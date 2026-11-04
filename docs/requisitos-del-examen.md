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

- [ ] Disponibilidad del servicio
- [ ] Escalabilidad
- [ ] Integridad de las transacciones
- [ ] Protección de datos personales
- [ ] Protección de información de pagos
- [ ] Seguridad de las comunicaciones
- [ ] Recuperación ante fallos
- [ ] Trazabilidad de las operaciones

> El objetivo **no** es programar la aplicación ni desplegar infraestructura real. Es
> **justificar** cómo se diseña y se protege.

---

## 1. Arquitectura general del sistema

Componentes **mínimos obligatorios** (se pueden añadir más si se justifican):

- [ ] Frontend web
- [ ] API Gateway / punto de entrada
- [ ] Servicio de autenticación y usuarios
- [ ] Servicio de catálogo
- [ ] Servicio de pedidos
- [ ] Servicio de inventario
- [ ] Servicio de pagos
- [ ] Servicio de notificaciones
- [ ] Base de datos transaccional
- [ ] Base de datos / almacenamiento del catálogo
- [ ] Caché
- [ ] Cola o bus de eventos
- [ ] Servicio externo de pagos
- [ ] Servicio externo de paquetería

Nube: **AWS, Azure, GCP o cloud genérica** (a elegir, pero hay que ser consistente).

En el diagrama deben **identificarse claramente**:

- [ ] Usuarios
- [ ] Servicios
- [ ] Microservicios
- [ ] Bases de datos
- [ ] Comunicaciones
- [ ] Servicios externos
- [ ] **Zonas de confianza**
- [ ] **Componentes de seguridad**

---

## 2. Clasificación de información

Tipos a analizar como **mínimo**:

- [ ] credenciales
- [ ] datos personales
- [ ] direcciones
- [ ] información de pedidos
- [ ] inventario
- [ ] información relacionada con pagos
- [ ] tokens de sesión
- [ ] registros de auditoría
- [ ] claves criptográficas

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

- [ ] protocolo utilizado
- [ ] función de TLS
- [ ] certificados digitales
- [ ] autenticación del servidor
- [ ] confidencialidad
- [ ] integridad

> ⚠️ El enunciado lo dice explícitamente: **no basta con escribir "Se utiliza HTTPS"**. Hay
> que explicar *qué problema resuelve* HTTPS/TLS.

### 3.2 Comunicación entre microservicios

Dos tramos: **API Gateway → microservicios** y **microservicio → microservicio**.

Mecanismos a considerar: TLS, mTLS, tokens, certificados, rotación de credenciales.

- [ ] Justificar **qué comunicaciones requieren autenticación mutua** (y cuáles no)

### 3.3 API REST — caso `POST /pedido`

- [ ] confidencialidad
- [ ] integridad
- [ ] autenticación
- [ ] autorización
- [ ] protección frente a repetición (*replay*)
- [ ] manejo de tokens
- [ ] qué información debe viajar cifrada
- [ ] qué información **no debería enviarse** innecesariamente

### 3.4 Protección de datos almacenados

- [ ] cifrado en reposo
- [ ] cifrado de discos / almacenamiento
- [ ] cifrado de respaldos
- [ ] separación de claves y datos
- [ ] administración de secretos

**Pregunta central a responder:** ¿por qué no basta con proteger la conexión HTTPS si la
base de datos puede ser comprometida?

### 3.5 Contraseñas

- [ ] Diferenciar **cifrado** vs **hash** vs **salt** vs **función de derivación de contraseña**
- [ ] Explicar por qué **no** deben almacenarse con cifrado reversible

### 3.6 Gestión de claves criptográficas

Ciclo de vida completo:

- [ ] generación
- [ ] almacenamiento
- [ ] acceso
- [ ] rotación
- [ ] revocación
- [ ] respaldo
- [ ] eliminación

- [ ] Explicar por qué las claves **no** van dentro del código fuente
- [ ] Proponer KMS / HSM / Secret Manager (o equivalente)

### 3.7 Pasarela de pagos

Flujo **Usuario → ReMarket → Pasarela**:

