(function(_, angular, $) {
  var app = angular.module("browse/controller", [
    "cyberhawk/controller",
    "cyberhawk/notifier",
    "binded_http"
  ]);

  function Controller(builder, notifier, $location, bindedHttp) {
    this.construct(builder.build($location), notifier, $location);
    this.location = $location;
    this.http     = bindedHttp.bind(this);

    _.bindAll(this, 'setFolders', 'setFiles');

    this.getFolders();
    this.getFiles();
  }

  var fn = Controller.prototype;

  _.extend(fn, Cyberhawk.Controller.prototype);

  fn.getFolders = function() {
    this.http
      .get(this.path('folders'))
      .success(this.setFolders);
  };

  fn.setFolders = function(data) {
    this.folders = data;
  };

  fn.getFiles = function() {
    this.http
      .get(this.path('files'))
      .success(this.setFiles);
  };

  fn.setFiles = function(data) {
    this.files = data;
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
    'cyberhawk_requester', 'cyberhawk_notifier', '$location',
    "binded_http",
    Controller
  ]);
}(window._, window.angular, window.$));
