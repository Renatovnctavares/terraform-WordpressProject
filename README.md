# Wordpress Project 

Scripts HCL to create AWS environment with:

 + VPC HML
  ++ Peering default
 + RDS
  ++ MySQL instance
  ++ Security Group
 + EC2
  ++ KEY
  ++ Security Group
  ++ EC2 Instance (t2.micro)
   +++ Docker Server
    ++++ Wordpress image
 + ELB
  ++ Security Group
 


Minimal requeriments:
 + git 2.17.2 
 + terraform v0.11.13
 + AWS account 

Output Script:
 + URL  : Access wordpress URL LoadBalance.
 + FILE : Key.pem

##step 1

  git clone https://github.com/Renatovnctavares/terraform-WordpressProject.git



