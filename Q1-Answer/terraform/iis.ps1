import-module servermanager
add-windowsfeature web-server -includeallsubfeature
add-windowsfeature Web-Asp-Net45
add-windowsfeature NET-Framework-Features
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "You are in the server $($env:computername)!"