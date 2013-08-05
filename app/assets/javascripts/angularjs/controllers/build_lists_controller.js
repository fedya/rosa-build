RosaABF.controller('BuildListsController', ['$scope', '$http', '$location', '$timeout', function($scope, $http, $location, $timeout) {

  $scope.params         = null;
  $scope.first_run      = true;
  $scope.server_status  = null;
  $scope.build_lists    = [];
  $scope.isRequest      = false; // Disable 'Search' button
  $scope.pages          = [];

  // Fixes: redirect to page after form submit
  $("#monitoring_filter").on('submit', function(){ return false; });

  $scope.getBuildLists = function() {
    // Disable 'Search' button
    $scope.isRequest = true;

    $http.get('/build_lists.json', {params: $location.search()}).success(function(results) {
      // Render Server status
      $scope.server_status  = results.server_status;

      // TMP fields
      var dictionary  = results.dictionary;
      var build_lists = [];
      var groups      = {};

      // Grouping of build_lists
      _.each(results.build_lists, function(r){
        var bl = new BuildList(r, dictionary);
        var key = bl.project_id + '-' + bl.commit_hash + '-' + bl.user_id;
        if (groups[key]) {
          groups[key].addRelated(bl);
        } else {
          groups[key] = bl;
          build_lists.push(bl);
        }
      });
      
      // Adds all build_lists into the table (group by group)
      $scope.build_lists    = [];
      _.each(build_lists, function(bl){
        _.each(bl.related, function(b){ $scope.build_lists.push(b); });
      });

      // Render pagination
      $scope.pages     = results.pages;
      // Enable 'Search' button
      $scope.isRequest = false;
    }).error(function(data, status, headers, config) {
      // Enable 'Search' button
      $scope.isRequest = false;
    });;
  }

  $scope.showRelated = function(build_list) {
    build_list.relatedHidden = false;
    _.each(build_list.related, function(bl){
      bl.show = true;
      // Waits for render of build_lists
      $timeout(function() {
        $('#build-list-' + bl.id + ' td:visible').effect('highlight', {}, 1000);
      }, 100);
    });
  }

  $scope.hideRelated = function(build_list) {
    build_list.relatedHidden = true;
    _.each(build_list.related, function(bl){ bl.show = false; });
    build_list.show = true;
  }

  $scope.cancelRefresh = null;
  $scope.refresh = function(force) {
    if ($('#autoreload').is(':checked') || force) {
      var params = {};
      _.each($("#monitoring_filter").serializeArray(), function(a){
        if (a.value) { params[a.name] = a.value; }
      });
      $location.search(params);
      $scope.getBuildLists();
    }
    if (!force) {
      $scope.cancelRefresh = $timeout($scope.refresh, 60000);
    }
  }


  $scope.$on('$locationChangeSuccess', function(event) {
    $scope.updateParams();
  });

  $scope.updateParams = function() {
    var params = $location.search();
    $scope.params    = {
      page:               params.page     || 1,
      per_page:           params.per_page || 25,
      filter: {
        ownership:          params['filter[ownership]'] || 'owned',
        status:             params['filter[status]'],
        platform_id:        params['filter[platform_id]'],
        arch_id:            params['filter[arch_id]'],
        mass_build_id:      params['filter[mass_build_id]'],
        updated_at_start:   params['filter[updated_at_start]'],
        updated_at_end:     params['filter[updated_at_end]'],
        project_name:       params['filter[project_name]'],
        id:                 params['filter[id]']
      }
    }
  }

  $scope.goToPage = function(number) {
    $location.search('page', number);
    $scope.getBuildLists();
  }

  $scope.updateParams();
  // Waits for render of filters
  $timeout($scope.refresh, 100);
}]);