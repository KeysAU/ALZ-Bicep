

$inputObject = @{
  DeploymentName        = 'alz-MGDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'australiaeast'
  TemplateFile          = 'infra-as-code/bicep/modules/managementGroups/managementGroups.bicep'
  TemplateParameterFile = 'infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.all.json'
}
New-AzTenantDeployment @inputObject


# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-PolicyDefsDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'australiaeast'
  ManagementGroupId     = 'global'
  TemplateFile          = 'infra-as-code/bicep/modules/policy/definitions/customPolicyDefinitions.bicep'
  TemplateParameterFile = 'infra-as-code/bicep/modules/policy/definitions/parameters/customPolicyDefinitions.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject


# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-alzPolicyAssignmentDefaultsDeployment-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'australiaeast'
  ManagementGroupId     = 'alz'
  TemplateFile          = 'infra-as-code/bicep/modules/policy/assignments/alzDefaults/alzDefaultPolicyAssignments.bicep'
  TemplateParameterFile = 'infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject


# For Azure global regions

$inputObject = @{
  DeploymentName        = 'alz-PolicyDenyAssignments-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  ManagementGroupId     = 'alz-landingzones'
  Location              = 'australiaeast'
  TemplateParameterFile = 'infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.deny.parameters.all.json'
  TemplateFile          = 'infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep'
}
New-AzManagementGroupDeployment @inputObject


$inputObject = @{
  DeploymentName        = 'alz-PolicyDineAssignments-{0}' -f ( -join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
  Location              = 'australiaeast'
  ManagementGroupId     = 'alz-landingzones'
  TemplateFile          = 'infra-as-code/bicep/modules/policy/assignments/policyAssignmentManagementGroup.bicep'
  TemplateParameterFile = '@infra-as-code/bicep/modules/policy/assignments/parameters/policyAssignmentManagementGroup.dine.parameters.all.json'
}

New-AzManagementGroupDeployment @inputObject



# Create the install folder
$installPath = "$env:USERPROFILE\.bicep"
$installDir = New-Item -ItemType Directory -Path $installPath -Force
$installDir.Attributes += 'Hidden'
# Fetch the latest Bicep CLI binary
(New-Object Net.WebClient).DownloadFile('https://github.com/Azure/bicep/releases/latest/download/bicep-win-x64.exe', "$installPath\bicep.exe")
# Add bicep to your PATH
$currentPath = (Get-Item -Path 'HKCU:\Environment' ).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
if (-not $currentPath.Contains('%USERPROFILE%\.bicep')) { setx PATH ($currentPath + ';%USERPROFILE%\.bicep') }
if (-not $env:path.Contains($installPath)) { $env:path += ";$installPath" }
# Verify you can now access the 'bicep' command.
bicep --help
# Done!

New-AzRoleAssignment -SignInName 'keithwaterman333@keithwaterman333gmail.onmicrosoft.com' -Scope '/' -RoleDefinitionName 'Owner'



