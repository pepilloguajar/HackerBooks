# HackerBooks
Lector de libros en PDF para iPhone & iPad. Los libros en sí los recibirás en un json que descargas de una URL.

## Pregusntas sobre la práctica

### Procesado del JSON
En la práctia lo que he utilizado ha sido el "as?" para hacer un cast de lo que me devuelve a la estructura de dato que me interesa. Si se consigue hacer ese "parseo" continuo sin errores.


### Modelo
Las imágenes de portada y los pdf de los libros he optado por almacenarlos en la carpeta de Documetns de la app, con el nombre igual al hashValue de su url. Lo que hago para saber si ya tenía guardado un libro o no (si está guardado lo recupero y no lo descargo), es comprobar si existe algún fichero en Documents que su nombre sea el hashValue.


### Tabla de libros
La gestión de favoritos la he hecho de la siguiente manera. Cada vez que marcaba un libro como favorito, lo añadía a un array de enteros que almacenaba en UserDefaults. A ese array le añadía el hashValue de cada book, así cuando iniciaba la app e iba reccorriendo el array de libros, iba marcando de nuevo los favoritos que tenía guardados.

Para comunicar cuando marcaba un libro como favorito en el BookViewController, he utilizado el mecanismo de comunicación de las notificaciones. Así que cuando pulsaba el botón de favotiro, añadía o eliminaba el tag al libro, y enviaba una notificación, pasando en el userInfo el libro, con o sin el tag. El libraryViewController estaría esperando esa notificación, y una vez que la recibiese, modificaría el modelo y el array donde guardo los favoritos. Despues hago un reload para actualizar la tabla con el nuevo modelo.

Respecto a lo de volver a cargar los datos (reloadData), pienso que no sería una aberración ya que la tableView no carga todos los datos, sino que sólo los de las celdas visibles. Luego va cargando los que vaya necesitando, si el usuario hace scroll.
No se si una opción alternativa sería buscar la celda en concreto y actualizarla, pero creo que no valdría la pena el recorrer toda la tabla para buscarla, ya que el hacer el reloadData no estaríamos perjudicando el rendimiento y es más "sencillo".


### Controlador de PDF: PDFViewController
Lo he hecho utilizando las notificaciones. El libraryViewController envia una notificación a la que está subscrito el PDFViewController, que al recibirla actualiza su modelo, y muestra el pdf que proceda.



### Comentarios
Queda pendiente el hacer la App universal, ya que ahora el funcionamiento en iPhone no es el deseado.

También quedaría crear una celda personalizada para el tableView.

Pendiente de logo.
