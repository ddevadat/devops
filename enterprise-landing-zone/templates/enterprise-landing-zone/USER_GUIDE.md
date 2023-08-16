<!-- BEGIN_TF_DOCS -->
## Introduction

This is a ZERO workload landing zone template with any number of environments. 

## Process to add an Environment(s)

Open a Terminal at this folder and fire the below command to start creating your first environment.
```
./create-env.sh <Environment-Name> <Environment-Prefix>
```
For Example,
```
./create-env.sh PROD P
```
Where **PROD** is the environment name and **P** is the prefix for the environment.

It creates appropriate entries in **terraform.tfvars** file about this new environment.

Keep repeating the same for additional environments right away or at later point (during the day-2 change management).

## Process to delete an Environment
Open a Terminal at this folder and fire the below command to start deleting an environment.
```
./delete-env.sh <Environment-Name>
```
For Example,
```
./delete-env.sh UAT
```
Where **UAT** is the environment name.

It removes the relevant entries in **terraform.tfvars** file about this environment.

## Installation / Updation

Once all the required environments are created/deleted, one can chose the option of running the template in Oracle Resource Manager or in a local terminal.