/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.EmergencyDetail.Edit

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
tmpChinese=GetChinese("MethodGetChinese","EmergencyDetailEdit");
//alert(tmpChinese[0]);

function cmdAddOnClick()
{
	var objList = document.getElementById("lstList");
	var objItm = null;
	var objExtra = null;
	if(objList.selectedIndex == -1)
	{
		window.alert(t['SelectItem']);
	}
	else
	{
		objItm = objList.options.item(objList.selectedIndex);
		if(objSelectedDic.Exists(objItm.value))
		{
			window.alert(t['HaveInList']);
		}
		else
		{
			objExtra = objWorkItemDic.Item(objItm.value);
			objItm = AddListItem("lstSelected", objExtra.Description, objExtra.RowID);
			objExtra.IsActive = true;
			objSelectedDic.Add(objExtra.RowID, objExtra)
		}
	}
}
function cmdRemoveOnClick()
{
	var objList = document.getElementById("lstSelected");
	var objItm = null;
	if(objList.selectedIndex == -1)
	{
		window.alert(t['SelectItem']);
	}
	else
	{
		objItm = objList.options.item(objList.selectedIndex);
		objExtra = objSelectedDic.Item(objItm.value);
		objExtra.Required = false;
		objExtra.IsActive = false;		
		objSelectedDic.Remove(objItm.value);
		objList.options.remove(objList.selectedIndex);
	}
}

function cmdUpOnClick()
{
	var obj = document.getElementById("lstSelected");
	if (obj.selectedIndex==-1) return;
	var itm = obj.options.item(obj.selectedIndex);
	
	if(itm.index > 0)
	{
		var newItem = AddListItem("lstSelected", itm.innerText, itm.value, itm.index - 1);
		obj.options.remove(itm.index);
		newItem.selected = true;
	}
}

function cmdDownOnClick()
{
	var obj = document.getElementById("lstSelected");
	if (obj.selectedIndex==-1) return;
	var itm = obj.options.item(obj.selectedIndex);
	if(itm.index < obj.options.length - 1)
	{
		var newItem = AddListItem("lstSelected", itm.innerText, itm.value, itm.index + 2);
		obj.options.remove(itm.index);
		newItem.selected = true;
	}
}

function cboSelectedOnDoubleClicked()
{
	var strSelected = getElementValue("lstSelected");
	var objDetail = null;
	var strResult = null;
	if(strSelected == "")
	{
		window.alert(t["ChoiceOnItem"]);
		return;
	}
	objDetail = objSelectedDic.Item(strSelected);
	strResult = window.prompt(t["InputDefaultValue"], objDetail.DefaultValue);
	if(strResult != undefined)
	{
		objDetail.DefaultValue = strResult;
	}
	
	
}

function DisplayExtraItemList()
{
	var strMethod = getElementValue("MethodExtraList");
	var ret = cspRunServerMethod(strMethod, "Y");
 	var arry = GetDHCWMRWorkDetailArray(ret);
 	var objExtra = null;
 	var objItem = null;
 	for(var i = 0; i < arry.length; i ++)
 	{
 		objExtra = arry[i];
 		objWorkItemDic.Add(objExtra.RowID, objExtra);
 		objItem = AddListItem("lstList", objExtra.Description, objExtra.RowID)
 		objExtra.Required = false;
 		objExtra.IsActive = false;
 		objExtra.DefaultValue = "";
 	}
}

function cmdRequiredOnClick()
{
	var objList = document.getElementById("lstSelected");
	var objItm = null;
	var objExtra = null;
	var oldPos = -1;
	if(objList.selectedIndex == -1)
	{
		window.alert(t['SelectItem']);
	}
	else
	{
		objItm = objList.options.item(objList.selectedIndex);
		objExtra = 	objSelectedDic.Item(objItm.value);
		objExtra.Required = !objExtra.Required;
		oldPos = objItm.index;
		if(objExtra.Required)
		{
			objList.options.remove(oldPos);
			objExtra = AddListItem("lstSelected",  objExtra.Description + tmpChinese[0], objExtra.RowID, oldPos);
		}
		else
		{
			objList.options.remove(oldPos);
			objExtra = AddListItem("lstSelected",  objExtra.Description, objExtra.RowID, oldPos);
		}
	}

}

function cmdSaveOnClick()
{
	if(SaveWorkDetailList())
	{
		window.alert(t['UpdateTrue']);
		window.close();
	}
	else
	{
		window.alert(t['UpdateFalse']);
	}
}

