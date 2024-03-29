#####################################################################################################################
#                                                                                                                   #
#                       KiCAD Proyect sharing configurator - Created by Gerardo P.                                  #
#                                                                                                                   #
#####################################################################################################################

<#"Este script tiene la intencion de acomodar todos los archivos necesarios para KiCAD cuando nos compartimos archivos 
.zip por cualquier metodo. Nos ayudara a poner las librerias en donde deben ir, asi como los modulos tambien.
Es necesario reemplazar el archivo .zip siempre que haya una actualizacion, y siempre mantener el nombre como PIA.zip"#>

$Folder = "C:\Users\$env:UserName\Documents\TDE\PIA";
$PCLibPath = "C:\Program Files\KiCad\share\kicad\library";
$PCModulePath = "C:\Program Files\KiCad\share\kicad\modules";
$mypath = split-path -parent $MyInvocation.MyCommand.Definition

#Test para revisar si existe el folder especificado, en caso de que no, lo crea
if (-not (Test-Path -LiteralPath $Folder)) {
    try {
        New-Item -Path $Folder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null -Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$Folder'. Error was: $_" -ErrorAction SilentlyContinue
    }
    "Successfully created directory '$Folder'."
}
else {
    "Directory already exists"
}

#Expande el archivo PIA.zip en el destino mencionado en la variable $Folder
Expand-Archive -Path $mypath\PIA.zip -DestinationPath $Folder -force

#ubica todos los archivos con extension .lib en el destino de la variable $Folder y los selecciona como objetos para poder utilizarlos despues
$Libs = Get-Childitem $Folder -Recurse -ErrorAction SilentlyContinue | where {$_.Extension -Match "lib"} | Select-Object @{Expression={($_.DirectoryName + "\" +$_.Name)};Label="Destination"}

#Para cada objeto encontrado en la iteracion que se realizo para $Libs, los toma y los copia al destino nombrado en la variable $PCLibPath uno a uno
ForEach($Object in $Libs){
   Copy-Item $Object.Destination -Destination $PCLibPath
}

#ubica todos los archivos con extension .pretty en el destino de la variable $Folder y los selecciona como objetos para poder utilizarlos despues
$Mods = Get-Childitem $Folder -Recurse -ErrorAction SilentlyContinue | where {$_.Extension -Match "pretty"} | Select-Object -Property FullName

#Para cada objeto encontrado en la iteracion que se realizo para $Mods, los toma y los copia al destino nombrado en la variable $PCModulePath uno a uno
ForEach($fldr in $Mods){
    Copy-Item $fldr.FullName $PCModulePath -ErrorAction SilentlyContinue
}
