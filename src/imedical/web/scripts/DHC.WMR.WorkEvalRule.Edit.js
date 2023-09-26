/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkEvalRule.Edit

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-14
========================================================================= */

function ValidateContents()
{
	if(getElementValue("txtDescription") == "")
	{
		window.alert(t['EvaRule']);
		document.getElementById("txtDescription").focus();
		return false;
	}
	return true;
}

function DisplayRule(obj)
{
	//setElementValue("RowID", obj.RowID);
	setElementValue("txtDescription", obj.Description);		//	
	setElementValue("chkIsActive", obj.IsActive);			//	
	setElementValue("txtResumeText", obj.Resume);			//	
}

function SaveToObject()
{
	var obj = DHCWMRWorkItemRule();
	obj.Parref = strPar;		//	DHC_WMR_WorkItem Parent Reference
	obj.ChildSub = strChildSub;		//	Childsubscript
	obj.Description = getElementValue("txtDescription");	//	
	obj.IsActive =getElementValue("chkIsActive");			//	
	obj.Resume = getElementValue("txtResumeText");			//	
	return obj;
}

function ProcessRequest()
{
	var objItm = GetDHCWMRWorkItemByID("MethodGetWorkItem", strPar);
	var objRule = null;
	setElementValue("txtWorkItem", objItm.Description);	
	if(strChildSub != "")
	{
		objRule = GetDHCWMRWorkItemRuleByID("MethodRead", getElementValue("RowID"));
		DisplayRule(objRule);
	}
	
}

function SaveRule()
{

	var strMethod = getElementValue("MethodSave");
	var ret = cspRunServerMethod(strMethod, SerializeDHCWMRWorkItemRule(SaveToObject()));
	return (ret != undefined);
}

function cmdSaveOnClick()
{
	if(!ValidateContents())
	{
		return;
	}
	if(SaveRule())
	{
		window.alert(t['UpdateTrue']);
		window.close();
	}
	else
	{
		windows.alert(t['UpdateFalse']);
	}
}

function initForm()
{
	setElementValue("chkActive", true);
	ProcessRequest();
}

function initEvent()
{
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
}

var strPar = GetCode(getElementValue("RowID"), "||");
var strChildSub = GetDesc(getElementValue("RowID"), "||");

initForm();
initEvent();