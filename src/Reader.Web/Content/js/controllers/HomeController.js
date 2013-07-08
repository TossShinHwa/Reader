﻿var HomeController;

HomeController = [
  "$scope", "$http", function($scope, $http) {
    $http.get("/api/Feed").success(function(data) {
      return $scope.feeds = data;
    });
    return $scope.showContent = function(id, type) {
      return $http.get("/api/rss?title=" + id).success(function(data) {
        $scope.rss = data.Table;
        debugger;
      });
    };
  }
];
