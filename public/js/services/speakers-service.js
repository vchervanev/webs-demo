'use strict';

angular.module('WebsDemo')
  .service('SpeakersService', ['$http', function SpeakersService($http) {

    this.loadSpeakers = function (page, pageSize, interest) {
      return $http({
        method: 'GET',
        url: '/speakers',
        params: {page: page, page_size: pageSize, interest: interest}
      }).then(function(response) {
        return response.data.data.speakers
      }, errorHandler);
    };

    this.loadSpeakerDetails = function (id) {
      return $http({
        method: 'GET',
        url: '/speakers/' + id
      }).then(defaultDataHandler, errorHandler);
    };

    this.loadInterests = function() {
      return $http({
        method: 'GET',
        url: '/interests'
      }).then(defaultDataHandler, errorHandler);
    };

    // -- private --
    function errorHandler(){
      alert('Something went wrong, please try again later');
      return null
    }

    function defaultDataHandler(response){
      return response.data
    }
  }]);