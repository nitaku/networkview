$ ->
    d3.json 'data/miserables.json', (data) ->
        new NetworkView(selector: '#network1', graph: data)
        