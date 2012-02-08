
/**
 * Module dependencies.
 */

require("coffee-script");
var express = require('express')
  , routes = require('./routes')
  , models = require('./models');

var app = module.exports = express.createServer();
var ShortURL = models.ShortURL;

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.static(__dirname + '/public'));
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes
//////////////
app.get('/', routes.index);

app.get('/create', routes.create);
app.post('/create', routes.create_post); 

// redirect
app.get(/([a-zA-Z0-9]{6})$/, function(req, res) {
    routes.redirect(req, res, req.params[0]);
});

// Stats on hash
app.get(/([a-zA-Z0-9]{6})\+$/, function(req, res) {
    routes.stats(req, res, req.params[0])
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