function SaveWorkDetailList()
{
	var arry = SaveToObject();
	return SaveDHCWMRWorkItemListArry("MethodSaveListItem", arry);
}




//Load the saved information
function LoadSavedList(Parref)
{
	var arry = GetDHCWMRWorkItemListArry("MethodGetSavedList", Parref, "");
	var obj = null; //Saved Detail Dictionary
	var objItm = null;//Detail Dictionary Item
	for(var i = 0 ; i < arry.length; i ++)
	{
		obj = arry[i];
		if(obj.IsActive)
		{
			objItm = objWorkItemDic.Item(obj.DetailDr);
			AddListItem("lstSelected", objItm.Description + (obj.IsNeed ? tmpChinese[0] : ""), obj.DetailDr, obj.ListIndex);
			objItm.Required = obj.IsNeed;
			objItm.DefaultValue = obj.DefaultValue;
			objSelectedDic.Add(obj.DetailDr, objItm);
		}
		objSaved.Add(obj.DetailDr, obj);
	}
}

function SaveToObject()
{
	var objExtra = null;//sudden item
	var objListItem = null;//sudden item detail
	var objList = document.getElementById("lstList");
	var objSelectedList = document.getElementById("lstSelected");
	var objItm = null;//<OPTION>
	//First initialization data to be stored list,
	// to ensure that every item has a corresponding dictionary project
	for(var i = 0; i < objList.length; i ++)
	{
		objExtra = objWorkItemDic.Item(objList.options.item(i).value);
		if(!objSaved.Exists(objExtra.RowID))
		{
			objListItem = DHCWMRWorkItemList();
			objListItem.Parref = getElementValue("RefRowID");			//	DHC_WMR_WorkItem Parent Reference
			objListItem.ChildSub = "";									//	Childsubscript
			objListItem.DetailDr = objExtra.RowID;						//	
			objListItem.ListIndex = "-1";			//	
			objListItem.IsActive = false;			//	
			objListItem.IsNeed = false;			//	
			objListItem.Resume = "";			//	
			objListItem.DefaultValue = "";
			objSaved.Add(objListItem.DetailDr, objListItem);
		}
		else
		{
			objListItem = objSaved.Item(objExtra.RowID);
			objListItem.IsActive = false;
			objListItem.IsNeed = false;
			objListItem.ListIndex = "-1";
		}
	}
	for(var i = 0; i < objSelectedList.options.length; i ++)
	{
		objItm = objSelectedList.options.item(i);
		objExtra = objWorkItemDic.Item(objItm.value);
		objListItem = objSaved.Item(objItm.value);
		objListItem.ListIndex = objItm.index;
		objListItem.IsActive = true;			//	
		objListItem.IsNeed = objExtra.Required;				//	
		objListItem.DefaultValue = objExtra.DefaultValue;//
	}
	return objSaved.Items().toArray();
}

function ProcessRequest()
{
	var strPar = getElementValue("RefRowID");
	var objItm = null;
	if(strPar == "")
	{
		window.alert(t['EditDetail']);
		window.close();
	}
	objItm = GetDHCWMRWorkItemByID("MethodGetWorkItem", strPar);
	if(objItm == null)
	{
		window.alert(t['NotReadWorkItem']);
		window.close();
	}
	else
	{
		document.getElementById("txtWorkItem").innerText = objItm.Description;
	}
	DisplayExtraItemList();	
 	LoadSavedList(strPar);

}

function initForm()
{
	var obj = null;
	obj = document.getElementById("lstList");
	obj.multiple = false;
	obj = document.getElementById("lstSelected");
	obj.multiple = false;
	ProcessRequest();
}

function initEvent()
{
	document.getElementById("cmdAdd").onclick = cmdAddOnClick;
	document.getElementById("cmdRemove").onclick = cmdRemoveOnClick;
	document.getElementById("cmdRequired").onclick = cmdRequiredOnClick;
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
	document.getElementById("cmdUp").onclick = cmdUpOnClick;
	document.getElementById("cmdDown").onclick = cmdDownOnClick;
	document.getElementById("lstSelected").ondblclick = cboSelectedOnDoubleClicked;
}

var objWorkItemDic = new ActiveXObject("Scripting.Dictionary");
var objSelectedDic = new ActiveXObject("Scripting.Dictionary");
var objSaved = new ActiveXObject("Scripting.Dictionary");
initForm();
initEvent();