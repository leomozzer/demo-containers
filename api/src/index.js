const express = require('express');
const mysql = require('mysql2');

const app = express();

const PORT = 9001 //change to 9001 when sending all the project

app.get('/', (req, res) => {
  return res.send(`Hello World! ${Date()}`)
})

const connection = mysql.createConnection({
  host: 'mysql',
  user: 'root',
  password: 'skaylink',
  database: 'skaylinkbr'
});

connection.connect();

app.get('/people', function (req, res) {
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
});


app.listen(PORT, '0.0.0.0', function () {
  console.log(`Listening on port ${PORT}`);
})