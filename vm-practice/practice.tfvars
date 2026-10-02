### tfvars ###
resource_group_name = "rg-practice-lab"
location            = "Central India"
admin_user          = "azureadmin"

vm_sizes = {
  web = "Standard_B2ats_v2"
  db  = "Standard_B2ats_v2"
  app = "Standard_B2ats_v2"
}
