reading time- number of words divided by 250. Eg. 6 min read)


I like lists. Specifically, [generic lists](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=netcore-3.0)
in .Net. They are so fast and versatile. And when you combine them with a
[custom class](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_classes?view=powershell-5.1), things really get interesting!

&nbsp;

**The problem**

I had a need to enumerate and compare various properties of two sources. I
enumerated these two sources into two separate lists. Each list contained items
with a unique key and some individual properties. I needed to merge them
together and compare properties on each.

Now in order to merge one list into another, you have to first see if that
item already exists in the target list, then if it exists, retrieve that item in order to update it.

Let’s look at some code;
``` powershell
    foreach ($Item in $List) {
        $result = $List2.where( { $_ -eq $Item })
        if ($result) {
            #do something
        }
    }
```

This is fine. Except when your lists get **big**. If we do a measure-command,
we see a problem; on a list of 45000 items it takes over 173ms **per operation**. it could take well over 2 hours to iterate through the code snippet above.

``` powershell
Measure-Command {$result = $List2.where( { $_ -eq $List[500] })}

Milliseconds      : 178
Ticks             : 1787943
TotalDays         : 2.06937847222222E-06
TotalHours        : 4.96650833333333E-05
TotalMinutes      : 0.002979905
TotalSeconds      : 0.1787943
TotalMilliseconds : 178.7943
```

**Optimisation**

I won’t touch on parallel tasks in this post (however I do use them). Let’s
just look at ways we can optimise our code.

_Contains_

Contains is fast. It can search a very large list quickly and simply returns
a boolean if it finds the item. We can use this to initially test whether we
even need to merge this item into an existing object, or simply create a new
one and append to the list.
``` powershell
    foreach ($Item in $List) {
        #Check if the item already exists in the list
        if ($List.Contains($Item)) {
            $result = $List2.where( { $_ -eq $Item })
            if ($result) {
                #do something
            }
        }
    }
```

Ok. So this helps whenever there is a new item to add, but its still
expensive to merge an object. In my case 90% of items required merging. More
work was required.

There are a more than a few ways to find an item in your list.

* [Foreach](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-6) (or foreach-object)

* [Where method](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.where?view=netframework-4.8) (ienumerable)

* [Find method](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.find?view=netframework-4.8) (list)

I normally prefer using the where method, however after much testing I
have found that in specific circumstances (and especially where you are only looking for the first result) the Find method can be faster;

Let’s look at some code:

``` powershell
Measure-Command {$result = $List2.Find([Predicate[object]] { $args[0] -eq $List[500] })}

Milliseconds      : 23
Ticks             : 231468
TotalDays         : 2.67902777777778E-07
TotalHours        : 6.42966666666667E-06
TotalMinutes      : 0.00038578
TotalSeconds      : 0.0231468
TotalMilliseconds : 23.1468
```
You can see in this example, we were looking for an item 500 items in; in this case, Find will immediately stop searching once it finds the first result. _the where method will always search till the end_.

This works great! but it’s still too slow! When dealing with lists with
50000+ items this still takes forever...

**My solution**

**_Find-ListItem_** was what I came up with. I combined
the benefits of **contains** &amp; **where** to try and search the
smallest number of items in order to locate the item I need.

Design overview:

Simply put I break the list into 4 sections, do a contains on each section and only perform a where on the subset where the contains returns true.

I've optimised this search pattern by checking the first quarter of the list, then the last,
working its way towards the middle. This drastically decreases the
time. Lets see some speed tests:

``` powershell
Measure-Command { $WhereItem = $List.where( { $_ -eq "$($List[45000])" }) }


Milliseconds      : 535
Ticks             : 5351268
TotalDays         : 6.19359722222222E-06
TotalHours        : 0.000148646333333333
TotalMinutes      : 0.00891878
TotalSeconds      : 0.5351268
TotalMilliseconds : 535.1268

Measure-Command { $FastItem = Find-ListItem -Verbose -List $List -SearchString "$($List[45000])" }
VERBOSE: START: Locating b1b11d1c-7998-4dbb-85ca-a4e764adc033 in List
VERBOSE: FINISH: Locating b1b11d1c-7998-4dbb-85ca-a4e764adc033 in List.

Milliseconds      : 420
Ticks             : 4200509
TotalDays         : 4.86170023148148E-06
TotalHours        : 0.000116680805555556
TotalMinutes      : 0.00700084833333333
TotalSeconds      : 0.4200509
TotalMilliseconds : 420.0509


```

Much better!

I have plans to improve this code to allow the number of sections to be
adjustable, and potentially slightly alter the search order to even better
optimise it.

_I had previously used Find in this code, but after even more testing I found the newer where method actually traverses the list at a faster rate than Find, so when we breakdown the list into smaller pieces we actually on average gain speed compared to Find._

Feel free to take a look and use the function as you see fit.

[https://github.com/opensequence/Find-ListItem](https://github.com/opensequence/Find-ListItem)