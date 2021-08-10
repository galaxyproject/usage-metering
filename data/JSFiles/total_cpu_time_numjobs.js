var margin = { top: 50, right: 300, bottom: 50, left: 50 },
    outerWidth = 1500,
    outerHeight = 500,
    width = outerWidth - margin.left - margin.right,
    height = outerHeight - margin.top - margin.bottom;

var x = d3.scale.linear()
    .range([0, width]).nice();

var y = d3.scale.linear()
    .range([height, 0]).nice();

d3.csv("total_cpu_time_numjobs.csv", function(data) {


  var xMax = d3.max(data, function(d) { return +d.num_jobs; }),
      xMin = d3.min(data, function(d) { return +d.num_jobs; }),
      xMin = xMin > 0 ? 0 : xMin,
      yMax = d3.max(data, function(d) { return +d.total_cpu_time; }),
      yMin = d3.min(data, function(d) { return +d.total_cpu_time; }),
      yMin = yMin > 0 ? 0 : yMin;

  x.domain([xMin, xMax]);
  y.domain([yMin, yMax]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom");

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left");

  var color = d3.scale.category10();

  var tip = d3.tip()
      .attr("class", "d3-tip")
      .offset([-10, 0])
      .html(function(d) {
        return "tool_name_version" + ": " + d.tool_name_version + "<br>num_jobs" + ": " + d.num_jobs +  "<br>total_cpu_time" + ": " + d.total_cpu_time;
      });

  var zoomBeh = d3.behavior.zoom()
      .x(x)
      .y(y)
      .scaleExtent([0,200])
      .on("zoom", zoom);

  var svg = d3.select("#scatter")
    .append("svg")
      .attr("width", outerWidth)
      .attr("height", outerHeight)
    .append("g")
      .attr("transform", "translate(" + 100 + "," + margin.top + ")")
      .call(zoomBeh);

  svg.call(tip);

  svg.append("rect")
      .attr("width", width)
      .attr("height", height);

  svg.append("g")
      .classed("x axis", true)
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    .append("text")
      .classed("label", true)
      .attr("x", width)
      .attr("y", margin.bottom - 10)
      .style("text-anchor", "end")
      .text("num_jobs");

  svg.append("g")
      .classed("y axis", true)
      .call(yAxis)
    .append("text")
      .classed("label", true)
      .attr("y",-20)
      .style("text-anchor", "end")
      .text("total_cpu_time");

  var objects = svg.append("svg")
      .classed("objects", true)
      .attr("width", width)
      .attr("height", height);

  objects.selectAll(".dot")
      .data(data)
    .enter().append("circle")
      .classed("dot", true)
      .attr("r", 1.5)
      .attr("transform", function(d) { return "translate(" + x(d.num_jobs) + "," + y(d.total_cpu_time) + ")"})
      .style("fill", function(d) { return color(d.tool_name_version); })
      .on("mouseover", tip.show)
      .on("mouseout", tip.hide);


  function zoom() {
    svg.select(".x.axis").call(xAxis);
    svg.select(".y.axis").call(yAxis);

    svg.selectAll(".dot")
        .attr("transform", function(d) { return "translate(" + x(d.num_jobs) + "," + y(d.total_cpu_time) + ")"});
  }

});