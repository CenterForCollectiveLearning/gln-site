angular.module('glnApp').config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/', 
      redirectTo: '/visualization/books'
    )
    .when('/visualization/:dataset',
      templateUrl: './templates/visualization.html'
    )
    .when('/paper',
      templateUrl: './templates/paper.html',
    )
    .when('/data',
      templateUrl: './templates/data.html',
    )
    .when('/about',
      templateUrl: './templates/about.html',
    )
    .when('/press',
      templateUrl: './templates/press.html',
    )
    .otherwise(
      redirectTo: '/'
    );

  $locationProvider.html5Mode(true)
])
