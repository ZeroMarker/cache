var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
	SetEquipInfo();
}


function InitPage()
{
	InitUserInfo();	
	InitStandardKeyUp();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
	}
	InitButton(false);	
}

function InitButton(isselected)
{
	if (1==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	DisableBElement("BAudit",!isselected);
}

function Selected(selectrow)
{
	var isselected;
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
		InitButton(true);
		SetData(rowid);
		
		}
	
}



function BAudit_Click()
{
	AuditData();
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
		alertShow(t[-4002]);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,'1');
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	location.reload();	}
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("FromManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("FromUseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToUseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("FromInstallLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToInstallLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MoveDate") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	return combindata;
}

function AuditData()
{
	var encmeth=GetElementValue("GetAudit");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var rowid=GetElementValue("RowID");
	if (rowid=="") 
		{alertShow(t['04']);
		 retrun;	}
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser,GetElementValue("ChangeTypeDR"));
	if (result<0)
	{	alertShow(t[result]);}
	else
	{	location.reload();	}
}

function SaveData()
{
	if (CheckSaveData()) return;
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
	else
	{	alertShow(t[result]);}
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
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	var sort=21
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("GroupDR",list[1]);
	SetElement("Group",list[sort+1]);
	SetElement("FromManageLocDR",list[2]);
	SetElement("FromManageLoc",list[sort+2]);
	SetElement("FromUseLocDR",list[3]);
	SetElement("FromUseLoc",list[sort+3]);
	SetElement("ToManageLocDR",list[4]);
	SetElement("ToManageLoc",list[sort+4]);
	SetElement("ToUseLocDR",list[5]);
	SetElement("ToUseLoc",list[sort+5]);
	SetElement("FromInstallLocDR",list[6]);
	SetElement("FromInstallLoc",list[sort+6]);
	SetElement("ToInstallLocDR",list[7]);
	SetElement("ToInstallLoc",list[sort+7]);
	SetElement("MoveDate",list[8]);
	SetElement("ChangeReason",list[9]);
	SetElement("Remark",list[10]);
	SetElement("Status",list[11]);
	SetElement("AddUserDR",list[12]);
	SetElement("AddUser",list[sort+8]);
	SetElement("AddDate",list[13]);
	SetElement("AddTime",list[14]);
	SetElement("UpdateUserDR",list[15]);
	SetElement("UpdateUser",list[sort+9]);
	SetElement("UpdateDate",list[16]);
	SetElement("UpdateTime",list[17]);
	SetElement("AuditUserDR",list[18]);
	SetElement("AuditUser",list[sort+10]);
	SetElement("AuditDate",list[19]);
	SetElement("AuditTime",list[20]);
	SetElement("Status",list[sort+11]);
	SetDisableButton(list[11],false)
}

