
Escriba un programa `index.js` que contenga una versión con promesas  `readFilePromise` de la función [fs.readFile](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback) que pueda ser usada así:

```js
readFilePromise(programName, 'utf8')
  .then(data => console.log('Data:\n'+data))
  .catch(error => console.log('Error:\n'+error));
```

{% comment %}
## See

`tema2-async/practicas/p9-t2-promise-readfile/solution`
{% endcomment  %}