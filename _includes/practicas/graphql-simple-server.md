## Requisitos

Usando los módulos npm [express](https://expressjs.com/), [express-graphql](https://graphql.org/graphql-js/running-an-express-graphql-server/) y [graphql](https://graphql.org/) escriba un servicio web con una API GraphQL y pruébela usando [GraphiQL](https://youtu.be/5BwmvekYCpY).

## Set up

Para hacer esta práctica empezaremos instalando los módulos que necesitamos y luego en `index.js` importamos las correspondientes funciones:

```js
const express = require("express")
const { graphqlHTTP } = require("express-graphql")
const { buildSchema } = require("graphql")
```

Puede aprovechar cualquier hoja de cálculo que tenga a mano y la exporta a CSV, para  usarla como datos de entrada para hacer las pruebas en esta práctica.

Después, puede usar el módulo [csvtojson](https://github.com/Keyang/node-csvtojson#command-line-usage) para convertir los datos a un objeto JS.

```js
const csv=require('csvtojson')
const port = process.argv[2] || 4006;
const csvFilePath = process.argv[3] || 'SYTWS-2122.csv'
const data = String(fs.readFileSync(csvFilePath))
```

Para hacer el parsing del fichero CSV podemos llamar a `csv().fromFile(<file>)` o bien puede usar el ejecutable de línea de comandos que provee `$ csvtojson [options] <csv file path>`.

```js
async function main () {
    let classroom = await csv().fromFile(csvFilePath);
    ...
}
```

Esto deja en `classroom` un array con las filas del CSV. En este caso de ejemplo, la información sobre las calificaciones de los estudiantes.

Uno de los primeros pasos a la hora de construir un servicio GraphQL es definir el esquema GraphQL usando el lenguaje SDL.

## GraphQL Schema 

A **GraphQL schema**[^1] is at the center of any GraphQL server implementation and describes the functionality available to the clients which connect to it. An Schema is written using the **Schema Definition Language (SDL)**[^2], that defines
the syntax for writing GraphQL Schemas. It is otherwise known as **Interface Definition Language**. It is the lingua franca shared for building GraphQL APIs regardless of the programming language chosen.

Here is an example of a GraphQL Schema written in SDL:

```gql
  type Student {
      AluXXXX: String!
      Nombre: String!
      markdown: String
  }

  type Query {
      students: [ Student ]
      student(AluXXXX: String!): Student
  }

  type Mutation {
      addStudent(AluXXXX: String!, Nombre: String!): Student
      setMarkdown(AluXXXX: String!, markdown: String!): Student 
  }
```

In addition to queries and mutations, GraphQL supports a third operation type: **[subscriptions](https://www.apollographql.com/docs/react/data/subscriptions/)**

Like queries, subscriptions enable you to fetch data. Unlike queries, subscriptions are long-lasting operations that can change their result over time. They can maintain an active connection to your GraphQL server (most commonly via [WebSocket]({{site.baseurl}}/tema3-web/websockets)), enabling the server to push updates to the subscription's result.


GraphQL SDL is a typed language. Types can be **Scalar** or can be composed as the `Student` type in the former 
example.

GraphQL ships with some scalar types out of the box; `Int`, `Float`, `String`, `Boolean` and `ID`. 

The fields whose types have an exclamation mark, `!`, next to them are **non-null** fields. These are fields that won’t return a `null` value when you query them.

The function `buildSchema` provided by the `graphql` module has the signature:


```js
function buildSchema(source: string | Source): GraphQLSchema
```

Creates a [GraphQLSchema object](https://graphql.org/graphql-js/type/#graphqlschema) from GraphQL schema language. 
The schema will use default **resolvers**[^3]. 

```js
const AluSchema = buildSchema(StringWithMySchemaDefinition)
```

## Resolvers

A **resolver** is a function that connects **schema fields** and **types** to various backends. 
Resolvers provide the instructions for turning a GraphQL operation into data. 

A resolver can retrieve data from or write data to anywhere, including a SQL, No-SQL, or graph database, a [micro-service]({{site.baseurl}}/tema2-async/message-queues.html), 
and a REST API. Resolvers can also return strings, ints, null, and other types.

To define our resolvers we create now the object `root` mapping the  schema fields (`students`, `student`, `addStudent`, `setMarkdown`) to their corresponding functions:

```js
async function main () {
    let classroom=await csv().fromFile(csvFilePath);
        const root = {
        students: () => classroom,
        student: ({AluXXXX}) => {
            let result = classroom.find(s => {
                return s["AluXXXX"] == AluXXXX
            });
            return result
        },
        addStudent: (obj, args, context, info) => {
            const {AluXXXX, Nombre} = obj; 

            let result = classroom.find(s => {
                return s["AluXXXX"] == AluXXXX
            });
            if (!result) {
                let alu = {AluXXXX : AluXXXX, Nombre: Nombre}
                console.log(`Not found ${Nombre}! Inserting ${AluXXXX}`)
                classroom.push(alu)
                return alu    
            }
            return result;
        },
        setMarkdown: ({AluXXXX, markdown}) => {
            let result = classroom.findIndex(s => s["AluXXXX"] === AluXXXX)
            if (result === -1) {
              let message = `${AluXXXX} not found!`
              console.log(message);
              return null;
            } 
            classroom[result].markdown = markdown
            return classroom[result]
        }
    }
      
    ... // Set the express app to work
}

main();
```

Observe how `setMarkDown` and `addStudent` sometimes return `null` since it is allowed by the schema we have previously set.

```gql 
 setMarkdown(AluXXXX: String!, markdown: String!): Student
 ```

There is no exclamation `!` at the value returned in the declaration of the `setMarkDown` mutation.

BLAH!!!
![]({{site.baseurl}}/assets/images/graphql-stages.png)

[Every GraphQL query goes through these phases](https://medium.com/paypal-tech/graphql-resolvers-best-practices-cd36fdbcef55):

1. Queries are parsed into an abstract syntax tree (or AST). See <https://astexplorer.net/> 
2. Validated: Checks for  query  correctness and check if the fields exist. 
3. Executed: The runtime walks through the AST, 
    1. Descending from the root of the tree, 
    2. Invoking resolvers, 
    3. Collecting up results, and 
    4. Emiting the final JSON

<table>
<tr>
<td><img src="{{site.baseurl}}/assets/images/graphql-query.png" height="80%" /></td>
<td><img src="{{site.baseurl}}/assets/images/graphql-ast.png" /></td>
</tr>
</table>

In this example, the root Query type is the entry point to the AST and contains two fields, `user` and `album`. The `user` and `album` resolvers are usually executed in parallel or in no particular order. 

The AST is traversed breadth-first, meaning `user` must be resolved before its children `name` and `email` are visited. 

If the user resolver is asynchronous, the user branch delays until its resolved. Once all leaf nodes, `name`, `email`, `title`, are resolved, execution is complete.

![]({{site.baseurl}}/assets/images/graphql-schema-vs-query.jpeg)


Typically, fields are executed in the order they appear in the query, but it’s not safe to assume that. Because fields can be executed in parallel, they are assumed to be atomic, idempotent, and side-effect free.

A resolver is a function that resolves a value for a type or field in a schema. 
- Resolvers can return objects or scalars like Strings, Numbers, Booleans, etc. 
- If an Object is returned, execution **continues to the next child field**. 
- If a scalar is returned (typically at a leaf node of the AST), execution completes. 
- If `null` is returned, execution halts and does not continue.

It’s worth noting that a GraphQL server has built-in default resolvers, so you don’t have to specify a resolver function for every field. A default resolver will look in root to find a property with the same name as the field. An implementation likely looks like this:

```js
export default {
    Student: {
        AluXXXX: (root, args, context, info) => root.AluXXXX,
        Nombre: (root, args, context, info) => root.Nombre,
        markdown: (root, args, context, info) => root.markdown

    }
}
```

This is the reason why there wass no need to implement the resolvers for these fields.

## Starting the express-graphql middleware

Now what remains is to set the `graphqlHTTP`  the **[express middleware]({{site.baseurl}}/tema3-web/express)** provided by the module `express-graphql` to work

```js

const app = express()

async function main () {
    let classroom = await csv().fromFile(csvFilePath);
    const root = { ... }
      
    app.use(
        '/graphql',
        graphqlHTTP({
          schema: AluSchema,
          rootValue: root,
          graphiql: true,
        }),
      );
      
      app.listen(port);
      console.log("Running at port "+port)
}
```

It  has the following properties:

* **schema**, our GraphQL schema
* **rootValue**, our resolver functions
* **graphiql**, a boolean stating whether to use [graphiql](https://youtu.be/5BwmvekYCpY), we want that so we pass true here

## Testing with GraphiQL

We can now run the app and open the browser at  the url `http://localhost:4000/graphql`  to make graphql queries using GraphiQL.

Use **GraphiQL** to test your API. GraphiQL is an in-browser IDE for GraphQL development and workflow.
Para ello vea este video:

{% include video id="5BwmvekYCpY" provider="youtube" %}

{% comment %}
{% include video id="atRadu-DKCE" provider="youtube" %}
{% endcomment %}

## References

* See inside the repo [crguezl/learning-graphql-with-gh](https://github.com/crguezl/learning-graphql-with-gh/tree/main/simple-graphql-express-server-example) the folder `simple-graphql-express-server-example/` with the example used in this description

* Youtube video [GraphQL Tutorial. Nos montamos una API con Nodejs y Express](https://youtu.be/atRadu-DKCE) 
* [Life of a GraphQL Query — Validation](https://medium.com/@cjoudrey/life-of-a-graphql-query-validation-18a8fb52f189) Christian Joudrey
* [GraphQL HTTP Server Middleware: GitHub repo graphql/express-graphql](https://github.com/graphql/express-graphql)
* [GRaphQL Glossary](https://www.apollographql.com/docs/resources/graphql-glossary/)

* [Queries y GraphiQL con la API de Rick & Morty (Curso express GraphQL)](https://youtu.be/5BwmvekYCpY)
* [GraphiQL Shortcuts](https://defkey.com/graphiql-shortcuts)
* [GraphQL fragments explained](https://blog.logrocket.com/graphql-fragments-explained/)
* [GraphQL Resolvers: Best Practices](https://medium.com/paypal-tech/graphql-resolvers-best-practices-cd36fdbcef55) by Mark Stuart
* <https://astexplorer.net/>
* [GraphQL Hello World](https://youtu.be/DyvsMKsEsyE). A YouTube list of videos by Ben Awad
  * [How GraphQL Resolvers Work](https://youtu.be/pI5CKxyrbiI)

## FootNotes

[^1]: For more detail on the GraphQL schema language, see the <a href="https://graphql.org/learn/schema/">schema language docs</a> 
[^2]: <a href="https://wehavefaces.net/graphql-shorthand-notation-cheatsheet-17cd715861b6#.9oztv0a7n" target="_blank" rel="nofollow noopener noreferrer">Schema language cheat sheet</a>
[^3]: <a href="https://graphql.org/learn/execution/#root-fields-resolvers" target="_blank">Root fields & resolvers</a>
