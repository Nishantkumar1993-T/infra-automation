module "resource_group" {
  source                  = "../Modules/azurem_resource_group"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
}

module "resource_group" {
  source                  = "../Modules/azurem_resource_group"
  resource_group_name     = "test-rg2"
  resource_group_location = "Australia East"
}

# kya baat hai bhai kitne RG add krega
# main branch leni thi main kuch b dalra tha
module "resource_group" {
  source                  = "../Modules/azurem_resource_group"
  resource_group_name     = "test-rg3"
  resource_group_location = "Australia East"
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../Modules/azurem_virtual_network"
  virtual_network_name     = "test-vnet"
  virtual_network_location = "Australia East"
  resource_group_name      = "test-rg"
  address_space            = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Modules/azurem_Subnet"
  virtual_network_name = "test-vnet"
  resource_group_name  = "test-rg"
  subnet_name          = "fro-test-subnet"
  address_prefixes     = ["10.0.1.0/24"]
}

module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../Modules/azurem_Subnet"
  virtual_network_name = "test-vnet"
  resource_group_name  = "test-rg"
  subnet_name          = "bac-test-subnet"
  address_prefixes     = ["10.0.2.0/24"]
}

module "pip_frontened" {
  source                  = "../Modules/azurem_public_ip"
  pip_name                = "test_pip_frontend"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
  allocation_method       = "Static"
}
module "pip_backend" {
  source                  = "../Modules/azurem_public_ip"
  pip_name                = "test_pip_backend"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
  allocation_method       = "Static"
}

module "frontend_vm" {
  depends_on              = [module.frontend_subnet]
  source                  = "../Modules/azurem_virtual_machine"
  nic_name                = "test-frontened-nic"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
  vm_name                 = "test-frontend-vm"
  username                = "usernishu"
  password                = "Nishant@2025"
  image_publisher         = "Canonical"
  image_offer             = "0001-com-ubuntu-server-jammy"
  sku                     = "22_04-lts"
  subnet_name             = "fro-test-subnet"
  virtual_network_name    = "test-vnet"
  pip_name                = "test_pip_frontend"
}
module "backend_vm" {
  depends_on              = [module.backend_subnet]
  source                  = "../Modules/azurem_virtual_machine"
  nic_name                = "test-backend-nic"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
  vm_name                 = "test-backend-vm"
  username                = "usernishu"
  password                = "Nishant@2025"
  image_publisher         = "Canonical"
  image_offer             = "0001-com-ubuntu-server-jammy"
  sku                     = "22_04-lts"
  subnet_name             = "bac-test-subnet"
  virtual_network_name    = "test-vnet"
  pip_name                = "test_pip_backend"
}

module "sqlserver" {
  source                  = "../Modules/azurem_sql_server"
  sqlserver_name          = "test-sqlserver07"
  resource_group_name     = "test-rg"
  resource_group_location = "Australia East"
  admin_username          = "usersql"
  admin_password          = "Nishant@2025"
}

module "sqldatabase" {
  source        = "../Modules/azurem_sql_database"
  database_name = "practise-database"
  server_id     = "/subscriptions/34efc0a7-8590-4931-b801-1a4f91725596/resourceGroups/test-rg/providers/Microsoft.Sql/servers/test-sqlserver07"
}
