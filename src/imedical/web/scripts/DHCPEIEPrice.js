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
		alert("û��ҽ����Ŀ");
		return false;
	}
	var obj=document.getElementById("RowID");
	if (obj) ID=obj.value;
	var obj=document.getElementById("Price");
	if (obj) Price=Trim(obj.value);
	if (Price=="")
	{
		alert("�۸���Ϊ��");
		return false;
	}
	var obj=document.getElementById("BeginDate");
	if (obj) BeginDate=Trim(obj.value);
	if (BeginDate=="")
	{
		alert("��ʼ���ڲ���Ϊ��");
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
		alert("û�и��·���");
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
	var eSrc = window.event.srcElement;	//�����¼���
	var objtbl=document.getElementById('tDHCPEIEPrice');	//ȡ���Ԫ��?����
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
//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

document.body.onload = BodyIni;