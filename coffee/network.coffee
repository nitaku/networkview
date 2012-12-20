MIN_NODE_R = 3
MAX_NODE_R = 7
AVG_NODE_R = (MIN_NODE_R+MAX_NODE_R)/2

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
        
        ### scales ###
        @group2color = d3.scale.category10()
        
        pre_node_size2radius = d3.scale.linear()
            .domain([1,5]) # FIXME hardcoded data values
            .range([MIN_NODE_R,MAX_NODE_R])
            .clamp(true)
        @node_size2radius = (size) -> if size? then pre_node_size2radius(size) else AVG_NODE_R
        
        @link_weight2stroke_width = d3.scale.linear()
            .domain([0,50]) # FIXME hardcoded data values
            .range([1,MIN_NODE_R*2])
            .clamp(true)
        
        ### empirical values for viewbox ###
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
                .attr('stroke-width', (d) => @link_weight2stroke_width(d.weight))
                
        @nodes = @svg.selectAll('.node')
            .data(@graph.nodes)
            .enter().append('circle')
                .attr('class', 'node')
                .attr('r', (d) => @node_size2radius(d.size))
                .attr('fill', (d) => @group2color(d.group))
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
        