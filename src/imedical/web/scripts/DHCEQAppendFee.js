var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	InitStandardKeyUp();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	InitButton(false);
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;		
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableElement("AppendFee",isselected)
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
		}
}

function BAdd_Click() 
{
	SaveData();	
}

function BUpdate_Click() 
{
	SaveData();
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t['03']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,'1');
	if (result>0)
	{	location.reload();	}
}

function BClose_Click() 
{
	window.close();
}

function GetAppendFeeTypeID(value)
{
	GetLookUpID('AppendFeeTypeDR',value);
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("AppendFeeTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("AppendFee") ;
  	combindata=combindata+"^"+GetElementValue("OccDate") ;
  	combindata=combindata+"^"+GetElementValue("PayUserDR") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("CurrencyDR") ;
  	return combindata;
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
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,Guser,'0');
	if (result>0)
	{	location.reload();	}
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	var sort=16
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("AppendFeeTypeDR",list[1]);
	SetElement("AppendFeeType",list[sort+1]);
	SetElement("AppendFee",list[2]);
	SetElement("OccDate",list[3]);
	SetElement("PayUserDR",list[4]);
	SetElement("PayUser",list[sort+2]);
	SetElement("InvoiceNo",list[5]);
	SetElement("InvoiceDate",list[6]);
	SetElement("Remark",list[7]);
	SetElement("AddUserDR",list[8]);
	SetElement("AddUser",list[sort+3]);
	SetElement("AddDate",list[9]);
	SetElement("AddTime",list[10]);
	SetElement("UpdateUserDR",list[11]);
	SetElement("UpdateUser",list[sort+4]);
	SetElement("UpdateDate",list[12]);
	SetElement("UpdateTime",list[13]);
	SetElement("CurrencyDR",list[14]);
	SetElement("Currency",list[sort+5]);
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQAppendFee');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

//alertShow(selectrow+"/"+rows)

	if (!selectrow) return;
	Selected(selectrow);
}

function InitStandardKeyUp()
{
	KeyUp("Equip^AppendFeeType^PayUser^AddUser^UpdateUser^Currency","N");
	Muilt_LookUp("Equip^AppendFeeType^PayUser^AddUser^UpdateUser^Currency");
	return;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AppendFeeType");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("PayUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Currency");
	if (obj) obj.onkeyup=Standard_KeyUp;
}

function Clear()
{
	SetElement("RowID","");
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("AppendFeeType","");
	SetElement("AppendFeeTypeDR","");
	SetElement("AppendFee","");
	SetElement("OccDate","");
	SetElement("PayUser","");
	SetElement("PayUserDR","");
	SetElement("InvoiceNo","");
	SetElement("InvoiceDate","");
	SetElement("Remark","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("Currency","");
	SetElement("CurrencyDR","");
}


document.body.onload = BodyLoadHandler;
