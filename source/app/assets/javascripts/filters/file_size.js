(function(angular, _) {
  class Sizer {
    constructor(input) {
      this.input = input;
    }

    convert() {
      return "" + this.getExhibit() + " " + this.getSymbol();
    }

    getOrder() {
      if (this.order) {
        return this.order;
      }
      this.reduce();
      return this.order;
    }

    getExhibit() {
      if (this.exhibit) {
        return this.exhibit;
      }
      this.reduce();
      return this.exhibit;
    }

    getSymbol() {
      var symbols = ["B", "KiB", "MiB", "GiB", "TiB"];

      return symbols[this.getOrder()];
    }

    reduce() {
      this.exhibit = this.input;
      this.order = 0;

      while(this.exhibit >= 1024) {
        this.exhibit /= 1024;
        this.order ++;
      }

      if (this.order > 0) {
        this.exhibit = Math.round(this.exhibit * 10) / 10;
      }
    }
  }

  Sizer.convert = function(input) {
    return new Sizer(input).convert();
  };

  angular
    .module("edison")
    .filter("file_size", function() { return Sizer.convert; });
}(window.angular, window._));

