angular.module('glnApp').directive("visualization", ["$window", "$timeout",
  ($window, $timeout) ->
    return (
      restrict: "EA"
      scope: {
        selectedDataset: "="
      }
      link: (scope, ele, attrs) ->
        $window.onresize = -> scope.$apply()

        # Resizing
        scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render()))

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
          console.log(dataset)

          clearTimeout(renderTimeout) if renderTimeout

          renderTimeout = $timeout( ->

            d3.json(dataset, (error, data) ->
              console.log("Got file", error, data)

              visualization = d3plus.viz()
                .dev(true)
                .type("network")
                .container("#viz")
                .color("Viz_Family_Name")
                .text("Final_Name")
                .tooltip(["Final_Name", "Viz_Family_Name", "Num_Speakers_M"])
                .legend(true)
                .data(data.data)
                .nodes(data.nodes) # sample_data)
                .edges(data.edges) # connections)
                .edges(arrows: false)
                .background("#111")
                .size("LogNumSpeaker")
                # .size("LogNumSpeaker")
                # .size((d) -> console.log(d) )
                .id("id")
                .draw()
            )
          , 200)
    )
])