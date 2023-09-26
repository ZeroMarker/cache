var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
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
  	combindata=combindata+"^"+GetElementValue("FromLoc") ;
  	combindata=combindata+"^"+GetElementValue("ToDeptDR") ;
  	combindata=combindata+"^"+GetElementValue("OutFee") ;
  	combindata=combindata+"^"+GetElementValue("PayModeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+GetElementValue("ChangeDate") ;
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
	var sort=19
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("GroupDR",list[1]);
	SetElement("Group",list[sort+1]);
	SetElement("FromLoc",list[2]);
	SetElement("ToDeptDR",list[3]);
	SetElement("ToDept",list[sort+2]);
	SetElement("OutFee",list[4]);
	SetElement("PayModeDR",list[5]);
	SetElement("PayMode",list[sort+3]);
	SetElement("ChangeReason",list[6]);
	SetElement("ChangeDate",list[7]);
	SetElement("Remark",list[8]);
	SetElement("Status",list[9]);
	SetElement("AddUserDR",list[10]);
	SetElement("AddUser",list[sort+4]);
	SetElement("AddDate",list[11]);
	SetElement("AddTime",list[12]);
	SetElement("UpdateUserDR",list[13]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[14]);
	SetElement("UpdateTime",list[15]);
	SetElement("AuditUserDR",list[16]);
	SetElement("AuditUser",list[sort+6]);
	SetElement("AuditDate",list[17]);
	SetElement("AuditTime",list[18]);
	SetDisableButton(list[9],false);
}

function InitStandardKeyUp()
{
	KeyUp("Equip^Group^ToDept^PayMode","N");
	Muilt_LookUp("Equip^Group^ToDept^PayMode");
	return;
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("Group");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("ToDept");
	if (obj) obj.onkeyup=Standard_KeyUp;
	var obj=document.getElementById("PayMode");
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
	//SetElement("EquipDR","");
	SetElement("Group","");
	SetElement("GroupDR","");
	SetElement("FromLoc","");
	SetElement("ToDept","");
	SetElement("ToDeptDR","");
	SetElement("OutFee","");
	SetElement("PayMode","");
	SetElement("PayModeDR","");
	SetElement("ChangeReason","");
	SetElement("ChangeDate","");
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
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQMoveOut');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}

function GetPayModeID(value)
{
	GetLookUpID('PayModeDR',value);
}

function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(0,"ChangeDate")) return false;
	if (CheckItemNull(1,"ToDept")) return false;
	*/
	return false;
}

document.body.onload = BodyLoadHandler;
