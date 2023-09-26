var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("ArcItem");
	if (obj) obj.onkeydown=ArcItem_KeyDown;
	obj=document.getElementById("Show_Item");
	if (obj) obj.onclick=ShowItem_Click;
	obj=document.getElementById("Show_Sets");
	if (obj) obj.onclick=ShowSet_Click;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=Save_Click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=Delete_Click;
	obj=document.getElementById("FindEmage");
	if (obj) obj.onclick=LookUp_Item;
	websys_setfocus("ArcItem");
	/*var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEItemSort&IsItem=N";
		alert(lnk)	
	location.href=lnk;*/
}
function ArcItem_KeyDown()
{
	var key=websys_getKey(e);
	if (13==key) 
	{
		LookUp_Item();
	}
	
}
function LookUp_Item()
{
	obj=document.getElementById("Show_Item");
	if (obj&&obj.checked)
	{
		var method="web.DHCPE.StationOrder:StationOrderList"
	}
	else
	{
		var method="web.DHCPE.HandlerOrdSetsEx:queryOrdSet"
	}
	var obj=document.getElementById("ArcItem");

	var jsfunction="GetItemSet"
	var url='websys.lookup.csp';
		url += "?ID=ArcItem";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ websys_escape(obj.value);
	websys_lu(url,1,'');
	return websys_cancel();	
}
function ShowItem_Click()
{
	var IsItem="N"
	obj=document.getElementById("Show_Item");
	if (obj&&obj.checked) IsItem="Y"
	obj=document.getElementById("Show_Sets");
	if (obj) obj.checked=!obj.checked
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEItemSort&IsItem="+IsItem;
			
	location.href=lnk;
}
function ShowSet_Click()
{
	var IsItem="N"
	obj=document.getElementById("Show_Item");
	if (obj) obj.checked=!obj.checked
	if (obj&&obj.checked) IsItem="Y"
	obj=document.getElementById("Show_Sets");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEItemSort&IsItem="+IsItem;
			
	location.href=lnk;
}
function Save_Click()
{
	var objtbl=document.getElementById('tDHCPEItemSort');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var i=1,IDs="",Sorts="",ID="",Sort="";
	
	for (i=1;i<rows;i++)
	{
		var obj=document.getElementById("TIDz"+i)
		if (obj) ID=obj.value;
		var obj=document.getElementById("TSortz"+i)
		if (obj) Sort=obj.value;
		Sort=Trim(Sort);
		if ((Sort=="")||(Sort=="0"))
		{
			alert(i+t["Null"]);
			return;
		}
		if (IDs=="")
		{
			IDs=ID;
			Sorts=Sort;
		}
		else
		{
			IDs=IDs+"^"+ID;
			Sorts=Sorts+"^"+Sort;
		}
	} 
	if (IDs=="") return;
	var Type="Item";
	obj=document.getElementById("Show_Item");
	if (obj&&obj.checked)
	{
		
	}
	else
	{
		Type="Set";
	}
	var encmeth="";
	var encmethobj=document.getElementById("UpdateBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,Type,IDs,Sorts);
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
}
function Delete_Click()
{
	var Type="Item"
	var ID=""
	obj=document.getElementById("Show_Item");
	if (obj&&obj.checked)
	{
		
	}
	else
	{
		Type="Set";
	}
	if (CurRow==0) return;
	var obj=document.getElementById("TIDz"+CurRow)
	if (obj) var ID=obj.value;
	var encmeth="";
	var encmethobj=document.getElementById("DeleteBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,Type,ID);
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
}
function GetItemSet(value)
{
	var Type="Item"
	var ID=""
	var StrArr=value.split("^");
	obj=document.getElementById("Show_Item");
	if (obj&&obj.checked)
	{
		ID=StrArr[2];
	}
	else
	{
		Type="Set";
		ID=StrArr[0];
	}
	var encmeth=""
	var encmethobj=document.getElementById("InsertBox");
	if (encmethobj) var encmeth=encmethobj.value;
	var flag=cspRunServerMethod(encmeth,Type,ID);
	if (flag==0)
	{
		location.reload();
	}
	else
	{
		alert(t[flag]);
	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEItemSort');	//取表格元素?名称
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
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

document.body.onload = BodyIni;