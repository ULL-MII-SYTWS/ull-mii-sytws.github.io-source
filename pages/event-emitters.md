---
title: Events
---

## The Observer Pattern

> The **observer pattern** is a software design pattern in which an object, called the **subject**, maintains a list of its dependents, called **observers**, and notifies them automatically of any state changes, usually by calling one of their methods.

![](/assets/images/observer-design-pattern.png)

See also 

* [Learning JavaScript Design Patterns. A book by Addy Osmani](https://addyosmani.com/resources/essentialjsdesignpatterns/book/#observerpatternjavascript)

## La Clase EventEmitter

* Algunos métodos de los objetos de la clase [EventEmitter](https://nodejs.org/api/events.html#events_class_eventemitter):

![](/assets/images/event-emitter-methods.png)

### on

```js
[~/.../p4-t2-networking/networking-with-sockets-chapter-3-crguezl(master)]$ node
Welcome to Node.js v12.10.0.
Type ".help" for more information.
> const {EventEmitter} = require("events")
undefined
> function c1() {   console.log('an event occurred!');}
undefined
> function c2() {   console.log('yet another event occurred!');}
undefined
> const myEmitter = new EventEmitter();
undefined
> myEmitter.on('eventOne', c1);
EventEmitter {
  _events: [Object: null prototype] { eventOne: [Function: c1] },
  _eventsCount: 1,
  _maxListeners: undefined
}
> myEmitter.on('eventOne', c2)
EventEmitter {
  _events: [Object: null prototype] {
    eventOne: [ [Function: c1], [Function: c2] ]
  },
  _eventsCount: 1,
  _maxListeners: undefined
}
> myEmitter.emit('eventOne');
an event occurred!
yet another event occurred!
true
```
### once

```js
> myEmitter.once('eventOnce', () => console.log('eventOnce once fired')); 
EventEmitter {
  _events: [Object: null prototype] {
    eventOne: [ [Function: c1], [Function: c2] ],
    eventOnce: [Function: bound onceWrapper] { listener: [Function] }
  },
  _eventsCount: 2,
  _maxListeners: undefined
}
> myEmitter.emit('eventOnce');
eventOnce once fired
true
> myEmitter.emit('eventOnce'); // Returns true if the event had listeners, false otherwise.
false
> myEmitter.emit('eventOnce');
false
```
## Argumentos

```js
> myEmitter.on('status', (code, msg)=> console.log(`Got ${code} and ${msg}`));
EventEmitter {
  _events: [Object: null prototype] {
    eventOne: [ [Function: c1], [Function: c2] ],
    status: [Function]
  },
  _eventsCount: 2,
  _maxListeners: undefined
}
> myEmitter.emit('status', 200, 'ok'); // Synchronously calls each of the listeners registered for the event named 'status', in the order they were registered, passing the supplied arguments to each
Got 200 and ok
```

## off / emitter.removeListener(eventName, listener)

Removes the specified `listener` from the listener array for the event named `eventName`.

```js
> myEmitter.off('eventOne', c1);
EventEmitter {
  _events: [Object: null prototype] {
    eventOne: [Function: c2],
    status: [Function]
  },
  _eventsCount: 2,
  _maxListeners: undefined
}
> myEmitter.emit('eventOne');  
yet another event occurred!
true
```

## listenerCount and rawListeners

`emitter.rawListeners(eventName)` returns a copy of the array of listeners for the event named `eventName`, including any wrappers (such as those created by `.once()`).

```js
> myEmitter.listenerCount('eventOne')
1
> myEmitter.rawListeners('eventOne')
[ [Function: c2] ]
```

# Ejercicio

Escriba una clase `WithTime` que extienda la clase [EventEmitter](https://nodejs.org/api/events.html#class-eventemitter) y cuyos objetos disponen de un método `(new WithTime()).execute` con una firma como esta:


```js 
const WithTime = require("./with-time.js");
const withTime = new WithTime();
withTime.execute(readFile, 'https://jsonplaceholder.typicode.com/posts/3');
```

Esto es, `execute` recibe como primer argumento una función asíncrona `asyncfun` cuyo último argumento es una callback  

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

Esta es una Solución

```
[~/.../networking-with-sockets-chapter-3-crguezl/event-emitter-tutorial(master)]$ cat with-time.js 
```

```js
const { EventEmitter } = require("events");

class WithTime extends EventEmitter {

  // This function executes asyncFunc(...args)
  execute(asyncFunc, ...args) {
    let label = asyncFunc.name;

    this.emit('begin', label);
    let old = process.hrtime.bigint();
    asyncFunc(...args, (err, data) => {
      if (err) { 
        this.emit('error', err); 
      } else {
        this.emit('result', label, data);
        this.emit('time', label, process.hrtime.bigint() - old);
        this.emit('end', label);
      }
    });
  }

}

module.exports = WithTime;
```

Si quieres prácticar mas con los event emitters puedes realizar **opcionalmente** la práctica 
[networking]({{site.baseurl}}/tema2-async/practicas/networking/). 

