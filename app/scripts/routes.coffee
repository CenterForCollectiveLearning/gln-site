angular.module('glnApp').config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/', 
      redirectTo: '/visualizations/books'
    )
    .when('/visualizations/:dataset',
      templateUrl: './templates/visualization.html'
    )
    .when('/rankings',
      redirectTo: '/rankings/books'
    )
    .when('/rankings/:dataset',
      templateUrl: './templates/ranking.html'
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
