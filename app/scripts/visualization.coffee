angular.module('glnApp').directive("visualization", ["$window", "$timeout",
  ($window, $timeout) ->
    return (
      restrict: "EA"
      scope: {
        selectedDataset: "="
      }
      link: (scope, ele, attrs) ->
        # $window.onresize = -> 
        #   scope.$apply()

        # Resizing
        scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render(scope.selectedDataset)))

        scope.$watchCollection("[selectedDataset]", ((newData) ->
          scope.render(newData[0])
        ), true)

        scope.render = (selectedDataset) ->
          unless (selectedDataset)
            return

          dataPrefix = "data/"
          datasetToFile =
            twitter: 'twitter_network.json'
            wikipedia: 'wikipedia_network.json'
            books: 'books_network.json'

          # When arrows: true
          # datasetToOverlap =
          #   twitter: 2.5
          #   wikipedia: 2.5
          #   books: 13.0

          datasetToOverlap =
            twitter: 1.0
            wikipedia: 1.0
            books: 7.0

          datasetToStats =
            twitter: ['Number of Tweets', 'Number of Users', 'Average Tweets per User', 'Number of Multilinguals', 'Average Tweets per Multilingual']
            wikipedia: ['Number of Edits', 'Number of Editors', 'Average Edits per Editor', 'Number of Multilinguals', 'Average Tweets per Multilingual']
            books: ['Translations From', 'Translations To', 'Out Degree', 'In Degree']

          familyToColor = 
            'Afro-Asiatic': '#CC6680'
            'Altaic': '#9CFF9C'
            'Amerindian': '#4E994E'
            'Austronesian': '#FF87FF'
            'Caucasian': '#BAFEFF'
            'Creoles and pidgins': '#9933FF'
            'Dravidian': '#F7E406'
            'Indo-European': '#7470FF'
            'Niger-Kordofanian': '#FF6666'
            'Other': '#999999'
            'Sino-Tibetan': '#E67E5A'
            'Tai': '#FFFF00'
            'Uralic': '#9999FF'


          dataset = dataPrefix + datasetToFile[selectedDataset]

          clearTimeout(renderTimeout) if renderTimeout

          renderTimeout = $timeout( ->

            d3.json(dataset, (error, data) ->
              overlap = datasetToOverlap[selectedDataset]
              datasetStats = datasetToStats[selectedDataset]

              languagesList = []
              languagesToIDsCollection =[]
              languagesToIDsMapping = {}

              for d in data.data
                id = d.id
                langName = d["Language Name"]
                languagesList.push(langName)
                languageToIDMapping = {}
                languageToIDMapping[langName] = id
                languagesToIDsCollection.push(languageToIDMapping)
                languagesToIDsMapping[langName] = id

              languagesToIDsCollection = _.sortBy(languagesToIDsCollection, (d) -> Object.keys(d)[0])

              visualization = d3plus.viz()
                .dev(false)
                .data(data.data)
                .type("network")
                .container("#viz")
                .font(
                  family: 'Arial'
                  weight: 'bold'
                  color: "#000000"
                )      
                .text("Language Name")
                .descs(
                  "Number of Speakers (millions)": "Number of speakers of this language (both native and non-native) in the millions"                  
                )
                .legend(
                  text: "Family Name"
                  # order:
                  #   sort: "desc"
                  #   value: "size"
                  size: 60
                  value: false
                )
                .labels(
                  padding: 0
                  value: true
                  text: "Language Code"
                  font:
                    transform: "uppercase"
                )
                .size(
                  # scale: d3.scale.linear()
                  value: "Number of Speakers (millions)"
                )
                .nodes(data.nodes)
                .nodes(
                  overlap: overlap
                )
                .edges(data.edges)
                .edges(
                  arrows: false
                  color: "#222"
                  size: 
                    scale: 1.0
                    value: "coocurrences"
                  opacity: "opacity"
                  label: "coocurrences"
                )
                .tooltip(
                  font:
                    color: "#FFF"
                )
                .tooltip(["Family Name", "Number of Speakers (millions)", "GDP per Capita (dollars)", "Eigenvector Centrality"].concat(datasetStats))
                .background("transparent")
                .id("id")
                .color((d) ->
                  familyToColor[d["Family Name"]]
                )
                .ui([
                    method: "size"
                    label: "Node Size"
                    type: "button"
                    value: ["Number of Speakers (millions)", "GDP per Capita (dollars)", "Eigenvector Centrality"]
                  ,
                    method: "focus",
                    label: "Focus Language"
                    type: "drop"
                    value: languagesToIDsCollection
                ])
                .draw()
            )
          , 200)
    )
])