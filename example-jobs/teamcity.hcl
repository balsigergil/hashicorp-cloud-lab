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

                mount {
                    target = "/data/teamcity_server/datadir"
                    source = "${NOMAD_JOB_NAME}-server-datadir"
                }

                mount {
                    target = "/opt/teamcity/logs"
                    source = "${NOMAD_JOB_NAME}-server-logs"
                }
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
        constraint {
            attribute = "${node.unique.name}"
            value     = "node-1"
        }

        task "teamcity-agent" {
            driver = "docker"

            config {
                image = "jetbrains/teamcity-agent"

                mount {
                    target = "/data/teamcity_agent/conf"
                    source = "${NOMAD_JOB_NAME}-agent-conf"
                }
            }

            env {
                SERVER_URL = "http://${NOMAD_UPSTREAM_ADDR_teamcity-server}"
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