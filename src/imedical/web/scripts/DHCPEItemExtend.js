var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("ARCDesc");
	if (obj) obj.onkeydown=ArcItem_KeyDown;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Save_Click;
	obj=document.getElementById("FindEmage");
	if (obj) obj.onclick=LookUp_Item;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;

	websys_setfocus("ARCDesc");
	
}

function BFind_Click()
{
	var obj;
	var iARCDesc="";
	obj=document.getElementById("ARCDesc");
	if (obj) iARCDesc=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEItemExtend"
			+"&ARCDesc="+iARCDesc
			;	
	location.href=lnk;
}

function ArcItem_KeyDown()
{
	var key=websys_getKey(e);
	if (13==key) 
	{
		LookUp_Item();
		return false
	}
}
function LookUp_Item()
{
	var method="web.DHCPE.StationOrder:StationOrderList"
	var obj=document.getElementById("ARCDesc");
 
	var jsfunction="GetItemSet"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ websys_escape(obj.value);
	
	websys_lu(url,1,'');
	return websys_cancel();	
}

function Save_Click()
{
	var ID=""
	var obj=document.getElementById("ARCID");
	if (obj) ID=obj.value;
	if (ID=="")
	{
		alert("没有医嘱项目");
		return false;
	}
	var encmeth=""
	var obj=document.getElementById("InsertClass");
	if (obj)
	{
		encmeth=obj.value;
	}
	if (encmeth=="")
	{
		alert("没有更新方法");
		return;
	}
	var Flag=cspRunServerMethod(encmeth,ID);
	if (Flag!=0)
	{
		alert(Flag);
		return false;
	}
	else
	{
		window.location.reload();
	}
}
function GetItemSet(value)
{
	if (value=="") return;
	var StrArr=value.split("^");
	var obj=document.getElementById("ARCID");
	if (obj) obj.value=StrArr[2];
	var obj=document.getElementById("ARCDesc");
	if (obj) obj.value=StrArr[1];;
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEItemExtend');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0
		//obj.disabled=true;
	}
	else
	{
		CurRow=Row;
		//obj.disabled=false;
	}
}
function ARCInfo(value)
{
	if (value=="") return;
    var tmp=value.split("^")
    var obj=document.getElementById('ARCID');
    obj.value=tmp[1];
    var obj=document.getElementById('ARCDesc');
    obj.value=tmp[0]
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

document.body.onload = BodyIni;