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

          dataset = dataPrefix + datasetToFile[selectedDataset]

          clearTimeout(renderTimeout) if renderTimeout

          renderTimeout = $timeout( ->

            d3.json(dataset, (error, data) ->

              languagesList = []
              languagesToIDsCollection =[]
              languagesToIDsMapping = {}

              for d in data.data
                id = d.id
                langName = d['Lang_Name']
                languageToIDMapping = {}
                languageToIDMapping[langName] = id
                languagesToIDsCollection.push(languageToIDMapping)
                languagesToIDsMapping[langName] = id

              languagesToIDsCollection = _.sortBy(languagesToIDsCollection, (d) -> Object.keys(d)[0])

              # visualization = d3plus.viz()
              #   .dev(true)
              #   .data(data.data)
              #   .type("rings")
              #   .text("Lang_Name")
              #   .container("#viz")
              #   .size(
              #     scale: d3.scale.linear()
              #     value: "Log(Number of Speakers)"
              #   )
              #   #.nodes(data.nodes)
              #   .edges(data.edges)
              #   .focus(languagesToIDsMapping['French'])
              #   .draw()

              visualization = d3plus.viz()
                .dev(true)
                .data(data.data)
                .type("network")
                .container("#viz")
                .text("Lang_Name")
                .color("Family_Name")                
                .descs(
                  "Log(Number of Speakers)": "Test"
                )
                # .tooltip(["Family Name", "Number of Speakers (millions)"])
                .legend(
                  order:
                    sort: "desc"
                    value: "size"
                  size: 40
                )
                .labels(
                  padding: 0
                )
                
                .size(
                  scale: d3.scale.linear()
                  value: "Log(Number of Speakers)"
                )
                .nodes(data.nodes)
                .nodes(
                  overlap: 0.9
                )
                .edges(data.edges)
                .edges(
                  # color: "#FFF"
                  size: "size"  # "Coocurrences"
                  # opacity: 0.5
                )
                .tooltip(
                  # background: "#000"
                  opacity: 0.8
                  font:
                    color: "#FFF"
                )
                .background("transparent")
                .focus(languagesToIDsMapping['English'])
                .id("id")
                .font(
                  family: "Oswald"
                  weight: "400"
                  color: "#FF0000"
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
                    value: languagesToIDsCollection  # TODO Sort by display language, not ID
                ])
                .draw()
            )
          , 200)
    )
])