(function (angular) {

  var myApp = angular.module('WebsDemo', ['mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', function ($scope) {

    $scope.modal = {
      "title": "Title",
      "content": "Test Modal Window<br />Some markup"
    };

  }]);

})(window.angular);