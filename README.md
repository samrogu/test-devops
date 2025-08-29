# Test DevOps
## Diagrama de aplicacion
### Para test tecnico devops, para esta solucion se implemtan un cluster de GKE, donde los ambientes se separan por espacios de trabajo (namespaces).
### Para efectos de este test en el namespaces **default** se implementa Jenkins para poder Orquestar el despliegue.

### En el namespaces **development** se implementa la aplicacion mediante un helm, para acceder a development: https://devsutest.sagurodev.com/api/swagger-ui/index.html#/

### En el namespaces **development** se implementa la aplicacion mediante un helm: https://devsuprod.sagurodev.com/api/swagger-ui/index.html#/

### Para poder acceder Jenkins: http://devops.sagurodev.com/

![Diagrama de arquitectura](/docs/arquitectura.png)


# Estructaura del proyecto:
## **demo-devops-java**:  contienel codigo fuente e internament el dockerfile

## **infraestructura/gcp**: Contiene el IAC para este proyecto creado en Terraform, por que permitira hacer el onboarding de cluster: Asignando permisos a Artifact Registry, Creando Service Account, Crea cluster GKE, una vez aplicado GKE, Aplicaca NGINX para orchestar el balanceo de aplicacion

## **k8s-app**: Contiene los archivos necesarios para deplegar el aplicativo, esta esta creada con helm para un tener una mejor facilidad de despliegue, el cual tambien permite hacer rollback en caso sea necesario.

# Capturas GCP:
## Network
 ![Diagrama de Network](/docs/network.png)
## GKE
 ![Diagrama de gke](/docs/gke.png)
 ![Diagrama de workloads](/docs/workloads.png)

## ALB
 ![Diagrama de alb](/docs/alb.png)

## Domain SquareSpace
 ![Diagrama de reg](/docs/domainreg.png)

# Estructura de Pipeline:
 ![Diagrama de pipeline](/docs/pipeline.png)

## Para el pipeline, se usan las herramientas: maven, sonarcloud, Kaniko para compilar la imagen, trivy para escanear la imagen, helm para desplegar, gcloud para obtener las credenciales necesarias.


## Sonar Cloud

![img](/docs/sonarcloud.png)


## Recurso Sobre Kubernetes dev:
 ![Diagrama de k8s dev](/docs/k8s-dev.png)


## Recurso Sobre Kubernetes Prod:
 ![Diagrama de k8s prod](/docs/k8s-prod.png)


## Recurso ING Kubernetes Dev/Prod:
 ![Diagrama de ings prod](/docs/ings.png)


## Salidas Terraform
 ![Diagrama de state tf prod](/docs/terraform-list.png)


## QA Namespaces Terraform:
### Agrego namespaces qa, para poder obtner una salida de terraform:
 ![Diagrama de state tf prod](/docs/terraform-list.png)
 ![Diagrama de state tf prod](/docs/tfplan1.png)
 ![Diagrama de state tf prod](/docs/plan2.png)

### Aplicando namespaces qa, para poder obtner una salida de terraform:
 ![Diagrama de state tf prod](/docs/tfapply.png)
  ![Diagrama de state tf prod](/docs/tfapply2.png)

### En el archivo que esta en **infraestructure/gcp/TerraformState.txt**  esta el estado de toda la implementacion



### Si se quiere ejecutar los archivos es necesario tener un buket en gcp para poder asociar y resguardar el esdado.

```
# Ejecutar terraform
terraform init

# Planear
terraform plan

# Applicar (--auto-approve si se quiere aplicar sin que pida aprobacion del ejecutor)
terraform apply --auto-approve
```
