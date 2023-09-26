/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Dictionary.List
 
AUTHOR: LiYang , Microsoft
DATE  : 2007-3-9

COMMENT: DHC.WMR.Dictionary.List事件响应

========================================================================= */
	function AddListItem(controlID, itemCaption, itemValue)
	{
		var obj = document.getElementById(controlID);
		var objItm = document.createElement("OPTION");
		obj.options.add(objItm);		
		objItm.innerText = itemCaption;
		objItm.value = itemValue;
	}

function initForm()
{
	AddListItem("Type", "请选择字典", "");
	AddListItem("Flag", "全部", "");
	AddListItem("Flag", "Y", "");
	AddListItem("Flag", "N", "");
	var obj = null;
	obj = document.getElementById("Type");
	obj.multiple = false;
	obj.size = 1;
	
	obj = document.getElementById("Flag");
	obj.multiple = false;
	obj.size = 1;
	window.alert("AAADDDSSS");
	
}

function initEvent()
{
}

initForm();
initEvent();