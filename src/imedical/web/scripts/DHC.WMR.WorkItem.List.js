/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkItem.List.JS

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-13
========================================================================= */
function initForm()
{
	var obj = null;
	obj = document.getElementById("Type");
	obj.multiple = false;
	obj.size = 1;
	
	//obj = document.getElementById("Flag");
	//obj.multiple = false;
	//obj.size = 1;
	
	DisplayDictionaryList("MethodGetDicList", "Type", "WorkType", "", false);
}

//initForm();