- [ ] qué datos recibe ReMarket
- [ ] qué datos debe manejar **directamente la pasarela**
- [ ] qué información **no debería almacenarse** nunca
- [ ] qué comunicaciones hay que proteger
- [ ] cómo verificar que una respuesta viene de verdad del proveedor

**Caso obligatorio — webhook `POST /payment-confirmed`:** ¿cómo evita ReMarket que un
atacante mande una solicitud falsa diciendo que un pedido fue pagado?

- [ ] Proponer mecanismos de verificación

### 3.8 Firmas digitales e integridad (facturas y comprobantes)

- [ ] Mecanismo para detectar modificaciones posteriores
- [ ] Uso de funciones hash
- [ ] Uso de firmas digitales
- [ ] Uso de certificados
- [ ] Describir el flujo: **Documento → Hash → Firma → Verificación**
- [ ] Explicar por qué **firmar un documento no es cifrarlo**

### 3.9 Comunicación asíncrona (cola de eventos)

Ejemplo: *Pedido creado → evento → servicio de notificaciones*.

- [ ] autenticación del productor
- [ ] autenticación del consumidor
- [ ] protección del canal
- [ ] integridad del evento
- [ ] permisos mínimos

**Pregunta:** ¿qué podría ocurrir si un atacante publicara mensajes falsos en la cola?

---

## 4. Pipeline DevSecOps

Flujo base: *Desarrollador → Repositorio Git → Build → Pruebas → Análisis de seguridad →
Creación de imagen → Despliegue*.

Controles mínimos, **y en qué punto del pipeline va cada uno**:

- [ ] revisión de código
- [ ] análisis estático (SAST)
- [ ] análisis de dependencias (SCA)
- [ ] detección de secretos
- [ ] análisis de imágenes de contenedores
- [ ] pruebas automatizadas
- [ ] control de acceso
- [ ] manejo seguro de secretos
- [ ] aprobación antes de producción

---

## 5. Seguridad de contenedores y microservicios

Controles para reducir el impacto de la vulneración de **un** microservicio:

- [ ] mínimo privilegio
- [ ] segmentación
- [ ] aislamiento
- [ ] actualización de imágenes
- [ ] cuentas de servicio
- [ ] secretos
- [ ] permisos de red

**Pregunta obligatoria:** si el microservicio de **catálogo** es comprometido, ¿por qué no
debería poder consultar directamente la base de datos de **usuarios** o de **pagos**?

---

## 6. Evaluación de riesgos

**Al menos tres riesgos**, con **uno por cada categoría** como mínimo:

- [ ] credenciales
- [ ] comunicaciones
- [ ] almacenamiento
- [ ] disponibilidad
- [ ] cadena de suministro / pipeline

Opcionales: APIs, microservicios, terceros, pagos, configuraciones cloud.

Tabla por riesgo: `Riesgo | Activo | Amenaza | Vulnerabilidad | Impacto | Probabilidad | Nivel`

Escala: **Alto = 3 · Medio = 2 · Bajo = 1**
Cálculo: **Nivel de riesgo = Impacto × Probabilidad**
Clasificación: **6–9 Alto · 3–4 Medio · 1–2 Bajo**

Para los riesgos más importantes, definir **tratamiento**:

- [ ] control **preventivo**
- [ ] control **detectivo**
- [ ] control **correctivo**
- [ ] clasificar como mitigación / evitación / transferencia / aceptación
- [ ] **relacionar cada control con un riesgo identificado**

---

## 7. Disponibilidad y continuidad

- [ ] balanceo de carga
- [ ] autoescalado
- [ ] redundancia
- [ ] múltiples zonas de disponibilidad
- [ ] respaldo
- [ ] replicación
- [ ] recuperación ante fallos

- [ ] Elegir **tres servicios críticos** y definir **RTO** y **RPO** para cada uno
- [ ] **Justificar** los valores elegidos

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

- [ ] contexto
- [ ] falsos positivos
- [ ] configuración real del sistema
- [ ] impacto operativo
- [ ] gestión de riesgos
- [ ] responsabilidad humana

### 8.4 Evidencia requerida en el informe

- [ ] el **prompt** utilizado
- [ ] un **fragmento relevante** de la respuesta de la IA
- [ ] nuestro **análisis crítico**
- [ ] la **decisión final** del equipo

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
