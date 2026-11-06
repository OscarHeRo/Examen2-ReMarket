# 12. Pipeline DevSecOps y Cadena de Suministro

ReMarket aplica *Shift-Left Security*. Flujo: Desarrollador → Git (PR) → Build y pruebas → SAST/SCA → Imagen → Staging → Aprobación → Producción. Cada control va en la etapa más temprana donde detecta el problema, y los críticos bloquean el avance.


| Control | Etapa | Herramienta | ¿Bloquea? | Propósito Técnico |
| :--- | :--- | :--- | :---: | :--- |
| **Detección de secretos** | Pre-commit y CI | Gitleaks / TruffleHog | **SÍ** | El hook local se puede saltar; el escaneo en CI no. |
| **Control de acceso** | Repositorio | Branch protection, CODEOWNERS, MFA | **SÍ** | Nadie hace push directo a `main` ni cambia el pipeline sin el equipo de seguridad. |
| **Revisión de código** | Pull Request | Reglas de GitHub | **SÍ** | Dos aprobaciones antes del merge a `main`. |
| **Pruebas automatizadas** | CI | Pruebas unitarias e integración | **SÍ** | Una prueba fallida detiene el build. |
| **Análisis SAST** | CI | SonarQube / Semgrep | **SÍ** | Detecta inyección SQL, XSS y mal uso de criptografía. |
| **Análisis SCA** | CI | Snyk / Trivy | **SÍ** | Bloquea dependencias con vulnerabilidades CVSS ≥ 7.0 con parche. |
| **Escaneo de imagen** | Empaquetado | Trivy | **SÍ** | Revisa paquetes del sistema base antes de subir a ECR. |
| **Firma de imagen** | Empaquetado | Sigstore Cosign | **SÍ** | Kyverno en EKS rechaza imágenes sin firma válida. |
| **Pruebas DAST** | Staging | OWASP ZAP | **Sólo críticos** | Escaneo dinámico; alerta salvo hallazgos críticos confirmados. |
| **Aprobación a producción** | Antes de producción | Entornos de GitHub + ArgoCD | **SÍ** | Visto bueno del líder técnico y de seguridad, con MFA. |

### Manejo Seguro de Secretos
El pipeline **no guarda claves fijas de AWS**: GitHub Actions usa federación **OIDC** con IAM para obtener credenciales de 15 minutos, limitadas a publicar en Amazon ECR. Los secretos de la aplicación nunca pasan por el pipeline: los pods los leen en ejecución desde Secrets Manager.

### Seguridad de la Cadena de Suministro
SCA frena librerías vulnerables o falsificadas (*typosquatting*), Kyverno sólo admite imágenes firmadas por nuestro pipeline y todo cambio productivo exige commits firmados y revisados por dos personas.
