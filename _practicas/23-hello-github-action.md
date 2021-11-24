---
title: "GitHub Action Hello World"
rubrica:
  - La acción está publicada y se usa correctamente
  - Las GitHub pages funcionan correctamente en el super repo
  - Se ha instalado Jekyll y puede ver las páginas generadas en local
  - "Opcional: En la práctica anterior se ha extendido la CI para Mac OS y Windows"
layout: practica
permalink: /practicas/github-action
visible: true
video: ["a3Ycya8S_0A", "qX88QdrlDqg", "FOlIeuTNkw8", "xeH67k2Vxl0"]
order: 21
---

<!--
  # - Hacer el ejercicio *Add another step to the former workflow to see the SECRETS context. What do you see?* <https://ull-esit-gradoii-pl.github.io/assets/temas/introduccion-a-javascript/github-actions#exercise>
-->

## Goals

Write a GitHub Action *Hello World* following the tutorial 
at section [Hello Actions World!]({{site.baseurl}}/pages/creating-javascript-action).

1. Save the action code in repo `hello-js-action-aluXXX`, 
  - Change the visibility of this repo to `public` (go to `settings/manage access`)
2. Inside repo `use-hello-js-action-aluXXX` save the project using the action and  
3. In repo `hello-js-action-super` build a  repo having the former two as submodules
4. Write your `README.md` report in the superproject repo. 
5. Set [GitHub pages](https://guides.github.com/features/pages/) 
  - Set the `main` branch and the root of the superproject 
  - Choose one of the [page supported themes](https://pages.github.com/themes/) for the static generator [Jekyll](https://jekyllrb.com/) 
  - Set the `github.io` URL in the *description* section of the superproject

## Optional Step

If you feel enthusiastic about GitHub Actions, continue 
using the repo [actions/javascript-action](https://github.com/actions/javascript-action)
as a template and follow the instructions. 
Save the action code in repo `hello-js-action-aluXXX` but in a branch with name `optional`.

To use this new action, you have to reference it in the client repo like this:

```yml
steps:    
  - uses: ULL-ESIT-PL-1920/hello-js-action-aluXXX@optional  # Reference a branch
```

Pay special attention to how the tests were written in this example.

## Build your own GitHub Action 

Think of ideas to write your own GH Action.

For example, this repo [crguezl/pandoc-gitpod-template](https://github.com/crguezl/pandoc-gitpod-template) uses GitHub Actions  to convert some markdown files, producing the pdf as an artifact. [See the workflow file](https://github.com/crguezl/pandoc-gitpod-template/blob/main/.github/workflows/generate_pdf.yml) and the [actions running](https://github.com/crguezl/pandoc-gitpod-template/actions)

Here is an action [BaileyJM02/markdown-to-pdf](https://github.com/BaileyJM02/markdown-to-pdf) that creates PDF and HTML files from Markdown using the GitHub (or custom) theme.

There are actions to run MatLab, to deploy to different platforms, ... here is the [github actions marketplace](https://github.com/marketplace?category=&query=&type=actions&verification=)


## Videos de clases relacionadas con las GH Actions

{% include video-youtube.html %}

## References

{% include github-js-actions-references.md %}
