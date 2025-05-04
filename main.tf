terraform {
  required_providers {
    scalingo = {
      source  = "scalingo/scalingo"
      version = "2.3.0"
    }
    ad = {
      source  = "hashicorp/ad"
      version = "0.5.0"
    }
  }
}

variable API_TOKEN {
  description = "API token for Scalingo"
  type        = string
}

provider "scalingo" {
  api_token = "${var.API_TOKEN}"
  region = "osc-fr1"
}

resource "scalingo_app" "python_api" {
  name = "python-api"
  environment = {
    PROJECT_DIR = "app"
    BUILDPACK_URL = "https://github.com/Scalingo/python-buildpack"
  }
}

resource "scalingo_addon" "db" {
  provider_id = "mysql"
  plan = "mysql-starter-512"
  app = "${scalingo_app.python_api.id}"
}

resource "scalingo_container_type" "web" {
  app = scalingo_app.python_api.name
  name = "web"
  amount = 1
  size = "S"
}