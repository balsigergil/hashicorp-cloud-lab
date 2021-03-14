job "nextcloud-mysql" {
    datacenters = ["dc1"]

    group "database" {
        task "database" {
            driver = "docker"

            env {
                MYSQL_ROOT_PASSWORD = "root"
                MYSQL_DATABASE = "nextcloud"
                MYSQL_USER = "nextcloud"
                MYSQL_PASSWORD = "nextcloud"
            }

            config {
                image = "mysql:5.7"
            }

            resources {
                cpu    = 100
                memory = 512
            }
        }

        network {
            mode = "bridge"
        }

        service {
            name = "database"
            port = 3306

            connect {
                sidecar_service {}
            }
        }
    }

    group "nextcloud" {
        constraint {
            attribute = "${node.unique.name}"
            value     = "server"
        }

        task "nextcloud" {
            driver = "docker"

            config {
                image = "nextcloud"
            }

            env {
                MYSQL_HOST = "${NOMAD_UPSTREAM_IP_database}"
                MYSQL_USER = "nextcloud"
                MYSQL_PASSWORD = "nextcloud"
                MYSQL_DATABASE = "nextcloud"
            }

            resources {
                cpu    = 100
                memory = 256
            }
        }
        
        network {
            mode = "bridge"

            port "http" {
                to = 80
                static = 8001
            }
        }

        service {
            name = "nextcloud"
            port = "http"

            check {
                type = "http"
                path = "/"
                interval = "10s"
                timeout = "5s"
            }

            connect {
                sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "database"
                            local_bind_port = 3306
                        }
                    }
                }
            }
        }
    }
}