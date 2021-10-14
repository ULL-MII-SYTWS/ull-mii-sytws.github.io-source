
1. Siguiendo el capítulo 20 *Node.JS*  del libro Eloquent JavaScript (EJS) escriba sus propios apuntes con ejemplos y realice los ejercicios que se indican a continuación.
  En este capítulo se introduce Node.js, la librería para el manejo de archivos (`fs`) y la librería para construir servidores HTTP. Combinando ambas se construye un servicio HTTP que permite el manejo de archivos remoto. 
    - [Eloquent JS: Chapter 20 HTTP](http://eloquentjavascript.net/20_node.html) 3d Edition
    - [Eloquent JS: Chapter 20 HTTP](http://eloquentjavascript.net/2nd_edition/20_node.html) 2nd Edition
3. Realice el ejercicio *Directory Creation* 
  - Though the `DELETE` method is wired up to delete directories (using `fs.rmdir`), 
  the file server currently does not provide any way to create a directory.  Add 
  support for a method `MKCOL`, which should create a directory by calling `fs.mkdir` 
4. Realice el ejercicio *A public space on the web*
4. Instale [insomia](https://insomnia.rest/) o [postman](https://www.getpostman.com/) para usarlo como cliente de prueba.
6. Recordarles que en las tareas del campus se entrega el enlace al repositorio en GitHub 


## Recursos para hacer esta práctica

* [Eloquent JS 3d Edition](https://eloquentjavascript.net/20_node.html)
* [Eloquent JS 2nd Edition: Chapter 20 HTTP](http://eloquentjavascript.net/2nd_edition/20_node.html)
* [Vídeo del profesor con sugerencias para la solución de la práctica](https://youtu.be/gxrBEfjgRdM) (2019)
  * [![https://img.youtube.com/vi/gxrBEfjgRdM/sddefault.jpg](https://img.youtube.com/vi/gxrBEfjgRdM/sddefault.jpg)](https://youtu.be/gxrBEfjgRdM)
* [See this repo with (modified) solutions of Juan Irache to EJS exercises](https://github.com/ULL-MII-SYTWS-1920/eloquent-javascript-exercises)
  - [Solutions 20_3_a_public_space](https://github.com/ULL-MII-SYTWS-1920/eloquent-javascript-exercises/tree/master/20_3_public_space)
* [Node.js docs: Anatomy of an HTTP Transaction](https://nodejs.org/es/docs/guides/anatomy-of-an-http-transaction/)
* [How to Develop Web Application using pure Node.js (HTTP GET and POST, HTTP Server)](https://youtu.be/nuw48-u3Yrg) Vídeo en Youtube. 2015

{% comment %}

## Diseño

La solución diseñada en el libro de EJS sigue el strategy pattern.
Estas fuentes pueden ser de utilidad:

  * [Apuntes: Code Smells](https://casianorodriguezleon.gitbooks.io/ull-esit-1617/content/apuntes/patterns/codesmell.html)
  * [Principios de Diseño](https://casianorodriguezleon.gitbooks.io/ull-esit-1617/content/apuntes/patterns/designprinciples.html)
  * [Patrones de Diseño](https://casianorodriguezleon.gitbooks.io/ull-esit-1617/content/apuntes/patterns/)
  * [Strategy Pattern](https://casianorodriguezleon.gitbooks.io/ull-esit-1617/content/apuntes/patterns/strategypattern.html)


## Para el profesor

* `/Users/casiano/local/src/javascript/eloquent-javascript/chapter20-node-js/` (recurso para el profesor)
* [Repo con las soluciones K.](https://github.com/ULL-ESIT-MII-CA-1718/nodejs-KevMCh) (No disponible ahora)
* [Repo con las soluciones C.](https://github.com/ULL-ESIT-MII-CA-1718/ejs-chapter20-node-js) (No disponible ahora)

## Reto

* [Reto para la práctica](reto.md)

{% endcomment %}