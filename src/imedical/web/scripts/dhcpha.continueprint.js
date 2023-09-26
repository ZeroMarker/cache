function BodyLoadHandler()
{
	  window.returnValue="";
	  var obj=document.getElementById("bOK")
	  if (obj) obj.onclick=OkClick;
	  
	  
	  
}
function OkClick()
{
	var frompage="",topage=""
	var objfrompage=document.getElementById("frompage");
	var objtopage=document.getElementById("topage");
	//if (objfrompage){var frompage=objfrompage.value;}
	
	//if(objtopage){var topage=objtopage.value;}
	
	//if(frompage!="" && topage!=""){window.returnValue=frompage+"-"+topage;}
	//else {window.returnValue="";}
	window.close();
}
document.body.onload=BodyLoadHandler