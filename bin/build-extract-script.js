var mysql = require('mysql'),
    fs = require('fs'),
    Promise = require('promise')
    _ = require('underscore');

var queryMostFrequentOfField =
"select counts.mId, counts.@@ " +
"from " +
"( " +
"  select m.mId, cp.@@, count(*) count " +
"  from CProvider cp  " +
"  join Merge m on m.sId = cp.id " +
"  where cp.@@ is not null " +
"  group by m.mId, cp.@@ " +
") counts " +
"where counts.count = " +
"( " +
"  select max(counts.count) " +
"  from " +
"  ( " +
"    select m.mId, count(*) as count " +
"    from CProvider cp  " +
"    join Merge m on m.sId = cp.id " +
"    where cp.@@ is not null " +
"    group by m.mId, cp.@@ " +
"  ) counts2 " +
"  where counts2.mId = counts.mId " +
") " +
// collapse into one record per mId.
// mysql weirdness allows us to keep the first @@ field
// even though we didn't group by it :)
"group by counts.mId";

var queryMostFrequentOfRelatedField =
"select counts.mId, counts.@@ " +
"from " +
"( " +
"  select m.mId, t.@field@ as @@, count(*) count " +
"  from CProvider cp  " +
"  join Merge m on m.sId = cp.id " +
"  join @Table@ t on t.id = cp.@@ " +
"  where t.@field@ is not null " +
"  group by m.mId, t.@field@ " +
") counts " +
"where counts.count = " +
"( " +
"  select max(counts.count) " +
"  from " +
"  ( " +
"    select m.mId, count(*) as count " +
"    from CProvider cp  " +
"    join Merge m on m.sId = cp.id " +
"    join @Table@ t on t.id = cp.@@ " +
"    where t.@field@ is not null " +
"    group by m.mId, t.@field@ " +
"  ) counts2 " +
"  where counts2.mId = counts.mId " +
") " +
"group by counts.mId";

var fields = {
  "name_first": {},
  "name_middle": {},
  "name_last": {},
  "name_suffix": {},
  "name_credential": {},
  "gender": {individual: true},
  "dateOfBirth": {individual: true},
  "isSoleProprietor": {individual: true},
  "phone": {table: "PhoneNumber", field: "phone"},
  "primarySpecialty": {table: "Specialty", field: "code"},
  "secondarySpecialty": {table: "Specialty", field: "code"},
};

var field_keys = _.keys(fields);

_.forEach(field_keys, function(field) {
  var query = fields[field].table ? queryMostFrequentOfRelatedField :
      queryMostFrequentOfField;

  if (fields[field].individual) {
    query = query.replace(/CProvider/g, "CIndividual");
  }

  if (fields[field].table) {
    query = query.replace(/@Table@/g, fields[field].table);
    query = query.replace(/@field@/g, fields[field].field);
  }

  fields[field].query = "(" + query.replace(/@@/g, field) + ") " + field + "_t";
});

var select = "select m.id, m.type, " + field_keys.map(function(field) {
  return field + "_t." + field;
}).join(", ") + "\n";

var query = select + "from MProvider m"

query = _.reduce(field_keys, function(query, field) {
  return query + "\nleft join " + fields[field].query + " on m.id = "
      + field + "_t.mId";
}, query);

// query = 'drop table if exists asdf; create table asdf as (' + query + ');';
 query += ';';

fs.writeFileSync('select-masters.sql', query);
