/**
	hxy
	2020-08-06
*/
$(function(){ 
var c=document.getElementById("myCanvas");
var ctx=c.getContext("2d");
ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(50,20,50,20);
ctx.strokeStyle="#818181"
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,50,50,50);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,80,50,80);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,110,50,110);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,140,50,140);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,170,50,170);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,200,50,200);
ctx.stroke();



var c=document.getElementById("my");
var ctx=c.getContext("2d");
ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(100,20,100,20);
ctx.strokeStyle="#818181"
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,50,100,50);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,80,100,80);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,110,100,110);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,140,100,140);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,170,100,170);
ctx.stroke();

ctx.beginPath();
ctx.moveTo(20,20);
ctx.quadraticCurveTo(20,200,100,200);
ctx.stroke();


})