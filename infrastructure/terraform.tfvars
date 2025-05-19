key_name            = "ap-south-1"
bastion_allowed_ips = ["117.205.133.239/32"]
# db_username = "value"
db_secret_name = "postgres_credentials"
# superset_secret = "superset_secret"


network_tfstate_bucket  = "my-terraform-state-bucket-apsouth1"
network_tfstate_key     = "networking/tst/terraform.tfstate"
network_tfstate_region  = "ap-south-1"
network_tfstate_profile = "poc"