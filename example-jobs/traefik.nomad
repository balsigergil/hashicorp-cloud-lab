job "traefik" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${node.unique.name}"
    value     = "server"
  }

  group "traefik" {
    network {
      port "http" {
        static = 80
      }

      port "api" {
        static = 8080
      }
    }

    service {
      name = "traefik"

      check {
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "5s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image        = "traefik:2.4"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        data = <<EOF
[entryPoints]
  [entryPoints.http]
    address = ":80"
  [entryPoints.traefik]
    address = ":8080"

[api]
  dashboard = true
  insecure  = true

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
  prefix           = "traefik"
  exposedByDefault = false

  [providers.consulCatalog.endpoint]
    address = "127.0.0.1:8500"
    scheme  = "http"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
