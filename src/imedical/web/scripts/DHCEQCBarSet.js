/// Mozy	2019-7-1	DHCEQCBarSet.js	条码权限配置
var SelectedRow = 0;
var rowid=0;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	InitButton(true);
	
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
		alertShow("操作成功!");
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
		alertShow("操作成功!")
		location.reload();
	}
    else
    {
	    alertShow(result+"   操作失败!");
    }
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCBarSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}
function Selected(selectrow)
{
	if (SelectedRow==selectrow)
	{
		Clear();
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(true);
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		if (rowid=="") return;
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(false);
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