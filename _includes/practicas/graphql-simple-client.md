## The GraphQL Explorer

You can run queries on real GitHub data using the GraphQL Explorer, an integrated development environment in your browser that includes docs, syntax highlighting, and validation errors. 

Visit <https://docs.github.com/en/graphql/overview/explorer>

## Exercise: Obtain the published GH Cli extensions sorted by stars

Let us try to design a query to obtain the published GH Cli extensions sorted by stars.

Let us go to the [documentation for `search`](https://docs.github.com/en/graphql/reference/queries#searchresultitemconnection) in the GraphQL API. It give us s.t. like:

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


Let us make an attempt using this query in the explorer:

```gql
query searchGHExtensions {
  search(query: "topic:gh-extension, sort:interactions", type: REPOSITORY, first: 2) {
    repositoryCount
    edges {
      cursor
      node {
        ... on Repository {
          nameWithOwner
        }
      }
    }
  }
}
```

that give us the number of repositories corresponding to gh-extensions.

```gql
      {
        search(query: "topic:gh-extension sort:stars", type: REPOSITORY, first: ${numRepos}, after: "${cursor}") {
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

## References

[^1]: https://spec.graphql.org/June2018/#sec-Unions
[^2]: https://spec.graphql.org/June2018/#sec-Language.Fragments

