## gh alias 

### gh create-repo

Using `gh api` and `gh alias --shell` (do not use the existing `gh repo create`) add to `gh` 
an extension `gh repo-create` that creates the repo inside the given organization:

```
$ gh repo-create ULL-ESIT-PL-2021/tuturepo
$ gh repo view ULL-ESIT-PL-2021/tuturepo -w
```

![image of create-repo.png]({{site.baseurl}}/assets/images/create-repo.png)

Use the GitHub REST API

### gh delete-repo

The same but with delete:

```
$ gh repo-delete ULL-ESIT-PL-2021/tuturepo
```

Then, after issuing the command and refreshing the former page we get:

![image of delete-repo.png]({{site.baseurl}}/assets/images/delete-repo.png)

See the GitHub API doc for [Delete repository](https://docs.github.com/es/rest/reference/repos#delete-a-repository)

### gh my-orgs-names 

Escriba un alias que muestre todas las organizaciones tanto aquellas en que sea miembro público como privado de las mismas:

```
[~/.../gh-learning/gh-clone-org(master)]$ gh my-orgs-names | tail -8
GeneticsJS
tfm-y-pce-mfp-2021
MDCCVRP
cooking-lifeboold
ULL-MII-SYTWS-2122
ULL-ESIT-DMSI-2121
ULL-MFP-AET-2122
ULL-ESIT-PL-2122
[~/.../gh-learning/gh-clone-org(master)]$ gh my-orgs-names | wc
      65      65    1279
[~/.../gh-learning/gh-clone-org(master)]$ gh my-orgs-names | grep 1819
ULL-ESIT-PL-1819
ULL-ESIT-DSI-1819
ULL-MII-CA-1819
```

### gh-org-members

Escriba un alias que reciba como argumento una organización y escriba los miembros de la misma:

```
$ gh org-members ULL-MII-SYTWS-2122 --jq '.[] | .login, .repos_url'
alu0100898293
https://api.github.com/users/alu0100898293/repos
alu0101102726
https://api.github.com/users/alu0101102726/repos
crguezl
https://api.github.com/users/crguezl/repos
PaulaExposito
https://api.github.com/users/PaulaExposito/repos
Pmolmar
https://api.github.com/users/Pmolmar/repos
```

Ahora con la información obtenida podemos ver los repos de un miembro fácilmente:

```
[~/.../gh-learning/gh-clone-org(master)]$ gh  api https://api.github.com/users/alu0100898293/repos -q '.[].name'
alu0100898293.github.io
eval-tareas-iniciales-NicolasHernandezGonzalez
express-start
prct01
prueba
```

### gh-user-repos

Añada un alias `gh-user-repos` que nos de los repos de un usuario:

```
$ gh user-repos Pmolmar --jq '.[] | .name, .created_at' | pcre2grep -M '.+\n2021'
Pmolmar
2021-08-27T12:30:12Z
pmolmar.github.io
2021-08-27T12:31:13Z
SYTW-C
2021-09-30T17:57:17Z
```

## Extension

Write and publish a gh extension using preferably Node.JS. Choose your own idea.

Suggestions. 

* It may be `gh-repo-delete [org/repo]` that deletes the specified remote repo or something similar. 
* Another idea: `gh-repo-rename org/reponame newname` changes the name of the repo to `org/newname` . See <https://docs.github.com/en/rest/reference/repos#update-a-repository>
* Rewriting an existing extension in Node.JS. For example [crguezl/gh-clone-org](https://github.com/crguezl/gh-clone-org)
See an example of how to write a gh extension in Node.JS in [crguezl/gh-submodule-add](https://github.com/crguezl/gh-submodule-add)

{% comment %}
* May be too much work: `gh-submodule-add '<[org1]/repo1>,...,<[orgN]/repoN>'` adds to the current repo the repos specified in the comma separated list `org1/repo1`, `org2/repo2`, etc as [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) of the current repo. 
  - If some org as  `org1` is not specified, it is assumed to be  the same organization of the current repo.
  - If one of the repos does'nt exist, throw an error.
{% endcomment %}

{% comment%}
this is possible with the GitHub API by sending a PATCH request to /repos/{owner}/{repo} and specifying a different name parameter (docs).

gh api -X PATCH --raw-field name=new-name repos/account-name/current-name

{% endcomment%}

## References

* [Apuntes de gh]({{site.baseurl}}/tema1-introduccion/gh.html)
* GitHub API doc for [Delete repository](https://docs.github.com/es/rest/reference/repos#delete-a-repository)
* See an example of extension at [crguezl/gh-clone-org](https://github.com/crguezl/gh-clone-org) in bash
* An example of a gh extension in Node.JS in [crguezl/gh-submodule-add](https://github.com/crguezl/gh-submodule-add)
* GitHub docs for [Creating GitHub CLI extensions](https://docs.github.com/es/github-cli/github-cli/creating-github-cli-extensions)
* Here is a list of repos with the topic `gh-extension`: [gh-extension](https://github.com/topics/gh-extension) list
* [GitHub GraphQL Playground](https://docs.github.com/en/graphql/overview/explorer)
* [An Introduction to GraphQL via the GitHub API](https://www.cloudbees.com/blog/an-introduction-to-graphql-via-the-github-api)  by Derek Haynes


