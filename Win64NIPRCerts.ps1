<#
This script is for doing a temp download and certificate update of installroot on x64 windows.
-Crowson
#>

#file download
echo "file download"
$TempDir   =  "$env:TEMP" + "\postinstall"
$TempFile  =  "$TempDir" + "\InstallRoot_5.5x64.msi"
rmdir -Path $TempDir -Recurse -Force
mkdir $TempDir -Force

Invoke-WebRequest -Uri https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/msi/InstallRoot_5.5x64.msi -OutFile $TempFile

#install
echo "install"
pushd $TempDir
cmd.exe /C "Msiexec /package InstallRoot_5.5x64.msi /passive /norestart"
popd

#update certs
echo "update certs"
& "C:\Program Files\DoD-PKE\InstallRoot\InstallRoot.exe" --update
& "C:\Program Files\DoD-PKE\InstallRoot\InstallRoot.exe" --insert

#uninstall
echo "uninstall"
pushd $TempDir
cmd.exe /C "Msiexec /uninstall InstallRoot_5.5x64.msi /passive"
popd

#delete temp files
echo "delete temp files"
sleep -Seconds 3
rmdir -Path $TempDir -Recurse -Force

powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('This script updates the windows certificate store. To force firefox to pull from the windows store type about:config like you would a normal website into the firefox browser, accept the security prompt, search for security.enterprise_roots.enabled, and change the value from False to True.','WARNING')}"
