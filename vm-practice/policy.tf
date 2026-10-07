resource "azurerm_policy_definition" "require_environment_tag" {
  name         = "require-environment-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Add Environment tag"
  description  = "Adds the required Azure policy tags when they are missing."

  policy_rule = <<POLICY
{
  "if": {
    "anyOf": [
      {
        "field": "tags['Environment']",
        "exists": "false"
      },
      {
        "field": "tags['PolicyManaged']",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "modify",
    "details": {
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"
      ],
      "operations": [
        {
          "operation": "add",
          "field": "tags['Environment']",
          "value": "Dev"
        },
        {
          "operation": "add",
          "field": "tags['PolicyManaged']",
          "value": "Yes"
        }
      ]
    }
  }
}
POLICY
}

resource "azurerm_resource_group_policy_assignment" "environment_tag" {
  name                 = "environment-tag-assignment"
  resource_group_id    = azurerm_resource_group.rg.id
  location             = azurerm_resource_group.rg.location
  policy_definition_id = azurerm_policy_definition.require_environment_tag.id
  display_name         = "Add Environment tag"
  description          = "Adds Environment=Dev to resources that do not have the tag."

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "policy_modify" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_resource_group_policy_assignment.environment_tag.identity[0].principal_id
}
