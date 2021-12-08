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

## gh workflow

* See gitHub blog [GitHub Actions: Manual triggers with workflow_dispatch](https://github.blog/changelog/2020-07-06-github-actions-manual-triggers-with-workflow_dispatch/)
* See [ULL-ESIT-PL-1920/use-hello-world-javascript-action](https://github.com/ULL-ESIT-PL-1920/use-hello-world-javascript-action)

You can now create workflows that are manually triggered with the new `workflow_dispatch` event.

You will then see a **Run workflow** button on the Actions tab, enabling you to easily trigger a run.

![](https://raw.githubusercontent.com/ULL-ESIT-PL-1920/use-hello-world-javascript-action/master/images/run-workflow.png) 

```
➜  use-hello-world-javascript-action git:(master) gh help workflow
List, view, and run workflows in GitHub Actions.

USAGE
  gh workflow <command> [flags]

CORE COMMANDS
  disable:    Disable a workflow
  enable:     Enable a workflow
  list:       List workflows
  run:        Run a workflow by creating a workflow_dispatch event
  view:       View the summary of a workflow

FLAGS
  -R, --repo [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO format

INHERITED FLAGS
  --help   Show help for command

LEARN MORE
  Use 'gh <command> <subcommand> --help' for more information about a command.
  Read the manual at https://cli.github.com/manual



A new release of gh is available: 1.9.1 → v1.9.2
To upgrade, run: brew update && brew upgrade gh
https://github.com/cli/cli/releases/tag/v1.9.2
```

### Example


```
gh workflow run manual.yml -f name=PL2021
```

To view a workflow:

```
➜  use-hello-world-javascript-action git:(master) ✗ gh workflow view --help
View the summary of a workflow

USAGE
  gh workflow view [<workflow-id> | <workflow-name> | <filename>] [flags]

FLAGS
  -r, --ref string   The branch or tag name which contains the version of the workflow file you'd like to view
  -w, --web          Open workflow in the browser
  -y, --yaml         View the workflow yaml file

INHERITED FLAGS
      --help                     Show help for command
  -R, --repo [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO format

EXAMPLES
  # Interactively select a workflow to view
  $ gh workflow view
  
  # View a specific workflow
  $ gh workflow view 0451

LEARN MORE
  Use 'gh <command> <subcommand> --help' for more information about a command.
  Read the manual at https://cli.github.com/manual
```


## Videos de clases relacionadas con las GH Actions

{% include video-youtube.html %}

## References

{% include github-js-actions-references.md %}
