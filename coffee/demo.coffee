$ ->
    d3.json 'data/miserables.json', (data) ->
        new NetworkView(selector: '#network1, #network2', graph: data)
        
    d3.json 'data/foo.json', (data) ->
        new NetworkView(selector: '#network3', graph: data)
        