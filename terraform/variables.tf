variable "resource_group_location" {
    type = string
    default = "eastus"
    description="Location of the resource group"
}

variable "resource_group_name_prefix" {
    type = string
    default = "rg"
    description="Prefix of resource group that's combined with random ID so name is unique in azure subscription"
}