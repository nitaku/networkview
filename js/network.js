(function() {
  var AVG_NODE_R, MAX_NODE_R, MIN_NODE_R, NetworkView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MIN_NODE_R = 3;

  MAX_NODE_R = 7;

  AVG_NODE_R = (MIN_NODE_R + MAX_NODE_R) / 2;

  /* NetworkView takes as parameters a CSS selector (expecting svg nodes) and graph data
  */

  window.NetworkView = NetworkView = (function() {

    function NetworkView(params) {
      this._on_tick = __bind(this._on_tick, this);
      /* validate parameters
      */
      var link_type2color_scale, link_weight2stroke_width_scale, node_size2radius_scale, node_type2color_scale,
        _this = this;
      if (!(params != null) || !(params.selector != null)) {
        throw new Error("'selector' parameter is mandatory");
      }
      /* load parameters
      */
      this.graph = params.graph ? params.graph : {
        nodes: [],
        links: []
      };
      this.svg = d3.selectAll(params.selector);
      /* scales
      */
      node_type2color_scale = d3.scale.ordinal().domain([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).range(['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#bcbd22', '#17becf', '#1f77b4']);
      this.node_type2color = function(type) {
        if (type != null) {
          return node_type2color_scale(type);
        } else {
          return '#7f7f7f';
        }
      };
      link_type2color_scale = d3.scale.ordinal().domain([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).range(['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#bcbd22', '#17becf', '#1f77b4']);
      this.link_type2color = function(type) {
        if (type != null) {
          return link_type2color_scale(type);
        } else {
          return '#7f7f7f';
        }
      };
      node_size2radius_scale = d3.scale.linear().domain([1, 5]).range([MIN_NODE_R, MAX_NODE_R]).clamp(true);
      this.node_size2radius = function(size) {
        if (size != null) {
          return node_size2radius_scale(size);
        } else {
          return AVG_NODE_R;
        }
      };
      link_weight2stroke_width_scale = d3.scale.linear().domain([0, 50]).range([1, MIN_NODE_R * 2]).clamp(true);
      this.link_weight2stroke_width = function(weight) {
        if (weight != null) {
          return link_weight2stroke_width_scale(weight);
        } else {
          return 1;
        }
      };
      /* empirical values for viewbox
      */
      this.svg.attr('viewBox', '-100 -100 300 300');
      this.force = d3.layout.force().nodes(this.graph.nodes).links(this.graph.links).size([100, 100]).linkDistance(40).start();
      /* links have to be drawn before nodes, so they are drawn under them
      */
      this.links = this.svg.selectAll('.link').data(this.graph.links).enter().append('line').attr('class', 'link').attr('stroke', function(d) {
        return _this.link_type2color(d.type);
      }).attr('stroke-width', function(d) {
        return _this.link_weight2stroke_width(d.weight);
      });
      this.nodes = this.svg.selectAll('.node').data(this.graph.nodes).enter().append('circle').attr('class', 'node').attr('r', function(d) {
        return _this.node_size2radius(d.size);
      }).attr('fill', function(d) {
        return _this.node_type2color(d.type);
      }).call(this.force.drag);
      this.force.on('tick', this._on_tick);
    }

    NetworkView.prototype._on_tick = function() {
      this.nodes.attr('cx', function(d) {
        return d.x;
      }).attr('cy', function(d) {
        return d.y;
      });
      return this.links.attr('x1', function(d) {
        return d.source.x;
      }).attr('y1', function(d) {
        return d.source.y;
      }).attr('x2', function(d) {
        return d.target.x;
      }).attr('y2', function(d) {
        return d.target.y;
      });
    };

    return NetworkView;

  })();

}).call(this);
