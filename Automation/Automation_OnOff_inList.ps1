workflow Shutdown-Start-VMs-By-Resource-Group
{
	Param
    (   
        [Parameter(Mandatory=$true)]
        [String]$AzureResourceGroup,
        [Parameter(Mandatory=$true)]
        [String]$Subscription,
		[Parameter(Mandatory=$true)]
        [Boolean]$Shutdown,
		#Input as array: [“Joe”,42,true]
		[Parameter(Mandatory=$true)]
        [String[]]$VMsList
    )
	
	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
    $CredentialAssetName = "DefaultAzureCredential";
	
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account   	
	Add-AzureRmAccount -Credential $Cred
	Add-AzureAccount -Credential $Cred

	if($Shutdown -eq $true){
		Write-Output "Stopping VMs in '$($AzureResourceGroup)' resource group";
	}
	else{
		Write-Output "Starting VMs in '$($AzureResourceGroup)' resource group";
	}
	
	#ARM VMs
	Write-Output "ARM VMs:";
	Select-AzureRmSubscription -SubscriptionName $Subscription

	Foreach ($VM in $VMsList){
		Write-Output "VM --- $VM";

            if($Shutdown -eq $true){
                
                Write-Output "Stopping $VM ...";
                #Stop-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $VM -Force;
            }
            else{
                Write-Output "Starting $VM ...";			
                #Start-AzureRmVM -ResourceGroupName $AzureResourceGroup -Name $VM;			
            }			
        };
    }
}