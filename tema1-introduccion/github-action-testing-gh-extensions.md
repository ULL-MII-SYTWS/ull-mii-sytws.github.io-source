---
title: Testing GitHub Cli Extensions with GitHub Actions
---

## Ejemplo: Respuesta automática a incidencias

Read the article [Using GitHub CLI in workflows](https://docs.github.com/en/actions/advanced-guides/using-github-cli-in-workflows). You can script with GitHub CLI in GitHub Actions workflows.

GitHub CLI is preinstalled on all GitHub-hosted runners. For each step that uses GitHub CLI, you must set an environment variable called `GITHUB_TOKEN` to a token with the required scopes.

You can execute any GitHub CLI command. 

For example, this workflow uses the `gh issue comment` subcommand to add a comment when an issue is opened.

{% raw %}
```yml 
name: Comment when opened
on:
  issues:
    types:
      - opened
jobs:
  comment:
    runs-on: ubuntu-latest
    steps:
      - run: gh issue comment $ISSUE --body "Thank you for opening this issue!"
        env:
          GITHUB_TOKEN: ${{ secrets.ACCESS_TOKEN }}
          ISSUE: ${{ github.event.issue.html_url }}
```
{% endraw %}

See 
* [Event object properties](https://docs.github.com/en/developers/webhooks-and-events/events/issue-event-types#event-object-properties-6)
*  and [Issue event object common properties](https://docs.github.com/en/developers/webhooks-and-events/events/issue-event-types#issue-event-object-common-properties)]: the `htm_url` property is a string that contains the HTML URL of the issue comment.

Here is the help of `gh issue comment`:


```
➜  gh-repo-rename-testing git:(main) ✗ gh help issue comment
Create a new issue comment

USAGE
  gh issue comment {<number> | <url>} [flags]

FLAGS
  -b, --body string      Supply a body. Will prompt for one otherwise.
  -F, --body-file file   Read body text from file (use "-" to read from standard input)
  -e, --editor           Add body using editor
  -w, --web              Add body in browser

INHERITED FLAGS
      --help                     Show help for command
  -R, --repo [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO format

EXAMPLES
  $ gh issue comment 22 --body "I was able to reproduce this issue, lets fix it."

LEARN MORE
  Use 'gh <command> <subcommand> --help' for more information about a command.
  Read the manual at https://cli.github.com/manual
```


## Testing in production 

Véase:

1. The action at gh-extension 
   - [Repo ULL-ESIT-DMSI-1920/gh-cli-graphql-casiano-rodriguez-leon-alumnoudv5 branch as-module](https://github.com/ULL-ESIT-DMSI-1920/gh-cli-graphql-casiano-rodriguez-leon-alumnoudv5/tree/as-module)
   - [crguezl/gh-repo-rename](https://github.com/crguezl/gh-repo-rename)
2. [Workflow syntax for GitHub Actions](https://docs.github.com/es/actions/learn-github-actions/workflow-syntax-for-github-actions#)
4. GitHub Action en [crguezl/gh-repo-rename-testing](https://github.com/crguezl/gh-repo-rename-testing) para testear la github cli  extensión 
en el repo [ULL-MII-SYTWS-2122/gh-repo-rename](https://github.com/ULL-MII-SYTWS-2122/gh-repo-rename) por Carlos.
    - [actions en crguezl/gh-repo-rename-testing](https://github.com/crguezl/gh-repo-rename-testing/actions)


```
➜  gh-cli-graphql-casiano-rodriguez-leon-alumnoudv5 git:(as-module) cat .github/workflows/npm-publish.yml 
```
{% raw %}
```yml
name: Npm publish repo-rename
on:
  push:
        branches: [as-module]

jobs:
  publish-npm:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: 16
          registry-url: https://registry.npmjs.org/
      - run: npm ci
      - run: npm publish --access=public
        env:
          NODE_AUTH_TOKEN: ${{secrets.NPM_TOKEN}}
          
  test-gh-rename-repo:
    needs: publish-npm
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
          run: gh extension install ${OWNER}/gh-repo-rename  

        - name: create repo with user as owner
          run: gh api /user/repos -X POST --field name=${OLDNAME}        
          continue-on-error: true   

        - name: probar a renombrarlo
          run: gh repo-rename -o ${OWNER} -r ${OLDNAME} -n ${NEWNAME}         

        - name: delete repo
          run: gh api -X DELETE "/repos/${OWNER}/${NEWNAME}"           
        
    env:
      GITHUB_TOKEN: ${{secrets.ACCESS_TOKEN}}
      # Instead of crguezl. To make it more generic
      OWNER: ${{ github.repository_owner }}
      OLDNAME: "prueba"
      NEWNAME: "pruebanuevo"
```
{% endraw %}

### Observaciones

* He tenido que hacer el repo de la extensión público para que el step `gh extension install ULL-MII-SYTWS-2122/gh-repo-rename` no requiera de autenticaciones adicionales
* `jobs.<job_id>.steps[*].continue-on-error` Prevents a job from failing when a step fails. 
  Set to `true` to allow a job to pass when this step fails.


## Example: Report remaining open issues

You can also execute API calls through GitHub CLI. For example, this workflow 

1. first uses the gh api subcommand to query the GraphQL API and parse the result. 
2. Then it stores the result in an environment variable that it can access in a later step. 
3. In the second step, it uses the gh issue create subcommand to create an issue containing the information from the first step.

```yml 
name: Report remaining open issues
on: 
  schedule: 
    # Daily at 8:20 UTC
    - cron: '20 8 * * *'
jobs:
  track_pr:
    runs-on: ubuntu-latest
    steps:
      - run: |
          numOpenIssues="$(gh api graphql -F owner=$OWNER -F name=$REPO -f query='
            query($name: String!, $owner: String!) {
              repository(owner: $owner, name: $name) {
                issues(states:OPEN){
                  totalCount
                }
              }
            }
          ' --jq '.data.repository.issues.totalCount')"

          echo 'NUM_OPEN_ISSUES='$numOpenIssues >> $GITHUB_ENV
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          OWNER: ${{ github.repository_owner }}
          REPO: ${{ github.event.repository.name }}
      - run: |
          gh issue create --title "Issue report" --body "$NUM_OPEN_ISSUES issues remaining" --repo $GITHUB_REPOSITORY
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
