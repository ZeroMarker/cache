/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.Extra.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-4-20

COMMENT: DHC.WMR.WorkFlow.Extra Event handler

============================================================================ */

//Save extra info table
//1-mainStatus 2-volStatus
function SaveStatusDetailToObject(flag)
{
	var arry = new Array();
	var obj = null;
	var objTbl = parent.frames[0].document.getElementById("tDHC_WMR_WorkDetail");
	for(var i = 1; i <= objTbl.rows.length; i ++)
	{
		if(flag == "1")
			obj = DHCWMRMainStatusDtl();
		else
			obj = DHCWMRVolStatusDtl();
		obj.WorkItemList_Dr = getElementValue("WorkItemListDrz" + i, parent.frames[0].document);
		obj.Detail_Dr = getElementValue("WorkDetailRowidz" + i, parent.frames[0].document);
		obj.ItemValue = getElementValue("ItemValuez" + i, parent.frames[0].document);
		arry.push(obj);
	}
	return arry;
}


function cmdOKOnClick()
{
	if(getElementValue("txtIsValidatePassed", parent.frames[0].document) != "True")
	{
		window.alert(getElementValue("txtErrorMsg", parent.frames[0].document));
		return;
	}
	var objArry = SaveStatusDetailToObject(GetParam(parent, "flag"));
	window.returnValue = objArry;
	window.close();
}


function cmdCancelOnClick()
{
	window.returnValue = new Array();
	window.close();
}

function initForm()
{
	var link = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkDetail";
	link += "&MainStatusRowid=" + GetParam(parent, "MainStatusRowid") +
			"&VolStatusRowid=" + GetParam(parent, "VolStatusRowid") +
			"&WorkItemRowid=" + GetParam(parent, "WorkItemRowid") +
			"&IsEdit=" + GetParam(parent, "IsEdit") +
			"&StatusFrom=" + GetParam(parent, "StatusFrom") +
			"&StatusTo=" + GetParam(parent, "StatusTo") +
			"&ValidateUser=" + GetParam(parent, "ValidateUser") +
			"&MainRowid=" + GetParam(parent, "MainRowid") +
			"&VolRowid=" + GetParam(parent, "VolRowid");
	parent.frames[0].location.href = link;
}

function initEvents()
{
	document.getElementById("cmdOK").onclick = cmdOKOnClick;
	document.getElementById("cmdCancel").onclick = cmdCancelOnClick;
}

initForm();
initEvents();