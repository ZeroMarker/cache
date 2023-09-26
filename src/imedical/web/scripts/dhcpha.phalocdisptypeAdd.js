
var gParref;
var gPhalocDispTypeRowid ;
var gSelectDefault;

function BodyLoadHandler()
{ 
	var obj=document.getElementById("Add")
	if (obj) obj.onclick=Add;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Exit;
	var obj=document.getElementById("Parref")
	if (obj) gParref=obj.value;
	var obj=document.getElementById("DispType")
	if (obj) 
	{obj.onkeydown=popDispType;
	obj.onblur=DispTypeCheck;
	}
	
	}
function Add()
{
	var exe=""
	var obj=document.getElementById("mInsertPhaLocDispType")
	if (obj) exe=obj.value;
	else exe=""
	
	var obj=document.getElementById("DispTypeRowid");
	gPhalocDispTypeRowid=obj.value;
	var obj=document.getElementById("SelectDefault");
	if (obj)
	{if (obj.checked) gSelectDefault="Y"
	 else gSelectDefault="N" ;
	}
	
	if (gPhalocDispTypeRowid=="") {alert("请选择发药类别后重试!"); return ;}
	var result=cspRunServerMethod(exe,gParref,gPhalocDispTypeRowid,"","","",gSelectDefault);
	
	opener.location.reload();
	window.close();
}
function Exit()
{window.close();
}
function setLookupDrugGroup(str)
{
	var ss=str.split("^")
	
	var obj=document.getElementById("DispTypeRowid");
	if (obj) obj.value=ss[1] ;
}

function popDispType()
{ 
	if (window.event.keyCode==13) 
	{
		window.event.keyCode=117;
	  	DispType_lookuphandler();
		}
}
function DispTypeCheck()
{
	var obj=document.getElementById("DispType");
	var obj2=document.getElementById("DispTypeRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}
document.body.onload=BodyLoadHandler