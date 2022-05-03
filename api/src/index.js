const express = require('express');
const mysql = require('mysql2');

const app = express();

app.get('/', (req, res) => {
  return res.send('Hello World!')
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


app.listen(9001, '0.0.0.0', function () {
  console.log('Listening on port 9001');
})