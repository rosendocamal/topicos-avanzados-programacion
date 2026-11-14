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

#let arq-acopio() = canvas({
  import draw: *
  let box(x, y, w, h, name, fill, st, body) = {
    rect((x, y), (x + w, y + h), name: name, fill: fill,
      stroke: (paint: st, thickness: 0.7pt), radius: 2pt)
    if body != none { content((x + w / 2, y + h / 2), text(size: 7.5pt, body)) }
  }
  let arrow(a, b) = line(a, b, mark: (end: (symbol: ">", scale: 0.7)),
    stroke: (paint: C-INK, thickness: 0.7pt))
  box(0, 5.2, 5.5, 0.7, "ui", C-BLUE, C-BLUE-S, [Interfaz (hilo principal)])
  box(0.2, 4.0, 2.5, 0.7, "in", C-ORANGE, C-ORANGE-S, [Cola de tareas])
  box(2.8, 4.0, 2.5, 0.7, "out", C-ORANGE, C-ORANGE-S, [Cola de resultados])
  box(0, 2.3, 5.5, 1.3, "pool", C-GREEN, C-GREEN-S, none)
  content((2.75, 3.4), text(size: 7.5pt)[Grupo de hilos])
  box(0.2, 2.4, 2.5, 0.6, "sem", white, C-GREY-S, [Semáforo])
  box(2.8, 2.4, 2.5, 0.6, "lock", white, C-GREY-S, [Bloqueo])
  box(0, 0.9, 5.5, 0.7, "proc", C-BLUE, C-BLUE-S, [Procesos (cálculo intensivo)])
  arrow((1.45, 5.2), (1.45, 4.7))
  arrow((1.45, 4.0), (1.45, 3.6))
  arrow((4.05, 3.6), (4.05, 4.0))
  arrow((4.05, 4.7), (4.05, 5.2))
  arrow((2.75, 2.3), (2.75, 1.6))
})

#let er-acopio() = canvas({
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
  let rel-opt(a, b) = {
    line(a, b, stroke: st)
    let d = vector.norm(vector.sub(b, a))
    let perp = (-d.at(1), d.at(0))
    let bar = vector.add(a, vector.scale(d, 0.18))
    line(vector.add(bar, vector.scale(perp, 0.12)),
         vector.sub(bar, vector.scale(perp, 0.12)), stroke: st)
    let bar2 = vector.sub(b, vector.scale(d, 0.18))
    line(vector.add(bar2, vector.scale(perp, 0.12)),
         vector.sub(bar2, vector.scale(perp, 0.12)), stroke: st)
    circle(vector.sub(b, vector.scale(d, 0.45)), radius: 0.1,
      stroke: st, fill: white)
  }
  ent(0.4, 2.2, 3.0, 1.1, "Tarea", [Tarea], [id, origen, estado, avance])
  ent(4.4, 2.2, 3.0, 1.1, "Resultado", [Resultado], [id, tarea, verificador])
  rel-opt((3.4, 2.75), (4.4, 2.75))
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
  #text(size: 32pt, weight: 700)[Acopio]
  #v(0.7cm)
  #line(length: 45%, stroke: 0.6pt)
  #v(0.7cm)
  #text(size: 15pt, style: "italic")[Gestor de descargas y procesamiento por lotes]
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
  title: block(width: 100%, align(center)[Acopio: gestor de descargas y procesamiento por lotes]),
  abstract: [
    Acopio gestiona la descarga y el procesamiento de archivos pesados sin bloquear la interfaz. Las tareas se encolan, se ejecutan de forma concurrente, informan su avance y admiten pausa, reanudación y cancelación. El avance se comunica a la interfaz desde los hilos de trabajo mediante una cola. La herramienta se distribuye como paquete instalable con interfaz de línea de comandos.
  ],
  index-terms: (
    "concurrencia",
    "hilos",
    "sincronización",
    "cola de tareas",
    "interfaz de línea de comandos",
    "empaquetado",
  ),
)

= Introducción

La descarga y el procesamiento de lotes de archivos pesados suelen realizarse con herramientas que bloquean la interfaz mientras trabajan, de modo que la aplicación deja de responder y el operador pierde el control del avance. Cuando el lote es extenso o el cálculo es costoso, esa interrupción se vuelve un obstáculo para la operación. Acopio cubre ese vacío con una herramienta que encola las tareas y las ejecuta de forma concurrente sin detener la interfaz.

La herramienta se destina a quienes manejan lotes de archivos y requieren que la aplicación permanezca disponible durante el proceso. El alcance comprende el encolado, la ejecución concurrente, el control de las tareas y el registro de resultados. Quedan fuera del alcance la reanudación de descargas interrumpidas a nivel de protocolo y la administración remota del servicio. Mientras un lote se descarga, el operador puede seguir encolando tareas y consultar el avance sin que la ventana deje de responder.

