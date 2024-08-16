output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "sql_server_pool_name" {
  value = azurerm_mssql_elasticpool.sql_pool.name
}
