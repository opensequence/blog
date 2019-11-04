#Create List of strings
$List = [System.Collections.Generic.List[string]]::New()
$List2 = [System.Collections.Generic.List[string]]::New()

$numberfitems = 500
while ($count -le $numberfitems) {
    $null = $List.Add((New-Guid).Guid)
    $count++
}
$null = $List2.AddRange($List)

# Execute
Measure-Command {
    foreach ($Item in $List) {
        $result = $List.where( { $_ -eq $Item })
        if ($result) {
            #do something
        }
    }
}

