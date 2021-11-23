---
title: GraphQL Subscriptions with Node.js
---


## The Query Object: queries

### Schema

```gql
  type Query {
        getPosts: [Post!]!
        getPost(query: String!): [Post]
    }
```   

### Resolvers for the queries

```js 
const resolvers = {
    Query: {
        getPosts() {
          return posts;
        },
        getPost(parent, args) {
                return posts.filter((post) => {
                const inBody = post.body.toLowerCase().includes(args.query.toLowerCase())
                const inTitle = post.title.toLowerCase().includes(args.query.toLowerCase())
                return inBody || inTitle;
            });
        }
    },
    Mutation: { ... },
    Subscription: { ... },
}
```

### Example of query `getPost`

```gql
query {
  getPost(query: "recusandae") {
    id
    title
    body
    author
    published
  }
}
```

### Example of answer to the query `getPost`

```json 
{
  "data": {
    "getPost": [
      {
        "id": "7",
        "title": "Et sunt in error et recusandae ut animi ut.",
        "body": "magni adipisci voluptatibus",
        "author": "Anabelle Sipes",
        "published": true
      }
    ]
  }
}
```

## Mutations

### createPost

### typeDef for createPost

```gql 
    type Post{
        id:ID
        title:String
        subtitle:String
        body:String
        published:Boolean
        author: String
        upvotes: Int
        downvotes: Int
        commentCount: Int
    }

    type Mutation{
        createPost(
          id:ID!
          title:String
          subtitle:String
          body:String
          published:Boolean
          author: String!
          upvotes: Int
          downvotes: Int
          commentCount: Int
        ): Post!

        updatePost( ... ): Post!
        deletePost(id: ID!): Post!
    }
``` 

### Resolver for createPost

```js
    Mutation: {
        createPost(parent, args, { pubsub }) {
            const id = parseInt(args.id, 10);
            const postIndex = posts.findIndex((post) => post.id === id);
            if (postIndex === -1) {
                posts.push({
                    ...args
                });

                pubsub.publish('post', {
                    post: {
                        mutation: 'CREATED',
                        data: { ...args }
                    }
                });

                return { ...args };
            };
            throw new Error('Post with same id already exist!');
        },
        updatePost(parent, args, { pubsub }) { ... },
        deletePost(parent, args, { pubsub }) { ... },
    },
```

### Sending createPost Mutations

#### Invalid example 

```gql 

mutation withError{
  createPost(
    id: 3, title: "hello", body: "world", 
    author: "Casiano") {
    id
    title
    body
    author
  }
}
```

the answer is:

```json
{
  "data": null,
  "errors": [
    {
      "message": "Post with same id already exist!",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "createPost"
      ]
    }
  ]
}
```

#### Valid Example

```gql
mutation ok {
  createPost(
    id: 11, title: "hello", body: "world", 
    author: "Casiano") {
    id
    title
    body
    author
  }
}
``` 

The answer is:

```json
{
  "data": {
    "createPost": {
      "id": "11",
      "title": "hello",
      "body": "world",
      "author": "Casiano"
    }
  }
}
```

## Full typeDef Code

```gql 
  type Query {
        getPosts: [Post!]!
        getPost(query: String!): [Post]
    }

    type Post{
        id:ID
        title:String
        subtitle:String
        body:String
        published:Boolean
        author: String
        upvotes: Int
        downvotes: Int
        commentCount: Int
    }

    type Mutation{

        updatePost(
          id:ID!
          title:String!
          subtitle:String
          body:String!
          published:Boolean
          author: String!
          upvotes: Int
          downvotes: Int
          commentCount: Int
        ): Post!
        
        deletePost(id: ID!): Post!
        
        createPost(
          id:ID!
          title:String
          subtitle:String
          body:String
          published:Boolean
          author: String!
          upvotes: Int
          downvotes: Int
          commentCount: Int
        ): Post!
    }

    type Subscription {
        post: SubscriptionPayload
    }
    
    type SubscriptionPayload {
        mutation: String
        data: Post
    }
```

## Full code of resolvers

```js 
const resolvers = {
    Query: {
        // return all posts
        getPosts() {
            return posts;
        },
        // return post by args passed, for now it just check for body and 
        // title for the post
        getPost(parent, args) {
            console.log(args);
            return posts.filter((post) => {
                console.log(post.title, post.id)
                const inBody = post.body.toLowerCase().includes(args.query.toLowerCase())
                const inTitle = post.title.toLowerCase().includes(args.query.toLowerCase())
                console.log(inTitle)
                return inBody || inTitle;
            });
        }
    },

    Mutation: {
        createPost(parent, args, { pubsub }) {
            const id = parseInt(args.id, 10);
            const postIndex = posts.findIndex((post) => post.id === id);
            if (postIndex === -1) {
                posts.push({
                    ...args
                });

                pubsub.publish('post', {
                    post: {
                        mutation: 'CREATED',
                        data: { ...args }
                    }
                });

                return { ...args };
            };
            throw new Error('Post with same id already exist!');
        },
        updatePost(parent, args, { pubsub }) {
            const id = parseInt(args.id, 10);
            const postIndex = posts.findIndex((post) => post.id === id);
            if (postIndex !== -1) {
                const post = posts[postIndex];
                const updatedPost = {
                    ...post,
                    ...args
                };
                posts.splice(postIndex, 1, updatedPost);
                pubsub.publish('post', {
                    post: {
                        mutation: 'UPDATED',
                        data: updatedPost
                    }
                });
                return updatedPost;
            }
            throw new Error('Post does not exist!');
        },
        deletePost(parent, args, { pubsub }) {
            const id = parseInt(args.id, 10);
            const isPostExists = posts.findIndex((post) => post.id === id);
            if (isPostExists === -1) {
                throw new Error('Post does not exist!');
            }
            //splice will return the index of the removed items from the array object
            const [post] = posts.splice(isPostExists, 1);
            // return post;
            pubsub.publish('post', {
                post: {
                    mutation: 'DELETED',
                    data: post
                }
            })
            return post;
        },
    },

    Subscription: {
        post: {
            subscribe(parent, args, { pubsub }) {
                return pubsub.asyncIterator('post');
            }
        }
    },
}
```

## Execution 

![]({{site.baseurl}}/assets/images/graphql/graphql-mutation.png)


![]({{site.baseurl}}/assets/images/graphql/graphql-subscription-notification.png)

## References

{% include graphql-subscriptions-references.md %}
