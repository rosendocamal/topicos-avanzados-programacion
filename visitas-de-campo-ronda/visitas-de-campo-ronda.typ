#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/cetz:0.5.2": canvas, draw, vector

#let C-BLUE = rgb("#dbe5f1")
#let C-BLUE-S = rgb("#2e4a7d")
#let C-GREEN = rgb("#e2efda")
#let C-GREEN-S = rgb("#548235")
#let C-ORANGE = rgb("#fce4d6")
#let C-ORANGE-S = rgb("#c55a11")
#let C-GREY = rgb("#f4f4f4")
#let C-GREY-S = rgb("#808080")
#let C-INK = rgb("#404040")

#let arq-ronda() = canvas({
  import draw: *
  let box(x, y, w, h, name, fill, st, body) = {
    rect((x, y), (x + w, y + h), name: name, fill: fill,
      stroke: (paint: st, thickness: 0.7pt), radius: 2pt)
    if body != none { content((x + w / 2, y + h / 2), text(size: 7.5pt, body)) }
  }
  let arrow(a, b) = line(a, b, mark: (end: (symbol: ">", scale: 0.7)),
    stroke: (paint: C-INK, thickness: 0.7pt))
  box(0, 0.4, 4.4, 4.2, "dev", C-GREY, C-GREY-S, none)
  content((2.2, 4.35), text(size: 7.5pt, weight: "bold")[Dispositivo])
  box(0.3, 3.3, 3.8, 0.7, "scr", C-BLUE, C-BLUE-S, [Pantallas (Flet)])
  box(0.3, 2.0, 3.8, 0.7, "db", C-GREEN, C-GREEN-S, [Base local (sqlite3)])
  box(0.3, 0.7, 3.8, 0.7, "que", C-ORANGE, C-ORANGE-S, [Cola de sincronización])
  box(5.0, 0.7, 2.1, 0.7, "srv", C-BLUE, C-BLUE-S, [Servicio central])
  arrow((2.2, 3.3), (2.2, 2.7))
  arrow((2.2, 2.0), (2.2, 1.4))
  arrow((4.1, 1.2), (5.0, 1.2))
  arrow((5.0, 0.9), (4.1, 0.9))
})

#let er-ronda() = canvas({
  import draw: *
  let ent(x, y, w, h, id, title, body) = {
    rect((x, y), (x + w, y + h), name: id, fill: white,
      stroke: (paint: C-BLUE-S, thickness: 0.7pt), radius: 2pt)
    rect((x, y + h - 0.32), (x + w, y + h), fill: C-BLUE,
      stroke: (paint: C-BLUE-S, thickness: 0.7pt))
    content((x + w / 2, y + h - 0.16), text(size: 7pt, weight: "bold", title))
    content((x + w / 2, y + (h - 0.32) / 2), text(size: 6.2pt, body))
  }
  let st = (paint: C-INK, thickness: 0.6pt)
  let rel(a, b) = {
    line(a, b, stroke: st)
    let d = vector.norm(vector.sub(b, a))
    let perp = (-d.at(1), d.at(0))
    let base = vector.sub(b, vector.scale(d, 0.30))
    line(base, b, stroke: st)
    line(base, vector.add(b, vector.scale(perp, 0.15)), stroke: st)
    line(base, vector.sub(b, vector.scale(perp, 0.15)), stroke: st)
    let bar = vector.add(a, vector.scale(d, 0.18))
    line(vector.add(bar, vector.scale(perp, 0.12)),
         vector.sub(bar, vector.scale(perp, 0.12)), stroke: st)
  }
  ent(0.3, 2.4, 3.2, 1.1, "Visita", [Visita], [id, cliente, fecha, estado])
  ent(4.2, 2.4, 3.2, 1.1, "Evidencia", [Evidencia], [id, visita, tipo, ruta])
  ent(0.3, 0.6, 3.2, 1.1, "Cambio", [Cambio], [id, visita, operación, estado])
  rel((3.5, 2.95), (4.2, 2.95))
  rel((1.9, 2.4), (1.9, 1.7))
})

