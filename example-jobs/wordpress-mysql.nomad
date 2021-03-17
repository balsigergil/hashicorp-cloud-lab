job "wordpress-mysql" {
    datacenters = ["dc1"]

    group "database" {
        constraint {
            attribute = "${node.unique.name}"
            value     = "node-1"
        }

        task "database" {
            driver = "docker"

            config {
                image = "mysql:5.7"
                
                mount {
                    target = "/var/lib/mysql"
                    source = "${NOMAD_JOB_NAME}-dbdata"
                }
            }

            env {
                MYSQL_ROOT_PASSWORD = "root"
                MYSQL_DATABASE = "wordpress"
                MYSQL_USER = "wordpress"
                MYSQL_PASSWORD = "wordpress"
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

    group "wordpress" {
        constraint {
            attribute = "${node.unique.name}"
            value     = "server"
        }

        task "wordpress" {
            driver = "docker"

            config {
                image = "wordpress"

                mount {
                    target = "/var/www/html"
                    source = "${NOMAD_JOB_NAME}-wwwdata"
                }
            }

            env {
                WORDPRESS_DB_HOST = "${NOMAD_UPSTREAM_IP_database}"
                WORDPRESS_DB_USER = "wordpress"
                WORDPRESS_DB_PASSWORD = "wordpress"
                WORDPRESS_DB_NAME = "wordpress"
                WORDPRESS_DEBUG = "1"
            }

            resources {
                cpu    = 100
                memory = 128
            }
        }
        
        network {
            mode = "bridge"

            port "http" {
                to = 80
                static = 8000
            }
        }

        service {
            name = "wordpress"
            port = "http"

            check {
                type = "http"
                path = "/"
                interval = "6s"
                timeout = "3s"
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