## Goals

Follow the [Tutorial](https://pusher.com/tutorials/chat-graphql-subscriptions/) *Building live chat app with GraphQL subscriptions* and reproduce the steps.

![]({{site.baseurl}}/assets/images/graphql-subscriptions-playground.png)

Use the corresponding repo [GitHub crguezl/graphql-chat-app](https://github.com/crguezl/graphql-chat-app) to see more details.

## Hello Subscriptions


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

![]({{ site.baseurl }}/assets/images/graphql-hello-subscriptions.png)

## References

* [Repo GitHub crguezl/graphql-chat-app](https://github.com/crguezl/graphql-chat-app) Chat with Subscriptions
* [Tutorial](https://pusher.com/tutorials/chat-graphql-subscriptions/) *Building live chat app with GraphQL subscriptions*
* [Realtime GraphQL Subscriptions](https://www.howtographql.com/graphql-js/7-subscriptions/) from GRAPHQL-NODE TUTORIAL. Written by Maira Bello: Build your own GraphQL server
