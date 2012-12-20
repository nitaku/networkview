networkview
===========

An SVG node-link diagram widget, made with [D3.js](http://d3js.org). A simple demo is avaliable [here](http://wafi.iit.cnr.it/webvis/diagrams/network/) (also included in the code).

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
    {"name": "A", "type": "one", "size": 4},
    {"name": "B", "type": "one", "size": 2},
    {"name": "C", "type": "two", "size": 7}
  ],
  "links": [
    {"source": 0, "target": 1, "type": 1, "weight": 2},
    {"source": 0, "target": 2, "type": 1, "weight": 1},
    {"source": 1, "target": 2, "type": 2, "weight": 3},
  ]
}
```

where `type`, `size` and `weight` are optional properties.

Then pass the JSON object to the NetworkView's constructor, along with a selector matching the SVG node:

```javascript
var net = new NetworkView({selector: '#the_graph', graph: json_graph});
```
