resource "helm_release" "superset" {
  name       = "mysuperset"
  repository = "https://apache.github.io/superset"
  chart      = "superset"
  version    = "0.14.2"
  wait_for_jobs = true
  values = [
    yamlencode({
      secretKey = local.secret_key_value

      configOverrides = {
        secret = <<-EOT
          SECRET_KEY = "${local.secret_key_value}"
        EOT
      }

    #   init = {
    #     enabled = true
    #   }

      postgresql = {
        enabled = false
      }

    #   externalDatabase = {
    #     host     = var.postgres_host
    #     username = var.postgres_secret_username
    #     password = var.postgres_secret_password
    #   }

      ingress = {
        enabled          = true
        ingressClassName = var.ingress_class
        path             = "/"
        annotations = {
          "cert-manager.io/cluster-issuer"             = var.cluster_issuer
          "nginx.ingress.kubernetes.io/rewrite-target" = "/"
        }
        hosts = [var.domain_name]

        tls = [{
          secretName = var.tls_secret_name
          hosts      = [var.domain_name]
        }]
      
    }
    supersetNode = {
        replicas = {
          enabled      = true
          replicaCount = 1
        }
        command = [
          "/bin/sh",
          "-c",
          "pip3 install psycopg2-binary pyhive && /app/pythonpath/superset_bootstrap.sh; /usr/bin/run-server.sh"
        ]
        resources = {}
        connections = {
            db_host     = var.postgres_host
            db_user = var.postgres_secret_username
            db_pass = var.postgres_secret_password
        }
      }
      supersetWorker = {
        replicas = {
          enabled      = true
          replicaCount = 1
        }
        command = [
          "/bin/sh",
          "-c",
          "pip3 install psycopg2-binary pyhive && /app/pythonpath/superset_bootstrap.sh; celery --app=superset.tasks.celery_app:app worker"
        ]
        
      }
      init = {
        enabled = true
        
        command = [
          "/bin/sh",
          "-c",
          "pip3 install psycopg2-binary pyhive && /app/pythonpath/superset_bootstrap.sh; /app/pythonpath/superset_init.sh"
        ]
        
      }
      bootstrapScript = <<-EOT
        #!/bin/bash
        uv pip3 install .[postgres] \
          .[bigquery] \
          .[elasticsearch] &&\
        pip3 install psycopg2-binary &&\
        pip3 install pyhive &&\
        if [ ! -f ~/bootstrap ]; then echo "Running Superset with uid {{ .Values.runAsUser }}" > ~/bootstrap; fi
      EOT
    })
  ]
  depends_on = [random_password.base64_key, kubernetes_job.create_superset_db]
}