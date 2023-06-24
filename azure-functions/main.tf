resource "azurerm_resource_group" "example" {
  name     = var.resource-group-name
  location = var.resource-group-location
}

resource "azurerm_storage_account" "example" {
  name                     = var.storage_account-name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.storage_account-account_tier
  account_replication_type = var.storage_account-replication_type
}


resource "azurerm_app_service_plan" "example" {
  location            = azurerm_resource_group.example.location
  name                = var.app_service_plan-name
  resource_group_name = azurerm_resource_group.example.name
  sku {
    size = var.app_service_plan-sku-size
    tier = var.app_service_plan-sku-tier
  }
}

resource "azurerm_linux_function_app" "example" {
  location            = azurerm_resource_group.example.location
  name                = var.linux_function_app-name
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_app_service_plan.example.id
  site_config {}
}

resource "azurerm_function_app_function" "example" {
    config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "function"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "req"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "$return"
        "type"      = "http"
      },
    ]
  })
  function_app_id = azurerm_linux_function_app.example.id
  name            = var.function_app_function-name
