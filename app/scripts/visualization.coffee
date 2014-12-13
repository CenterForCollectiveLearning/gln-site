angular.module('glnApp').directive("visualization", ["$window", "$timeout",
  ($window, $timeout) ->
    return (
      restrict: "EA"
      scope: {
        selectedDataset: "="
      }
      link: (scope, ele, attrs) ->
        $window.onresize = -> 
          scope.$apply()

        # TODO Make resizing work
        # Resizing
        scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> console.log("Resizing"); scope.render(scope.selectedDataset)))

        scope.$watchCollection("[selectedDataset]", ((newData) ->
          scope.render(newData[0])
        ), true)

        scope.render = (selectedDataset) ->
          console.log("selectedDataset in directive", selectedDataset)
          unless (selectedDataset)
            return
          console.log("Rendering", selectedDataset)

          dataPrefix = "data/"
          datasetToFile =
            twitter: 'twitter_formatted.json'
            wikipedia: 'wikipedia_formatted.json'
            books: 'books_formatted.json'

          datasetToOverlap =
            twitter: 2.5
            wikipedia: 2.5
            books: 13.0

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
              console.log("OVERLAP", overlap)

              languagesList = []
              languagesToIDsCollection =[]
              languagesToIDsMapping = {}

              for d in data.data
                id = d.id
                langName = d['Language Name']
                languagesList.push(langName)
                languageToIDMapping = {}
                languageToIDMapping[langName] = id
                languagesToIDsCollection.push(languageToIDMapping)
                languagesToIDsMapping[langName] = id

              languagesToIDsCollection = _.sortBy(languagesToIDsCollection, (d) -> Object.keys(d)[0])
              # sortedLanguagesList = languagesList.sort(0)

              # console.log(sortedLanguagesList)

              visualization = d3plus.viz()
                .dev(true)
                .data(data.data)
                .type("network")
                .container("#viz")
                .font(
                  family: "Open Sans Condensed"#"Oswald"
                  weight: 700
                  color: "#000000"
                )      
                .text("Language Name")
                # .descs(
                #   "Log(Number of Speakers)": "Test"                  
                # )
                .format({text: (text, key) ->
                  text.toUpperCase()
                })
                .legend(
                  text: "Family Name"
                  # order:
                  #   sort: "desc"
                  #   value: "size"
                  size: 60
                )
                .labels(
                  padding: 0
                  value: true
                  text: "name"
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
                  arrows: true
                  color: "#ccc"
                  size: "size"
                  opacity: 0.7
                  # size: 
                  #   min: 2
                  #   scale: 1.0
                  #   value: "size"

                  # size:
                  #   value: "size"
                  # size: { value: "size", scaleExtent: 2.0 }
                  # opacity: "opacity"
                )
                .tooltip(
                  font:
                    color: "#FFF"
                )
                # .tooltip(["Language Name", "Family Name", "Log(Number of Speakers)", "Number of Speakers (millions)"])
                .background("transparent")
                # .focus(languagesToIDsMapping['English'])
                .id("id")
                .color((d) ->
                  familyToColor[d["Family Name"]]
                )
                .ui([
                    method: "size"
                    label: "Node Size"
                    type: "button"
                    value: ["Number of Speakers (millions)", "Log(Number of Speakers)"]
                  ,
                    method: "focus",
                    label: "Focus Language"
                    type: "drop"
                    value: languagesToIDsCollection
                ])

                .draw()

                console.log(visualization.edges(Object))
            )
          , 200)
    )
])