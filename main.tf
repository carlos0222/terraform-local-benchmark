
# ==========================================
# TERRAFORM LOCAL BENCHMARK LAB
# Infraestructura local con Docker
# ==========================================

# 1. CONFIGURACIÓN DE TERRAFORM
terraform {
  required_providers {
    docker = {
      # Proveedor que permite gestionar Docker
      source = "kreuzwerker/docker"

      # Versión del proveedor
      version = "4.6.0"
    }
  }
}

# 2. CONEXIÓN CON DOCKER
provider "docker" {
  # Conexión con Docker Desktop en Windows
  host = "npipe:////.//pipe//docker_engine"
}

# 3. IMAGEN DE DOCKER
resource "docker_image" "nginx" {
  # Descargamos Nginx en su versión Alpine
  # Alpine es una distribución ligera de Linux
  name = "nginx:alpine"

  # Permite eliminar la imagen cuando Terraform destruye el recurso
  keep_locally = false
}

# 4. CONTENEDOR DOCKER
resource "docker_container" "servidor" {
  # Nombre que tendrá nuestro contenedor
  name = "terraform-local-lab"

  # Utilizamos la imagen descargada arriba
  image = docker_image.nginx.image_id

  # Configuramos los puertos de comunicación
  ports {
    # Puerto que utiliza Nginx dentro del contenedor
    internal = 80

    # Puerto de nuestro ordenador
    external = 8080
  }
}

# 5. INFORMACIÓN DEL DESPLIEGUE
output "url_servidor" {
  # Terraform mostrará esta dirección cuando termine de crear la infraestructura
  value = "http://localhost:8080"
}

