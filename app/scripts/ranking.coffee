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
        twitter: ["Language Name", "Language Code", "Family Name", "Eigenvector Centrality", "Number of Tweets", "Number of Users", "Average Tweets per User", "Percent of Total Users", "Number of Speakers (millions)", "GDP per Capita (dollars)"]
        wikipedia: ["Language Name", "Language Code", "Family Name", "Eigenvector Centrality", "Number of Edits", "Number of Editors", "Percent of Total Editors", "Average Edits per Editor", "Number of Speakers (millions)", "GDP per Capita (dollars)"]
        books: ["Language Name", "Language Code", "Family Name", "Eigenvector Centrality", "Translations From", "Translations To", "Number of Speakers (millions)", "GDP per Capita (dollars)"]

    datasetToOptions = 
        twitter: [
                name: "Language Name"
                title: "Language"
            , 
                name: "Language Code"
                title: "Code"
            ,   
                name: "Family Name"
                title: "Family"
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
            ,
                name: "Number of Tweets"
                title: "Tweets"
            ,
                name: "Number of Users"
                title: "Users"
            ,
                name: "Average Tweets per User"
                title: "Avg. tweets/user" 
            ,
                name: "Percent of Total Users"
                title: "% Total Users"
            ,
                name: "Number of Speakers (millions)"
                title: "Speakers (M)"
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
            ],
        wikipedia: [
                name: "Language Name"
                title: "Language"
            , 
                name: "Language Code"
                title: "Code"
            ,   
                name: "Family Name"
                title: "Family"
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
            ,
                name: "Number of Edits"
                title: "Edits"
            ,
                name: "Number of Editors"
                title: "Editors"
            ,
                name: "Average Edits per Editor"
                title: "Avg. edits/editor" 
            ,
                name: "Percent of Total Editors"
                title: "% Total Editors"
            ,
                name: "Number of Speakers (millions)"
                title: "# Speakers (M)"
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
            ],
        books: [
                name: "Language Name"
                title: "Language"
            , 
                name: "Language Code"
                title: "Code"
            ,   
                name: "Family Name"
                title: "Family"
            ,
                name: "Eigenvector Centrality"
                title: "Centrality"
            ,
                name: "Translations From"
                title: "Translations From"
            ,
                name: "Translations To"
                title: "Translations To"
            ,
                name: "Number of Speakers (millions)"
                title: "Speakers (M)"
            , 
                name: "GDP per Capita (dollars)"
                title: "GDP per cap. ($)"
            ]

    colsToDtColumns = (cols) ->
        console.log(cols)
        DtColumns = []
        for col in cols
            DtColumns.push(DTColumnBuilder.newColumn(col.name).withTitle(col.title))
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
        .withOption('order', [[4, 'desc']])
        .withPaginationType('full_numbers')
        .withColVis()
])