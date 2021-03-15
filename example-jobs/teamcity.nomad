job "teamcity" {
    datacenters = ["dc1"]

    group "teamcity-server" {
        constraint {
            attribute = "${node.unique.name}"
            value     = "server"
        }

        task "teamcity-server" {
            driver = "docker"

            config {
                image = "jetbrains/teamcity-server"
            }

            resources {
                cpu    = 600
                memory = 2048
            }
        }

        network {
            mode = "bridge"
            port "http" {
                to = 8111
                static = 8111
            }
        }

        service {
            name = "teamcity-server"
            port = 8111

            connect {
                sidecar_service {}
            }
        }
    }

    group "teamcity-agent" {
        task "teamcity-agent" {
            driver = "docker"

            config {
                image = "jetbrains/teamcity-agent"
            }

            env {
                SERVER_URL = "http://${NOMAD_UPSTREAM_ADDR_teamcity-server}"
            }

            resources {
                cpu    = 200
                memory = 512
            }
        }
        
        network {
            mode = "bridge"
        }

        service {
            name = "teamcity-agent"

            connect {
                sidecar_service {
                    proxy {
                        upstreams {
                            destination_name = "teamcity-server"
                            local_bind_port = 8111
                        }
                    }
                }
            }
        }
    }
}