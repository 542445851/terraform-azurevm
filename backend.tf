terraform {
  backend "azurerm" {
    storage_account_name = "demotfstatedevstorage"
    container_name = "devcontainer"
    key = "dev.terrafrom.tfstate"
    
  }
}
