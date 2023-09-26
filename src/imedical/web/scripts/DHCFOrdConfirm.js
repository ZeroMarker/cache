//DHCFOrdConfirm.js
//IF ADD DATA TO "tDHCOPAdm" SET "Disstatus"=1


var PatNoObj=document.getElementById("PatNo");  
var CtLocObj=document.getElementById("CtLoc"); 
var AdmNohObj=document.getElementById("AdmNoh"); 
var AdmNoObj=document.getElementById("AdmNo");
var RecLocIdObj=document.getElementById("RecLocId");   
var ConfirmObj=document.getElementById("Confirm");  
var DHCFOrdConfirmObj=document.getElementById("tDHCFOrdConfirm");
var OrdItmObj=document.getElementById("OrdItm");
var OrdItmhObj=document.getElementById("OrdItmh");
var StDateObj=document.getElementById("StDate");
//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,0' VIEWASTEXT>");
//document.write("</object>");
function BodyLoadHandler() 
{	
   if (PatNoObj) 
   	{	
   		PatNoObj.onchange=PatNoonChange;
   		PatNoObj.onkeydown=PatNoKeyDown
   	}
   if (ConfirmObj) 
   {
	   ConfirmObj.onclick=ConfirmClick
   }
   if (OrdItmObj) {OrdItmObj.onchange=OrdItmonChange;}
   	
}
function PatNoKeyDown(e)
{   var RetValue;
	var key = websys_getKey(e);

	if (key==13) 
	{ 
		var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirm&AdmNoh='+AdmNohObj.value+"&RecLocId="+RecLocIdObj.value;
		lnk+='&PatNo='+PatNoObj.value+'&AdmNo='+AdmNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;
		lnk+='&StDate='+StDateObj.value;
		window.location=lnk;
	 }

}
function SetAdmId(value)
{ 	var AdmStr=value.split("^")
	if (AdmNohObj) 
	{ AdmNohObj.value=AdmStr[1];	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirm&AdmNoh='+AdmNohObj.value+"&RecLocId="+RecLocIdObj.value;
	lnk+='&PatNo='+PatNoObj.value+'&AdmNo='+AdmNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;;
	lnk+='&StDate='+StDateObj.value;
	window.location=lnk;

}
function SetOrdItmh(value)
{ 	var Str=value.split("^")
	if (OrdItmhObj) 
	{ OrdItmhObj.value=Str[1];	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirm&AdmNoh='+AdmNohObj.value+"&RecLocId="+RecLocIdObj.value;
	lnk+='&PatNo='+PatNoObj.value+'&AdmNo='+AdmNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;
	lnk+='&StDate='+StDateObj.value;
	window.location=lnk;
}
function ConfirmClick()
{
	var QueryRows=DHCFOrdConfirmObj.rows.length;
	var RunClass=document.getElementById("Confirmh")
	for (Queryrow=1;Queryrow<QueryRows;Queryrow++)
	{
		var ConfirmStatus=DHCFGetCellValue('ConfirmStatusz'+Queryrow);
		if (ConfirmStatus)
		{
			var OrdId=DHCFGetCellValue('OrdIdz'+Queryrow);
			if (RunClass)
			{
				var Para='I'+"^"+RecLocIdObj.value+"^"+OrdId+"^"+session['LOGON.USERID'];
				RetValue=cspRunServerMethod(RunClass.value,Para)
				var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCFOrdConfirm&AdmNoh='+AdmNohObj.value+"&RecLocId="+RecLocIdObj.value;
				lnk+='&PatNo='+PatNoObj.value+'&AdmNo='+AdmNoObj.value+"&OrdItm="+OrdItmObj.value+"&OrdItmh="+OrdItmhObj.value;
				lnk+='&StDate='+StDateObj.value;
				window.location=lnk;
			}
		}
				
	}
}

function PatNoonChange()
{
	if (OrdItmObj) 
	{OrdItmObj.value="";
	 OrdItmhObj.value="";
	 AdmNohObj.value="";
	 AdmNoObj.value="";
	}
}
function OrdItmonChange()
{
	if (PatNoObj) 
	{PatNoObj.value="";
	 AdmNohObj.value="";
	 AdmNoObj.value=""
	}
}
document.body.onload = BodyLoadHandler;
