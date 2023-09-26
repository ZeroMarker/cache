/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.QueryByEntry.Qry.js

AUTHOR: zhufei, Microsoft
DATE  : 2007-6


============================================================================ */
/*
function txtMainIdOnKeyDown()
{
	var MainId="",VolId=""
	if(window.event.keyCode != 13)
		return;
	MainId=getElementValue("txtMainId");
	DisplayResult(MainId,VolId);
	document.getElementById("txtMainId").focus();
}

function txtVolIdOnKeyDown()
{
	var MainId="",VolId=""
	if(window.event.keyCode != 13)
		return;
	VolId=getElementValue("txtVolId");
	DisplayResult(MainId,VolId);
	document.getElementById("txtVolId").focus();
}
*/

function txtMainIdOnKeyDown()
{
	var MainId="",VolId="";
	if(window.event.keyCode != 13)
		return;
	MainId=getElementValue("txtMainId");
	if (MainId.length==13){
		var BarCodeType=MainId.substr(0,2);
		var cTemp=MainId.substr(2,11);
		if (BarCodeType=="01"){
			MainId=cTemp;
		}
	}
	MainId=Number(MainId);
	DisplayResult(MainId,VolId);
	document.getElementById("txtMainId").value=MainId;
	document.getElementById("txtVolId").value=VolId;
	document.getElementById("txtMainId").focus();
}

function txtVolIdOnKeyDown()
{
	var MainId="",VolId="";
	if(window.event.keyCode != 13)
		return;
	VolId=getElementValue("txtVolId");
	if (VolId.length==13){
		var BarCodeType=VolId.substr(0,2);
		var cTemp=VolId.substr(2,11);
		if (BarCodeType=="02"){
			VolId=cTemp;
		}
	}
	VolId=Number(VolId);
	DisplayResult(MainId,VolId);
	document.getElementById("txtMainId").value=MainId;
	document.getElementById("txtVolId").value=VolId;
	document.getElementById("txtVolId").focus();
}

function DisplayResult(MainId,VolId)
{
	if ((MainId=="")&&(VolId==""))
		return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainByEntry.List" + "&MainId=" +MainId+"&VolId="+VolId;
    parent.RPMain.location.href=lnk;
}

function Query_click()
{
	var MainId="",VolId="",cMainId="",cVolId=""
	MainId=getElementValue("txtMainId");
	if (MainId.length==13){
		var xBarCodeType=MainId.substr(0,2);
		var xTemp=MainId.substr(2,11);
		if (xBarCodeType=="01"){
			cMainId=xTemp;
		}
	}
	VolId=getElementValue("txtVolId");
	if (VolId.length==13){
		var yBarCodeType=VolId.substr(0,2);
		var yTemp=VolId.substr(2,11);
		if (yBarCodeType=="02"){
			cVolId=yTemp;
		}
	}
	cMainId=Number(cMainId);
	cVolId=Number(cVolId);
	DisplayResult(cMainId,cVolId);
	document.getElementById("txtMainId").focus();
}

function initForm()
{
}

function initEvent()
{
	document.getElementById("txtMainId").onkeydown = txtMainIdOnKeyDown;
	document.getElementById("txtVolId").onkeydown = txtVolIdOnKeyDown;
	document.getElementById("cmdQuery").onclick = Query_click;
}

initForm();
initEvent();
