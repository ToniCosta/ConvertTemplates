// Generated by CoffeeScript 1.8.0
var Route, home, homeController;

homeController = require('./controllers/home');

home = new homeController;

Route = (function() {
  function Route(app) {
    app.get('/api', home.get);
  }

  return Route;

})();

module.exports = Route;
