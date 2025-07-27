terraform {
  backend "azurerm" {
    storage_account_name = "devstorage"
    container_name = "devcontainer"
    key = "dev.terrafrom.tfstate"
    
  }
}