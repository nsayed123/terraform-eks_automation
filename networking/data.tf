### To read the public IP of the machine
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

