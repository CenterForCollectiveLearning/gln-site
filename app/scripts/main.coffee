glnApp = angular.module('glnApp', ['ngRoute'])

angular.module('glnApp').controller('navCtrl', ['$scope', '$location', ($scope, $location) ->
    $scope.links = [
        {route: '/', title: 'visualization'},
        {route: '/paper', title: 'paper'},
        {route: '/data', title: 'data'},
        {route: '/about', title: 'about'},
        {route: '/press', title: 'press'},
    ]

    $scope.isActive = (route) ->
        path = $location.path();
        if (route == '/')
            if (path.split('/')[1] == 'visualization')
                return true
        else 
            if (path.substr(0, route.length) == route)
                return true
            else
                return false
])

angular.module('glnApp').controller('visualizationCtrl', ['$scope', '$routeParams', '$location', ($scope, $routeParams, $location) ->
    $scope.datasets = ['books', 'twitter', 'wikipedia']

    if $routeParams.dataset
        $scope.selectedDataset = $routeParams.dataset

    else
        $scope.selectedDataset = $scope.datasets[0]

    $scope.isActive = (d) -> (d is $scope.selectedDataset)
    $scope.selectDataset = (d) ->
        pathList = $location.path().split('/')
        pathList[2] = d
        $location.path(pathList.join('/'))
])