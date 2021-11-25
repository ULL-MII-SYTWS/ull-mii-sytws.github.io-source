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
### Argumentos

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

### off / emitter.removeListener(eventName, listener)

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

### listenerCount and rawListeners

`emitter.rawListeners(eventName)` returns a copy of the array of listeners for the event named `eventName`, including any wrappers (such as those created by `.once()`).

```js
> myEmitter.listenerCount('eventOne')
1
> myEmitter.rawListeners('eventOne')
[ [Function: c2] ]
```
