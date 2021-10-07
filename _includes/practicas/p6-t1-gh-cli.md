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

## gh org-list 

Escriba un alias que muestre todas las organizaciones tanto aquellas en que sea miembro público como privado de las mismas:

```
[~/.../gh-learning/gh-clone-org(master)]$ gh org-list | tail -8
GeneticsJS
tfm-y-pce-mfp-2021
MDCCVRP
cooking-lifeboold
ULL-MII-SYTWS-2122
ULL-ESIT-DMSI-2121
ULL-MFP-AET-2122
ULL-ESIT-PL-2122
[~/.../gh-learning/gh-clone-org(master)]$ gh org-list | wc
      65      65    1279
[~/.../gh-learning/gh-clone-org(master)]$ gh org-list | grep 1819
ULL-ESIT-PL-1819
ULL-ESIT-DSI-1819
ULL-MII-CA-1819
```

## Extension

Write and publish a gh extension `gh-repo-delete [org/repo]` that deletes the specified remote repo.

## References

* [Apuntes de gh]({{site.baseurl}}/tema1-introduccion/gh.html)
* GitHub API doc for [Delete repository](https://docs.github.com/es/rest/reference/repos#delete-a-repository)
* See an example of extension at [crguezl/gh-clone-org](https://github.com/crguezl/gh-clone-org)
* GitHub docs for [Creating GitHub CLI extensions](https://docs.github.com/es/github-cli/github-cli/creating-github-cli-extensions)
* Here is a list of repos with the topic `gh-extension`: [gh-extension](https://github.com/topics/gh-extension) list


