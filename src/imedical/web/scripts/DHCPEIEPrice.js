var CurRow=0
function BodyIni()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Save_Click;
	FillARCInfo();
}
function FillARCInfo()
{
	var obj;
	obj=document.getElementById("ParRef");
	if (obj) var ParRef=obj.value;
	var obj=document.getElementById("GetARCDesc");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,ParRef);
	var InfoArr=Info.split("^");
	var obj=document.getElementById("ARCDesc");
	if (obj) obj.value=InfoArr[0];
	var obj=document.getElementById("ARCPrice");
	if (obj) obj.value=InfoArr[1];
}
function Save_Click()
{
	var Strings="",ID="",Price="",BeginDate="",EndDate="",SetsFlag="N"
	var ParRef=""
	var obj=document.getElementById("ParRef");
	if (obj) ParRef=obj.value;
	if (ParRef=="")
	{
		alert("没有医嘱项目");
		return false;
	}
	var obj=document.getElementById("RowID");
	if (obj) ID=obj.value;
	var obj=document.getElementById("Price");
	if (obj) Price=Trim(obj.value);
	if (Price=="")
	{
		alert("价格不能为空");
		return false;
	}
	var obj=document.getElementById("BeginDate");
	if (obj) BeginDate=Trim(obj.value);
	if (BeginDate=="")
	{
		alert("开始日期不能为空");
		return false;
	}
	
	var obj=document.getElementById("EndDate");
	if (obj) EndDate=Trim(obj.value);
	var obj=document.getElementById("SetsFlag");
	//if (obj) SetsFlag=obj.value;
	Strings=ParRef+"^"+Price+"^"+BeginDate+"^"+EndDate+"^"+SetsFlag;
	var encmeth="";
	var obj=document.getElementById("UpdateClass");
	if (obj)
	{
		encmeth=obj.value;
	}
	if (encmeth=="")
	{
		alert("没有更新方法");
		return;
	}
	var Flag=cspRunServerMethod(encmeth,ID,Strings);
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
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEIEPrice');	//取表格元素?名称
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
	FillData(CurRow);
}
function FillData(CurRow)
{
	var obj;
	
	if (CurRow==0)
	{
		var DataStr="^^^^"
	}
	else
	{
		obj=document.getElementById("TRowIDz"+CurRow);
		if (obj) var RowID=obj.value;
		obj=document.getElementById("GetOneInfoClass");
		if (obj) var encmeth=obj.value;
		var DataStr=cspRunServerMethod(encmeth,RowID,"P");
	}
	var StrArr=DataStr.split("^");
	obj=document.getElementById("RowID");
	if (obj) obj.value=RowID;
	obj=document.getElementById("Price");
	if (obj) obj.value=StrArr[0];
	obj=document.getElementById("BeginDate");
	if (obj) obj.value=StrArr[1];
	obj=document.getElementById("EndDate");
	if (obj) obj.value=StrArr[2];
	obj=document.getElementById("SetsFlag");
	if (obj) obj.value=StrArr[3];
}
//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

document.body.onload = BodyIni;