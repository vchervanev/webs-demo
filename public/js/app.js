(function (angular) {

  var myApp = angular.module('WebsDemo', ['ngAnimate', 'mgcrea.ngStrap', 'ngSanitize']);

  myApp.controller('WebsCtrl', ['$scope', 'SpeakersService', '$modal', function ($scope, $speakers, $modal) {

    var modalInProgress = false;

    $speakers.loadSpeakers(1, 100).then(function(result){
      $scope.speakers = result
    });

    $scope.showSpeakerInfo = function(speaker){
      if(canShowModal()){
        $speakers.loadSpeakerDetails(speaker.id).then(tryShowModal);
      }
    };

    function canShowModal(){
      var result = !modalInProgress;
      modalInProgress = true; // it's always true
      return result;
    }

    function tryShowModal(data){
      if (data){
        showModal(data);
      }
    }

    function showModal(data){
      $scope.currentSpeakerDetails = data;
      $modal({
        scope: $scope,
        show: true,
        templateUrl: "/view/speaker_modal",
        placement: "center",
        animation: "am-fade-and-scale"
      }).$promise.then(onModalLoaded);
    }

    function onModalLoaded(){
      // the modal is shown, but network requests are finished
      modalInProgress = false;
    }
  }]);

})(window.angular);