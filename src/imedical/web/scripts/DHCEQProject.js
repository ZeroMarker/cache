function BodyLoadHandler() 
{
	KeyUp("Provider","N");
	Muilt_LookUp("Provider","N")
	InitUserInfo();
	InitPage();	
	FillData();
	SetBEnable();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetDisplay()
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1))	return;
	var encmeth=GetElementValue("fillData");
	if (encmeth=="") return;
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=30
	SetElement("RowID",list[0]);
	SetElement("No",list[1]);
	SetElement("Name",list[2]);
	SetElement("ShortName",list[3]);
	SetElement("Content",list[4]);
	SetElement("Type",list[5]);
	SetElement("ProviderDR",list[6]);
	SetElement("TotalFee",list[7]);
	SetElement("StartDate",list[8]);
	SetElement("EndDate",list[9]);
	SetElement("StatusDR",list[10]);
	SetElement("Remark",list[11]);
	/*
	SetElement("AddUserDR",list[12]);
	SetElement("AddDate",list[13]);
	SetElement("AddTime",list[14]);
	SetElement("SubmitUserDR",list[15]);
	SetElement("SubmitDate",list[16]);
	SetElement("SubmitTime",list[17]);
	SetElement("AuditUserDR",list[18]);
	SetElement("AuditDate",list[19]);
	SetElement("AuditTime",list[20]);
	SetElement("CancelUserDR",list[21]);
	SetElement("CancelDate",list[22]);
	SetElement("CancelTime",list[23]);
	SetElement("InvalidFlag",list[24]);*/
	SetElement("Hold1",list[25]);
	SetElement("Hold2",list[26]);
	SetElement("Hold3",list[27]);
	SetElement("Hold4",list[28]);
	SetElement("Hold5",list[29]);
	
	SetElement("Provider",list[sort+0]);
	SetElement("Status",list[10]);
	SetElement("AddUser",list[sort+1]);
	SetElement("SubmitUser",list[sort+2]);
	SetElement("AuditUser",list[sort+3]);
	SetElement("CancelUser",list[sort+4]);
	
	SetElement("ApproveSetDR",list[sort+7]);
	SetElement("NextRoleDR",list[sort+8]);
	SetElement("NextFlowStep",list[sort+9]);
	SetElement("ApproveStatu",list[sort+10]);
	SetElement("ApproveRoleDR",list[sort+11]);
	SetElement("CancelFlag",list[sort+12]);
	SetElement("CancelToFlowDR",list[sort+13]);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	var Status=GetElementValue("Status");
	if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}
	else if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	else if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
	}
	else if (Status=="")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (WaitAD=="on")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	else
	{
		DisableBElement("BCancelSubmit",true);
	}
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
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("No") ;
	combindata=combindata+"^"+GetElementValue("Name") ;
	combindata=combindata+"^"+GetElementValue("ShortName") ;
	combindata=combindata+"^"+GetElementValue("Content") ;
	combindata=combindata+"^"+GetElementValue("Type") ;
	combindata=combindata+"^"+GetElementValue("ProviderDR") ;
	combindata=combindata+"^"+GetElementValue("TotalFee") ;
	combindata=combindata+"^"+GetElementValue("StartDate") ;
	combindata=combindata+"^"+GetElementValue("EndDate") ;
	combindata=combindata+"^"+GetElementValue("Status") ;
	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+GetElementValue("Hold1") ;
	combindata=combindata+"^"+GetElementValue("Hold2") ;
	combindata=combindata+"^"+GetElementValue("Hold3") ;
	combindata=combindata+"^"+GetElementValue("Hold4") ;
	combindata=combindata+"^"+GetElementValue("Hold5") ;

  	var encmeth=GetElementValue("upd")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQProject&RowID='+Rtn;
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
  	var encmeth=GetElementValue("del")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn=="0")
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQProject';
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("submit")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn>0)
    {
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQProject&RowID='+Rtn;
	}
    else
    {
	    alertShow(EQMsg("",t[Rtn]))
    }
}
function BCancelSubmit_Clicked()
{	
	var combindata=GetValueList();
  	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
  	var encmeth=GetElementValue("cancel")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole);
    if (Rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQProject&RowID='+Rtn+"&WaitAD="+GetElementValue("WaitAD");
	}
    else
    {
	    alertShow(EQMsg("²Ù×÷Ê§°Ü",t[Rtn]))
    }
}

function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQProject');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("audit")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(EQMsg("²Ù×÷Ê§°Ü",t[Rtn]))
    }
}

function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("ApproveSetDR");
	return ValueList;
}
function CheckNull()
{
	if (CheckMustItemNull("")) return true;
	return false;
}

function GetProviderID(value)
{
	GetLookUpID("ProviderDR",value);
}

function SetDisplay()
{	
	ReadOnlyCustomItem(GetParentTable("Name"),GetElementValue("Status"));
}
document.body.onload = BodyLoadHandler;