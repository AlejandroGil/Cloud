ForEach ($vault in $(Get-AzureRmRecoveryServicesVault)) {
    # set vault context
    Get-AzureRmRecoveryServicesVault -Name $vault.Name | Set-AzureRmRecoveryServicesVaultContext
    # step through all jobs found
    ForEach ($job in $(Get-AzureRmRecoveryservicesBackupJob)) {
                                               if ($job.Status -eq "Failed") {
        write-host " *" $Vault.Name "Backup failed for :" $job.WorkloadName -foregroundcolor "red"
        $confirmation = Read-Host "   -> Re-run backup job y/n "
        if ($confirmation -eq "y") {
          $item = Get-AzureRmRecoveryServicesBackupItem -BackupManagementType AzureVM -Name $job.WorkloadName -WorkloadType AzureVM
          $backup = Backup-AzureRmRecoveryServicesBackupItem -Item $item
          write-host "   -> Backup job re-run for :" $job.WorkloadName -foregroundcolor "green"
        }
      }
    }
}
