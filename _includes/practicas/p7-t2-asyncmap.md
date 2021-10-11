
## Descripción de la Práctica 

Escriba un programa Node.js que usando `fs.readFile` lea **en paralelo** un conjunto de ficheros pasados en vía de comandos y produzca como salida la concatenación de los mismos en el orden especificado. Evite usar `fs.readFileSync` y use `fs.readFile(path[, options], callback)`:

```
$ concat -f one.txt -f two.txt -f three.txt -o salida.txt
```

## commander

Con [commander](https://www.npmjs.com/package/commander?activeTab=readme) es posible indicar una opción que se puede repetir

```js
const program = require('commander');
function collect(value, previous) {
  return previous.concat([value]);
}
program.option('-c, --collect <value>', 'repeatable value', collect, []);
program.parse(process.argv);
console.log(program.collect)
```

```
$ node repeatable-option-commander.js -c a -c b -c c
[ 'a', 'b', 'c' ]
```
## Requisitos

1. Lea la sección [The Async Module]({{site.baseurl}}/tema2-async/async-js) de los apuntes y encuentre una solución usando `Async`. Considere la posibilidad de excepciones debidas a que alguno de los ficheros no exista
3. Encuentre  una solución sin hacer uso de `Async` ¿Cómo lo haría?
4. Haciendo abstracción de la solución encontrada en el paso anterior escriba una función `asyncMap` que funcione como el `map` del módulo `Async`:

  ```js
  asyncMap(inputs, (item, cb) => fs.readFile(item, cb), (err, contents) => { ... });
  ```

## Versiones usadas en este texto

Versiones usadas de los módulos en los ejemplos:

```json
➜  daniel-alu0101040882 git:(main) ✗ jq '.dependencies' package.json 
{
  "async": "^3.2.0",
  "commander": "^6.2.0"
}
```

## Referencias

* Sección [The Async Module]({{site.baseurl}}/tema2-async/async-js)