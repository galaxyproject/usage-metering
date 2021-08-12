
// set the dimensions and margins of the graph
var margin = {top: 10, right: 30, bottom: 30, left: 60},
    width = 500 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

// append the SVG object to the body of the page
var SVG = d3.select("#dataviz_axisZoom")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

//Read the data
chart = d3.csv("total_cpu_time_numjobs.csv", function(data) {

  // Add X axis
  var x = d3.scaleLinear()
    .domain([0,d3.max(data,d=>+d.num_jobs)])
    .range([ 0, width ]);
  
    var xAxis = SVG.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x))

  

  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, d3.max(data,d=>+d.total_cpu_time)])
    .range([ height, 0]);
  var yAxis = SVG.append("g")
    .call(d3.axisLeft(y))

    // y-axis label
    SVG.append("text")
      .classed("label", true)
      .attr("x",40)
      .attr("y",0)
      .style("text-anchor", "end")
      .text("total_cpu_time");
    
    // x-axis label
    SVG.append("text")
        .classed("label",true)
        .attr("x",width)
        .attr("y",height+30)
        .style("text-anchor","end")
        .text("num_jobs");

  var tooltip = d3.select("#dataviz_axisZoom")
    .append("div")
    .style("opacity", 1)
    .attr("class", "tooltip")
    .style("background-color", "white")
    .style("border", "solid")
    .style("border-width", "1px")
    .style("border-radius", "5px")
    .style("padding", "10px")



  // A function that change this tooltip when the user hover a point.
  // Its opacity is set to 1: we can now see it. Plus it set the text and position of tooltip depending on the datapoint (d)
  var mouseover = function(d) {
    tooltip
      .style("opacity", 1)
  }

  var mousemove = function(d) {
    tooltip
      .html("Tool_name_version: " + d.tool_name_version + "<br>Numjobs:" + d.num_jobs + "<br>total_cpu_time:" + d.total_cpu_time)
      .style("left", (d3.mouse(this)[0]) + "px") 
      .style("top", (d3.mouse(this)[1]) + "px")
  }

  // A function that change this tooltip when the leaves a point: just need to set opacity to 0 again
  var mouseleave = function(d) {
    tooltip
      .transition()
      .duration(2000)
      .style("opacity", 0)
  }

  // Add a clipPath: everything out of this area won't be drawn.
  var clip = SVG.append("defs").append("SVG:clipPath")
      .attr("id", "clip")
      .append("SVG:rect")
      .attr("width", width )
      .attr("height", height )
      .attr("x", 0)
      .attr("y", 0);

  // Create the scatter variable: where both the circles and the brush take place
  var scatter = SVG.append('g')
     .attr("clip-path", "url(#clip)")

  // Add circles
  scatter
    .selectAll("circle")
    .data(data)
    .enter()
    .append("circle")
      .attr("cx", function (d) { return x(d.num_jobs); } )
      .attr("cy", function (d) { return y(d.total_cpu_time); } )
      .attr("r", 1)
      .style("fill", "green")
      .style("opacity", 1)
      .on("mouseover", mouseover)
      .on("mousemove",mousemove)
      .on("mouseout", mouseleave);

  // Set the zoom and Pan features: how much you can zoom, on which part, and what to do when there is a zoom
  var zoom = d3.zoom()
      .scaleExtent([0.5, 100])  // This control how much you can unzoom (x0.5) and zoom (x20)
      .extent([[0, 0], [width, height]])
      .on("zoom", updateChart);

  // This add an invisible rect on top of the chart area. This rect can recover pointer events: necessary to understand when the user zoom
  SVG.append("rect")
      .attr("width", width)
      .attr("height", height)
      .style("fill", "none")
      .style("pointer-events", "all")
      .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
      .call(zoom);
  // now the user can zoom and it will trigger the function called updateChart



  // A function that updates the chart when the user zoom and thus new boundaries are available
  function updateChart() {

    // recover the new scale
    var newX = d3.event.transform.rescaleX(x);
    var newY = d3.event.transform.rescaleY(y);

    // update axes with these new boundaries
    xAxis.call(d3.axisBottom(newX))
    yAxis.call(d3.axisLeft(newY))

    // update circle position
    scatter
      .selectAll("circle")
        .attr('cx', function(d) {return newX(d.num_jobs)})
        .attr('cy', function(d) {return newY(d.total_cpu_time)})

  }

})