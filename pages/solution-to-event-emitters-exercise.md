# Solution
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
