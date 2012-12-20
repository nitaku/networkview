
/* NetworkView takes as parameters a CSS selector (expecting svg nodes) and graph data
*/

(function() {
  var NetworkView,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.NetworkView = NetworkView = (function() {

    function NetworkView(params) {
      this._on_tick = __bind(this._on_tick, this);
      /* validate parameters
      */      if (!(params != null) || !(params.selector != null)) {
        throw new Error("'selector' parameter is mandatory");
      }
      /* load parameters
      */
      this.graph = params.graph ? params.graph : {
        nodes: [],
        links: []
      };
      this.svg = d3.selectAll(params.selector);
      /* empirical values for graph units
      */
      this.svg.attr('viewBox', '-100 -100 300 300');
      this.force = d3.layout.force().nodes(this.graph.nodes).links(this.graph.links).size([100, 100]).linkDistance(40).start();
      /* links have to be drawn before nodes, so they are drawn under them
      */
      this.links = this.svg.selectAll('.link').data(this.graph.links).enter().append('line').attr('class', 'link');
      this.nodes = this.svg.selectAll('.node').data(this.graph.nodes).enter().append('circle').attr('class', 'node').attr('r', 5).call(this.force.drag);
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
