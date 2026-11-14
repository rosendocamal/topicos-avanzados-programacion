#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/cetz:0.5.2": canvas, draw, vector

#let C-BLUE = rgb("#dbe5f1")
#let C-BLUE-S = rgb("#2e4a7d")
#let C-GREEN = rgb("#e2efda")
#let C-GREEN-S = rgb("#548235")
#let C-ORANGE = rgb("#fce4d6")
#let C-ORANGE-S = rgb("#c55a11")
#let C-GREY-S = rgb("#808080")
#let C-INK = rgb("#404040")

#let arq-mostrador() = canvas({
  import draw: *
  let box(x, y, w, h, name, fill, st, body) = {
    rect((x, y), (x + w, y + h), name: name, fill: fill,
      stroke: (paint: st, thickness: 0.7pt), radius: 2pt)
    if body != none { content((x + w / 2, y + h / 2), text(size: 7.5pt, body)) }
  }
  let arrow(a, b) = line(a, b, mark: (end: (symbol: ">", scale: 0.7)),
    stroke: (paint: C-INK, thickness: 0.7pt))
  box(0, 5.2, 5.5, 0.7, "ui", C-BLUE, C-BLUE-S, [Interfaz de usuario])
  box(0, 4.0, 5.5, 0.7, "log", C-GREEN, C-GREEN-S, [Lógica de negocio])
  box(0, 2.4, 5.5, 1.1, "dat", C-ORANGE, C-ORANGE-S, none)
  content((2.75, 3.25), text(size: 7.5pt)[Capa de acceso a datos])
  box(0.2, 2.5, 2.5, 0.6, "raw", white, C-GREY-S, [sqlite3])
  box(2.8, 2.5, 2.5, 0.6, "orm", white, C-GREY-S, [SQLAlchemy])
  box(0, 0.9, 5.5, 0.7, "db", C-BLUE, C-BLUE-S, [Base de datos SQLite])
  box(6.1, 2.4, 1.6, 1.1, "rep", C-GREEN, C-GREEN-S, [Reportes])
  arrow("ui.south", "log.north")
  arrow("log.south", "dat.north")
  arrow("dat.south", "db.north")
  arrow("rep.west", "dat.east")
})

#let er-mostrador() = canvas({
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
  ent(2.7, 2.9, 2.2, 1.0, "Usuarios", [Usuarios], [id, nombre, rol])
  ent(0, 1.3, 2.2, 1.0, "Clientes", [Clientes], [id, nombre, correo])
  ent(2.7, 1.3, 2.2, 1.0, "Pedidos", [Pedidos], [id, fecha, total])
  ent(5.4, 1.3, 2.2, 1.0, "Detalle", [Detalle], [id, cantidad, subtotal])
  ent(5.4, 2.9, 2.2, 1.0, "Productos", [Productos], [id, nombre, precio])
  rel((2.2, 1.8), (2.7, 1.8))
  rel((4.9, 1.8), (5.4, 1.8))
  rel((6.5, 2.9), (6.5, 2.3))
  rel((3.8, 2.9), (3.8, 2.3))
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
  #text(size: 32pt, weight: 700)[Mostrador]
  #v(0.7cm)
  #line(length: 45%, stroke: 0.6pt)
  #v(0.7cm)
  #text(size: 15pt, style: "italic")[Punto de venta para cafetería]
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
  title: block(width: 100%, align(center)[Mostrador: punto de venta para cafetería]),
  abstract: [
    Mostrador organiza la operación diaria de una cafetería. El cajero registra pedidos, los cobra y emite un comprobante; el administrador mantiene el catálogo, el personal y los precios, y consulta el desempeño del negocio. La información se conserva en una base relacional, los reportes se derivan de los datos de venta y el acceso se restringe según el rol. La aplicación se construye con Python y Flet sobre una capa de datos que combina acceso directo a SQLite y un mapeo objeto-relacional.
  ],
  index-terms: (
    "punto de venta",
    "aplicación de escritorio",
    "SQLite",
    "mapeo objeto-relacional",
    "análisis de datos",
    "control de acceso",
  ),
)

= Introducción

La operación de una cafetería pequeña suele apoyarse en registros manuales o en hojas de cálculo que retrasan el cierre diario y dificultan la trazabilidad del inventario. Cuando varias personas atienden el mostrador, la venta y el control de existencias se descoordinan, y las cifras del negocio se reconstruyen al final de la jornada con errores. Mostrador cubre ese vacío con una aplicación de escritorio que centraliza la venta, el catálogo y los reportes en una base de datos local.

