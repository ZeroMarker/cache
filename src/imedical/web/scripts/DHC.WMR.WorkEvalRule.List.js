/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkEvalRule.List

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-14
========================================================================= */
function cmdQueryOnClick()
{
	window.navigate(
		"websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkEvalRule.List&RefRowID=" 
		+ getElementValue("ParID")
		+ "&ParID=" + getElementValue("ParID") 
		+ "&Flag=" + getElementValue("Flag")
		);
}
function cmdAddNewOnClick()
{
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkEvalRule.Edit&RowID=" + getElementValue("ParID");
    //location.href=lnk;
	window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkEvalRule.Edit&RowID=" + getElementValue("ParID"));
}

function initEvent()
{
	document.getElementById("cmdQuery").onclick = cmdQueryOnClick;
	document.getElementById("cmdAdd").onclick = cmdAddNewOnClick;
}

function initForm()
{
	var objItem = GetDHCWMRWorkItemByID("MethodGetWorkItem", getElementValue("ParID"));
	document.getElementById("txtWorkItem").innerText = objItem.Description;
}
initForm();
initEvent();