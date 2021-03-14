job "jenkins" {
    datacenters = ["dc1"]

    group "jenkins" {
        constraint {
            attribute = "${node.unique.name}"
            value     = "server"
        }

        task "jenkins" {
            driver = "docker"

            config {
                image = "jenkins/jenkins"
                ports = ["http", "jnlp"]
            }

            resources {
                cpu    = 100
                memory = 512
            }
        }
        
        network {
            port "http" {
                to = 8080
                static = 8002
            }

            port "jnlp" {
                to = 50000
                static = 50000
            }
        }

        service {
            name = "jenkins"
            port = "http"

            check {
                type = "http"
                path = "/login"
                interval = "10s"
                timeout = "5s"
            }
        }
    }
}