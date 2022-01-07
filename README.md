# Terraform

## Installation

**Arch Linux**
- `yay -S terraform`

## Prerequisites 

Adding two environment variables to the .bashrc

- `AWS_ACCESS_KEY_ID=<insert_key_here>`
- `AWS_SECRET_ACCESS_KEY=<insert_key_here>`
- `source ~/.bashrc`

### Establish a working environment

- Make a main.tf
- variable.tf for all the variables

### Useful commands

`terraform init` for the initialisation
`terraform plan` for a syntax check
`terraform apply` to apply all the changes
`terraform destroy` to destroy all changes made by terraform


