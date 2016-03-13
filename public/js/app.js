(function (angular) {

  var myApp = angular.module('WebsDemo', ['ngAnimate', 'mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', 'SpeakersService', 'SpeakerModal', function ($scope, $speakers, $modal) {

    $speakers.loadSpeakers(1, 100).then(function(result){
      $scope.speakers = result
    });

    $scope.showSpeakerInfo = function(speaker){
      $modal.perform(speaker.id)
    };

  }]);

})(window.angular);