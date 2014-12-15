angular.module('glnApp').run(['DTDefaultOptions', (DTDefaultOptions) ->
    DTDefaultOptions.setDisplayLength(25)
])

angular.module('glnApp').controller('rankingCtrl', ['$scope', '$routeParams', '$location', 'DTOptionsBuilder', 'DTColumnBuilder', ($scope, $routeParams, $location, DTOptionsBuilder, DTColumnBuilder) ->
    $scope.datasets = [
        {
            name: 'books'
            icon: 'book'
        },
        {
            name: 'twitter'
            icon: 'twitter'
        },
        {
            name: 'wikipedia'
            icon: 'wikipedia'
        }
    ]

    datasetToFile = 
        twitter: 'twitter_table.json'
        wikipedia: 'wikipedia_table.json'
        books: 'books_table.json'

    datasetToOptions = 
        twitter: [
                name: "Language Name"
                title: "Language"
                visible: true
            , 
                name: "Language Code"
                title: "Code"
                visible: false
            ,   
                name: "Family Name"
                title: "Family"
                visible: false
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
                visible: true
            ,
                name: "Number of Tweets"
                title: "Tweets"
                visible: true
            ,
                name: "Number of Users"
                title: "Users"
                visible: true
            ,
                name: "Average Tweets per User"
                title: "Avg. tweets/user" 
                visible: false
            ,
                name: "Number of Multilinguals"
                title: "Multilinguals"
                visible: true
            ,
                name: "Average Tweets per Multilingual"
                title: "Avg. tweets/ml"
                visible: false
            ,
                name: "Number of Speakers (millions)"
                title: "Speakers (M)"
                visible: true
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
                visible: true
            ],
        wikipedia: [
                name: "Language Name"
                title: "Language"
                visible: true
            , 
                name: "Language Code"
                title: "Code"
                visible: false
            ,   
                name: "Family Name"
                title: "Family"
                visible: false
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
                visible: true
            ,
                name: "Number of Edits"
                title: "Edits"
                visible: true
            ,
                name: "Number of Editors"
                title: "Editors"
                visible: true
            ,
                name: "Average Edits per Editor"
                title: "Avg. edits/editor" 
                visible: false
            ,
                name: "Number of Multilinguals"
                title: "Multilinguals"
                visible: true
            ,
                name: "Average Tweets per Multilingual"
                title: "Avg. tweets/ml"
                visible: false
            ,
                name: "Number of Speakers (millions)"
                title: "# Speakers (M)"
                visible: true
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
                visible: true
            ],
        books: [
                name: "Language Name"
                title: "Language"
                visible: true
            , 
                name: "Language Code"
                title: "Code"
                visible: false
            ,   
                name: "Family Name"
                title: "Family"
                visible: false
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
                visible: true
            ,
                name: "Translations From"
                title: "Translations From"
                visible: true
            ,
                name: "Translations To"
                title: "Translations To"
                visible: true
            ,
                name: "Out Degree"
                title: "Out Degree"
                visible: false
            ,
                name: "In Degree"
                title: "In Degree"
                visible: false
            ,
                name: "Number of Speakers (millions)"
                title: "Speakers (M)"
                visible: true
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
                visible: true
            ]

    colsToDtColumns = (cols) ->
        DtColumns = []
        for col in cols
            colBuilder = DTColumnBuilder.newColumn(col.name).withTitle(col.title)
            unless col.visible
                colBuilder = colBuilder.notVisible()
            DtColumns.push(colBuilder)
        return DtColumns

    if $routeParams.dataset
        d = $routeParams.dataset
    else 
        d = $scope.datasets[0]
    $scope.selectedDataset = d
    $scope.selectedDatasetFile = datasetToFile[d]
    $scope.dtColumns = colsToDtColumns(datasetToOptions[d])

    $scope.isActive = (d) -> (d is $scope.selectedDataset)
    $scope.selectDataset = (d) ->
        pathList = $location.path().split('/')
        pathList[2] = d
        $location.path(pathList.join('/'))

    $scope.dtOptions = DTOptionsBuilder.fromSource('data/' + datasetToFile[d])
        .withOption('order', [[3, 'desc']])
        .withPaginationType('full_numbers')
        .withColVis()
])