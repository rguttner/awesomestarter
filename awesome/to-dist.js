const replace = require('replace-in-file');
const results = replace.sync({
  files: ['src/style/**'],
  from: /\/src\//g,
  to: '/dist/'
});
//console.log(results);
