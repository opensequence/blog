#3000 Items

$List = [System.Collections.Generic.List[string]]::New()
$List2 = [System.Collections.Generic.List[string]]::New()

$numberfitems = 3000
while ($count -le $numberfitems) {
    $null = $List.Add((New-Guid).Guid)
    $count++
}
$null = $List2.AddRange($List)

# Execute
Measure-Command {
    foreach ($Item in $List) {
        $result = $List2.where( { $_ -eq $Item })
        if ($result) {
            #do something
        }
    }
}

Measure-Command {
    foreach ($Item in $List) {
        $result = $List2.Find([Predicate[object]] { $args[0] -eq $Item })
        if ($result) {
            #do something
        }
    }
}