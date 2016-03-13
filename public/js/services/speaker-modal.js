'use strict';

angular.module('WebsDemo')
  .service('SpeakerModal', ['$rootScope', 'SpeakersService', '$modal', function SpeakerModal($rootScope, $speakers, $modal) {

    this.perform = function(speaker_id){
      if(!modalInProgress){
        $speakers.loadSpeakerDetails(speaker_id).then(tryShowModal);
        modalInProgress = true;
      }
    };

    // -- private --

    var modalInProgress = false;

    function tryShowModal(data){
      if (data){
        showModal(data);
      }
    }

    function showModal(data){
      var scope = $rootScope.$new();
      scope.speaker = data;
      $modal({
        scope: scope,
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