locals {
  list_of_items = ["foo", "bar", "test"]
  map_of_keys = {
    "apple"  = 1
    "banana" = 2
    "citrus" = 3
  }

  set_product_enumeration = [for item in setproduct(keys(local.map_of_keys), local.list_of_items) : join(".", item)]
}

output "set_product" {
  value = local.set_product_enumeration
}