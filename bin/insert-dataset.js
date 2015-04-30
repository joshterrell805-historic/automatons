var mysql = require('mysql'),
    fs = require('fs'),
    Promise = require('promise')
    _ = require('underscore');

var readFile = Promise.denodeify(fs.readFile);

module.exports = function(tableName, columnCount, disableFk) {
  var connection = mysql.createConnection({
    host     : process.env['mysql_host'],
    user     : process.env['mysql_user'],
    password : process.env['mysql_password'],
    database : process.env['mysql_database'],
  });

  connection.connect();
  var query = Promise.denodeify(connection.query.bind(connection));

  var qs = [];
  qs.length = columnCount;
  qs = _.map(qs, function() {return '?';});

  function onRead(data) {
    data = data.toString();
    data = data.split('\n');

    var q = 'insert into ' + tableName + ' values (' + qs.join(',') + ')';

    var ps = [];

    for (var i = 1; i < data.length; ++i) {
      var line = data[i].replace(/(\r$)/, '').split('\t');
      line = _.map(line, function(field) {
        return field === '' ? null : field;
      });
      if (line.length != columnCount) {
        if (i === data.length - 1 && line.length < 2) {
          break;
        }

        throw new Error('invalid column count for id' + line[0]);
      }
      ps.push(query(q, line));
    }

    return Promise.all(ps);
  }

  readFile(process.argv[2])
  .then(function(data) {
    return query(disableFk ? 'SET FOREIGN_KEY_CHECKS = 0' : 'select 1')
    .then(function() {
      return data;
    })
  })
  .then(onRead)
  .then(function() {
    return query(disableFk ? 'SET FOREIGN_KEY_CHECKS = 1;' : 'select 1');
  })
  .done(connection.end.bind(connection));
}
