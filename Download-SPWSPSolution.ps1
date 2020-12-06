# PowerShell script to download all Farm solutions in a SharePoint farm
# Author: Henderson Andrade
# Version: 1.1

# Get reference to SharePoint farm
$farm = Get-SPFarm

#Location to save the solution files
Write-Host " " 
Write-Host " " 
Write-Host "Download Path: " -NoNewLine -ForegroundColor Cyan
$loc = Read-Host
Write-Host " " 
Write-Host " "
$variable = get-spsolution
$variable_count = $variable.count

#Download all the solutions
$x=1

foreach($solution in $farm.Solutions){
$solution_name = $solution.name.ToUpper()

for ($i = 1; $i -le 100; $i++ ){
    write-progress -activity "Downloading Solution $x of $variable_count - $solution_name... $i%" -percentcomplete $i;
}

# Write-Host -ForegroundColor white "Saving solution: " $solution.Name " in folder $loc"
$solution = $farm.Solutions[$solution.Name]
$file = $solution.SolutionFile
$file.SaveAs($loc + '\' + $solution.Name)
$x++
}


Write-Host "Verbose: The solutions are downloaded in: $loc" -ForegroundColor yellow
$all_solutions = get-spsolution
$all_solutionsdeployed = get-spsolution | Where-Object{$_.Deployed -match "True"}
$all_solutionglobaldeployed = get-spsolution | Where-Object{$_.DeploymentState -eq "GlobalDeployed"}

Write-Host "Verbose: Number of Solutions: " $all_solutions.count -ForegroundColor yellow
Write-Host "Verbose: Number of Solutions Deployed in SharePoint farm: " $all_solutionsdeployed.count -ForegroundColor yellow
Write-Host "Verbose: Number of Global Solutions Deployed in SharePoint farm: " $all_solutionglobaldeployed.count -ForegroundColor yellow
Write-Host " "


Get-ChildItem $loc | Select-Object Name,LastWriteTime

