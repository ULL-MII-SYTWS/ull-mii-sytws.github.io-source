## Goals

Follow the two tutorials below and reproduce the steps.

![]({{site.baseurl}}/assets/images/graphql-subscriptions-playground.png)

Use the corresponding repo 
[Repo crguezl/graphql-subscriptions-with-node-js](https://github.com/crguezl/graphql-subscriptions-with-node-js)

## First Example: Hello Subscriptions

See the section [hello subscriptions]({{ site.baseurl }}/pages/graphql/hello-subscriptions) 


## Second  Example: GraphQL Subscriptions with Node.js

See section [GraphQL Subscriptions with Node.js]({{ site.baseurl }}/pages/graphql/graphql-subscriptions-with-nodejs)

## Challenge

Write a graphQL server tha counts the accepts  `hello` queries like:

```gql
query paula {
  hello(name: "paula")
}

query pablo {
  hello(name: "pablo")
}

query nico {
  hello(name: "nicolas")
}
```

and clients can subscribe to a `greetings` event that occurs each time a `hello` query occurs.
The event triggered by the `hello`  is an object that has not only the name greeted but 
also the number of times it has been greeted.

Therefore  queries like this one must be supported:

```gql 
subscription {
  counter {
    name
    count
  }
}
```

You can find a solution in  the folder `subscriptions/hello-name` of the repo [crguezl/graphql-yoga-examples](https://github.com/crguezl/graphql-yoga-examples/blob/main/subscriptions/hello-name/index.js)

## References

{% include graphql-subscriptions-references.md %}
