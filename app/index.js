var express = require('./node_modules/express'); //try changing it to just express
var app = express();
const port = 3010;
app.use(express.static('src')); // All our static files 
app.get('/', function (req, res) {
  res.render('index.html');
});



app.listen(process.env.PORT || port, function () {
    console.log('My Express App listening on port 3010!');
  });