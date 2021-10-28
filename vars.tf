variable "REGION" {
  default = "ap-south-1"
}

variable "ZONE1" {
  default = "ap-south-1a"
}

variable "ZONE2" {
  default = "ap-south-1b"
}

variable "ZONE3" {
  default = "ap-south-1c"
}

variable "USER" {
  default = "ec2-user"
}

variable "PUB_KEY" {
  default = "dove-key.pub"
}

variable "AMIS" {
  type = map(any)
  default = {
    ap-south-1     = "ami-041d6256ed0f2061c"
    ap-northeast-2 = "ami-0e4a9ad2eb120e054"

  }
}