#let seq-ronda() = canvas({
  import draw: *
  let actor(x, y, id, title) = {
    rect((x, y), (x + 2.6, y + 0.7), name: id, fill: C-BLUE,
      stroke: (paint: C-BLUE-S, thickness: 0.7pt), radius: 2pt)
    content((x + 1.3, y + 0.35), text(size: 7.5pt, weight: "bold", title))
  }
  let msg(y, a, b, label) = {
    line((a, y), (b, y), mark: (end: (symbol: ">", scale: 0.7)), stroke: (paint: C-INK, thickness: 0.7pt))
    content(((a + b) / 2, y + 0.18), text(size: 6.2pt, label))
  }
  actor(0.4, 4.0, "dev", [Dispositivo])
  actor(4.0, 4.0, "srv", [Servicio])
  line((1.7, 4.0), (1.7, 0.4), stroke: (paint: C-GREY-S, thickness: 0.5pt))
  line((5.3, 4.0), (5.3, 0.4), stroke: (paint: C-GREY-S, thickness: 0.5pt))
  msg(3.3, 1.7, 5.3, [Enviar cambios pendientes])
  msg(2.6, 5.3, 1.7, [Confirmar recepción])
  msg(1.9, 1.7, 5.3, [Solicitar agenda])
  msg(1.2, 5.3, 1.7, [Agenda actualizada])
})

#let bt(columns, header, ..rows) = table(
  columns: columns,
  stroke: none,
  inset: (x: 5pt, y: 3.5pt),
  align: left,
  table.hline(stroke: 0.9pt),
  table.header(..header),
  table.hline(stroke: 0.5pt),
  ..rows,
  table.hline(stroke: 0.9pt),
)

// Portada
#set page(paper: "us-letter", margin: (x: 1.1in, y: 1.2in), numbering: none)
#set text(font: "TeX Gyre Termes", size: 12pt)
#set par(justify: false)

#align(center)[
  #v(2.6cm)
  #text(size: 12.5pt, tracking: 0.06em)[#smallcaps[Tópicos Avanzados de Programación]]
  #v(4.2cm)
  #text(size: 32pt, weight: 700)[Ronda]
  #v(0.7cm)
  #line(length: 45%, stroke: 0.6pt)
  #v(0.7cm)
  #text(size: 15pt, style: "italic")[Aplicación móvil de visitas para personal de campo]
  #v(4.8cm)
  #text(size: 12pt)[13 de noviembre de 2026]
]

#pagebreak()

// Cuerpo IEEE
#set figure(supplement: [Tabla])
#show figure.where(kind: table): fig => {
  let numbers = numbering(fig.numbering, ..fig.counter.at(fig.location()))
  show figure.caption: it => block[Tabla~#numbers#it.separator#it.body]
  fig
}
#show: ieee.with(
  title: block(width: 100%, align(center)[Ronda: aplicación móvil de visitas para personal de campo]),
  abstract: [
    Ronda permite registrar visitas de campo desde un dispositivo móvil, incluso sin conexión. El operador consulta su agenda, abre el detalle de una visita, registra el resultado y adjunta evidencia fotográfica o de audio. La información se conserva en una base local y se sincroniza con el servicio central al recuperar la señal. La aplicación se distribuye como paquete instalable para Android.
  ],
  index-terms: (
    "aplicación móvil",
    "operación sin conexión",
    "sincronización",
    "base de datos local",
    "servicio central",
  ),
)

= Introducción

El personal de campo trabaja en zonas donde la cobertura es intermitente o inexistente, de modo que los registros de visita no pueden depender de una conexión permanente. Cuando la captura exige conexión, el operador difiere la anotación y pierde evidencia o exactitud. Ronda cubre ese vacío con una aplicación móvil que registra las visitas en el dispositivo y las sincroniza con el servicio central cuando la señal se restablece.

