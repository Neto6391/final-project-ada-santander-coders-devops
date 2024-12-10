resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key     = var.hash_key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      read_capacity      = 5
      write_capacity     = 5
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.index
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection
      read_capacity      = 5
      write_capacity     = 5
    }
  }

  tags = {
    Environment = var.environment
    Name        = var.table_name
  }
}