/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.QueryByNo.Condition.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-5-16
============================================================================ */

function txtMrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	DisplayResult();
	document.getElementById("txtMrNo").focus();
}

function txtRegNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	DisplayResult();
}

function DisplayResult()
{
	var PatientNo=""
	PatientNo=getElementValue("txtRegNo");
	if (PatientNo!=""){PatientNo=FormatRegNo(PatientNo);}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.History.QueryByNo.List" +
		"&MrTypeDR=" + GetParam(parent, "MrType") + 
		"&PatientNo=" + PatientNo + 
		"&MrNO=" + getElementValue("txtMrNo") + 
		"&IsActive=Y";
    parent.frames[1].location.href=lnk;	
    document.getElementById("txtRegNo").focus();
}

function Query_click()
{
	var PatientNo=""
	PatientNo=getElementValue("txtRegNo");
	if (PatientNo!=""){PatientNo=FormatRegNo(PatientNo);}
	if ((PatientNo=="")&&(getElementValue("txtMrNo")=="")) return;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.History.QueryByNo.List" +
		"&MrTypeDR=" + GetParam(parent, "MrType") + 
		"&PatientNo=" + PatientNo + 
		"&MrNO=" + getElementValue("txtMrNo") + 
		"&IsActive=Y";
    parent.RPbottom.location.href=lnk;
}

function initForm()
{
}

function initEvent()
{
	document.getElementById("txtMrNo").onkeydown = txtMrNoOnKeyDown;
	document.getElementById("txtRegNo").onkeydown = txtRegNoOnKeyDown;
	document.getElementById("cmdQuery").onclick = Query_click;
}

initForm();
initEvent();


function FormatRegNo(str)
{
	tmp = str;
	while(tmp.length <8)
	{
		tmp = "0" + tmp;
	}
	return tmp;
}