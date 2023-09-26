//DHCFOrdConfirmFind.js
//IF ADD DATA TO "tDHCOPAdm" SET "Disstatus"=1


var PatNoObj=document.getElementById("PatNo");  
var CtLocObj=document.getElementById("CtLoc"); 
var RecLocIdObj=document.getElementById("RecLocId");   
var DHCFOrdConfirmFindObj=document.getElementById("tDHCFOrdConfirmFind");
var OrdItmObj=document.getElementById("OrdItm");
var OrdItmhObj=document.getElementById("OrdItmh");
var ConfirmDateObj=document.getElementById("ConfirmDate");
//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,0' VIEWASTEXT>");
//document.write("</object>");
function BodyLoadHandler() 
{
   if (PatNoObj) 
   	{	
   		PatNoObj.onchange=PatNoonChange;
   		PatNoObj.onkeydown=PatNoKeyDown;
   	}

   if (OrdItmObj)  {OrdItmObj.onchange=OrdItmonChange;}
   	
}
function PatNoKeyDown(e)
{   var RetValue;
	var key = websys_getKey(e);
	if (key==13) 
	{	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirmFind&RecLocId='+RecLocIdObj.value;
		lnk+='&PatNo='+PatNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;
		lnk+='&ConfirmDate='+ConfirmDateObj.value;
		window.location=lnk;
	}
}

function SetOrdItmh(value)
{ 	var Str=value.split("^")
	if (OrdItmhObj) 
	{ 	OrdItmhObj.value=Str[1];	
		var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirmFind&RecLocId='+RecLocIdObj.value;
		lnk+='&PatNo='+PatNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;
		lnk+='&ConfirmDate='+ConfirmDateObj.value;
		window.location=lnk;
	}
		
}
function PatNoonChange()
{	PatNoObj.select()
	if (OrdItmObj) 
	{OrdItmObj.value="";
	 OrdItmhObj.value="";
	 
	}
}
function OrdItmonChange()
{	OrdItmObj.select()
	if (PatNoObj) 
	{PatNoObj.value="";}
}
document.body.onload = BodyLoadHandler;
