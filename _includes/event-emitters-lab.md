Escriba una clase `WithTime` que extienda la clase [EventEmitter](https://nodejs.org/api/events.html#class-eventemitter) y cuyos objetos disponen de un método `(new WithTime()).execute` con una firma como esta:


```js 
const WithTime = require("./with-time.js");
const withTime = new WithTime();
withTime.execute(asyncFun, ...args);
```

Esto es, `execute` recibe como primer argumento una función asíncrona `asyncfun` y emite distintos tipos de eventos `begin`, `end`, `error`, etc, indicando los cambios de estado en la ejecución de  `asyncFun`. 

La firma de `asyncFun` es

```js
asyncfun(..., cb)
```

Como es el convenio habitual en JS, se supone que la callback será llamada  `cb(err, data)` por `asyncfun` cuando esta termina su tarea asíncrona. El primer parámetro `err` indica el error si lo hubo y el segundo `data` con el resultado de la operación asíncrona:  `cb(err, data)`.

Se pide que:

1. La llamada `withTime.execute(asyncFun, ...args)` emita eventos `begin` y `end`  señalando 
   el comienzo y final de la ejecución de `asyncfun`
2. Deberá así mismo emitir un evento `result` con el resultado de la operación asíncrona al final de la misma.
3. Deberá emitir un evento `time` indicando el tiempo que ha tomado la ejecución en nanosegundos (puede usar [`process.hrtime.bigint`](https://nodejs.org/api/process.html#process_process_hrtime_bigint) para ello)

Por ejemplo, un código como:

```js
const inspect = require("util").inspect;
const ins = (x) => inspect(x, {depth: Infinity, colors: true});
const fetch = require("node-fetch");
const WithTime = require("./with-time.js");

const withTime = new WithTime();

withTime.on('begin', (label) => console.log('About to execute '+label));

withTime.on('end', (label) => console.log('Done with execution of '+label));

withTime.on('result', (label, data) => console.log('Function '+label+' produced:\n'+ins(data)));
withTime.on('error', (label, error) => console.log('Function '+label+' error:\n'+ins(error)));

withTime.on('time', (label, t) => console.log('Function '+label+' took '+t+' nanoseconds'));

const readFile = (url, cb) => {
  fetch(url)
    .then((resp) => resp.json())
    .then(function(data) {
      cb(null, data);
    })
    .catch(e => cb(`Buf! ${e}`));
}

withTime.execute(readFile, process.argv[2] || 'https://jsonplaceholder.typicode.com/posts/3');
```

Debería producir una salida como está:

```
About to execute readFile
Function readFile produced:
{
  userId: 1,
  id: 3,
  title: 'ea molestias quasi exercitationem repellat qui ipsa sit aut',
  body: 'et iusto sed quo iure\n' +
    'voluptatem occaecati omnis eligendi aut ad\n' +
    'voluptatem doloribus vel accusantium quis pariatur\n' +
    'molestiae porro eius odio et labore et velit aut'
}
Function readFile took 331675217 nanoseconds
Done with execution of readFile
```

y si se producen errores una salida como esta:

```
➜  event-emitter-tutorial git:(master) ✗ node client.js no-existe
About to execute readFile
Function readFile error:
'Buf! TypeError: Only absolute URLs are supported'
```

* [Esta es una Solución]({{site.baseurl}}/pages/solution-to-event-emitters-exercise)

Si quieres prácticar mas con los event emitters puedes realizar **opcionalmente** la práctica 
[networking]({{site.baseurl}}/tema2-async/practicas/networking/). 

