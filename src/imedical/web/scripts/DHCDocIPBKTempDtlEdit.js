/* ======================================================================
NAME: DHCDocIPBKTempDtlEdit.js
AUTHOR: lxf
DATE  : 2008-10-27
========================================================================= */

var objTemplateItemDic = new ActiveXObject("Scripting.Dictionary");
var objSelectedDic = new ActiveXObject("Scripting.Dictionary");
function cmdAddOnClick()
{
	var objList = document.getElementById("lstList");
	var objItm = null;
	var objTemplateItm = null;
	var objDtl = null; 
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
			objTemplateItm = objTemplateItemDic.Item(objItm.value);
			objDtl = new DHCDocIPBKTempDtl();
			objDtl.TempID = document.getElementById("RefRowID").value;
			objDtl.ItemID = objTemplateItm.RowID;
			objDtl.DefaultValue = "";
			objDtl.IsNeed = false;
			objItm = AddListItem("lstSelected", objTemplateItm.ItemDesc, objTemplateItm.RowID);
			objSelectedDic.Add(objTemplateItm.RowID, objDtl)
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
	if(obj.selectedIndex==-1){
		alert(t['SelectItem']);
		return;
	}
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
	if(obj.selectedIndex==-1){
		alert(t['SelectItem']);
		return;
	}
	//alert("obj.selectedIndex="+obj.selectedIndex);
	var itm = obj.options.item(obj.selectedIndex);
	//alert("itm.value="+itm.value+"itm.innerText"+itm.innerText);
	//alert("itm.index="+itm.index);
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
 	var arry = GetDHCDocIPBKTempItemArray(ret);
 	var objTemplateItm = null;
 	for(var i = 0; i < arry.length; i ++)
 	{
 		objTemplateItm = arry[i];
 		objTemplateItemDic.Add(objTemplateItm.RowID, objTemplateItm);
 		AddListItem("lstList", objTemplateItm.ItemDesc, objTemplateItm.RowID)
 	}
}

function cmdRequiredOnClick()
{
	var objList = document.getElementById("lstSelected");
	var objItm = null;
	var objDetail = null;
	var oldPos = -1;
	if(objList.selectedIndex == -1)
	{
		window.alert(t['SelectItem']);
	}
	else
	{
		objItm = objList.options.item(objList.selectedIndex);
		objTemplateItem = objTemplateItemDic.Item(objItm.value);
		objDetail = objSelectedDic.Item(objItm.value);
		objDetail.IsNeed = !objDetail.IsNeed;
		if(objDetail.IsNeed)
		{
			objItm.innerText = objTemplateItem.ItemDesc + t['Required'];
		}
		else
		{
			objItm.innerText = objTemplateItem.ItemDesc;
		}
	}

}

function cmdSaveOnClick()
{
	if(SaveTemplateDetailList())
	{
		window.alert(t['UpdateTrue']);
		window.close();
	}
	else
	{
		window.alert(t['UpdateFalse']);
	}
}

function SaveTemplateDetailList()
{
	var arry = SaveToObject();
	return SaveDHCDocIPBKTempDtlListArry(
		"MethodSaveListItem", 
		"MethodDeleteTemplateDetail", 
		document.getElementById("RefRowID").value,
		arry);
}

//Load the saved information
function LoadSavedList(Parref)
{
	var arry = GetDHCDocIPBKTempDtlListArry("MethodGetSavedList", Parref);
	var objDetail = null; 			
	var objTemplateItem = null;		
	for(var i = 0 ; i < arry.length; i ++)
	{
		objDetail = arry[i];
		objTemplateItem = objTemplateItemDic.Item(objDetail.ItemID);
		//alert("objDetail.ItemID="+objDetail.ItemID+";objTemplateItem.ItemDesc="+objTemplateItem.ItemDesc);
		AddListItem("lstSelected", objTemplateItem.ItemDesc + (objDetail.IsNeed ? t['Required'] : ""), objDetail.ItemID);
		objSelectedDic.Add(objDetail.ItemID, objDetail);
	}
}
/*
function SaveToObject()
{
	var objDtl = null;
	var objListItem = null;
	var objList = document.getElementById("lstList");
	var objSelectedList = document.getElementById("lstSelected");
	var objItm = null;
	for(var i = 0; i < objSelectedList.options.length; i ++)
	{
		objItm = objSelectedList.options.item(i);
		objDtl = objSelectedDic.Item(objItm.value);
		objDtl.RowID = "";
	}
	return objSelectedDic.Items().toArray();
}
*/
function SaveToObject()
{
	var objDtl = null;
	var objListItem = null;
	var objList = document.getElementById("lstList");
	var objSelectedList = document.getElementById("lstSelected");
	var objItm = null;
	var objArry = new Array();
	for(var i = 0; i < objSelectedList.options.length; i ++)
	{
		objItm = objSelectedList.options.item(i);
		objDtl = objSelectedDic.Item(objItm.value);
		objDtl.RowID = "";
		objArry.push(objDtl);
	}
	return objArry;
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
	objItm = GetMedIPBKTemplateByID("MethodGetTemplateByID", strPar);
	if(objItm == null)
	{
		window.alert(t['NotReadWorkItem']);
		window.close();
	}
	else
	{
		document.getElementById("txtTemplate").innerText = objItm.TempDesc;//display the DHCDocIPBKTemplate item 
	}
	DisplayExtraItemList();	
 	LoadSavedList(strPar);

}

function initForm()
{
	initEvent();
	var obj = null;
	obj = document.getElementById("lstList");
	obj.multiple = false;
	obj = document.getElementById("lstSelected");
	obj.multiple = false;
	ProcessRequest();
	initEvent();
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
/*===========================================
Name:SaveDHCDocIPBKTempDtlListArry
Author: lxf
Date: 2008-10-27
Param:
methodControl:
arry:The collection of TemplateItemList
Comment: Save to Table DHCDocIPBKTempDtl
============================================*/
function SaveDHCDocIPBKTempDtlListArry(MethodControl, MethodControlDel, TemplateID, arry)
{
	var strMethod = document.getElementById(MethodControl).value;
	var tmp = "";
	var ret = "";
	var returnValue = true;
	cspRunServerMethod(document.getElementById(MethodControlDel).value, TemplateID);
	for(var i = 0; i < arry.length; i ++)
	{
		tmp = "";
		tmp = SerializeDHCDocIPBKTempDtlList(arry[i]);
		ret = cspRunServerMethod(strMethod, tmp);
		if(ret == "-100")
		{
			returnValue = false;
		}
	}
	return returnValue;
}

window.onload=initForm;
