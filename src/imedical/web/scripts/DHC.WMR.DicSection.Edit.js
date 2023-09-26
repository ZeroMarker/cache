/* =========================================================================
/By wuqk 2007-09-05
============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdUpdate");
	if (obj){obj.onclick=Update_click;}
	var obj=document.getElementById("TypeList");
	if (obj){
		obj.multiple = false;
	    obj.size = 1;
	    }
	GetData();
}

function GetData()
{
	var DicRowId=document.getElementById("DicRowId").value;
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
	var tempArr0=value.split(CHR_2);
	var tempArr=tempArr0[0].split(CHR_Up);
	gSetObjValue("DicRowId",tempArr[0]);
	gSetObjValue("Code",tempArr[1]);
	gSetObjValue("Desc",tempArr[2]);
	gSetListIndexByVal("TypeList",tempArr[3])
	var obj=document.getElementById("IsRequest")
	//gSetObjValue("IsRequest",tempArr[4]);
	if (tempArr[4]=="Yes"){obj.checked=true;}
	else{obj.checked=false;}
	gSetObjValue("ResumeText",tempArr[5]);
}
function Update_click()
{
	if (cTrim(gGetListData("Code"))==""){
		 websys_setfocus("Code");
		 return
	}
	if (cTrim(gGetListData("Desc"))==""){
		 websys_setfocus("Desc");
		 return
	}
	if (document.getElementById("TypeList").SelectIndex==-1){
		 websys_setfocus("TypeList");
		 return
	}
	var Instring=BuildData();
	var strMethod = document.getElementById("MethodUpdate").value;
	
	var ret = cspRunServerMethod(strMethod,Instring);
	if (ret > 0 ){
		alert(t['UpdateTrue']);
		//websys_closeWindows;
		window.close();
		    }
	else{
		alert(['UpdateFalse']+" Error:"+ret);
		}
}
	

function BuildData()
{
	var s=""
	s=s + gGetListData("DicRowId") + CHR_Up;
	s=s + gGetListData("Code") + CHR_Up;
	s=s + gGetListData("Desc") + CHR_Up;
	s=s + gGetListData("TypeList") + CHR_Up;
	var obj=document.getElementById("IsRequest")
	if (obj.checked==true){s=s + "Yes" + CHR_Up;}
	else{s=s + "No" + CHR_Up;}
	s+=gGetListData("ResumeText");
	return s;
}


document.body.onload = BodyLoadHandler;