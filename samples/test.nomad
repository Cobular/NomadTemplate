job "umami" {
  datacenters = ["home"]
  type        = "service"

  affinity {
    attribute = "${node.unique.id}"
    value = "4087810e-3c43-1c96-1bab-f34cedb93a48"
    weight = 1000
  }

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "3m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
  }

  group "umami" {
    count = 1

    network {
      port "http" {
        to = 3000
      }
    }

    task "umami" {
      driver = "docker"

      config {
        image = "ghcr.io/umami-software/umami:postgresql-v1.39.5"
        ports = ["http"]
      }

      env {
        DATABASE_TYPE   = "postgres"
        DATABASE_URL   = "postgresql://umami:aaaa@prodesk.vpn.cobular.com:5432/umami"
        HASH_SALT   = "eee"
      }

      resources {
        cpu    = 300
        memory = 400
      }
    }

    service {
      name = "umami"
      port = "http"

      tags = [
    "traefik.enable=true",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Job=umami",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Task=umami",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Service=http",
    "traefik.http.routers.umami.rule=Host(`umami.cobular.com`)",
    "traefik.http.services.umami.loadbalancer.sticky=true",
    "traefik.tags=service",
    "traefik.frontend.rule=Host:umami.cobular.com",
    "traefik.http.routers.umami.middlewares=umami-chain",
    "traefik.http.middlewares.umami-chain.chain.middlewares=umami-mid,local-ipwhitelist@file",
    "traefik.http.routers.umami.entrypoints=https",
    "traefik.http.routers.umami.tls.certresolver=certResolver",
    "traefik.http.routers.umami-http.entrypoints=http",
    "traefik.http.routers.umami-http.rule=Host(`umami.cobular.com`)",
    "traefik.http.middlewares.umami-chain-http.chain.middlewares=redirect-to-https@file,local-ipwhitelist@file",
    "traefik.http.routers.umami-http.middlewares=umami-chain-http"
]

    }

    service {
      name = "umami-pub"
      port = "http2"

      tags = [
    "traefik.enable=true",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Job=umami",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Task=umami",
    "traefik.http.middlewares.umami-mid.headers.customresponseheaders.X-Service=http",
    "traefik.http.routers.umami.rule=Host(`umami.cobular.com`)",
    "traefik.http.services.umami.loadbalancer.sticky=true",
    "traefik.tags=service",
    "traefik.frontend.rule=Host:umami.cobular.com",
    "traefik.http.routers.umami.middlewares=umami-mid",
    "traefik.http.routers.umami.entrypoints=https",
    "traefik.http.routers.umami.tls.certresolver=certResolver",
    "traefik.http.routers.umami-http.entrypoints=http",
    "traefik.http.routers.umami-http.rule=Host(`umami.cobular.com`)",
    "traefik.http.routers.umami-http.middlewares=redirect-to-https@file"
]

    }
  }
}
