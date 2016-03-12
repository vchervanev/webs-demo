(function (angular) {

  var myApp = angular.module('WebsDemo', ['ngAnimate', 'mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', 'SpeakersService', function ($scope, $speakers) {

    $scope.modal = {
      "title": "Title",
      "content": "Test Modal Window<br />Some markup"
    };

    $speakers.loadSpeakers(1, 100).then(function(result){
      $scope.speakers = result
    });

  }]);

})(window.angular);