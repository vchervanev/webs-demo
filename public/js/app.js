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

    $scope.loadMore = function(){
      alert($speakers.nextPage)
      if ($speakers.nextPage){
        loadAndAppendPage($speakers.nextPage);
      }
    };

    // -- private --

    function loadInitialList() {
      $scope.speakers = [];
      loadAndAppendPage(1);
    }

    function loadAndAppendPage(page){
      $speakers.loadSpeakers(page, 100, $scope.selectedInterest).then(function(result){
        push_array(result, $scope.speakers)
      });
    }

    function push_array(src, dst){
      dst.push.apply(dst, src);
    }

  }]);

})(window.angular);