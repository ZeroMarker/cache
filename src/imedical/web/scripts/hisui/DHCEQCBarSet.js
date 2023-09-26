/// Mozy	2019-7-1	DHCEQCBarSet.js	条码权限配置
var SelectedRow = -1;
var rowid=0;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	InitButton(true);
	initButtonWidth();
	
	KeyUp("Hospital^EquipType","N");
	Muilt_LookUp("Hospital^EquipType");
}
function InitButton(isselected)
{
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	
	//DisableBElement("BSave",isselected);
	DisableBElement("BDelete",isselected);
}
function BSave_Clicked()
{
	if (CheckNull()) return;
  	var combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("BarInfoDR");
  	combindata=combindata+"^"+GetElementValue("HospitalDR");
	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
	
  	var encmeth=GetElementValue("UpdateBarSet");
  	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,combindata, 0);
	//alertShow(result)
    if (result>0)
	{
		ShowMessage();
		location.reload();
	}
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm("您确认要删除该记录吗?");
	if (!truthBeTold) return;
  	var encmeth=GetElementValue("UpdateBarSet")
  	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,GetElementValue("RowID"), 1);
	if (result>0)
    {
		ShowMessage();
		location.reload();
	}
}
function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)
	{
		Clear();
		SelectedRow= -1;
		InitButton(true);
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		if (rowdata.TRowID=="") return;
		SetData(rowdata.TRowID);
		InitButton(false);
		SetElement("RowID",rowdata.TRowID);
	}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	var sort=9;
	SetElement("HospitalDR",list[1]);
	SetElement("Hospital",list[sort+1]);
	SetElement("EquipTypeDR",list[2]);
	SetElement("EquipType",list[sort+2]);
}
function Clear()
{
	SetElement("RowID","");
	SetElement("HospitalDR","");
	SetElement("Hospital","");
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
}
function GetEquipType(value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetHospitalDR(value)
{
    GetLookUpID("HospitalDR",value);
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}