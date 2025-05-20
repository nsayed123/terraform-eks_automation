resource "kubernetes_secret" "postgres_admin" {
  metadata {
    name = "postgres-admin-secret"
  }


  data = {
    postgres_username = base64encode(var.postgres_secret_username)
    postgres_password = base64encode(var.postgres_secret_password)
    postgres_host = base64encode(var.postgres_host)
    
  }
}

resource "kubernetes_job" "create_superset_db" {
  metadata {
    name = "create-superset-db"
  }

  spec {
    template {
      metadata {
        labels = {
          job = "create-superset-db"
        }
      }

      spec {
        restart_policy = "OnFailure"

        container {
          name  = "psql"
          image = "postgres:15"

          env {
            name = "POSTGRES_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_admin.metadata[0].name
                key  = "postgres_host"
              }
            }
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_admin.metadata[0].name
                key  = "postgres_username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_admin.metadata[0].name
                key  = "postgres_password"
              }
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.postgres_admin.metadata[0].name
            }
          }

          command = ["/bin/sh", "-c"]
          args = [
            "export PGPASSWORD=$POSTGRES_PASSWORD; psql -h $POSTGRES_HOST -U $POSTGRES_USER -d postgres -c \"CREATE DATABASE superset\""
          ]
        }
      }
    }
  }
}
