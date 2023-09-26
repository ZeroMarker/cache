var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Save_Click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=Delete_Click;

	obj=document.getElementById("Type");
	if (obj) obj.onchange=Select_Click;
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

}

function Clear_click()
{ 
  setData(0)

}


function Select_Click()
{
    var Type=""
	var obj=document.getElementById("Type");
	if (obj&&obj.checked) {
		Type="ReportItem";
	}
		else{
			Type="PatItem";
			}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESetPatItem"
			+"&Type="+Type;
    window.location.href=lnk; 
}

function Save_Click()
{
	Update("0")
	window.location.reload();
	
}
function Delete_Click()
{
	Update("1")
}
function Update(Type)
{
	
	var obj,RowID,Name,Sort,Diet,Place,encmeth,AutoChange="N";
	var Reporttype="PatItem";
	obj=document.getElementById("RowID");
	if (obj) RowID=Trim(obj.value);
	obj=document.getElementById("Name");
	if (obj) Name=Trim(obj.value);
	obj=document.getElementById("Sort");
	if (obj) Sort=obj.value;
	obj=document.getElementById("Place");
	if (obj) Place=obj.value;
	
	var IFDocSign="N"
	obj=document.getElementById("IFDocSign");
	if ((obj)&&(obj.checked)) {IFDocSign="Y";}
	var PatSignName="N"
	obj=document.getElementById("PatSignName");
	if ((obj)&&(obj.checked)) {PatSignName="Y";}
	obj=document.getElementById("Type");
	if ((obj)&&(obj.checked)){
		   Reporttype="ReportItem";
		} 
	//if (IFDocSign=="on") {IFDocSign="Y";}
	//alert(IFDocSign)
		
	obj=document.getElementById("AutoChange");
	if ((obj)&&(obj.checked)) AutoChange="Y"
	obj=document.getElementById("UpdateClassBox");
	if (obj) encmeth=obj.value;
	var Strs=Name+"^"+Sort+"^^"+AutoChange+"^"+Place+"^"+IFDocSign+"^"+PatSignName;
	var Return=cspRunServerMethod(encmeth,RowID,Strs,Type,Reporttype);
	window.location.reload();
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPESetPatItem');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	if (Row==CurRow)
	{
		CurRow=0
		setData(CurRow);
	}
	else
	{
		CurRow=Row;
		setData(CurRow);
		var ParRefID="";
		var obj=document.getElementById("RowID");
		if (obj) ParRefID=obj.value;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPatItemList"
			+"&PatItemName="+ParRefID;
		if (parent.frames['list']){
			parent.frames['list'].location.href=lnk;
		}
	}
}
function setData(CurRow)
{
	SetOneData(CurRow,"TID","RowID","Hidden");
	SetOneData(CurRow,"TName","Name","");
	SetOneData(CurRow,"TSort","Sort","");
	SetOneData(CurRow,"TPlace","Place","");
	SetOneData(CurRow,"TAutoChange","AutoChange","");
	SetOneData(CurRow,"TIFDocSign","IFDocSign","");
	SetOneData(CurRow,"TPatSignName","PatSignName","");
	
}
function SetOneData(CurRow,TName,Name,Type)
{
	if (CurRow==0)
	{
		var obj=document.getElementById(Name);
		if (obj)
		{
			if (obj.type=="checkbox")
			{
				obj.checked=false;
				return;
			}
			obj.value="";
			return;
		}
	}
	var Tobj=document.getElementById(TName+"z"+CurRow)
	if (Tobj)
	{
		var obj=document.getElementById(Name);
		if (obj)
		{
			if (obj.type=="checkbox")
			{
				obj.checked=Tobj.checked;
				return;
			}
			if (Type=="Hidden")
			{
				obj.value=Tobj.value;
			}
			else
			{
				obj.value=Tobj.innerText;
			}
		}
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