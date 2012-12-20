networkview
===========

An SVG node-link diagram widget, made with [D3.js](http://d3js.org).

Click here for a simple [demo](http://wafi.iit.cnr.it/webvis/diagrams/network/) (also included in the code).

Source is written in [coffeescript](http://coffeescript.org) ([coffee](https://github.com/nitaku/networkview/tree/master/coffee) folder), then compiled into standard Javascript ([js](https://github.com/nitaku/networkview/tree/master/js) folder).

Usage
-----

In order to use networkview, you must include the following lines into your HTML head:

```html
<link type="text/css" href="style/network.css" rel="stylesheet"/>
<script type="text/javascript" src="js/network.js"></script>
```

then place an SVG container where you want the network view to be displayed:

```html
<body>
  <svg id="the_graph"></svg>
</body>
```

In your Javascript code, just define or fetch a JSON file representing the graph, using the following syntax:

```json
{
  "nodes": [
    {"name": "A", "group": 1, "size": 4},
    {"name": "B", "group": 1, "size": 2},
    {"name": "C", "group": 2, "size": 7}
  ],
  "links": [
    {"source": 0, "target": 1, "weight" 2},
    {"source": 0, "target": 2, "weight" 1},
    {"source": 1, "target": 2, "weight" 3},
  ]
}
```

where `group`, `size` and `weight` are optional properties, then pass it to the NetworkView's constructor, along with a selector matching the SVG node:

```javascript
var net = new NetworkView({selector: '#the_graph', graph: json_graph});
```
