/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Emergency.List

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
tmpChinese=GetChinese("MethodGetChinese","EmergencyList");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]);

function initForm()
{
	var obj = document.getElementById("Flag");
	obj.multiple = false;
	obj.size = 1;
	AddListItem("Flag", tmpChinese[0], "");
	AddListItem("Flag", tmpChinese[1], "Y");
	AddListItem("Flag", tmpChinese[2], "N");
	
}

//initForm();