= Actores y responsabilidades

La herramienta distingue dos roles. El operador encola tareas, supervisa el avance y pausa, reanuda o cancela la ejecución. El desarrollador construye el motor concurrente, define las políticas de ejecución y empaqueta la herramienta para su distribución.

= Flujos de operación

Los flujos describen la secuencia de acciones que la herramienta admite en cada operación.

== Encolado de tareas

El operador incorpora una lista de enlaces. Cada elemento se convierte en una tarea con estado pendiente y espera su turno en la cola. La cola conserva el orden de incorporación y admite nuevos elementos mientras otras tareas se ejecutan.

== Ejecución concurrente

Un número acotado de tareas se ejecuta a la vez, según la capacidad configurada. El avance de cada una se refleja en la interfaz a medida que los hilos de trabajo lo comunican. Al concluir una tarea, el grupo de hilos toma la siguiente de la cola, de modo que la capacidad se aprovecha de forma continua.

== Pausa, reanudación y cancelación

El operador suspende, reanuda o cancela una tarea. Una tarea pausada conserva el avance alcanzado y se reanuda desde ese punto. La cancelación detiene el trabajo sin cerrar la aplicación ni afectar a las tareas restantes.

= Reglas de negocio

Las reglas de negocio fijan las condiciones que toda operación debe satisfacer.

- La ejecución simultánea se limita a un número fijo de tareas.
- Una tarea cancelada no produce resultado.
- El avance se informa de forma continua.
- El resultado de cada tarea se conserva con su estado.

= Reglas internas

Las reglas internas rigen la sincronización y la comunicación entre los componentes.

- Los recursos compartidos se protegen con mecanismos de exclusión.
- La interfaz se actualiza desde el hilo principal; los hilos de trabajo comunican su avance por una cola.
- La cancelación se propaga mediante una bandera de parada.
- Las tareas de cálculo intensivo se ejecutan en procesos independientes.

= Arquitectura de concurrencia

La interfaz se ejecuta en el hilo principal. Las tareas entran por una cola y un grupo de hilos las toma una a una, con un semáforo que acota la concurrencia y un bloqueo que protege el estado compartido. El avance regresa por una segunda cola hasta la interfaz. Las tareas de cálculo intensivo se derivan a procesos, lo que evita el bloqueo global del intérprete. La @fig:arq resume esta disposición.

#figure(arq-acopio(), caption: [Arquitectura de concurrencia de Acopio], placement: top) <fig:arq>

= Modelo de datos

El modelo conserva las tareas y sus resultados. La @fig:er presenta las entidades y su cardinalidad; la @tab:entidades detalla los atributos principales de cada una.

#figure(er-acopio(), caption: [Modelo de datos de Acopio], placement: top) <fig:er>

Una tarea produce a lo sumo un resultado. El estado de la tarea recorre los valores pendiente, en curso, pausada, cancelada y concluida.

#figure(
  bt(
    (auto, 1fr),
    ([Entidad], [Atributos principales]),
    [Tarea], [identificador, origen, estado, avance, tiempo],
    [Resultado], [identificador, tarea, verificador, tamaño],
  ),
  caption: [Entidades del modelo de Acopio],
  placement: none,
) <tab:entidades>

= Tecnologías

La interfaz se construye con `Flet` sobre Python. La concurrencia emplea los módulos `threading`, `queue`, `concurrent.futures` y `multiprocessing` de la biblioteca estándar. El empaquetado se realiza con `setuptools`, la gestión de dependencias con `Poetry` y la interfaz de línea de comandos con `argparse`. Las pruebas se ejecutan con `pytest`. El cálculo intensivo se deriva a `multiprocessing` para evitar el bloqueo global del intérprete, mientras la coordinación de las tareas se resuelve con `threading` y `queue`.

= Plan de desarrollo

El plan se organiza en seis fases, cada una con un producto verificable y su criterio de aceptación (véase la @tab:fases).

#figure(
  bt(
    (auto, 1fr),
    ([Fase], [Producto y criterio de aceptación]),
    [Fundamentos], [Paquete y entorno aislado; el paquete se instala y ejecuta.],
    [Dominio], [Modelo de tareas y resultados; los estados y las transiciones se respetan.],
    [Interacción], [Interfaz y avance; la aplicación permanece disponible durante la ejecución.],
    [Concurrencia], [Hilos, colas, semáforos, procesos y cancelación; las tareas se sincronizan sin bloqueos ni condiciones de carrera.],
    [Calidad], [Pruebas, documentación y paquete; la cobertura y el empaquetado son correctos.],
    [Entrega], [Paquete y herramienta de línea de comandos; el proyecto se reconstruye desde el código fuente y se ejecuta.],
  ),
  caption: [Fases del plan de desarrollo],
  placement: none,
) <tab:fases>

