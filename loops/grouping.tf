locals {
  # Inputs
  mapping_input = {
    "key1" = ["foo1", "10.1.2.3/32", "foo2"]
    "key2" = ["foo2"]
    "key3" = ["10.9.8.7/32"]
    "key4" = ["10.0.0.1/32","10.0.0.2/32"]
  }
  lookup_map = {
    "foo1" = ["10.1.1.1/32","10.2.2.2/32","10.3.3.3/32"]
    "foo2" = ["10.9.9.9/32","10.8.8.8/32","10.7.7.7/32"]
  }

  # Step 1 - Supporting variables
  mapping_input_keys = keys(local.mapping_input)
  lookup_map_keys    = keys(local.lookup_map)

  # Step 2 - Alias Enumeration
  alias_enumeration = merge([
    for key, list_value in local.mapping_input : {
      for item in list_value : key => lookup(local.lookup_map, item)... if contains(local.lookup_map_keys, item)
    }
  ]...)

  # Step 3 - CIDR Enumeration
  cidr_enumeration = merge([
    for key, list_value in local.mapping_input : {
      for item in list_value : key => item... if length(regexall("/", item)) > 0
    }
  ]...)

  # Step 4 - Expand aliases in input to list of CIDRs
  expanded_cidrs_for_map_input = {
    for key in local.mapping_input_keys : key => compact(concat(flatten(lookup(local.alias_enumeration,key,[])), lookup(local.cidr_enumeration, key, [])))
  }

  # Step 5 - Produce unique key value pairs for usage in for_each loops
  final_enumeration =  merge([
    for key, list_value in local.expanded_cidrs_for_map_input : {
      for item in list_value : "${key}_${item}" => item
    }
  ]...)
}

output "alias_enumeration" {
  value = local.alias_enumeration
}
/*
  alias_enumeration = {
    "key1" = [
      [
        "10.1.1.1/32",
        "10.2.2.2/32",
        "10.3.3.3/32",
      ],
      [
        "10.9.9.9/32",
        "10.8.8.8/32",
        "10.7.7.7/32",
      ],
    ]
    "key2" = [
      [
        "10.9.9.9/32",
        "10.8.8.8/32",
        "10.7.7.7/32",
      ],
    ]
  }
*/

output "cidr_enumeration" {
  value = local.cidr_enumeration
}
/*
  cidr_enumeration = {
    "key1" = [
      "10.1.2.3/32",
    ]
    "key3" = [
      "10.9.8.7/32",
    ]
    "key4" = [
      "10.0.0.1/32",
      "10.0.0.2/32",
    ]
  }
*/

output "expanded_cidrs_for_map_input" {
  value = local.expanded_cidrs_for_map_input
}
/*
  expanded_cidrs_for_map_input = {
    "key1" = tolist([
      "10.1.1.1/32",
      "10.2.2.2/32",
      "10.3.3.3/32",
      "10.9.9.9/32",
      "10.8.8.8/32",
      "10.7.7.7/32",
      "10.1.2.3/32",
    ])
    "key2" = tolist([
      "10.9.9.9/32",
      "10.8.8.8/32",
      "10.7.7.7/32",
    ])
    "key3" = tolist([
      "10.9.8.7/32",
    ])
    "key4" = tolist([
      "10.0.0.1/32",
      "10.0.0.2/32",
    ])
  }
*/

output "final_enumeration" {
  value = local.final_enumeration
}
/*
  final_enumeration = {
    "key1_10.1.1.1/32" = "10.1.1.1/32"
    "key1_10.1.2.3/32" = "10.1.2.3/32"
    "key1_10.2.2.2/32" = "10.2.2.2/32"
    "key1_10.3.3.3/32" = "10.3.3.3/32"
    "key1_10.7.7.7/32" = "10.7.7.7/32"
    "key1_10.8.8.8/32" = "10.8.8.8/32"
    "key1_10.9.9.9/32" = "10.9.9.9/32"
    "key2_10.7.7.7/32" = "10.7.7.7/32"
    "key2_10.8.8.8/32" = "10.8.8.8/32"
    "key2_10.9.9.9/32" = "10.9.9.9/32"
    "key3_10.9.8.7/32" = "10.9.8.7/32"
    "key4_10.0.0.1/32" = "10.0.0.1/32"
    "key4_10.0.0.2/32" = "10.0.0.2/32"
  }
*/