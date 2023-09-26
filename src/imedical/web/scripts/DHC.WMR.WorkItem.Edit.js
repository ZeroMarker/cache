/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkItem.Edit.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-8

COMMENT: DHC.WMR.WorkItem.Edit

============================================================================ */
var tmpList
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpList=GetChinese("MethodGetChinese","WorkItemEdit");

function ValidateContents()
{
	var strValue = "";
	strValue = getElementValue("cboWorkType");
	if(strValue == "")
	{
		window.alert(t['WorkType']);
		document.getElementById("cboWorkType").focus();
		return false;
	}
	strValue = getElementValue("txtDescription");
	if(Trim(strValue) == "")
	{
		window.alert(t['WorkFlowName']);
		document.getElementById("txtDescription").focus();
		return false;
	}
	return true;
}


function SaveToObject()
{
	var obj = DHCWMRWorkItem();
	obj.RowID = getElementValue("RowID");
	obj.ItemType = getElementValue("cboWorkType");					//	
	obj.Description = getElementValue("txtDescription");			//	
	obj.IsActive = getElementValue("chkActive");					//	
	obj.Resume = getElementValue("txtResumeText");
	obj.SysOper_Dr = getElementValue("cboSysOpe");
	obj.CheckUser = getElementValue("chkNeedSign");
	obj.BeRequest = getElementValue("BeRequest");         //by wuqk 2008-2-26
	return obj;
}

function SaveWorkItem()
{
	var strMethod = document.getElementById("MethodSave").value;
	var ret = cspRunServerMethod(strMethod, SerialzieDHCWMRWorkItem(SaveToObject()));
	return (ret != undefined);
}

function DisplayWorkItem(obj)
{
	 setElementValue("txtRowID", obj.RowID);
	 setElementValue("cboWorkType", obj.ItemType);					//	
	 setElementValue("txtDescription", obj.Description);			//	
	 setElementValue("chkActive", obj.IsActive);					//	
	 setElementValue("txtResumeText", obj.Resume);
	 setElementValue("cboSysOpe", obj.SysOper_Dr);
	 setElementValue("chkNeedSign", obj.CheckUser);
	 setElementValue("BeRequest", obj.BeRequest);         //by wuqk 2008-2-26
}

function ProcessRequest()
{
	var strRowID = document.getElementById("RowID").value
	var objItm = null;
	if( strRowID == "")
	{
		return ;
	}
	
	objItm = GetDHCWMRWorkItemByID("MethodGetByRowID", strRowID);
	if(objItm == null)
	{
		window.alert(t['NotReadData']);
	}else
	{
		DisplayWorkItem(objItm);
	}
}



function cmdSaveOnClick()
{
	var objItem = null;
	if(!ValidateContents())
	{
		return ;
	}
	if(SaveWorkItem())
	{
		window.alert(t['UpdateTrue']);
		window.close();
	}
	else
	{
		window.alert(t['UpdateFalse']);
	}
}

function initForm()
{
	var obj = document.getElementById("cboWorkType");
	DisplayDictionaryList("MethodGetDicList", "cboWorkType", "WorkType", "Y", false);
	obj.size = 1;
	obj.multiple = false;
	setElementValue("chkActive", true);
	MakeComboBox("cboSysOpe");
	AddListItem("cboSysOpe", tmpList[0], "", 0);
	setElementValue("cboSysOpe", "");
	setElementValue("chkNeedSign", true);
	setElementValue("BeRequest", "");    //by wuqk 2008-2-26
	ProcessRequest();
}


function initEvent()
{
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
}

initForm();
initEvent();


//Add Item to ListBox Control
function AddListItem(controlID, itemCaption, itemValue, pos)
{
	var obj = document.getElementById(controlID);
	var objItm = document.createElement("OPTION");
	if(pos >=0 )
	{
		obj.options.add(objItm, pos);		
	}else
	{
		obj.options.add(objItm);
	}
	objItm.innerText = itemCaption;
	objItm.value = itemValue;
	return objItm;
}


function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}