= Requisitos académicos

El programa exige acreditar cada módulo con una evidencia verificable en la herramienta.

== Programación concurrente

El módulo se acredita con las evidencias siguientes.

- *Hilo único frente a varios hilos.* Se demuestra que una tarea pesada congela la interfaz en el hilo principal y que un hilo aparte la mantiene responsiva, con una barra de progreso animada (`threading`, `time`).
- *Paso de parámetros y retorno.* Se envían argumentos a la función de cada hilo y se ejecutan tres tareas de cálculo numérico en simultáneo (`threading`).
- *Sincronización con semáforos.* Se acota el acceso concurrente a un recurso compartido (`threading.Semaphore`).
- *Exclusión mutua.* Se evita una condición de carrera sobre un contador compartido, verificando diez hilos que incrementan mil veces cada uno (`threading.Lock`).
- *Productor y consumidor.* Se comunican hilos por una cola segura, con un productor y dos consumidores coordinados (`queue.Queue`).
- *Bloqueo mutuo.* Se reproduce un interbloqueo al competir por recursos y se previene con bloqueos reentrantes o un orden de recursos (`threading.RLock`).
- *Contenedor de ejecución.* Se procesan de forma concurrente una lista de enlaces y se recolectan los resultados a medida que terminan (`concurrent.futures`).
- *Comunicación con la interfaz.* Se actualiza la interfaz desde un hilo secundario sin corromper el hilo principal, mediante una cola (`queue`).
- *Paralelismo con procesos.* Se ejecuta un cálculo pesado en varios procesos y se compara el tiempo frente a un solo hilo (`multiprocessing`).
- *Cancelación.* Se detiene de forma limpia un hilo en un bucle continuo mediante una bandera de parada (`threading.Event`).

== Componentes y librerías

El módulo se acredita con las evidencias siguientes.

- *Módulo de utilidades.* Se escribe un archivo independiente con funciones puras reutilizables y pruebas internas bajo la protección de `__main__` (`statistics`, `math`).
- *Paquete modular.* Se agrupan varios módulos en una carpeta contenedora y se controla con `__all__` lo expuesto por la importación global.
- *Empaquetado.* Se definen los metadatos de la librería y se genera un archivo de distribución en formato wheel (`setuptools`).
- *Gestión de dependencias.* Se inicializa el proyecto, se aísla el entorno y se declaran las versiones y dependencias de terceros (`Poetry`).
- *Componente reutilizable.* Se extiende una clase base de la interfaz para empaquetar un componente visual complejo reutilizable en otras aplicaciones.
- *Patrón observador.* Se diseña una clase que registra observadores y les notifica los cambios de estado, actualizando dos vistas a la vez.
- *Instalación editable.* Se instala el paquete apuntando al código fuente y se comprueba que los cambios se reflejan sin reinstalar (`pip`).
- *Documentación.* Se documentan clases y métodos con docstrings y se extrae la ayuda (`pydoc`; `Sphinx` si se genera un sitio).
- *Pruebas unitarias.* Se cubren entradas válidas e inválidas de cada módulo y se mide la cobertura (`pytest` y `coverage`; alternativa `unittest`).
- *Interfaz de línea de comandos.* Se expone la librería como herramienta ejecutable con argumentos posicionales y opcionales (`argparse`).

= Entregables

La entrega comprende los artefactos siguientes.

- Aplicación con cola de tareas y control de ejecución.
- Interfaz de línea de comandos.
- Paquete instalable con sus dependencias declaradas.
- Suite de pruebas con su informe de cobertura.

= Referencias

#set enum(numbering: "[1]")

+ Flet. Documentación oficial. #link("https://flet.dev/docs/")
+ threading. Documentación de Python. #link("https://docs.python.org/3/library/threading.html")
+ queue. Documentación de Python. #link("https://docs.python.org/3/library/queue.html")
+ concurrent.futures. Documentación de Python. #link("https://docs.python.org/3/library/concurrent.futures.html")
+ multiprocessing. Documentación de Python. #link("https://docs.python.org/3/library/multiprocessing.html")
+ argparse. Documentación de Python. #link("https://docs.python.org/3/library/argparse.html")
+ setuptools. Documentación oficial. #link("https://setuptools.pypa.io/")
+ Poetry. Documentación oficial. #link("https://python-poetry.org/docs/")
+ pytest. Documentación oficial. #link("https://docs.pytest.org/")
+ coverage. Documentación oficial. #link("https://coverage.readthedocs.io/")
