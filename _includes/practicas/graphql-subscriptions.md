## Goals

Follow the [Tutorial](https://pusher.com/tutorials/chat-graphql-subscriptions/) *Building live chat app with GraphQL subscriptions* and reproduce the steps.

![]({{site.baseurl}}/assets/images/graphql-subscriptions-playground.png)

Use the corresponding repo [GitHub crguezl/graphql-chat-app](https://github.com/crguezl/graphql-chat-app) to see more details.

## Hello Subscriptions

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

const pubsub = new PubSub()
const server = new GraphQLServer({ typeDefs, resolvers, context: { pubsub } })

server.start(() => console.log('Server is running on localhost:4000'))
```

Now when we visit `localhost:4000` and subscribe we can see the counters moving:

![]({{ site.baseurl }}/assets/images/graphql-hello-subscriptions.png)


## References

* [Repo GitHub crguezl/graphql-chat-app](https://github.com/crguezl/graphql-chat-app) Chat with Subscriptions
* [Tutorial](https://pusher.com/tutorials/chat-graphql-subscriptions/) *Building live chat app with GraphQL subscriptions*
* [Realtime GraphQL Subscriptions](https://www.howtographql.com/graphql-js/7-subscriptions/) from GRAPHQL-NODE TUTORIAL. Written by Maira Bello: Build your own GraphQL server

{% include video provider="youtube" id="bn8qsi8jVew" %}