provider "helm" {
  kubernetes {
    config_path = "client.config"
  }
}

variable "fluent-bit-config" {
  type = string
}

variable "namespace" {
  type = string
}

data "local_file" "fluent-bit-config" {
  filename = basename(var.fluent-bit-config)
}

resource "helm_release" "fluent-bit" {
  name       = "fluent-bit"
  namespace  = var.namespace
  atomic     =  true
  force_update = true
  skip_crds = true
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  values = [data.local_file.fluent-bit-config.content]
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  namespace  = var.namespace
  repository = "https://helm.elastic.co"
  skip_crds = true
  chart      = "elasticsearch"
  atomic     =  true
  force_update = true

  set {
    name = "replicas"
    value = "1"
  }

  set {
    name = "minMasterNodes"
    value = "1"
  }
}