# Write your PowerShell commands here.
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - -'
Write-Host ' reflect Azure Devops repo changes to GitHub repo'
Write-Host ' - - - - - - - - - - - - - - - - - - - - - - - - - '
$stageDir = pwd | split-path
$githubDir = $stageDir +"\"+"gitHub"
$destination = $githubDir +"\"+"test.git"
#please provide your username
$alias = ${env:GITHUB}
#Please make sure, you remove https from azure-repo-clone-url
$sourceURL = ("https://{0}@dev.azure.com/juangarridocaballero/test/_git/test" -f ${env:TOKEN})
#Please make sure, you remove https from github-repo-clone-url
$destURL = 'https://' + $alias + '@github.com/silverhack/testdevops.git'
#Check if the parent directory exists and delete
if((Test-Path -path $githubDir))
{
  Remove-Item -Path $githubDir -Recurse -force
}
if(!(Test-Path -path $githubDir))
{
  New-Item -ItemType directory -Path $githubDir
  Set-Location $githubDir
  git clone --mirror $sourceURL
}
else
{
  Write-Host "The given folder path $githubDir already exists";
}
Set-Location $destination
git config --unset core.bare
Write-Output '*****Git removing remote secondary****'
git remote rm secondary
Write-Output '*****Git remote add****'
git remote add --mirror=fetch secondary $destURL
git pull https://github.com/silverhack/testdevops.git
git remote prune $sourceUrl
Write-Output '*****Git fetch origin****'
git fetch $sourceURL
Write-Output '*****Git push secondary****'
git push secondary --all -f
Write-Output '**Azure Devops repo synced with Github repo**'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
 Remove-Item -Path $githubDir -Recurse -force
}