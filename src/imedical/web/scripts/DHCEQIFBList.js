/// DHCEQIFBList.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;

function BodyLoadHandler()
{
	InitPage();
	InitUserInfo();
	InitButton(false);
	document.body.onunload = BodyUnloadHandler;
}
function InitPage()
{
	KeyUp("Vendor^ManuFactory");
	Muilt_LookUp("Vendor^ManuFactory");
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=Clear;
	
	//alertShow(GetElementValue("ReadOnly"))
	var ReadOnly=GetElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);		
		return;
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
}

function BAdd_Click()
{
	if (CheckSaveData()) return;
	if (GetElementValue("IFBBagDR")=="")
	{
		alertShow("招标包为空,不能添加供应商.");
		return true;
	}
	SaveData(0);
}

function BUpdate_Click() 
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
    SaveData(1);
}

function BClose_Click()
{
	window.close();
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	//+组件名 就是你的组件显示 Query 结果的部分
	var objtbl =document.getElementById('tDHCEQIFBList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();	
		InitButton(false);
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);
		InitButton(true);
	}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var sort=18
	var list=gbldata.split("^");
	//alertShow(list[8]);
	SetElement("RowID",list[0]); //rowid
	SetElement("IFBBagDR",list[1]);
	//SetElement("VendorDR",list[2]);
	SetElement("VendorDR",list[2]);
	SetElement("Vendor",list[sort+2]);
	SetElement("ManuFactoryDR",list[3]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("ModelDR",list[4]);
	SetElement("Model",list[sort+4]);
	SetElement("Arg",list[5]);
	SetElement("Price",list[6]);
	SetElement("Amount",list[7]);
	SetChkElement("WinFlag",list[8])
	SetElement("WinQty",list[9]);
	SetElement("Candidacy",list[10]);
	SetElement("CandidacySeq",list[11]);
	SetElement("Score",list[12]);
	SetElement("Remark",list[13]);
	SetElement("Hold1",list[14]);
	SetElement("Hold2",list[15]);
	SetElement("Hold3",list[16]);
	SetElement("Hold4",list[17]);
	SetElement("Hold5",list[18]);
}
function SaveData(isDel)
{
	var encmeth=GetElementValue("GetUpdate");
	var plist=CombinData();	
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	//alertShow(plist)
	var result=cspRunServerMethod(encmeth,plist,isDel);
	if (result!=-1)
	{	location.reload();	}
	else
	{	alertShow(t[-1]);	}
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("IFBBagDR");
	combindata=combindata+"^"+GetElementValue("VendorDR");
	combindata=combindata+"^"+GetElementValue("ManuFactoryDR");
	combindata=combindata+"^"+GetElementValue("ModelDR");
	combindata=combindata+"^"+GetElementValue("Arg");
	combindata=combindata+"^"+GetElementValue("Price");
	combindata=combindata+"^"	//+GetElementValue("Amount");
	var Price=GetElementValue("Price");
	var WinQty=GetElementValue("WinQty");
	if ((Price>0)&&(WinQty>0))
	{
		combindata=combindata+Price*WinQty;
	}
	combindata=combindata+"^"+GetChkElementValue("WinFlag");
	combindata=combindata+"^"+GetElementValue("WinQty");
	combindata=combindata+"^"+GetElementValue("Candidacy");
	combindata=combindata+"^"+GetElementValue("CandidacySeq");
	combindata=combindata+"^"+GetElementValue("Score");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}
function GetManuFactoryDR(value)
{
	var list=value.split("^")
	SetElement("ManuFactory",list[0]);
	SetElement("ManuFactoryDR",list[1]);
}
function GetModelDR(value)
{
	var list=value.split("^")
	SetElement("Model",list[0]);
	SetElement("ModelDR",list[1]);
}
function GetVendorDR(value)
{
	var list=value.split("^")
	SetElement("Vendor",list[0]);
	SetElement("VendorDR",list[1]);
}
function Clear()
{
	SetElement("RowID",""); //rowid
	SetElement("VendorDR","");
	SetElement("Vendor","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("Arg","");
	SetElement("Price","");
	SetElement("Amount","");
	SetChkElement("WinFlag",0);
	SetElement("WinQty","");
	SetChkElement("Candidacy",0);
	SetElement("CandidacySeq","");
	SetElement("Score","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	
	//if (GetElementValue("Code")=="") return true;
	//if (GetElementValue("Desc")=="") return true;
	
	return false;
}
function BodyUnloadHandler()
{
	//alertShow("BodyUnloadHandler")
	//KeyUp("Vendor^ManuFactory");
	//Muilt_LookUp("Vendor^ManuFactory");
}
document.body.onload = BodyLoadHandler;