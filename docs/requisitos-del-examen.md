# Checklist completa del Examen 2

Todo lo que pide el enunciado, en forma de lista verificable. Extraído de
[`enunciado/Examen 2 E-commerce.pdf`](enunciado/). **Si algo aquí no está marcado, no hemos
terminado.**

---

## Contexto que hay que respetar

**ReMarket**: e-commerce internacional, vende producto propio por plataforma web. En
campañas y temporada alta recibe picos de solicitudes simultáneas. Migra a **microservicios
en la nube**. Usa servicios externos de **pagos**, **paquetería/envíos** y **notificaciones
(correo/SMS)**.

El equipo de seguridad exige **Security by Design**: la criptografía y los controles entran
*desde la arquitectura*, no pegados después.

Garantías que la empresa necesita:

- [x] Disponibilidad del servicio
- [x] Escalabilidad
- [x] Integridad de las transacciones
- [x] Protección de datos personales
- [x] Protección de información de pagos
- [x] Seguridad de las comunicaciones
- [x] Recuperación ante fallos
- [x] Trazabilidad de las operaciones

> El objetivo **no** es programar la aplicación ni desplegar infraestructura real. Es
> **justificar** cómo se diseña y se protege.

---

## 1. Arquitectura general del sistema

Componentes **mínimos obligatorios** (se pueden añadir más si se justifican):

- [x] Frontend web
- [x] API Gateway / punto de entrada
- [x] Servicio de autenticación y usuarios
- [x] Servicio de catálogo
- [x] Servicio de pedidos
- [x] Servicio de inventario
- [x] Servicio de pagos
- [x] Servicio de notificaciones
- [x] Base de datos transaccional
- [x] Base de datos / almacenamiento del catálogo
- [x] Caché
- [x] Cola o bus de eventos
- [x] Servicio externo de pagos
- [x] Servicio externo de paquetería

Nube: **AWS, Azure, GCP o cloud genérica** (a elegir, pero hay que ser consistente).

En el diagrama deben **identificarse claramente**:

- [x] Usuarios
- [x] Servicios
- [x] Microservicios
- [x] Bases de datos
- [x] Comunicaciones
- [x] Servicios externos
- [x] **Zonas de confianza**
- [x] **Componentes de seguridad**

---

## 2. Clasificación de información

Tipos a analizar como **mínimo**:

- [x] credenciales
- [x] datos personales
- [x] direcciones
- [x] información de pedidos
- [x] inventario
- [x] información relacionada con pagos
- [x] tokens de sesión
- [x] registros de auditoría
- [x] claves criptográficas

Para **cada uno** de los nueve, indicar las **siete** cosas:

1. dónde se genera
2. dónde se almacena
3. por qué servicios circula
4. quién debería poder acceder
5. qué pasa si se compromete su **confidencialidad**
6. qué pasa si se **modifica**
7. qué pasa si deja de estar **disponible**

Y clasificar cada tipo según su **sensibilidad**.

---

## 3. Criptografía aplicada — *sección principal del proyecto*

> Para cada decisión: **qué propiedad de seguridad se protege** y **por qué ese mecanismo**.

### 3.1 Protección de la página web (Usuario ↔ ReMarket)

- [x] protocolo utilizado
- [x] función de TLS
- [x] certificados digitales
- [x] autenticación del servidor
- [x] confidencialidad
- [x] integridad

> ⚠️ El enunciado lo dice explícitamente: **no basta con escribir "Se utiliza HTTPS"**. Hay
> que explicar *qué problema resuelve* HTTPS/TLS.

### 3.2 Comunicación entre microservicios

Dos tramos: **API Gateway → microservicios** y **microservicio → microservicio**.

Mecanismos a considerar: TLS, mTLS, tokens, certificados, rotación de credenciales.

- [x] Justificar **qué comunicaciones requieren autenticación mutua** (y cuáles no)

### 3.3 API REST — caso `POST /pedido`

- [x] confidencialidad
- [x] integridad
- [x] autenticación
- [x] autorización
- [x] protección frente a repetición (*replay*)
- [x] manejo de tokens
- [x] qué información debe viajar cifrada
- [x] qué información **no debería enviarse** innecesariamente

### 3.4 Protección de datos almacenados

- [x] cifrado en reposo
- [x] cifrado de discos / almacenamiento
- [x] cifrado de respaldos
- [x] separación de claves y datos
- [x] administración de secretos

**Pregunta central a responder:** ¿por qué no basta con proteger la conexión HTTPS si la
base de datos puede ser comprometida?

### 3.5 Contraseñas

- [x] Diferenciar **cifrado** vs **hash** vs **salt** vs **función de derivación de contraseña**
- [x] Explicar por qué **no** deben almacenarse con cifrado reversible

### 3.6 Gestión de claves criptográficas

Ciclo de vida completo:

- [x] generación
- [x] almacenamiento
- [x] acceso
- [x] rotación
- [x] revocación
- [x] respaldo
- [x] eliminación

- [x] Explicar por qué las claves **no** van dentro del código fuente
- [x] Proponer KMS / HSM / Secret Manager (o equivalente)

### 3.7 Pasarela de pagos

Flujo **Usuario → ReMarket → Pasarela**:

- [x] qué datos recibe ReMarket
- [x] qué datos debe manejar **directamente la pasarela**
- [x] qué información **no debería almacenarse** nunca
- [x] qué comunicaciones hay que proteger
- [x] cómo verificar que una respuesta viene de verdad del proveedor

**Caso obligatorio — webhook `POST /payment-confirmed`:** ¿cómo evita ReMarket que un
atacante mande una solicitud falsa diciendo que un pedido fue pagado?

- [x] Proponer mecanismos de verificación

### 3.8 Firmas digitales e integridad (facturas y comprobantes)

