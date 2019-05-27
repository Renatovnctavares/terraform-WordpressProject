provider "aws" {
  region = "ap-southeast-2"
}

variable "region"{
 default = "ap-southeast-2"
}

variable "amiawsid"{
 description = "AMI ID aws free tier Sydney"
 default = "ami-0fb7513bcdc525c3b"
}

variable "webapp_db_user" {
  description = "Database user"
  default = "wordpresshml"
}

variable "webapp_db_name" {
  description = "Database name"
  default = "wordpresshml"
}


variable "webapp_db_password" {
 description = "Password for your DataBase"
 default = "password"
}

variable "webapp_db_engine" {
  default = "mysql"
}

variable "webapp_db_engine_version" {
  default = "5.7"
}

variable "webapp_db_instance_class" {
  default = "db.t2.micro"
}

variable "webapp_db_size" {
  default     = 5
}

