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
        node_type2color_scale = d3.scale.ordinal()
            .domain([0...10])
            .range(['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#bcbd22', '#17becf', '#1f77b4'])
        @node_type2color = (type) -> if type? then node_type2color_scale(type) else '#7f7f7f'
        
        link_type2color_scale = d3.scale.ordinal()
            .domain([0...10])
            .range(['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#bcbd22', '#17becf', '#1f77b4'])
        @link_type2color = (type) -> if type? then link_type2color_scale(type) else '#7f7f7f'
        
        node_size2radius_scale = d3.scale.linear()
            .domain([1,5]) # FIXME hardcoded data values
            .range([MIN_NODE_R,MAX_NODE_R])
            .clamp(true)
        @node_size2radius = (size) -> if size? then node_size2radius_scale(size) else AVG_NODE_R
        
        link_weight2stroke_width_scale = d3.scale.linear()
            .domain([0,50]) # FIXME hardcoded data values
            .range([1,MIN_NODE_R*2])
            .clamp(true)
        @link_weight2stroke_width = (weight) -> if weight? then link_weight2stroke_width_scale(weight) else 1
        
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
                .attr('stroke', (d) => @link_type2color(d.type))
                .attr('stroke-width', (d) => @link_weight2stroke_width(d.weight))
                
        @nodes = @svg.selectAll('.node')
            .data(@graph.nodes)
            .enter().append('circle')
                .attr('class', 'node')
                .attr('r', (d) => @node_size2radius(d.size))
                .attr('fill', (d) => @node_type2color(d.type))
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
        