La aplicación se destina a organizaciones cuyos operadores trabajan en terreno y necesitan conservar el registro de cada visita. El alcance comprende el registro, la evidencia, el almacenamiento local y la sincronización. Quedan fuera del alcance la planificación de rutas, la geolocalización continua y la gestión administrativa de clientes en el servicio central. El dispositivo opera de forma autónoma durante la jornada y sincroniza al final del recorrido o cuando recupera la señal.

= Actores y responsabilidades

La aplicación distingue dos roles. El operador de campo inicia sesión, consulta su agenda, registra el resultado de cada visita y adjunta evidencia. El desarrollador construye la aplicación, define el modelo local, implementa la sincronización y empaqueta el artefacto instalable.

= Flujos de operación

Los flujos describen la secuencia de acciones que la aplicación admite en cada operación.

== Registro de una visita

El operador abre una visita pendiente, registra el resultado y la marca como atendida. El cambio se conserva en el dispositivo aunque no exista conexión. El resultado queda asociado a la visita y alimenta la agenda local hasta su sincronización.

== Adjuntar evidencia

El operador captura una fotografía o graba una nota de voz y la asocia a la visita. La evidencia queda almacenada en el dispositivo a la espera de su envío. Cada evidencia se identifica por su tipo y su ubicación en el almacenamiento local, de modo que pueda transmitirse junto con la visita.

== Sincronización

Al recuperar la señal, los cambios pendientes se envían al servicio central y la agenda se actualiza con los datos remotos. El intercambio se repite para cada cambio pendiente y la cola se vacía a medida que el servicio confirma la recepción.

= Reglas de negocio

Las reglas de negocio fijan las condiciones que toda operación debe satisfacer.

- Cada visita pertenece a un cliente y a un operador.
- Una visita atendida requiere un resultado registrado.
- La evidencia se asocia a una única visita.
- La agenda del operador refleja los datos sincronizados más recientes.

= Reglas internas

Las reglas internas rigen el almacenamiento local y la sincronización.

- La aplicación opera sin conexión y conserva los cambios en una cola de sincronización.
- Cada cambio local se envía una sola vez al servicio central.
- Los datos se almacenan en una base local del dispositivo.
- La interfaz se adapta a la orientación y al tamaño de la pantalla.

= Arquitectura

La aplicación se ejecuta en el dispositivo, donde residen las pantallas, la base local y la cola de sincronización. Las pantallas escriben en la base local y cada modificación se acumula en la cola de sincronización. Cuando la conexión se restablece, la cola envía los cambios al servicio central y la agenda se actualiza con la respuesta. La @fig:arq representa estos componentes y el sentido de los intercambios.

#figure(arq-ronda(), caption: [Arquitectura de Ronda], placement: top) <fig:arq>

= Modelo de datos

El modelo local conserva las visitas, su evidencia y los cambios pendientes de envío. La @fig:er presenta las entidades y su cardinalidad; la @tab:entidades detalla los atributos principales de cada una.

#figure(er-ronda(), caption: [Modelo de datos de Ronda], placement: top) <fig:er>

Una visita reúne varias evidencias. La entidad Cambio registra cada modificación local a la espera de su envío; el conjunto de estos registros forma la cola de sincronización.

#figure(
  bt(
    (auto, 1fr),
    ([Entidad], [Atributos principales]),
    [Visita], [identificador, cliente, operador, fecha, estado, resultado],
    [Evidencia], [identificador, visita, tipo, ruta],
    [Cambio], [identificador, visita, operación, estado],
  ),
  caption: [Entidades del modelo de Ronda],
  placement: none,
) <tab:entidades>

= Pantallas y navegación

La aplicación se organiza en cuatro pantallas. La pantalla de acceso solicita las credenciales y conserva la sesión en el dispositivo; la agenda lista las visitas asignadas con su estado; el detalle reúne el registro del resultado, la evidencia y el cambio pendiente de envío, y el perfil muestra los datos del operador. La navegación entre pantallas emplea transiciones y la disposición de los controles se ajusta a la orientación del dispositivo.

= Operación sin conexión

La agenda y las visitas se conservan en una base local. Los cambios se acumulan en la cola de sincronización y se envían al servicio central cuando la conexión se restablece. Las fotografías y las notas de voz se asocian a la visita y se transmiten junto con los cambios. La @fig:seq describe el intercambio entre el dispositivo y el servicio.

