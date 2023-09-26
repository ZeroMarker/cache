var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitPage();
	InitUserInfo();
}


function InitPage()
{
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
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
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
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",GetElementValue("TRowIDz"+SelectedRow));
		SetElement("FromYearsNum",GetCElementValue("TFromYearsNumz"+SelectedRow));
		SetElement("ToYearsNum",GetCElementValue("TToYearsNumz"+SelectedRow));
		SetElement("ChangeDate",GetCElementValue("TChangeDatez"+SelectedRow));
		SetElement("ChangeReason",trim(GetCElementValue("TChangeReasonz"+SelectedRow)));
		SetElement("Remark",trim(GetCElementValue("TRemarkz"+SelectedRow)));
		SetElement("AddUserDR",GetCElementValue("TAddUserDRz"+SelectedRow));
		SetElement("AddDate",GetCElementValue("TAddDatez"+SelectedRow));
		SetElement("AddTime",GetCElementValue("TAddTimez"+SelectedRow));
		SetElement("UpdateUserDR",GetCElementValue("TUpdateUserDRz"+SelectedRow));
		SetElement("UpdateDate",GetCElementValue("TUpdateDatez"+SelectedRow));
		SetElement("UpdateTime",GetCElementValue("TUpdateTimez"+SelectedRow));
		InitButton(true);
		
		if (GetCElementValue("TStatusz"+SelectedRow)=="ÉóºË")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
			DisableBElement("BAudit",true);
		}
		if (GetCElementValue("TStatusz"+SelectedRow)=="Ìá½»")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
		}
		}
	
		
}
function Clear()
{
	SetElement("RowID","");
	SetElement("FromYearsNum","");
	//SetElement("EquipDR","");
	SetElement("ToYearsNum","");
	SetElement("ChangeDate","");
	SetElement("ChangeReason","");
	SetElement("Remark","");
	SetElement("AddUserDR","");
	SetElement("AddDate","");
	SetElement("AddTime","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
}

function BClose_Click()
{
	parent.close();
}
function BAudit_Click()
{
	var val=CombinData();
	UpdateChangeYears(val,"2");
}

function BAdd_Click() 
{
	if (CheckNull()) return;
	var val=CombinData();
	UpdateChangeYears(val,"0");
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	var val=CombinData();
	UpdateChangeYears(val,"4");
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t[-4002]);
		return;
	}
	var truthBeTold = window.confirm(t["02"]);
    if (!truthBeTold) return;
    UpdateChangeYears("","3");

}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("FromYearsNum") ;
  	combindata=combindata+"^"+GetElementValue("ToYearsNum") ;
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
  	combindata=combindata+"^"+GetElementValue("ChangeTypeDR") ;
  	/*combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;*/
  	return combindata;
}

function UpdateChangeYears(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var RowID=GetElementValue("RowID");
	var EquipDR=GetElementValue("EquipDR");
	var Guser=curUserID;
	var result=cspRunServerMethod(encmeth,'','',val,AppType,RowID,EquipDR,Guser);
	if (result>0)
	{	location.reload();	}
	else
	{	alertShow(t["01"]);}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"ChangeDate")) return true;
	if (CheckItemNull(2,"ToYearsNum")) return true;
	*/
	return false;
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQChangeYears');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	Selected(selectrow);
}

document.body.onload = BodyLoadHandler;