La aplicación se destina a establecimientos que necesitan registrar cada venta y disponer de cifras propias sin depender de herramientas externas. El alcance comprende la venta y el cobro, la administración del catálogo, el control de acceso por rol y la generación de reportes. Quedan fuera del alcance la facturación electrónica, la integración con medios de pago y la operación en red entre varios equipos. En una jornada típica, el cajero alterna entre cobros consecutivos y consultas al catálogo, mientras el administrador revisa al cierre el consolidado del día.

= Actores y responsabilidades

La aplicación distingue tres roles. El cajero inicia sesión, consulta el catálogo, arma el pedido, lo cobra y emite el comprobante; su acceso se limita a la operación de venta. El administrador gestiona usuarios, productos y precios, consulta los reportes y dispone además de las funciones del cajero. El desarrollador construye la aplicación, define la base de datos, implementa los reportes y garantiza la integridad de las operaciones.

= Flujos de operación

Los flujos describen la secuencia de acciones que la aplicación admite en cada operación.

== Venta y cobro

El cajero selecciona los productos y la aplicación totaliza el pedido con los precios vigentes. Confirmado el pago, se emite el comprobante y se descuentan las existencias en la misma operación, de modo que el inventario refleje la venta sin intervención adicional. El comprobante reúne los productos, las cantidades y el total, y queda asociado al pedido para su consulta posterior.

== Administración del catálogo

El administrador registra un producto nuevo o modifica uno existente; asigna nombre, precio y existencias, y adjunta una imagen. Los cambios quedan disponibles para la venta en cuanto se confirman.

== Cierre y reportes

El administrador consulta el total vendido por cliente, el producto más vendido y el consolidado del periodo. Los reportes se calculan a partir de las ventas registradas, sin captura adicional.

= Reglas de negocio

Las reglas de negocio fijan las condiciones que toda operación debe satisfacer para conservar la consistencia de los datos.

- Una venta no se registra si algún producto carece de existencias.
- Una venta se aplica de forma atómica: se ejecutan todos sus efectos o ninguno.
- Solo el administrador modifica precios, productos y usuarios.
- Las existencias se descuentan al confirmar la venta.

= Reglas internas

Las reglas internas rigen la implementación y la seguridad de la aplicación.

- Las contraseñas se almacenan como resumen criptográfico, nunca en texto claro.
- Toda consulta se ejecuta con parámetros, sin concatenación de cadenas.
- Las operaciones que afectan varias tablas se ejecutan dentro de una transacción.
- La interfaz se actualiza sin bloquear el hilo principal.
- El acceso a cada panel depende del rol autenticado.

= Arquitectura

La aplicación se organiza en tres capas: la interfaz, la lógica de negocio y el acceso a datos. La capa de datos expone dos vías sobre el mismo motor: el acceso directo mediante el módulo `sqlite3` y el mapeo objeto-relacional de `SQLAlchemy`. Los reportes leen de la base sin atravesar la interfaz, lo que mantiene separada la operación de la consulta. La @fig:arq resume esta disposición y el sentido de las dependencias entre capas.

#figure(arq-mostrador(), caption: [Arquitectura por capas de Mostrador], placement: top) <fig:arq>

= Modelo de datos

El modelo relacional conserva las entidades del negocio y sus relaciones. La @fig:er presenta las entidades y la cardinalidad de sus vínculos; la @tab:entidades detalla los atributos principales de cada una.

#figure(er-mostrador(), caption: [Modelo de datos de Mostrador], placement: top) <fig:er>

Un cliente registra varios pedidos; un pedido contiene varias líneas de detalle, y un producto aparece en varias de esas líneas. Un usuario registra varios pedidos. La integridad se sostiene con claves foráneas entre el pedido y sus líneas.

#figure(
  bt(
    (auto, 1fr),
    ([Entidad], [Atributos principales]),
    [Usuarios], [identificador, nombre, rol, resumen de contraseña],
    [Productos], [identificador, nombre, precio, existencias, imagen],
    [Clientes], [identificador, nombre, correo],
    [Pedidos], [identificador, fecha, cliente, total],
    [Detalle], [identificador, pedido, producto, cantidad, subtotal],
  ),
  caption: [Entidades del modelo de Mostrador],
  placement: none,
) <tab:entidades>

= Reportes y analítica

Los reportes se obtienen del cruce de las tablas de clientes, pedidos y detalle. El total gastado por cliente permite reconocer a los compradores frecuentes; el producto más vendido orienta la reposición de existencias; las ventas por periodo muestran la evolución del negocio, y las estadísticas descriptivas (promedio, máximo y mínimo) resumen el tamaño de cada operación. El producto más vendido surge de agregar las líneas de detalle por producto y ordenarlas por cantidad, y las ventas por periodo agrupan los pedidos por su fecha. Las cifras se derivan de los datos registrados, por lo que no requieren captura ni ajuste manual, y su cálculo se apoya en consultas de agregación sobre las tablas de venta.

