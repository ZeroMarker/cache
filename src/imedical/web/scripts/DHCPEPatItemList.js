var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Save_Click;
	var obj=document.getElementById("ARCIMDesc")
	if (obj) obj.onchange=ARCIMDesc_change;
	
	//清屏
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }

}

function Clear_click()
{ 
  setData(0)

 //类别
  var obj=document.getElementById("PatItemName");
  if(obj){obj.value="";}
  
  //站点
  var obj=document.getElementById("StationID");
  if(obj){obj.value="";}

}

function ARCIMDesc_change()
{
	var obj=document.getElementById("ARCIMID")
	if (obj) obj.value="";
}
function ItemSelectAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("ARCIMID")
	if (obj) obj.value=Arr[4];
	var obj=document.getElementById("ARCIMDesc")
	if (obj) obj.value=Arr[1];
}

function Save_Click()
{
	var obj,PatItem="",ARCIMID="",Sort="",PrintFlag="Y",PrintName="";
	obj=document.getElementById("PatItemName");
	if (obj) PatItem=obj.value;
	if (PatItem==""){
		alert("类别不能为空");
		return false
	}
	obj=document.getElementById("ARCIMID");
	if (obj) ARCIMID=obj.value;
	if (ARCIMID==""){
		//alert("医嘱ID不能为空");
		alert("项目不能为空");
		return false
	}
	obj=document.getElementById("Sort");
	if (obj) Sort=obj.value;
	obj=document.getElementById("PrintFlag");
	if (obj&&!obj.checked) PrintFlag="N";
	obj=document.getElementById("PrintName");
	if (obj) PrintName=obj.value;
	var encmeth="";
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var Str=PatItem+"^"+Sort+"^"+PrintFlag+"^"+PrintName
	var ret=cspRunServerMethod(encmeth,ARCIMID,Str)
	obj=document.getElementById("OldPatItemName");
	if (obj) var OldPatItem=obj.value;
	obj=document.getElementById("StationID");
	if (obj) var StationID=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPatItemList"
			+"&PatItemName="+OldPatItem+"&StationID="+StationID;
	window.location.href=lnk;
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEPatItemList');	//取表格元素?名称
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
	}
}
function setData(CurRow)
{
	SetOneData(CurRow,"TARCIMID","ARCIMID","Hidden");
	SetOneData(CurRow,"TARCIMDesc","ARCIMDesc","");
	SetOneData(CurRow,"TPrintFlag","PrintFlag","");
	SetOneData(CurRow,"TSort","Sort","");
	SetOneData(CurRow,"TPrintName","PrintName","");
	
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