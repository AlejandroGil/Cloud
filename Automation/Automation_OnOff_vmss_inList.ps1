workflow Shutdown-Start-VMSS-list{
	Param
    (   
        [Parameter(Mandatory=$true)]
        [String]$AzureResourceGroup,
        [Parameter(Mandatory=$true)]
        [String]$Subscription,
		[Parameter(Mandatory=$true)]
        [Boolean]$Shutdown,
		#Input as array: ["VMSS1","VMSS2","VMSS3"]
		[Parameter(Mandatory=$true)]
        [String[]]$VMSSNames
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
    
	if($Shutdown -eq $true){
		Write-Output "Stopping VMs in '$($AzureResourceGroup)' resource group";
	}
	else{
		Write-Output "Starting VMs in '$($AzureResourceGroup)' resource group";
	}
	
	#ARM VMSS
	Write-Output "ARM VMs:";
	Select-AzureRmSubscription -SubscriptionName $Subscription

	Foreach ($VMSS_name in $VMSSNames){
        $VMSS = Get-AzureRmVmssVM -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSS_name

        Foreach ($instance in $VMSS.instanceID){
            if($Shutdown -eq $true){
                Write-Output "Stopping instance $instance of $VMSS_name ...";
                #Stop-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSS -InstanceId $instance;
            }
            else{
                Write-Output "Starting instance $instance of $VMSS_name ...";			
                #Start-AzureRmVmss -ResourceGroupName $AzureResourceGroup -VMScaleSetName $VMSS -InstanceId $instance;		
            }	
        }	
    }
}