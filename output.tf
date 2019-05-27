#output "private_key" { 
#  value = "${tls_private_key.gereted_key.private_key_pem}"
#  description = "key gereted" 
#}
resource "local_file" "key" {
    content     = "${tls_private_key.gereted_key.private_key_pem}"
    filename = "key.pem"
}

output "LB-acess"{
  value ="${aws_elb.elb_wordpress.dns_name}"
  description = "URL acessos wordpress"
}
