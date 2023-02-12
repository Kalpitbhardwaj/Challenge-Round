$vmInfo = Invoke-RestMethod -Headers @{"Metadata" = "true" } -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01"
$vmInfo.compute.subscriptionId
$vmInfo.compute.resourceGroupName
$vmInfo.compute.name
