'use strict';

angular.module('WebsDemo')
  .service('SpeakersService', ['$http', function SpeakersService($http) {

    var self = this;
    self.nextPage = null;

    this.loadSpeakers = function (page, pageSize, interest) {
      return $http({
        method: 'GET',
        url: '/speakers',
        params: {page: page, page_size: pageSize, interest: interest}
      }).then(function(response) {
        var meta = response.data.meta;
        if (meta.page == meta.total_pages){
          self.nextPage = null
        } else {
          self.nextPage = meta.page + 1
        }

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