(function (angular) {

  var myApp = angular.module('WebsDemo', ['ngAnimate', 'mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', 'SpeakersService', '$modal', function ($scope, $speakers, $modal) {

    $speakers.loadSpeakers(1, 100).then(function(result){
      $scope.speakers = result
    });

    $scope.showSpeakerInfo = function(speaker){
      $scope.currentSpeaker = speaker;
      $modal({
        scope: $scope,
        show: true,
        templateUrl: "/view/speaker_modal",
        placement: "center",
        animation: "am-fade-and-scale"
      });
    }
  }]);

})(window.angular);