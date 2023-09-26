/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Dictionary.List

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-9
========================================================================= */
// 	function AddListItem(controlID, itemCaption, itemValue)
// 	{
// 		var obj = document.getElementById(controlID);
// 		var objItm = document.createElement("OPTION");
// 		obj.options.add(objItm);		
// 		objItm.innerText = itemCaption;
// 		objItm.value = itemValue;
// 	}

function initForm()
{
	DisplayDictionaryListPrivate("MethodGetDicList", "Type", "SYS", "", true);
	var obj = null;
	obj = document.getElementById("Type");
	obj.multiple = false;
	obj.size = 1;
	
	//obj = document.getElementById("Flag");
	//obj.multiple = false;
	//obj.size = 1;
}

function newSysDic()
{
// 	window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Dictionary.Edit", "_blank", "height=100,width=100");
// 	var strDicName = window.prompt(t['NewDicName'], "");
// 	var objDic = null;
// 	var encmeth = document.getElementById("MethodSave").value;
// 	if((strDicName == null) || (strDicName == "") )
// 	{
// 		window.alert(t['NoInputDicName']);
// 	}
// 	else
// 	{
// 		objDic = DHCWMRDictionary();
// 		objDic.DictionaryName = "SYS";
// 		objDic.Description = strDicName;
// 		window.alert(encmeth);
// 		var ret=cspRunServerMethod(encmeth, SerializeDHCWMRDictionary(objDic));
// 		window.alert(ret);
// 	}
}

function initEvent()
{
//  	document.getElementById("cmdNewSysDic").onclick = newSysDic;
}

//initForm();
//initEvent();
