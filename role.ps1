#Crear rol a partir de otro, añadiendo funcionalidad
Add-AzureRmAccount

$role = Get-AzureRmRoleDefinition "Indra owner"

#Hacer el rol asignable a cualquier suscripcion
#Get-AzureSubscription | ForEach {$role.AssignableScopes.Remove("/subscriptions/" + $_.SubscriptionId)}
$role.AssignableScopes.Remove("/subscriptions/xxx")
Set-AzureRmRoleDefinition -Role $role

# Eliminar rol
#Get-AzureRmRoleDefinition "testRole2" | Remove-AzureRmRoleDefinition

#Set-AzureRmContext -SubscriptionId 80cbc269-663d-4f72-8631-aeaa2d9c8d1d

#$role.AssignableScopes.Remove("/subscriptions/551bf97e-12fe-4f58-bf36-53a03a38f0f4")