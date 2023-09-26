
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
  	combindata=combindata+"^"+GetElementValue("ChangeTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+GetElementValue("ChangeDate") ;
  	combindata=combindata+"^"+GetElementValue("MainID") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("AuditFlag") ;
  	combindata=combindata+"^"+GetElementValue("ChangeDesc") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
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
	var result=cspRunServerMethod(encmeth,'','',rowid,Guser);
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
	var sort=19
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("GroupDR",list[1]);
	SetElement("Group",list[sort+1]);
	SetElement("ChangeTypeDR",list[2]);
	SetElement("ChangeType",list[sort+2]);
	SetElement("ChangeReason",list[3]);
	SetElement("ChangeDate",list[4]);
	SetElement("MainID",list[5]);
	SetElement("Remark",list[6]);
	SetChkElement("AuditFlag",list[7]);
	SetElement("ChangeDesc",list[8]);
	SetChkElement("InvalidFlag",list[9]);
	SetElement("AddUserDR",list[10]);
	SetElement("AddUser",list[sort+3]);
	SetElement("AddDate",list[11]);
	SetElement("AddTime",list[12]);
	SetElement("UpdateUserDR",list[13]);
	SetElement("UpdateUser",list[sort+4]);
	SetElement("UpdateDate",list[14]);
	SetElement("UpdateTime",list[15]);
	SetElement("AuditUserDR",list[16]);
	SetElement("AuditUser",list[sort+5]);
	SetElement("AuditDate",list[17]);
	SetElement("AuditTime",list[18]);
	if (list[7]==1)
	{ SetDisableButton(2,false)}
	else
	{ SetDisableButton(0,false)}
}

function InitStandardKeyUp()
{
	KeyUp("Equip^Group^ChangeType^AddUser^UpdateUser^AuditUser","N");
	Muilt_LookUp("Equip^Group^ChangeType^AddUser^UpdateUser^AuditUser");
	return;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Group");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ChangeType");
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
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("Group","");
	SetElement("GroupDR","");
	//SetElement("ChangeType","");
	//SetElement("ChangeTypeDR","");
	SetElement("ChangeReason","");
	SetElement("ChangeDate","");
	SetElement("MainID","");
	SetElement("Remark","");
	SetChkElement("AuditFlag",0);
	SetElement("ChangeDesc","");
	SetChkElement("InvalidFlag",0);
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
}

function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"ChangeDate")) return false;
	return false;
}