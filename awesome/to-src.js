const replace = require('replace-in-file');
const results = replace.sync({
  files: ['src/style/**'],
  from: /\/dist\//g,
  to: '/src/'
});
//console.log(results);
