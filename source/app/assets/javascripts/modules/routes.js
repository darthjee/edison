(function(angular) {
  var module = angular.module("edison");

  module.config(["kantoProvider", function(provider) {
    provider.defaultConfig = {
      controller: "Cyberhawk.Controller",
      controllerAs: "gnc",
      templateBuilder: function(route, params) {
        return route + "?ajax=true";
      }
    }

    provider.configs = [{
      routes: ["/"],
      config: {
        controller: "Home.Controller",
        controllerAs: "hc"
      }
    }, {
      routes: ["/browse/:id"],
      config: {
        controller: "Browse.Controller",
        controllerAs: "browseController"
      }
    }];
    provider.$get().bindRoutes();
  }]);
}(window.angular));
