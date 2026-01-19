variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "number_of_instances" {
  description = "The number of EC2 instances to create."
  type        = number
  default     = 2
}

variable "list_example" {
  description = "An example list variable."
  type        = list(string)
  default     = ["item1", "item2", "item3"]
}

variable "list_numeric" {
  description = "An example list of numbers."
  type        = list(number)
  default     = [10, 20, 30]
}

variable "map_example" {
  description = "An example map variable."
  type        = map(string)
  default = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value"
  }
}

variable "map_numeric" {
  description = "An example map of numbers."
  type        = map(number)
  default = {
    key1 = 100
    key2 = 200
    key3 = 300
  }
}


variable "object_example" {
  description = "An example object variable."
  type = object({
    name     = string
    age      = number
    is_admin = bool
  })
  default = {
    name     = "John Doe"
    age      = 30
    is_admin = false
  }
}

variable "set_example" {
  description = "An example set variable."
  type        = set(string)
  default     = ["set_item1", "set_item2", "set_item3"]
}

variable "boolean_example" {
  description = "An example boolean variable."
  type        = bool
  default     = true
}

variable "string_example" {
  description = "An example string variable."
  type        = string
  default     = "Hello, Terraform!"
}

variable "number_example" {
  description = "An example number variable."
  type        = number
  default     = 42
}

variable "complex_object" {
  description = "An example of a complex object variable."
  type = object({
    id   = number
    tags = map(string)
    addresses = list(object({
      street = string
      city   = string
      zip    = number
    }))
  })
  default = {
    id = 1
    tags = {
      environment = "dev"
      project     = "terraform"
    }
    addresses = [
      {
        street = "123 Main St"
        city   = "Anytown"
        zip    = 12345
      },
      {
        street = "456 Side St"
        city   = "Othertown"
        zip    = 67890
      }
    ]
  }
}

variable "tuple_example" {
  description = "An example tuple variable."
  type        = tuple([string, number, bool])
  default     = ["tuple_string", 100, true]
}