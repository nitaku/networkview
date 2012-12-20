(function() {

  $(function() {
    return d3.json('data/miserables.json', function(data) {
      return new NetworkView({
        selector: '#network1',
        graph: data
      });
    });
  });

}).call(this);
