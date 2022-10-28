##### Region #####
region = "ap-south-1"

##### lables #####
environment = "shared"
label_order = ["name", "environment"]

##### networking #####
vpc_cidr_block                  = "10.30.0.0/16"
availability_zones              = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
type                            = "public-private"
assign_ipv6_address_on_creation = false


##### Ec2 ####
ec2_ami           = "ami-062df10d14676e201"
ec2_instance_type = "t3.medium"
public_key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIH7wEH57EUFPEw4G0oYoUUIiYs2vc4iXtgxV0T4CwUuUIOFIXL3kvssodT8ftw2yk+F9hLI2CKm4KFIEOmIIxO2m1xQwrDWRUefeg6Ppi2pcKXQ608f2NSVSVBACoEcaL2RazvvXGSQY1vY7k+Fn00o/J6u+PUw1BA8k/5rkeQUZfmeM44WQSrn4+HDTpkCDw2sqRoNMBZwfE2ngHHY836tlk5qmYkMI32BgeG9lG8Jv3cWYriSIrpOauOjKjlUXsPG70i4w02hRu3R5WWkeN0lQnjoFxsPt/oNAzmgimMkMCxa7HKCawoboUxIT65zSOv8dSnJiiXMtPfOisJXzstZALIV16+ZXskXy1he8VHt3cSTts9CBNjX40d3cmSwwCDT2C3IAzKitSu73WyWQOPG7NaYr/Op0a6lQMsz0E+sqByh28djTZEZf/H4TtHPixdCCO0GEppB5kDOdqGkYJFKPN/DzVxRKayaTpHaeEaHdK9guZms8Csl+tWVgGF55k83vFN4Ok1KXni2vkM0Qzjt47EEuD3Y7Jk3d3btVF68Zy5PD1i6L+ecnxmL++lVKZ82ke/OFJYSDacVfobZ7veA1NxoOtraWI4cA+0vTlUWhedkRXfGKjELwFJCqrw/MVg8xWSkpNWF9tqcST9Gxk0m6oKWicYq0Tp8/Bq00Y1w== vaibhav-shared"