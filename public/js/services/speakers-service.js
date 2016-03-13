'use strict';

angular.module('WebsDemo')
  .service('SpeakersService', ['$http', function SpeakersService($http) {

    this.loadSpeakers = function (page, pageSize) {
      return $http({
        method: 'GET',
        url: '/speakers.json',
        params: {page: page, page_size: pageSize}
      }).then(function(response) {
        return response.data.data.speakers
      }, function() {
        alert('Something went wrong, please try again later')
      });
    };

  }]);