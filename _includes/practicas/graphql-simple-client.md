## Goal

Write an express web app that shows the published GH cli extensions sorted by stars.
Use The GitHub GRaphQL API to get the data.


## Libraries


```js
const express = require('express');
const app = express()
const { ApolloClient, InMemoryCache, HttpLink, gql } = require('@apollo/client');
const fetch = require('node-fetch');
```


## gql

The `gql` function is a tagged template literal. [Tagged template literals](https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Template_literals) are literals delimited with backticks (`) that call a function (called the tag function) with

1. an array of any text segments from the literal followed by 
2. arguments with the values of any substitutions

`gql` returns the AST of the query. See this repl node session:

```js
> let { ApolloClient, InMemoryCache, HttpLink, gql } = require('@apollo/client');
undefined
> result = gql`
... query GetDogs {
...     dogs {
.....       id
.....   }
... }
... `
{
  kind: 'Document',
  definitions: [
    {
      kind: 'OperationDefinition',
      operation: 'query',
      name: [Object],
      variableDefinitions: [],
      directives: [],
      selectionSet: [Object]
    }
  ],
  loc: { start: 0, end: 43 }
}
```


## Getting Familiar with the GraphQL Explorer

You can run queries on **real GitHub data** using the GraphQL Explorer, an integrated development environment in your browser that includes docs, syntax highlighting, and validation errors. 

Visit <https://docs.github.com/en/graphql/overview/explorer>

## Designing the **search** query

Let us try to design a query to obtain the published GH Cli extensions sorted by stars.

Let us go to the [documentation for `search`](https://docs.github.com/en/graphql/reference/queries#searchresultitemconnection) in the GraphQL API. It give us s.t. like:

<b>Type:</b> <a href="{{site.ghd}}/en/graphql/reference/objects#searchresultitemconnection">SearchResultItemConnection!</a>

<table class="fields width-full">
<thead>
<tr>
  <th>Name</th>
  <th>Description</th>
</tr>
</thead>
<tbody><tr>
<td><p><code>after</code> (<code><a href="{{site.ghd}}/en/graphql/reference/scalars#string">String</a></code>)</p></td>
<td><p></p><p>Returns the elements in the list that come after the specified cursor.</p><p></p>
</td>
</tr><tr>
<td><p><code>before</code> (<code><a href="{{site.ghd}}/en/graphql/reference/scalars#string">String</a></code>)</p></td>
<td><p></p><p>Returns the elements in the list that come before the specified cursor.</p><p></p>
</td>
</tr><tr>
<td><p><code>first</code> (<code><a href="{{site.ghd}}/en/graphql/reference/scalars#int">Int</a></code>)</p></td>
<td><p></p><p>Returns the first <em>n</em> elements from the list.</p><p></p>
</td>
</tr><tr>
<td><p><code>last</code> (<code><a href="{{site.ghd}}/en/graphql/reference/scalars#int">Int</a></code>)</p></td>
<td><p></p><p>Returns the last <em>n</em> elements from the list.</p><p></p>
</td>
</tr><tr>
<td><p><code>query</code> (<code><a href="{{site.ghd}}/en/graphql/reference/scalars#string">String!</a></code>)</p></td>
<td><p></p><p>The search string to look for.</p><p></p>
</td>
</tr><tr>
<td><p><code>type</code> (<code><a href="{{site.ghd}}/en/graphql/reference/enums#searchtype">SearchType!</a></code>)</p></td>
<td><p></p><p>The types of search items to search within.</p><p></p>
</td>
</tr></tbody>
</table>
<hr>

We see also that result of a search has the type [SearchResultItemConnection](https://docs.github.com/en/graphql/reference/objects#searchresultitemconnection) that describes the list of results that matched against our search query.

## Searching in GitHub

To fill the `query` field we need to find out how to search for `"gh-extensions"`.

Let us go to the GitHub docs for search syntax. We need to read:

1. [Understanding the search syntax](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax)
2. [Sorting Search Results](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/sorting-search-results)

try different searches

## The SearchResultItemConnection Type

We see that result of a GraphQL search has the type [SearchResultItemConnection](https://docs.github.com/en/graphql/reference/objects#searchresultitemconnection) that describes the list of results that matched against our search query.

These are the fields:

 <h4>Fields</h4>
 <table class="fields width-full">
<thead>
<tr>  <th>Name</th>  <th>Description</th></tr>
</thead>
<tbody>

<tr><td><p><code>codeCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of pieces of code that matched the search query.</p><p></p></td></tr>

<tr><td><p><code>discussionCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of discussions that matched the search query.</p><p></p></td></tr>

<tr>
<td><p><code>edges</code> (<code><a href="{{ghd}}/en/graphql/reference/objects#searchresultitemedge">[SearchResultItemEdge]</a></code>)</p></td>
<td><p></p><p>A list of edges.</p><p></p>
</td>
</tr>

<tr>
<td><p><code>issueCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of issues that matched the search query.</p><p></p>
</td>
</tr>

<tr>
<td><p><code>nodes</code> (<code><a href="{{ghd}}/en/graphql/reference/unions#searchresultitem">[SearchResultItem]</a></code>)</p></td>
<td><p></p><p>A list of nodes.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>pageInfo</code> (<code><a href="{{ghd}}/en/graphql/reference/objects#pageinfo">PageInfo!</a></code>)</p></td>
<td><p></p><p>Information to aid in pagination.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>repositoryCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of repositories that matched the search query.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>userCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of users that matched the search query.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>wikiCount</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#int">Int!</a></code>)</p></td>
<td><p></p><p>The number of wiki pages that matched the search query.</p><p></p>
</td>
</tr>
</tbody>
</table>


## Connections

The result type is a [SearchResultItemConnection](https://docs.github.com/en/graphql/reference/objects#searchresultitemconnection) which means is a special kind of **Connection**.

The concept of **Connection** belongs to GraphQL.

A **connection** is a collection of objects with metadata such as `edges`, `pageInfo`, etc.

### pageInfo

The `pageInfo` object contains information as  

<h4>Fields</h4>
<table class="fields width-full">
<thead>
<tr><th>Name</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td><p><code>endCursor</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#string">String</a></code>)</p></td>
<td><p></p><p>When paginating forwards, the cursor to continue.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>hasNextPage</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#boolean">Boolean!</a></code>)</p></td>
<td><p></p><p>When paginating forwards, are there more items?.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>hasPreviousPage</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#boolean">Boolean!</a></code>)</p></td>
<td><p></p><p>When paginating backwards, are there more items?.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>startCursor</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#string">String</a></code>)</p></td>
<td><p></p><p>When paginating backwards, the cursor to continue.</p><p></p>
</td>
</tr>
</tbody>
</table>

`hasNextPage` will tell us if there are more `edges` available, or if we’ve reached the end of this connection.

### The array of records: edges

Edges will provide us with flexibility to use our data.
In the  example of a search, the edges are of type [SearchResultItemEdge](https://docs.github.com/en/graphql/reference/objects#searchresultitemedge)

<h4>Fields</h4>
<table class="fields width-full">
<thead>
<tr>
  <th>Name</th> <th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><p><code>cursor</code> (<code><a href="{{ghd}}/en/graphql/reference/scalars#string">String!</a></code>)</p></td>
<td><p></p><p>A cursor for use in pagination.</p><p></p>
</td>
</tr>

<tr>
<td><p><code>node</code> (<code><a href="{{ghd}}/en/graphql/reference/unions#searchresultitem">SearchResultItem</a></code>)</p></td>
<td><p></p><p>The item at the end of the edge.</p><p></p>
</td>
</tr>
<tr>
<td><p><code>textMatches</code> (<code><a href="{{ghd}}/en/graphql/reference/objects#textmatch">[TextMatch]</a></code>)</p></td>
<td><p></p><p>Text matches on the result found.</p><p></p>
</td>
</tr>
</tbody>
</table> 

**edges** will help us for the pagination: Each edge has a `node` which is a record or a data and a `cursor` that is a base64 encoded string to help relay with pagination.

### nodes

In our example the nodes are of the type [SearchResultItem](https://docs.github.com/en/graphql/reference/unions#searchresultitem) that can be almost anything since they are a union type.

## unions

Unions do not define any fields, **so no fields may be queried on this type** without the use of type **refining fragments** or **inline fragments**[^1].

## fragments 

Fragments are the primary unit of composition in GraphQL.

Fragments allow for the reuse of common repeated selections of fields, reducing duplicated text in the document. 
Inline Fragments can be used directly within a selection to condition upon a type condition when querying against an interface or union[^2].

For example,let's say we had a page in our app, which lets us look at the marks of two students side by side. 
You can imagine that such a query implies to repeat the fields at least once - one for each side of the comparison.

```gql 
query compare2studentsNoFragment($id1: String!, $id2: String!) {
  
  left: student(AluXXXX: $id1) {
    Nombre
    AluXXXX
    markdown
  }
  
  right: student(AluXXXX: $id2) {
    Nombre
    AluXXXX
    markdown
  }
}
```

The repeated fields could be extracted into a fragment and composed by a parent fragment or query.


```gql
fragment studentInfo on Student {
  Nombre
  AluXXXX
  markdown
}

query compare2students($id1: String!, $id2: String!) {
  # fragment example
  
  left: student(AluXXXX: $id1) {
    ... studentInfo
  }
  
  right: student(AluXXXX: $id2) {
    ... studentInfo
  }
}
```

## Aliases

If you have a sharp eye, you may have noticed that, since the result object fields match the name of the field in the query but don't include arguments, 
**you can't directly query for the same field with different arguments**.

That's why you need **aliases** - they let you rename the result of a field to anything you want. 
In the above example, thw two `student` fields would have conflicted, but 
since we can alias them to different names `left` and `right`, we can get both results in one request.

## Default Values

Default values can also be assigned to the variables in the query by adding the default value after the type declaration.


```gql
query getStudent($id1: String = "232566@studenti.unimore.it") {
  student(AluXXXX: $id1) {
    Nombre
    markdown
  }
}
```

## The query

After what we have explained, we can make an attempt trying this query in the [explorer](https://docs.github.com/en/graphql/overview/explorer):

```gql
{
  search(query: "topic:gh-extension sort:stars", type: REPOSITORY, first: 2 ) {
    repositoryCount
    edges {
      cursor
      node {
        ... on Repository {
          nameWithOwner
          description
          url
          stargazers {
            totalCount
          }
        }
      }
    }
  }
}
```

that give us the number of repositories corresponding to gh-extensions.


```json
{
  "data": {
    "search": {
      "repositoryCount": 101,
      "edges": [
        {
          "cursor": "Y3Vyc29yOjE=",
          "node": {
            "nameWithOwner": "mislav/gh-branch",
            "description": "GitHub CLI extension for fuzzy finding, quickly switching between and deleting branches.",
            "url": "https://github.com/mislav/gh-branch",
            "stargazers": {
              "totalCount": 117
            }
          }
        },
        {
          "cursor": "Y3Vyc29yOjI=",
          "node": {
            "nameWithOwner": "vilmibm/gh-screensaver",
            "description": "full terminal animations",
            "url": "https://github.com/vilmibm/gh-screensaver",
            "stargazers": {
              "totalCount": 61
            }
          }
        }
      ]
    }
  }
}
```

Now we can use the cursor of the last element to make the next request.

## Building the Apollo Client

```
const cache = new InMemoryCache();
const client = new ApolloClient({
  link: new HttpLink({
    uri: "https://api.github.com/graphql", 
    fetch, 
    headers: { 'Authorization': `Bearer ${process.env['GITHUB_TOKEN']}`, },
  }),
  cache
});
```

[HttpLink](https://www.apollographql.com/docs/react/api/link/apollo-link-http/) is a 
<a href="https://www.apollographql.com/docs/react/api/link/introduction/">**terminating link**</a>
that sends a **GraphQL operation** to a remote endpoint over HTTP. 




The HttpLink constructor takes an options object that can include:

- The `uri`  parameter is the URL of the GraphQL endpoint to send requests to. 
The default value is `/graphql`.

- The `fetch` parameter is A function to use instead of calling the Fetch API directly when sending HTTP requests to your GraphQL endpoint. The function must conform to the signature of `fetch`.

- The `headers` parameter is an object representing headers to include in every HTTP request.



## Caching

In an endpoint-based API, clients can use HTTP caching to easily avoid refetching resources, and for identifying when two resources are the same. The URL in these APIs is a globally unique identifier that the client can leverage to build a cache. 

HTTP cache semantics allow for cacheable responses to be stored locally by clients, moving the cache away from the server-side and closer to the client for better performance and reduced network dependence.

To support this, HTTP makes available several caching options through the `Cache-Control` response header that defines if the response is cacheable and, if so, for how long. Responses may only be cached if the HTTP method is `GET` or `HEAD` and the proper `Cache-Control` header indicates the content is cacheable.

In GraphQL, though, there's no URL-like primitive that provides this globally unique identifier for a given object. It's hence a best practice for the API to expose such an identifier for clients to use. 

See the section [Caching in Apollo Client](https://www.apollographql.com/docs/react/caching/overview/) for  details on how the Apollo Client
stores the results of your GraphQL queries in a local, <a href="https://www.apollographql.com/docs/react/caching/overview/#data-normalization">normalized</a>, in-memory cache. This enables Apollo Client to respond immediately to queries for already-cached data, without  sending a network request.


## Pagination

See [Pagination in Apollo Client](https://www.apollographql.com/docs/react/pagination/overview/)

## Express Routes

Now the handler for requests to the main  `/` route is simple:

```js
 app.get('/', function(req, res) {
  client
    .query({query: firstQuery})
    .then(queryRes => handler(res, queryRes))
    .catch(error => console.error(error))
});
```

We make the GraphQL query `firstQuery` using the `query` method of the ApolloClient `client`
that it is sent to the GitHub GraphQL API endpoint. It returns a Promise. 
When the promise is fulfilled, we get in the variable `queryRes` the response of the GitHub server.
We pass both our object `res` to elaborate the response and the `queryRes` 
object to our `handler` function that renders the results of the query:


```js
const handler = (res, queryRes) => {
  const repos = queryRes.data.search.edges;
  const repoCount = queryRes.data.search.repositoryCount
  if (repos.length) {
    let lastCursor = repos[repos.length-1].cursor;
    res.render('pages/index',{ repos: repos, lastCursor: lastCursor });
  } else {
      console.log('No more repos found!');
      console.log(`Array came empty repoCount=${repoCount}`)
  }
}
```

The first call to `handler` gets from `queryRes` the array `repos` 
corresponding to the first page of json objects describing the matching repositories.
Then it computes `lastCursor`, the cursor of the last item in the incoming page.
Both the array `repos` and `lastCursor` are passed to the view in  `views/pages/index.ejs`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <%- include('../partials/head'); %>
</head>
<body class="container">

<header>
  <%- include('../partials/header'); %>
</header>

<main>
  <div class="jumbotron">
    <h1>Most Starred GitHub Cli Extensions</h1>
   
      <ol start="<%= offset %>">
        <% repos.forEach(function(repo) { %>
          <li>
            <a href="<%= repo.node.url %>" target="_blank">
                <strong><%= repo.node.nameWithOwner %></strong>
            </a>
            <%= repo.node.description %>
          </li>
        <% }); %>
      </ol>
 
        <a href="/next/<%= lastCursor %>">
            <button type="button" class="btn btn-primary btn-sm float-right">Next extensions</button>
        </a>
 
</main>

<footer>
  <%- include('../partials/footer'); %>
</footer>

</body>
</html>       
```

A request to the route `/next/:cursor` is sent when the link button 
to get the next page of gh cli extensions is clicked. The parameter `:cursor` is 
filled with the value of the last cursor of the previous page.

```js
app.get('/next/:cursor', function(req, res) {
  client
    .query({ query: subsequentQueries(req.params.cursor)})
    .then(queryRes => handler(res,queryRes))
    .catch(error => console.error(error))
});
```

After we the `app` to listen for requests 

```js
app.listen(7000, () => console.log(`App listening on port 7000!`))
```

we can visit the page with our browser:

![]({{site.bseurl}}/assets/images/most-starred-github-cli-extensions.png)


## References

* [GraphQL Hello World](https://youtu.be/DyvsMKsEsyE). A YouTube list of videos by Ben Awad

* Apollo Client API Core
  *   [ApolloClient](https://www.apollographql.com/docs/react/api/core/ApolloClient/)
  *   [InMemoryCache](https://www.apollographql.com/docs/react/api/cache/InMemoryCache/)
  *   [ObservableQuery](https://www.apollographql.com/docs/react/api/core/ObservableQuery/)
  *   [`query(options): Promise<ApolloQueryResult>`](https://www.apollographql.com/docs/react/api/core/ApolloClient/#ApolloClient.query)
  
* [Caching in GraphQL](https://graphql.org/learn/caching/)
  * [Caching in Apollo Client](https://www.apollographql.com/docs/react/caching/overview/)

## Footnotes

[^1]: https://spec.graphql.org/June2018/#sec-Unions
[^2]: https://spec.graphql.org/June2018/#sec-Language.Fragments

