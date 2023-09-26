/// dhcpha.resfusereason.js
var currRow="0";
function BodyLoadHandler()
{
  window.returnValue="";
  var obj=document.getElementById("cmdOk")
  if (obj) obj.onclick=OkClick;
  var obj=document.getElementById("cmdCancel")
  if (obj) obj.onclick=CancelClick;
  var obj=document.getElementById("opReason")
  if (obj) obj.onblur=ReasonLostFocs;
}
/*
function DispOpReasonLookUpSelect(str)
{
	var op=str.split("^");
	var obj=document.getElementById("ReasonDr");
	if (obj){
		if (op.length>0) obj.value=op[1];
		else obj.value="";
	}
}
*/
/*function OkClick()
{
	var obj=document.getElementById("ReasonDr");
	if (obj){window.returnValue=obj.value;}
	else {window.returnValue="";}
	//alert(window.returnValue)
	window.close();
}
*/
function OkClick()
{
	var PORID="";
	if (currRow>0){
		var obj=document.getElementById("tbReasonID"+"z"+currRow);
		if (obj){PORID=obj.value}
	}
	window.returnValue=PORID;
	window.close();
}
function CancelClick()
{
	window.returnValue="";
	window.close();
}
/*
function ReasonLostFocs()
{
	var obj=document.getElementById("opReason")
  	if (obj){
	  	if (obj.value==""){
		  	var obj=document.getElementById("ReasonDr")
  			if (obj){obj.value="";}
  			
	  	}
  	}
}
*/
function SelectRowHandler()
{
	currRow=selectedRow(window)
}
document.body.onload=BodyLoadHandler