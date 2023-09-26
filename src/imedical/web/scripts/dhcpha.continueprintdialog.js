function BodyLoadHandler()
{
	  window.returnValue="";
	  var objpage=document.getElementById("page")
	  if(objpage) var page=objpage.value;
	  var objfrompage=document.getElementById("frompage");
	  if(objfrompage) objfrompage.value=1;
	  var objtopage=document.getElementById("topage");
	  if(objtopage) objtopage.value=page;
	  var obj=document.getElementById("bOK")
	  if (obj) obj.onclick=OkClick;
	  
	  
	  
}
function OkClick()
{
	var frompage="",topage=""
	var objpage=document.getElementById("page")
	if(objpage) var page=objpage.value;
	var objfrompage=document.getElementById("frompage");
	var objtopage=document.getElementById("topage");
	if (objfrompage){var frompage=objfrompage.value;}
	
	if(objtopage){var topage=objtopage.value;}
	if(topage<frompage){
		alert("起始页码大于终止页码");
		return;
		}
	if(topage>page){
		alert("打印范围超出总页数");
	    return;}
	if(frompage!="" && topage!=""){window.returnValue=frompage+"-"+topage;}
	else {window.returnValue="";}
	window.close();
}
document.body.onload=BodyLoadHandler