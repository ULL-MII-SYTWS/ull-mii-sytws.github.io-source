---
title: "npm Module"
published: true
permalink: practicas/npm-module
layout: practica
visible: true
order: 17
categories: [ "practicas" ]
rubrica: 
  - El paquete está publicado en npmjs con ámbito `aluXXX`
  - Contiene un ejecutable que se ejecuta correctamente (`--help`, etc.)
  - El módulo exporta las funciones adecuadas
  - Contiene suficientes tests 
  - "Opcional: estudio de covering"
  - Se ha hecho CI con GitHub Actions y se ejecuta en los tres O.S.
  - Los informes están bien presentados
  - "La documentación es completa: API, ejecutable, instalación, etc." 
  - "Opcional: publicar la documentación de la API usando GitHub Pages en la carpeta `docs/`"
  - 
    - Las *pruebas de producción* funcionan bien
    - Probar que la librería está accesible y funciona 
    - Probar que el ejecutable queda correctamente instalado, puede ser ejecutado con el nombre publicado y produce salidas correctas
  - El superproyecto está correctamente estructurado usando submódulos
  - Se ha hecho un buen uso del versionado semántico en la evolución del módulo
---

{% include practicas/npm-module.md %}