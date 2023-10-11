$(function(){
  //alert("list")
  $("body.service").empty();
  var frameStr='<iframe id="myFrame" src="ensWebServiceNew.csp" width="100%" style="border:0;"></iframe>'
  //$("body.service").append(frameStr)
  //console.log("load")
  $("body.service").load("hip.ens.webser.csp");//¼ÓÔØ·þÎñ×¢²á
}) 