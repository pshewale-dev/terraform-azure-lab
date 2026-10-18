### tfvars ###
resource_group_name = "rg-practice-lab"
location            = "Central India"
admin_user          = "azureadmin"

vm_sizes = {
  web = "Standard_B2ats_v2"
  db  = "Standard_B2ats_v2"
  app = "Standard_B2ats_v2"
}
nsg_rules = {
  ssh = {
    name      = "allow-ssh"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"
    port      = "22"
  }

  http = {
    name      = "allow-http"
    priority  = 110
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"
    port      = "80"
  }

  https = {
    name      = "allow-https"
    priority  = 120
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"
    port      = "443"
  }

}
alert_email        = "pshewale1212@gmail.com"
automation_account = "aa-practice-lab"