<#
This script is for doing a temp download and certificate update of installroot on x64 window.
-Crowson
#>

#file download
echo "file download"
$TempDir   =  "$env:TEMP" + "\postinstall"
$TempFile  =  "$TempDir" + "\InstallRoot_5.5x64.msi"
rmdir -Path $TempDir -Recurse -Force
mkdir $TempDir -Force

Invoke-WebRequest -Uri https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/msi/InstallRoot_5.5x64.msi -OutFile $TempFile
if ($LASTEXITCODE -eq 0) {echo "success"} else {sleep 10}

#install
echo "install"
pushd $TempDir
powershell -Command "Msiexec /package InstallRoot_5.5x64.msi /passive /norestart"
if ($LASTEXITCODE -eq 0) {echo "success"} else {sleep 10}
popd

#update certs
echo "update certs"
& "C:\Program Files\DoD-PKE\InstallRoot\InstallRoot.exe" --update
if ($LASTEXITCODE -eq 0) {echo "success"} else {sleep 10}
& "C:\Program Files\DoD-PKE\InstallRoot\InstallRoot.exe" --insert
if ($LASTEXITCODE -eq 0) {echo "success"} else {sleep 10}

#uninstall
echo "uninstall"
pushd $TempDir
powershell -Command "Msiexec /uninstall InstallRoot_5.5x64.msi /quiet"
if ($LASTEXITCODE -eq 0) {echo "success"} else {sleep 10}
popd

#delete temp files
echo "delete temp files"
sleep -Seconds 10
rmdir -Path $TempDir -Recurse -Force
