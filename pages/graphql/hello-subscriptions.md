# Hello Subscriptions

GraphQL subscriptions enable you to subscribe to events under a source stream and receive notifications in real time via a response stream when a selected event executes. 

Once a GraphQL subscription is executed, a persistent function is created on the server that maps an underlying source stream to a returned response stream.

GraphQL subscriptions differ from queries in the way the data is delivered to the client. 

Queries immediately returns a single response, while subscriptions return a result every time data is published on a topic the client has subscribed.


```js 
import { GraphQLServer, PubSub } from 'graphql-yoga'

const typeDefs = `
  type Query {
    hello: String!
  }

  type Counter {
    count: Int!
    countStr: String
  }

  type Subscription {
    counter: Counter!
  }
`

const resolvers = {
  Query: {
    hello: () => `Hello`,
  },
  Counter: {
    countStr: counter => `Current count: ${counter.count}`,
  },
  Subscription: {
    counter: {
      subscribe: (parent, args, { pubsub }) => {
        const channel = Math.random().toString(36).substring(2, 15) // random channel name
        let count = 0
        setInterval(() => pubsub.publish(channel, { counter: { count: count++ } }), 2000)
        return pubsub.asyncIterator(channel)
      },
    }
  },
}
```

Now, let's create a simple **PubSub** instance - it is a simple pubsub implementation, based on [EventEmitter](). Alternative [EventEmitter]({{site.baseurl}}/pages/event-emitters) implementations can be passed by an options object to the PubSub constructor.

```js
const pubsub = new PubSub()
```

{% include graphql-subscriptions-technologies.md %}

Before to continue with the rest of the code let us review the 

* [EventEmitter]({{site.baseurl}}/pages/event-emitters) class 

```js
const server = new GraphQLServer({ typeDefs, resolvers, context: { pubsub } })
``` 
[pubsub](https://www.apollographql.com/docs/graphql-subscriptions/setup/) is a class that exposes a simple `publish` and `subscribe` API.

It sits between your application's logic and the GraphQL subscriptions engine - it receives a *publish* command from your app logic and pushes it to your GraphQL execution engine.

graphql-subscriptions exposes a default PubSub class you can use for a simple usage of data publication.

The PubSub implementation also includes a mechanism that **converts a specific PubSub event into a stream of AsyncIterator**, which you can use with *graphql subscriptions resolver*.

```js  
server.start(() => console.log('Server is running on localhost:4000'))
```

Now when we visit `localhost:4000` and subscribe we can see the counters moving:

![]({{ site.baseurl }}/assets/images/graphql-hello-subscriptions.png)

