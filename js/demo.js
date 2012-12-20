(function() {

  $(function() {
    d3.json('data/miserables.json', function(data) {
      return new NetworkView({
        selector: '#network1, #network2',
        graph: data
      });
    });
    return d3.json('data/foo.json', function(data) {
      return new NetworkView({
        selector: '#network3',
        graph: data
      });
    });
  });

}).call(this);
