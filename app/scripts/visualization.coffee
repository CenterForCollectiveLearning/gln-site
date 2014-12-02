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

              languages = []
              languagesToIDs = {}
              for d in data.data
                languages.push(d.Lang_Name)
                languagesToIDs[d.Lang_Name] = d.id

              # TODO Mute for n/as?

              visualization = d3plus.viz()
                .dev(true)
                .data(data.data)
                .nodes(data.nodes)
                .edges(data.edges)
                .type("network")
                .container("#viz")
                .color("Family Name")
                .text("Lang_Name")
                .tooltip(["Final_Name", "Family Name", "Number of Speakers (millions)"])
                .legend({
                  order:
                    sort: "desc"
                    value: true
                  size: 40
                })
                .labels({
                  resize: true
                  value: true
                })
                .font(
                  color: "#FFF"
                  family: "Neutral"
                )
                .size({
                  scale: d3.scale.linear()
                  value: "Log(Number of Speakers)"
                })
                .edges({
                  arrows: false
                  color: "#FFF"
                  interpolate: "monotone"
                  size: "Coocurrences"
                  opacity: "opacity"
                  label: "coocurrences"
                })
                .background("transparent")# "#111")
                # .size("Log(Number of Speakers)")

                # .focus('English')
                .id("id")
                .ui([
                    method: "size"
                    value: ["Number of Speakers (millions)", "Log(Number of Speakers)"]
                  ,
                    method: "focus",
                    value: languages
                ])
                .draw()
            )
          , 200)
    )
])