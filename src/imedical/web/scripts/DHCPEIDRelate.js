//
var SelectedRow=0
function Init()
{
	var obj;
	
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	obj=document.getElementById("ILLNessID");
	var ILLNess="";
	if (obj) ILLNess=obj.value;
	if (ILLNess!="")
	{
		obj=document.getElementById("ILLNessDesc");
		if (obj) obj.disabled=true;
		obj=document.getElementById("ComponentID");
		if (obj) ComponentID=obj.value;
		obj=document.getElementById('ld'+ComponentID+"iILLNessDesc");
		if (obj) obj.disabled=true;
	}
	else
	{
		obj=document.getElementById("EDDesc");
		if (obj) obj.disabled=true;
		obj=document.getElementById("ComponentID");
		if (obj) ComponentID=obj.value;
		obj=document.getElementById('ld'+ComponentID+"iEDDesc");
		if (obj) obj.disabled=true;
	}
}
//增加
function BUpdate_Click()
{	
	Update(0);
}
//删除
function BDelete_Click()
{	
	Update(1);
}
function Update(Type)
{
	var obj;
	var RowID="",IllID="",EDID="",InString="",encmeth="";
	obj=document.getElementById("RowID");
	if (obj) RowID=obj.value;
		
	if (Type=="1")
	{
		if (RowID=="")
		{
			//alert(t["RowIDNull"]);
			alert("请先选择要删除的记录");
			return;
		}
		InString=RowID
	}
	else
	{
		obj=document.getElementById("ILLNessID");
		if (obj) IllID=obj.value;
		if (IllID=="")
		{
			//alert(t["IllIDNull"]);
			alert("疾病描述不能为空");
			return;
		}
		obj=document.getElementById("EDID");
		if (obj) EDID=obj.value;
		if (EDID=="")
		{
			alert(t["EDIDNull"]);
			return;
		}
		InString=RowID+"^"+EDID+"^"+IllID;
	}
	obj=document.getElementById("UpdateBox");
	if (obj) encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,InString,Type)
	if (flag==0)
	{
		location.reload();
		return;
	}
	else{
		alert(flag)
		}

	alert(t["Err"]);
}
// **************************************************************


function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEIDRelate');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	var obj;
	obj=document.getElementById("ParRef");
	var ILLNess="";
	if (obj) ILLNess=obj.value;
	
	if (selectrow!=SelectedRow) {
		var Tobj;
		obj=document.getElementById("RowID");
		Tobj=document.getElementById("TRowIDz"+selectrow);
		if (obj) obj.value=Tobj.value;
		if (ILLNess!="")
		{
			obj=document.getElementById("EDID");
			Tobj=document.getElementById("TEDIDz"+selectrow);
			if (obj&&Tobj) obj.value=Tobj.value;
			obj=document.getElementById("EDDesc");
			Tobj=document.getElementById("TEDDescz"+selectrow);
			if (obj) obj.value=Tobj.innerText;
		}
		else
		{
			obj=document.getElementById("ILLNessID");
			Tobj=document.getElementById("TILLNessIDz"+selectrow);
			if (obj&&Tobj) obj.value=Tobj.value;
			obj=document.getElementById("ILLNessDesc");
			Tobj=document.getElementById("TILLNessDescz"+selectrow);
			if (obj) obj.value=Tobj.innerText;
		}
		SelectedRow = selectrow;
	}
	else
	{
		obj=document.getElementById("RowID");
		if (obj) obj.value="";
		if (ILLNess!="")
		{
			obj=document.getElementById("EDID");
			if (obj) obj.value="";
			obj=document.getElementById("EDDesc");
			if (obj) obj.value="";
		}
		else
		{
			obj=document.getElementById("ILLNessID");
			if (obj) obj.value="";
			obj=document.getElementById("ILLNessDesc");
			if (obj) obj.value="";
		}
		SelectedRow=0;
		
	}
	
}

function GetILLNessID(value)	{
	var value=value.split("^");
	var obj;
	obj=document.getElementById("ILLNessID");
	if (obj) obj.value=value[0];
	obj=document.getElementById("ILLNessDesc");
	if (obj) obj.value=value[1];
}
function GetEDID(value)	{
	var value=value.split("^");
	var obj;
	obj=document.getElementById("EDID");
	if (obj) obj.value=value[0];
	obj=document.getElementById("EDDesc");
	if (obj) obj.value=value[1];
}
function ILLNessChange()	{
	var obj;
	obj=document.getElementById("ILLNessID");
	if (obj) obj.value=""
}
function EDChange()
{
	var obj;
	obj=document.getElementById("EDID");
	if (obj) obj.value=""
}
document.body.onload = Init;// BodyLoadHandler;