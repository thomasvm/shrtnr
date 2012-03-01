
/**
 * Module dependencies.
 */

require("coffee-script");
var express = require('express')
  , routes = require('./routes')
  , models = require('./models')
  , middleware = require('./middleware');

var app = module.exports = express.createServer();
var ShortURL = models.ShortURL;

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view options', { pretty: true });  
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(middleware.adderrors);
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
app.get('/', routes.create);
app.post('/', routes.create_post); 

app.get('/created/:hash', function(req, res) {
 	routes.created(req, res, req.params.hash);
});

app.get('/words', routes.words);

app.get('/about', function(req, res) {
    res.render('about', { title: 'About' });
});

// api
app.post('/api/create', routes.api.create);

// redirect
app.get(/([a-zA-Z0-9_!]+)$/, function(req, res) {
    routes.redirect(req, res, req.params[0]);
});

// Stats on hash
app.get(/([a-zA-Z0-9_!]+)\+$/, function(req, res) {
    routes.stats(req, res, req.params[0])
});

app.listen(process.env['app_port'] || 3000);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