#figure(seq-ronda(), caption: [Secuencia de sincronización], placement: top) <fig:seq>

El dispositivo envía los cambios pendientes, recibe la confirmación, solicita la agenda y la actualiza con la respuesta del servicio. La cola retira cada cambio una vez confirmado, de modo que una interrupción de la conexión no duplica el envío.

= Tecnologías

La aplicación se construye con `Flet` sobre Python y se empaqueta para Android. La persistencia local emplea el módulo `sqlite3`. El acceso al servicio central usa `requests`. La captura de fotografías y audio se apoya en `plyer` y el tratamiento de imágenes en `Pillow`.

= Plan de desarrollo

El plan se organiza en seis fases, cada una con un producto verificable y su criterio de aceptación (véase la @tab:fases).

#figure(
  bt(
    (auto, 1fr),
    ([Fase], [Producto y criterio de aceptación]),
    [Fundamentos], [Proyecto y entorno aislado; la aplicación se ejecuta en el dispositivo.],
    [Dominio], [Modelo local y reglas; las visitas y la evidencia se conservan sin conexión.],
    [Interacción], [Pantallas y navegación; los flujos se completan en pantalla táctil.],
    [Sincronización], [Servicio central y cola de cambios; los datos se envían una sola vez y la agenda se actualiza.],
    [Calidad], [Pruebas y paquete; el artefacto se instala en el dispositivo.],
    [Entrega], [Paquete instalable; el proyecto se reconstruye desde el código fuente y se instala en el dispositivo.],
  ),
  caption: [Fases del plan de desarrollo],
  placement: none,
) <tab:fases>

= Requisitos académicos

El programa exige acreditar cada módulo con una evidencia verificable en la aplicación.

== Programación de dispositivos móviles

El módulo se acredita con las evidencias siguientes.

- *Arquitectura de la aplicación.* Se estructura la aplicación con su clase principal y su ciclo de vida, y se muestra una pantalla adaptada al tamaño móvil.
- *Disposición adaptable.* Se organizan los controles con contenedores flexibles que se ajustan a la resolución y a la orientación; se construye la pantalla de acceso.
- *Separación de interfaz y lógica.* Se separa el diseño visual del código de control y se conectan los eventos a sus funciones.
- *Navegación entre pantallas.* Se manejan varias vistas con transiciones, incluidas agenda, detalle y perfil.
- *Eventos táctiles y gestos.* Se captura el toque inicial, el arrastre y la liberación para trazar líneas con el dedo.
- *Listas desplazables.* Se muestra una colección extensa con desplazamiento suave sin congelar la pantalla.
- *Consumo de servicios web.* Se obtienen y envían datos en formato JSON mediante peticiones asíncronas (`requests` o `httpx`).
- *Base de datos local.* Se almacena la información de forma persistente en el dispositivo con SQLite (`sqlite3`).
- *Hardware y multimedia.* Se captura una fotografía y se reproduce audio local, con acceso a sensores si se requiere (`plyer`; `Pillow` si se procesan fotografías).
- *Empaquetado.* Se configura la compilación con los permisos necesarios y se genera el paquete instalable para Android.

= Entregables

La entrega comprende los artefactos siguientes.

- Paquete instalable para Android.
- Aplicación operativa sin conexión.
- Sincronización con el servicio central.
- Base local inicializada con las tablas del modelo.

= Referencias

#set enum(numbering: "[1]")

+ Flet. Documentación oficial. #link("https://flet.dev/docs/")
+ sqlite3. Documentación de Python. #link("https://docs.python.org/3/library/sqlite3.html")
+ requests. Documentación oficial. #link("https://requests.readthedocs.io/")
+ httpx. Documentación oficial. #link("https://www.python-httpx.org/")
+ plyer. Documentación oficial. #link("https://plyer.readthedocs.io/")
+ Pillow. Documentación oficial. #link("https://pillow.readthedocs.io/")
