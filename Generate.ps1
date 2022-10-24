$FolderStructure = ".\FolderStructure"
$directoryIcon = "📁"
$fileIcon = "📄"
$crossing = "┣"
$line = "┃"
$end = "┗"

$output = "";

function GetContent() {
    param(
        [string]$pre,
        [string]$path
    )
    [Object[]]$items = Get-ChildItem $path
    $i = 0
    $output = ""
    foreach($item in $items) {
        $i++

        if(isDirectory($item)){
            if($items.Length -eq $i){
                $output += "$pre$end$directoryIcon $($item.Name)`n"
                $output += GetContent "$pre " $item.FullName
            }
            else {
                $output += "$pre$crossing$directoryIcon $($item.Name)`n"
                $output += GetContent "$pre$line" $item.FullName
            }
        }
        else {
            if($items.Length -eq $i){
                $output += "$pre$end$(getIcon($item.Name)) $($item.Name)`n"
            }
            else {
                $output += "$pre$crossing$(getIcon($item.Name)) $($item.Name)`n"
            }
        }
    }
    return $output
}

function isDirectory{
    param(
        $item
    )

    return $item.Mode.StartsWith("d")
}

function getIcon{
    param(
        $name
    )

    $a = switch -Wildcard ($name) {
        "*.jpg"
            {"🖼️"}
        "*.jpeg"
            {"🖼️"}
        "*.svg"
            {"🖼️"}
        "*.gif"
            {"🖼️"}
        "*.png" 
            {"🖼️"}

        default
            {"📄"}
    }
    return $a
}

if(!(Test-Path .\out)) {mkdir .\out}

$output = GetContent "" $FolderStructure

$now = Get-Date -Format "yyyyMMdd_HHmmss"

Out-File -FilePath .\out\$now.txt -InputObject $output