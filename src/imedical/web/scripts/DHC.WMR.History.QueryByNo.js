/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.QueryByNo.Condition.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-5-16
 
COMMENT: 用来响应DHC.WMR.History.QueryByNo.Condition的事件

============================================================================ */

function txtMrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	DisplayResult();

}

function txtRegNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	DisplayResult();
}

function DisplayResult()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.History.QueryByNo.List" +
		"&MrTypeDR=" + GetParam(window, "MrType") + 
		"&PatientNo" + getElementValue("txtRegNo") + 
		"&MrNO" + getElementValue("txtMrNo") + 
		"&IsActive=Y";
	window.alert(lnk);
    parent.frames[1].location.href=lnk;	
}

function initForm()
{
}

function initEvent()
{
	document.getElementById("txtMrNo").onkeydown = txtMrNoOnKeyDown;
	document.getElementById("txtRegNo").onkeydown = txtRegNoOnKeyDown;
}
window.alert("AAA");
initForm();
initEvent();