/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.DictionaryTool

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-12
========================================================================= */
/*===========================================
Name:DisplayDictionaryList
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:Method Name Control ID
controlID:Control ID
dicName:
flag
displayRootDic:display root dictionary
Comment: display dictionary list in combox
============================================*/

var objChineseDic = GetChineseDic("MethodGetChineseDic", "DHC.WMR.DictionaryTool");

	function DisplayDictionaryList(methodControl, controlID, dicName, flag, displayRootDic)
	{
		var strMethod = document.getElementById(methodControl).value;
		var ret = cspRunServerMethod(strMethod, dicName , flag);
		var arryDic = null;
		var objDic = null;
		//window.alert("REturn:" + ret);
		if((ret != undefined) && (ret != ""))
		{
			arryDic = GetDHCWMRDictionaryArray(ret);
		}
		AddListItem(controlID, objChineseDic.Item("PleaseChoose"), "");
		for(var i = 0; i < arryDic.length; i ++)
		{
			objDic = arryDic[i];
			AddListItem(controlID, objDic.Code + "--" + objDic.Description , objDic.RowID);
		}
		if(displayRootDic)
		{
			AddListItem(controlID, objChineseDic.Item("RootDic"), "SYS");
		}
	}
	
	function DisplayDictionaryListPrivate(methodControl, controlID, dicName, flag, displayRootDic)
	{
		var strMethod = document.getElementById(methodControl).value;
		var ret = cspRunServerMethod(strMethod, dicName , flag);
		var arryDic = null;
		var objDic = null;
		//window.alert("REturn:" + ret);
		if((ret != undefined) && (ret != ""))
		{
			arryDic = GetDHCWMRDictionaryArray(ret);
		}
		AddListItem(controlID, objChineseDic.Item("PleaseChoose"), "");
		for(var i = 0; i < arryDic.length; i ++)
		{
			objDic = arryDic[i];
			AddListItem(controlID, objDic.Code + "--" + objDic.Description , objDic.Code);
		}
		if(displayRootDic)
		{
			AddListItem(controlID, objChineseDic.Item("RootDic"), "SYS");
		}
	}	