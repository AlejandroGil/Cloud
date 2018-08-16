# Config Coninuous Integration and Continuous Deployment in Jenkins
### Azure & Scaleset example

- Config Mulbranch pipeline
    - Checkout
    - Build
    - Save artifacts
    - if branch == DEV/PRO deploy sigle job
    - Deploy to VMSS (after single job)

- Config single job to deploy to config/test VM
    - Copy artifacts from multibranch
    - Deploy config
    - Deploy to VMSS?
