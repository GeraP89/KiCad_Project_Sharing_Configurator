
<#Este script tiene la intencion de acomodar todos los archivos necesarios para KiCAD cuando nos compartimos archivos 
.zip por cualquier metodo. Nos ayudara a poner las librerias en donde deben ir, asi como los modulos tambien.
Es necesario reemplazar el archivo .zip siempre que haya una actualizacion, y siempre mantener el nombre como PIA.zip#>

$Folder = "C:\Users\$env:UserName\Documents\TDE\PIA";

$PCLibPath = "C:\Program Files\KiCad\share\kicad\library";
$PCModulePath = "C:\Program Files\KiCad\share\kicad\modules";

if (-not (Test-Path -LiteralPath $Folder)) {
    #Test para revisar si existe el folder especificado, en caso de que no, lo crea
    try {
        New-Item -Path $Folder -ItemType Directory -ErrorAction Stop | Out-Null;
    }
    catch {
        Write-Error -Message "Unable to create directory '$Folder'. Error was: $_" -ErrorAction Stop;
    }
    "Successfully created directory '$Folder'.";
}
else {
    "Directory already exists";
}

Expand-Archive -Path $PSScriptRoot\PIA.zip -DestinationPath $Folder -force;
#Expande el archivo PIA.zip en el destino mencionado en la variable $Folder

$Libs = Get-Childitem $Folder -Recurse -ErrorAction SilentlyContinue | where {$_.Extension -Match "lib"} | Select-Object @{Expression={($_.DirectoryName + "\" +$_.Name)};Label="Destination"};
#ubica todos los archivos con extension .lib en el destino de la variable $Folder y los selecciona como objetos para poder utilizarlos despues

ForEach($Object in $Libs){
   Copy-Item $Object.Destination -Destination $PCLibPath;
}
#Para cada objeto encontrado en la iteracion que se realizo para $Libs, los toma y los copia al destino nombrado en la variable $PCLibPath uno a uno

$Mods = Get-Childitem $Folder -Recurse -ErrorAction SilentlyContinue | where {$_.Extension -Match "pretty"} | Select-Object -Property FullName;
#ubica todos los archivos con extension .pretty en el destino de la variable $Folder y los selecciona como objetos para poder utilizarlos despues

ForEach($fldr in $Mods){
    Copy-Item $fldr.FullName $PCModulePath -ErrorAction SilentlyContinue;
}
#Para cada objeto encontrado en la iteracion que se realizo para $Mods, los toma y los copia al destino nombrado en la variable $PCModulePath uno a uno