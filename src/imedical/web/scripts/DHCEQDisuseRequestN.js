function BodyLoadHandler() 
{
	InitStyle("EquipType","5");
	InitUserInfo();
	InitPage();
	FillData();
	KeyUp("RequestLoc^Loc^DisuseType");	//���ѡ��
	Muilt_LookUp("RequestLoc^Loc^DisuseType"); //�س�ѡ��
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
}


/// ����
function BUpdate_Clicked()
{
	if (CheckNull()) return
	var plist=CombinData();
	var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==1)
	{
    	if (GetElementValue("RowIDs")=="")
    	{
		    alertShow("�豸��ϸ����Ϊ��!")
		    return
		}
	}
    var Return=UpdateDisuseRequest(plist,"0");
    if (Return>0)
    {
	    window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&Type=0&RowID="+Return+"&RowIDs="+GetElementValue("RowIDs");
	}
    else
    {
	    alertShow(t[-1001]);
    }
}

/// ɾ��
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-1002"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateDisuseRequest(RowID,"3");
	if (Return>0)
    {
	    var val="&RequestLocDR="+GetElementValue("RequestLocDR")
	    val=val+"&RequestLoc="+GetElementValue("RequestLoc");
	    val=val+"&RequestDate="+GetElementValue("RequestDate");
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&Type=0'+val
	}
    else
    {
	    alertShow(t[-1001]);
    }
}
///�ύ
function BSubmit_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var Return=UpdateDisuseRequest(RowID,"1");
	if (Return>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&Type=1&RowID='+Return
    }
    else
    {
	    alertShow(t[-1001]);
    }
}
/// ȡ���ύ
function BCancelSubmit_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var RejectReason=GetElementValue("RejectReason")
	if (RejectReason=="")
	{
		alertShow(t[-1003])
		return
	}
	var combindata="";
  	combindata=GetElementValue("RowID") ;
    combindata=combindata+"^"+GetElementValue("RejectReason") ;
	var Return=UpdateDisuseRequest(combindata,"2");
    if (Return>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t[-1001]);;
    }
}
/// ���
function BAudit_Clicked()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var combindata=RowID+"^"+GetOpinion();
		var Return=UpdateDisuseRequest(combindata,"5");
	}
	if (Type=="2")
	{
		var combindata=RowID+"^Y";
		var Return=UpdateDisuseRequest(combindata,"4");
	}
    if (Return==0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t[-1001]);
    }
}


function UpdateDisuseRequest(ValueList,AppType)
{
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,"","",ValueList,AppType);
	return ReturnValue;
}


function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=""
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+""; //GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("UseState") ;
  	combindata=combindata+"^"+GetElementValue("DisuseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+""; //GetElementValue("DisureDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	//begin 11 to 33
  	for (var j=11;j<34;j++)
	{
		combindata=combindata+"^"
	}
    combindata=combindata+"^"+GetElementValue("RequestNo") ;//
    combindata=combindata+"^"+GetElementValue("LocDR") ;//
    combindata=combindata+"^"+GetElementValue("TotleTime") ;//
    combindata=combindata+"^"+GetElementValue("Income") ;//
    combindata=combindata+"^"+GetElementValue("CheckResult") ;//
    combindata=combindata+"^"+GetElementValue("TechnicEvaluate") ;//
    combindata=combindata+"^"+GetElementValue("RepairHours") ;//
    combindata=combindata+"^"+GetElementValue("RepairFee") ;//
    combindata=combindata+"^"+GetElementValue("RepairTimes") ;//
    combindata=combindata+"^"+GetElementValue("LimitYears") ;//
    combindata=combindata+"^"+GetElementValue("KindFlag") ;//
    combindata=combindata+"^"+GetElementValue("InStockListDR") ;//
    combindata=combindata+"^"+GetElementValue("RejectReason") ;//
    combindata=combindata+"^"+GetElementValue("RowIDs") ;//
    combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//
  	return combindata;
}
function GetEquipID(value)
{
	Clear()
	var val=value.split("^");
	SetElement("EquipDR", val[0]);
	SetElement("Equip", val[1]);
	SetElement("LocDR",val[2]);
	SetElement("Loc",val[3]);
	SetElement("InStockListDR", val[4]);
	SetElement("InStockList", val[5]);
	SetElement("Model", val[7]);
	SetElement("ModelDR", val[8]);
	SetElement("EquipCat", val[9]);
	SetElement("EquipCatDR", val[10]);
	SetElement("ManuFactory", val[11]);
	SetElement("ManuFactoryDR", val[12]);
	SetElement("Provider", val[13]);
	SetElement("ProviderDR", val[14]);
	SetElement("InDate", val[15]);
	SetElement("EquipType",val[16]);
	SetElement("EquipTypeDR",val[17]);
	SetElement("LimitYears",val[18]);
	SetElement("No",val[19]);
	SetElement("LeaveFactoryNo",val[20]);
	var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==0) SetElement("Amount","1");
	SetElement("RowIDs", "");
}

function Clear()
{
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("LocDR","");
	SetElement("Loc","");
	SetElement("InStockList","");
	SetElement("InStockListDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("ManuFactory","");
	SetElement("ManuFactoryDR","");
	SetElement("Provider","");
	SetElement("ProviderDR","");
	SetElement("InDate","");
	SetElement("LeaveFactoryNo","");
	SetElement("No","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("LimitYears","");
	SetElement("Amount","");
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	if (Status=="") //���������ťǰ
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="0") //����
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="1") //�ύ
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status=="2") //���
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Type!="0")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		var NextStep=GetElementValue("NextFlowStep");
		if (Type=="1")
		{
			var RoleStep=GetElementValue("RoleStep");
			if (RoleStep!=NextStep)
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
		if (Type=="2")
		{
			if (NextStep!="")
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
	}
	else
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
}

