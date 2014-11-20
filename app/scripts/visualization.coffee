angular.module('glnApp').directive("visualization", ["$window", "$timeout",
  ($window, $timeout) ->
    return (
      restrict: "EA"
      scope: {}
      link: (scope, ele, attrs) ->
        $window.onresize = -> scope.$apply() 

        # Resizing
        scope.$watch(( -> angular.element($window)[0].innerWidth ), ( -> scope.render()))

        # scope.$watchCollection("[vizType,vizSpec,vizData,conditional]", ((newData) ->
        #   scope.render(newData[0], newData[1], newData[2], newData[3])
        # ), true)

        scope.render = ->
          console.log("in render")

          clearTimeout renderTimeout if renderTimeout

          renderTimeout = $timeout( ->
            sample_data = [
                {"name": "alpha", "size": 10},
                {"name": "beta", "size": 12},
                {"name": "gamma", "size": 30},
                {"name": "delta", "size": 26},
                {"name": "epsilon", "size": 12},
                {"name": "zeta", "size": 26.5},
                {"name": "theta", "size": 11},
                {"name": "eta", "size": 24}
            ]

            connections = [
                {"source": "alpha", "target": "beta"},
                {"source": "alpha", "target": "gamma"},
                {"source": "beta", "target": "delta"},
                {"source": "beta", "target": "epsilon"},
                {"source": "zeta", "target": "gamma"},
                {"source": "theta", "target": "gamma"},
                {"source": "eta", "target": "gamma"}
            ]
            
            visualization = d3plus.viz()
              .container("#viz")
              .type("network")
              .data(sample_data)
              .edges(connections)
              .background("#111")
              .size("size")
              .id("name")
              .draw()

            # d3.json('/data/books_formatted.json', (error, data) ->
            
            #     visualization = d3plus.viz()
            #         .dev(true)
            #         .type("network")
            #         .container("#viz")
            #         # .size(function(d) { 
            #         #     size = Math.round(d.LogNumSpeaker)
            #         #     return 10;
            #         #     if (typeof size === 'undefined') {
            #         #         return 1;
            #         #     } else {
            #         #         return Math.round(d.LogNumSpeaker);                 
            #         #     }
            #         # })
            #         .color("Viz_Family_Name")
            #         .text("Final_Name")
            #         .tooltip(["Final_Name", "Viz_Family_Name", "Num_Speakers_M"])
            #         .legend(true)
            #         .data(data.data)
            #         .nodes(data.nodes) # sample_data)
            #         .edges(data.edges) # connections)
            #         .edges({"arrows": false})
            #         .background("#111")
            #         .size("LogNumSpeaker")
            #         .id("id")
            #         .draw()
            
            #     # TODO Opacity and stroke (T statistic and co-occurrences)
            
            #     # visualization = d3plus.viz()
            #     #     .container("#viz")
            #     #     .type("network")
            #     #     .data(sample_data)
            #     #     .edges(connections)
            #     #     .background("#111")
            #     #     .size("size")
            #     #     .id("name")
            #     #     .draw()
            # )

          , 200)
    )
])