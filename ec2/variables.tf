variable "security_group_id" {}
variable "key_name" {}
variable "instance_type" {}
variable "AMI" {}
variable "port_numbers" {
    #type = number
}
variable "number_of_instances" {}
variable "load_balancing_algorithm_type" {}
variable "ec2_lbname" {}
variable "ec2_target_group" {}
variable "ec2_sg" {}