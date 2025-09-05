 variable "project" {
     default = "roboshop"
 }

 variable "environment" {
     default = "dev"
 }

 variable "images" {
     default = [ "user", "cart", "shipping", "payment", "frontend"]
 }