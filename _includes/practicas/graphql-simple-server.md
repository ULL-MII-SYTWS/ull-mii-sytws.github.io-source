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

Después, puede usar el módulo [csvtojson]() para convertir los datos a un objeto JS.

```js
const csv=require('csvtojson')
const port = process.argv[2] || 4006;
const csvFilePath = process.argv[3] || 'SYTWS-2122.csv'
const data = String(fs.readFileSync(csvFilePath))
```

Para hacer el parsing del fichero CSV podemos llamar a `csv().fromFile(<file>)`:

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

A resolver can retrieve data from or write data to anywhere, including a SQL, No-SQL, or graph database, a micro-service, 
and a REST API. Resolvers can also return strings, ints, null, and other types.

To define our resolvers we create now the object `root` mapping the  schema fields (`students`, `student`, `addStudent`, `setMarkdown`) to their corresponding functions:

```js
async function main () {
    let classroom=await csv().fromFile(csvFilePath);
    const root = {
        students: () => classroom,
        student: (aluId) => {
            let result = classroom.find(s => s["AluXXXX"] == aluId.AluXXXX);
            return result
        },
        addStudent: ({AluXXXX, Nombre}) => { 
            let result = classroom.find(s => s["AluXXXX"] == AluXXXX);
            if (!result) {
                let alu = {AluXXXX : AluXXXX, Nombre: Nombre}
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

Use **GraphiQL** to test your API. GraphiQL is an in-browser IDE for GraphQL development and workflow.
Para ello vea este video:

{% include video id="5BwmvekYCpY" provider="youtube" %}

{% comment %}
{% include video id="atRadu-DKCE" provider="youtube" %}
{% endcomment %}

## References

* See inside the repo [crguezl/learning-graphql-with-gh](https://github.com/crguezl/learning-graphql-with-gh/tree/main/simple-graphql-express-server-example) the folder `simple-graphql-express-server-example/` with the example used in this description

* Youtube video [GraphQL Tutorial. Nos montamos una API con Nodejs y Express](https://youtu.be/atRadu-DKCE) 

* [GraphQL HTTP Server Middleware: GitHub repo graphql/express-graphql](https://github.com/graphql/express-graphql)
* [GRaphQL Glossary](https://www.apollographql.com/docs/resources/graphql-glossary/)

* [Queries y GraphiQL con la API de Rick & Morty (Curso express GraphQL)](https://youtu.be/5BwmvekYCpY)
* [GraphiQL Shortcuts](https://defkey.com/graphiql-shortcuts)
* [GraphQL fragments explained](https://blog.logrocket.com/graphql-fragments-explained/)

## FootNotes

[^1]: For more detail on the GraphQL schema language, see the <a href="https://graphql.org/learn/schema/">schema language docs</a> 
[^2]: <a href="https://wehavefaces.net/graphql-shorthand-notation-cheatsheet-17cd715861b6#.9oztv0a7n" target="_blank" rel="nofollow noopener noreferrer">Schema language cheat sheet</a>
[^3]: <a href="https://graphql.org/learn/execution/#root-fields-resolvers" target="_blank">Root fields & resolvers</a>