- [x] Mecanismo para detectar modificaciones posteriores
- [x] Uso de funciones hash
- [x] Uso de firmas digitales
- [x] Uso de certificados
- [x] Describir el flujo: **Documento → Hash → Firma → Verificación**
- [x] Explicar por qué **firmar un documento no es cifrarlo**

### 3.9 Comunicación asíncrona (cola de eventos)

Ejemplo: *Pedido creado → evento → servicio de notificaciones*.

- [x] autenticación del productor
- [x] autenticación del consumidor
- [x] protección del canal
- [x] integridad del evento
- [x] permisos mínimos

**Pregunta:** ¿qué podría ocurrir si un atacante publicara mensajes falsos en la cola?

---

## 4. Pipeline DevSecOps

Flujo base: *Desarrollador → Repositorio Git → Build → Pruebas → Análisis de seguridad →
Creación de imagen → Despliegue*.

Controles mínimos, **y en qué punto del pipeline va cada uno**:

- [x] revisión de código
- [x] análisis estático (SAST)
- [x] análisis de dependencias (SCA)
- [x] detección de secretos
- [x] análisis de imágenes de contenedores
- [x] pruebas automatizadas
- [x] control de acceso
- [x] manejo seguro de secretos
- [x] aprobación antes de producción

---

## 5. Seguridad de contenedores y microservicios

Controles para reducir el impacto de la vulneración de **un** microservicio:

- [x] mínimo privilegio
- [x] segmentación
- [x] aislamiento
- [x] actualización de imágenes
- [x] cuentas de servicio
- [x] secretos
- [x] permisos de red

**Pregunta obligatoria:** si el microservicio de **catálogo** es comprometido, ¿por qué no
debería poder consultar directamente la base de datos de **usuarios** o de **pagos**?

---

## 6. Evaluación de riesgos

**Al menos tres riesgos**, con **uno por cada categoría** como mínimo:

- [x] credenciales
- [x] comunicaciones
- [x] almacenamiento
- [x] disponibilidad
- [x] cadena de suministro / pipeline

Opcionales: APIs, microservicios, terceros, pagos, configuraciones cloud.

Tabla por riesgo: `Riesgo | Activo | Amenaza | Vulnerabilidad | Impacto | Probabilidad | Nivel`

Escala: **Alto = 3 · Medio = 2 · Bajo = 1**
Cálculo: **Nivel de riesgo = Impacto × Probabilidad**
Clasificación: **6–9 Alto · 3–4 Medio · 1–2 Bajo**

Para los riesgos más importantes, definir **tratamiento**:

- [x] control **preventivo**
- [x] control **detectivo**
- [x] control **correctivo**
- [x] clasificar como mitigación / evitación / transferencia / aceptación
- [x] **relacionar cada control con un riesgo identificado**

---

## 7. Disponibilidad y continuidad

- [x] balanceo de carga
- [x] autoescalado
- [x] redundancia
- [x] múltiples zonas de disponibilidad
- [x] respaldo
- [x] replicación
- [x] recuperación ante fallos

- [x] Elegir **tres servicios críticos** y definir **RTO** y **RPO** para cada uno
- [x] **Justificar** los valores elegidos

---

## 8. Uso de IA

### 8.1 IA como atacante

**Tres escenarios** de ataque donde la IA facilite o acelere: phishing dirigido,
descubrimiento de errores de configuración, identificación de APIs expuestas, generación de
entradas maliciosas, análisis de respuestas, búsqueda de secretos filtrados, automatización
del reconocimiento.

Por cada escenario, las **cinco** preguntas:

1. qué activo intenta comprometer
2. qué vulnerabilidad o debilidad aprovecha
3. qué impacto produciría
4. qué controles **de nuestra arquitectura** reducen el riesgo
5. qué evidencia permitiría detectarlo

> No hace falta escribir código de ataque ni ejecutar técnicas ofensivas reales.

### 8.2 IA como evaluador de seguridad

Darle a la IA un resumen de nuestra arquitectura y pedirle que encuentre riesgos, errores de
diseño o controles faltantes. **Al menos tres observaciones**, evaluadas críticamente:

1. ¿es técnicamente correcta?
2. ¿aplica realmente a nuestra arquitectura?
3. ¿qué riesgo intenta reducir?
4. ¿la aceptamos, modificamos o rechazamos?
5. ¿qué evidencia técnica justifica la decisión?

### 8.3 Reflexión final

¿Por qué una organización **no** debería implementar automáticamente todas las
recomendaciones de una IA en ciberseguridad? Relacionar con:

- [x] contexto
- [x] falsos positivos
- [x] configuración real del sistema
- [x] impacto operativo
- [x] gestión de riesgos
- [x] responsabilidad humana

### 8.4 Evidencia requerida en el informe

- [x] el **prompt** utilizado
- [x] un **fragmento relevante** de la respuesta de la IA
- [x] nuestro **análisis crítico**
- [x] la **decisión final** del equipo

---

## Entregables finales

1. [ ] Diagrama de arquitectura cloud
2. [ ] Documento técnico de **máximo 8–10 páginas**
3. [ ] Matriz de riesgos
4. [ ] Diseño del pipeline DevSecOps
5. [ ] Análisis del uso de la IA

Equipos de **a lo más 3 personas**. La profesora recomienda enfoque **ágil** y usar la IA
como *Product Owner* y *Scrum Master* para guiar la planificación.

---

## Criterio principal de evaluación

> No se evaluará únicamente si el alumnado menciona tecnologías. Se evaluará principalmente
> si comprende:
> - **qué se protege**
> - **contra qué amenaza se protege**
> - **qué propiedad criptográfica o control de seguridad se necesita**
> - **por qué la solución propuesta es adecuada**
