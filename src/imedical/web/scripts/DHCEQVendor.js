/// -----------------------------------------
/// 修改人:JDL 2009-06-23
/// 修改目的:解决JDL0018,增加供应商分类的处理?
/// 修改内容:修改方法Clear,SaveData,SetData
/// 		 增加方法:GetVendCatID
/// -----------------------------------------

var SelectedRow = 0;
var rowid=0;
var name="";
var code="";

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitButton(false);
	KeyUp("VendCat","N");
}

function InitButton(isselected)
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		}
}


function BUpdate_Click() 
{
	SaveData();
}

function SaveData()
{
	if (CheckMustItemNull()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	rowid=GetElementValue("RowID")
	code=GetElementValue("Code")
	name=GetElementValue("Name")
	cat=GetElementValue("VendCatDR");
	var result=cspRunServerMethod(encmeth,rowid,code,name,cat);
	///alertShow(result);
	var list=result.split("^");
	if (list[0]=="0")
	{
		alertShow(t['success']);
		SetElement("RowID","");	
		location.reload();	
	}
	else
	{
		alertShow(t['failed']+":"+list[2]);
	}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetOneData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	//alertShow(gbldata);
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("Name",list[2]);
	SetElement("Code",list[1]);
	SetElement("VendCatDR",list[3]);
	SetElement("VendCat",list[4]);	
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQVendor');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Name","");
	SetElement("Code","");
	SetElement("ShName","");
	SetElement("VendCatDR","");
	SetElement("VendCat","");
}

function GetVendCatID(value)
{
	GetLookUpID('VendCatDR',value);
}

document.body.onload = BodyLoadHandler;
