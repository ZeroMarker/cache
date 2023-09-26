/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Emergency.Edit

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-15
========================================================================= */
var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","EmergencyEdit");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]+"||"+tmpChinese[3]+"||"+tmpChinese[4]);


function ValidateContents()
{
	if(Trim(getElementValue("txtCode")) == "")
	{
		window.alert(t['Code']);
		return false;
	}
	if(Trim(getElementValue("txtDescription")) == "")
	{
		window.alert(t['Discription']);
		return false;
	}
	if(Trim(getElementValue("cboDataType")) == "")
	{
		window.alert(t['DataType']);
		return false;
	}
	return true;
}

function DisplayItem(obj)
{
	setElementValue("RowID", obj.RowID);
	setElementValue("txtCode", obj.Code);
	setElementValue("txtDescription", obj.Description);
	setElementValue("cboDataType", obj.DataType);
	setElementValue("chkActive", obj.IsActive);
	setElementValue("txtResume", obj.Resume);
	setElementValue("cboDic", obj.DictionaryCode);
}


function SaveToObject()
{
	var obj = DHCWMRWorkDetail();
	obj.RowID = getElementValue("RowID");
	obj.Code = getElementValue("txtCode");
	obj.Description = getElementValue("txtDescription");
	obj.DataType = getElementValue("cboDataType");
	obj.IsActive = getElementValue("chkActive");
	obj.Resume = getElementValue("txtResumeText");
	obj.DictionaryCode = getElementValue("cboDic");
	return obj;	
}

function SaveItem()
{
	var strMethod = getElementValue("MethodSave");
	var ret = cspRunServerMethod(strMethod, SerialDHCWMRWorkDetail(SaveToObject()));
	return (ret != undefined);
}

function cmdSaveOnClick()
{
	if(!ValidateContents())
	{
		return;
	}
	if(SaveItem())
	{
		window.alert(t['UpdateTrue']);
		window.close();
	}
	else
	{
		window.alert(t['UpdateFalse']);
	}
}

function ProcessRequest()
{
	var strRowID = getElementValue("RowID");
	var obj = null;
	if(strRowID == "")
	{
		return;
	}
	obj = GetDHCWMRWorkDetailByID("MethodRead", strRowID);
	if(obj != null)
	{
		DisplayItem(obj);
	}else
	{
		window.alert(t['NotReadInfo']);
	}
	
}

function initForm()
{
	var obj = null;
	obj = document.getElementById("cboDataType");
	obj.multiple = false;
	obj.size = 1;
	MakeComboBox("cboDic");
	setElementValue("chkActive", true);	
	AddListItem("cboDataType", tmpChinese[0], "Text");
	AddListItem("cboDataType", tmpChinese[1], "Number");
	AddListItem("cboDataType", tmpChinese[2], "Date");
	AddListItem("cboDataType", tmpChinese[3], "Dictionary");
	AddListItem("cboDic", tmpChinese[4], "", 0);
	setElementValue("cboDic", "");	
	ProcessRequest();
}

function initEvent()
{
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
}


initForm();
initEvent();