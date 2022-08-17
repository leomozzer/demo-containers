const express = require('express');
const mysql = require('mysql2');
require('dotenv').config()
const app = express();

app.use(express.json())
app.use(express.urlencoded({ 'extended': true }))
app.use((req, res, next) => {
  next();
})

const PORT = 9001 //change to 9001 when sending all the project

app.get('/', (req, res) => {

  return res.json({
    "message": `Hello World! ${Date()}`,
    "host": process.env.MYSQL_HOST
  })
})

try {
  console.log(`Connecting to the MySql on ${process.env.MYSQL_HOST}`)
  const connection = mysql.createConnection({
    host: process.env.MYSQL_HOST ? process.env.MYSQL_HOST : 'mysql',
    user: 'root',
    password: 'skaylink',
    database: 'skaylinkbr',
    port: process.env.MYSQL_PORT ? process.env.MYSQL_PORT : 3306
  });

  connection.connect();
} catch (error) {
  console.log(error)
}

app.get('/people', function (req, res) {
  try {
    connection.query('SELECT * FROM people', function (error, results) {

      if (error) {
        throw error
      };
      console.log(results);
      res.send(
        results.map(item => ({
          name: item.full_name,
          email: item.email,
          title: item.title,
          location: item.location_name
        })
        )
      );
    });
  }
  catch (error) {
    console.log(error)
    res.json({
      'message': JSON.stringify(error, null, 2)
    })
  }
});


app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
  console.log(`Mysql host: ${process.env.MYSQL_HOST}`)
})