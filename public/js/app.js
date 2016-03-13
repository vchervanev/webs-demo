(function (angular) {

  var myApp = angular.module('WebsDemo', ['ngAnimate', 'mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', 'SpeakersService', 'SpeakerModal', function ($scope, $speakers, $modal) {

    $scope.selectedInterest = null;
    loadInitialList();

    $scope.showSpeakerInfo = function(speaker){
      $modal.perform(speaker.id)
    };

    $speakers.loadInterests().then(function(result){
      $scope.interests = result;
    });

    $scope.applyInterest = function(interest){
      $scope.selectedInterest = interest;
      loadInitialList();
    };

    // -- private --

    function loadInitialList() {
      $speakers.loadSpeakers(1, 100, $scope.selectedInterest).then(function(result){
        $scope.speakers = result
      });
    }

  }]);

})(window.angular);