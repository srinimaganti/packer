Set-ExecutionPolicy bypass
$path = Z:
$softwares = import-csv "Z:\packages.csv" -Delimiter "," -Header 'Installer','Switch'

foreach ( $software in $softwares ) 
{
    $softexec = $software.Installer
    $softexec = $softexec.ToString()
    $pkgs = Get-ChildItem $path$softexec | Where-Object {$_.Name -eq $softexec}
      
      foreach ($pkg in $pkgs)
      {
        $ext = [System.IO.Path]::GetExtension($pkg)
        $ext = $ext.ToLower()

        $switch = $software.Switch
        $switch = $switch.ToString()

        if($ext -eq ".msi")
        {
          mkdir C:\Temp\softwares  -Force
          Copy-Item "$path$softexec" -Recurse C:\Temp\softwares -Force
          Write-host "Installing $softexec silently, Please wait......" -foregroundColor Yellow
          Start-Process "C:\Temp\Softwares\$softexec" -ArgumentList "$switch"  -wait

          Remove-item "C:\Temp\Softwares\$softexec" -Recurse -Force
          Write-host "Installation of $softexec Completed" -foregroundColor Green
        }
        else {
            mkdir C:\Temp\softwares  -Force
            Copy-Item "$path$softexec" -Recurse C:\Temp\softwares -Force
            Write-host "Installing $softexec silently, Please wait......" -foregroundColor Yellow
            Start-Process "C:\Temp\Softwares\$softexec" -ArgumentList "$switch"  -wait -NoNewWindow

            Remove-item "C:\Temp\Softwares\$softexec" -Recurse -Force
            Write-host "Installation of $softexec Completed" -foregroundColor Green
        }

      }

}
net use Z: /delete /yes
