/// DHCPEInPatientToHP.RecLoc.js
/// 创建时间		2015.05.14
/// 创建人		wrz
/// 主要功能		设置住院体检会诊费对应的接受科室
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成


var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSaveGenConUser");
	if (obj){ obj.onclick=BSaveGenConUser_click; }
	
	obj=document.getElementById("BSaveRecLoc");
	if (obj){ obj.onclick=BSaveRecLoc_click; }

	obj=document.getElementById("GenConUser");
	if (obj){ obj.onchange=GenConUser_change; }
	
	obj=document.getElementById("RecLocDesc");
	if (obj){obj.onchange=RecLocDesc_change;}
	
	obj=document.getElementById("DefaultDoc");
	if (obj){obj.onchange=DefaultDoc_change;}
	
}
function BSaveGenConUser_click()
{
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("GenConUserID");
	if (obj) UserID=obj.value;
	obj=document.getElementById("GenConUserClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID);
	
}
function BSaveRecLoc_click()
{
	var obj,StationID="",LocID="",RecLocID="",encmeth="",DefaultDocID = "";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("StationID");
	if (obj) StationID=obj.value;
	if (StationID==""){
		alert("请选择站点，然后保存数据");
		return false;
	}
	obj=document.getElementById("RecLocID");
	if (obj) RecLocID=obj.value;
	obj=document.getElementById("RecLocClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("DefaultDocID");
	if (obj) DefaultDocID=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,StationID,RecLocID+"^"+DefaultDocID);
	window.location.reload();
}
function GenConUser_change()
{
	var obj=document.getElementById("GenConUserID");
	if (obj) obj.value="";
}
function RecLocDesc_change()
{
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value="";
}
function DefaultDoc_change()
{
	var obj=document.getElementById("DefaultDocID");
	if (obj) obj.value="";
}

function AfterGenConUser(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("GenConUser");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("GenConUserID");
	if (obj) obj.value=Arr[2];
}
function AfterRecLocDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("RecLocDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value=Arr[2];
}

function DefaultDocSelect(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("DefaultDoc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("DefaultDocID");
	if (obj) obj.value=Arr[2];
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}

function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	FromTableToItem("StationID","StationID",selectrow);  
	FromTableToItem("StationDesc","STDesc",selectrow);  
	FromTableToItem("RecLocID","RecLocID",selectrow);  
	FromTableToItem("RecLocDesc","RecLocDesc",selectrow);  
	FromTableToItem("DefaultDocID","DefaultDocID",selectrow);  
	FromTableToItem("DefaultDoc","DefaultDoc",selectrow);
}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    Clear_click();
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);
	
}
function Clear_click()
{
	var obj=document.getElementById("RecLocDesc");
	if (obj) obj.value="";
	var obj=document.getElementById("RecLocID");
	if (obj) obj.value="";
	var obj=document.getElementById("StationID");
	if (obj) obj.value="";
	var obj=document.getElementById("StationDesc");
	if (obj) obj.value="";
	var obj=document.getElementById("DefaultDocID");
	if (obj) obj.value="";
	var obj=document.getElementById("DefaultDoc");
	if (obj) obj.value="";
	
}
document.body.onload = BodyLoadHandler;

