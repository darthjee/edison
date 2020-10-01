(function(_, angular, $) {
  var app = angular.module("browse/controller", [
    "cyberhawk/controller",
    "cyberhawk/notifier",
    "binded_http"
  ]);

  function Controller($location, bindedHttp, notifier) {
    this.location = $location;
    this.http     = bindedHttp.bind(this);
    this.notifier = notifier;

    //_.bindAll(this)
    this.getFolders();
  }

  var fn = Controller.prototype;

  fn.getFolders = function() {
    this.http
      .get(this.path('folders'))
      .success(this.setFolders);
  };

  fn.setFolders = function(data) {
    this.folders = data;
  };

  fn.path = function(entity) {
    return this.location.url() + '/' + entity + '.json';
  };

  fn.initRequest = function() {
    this.ongoing = true;
  };

  fn.finishRequest = function() {
    this.ongoing = false;
  };

  app.controller("Browse.Controller", [
    "$location",
    "binded_http",
    "cyberhawk_notifier",
    Controller
  ]);
}(window._, window.angular, window.$));
