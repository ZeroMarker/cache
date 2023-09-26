/// DHCPEInPatientToHP.InDoc.js
/// 创建时间		2015.05.14
/// 创建人		wrz
/// 主要功能		设置住院体检的住院医生、不允许使用体检录入的提交
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成


var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click; }
	obj=document.getElementById("BDelete");
	if (obj){ obj.onclick=BDelete_click; }
	obj=document.getElementById("UserName");
	if (obj){ obj.onchange=UserName_change; }
	
}
function BSave_click()
{
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("请选择待设置人员");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID);
	window.location.reload();
}
function BDelete_click()
{
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("请选择待删除数据");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID,"Y");
	window.location.reload();
}
function UserName_change()
{
	var obj=document.getElementById("UserID");
	if (obj) obj.value="";
}

function AfterUserName(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("UserName");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("UserID");
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
	FromTableToItem("UserID","TUserID",selectrow);  
	FromTableToItem("UserName","TUserName",selectrow);
	
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
	var obj=document.getElementById("UserID");
	if (obj) obj.value="";
	var obj=document.getElementById("UserName");
	if (obj) obj.value="";
}
document.body.onload = BodyLoadHandler;

