$VMSS="xxx"
$RG="xxx"
$LB="xxx"
$PROBE="xxx"

az vmss show --name $VMSS --resource-group $RG --query upgradePolicy
az network lb probe show --resource-group $RG --lb-name $LB --name $PROBE --query id
az vmss update --name $VMSS --resource-group $RG --query virtualMachineProfile.networkProfile.healthProbe --set virtualMachineProfile.networkProfile.healthProbe.id='id-in-previous-step'
az vmss update-instances --name $VMSS --resource-group $RG --instance-ids *
az vmss update --name $VMSS --resource-group $RG --query upgradePolicy --set upgradePolicy.mode='Rolling'