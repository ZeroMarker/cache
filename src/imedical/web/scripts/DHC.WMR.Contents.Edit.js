/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Contents.Edit.js

AUTHOR: ZF , Microsoft
DATE  : 2007-7
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdUpdate");
	if (obj){obj.onclick=Update_click;}
	iniForm();
}

function iniForm()
{
	insertData();
}

function insertData()
{
	var cContentsRowId="";
	var obj=document.getElementById("txtContentsRowId");
	if (obj){cContentsRowId=obj.value;}
	if (cContentsRowId==""){return;}
	
	var obj=document.getElementById('MethodGetContentsByRowId');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ContentsInfo=cspRunServerMethod(encmeth,cContentsRowId);
    if (ContentsInfo!=""){
	    Temp=ContentsInfo.split("^")
		var obj=document.getElementById("txtContentsCode");
	    if (obj){obj.value=Temp[1];}
		var obj=document.getElementById("txtContentsDesc");
	    if (obj){obj.value=Temp[2];}
    }
}

function Update_click()
{
	var cContentsRowId="",cContentsCode="",cContentsDesc=""
	
	var obj=document.getElementById("txtContentsRowId");
	if (obj){cContentsRowId=obj.value;}
	else{cContentsRowId=""}

	var obj=document.getElementById("txtContentsCode");
	if (obj){cContentsCode=Trim(obj.value);}
	else{cContentsCode=""}
	
	var obj=document.getElementById("txtContentsDesc");
	if (obj){cContentsDesc=Trim(obj.value);}
	else{cContentsDesc=""}
	
	if ((cContentsCode=="")||(cContentsDesc=="")) return;
	
	var Condition=cContentsRowId+"^"+cContentsCode+"^"+cContentsDesc;
	var obj=document.getElementById('MethodUpdateContents');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Id=cspRunServerMethod(encmeth,Condition);
    if (Id>0){alert(t['UpdataTrue']);}
    else{alert(t['UpdataFalse']);}
}

document.body.onload = BodyLoadHandler;