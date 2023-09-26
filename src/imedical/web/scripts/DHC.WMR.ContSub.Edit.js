/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.ContSub.Edit.js

AUTHOR: ZF , Microsoft
DATE  : 2007-7

COMMENT: DHC.WMR.ContSub.Edit

============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdUpdate");
	if (obj){obj.onclick=Update_click;}
	var obj=document.getElementById("cmdAdd");
	if (obj){obj.onclick=Add_click;}
	iniForm();
}

function iniForm()
{
	insertData();
}

function insertData()
{
	var cContSubRowId="";
	var obj=document.getElementById("ContSubRowId");
	if (obj){cContSubRowId=obj.value;}
	if (cContSubRowId==""){return;}
	
	var obj=document.getElementById('MethodGetContSubByRowId');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ContSubInfo=cspRunServerMethod(encmeth,cContSubRowId);
    if (ContSubInfo!=""){
	    Temp=ContSubInfo.split("^")
		var obj=document.getElementById("Code");
	    if (obj){obj.value=Temp[1];}
		var obj=document.getElementById("Desc");
	    if (obj){obj.value=Temp[2];}
		var obj=document.getElementById("IsRequest");
	    if (obj){
		    if (Temp[3]=="Y") {obj.value=true;}
		    else{obj.value=false;}
		}
    }
}

function Add_click()
{
	var cContentsRowId="",cContSubRowId="",cContSubSubId="",cContSubCode="",cContSubDesc="",cContSubIsRequest=""
	
	var obj=document.getElementById("ContentsRowId");
	if (obj){cContentsRowId=obj.value;}
	else{cContentsRowId=""}
	
	var obj=document.getElementById("ContSubRowId");
	if (obj){cContSubRowId=Trim(obj.value);}
	else{cContSubRowId=""}
	
	if (cContSubRowId!=""){
		Temp=cContSubRowId.split("||");
		if (cContentsRowId==""){cContentsRowId=Temp[0];}
		cContSubSubId="";
	}
	
	var obj=document.getElementById("Code");
	if (obj){cContSubCode=Trim(obj.value);}
	else{cContSubCode=""}
	
	var obj=document.getElementById("Desc");
	if (obj){cContSubDesc=Trim(obj.value);}
	else{cContSubDesc=""}
	
	var obj=document.getElementById("IsRequest");
	if (obj){
		if (obj.checked==true) {cContSubIsRequest="Y";}
		else{cContSubIsRequest="N";}
	}
	else{cContSubIsRequest="";}
	
	if ((cContentsRowId=="")||(cContSubCode=="")||(cContSubDesc=="")||(cContSubIsRequest=="")) return;
	
	var Condition=cContentsRowId+"^"+cContSubSubId+"^"+cContSubCode+"^"+cContSubDesc+"^"+cContSubIsRequest;
	var obj=document.getElementById('MethodUpdateContSub');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Id=cspRunServerMethod(encmeth,Condition);
    Temp=Id.split("||")
    if (Temp[0]<1){alert(t['UpdateFalse']);}
    else{
	    //alert(t['UpdateTrue']);
    }
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.List" + "&ContentsRowId="+cContentsRowId;
	parent.RPtop.location.href=lnk;
}

function Update_click()
{
	var cContentsRowId="",cContSubRowId="",cContSubSubId="",cContSubCode="",cContSubDesc="",cContSubIsRequest=""
	
	var obj=document.getElementById("ContentsRowId");
	if (obj){cContentsRowId=obj.value;}
	else{cContentsRowId=""}
	
	var obj=document.getElementById("ContSubRowId");
	if (obj){cContSubRowId=Trim(obj.value);}
	else{cContSubRowId=""}
	
	if (cContSubRowId!=""){
		Temp=cContSubRowId.split("||");
		if (cContentsRowId==""){cContentsRowId=Temp[0];}
		cContSubSubId=Temp[1];
	}
	
	var obj=document.getElementById("Code");
	if (obj){cContSubCode=Trim(obj.value);}
	else{cContSubCode=""}
	
	var obj=document.getElementById("Desc");
	if (obj){cContSubDesc=Trim(obj.value);}
	else{cContSubDesc=""}
	
	var obj=document.getElementById("IsRequest");
	if (obj){
		if (obj.checked==true) {cContSubIsRequest="Y";}
		else{cContSubIsRequest="N";}
	}
	else{cContSubIsRequest="";}
	
	if ((cContentsRowId=="")||(cContSubCode=="")||(cContSubDesc=="")||(cContSubIsRequest=="")) return;
	
	var Condition=cContentsRowId+"^"+cContSubSubId+"^"+cContSubCode+"^"+cContSubDesc+"^"+cContSubIsRequest;
	var obj=document.getElementById('MethodUpdateContSub');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Id=cspRunServerMethod(encmeth,Condition);
    Temp=Id.split("||")
    if (Temp[0]<1){alert(t['UpdateFalse']);}
    else{
	    //alert(t['UpdateTrue']);
    }
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.List" + "&ContentsRowId="+cContentsRowId;
	parent.RPtop.location.href=lnk;
}

document.body.onload = BodyLoadHandler;