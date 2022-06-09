variable "instance_name" {
  description =  "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ohio_instance"
}

variable "instance_name_london" {
  description =  "Value of the Name tag for the London EC2 instance"
  type        = string
  default     = "london_instance"
}