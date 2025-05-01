terraform {
    required_providers {
        docker = {
            source  = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}

provider "docker" {
    }

resource "docker_image" "mysql" {
    name = "mysql:8.0.31"
    keep_locally = true
}

resource "docker_image" "python" {
    name = "python:3.11.4"
    keep_locally = true
    build {
        context = "./python"
    }
}

variable "MYSQL_DATABASE" {
    description = "The name of the database to create"
    type        = string
    default     = "ynov_cis"
}

variable "MYSQL_PASSWORD" {
    description = "The password for the MySQL root user"
    type        = string
    default     = "root"
}

variable "MYSQL_ROOT_PASSWORD" {
    description = "The password for the MySQL root user"
    type        = string
    default     = "root"
}

variable "MYSQL_ROOT_USER" {
    description = "The name of the MySQL root user"
    type        = string
    default     = "root"
}

variable "MYSQL_HOST" {
    description = "The host of the MySQL server"
    type        = string
    default     = "mysql"
}

variable "MYSQL_PORT" {
    description = "The port of the MySQL server"
    type        = number
    default     = 3306
}
variable "MYSQL_USER" {
    description = "The name of the MySQL user"
    type        = string
    default     = "root"
}


resource "docker_network" "ynov_cis" {
    name = "ynov_cis"
}

resource "docker_container" "mysql" {
    name  = "mysql"
    image = docker_image.mysql.image_id
    networks_advanced {name = docker_network.ynov_cis.name}
    volumes {
        host_path = abspath("${path.module}/mysql")
        container_path = "/docker-entrypoint-initdb.d"
    }
    env = [
      "MYSQL_DATABASE=${var.MYSQL_DATABASE}",
      "MYSQL_PASSWORD=${var.MYSQL_PASSWORD}",
      "MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD}",
      "MYSQL_ROOT_USER=${var.MYSQL_ROOT_USER}",
    ]
    ports {
        internal = 3306
        external = 3306
    }
    healthcheck {
        test = ["mysqladmin", "ping", "-h", "localhost"]
    }
}

resource "docker_container" "python" {
    name  = "python"
    image = docker_image.python.image_id
    networks_advanced {name = docker_network.ynov_cis.name}
    ports {
        internal = 8080
        external = 8080
    }
    env = [
        "MYSQL_HOST=${var.MYSQL_HOST}",
        "MYSQL_PORT=${var.MYSQL_PORT}",
        "MYSQL_USER=${var.MYSQL_USER}",
        "MYSQL_PASSWORD=${var.MYSQL_PASSWORD}",
        "MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD}",
        "MYSQL_DATABASE=${var.MYSQL_DATABASE}",
    ]
    volumes {
        host_path      = abspath("${path.module}/app")
        container_path = "/app"
    }
    depends_on = [docker_container.mysql]
}


