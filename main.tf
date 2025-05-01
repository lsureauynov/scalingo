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

provider "scalingo" {
  api_token = "tk-us-tpUDHklBlvTQ0eBK20oyt2x9Q3AbG1MRn3E9qZoY9OtqU4XU"
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