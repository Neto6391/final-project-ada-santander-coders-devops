locals {
  subnet_newbits = 8  # Used for subnet CIDR calculations

  subnet_configs = [
    {
      tier        = "Public"
      public_ip   = true
      cidr_offset = 0
    },
    {
      tier        = "Private-App"
      public_ip   = false
      cidr_offset = 10
    },
    {
      tier        = "Private-DB"
      public_ip   = false
      cidr_offset = 20
    }
  ]
}