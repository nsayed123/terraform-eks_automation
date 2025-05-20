### Providers Config
aws_profile = "poc"
aws_region  = "ap-south-1"


network_tfstate_bucket  = "my-terraform-state-bucket-apsouth1"
network_tfstate_key     = "networking/tst/terraform.tfstate"
network_tfstate_region  = "ap-south-1"
network_tfstate_profile = "poc"

eks_cluster_name    = "tst-eks"
eks_ng_desired_size = 2
eks_ng_min_size     = 1
eks_ng_max_size     = 4
key_name            = "ap-south-1"

# db_username = "value"
rds_cluster_name = "myappdb"
db_secret_name   = "postgres_credentials"
# superset_secret = "superset_secret"

dns_zone_name       = "tst-cs.tek.xyz"
dns_public_hostname = "superset.tst-cs.tek.xyz"


### Superset application
domain_name = "superset.dev.tekioncloud.xyz"
ingress_class = "public"
tls_secret_name = "superset-tls"
cluster_issuer = "letsencrypt"