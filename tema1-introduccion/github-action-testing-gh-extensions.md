---
title: Testing GitHub Cli Extensions with GitHub Actions
---

Véase:

1. GitHub Action en [crguezl/gh-repo-rename-testing](https://github.com/crguezl/gh-repo-rename-testing) para testear la github cli  extensión 
en el repo [ULL-MII-SYTWS-2122/gh-repo-rename](https://github.com/ULL-MII-SYTWS-2122/gh-repo-rename) por Carlos.
    - [actions en crguezl/gh-repo-rename-testing](https://github.com/crguezl/gh-repo-rename-testing/actions)
2. [Workflow syntax for GitHub Actions](https://docs.github.com/es/actions/learn-github-actions/workflow-syntax-for-github-actions#)


```yml
name: testing carlos extension

# Controls when the workflow will run
on:
  push:
    branches: [main]

jobs:          
  carlos:
    # Define the OS our workflow should run on
    runs-on: ubuntu-latest
    steps: 
        - uses: actions/checkout@v2 # esta action descarga el repo en la máquina virtual
        - name: Install node
          uses: actions/setup-node@v1
          with:
            node-version: '16'
        
        - name: See what version of gh is installed
          run: gh version  

        - name: Install gh repo-rename extension. Repo  is now public
          run: gh extension install ULL-MII-SYTWS-2122/gh-repo-rename  

        - name: create repo with user as owner
          run: gh api /user/repos -X POST --field name=prueba   
          continue-on-error: true        

        - name: probar a renombrarlo
          run: gh repo-rename ${OWNER}/prueba repoRenombrado           

        - name: delete repo
          run: gh api -X DELETE "/repos/${OWNER}/repoRenombrado"           
        
    env:
      GITHUB_TOKEN: ${{secrets.ACCESS_TOKEN}}
      # Instead of crguezl. To make it more generic
      OWNER: ${{ github.repository_owner }}
```

## Observaciones

* He tenido que hacer el repo de la extensión público para que el step `gh extension install ULL-MII-SYTWS-2122/gh-repo-rename` no requiera de autenticaciones adicionales
* `jobs.<job_id>.steps[*].continue-on-error` Prevents a job from failing when a step fails. 
  Set to `true` to allow a job to pass when this step fails.