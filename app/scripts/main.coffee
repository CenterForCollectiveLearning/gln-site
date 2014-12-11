glnApp = angular.module('glnApp', ['ngRoute'])

angular.module('glnApp').controller('navCtrl', ['$scope', '$location', ($scope, $location) ->
    $scope.links = [
        {route: '/', title: 'visualization'},
        {route: '/ranking', title: 'ranking'},
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

angular.module('glnApp').controller('aboutCtrl', ['$scope', ($scope) ->
    $scope.firstRowMembers = [
        {
            name: 'Shahar Ronen'
            picture: 'shahar_ronen.png'
            twitter: 'ShRonen'
            website: 'shaharronen.com'
            affiliation: 'MIT Media lab'
        },
        {
            name: 'Kevin Hu'
            picture: 'kevin_hu.png'
            twitter: 'kevinzenghu'
            website: 'kevinzenghu.com'
            affiliation: 'MIT Media lab'
        },
        {
            name: 'César Hidalgo'
            picture: 'cesar_hidalgo.jpg'
            twitter: 'cesifoti'
            website: 'chidalgo.com'
            affiliation: 'MIT Media Lab'
        }
    ]
    $scope.secondRowMembers = [
        {
            name: 'Bruno Gonçalves'
            picture: 'bruno_goncalves.png'
            twitter: 'bgoncalves'
            website: 'bgoncalves.com'
            affiliation: 'Aix-Marseille Université'
        },
        {
            name: 'Alex Vespignani'
            picture: 'alex_vespignani.jpg'
            twitter: 'alexvespi'
            website: 'northeastern.edu/news/faculty-experts/alex-vespignani'
            affiliation: 'Northeastern University'
        },
        {
            name: 'Steven Pinker'
            picture: 'steven_pinker.jpeg'
            twitter: 'sapinker'
            website: 'stevenpinker.com'
            affiliation: 'Harvard University'
        },
    ]
])

angular.module('glnApp').directive('navigator', ($window, $document) ->
    return {
        restrict: 'A'
        link: (scope, $e) ->
            scope.top = true
            angular.element($window).bind("scroll", ->
                maxScroll = $document.height() - $window.innerHeight
                console.log(this.pageYOffset)
                if (this.pageYOffset > maxScroll - 300)
                    scope.top = false
                else
                    scope.top = true
                scope.$apply()
            )
            scope.scrollTo = (direction) ->
                if (direction is 'bottom')
                    $("body").animate(scrollTop: $("body").height())
                else 
                    $("body").animate(scrollTop: 0)
    }
)