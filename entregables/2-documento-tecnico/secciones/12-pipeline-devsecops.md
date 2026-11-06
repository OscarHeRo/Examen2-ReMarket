# 12. Pipeline DevSecOps y Cadena de Suministro

ReMarket aplica *Shift-Left Security* integrando controles automáticos bloqueantes en cada etapa:

```
[ Desarrollador ] ──> [ Git PR ] ──> [ Pruebas CI ] ──> [ Empaquetado ] ──> [ Aprobación ] ──> [ Despliegue ]
   (Gitleaks)          (2 pares)      (SAST + SCA)        (Trivy + Cosign)     (Manual Prod)      (ArgoCD GitOps)
```

| Control | Etapa | Herramienta | ¿Bloquea? | Propósito Técnico |
| :--- | :--- | :--- | :---: | :--- |
| **Detección de Secretos** | Pre-commit | Gitleaks | **SÍ** | Impide comitear API keys o contraseñas al repositorio. |
| **Revisión de Código** | Pull Request | GitHub Rules | **SÍ** | Exige aprobación de dos pares antes del merge a `main`. |
| **Análisis SAST** | CI | SonarQube | **SÍ** | Detecta inyecciones SQL, XSS y fallas de código interno. |
| **Análisis SCA** | CI | Snyk / Trivy | **SÍ** | Bloquea dependencias con vulnerabilidades (CVE $\ge 7.0$). |
| **Escaneo Contenedores** | Build | Trivy Container | **SÍ** | Analiza la imagen base en busca de paquetes vulnerables. |
| **Firma Criptográfica** | Build | Sigstore Cosign | **SÍ** | Firma la imagen OCI; Kubernetes rechaza imágenes sin firma. |
| **Pruebas DAST** | Staging | OWASP ZAP | **NO** | Escaneo dinámico en ejecución; alerta sin frenar despliegues. |
| **Aprobación Manual** | Staging | GitHub Envs | **SÍ** | Visto bueno formal de líderes técnicos antes de producción. |
| **Despliegue GitOps** | Deploy | ArgoCD | **SÍ** | Aplica el estado declarado en Git; anula desvíos manuales. |

### Manejo de Secretos vía OIDC
El pipeline **no almacena claves fijas de AWS**. GitHub Actions usa federación **OpenID Connect (OIDC)** con AWS IAM para obtener credenciales efímeras (15 min) limitadas a publicar en Amazon ECR.

### Seguridad de la Cadena de Suministro
SCA previene librerías envenenadas (*typosquatting*), la política Kyverno en Kubernetes rechaza imágenes sin firma Cosign válida y todo cambio productivo exige commits firmados y revisados por dos pares.
