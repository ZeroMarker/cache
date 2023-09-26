/* =========================================================================
/By wuqk 2007-09-05
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	GetData();
}

function GetData()
{
	var obj=document.getElementById("DicRowid");
	var DicRowId=obj.value;
	if (DicRowId==""){}
	else{
	    var strMethod = document.getElementById("MethodGetDic").value;
	    var ret = cspRunServerMethod(strMethod,DicRowId);
	    if (ret!=""){
		    showData(ret);
		    }
		}
}
function showData(value)
{
	var tempArr=value.split(CHR_2);
	var tempArr0=tempArr[0].split(CHR_Up);
	var tempArr1=tempArr[1].split(CHR_Up);
	
	gSetObjValue("DicCode",tempArr0[1]);
	gSetObjValue("DicTitle",tempArr0[2]);
	gSetObjValue("DicResumeText",tempArr0[5]);
	gSetObjValue("DicType",tempArr1[3]);
}

document.body.onload = BodyLoadHandler;