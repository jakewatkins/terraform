
variable "azRegion" {
    default = "centralus"
    description = "location where the resource is hosted"
}

variable "rgName" {
    default = "Sprinter"
    description = "name of the resource group"
}

variable "AvailabilitySetName" {
    default = "ASSprinter"
    description = "name of availability set"
}

variable "machineName" {
  default = "vmjkwWS20220609"
  description = "name of the vm"
}

variable "username" {
  default = "sysAdmin"
  description = "admin user name"
}

variable "workstation_ip" {
  type = string
  description = "Ip address for the local workstation that will access the vm once it has been created"
}