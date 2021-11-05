## Práctica de Grupo individual

Al aceptar la asignación se le pedirá el nombre del equipo. Deberá darle como nombre 
`Nombre-Apellidos-aluXXX` (sin acentos ni caracteres especiales). Los equipos son de un sólo miembro.


## Objetivos

Partiendo de la gh extension escrita en la práctica [gh-cli]({{site.baseurl}}/practicas/06p6-t1-gh-cli.html) construya un paquete npm y 
publíquelo en [npmjs](https://www.npmjs.com/) con ámbito `@aluXXX`.

El módulo además de exportar las funciones que sean necesarias deberá proveer el ejecutable `gh-my-extension`

Reescriba la extensión gh-cli que escribió en la práctica anterior para que haga uso del módulo creado en esta práctica. Recuerde que el ejecutable queda en `node_modules/.bin`

La mayor parte de los conceptos y habilidades a adquirir con esta práctica se explican en la sección [Creating and publishing a node.js module en GitHub y en NPM]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module). Léala con detenimiento antes de hacer esta práctica. 

El módulo lo puede publicar como CommonJS o ES

## Ámbitos

Deberá publicar el paquete en [npmjs](https://www.npmjs.com/) con ámbito `@aluXXX` y con nombre `gh-...`. Sustituya los tres puntos por el nombre de su extensión.

Para saber sobre ámbitos, vea la sección [Scopes and Registries]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#scopes-and-registries).

## Pruebas

Deberá añadir pruebas usando [Mocha y Chai]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#testing-with-mocha-and-chai) o [Jest]({{site.baseurl}}/tema1-introduccion/jest).
Repase las secciones [Testing with Mocha and Chai]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module##testing-with-mocha-and-chai) y [Jest]({{site.baseurl}}/tema1-introduccion/jest).

## Integración Contínua usando GitHub Actions

Use [GitHub Actions]({{site.baseurl}}/tema1-introduccion/github-actions) para la ejecución de las pruebas

Compruebe que las pruebas pasan en los tres O.S: Linux, MacOS y Windows.


## Documentación

[Documente]({{site.baseurl}}/tema1-introduccion/documentation)
el módulo incorporando un `README.md` y la documentación de la función exportada.
Repase la sección [Documenting the JavaScript Sources]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#documenting-the-javascript-sources)

## Pruebas de Producción

Crea un repo `testing-gh-...`  dentro de la organización. 

Añada las pruebas necesarias
para comprobar que **la última versión del paquete publicado** se instala y puede ser usado.

Repase la sección [Testing in Production]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#testing-in-production)

Use [GitHub Actions]({{site.baseurl}}/tema1-introduccion/github-actions) para la ejecución de las pruebas

**Compruebe que las pruebas pasan en los tres O.S: Linux, MacOS y Windows**

## Superproject with Git Submodule

Crea dentro de la organización un repo con nombre para que contenga
a a los dos repos: en el que ha desarrollado el módulo npm `gh-...` y el repo para las pruebas en tiempo de producción `testing-gh-...`.

Usando `git submodule` configura como super-project dicho repo. 

Repase la sección [Making a Project with the two repos: git submodule]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#making-a-project-with-the-two-repos-git-submodule)

## Semantic Versioning

Publique alguna mejora en la funcionalidad del módulo.  
¿Como debe en tales casos cambiar el nº de versión?

Repase la sección [Semantic Versioning]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module#semantic-versioning)

## References

* [Creating and Publishing a node.js Module in GitHub and NPM Registries]({{site.baseurl}}/tema1-introduccion/creating-and-publishing-npm-module)
* [Jest]({{site.baseurl}}/tema1-introduccion/jest)
* [Módulos]({{site.baseurl}}/tema1-introduccion/modulos)
* [Node.js Packages]({{site.baseurl}}/tema1-introduccion/nodejspackages)
* [Documentation]({{site.baseurl}}/tema1-introduccion/documentation)
* [Instalación de Módulos desde GitHub]({{site.baseurl}}/tema1-introduccion/nodejspackages.html#instalaci%C3%B3n-desde-github)
* [Introducción a los Módulos en JS](https://lenguajejs.com/automatizadores/introduccion/commonjs-vs-es-modules/) por Manz
* [@ull-esit-dsi-1617/scapegoat](https://www.npmjs.com/package/@ull-esit-dsi-1617/scapegoat) en npm
* [How to install an npm package from GitHub directly?](https://stackoverflow.com/questions/17509669/how-to-install-an-npm-package-from-github-directly) in StackOverflow
* [Working with scoped packages](https://docs.npmjs.com/getting-started/scoped-packages)
* [npm-scope manual: Scoped packages](https://docs.npmjs.com/misc/scope#publishing-public-scoped-packages-to-the-public-npm-registry)
* [Package.json documentation en npm site](https://docs.npmjs.com/files/package.json)
* Semantic versioning and npm
    * [Semantic versioning and npm](https://docs.npmjs.com/getting-started/semantic-versioning)
    * [Semantic Versioning: Why You Should Be Using it](https://www.sitepoint.com/semantic-versioning-why-you-should-using/) SitePoint
    * [YouTube Video: Semantic versioning and npm](https://youtu.be/kK4Meix58R4)
    * [El comando npm version](https://docs.npmjs.com/cli/version)
