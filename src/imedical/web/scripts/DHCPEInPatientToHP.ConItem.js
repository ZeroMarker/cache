/// DHCPEInPatientToHP.ConItem.js
/// 创建时间		2015.05.14
/// 创建人		wrz
/// 主要功能		设置住院体检职称对应的会诊医嘱
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成


var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSaveDefaultItem");
	if (obj){ obj.onclick=BSaveDefaultItem_click; }
	
	obj=document.getElementById("BSaveItem");
	if (obj){ obj.onclick=BSaveItem_click; }

	obj=document.getElementById("DefaultItemDesc");
	if (obj){ obj.onchange=DefaultItemDesc_change; }
	
	obj=document.getElementById("ItemDesc");
	if (obj){obj.onchange=ItemDesc_click;}
}
function BSaveDefaultItem_click()
{
	var obj,LocID="",DefaultItemID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("DefaultItemID");
	if (obj) DefaultItemID=obj.value;
	obj=document.getElementById("DefaultItemClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,DefaultItemID);
	
}
function BSaveItem_click()
{
	var obj,CarPrvTpID="",LocID="",ItemID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("CarPrvTpID");
	if (obj) CarPrvTpID=obj.value;
	if (CarPrvTpID==""){
		alert("请选择职称，然后保存数据");
		return false;
	}
	obj=document.getElementById("ItemID");
	if (obj) ItemID=obj.value;
	obj=document.getElementById("ItemClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,CarPrvTpID,LocID,ItemID);
	window.location.reload();
}
function DefaultItemDesc_change()
{
	var obj=document.getElementById("DefaultItemID");
	if (obj) obj.value="";
}
function ItemDesc_click()
{
	var obj=document.getElementById("ItemID");
	if (obj) obj.value="";
}
function AfterDefaultItemDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("DefaultItemDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("DefaultItemID");
	if (obj) obj.value=Arr[2];
}
function AfterItemDesc(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("ItemDesc");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("ItemID");
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
	FromTableToItem("CarPrvTpID","TCarPrvTpID",selectrow);  
	FromTableToItem("CarPrvTpDesc","TCarPrvTpDesc",selectrow);  
	FromTableToItem("ItemID","TItemID",selectrow);  
	FromTableToItem("ItemDesc","TItemDesc",selectrow);  
	
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
	var obj=document.getElementById("ItemDesc");
	if (obj) obj.value="";
	var obj=document.getElementById("ItemID");
	if (obj) obj.value="";
	var obj=document.getElementById("CarPrvTpID");
	if (obj) obj.value="";
	var obj=document.getElementById("CarPrvTpDesc");
	if (obj) obj.value="";
}
document.body.onload = BodyLoadHandler;

