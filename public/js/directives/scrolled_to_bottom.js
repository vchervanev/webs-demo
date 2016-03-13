'use strict';

angular.module('WebsDemo')
  .directive('whenScrolledToBottom', function() {
  return function(scope, elm, attr) {

    var scrollHandler = function() {

      if ($(window).scrollTop() + $(window).height() == $(document).height()){
        scope.$apply(attr.whenScrolledToBottom);
      }
    };

    $(window).bind('scroll load', scrollHandler);

  };
});