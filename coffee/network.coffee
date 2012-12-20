### NetworkView takes as parameters a CSS selector (expecting svg nodes) and graph data ###
window.NetworkView =
class NetworkView
    constructor: (params) ->
        ### validate parameters ###
        if not params? or not params.selector?
            throw new Error("'selector' parameter is mandatory")
        
        ### load parameters ###
        @graph = if params.graph then params.graph else {nodes: [], links: []}
        @svg = d3.selectAll(params.selector)
        
        ### empirical values for graph units ###
        @svg.attr('viewBox', '-100 -100 300 300')
        
        @force = d3.layout.force()
            .nodes(@graph.nodes)
            .links(@graph.links)
            .size([100, 100])
            .linkDistance(40)
            .start()
        
        ### links have to be drawn before nodes, so they are drawn under them ###
        @links = @svg.selectAll('.link')
            .data(@graph.links)
            .enter().append('line')
                .attr('class', 'link')
                
        @nodes = @svg.selectAll('.node')
            .data(@graph.nodes)
            .enter().append('circle')
                .attr('class', 'node')
                .attr('r', 5)
                .call(@force.drag)
                
        @force.on 'tick', @_on_tick
        
    _on_tick: () =>
        @nodes
            .attr('cx', (d) -> d.x)
            .attr('cy', (d) -> d.y)
            
        @links
            .attr('x1', (d) -> d.source.x)
            .attr('y1', (d) -> d.source.y)
            .attr('x2', (d) -> d.target.x)
            .attr('y2', (d) -> d.target.y)
        