var mysql = require('mysql'),
    fs = require('fs'),
    Promise = require('promise');

var readFile = Promise.denodeify(fs.readFile);
var connection = mysql.createConnection({
  host     : process.env['mysql_host'],
  user     : process.env['mysql_user'],
  password : process.env['mysql_password'],
  database : process.env['mysql_database'],
});

connection.connect();
var query = Promise.denodeify(connection.query.bind(connection));

function onRead(data) {
  data = data.toString();
  data = data.split('\n');

  var q = 'insert into SProvider values ' +
      '(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
  var columnCount = 23;

  for (var i = 1; i < data.length; ++i) {
    var line = data[i].replace(/(\r$)/, '').split('\t');
    if (line.length != columnCount) {
      if (i === data.length - 1 && line.length < 2) {
        break;
      }

      throw new Error('invalid column count for id' + line[0]);
    }

    query(q, line).done();
  }
}

readFile(process.argv[2])
.then(onRead)
.done(connection.end.bind(connection));
