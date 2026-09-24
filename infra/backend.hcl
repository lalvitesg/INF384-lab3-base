## Preparacion previa lista

| | |
|---|---|
| Bucket de estado | `20221943` |
| Clave del estado | `lab3/terraform.tfstate` |
| Repositorio de imagenes | `644637381926.dkr.ecr.us-east-1.amazonaws.com/inf384-lab3` |
| Imagen inicial | `644637381926.dkr.ecr.us-east-1.amazonaws.com/inf384-lab3:bootstrap` |

### Falta un paso, y es manual

Crear `infra/backend.hcl` con este contenido exacto y **versionarlo**:

```hcl
bucket = "20221943"
key    = "lab3/terraform.tfstate"
region = "us-east-1"
```

El pipeline de infraestructura lee ese archivo. Si no esta
versionado, `terraform init` falla.

Ese mismo commit toca `infra/`, asi que dispara el pipeline de
infraestructura, y su primera ejecucion crea el grupo de logs,
la politica de descarga y la funcion.