= Tecnologías

La interfaz se construye con `Flet` sobre Python. La persistencia combina el módulo `sqlite3` para el acceso directo y `SQLAlchemy` para el mapeo objeto-relacional. El análisis tabular se realiza con `pandas`, el tratamiento de imágenes con `Pillow` y la importación o exportación de hojas de cálculo con `openpyxl`. Las dependencias se gestionan con `Poetry`. La combinación de acceso directo y mapeo objeto-relacional permite usar consultas SQL en los reportes y clases en el dominio sobre el mismo motor de datos.

= Plan de desarrollo

El plan se organiza en seis fases, cada una con un producto verificable y su criterio de aceptación (véase la @tab:fases).

#figure(
  bt(
    (auto, 1fr),
    ([Fase], [Producto y criterio de aceptación]),
    [Fundamentos], [Proyecto y entorno aislado; la aplicación arranca y muestra la pantalla de acceso.],
    [Dominio], [Modelo relacional y reglas; la venta y el inventario se actualizan de forma consistente.],
    [Interacción], [Pantallas y navegación; el cajero completa una venta y el administrador gestiona el catálogo.],
    [Procesos], [Reportes y analítica; las cifras coinciden con los datos de venta.],
    [Calidad], [Pruebas y empaquetado; el flujo de venta se cubre con pruebas.],
    [Entrega], [Aplicación y base de datos; el proyecto se reconstruye desde el código fuente y arranca.],
  ),
  caption: [Fases del plan de desarrollo],
  placement: none,
) <tab:fases>

= Requisitos académicos

El programa exige acreditar cada módulo con una evidencia verificable en la aplicación.

== Programación de interfaces gráficas

El módulo se acredita con las evidencias siguientes.

- *Primer componente.* Se muestra un texto en la ventana y se modifica desde el código.
- *Controles básicos.* Se construye un formulario con campos de texto, botones y etiquetas, con validación de entrada.
- *Eventos.* Se responde a la pulsación de un botón y se actualiza la interfaz en consecuencia.
- *Disposición.* Se organizan los controles con filas y columnas que se adaptan al tamaño de la ventana.
- *Listas y tablas.* Se muestran colecciones de datos en tablas con selección de fila.
- *Diálogos.* Se abre un cuadro de diálogo para confirmar una acción o capturar un dato.
- *Formularios y validación.* Se valida el contenido de los campos y se informa el error al usuario.
- *Navegación.* Se alternan varias vistas o paneles dentro de la misma ventana.
- *Galería de imágenes.* Se muestran imágenes del catálogo con recorte y ajuste.
- *Reportes.* Se presenta el resultado de una consulta en una vista con exportación a hoja de cálculo (`pandas`, `openpyxl`).

== Acceso a datos

El módulo se acredita con las evidencias siguientes.

- *Conexión.* Se abre y cierra una base SQLite desde Python (`sqlite3`).
- *Creación de tablas.* Se definen las tablas del modelo con sus claves.
- *Inserción.* Se registran filas con parámetros, sin concatenación de cadenas.
- *Consulta.* Se recuperan filas con filtros y ordenamiento.
- *Actualización y borrado.* Se modifican y eliminan filas por clave.
- *Consultas con agregación.* Se calculan totales, promedios y máximos sobre las ventas.
- *Consultas con unión.* Se cruzan pedidos y detalle para obtener los productos vendidos.
- *Mapeo objeto-relacional.* Se modelan las entidades como clases con `SQLAlchemy`.
- *Transacciones.* Se agrupan varias operaciones y se revierte ante un error.
- *Seguridad.* Se almacenan las contraseñas como resumen criptográfico (`hashlib`).

= Entregables

La entrega comprende los artefactos siguientes.

- Aplicación de escritorio con los flujos de venta y administración.
- Base de datos inicializada con el modelo y datos de prueba.
- Conjunto de reportes con su exportación.
- Suite de pruebas del flujo de venta.

= Referencias

#set enum(numbering: "[1]")

+ Flet. Documentación oficial. #link("https://flet.dev/docs/")
+ sqlite3. Documentación de Python. #link("https://docs.python.org/3/library/sqlite3.html")
+ SQLAlchemy. Documentación oficial. #link("https://docs.sqlalchemy.org/")
+ pandas. Documentación oficial. #link("https://pandas.pydata.org/docs/")
+ Pillow. Documentación oficial. #link("https://pillow.readthedocs.io/")
+ openpyxl. Documentación oficial. #link("https://openpyxl.readthedocs.io/")
+ Poetry. Documentación oficial. #link("https://python-poetry.org/docs/")
+ hashlib. Documentación de Python. #link("https://docs.python.org/3/library/hashlib.html")