function FillData()
{
	return;
	var RowID=document.getElementById("RowID");
	var RowID=RowID.value;
	var EquipDR=document.getElementById("EquipDR");
	var EquipDR=EquipDR.value;
	if (RowID!="")
	{
		var sort=49
		if (RowID<1)	return;
		var obj=document.getElementById("fillData");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",RowID);		
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		SetElement("RowID", list[sort+16]);
		if (list[0]!="")
		{
			SetElement("EquipDR", list[0]);		
		}else
		{
			SetElement("EquipDR", list[44]);
		}
		SetElement("RequestLoc", list[sort+2]);
		SetElement("RequestLocDR", list[2]);
		SetElement("RequestDate", list[3]);
		SetElement("UseState", list[4]);
		SetElement("DisuseType", list[sort+3]);
		SetElement("DisuseTypeDR", list[5]);
		SetElement("ChangeReason", list[6]);
		SetElement("DisureDate", list[7]);
		SetElement("Remark", list[8]);
		SetElement("Status", list[9]);
		//SetElement("AddUserDR", list[10]);
		//SetElement("AddUser", list[sort+6]);
		//SetElement("AddDate", list[11]);
		//SetElement("AddTime", list[12]);
		//SetElement("UpdateUserDR", list[13]);
		//SetElement("UpdateUser", list[sort+8]);
		//SetElement("UpdateDate", list[14]);
		//SetElement("UpdateTime", list[15]);
		//SetElement("SubmitUserDR", list[16]);
		//SetElement("SubmitUser", list[sort+10]);
		//SetElement("SubmitDate", list[17]);
		//SetElement("SubmitTime", list[18]);
		//SetElement("AuditUserDR", list[19]);
		//SetElement("AuditUserDR", list[sort+12]);
		//SetElement("AuditDate", list[20]);
		//SetElement("AuditTime", list[21]);
		SetElement("RejectReason", list[22]);
		//SetElement("RejectUserDR", list[23]);
		//SetElement("RejectUser", list[sort+14]);
		//SetElement("RejectDate", list[24]);
		//SetElement("RejectTime", list[25]);
		SetElement("ApproveSetDR", list[26]);
		SetElement("NextRoleDR", list[27]);
		SetElement("NextFlowStep", list[28]);
		SetElement("ApproveStatu", list[29]);
		SetElement("ApproveRoleDR", list[30]);
		//SetElement("Hold1", list[sort+21]);
		SetElement("RequestNo", list[32]);
		SetElement("Loc", list[sort+13]);
		SetElement("LocDR", list[33]);
		SetElement("TotleTime", list[34]);
		SetElement("Income", list[35]);
		SetElement("CheckResult", list[36]);
		SetElement("TechnicEvaluate", list[37]);
		SetElement("RepairHours", list[38]);
		SetElement("RepairFee", list[39]);
		SetElement("RepairTimes", list[40]);
		SetElement("LimitYears", list[41]);
		SetElement("EquipType", list[sort+15]);
		SetElement("EquipTypeDR", list[42]);
		SetElement("KindFlag", list[43]);
		SetElement("InStockList", list[sort+14]);	
		SetElement("InStockListDR", list[44]);	
		SetElement("Equip", list[sort+17]);
		SetElement("Model", list[sort+18]);
		SetElement("ModelDR", list[sort+19]);
		SetElement("EquipCat", list[sort+20]);
		SetElement("EquipCatDR", list[sort+21]);
		SetElement("ManuFactory", list[sort+22]);
		SetElement("ManuFactoryDR", list[sort+23]);
		SetElement("Provider", list[sort+24]);
		SetElement("ProviderDR", list[sort+25]);
		SetElement("InDate", list[sort+26]);
		SetElement("RowIDs", list[sort+27]);
		SetElement("No", list[sort+28]);
		SetElement("LeaveFactoryNo", list[sort+29]);
	}
	else if (EquipDR!="")
	{
		var sort=80
		if (EquipDR<1)	return;
		var obj=document.getElementById("GetEquipInfo");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",EquipDR);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		SetElement("RowID", "");
		SetElement("Equip", list[0]);
		SetElement("No",list[70]);
		SetElement("Status", "");
		SetElement("Loc", list[sort+26]);
		SetElement("LocDR", list[66]);
		SetElement("LimitYears", list[30]);
		SetElement("EquipType", list[sort+22]);
		SetElement("EquipTypeDR", list[62]);
		SetElement("InStockList", list[sort+28]);	
		SetElement("InStockListDR", list[69]);
		SetElement("Model", list[sort+0]);
		SetElement("ModelDR", list[2]);
		SetElement("EquipCat", list[sort+1]);
		SetElement("EquipCatDR", list[3]);
		SetElement("ManuFactory", list[sort+13]);
		SetElement("ManuFactoryDR", list[25]);
		SetElement("Provider", list[sort+12]);
		SetElement("ProviderDR", list[24]);
		if (list[69]=="")
		{
			SetElement("InDate", list[sort+32]);
		}
		else
		{
			SetElement("InDate", list[sort+32]);
		}		
		SetElement("No", list[70]);
		SetElement("LeaveFactoryNo", list[9]);
		SetElement("Amount", 1);
	}
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}

function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}

function GetRequestLocID(value)
{
	GetLookUpID('RequestLocDR',value);
}

function GetDisuseTypeID(value)
{
	GetLookUpID('DisuseTypeDR',value);
}

function GetInStockListID(value)
{
	GetLookUpID('InStockListDR',value);
}
document.body.onload = BodyLoadHandler;