function InitStandardKeyUp()
{
	KeyUp("Equip^Group^FromManageLoc^FromUseLoc^ToManageLoc^ToUseLoc^FromInstallLoc^ToInstallLoc","N");
	Muilt_LookUp("Equip^Group^FromManageLoc^FromUseLoc^ToManageLoc^ToUseLoc^FromInstallLoc^ToInstallLoc");
	return;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Group");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("FromManageLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("FromUseLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ToManageLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ToUseLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("FromInstallLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ToInstallLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AddUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("UpdateUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("AuditUser");
	if (obj) obj.onkeyup=Standard_KeyUp;
}
function Clear()
{
	SetElement("RowID","");
	/*
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("Group","");
	SetElement("GroupDR","");
	
	SetElement("FromManageLoc","");
	SetElement("FromManageLocDR","");
	SetElement("FromUseLoc","");
	SetElement("FromUseLocDR","");
	*/
	SetElement("ToManageLoc","");
	SetElement("ToManageLocDR","");
	SetElement("ToUseLoc","");
	SetElement("ToUseLocDR","");
	/*
	SetElement("FromInstallLoc","");
	SetElement("FromInstallLocDR","");
	*/
	SetElement("ToInstallLoc","");
	SetElement("ToInstallLocDR","");
	SetElement("MoveDate","");
	SetElement("ChangeReason","");
	SetElement("Remark","");
	SetElement("Status","");
	SetElement("AddUser","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUser","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("AuditUser","");
	SetElement("AuditUserDR","");
	SetElement("AuditDate","");
	SetElement("AuditTime","");
	SetEquipInfo();
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMove');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

//alertShow(selectrow+"/"+rows)

	if (!selectrow) return;
	Selected(selectrow);
}

function SetEquipInfo()
{
	var equipid=GetElementValue("EquipDR");
	if (equipid=="") return;
	var encmeth=GetElementValue("GetEquip");
	if (encmeth=="")	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,'','',equipid);
	var list=gbldata.split("^");
	var sort=EquipGlobalLen;
	
	SetElement("FromInstallLocDR",list[7]);
	SetElement("FromInstallLoc",list[sort+3]);
	SetElement("InstallDate",list[8]);
	SetElement("FromManageLocDR",list[16]);
	SetElement("FromManageLoc",list[sort+5]);
	SetElement("FromUseLocDR",list[18]);
	SetElement("FromUseLoc",list[sort+7]);
	
	/*	
	SetElement("Name",list[0]);
	SetElement("ABCType",list[1]);
	SetElement("ModelDR",list[2]);
	SetElement("Model",list[sort+0]);
	SetElement("EquiCatDR",list[3]);
	SetElement("EquiCat",list[sort+1]);
	SetElement("UnitDR",list[4]);
	SetElement("Unit",list[sort+2]);
	SetElement("Code",list[5]);
	SetElement("Desc",list[6]);		
	SetElement("LeaveFactoryNo",list[9]);
	SetElement("LeaveFactoryDate",list[10]);
	SetElement("OpenCheckDate",list[11]);
	SetElement("CheckDate",list[12]);
	SetElement("MakeDate",list[13]);
	SetChkElement("ComputerFlag",list[14]);
	SetElement("CountryDR",list[15]);
	SetElement("Country",list[sort+4]);	
	SetElement("ManageLevelDR",list[17]);
	SetElement("ManageLevel",list[sort+6]);	
	SetElement("OriginDR",list[19]);
	SetElement("Origin",list[sort+8]);
	SetElement("FromDeptDR",list[20]);
	SetElement("FromDept",list[sort+9]);
	SetElement("ToDeptDR",list[21]);
	SetElement("ToDept",list[sort+10]);
	SetElement("BuyTypeDR",list[22]);
	SetElement("BuyType",list[sort+11]);
	SetElement("EquipTechLevelDR ",list[23]);
	SetElement("ProviderDR",list[24]);
	SetElement("Provider",list[sort+12]);
	SetElement("ManuFactoryDR",list[25]);
	SetElement("ManuFactory",list[sort+13]);
	SetElement("OriginalValueFee",list[26]);
	SetElement("NetValueFee",list[27]);
	SetElement("NetRemainValueFee",list[28]);
	SetElement("GroupDR",list[29]);
	SetElement("Group",list[sort+14]);
	SetElement("LimitYearsNum",list[30]);
	SetElement("ContractListDR",list[31]);
	SetElement("ContractList",list[sort+15]);
	SetElement("DepreMethodDR",list[32]);
	SetElement("DepreMethod",list[sort+16]);
	SetElement("Remark",list[33]);
	SetElement("DepreTotalFee",list[34]);
	SetElement("DesignWorkLoadNum",list[35]);
	SetElement("WorkLoadUnitDR",list[36]);
	SetElement("WorkLoadUnit",list[sort+17]);
	SetElement("Status",list[37]);
	SetElement("ManageUserDR",list[38]);
	SetElement("ManageUser",list[sort+18]);
	SetElement("MaintUserDR",list[39]);
	SetElement("MaintUser",list[sort+19]);
	SetElement("ContactUser",list[40]);
	SetElement("ContactMode",list[41]);
	SetElement("AppendFeeTotalFee",list[42]);
	SetElement("StartDate",list[43]);
	SetElement("TransAssetDate",list[44]);
	SetChkElement("GuaranteeFlag",list[45]);
	SetChkElement("InputFlag",list[46]);
	SetChkElement("TestFlag",list[47]);
	SetChkElement("MedicalFlag",list[48]);
	SetElement("GuaranteeStartDate",list[49]);
	SetElement("GuaranteeEndDate",list[50]);
	*/	
}

function GetToInstallocID(value)
{
	GetLookUpID('ToInstallLocDR',value);
}

function GetToManageLocID(value)
{
	GetLookUpID('ToManageLocDR',value);
}

function GetToUseLocID(value)
{
	GetLookUpID('ToUseLocDR',value);
}

function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"MoveDate")) return false;
	return false;
}

document.body.onload = BodyLoadHandler;
