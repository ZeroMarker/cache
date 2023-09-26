
function BodyLoadHandler() 
{
	InitPage();
	FillData();
	InitStyle("Remark","9");
	SetEnabled();
	KeyUp("UseLoc^Equip");//
	Muilt_LookUp("UseLoc^Equip");
	InitUserInfo();
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
	
	var obj=document.getElementById("BSource");
	if (obj) obj.onclick=BSource_Clicked;
	
	
	DisableElement("RequestNo",true);
	DisableElement("Equip",true);
	DisableElement("UseLoc",true);
	//ReadOnly("RequestNo");
	//ReadOnly("Equip");
	//ReadOnly("UseLoc");
}

function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	
	var sort=32
	SetElement("RequestNo",list[0]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[2]);
	SetElement("EquipDR",list[3]);
	SetElement("Equip",list[sort+0]);
	SetElement("UseLocDR",list[4]);
	SetElement("UseLoc",list[sort+1]);
	SetElement("MaintFee",list[5]);
	SetElement("RequestDate",list[6]);
	SetElement("SubmitUserDR",list[7]);
	SetElement("SubmitUser",list[sort+2]);
	SetElement("SubmitDate",list[8]);
	SetElement("SubmitTime",list[9]);
	SetElement("AuditUserDR",list[10]);
	SetElement("AuditUser",list[sort+3]);
	SetElement("AuditDate",list[11]);
	SetElement("AuditTime",list[12]);
	SetElement("Status",list[13]);
	SetElement("ApproveSetDR",list[14]);
	SetElement("ApproveSet",list[sort+4]);
	SetElement("NextRoleDR",list[15]);
	SetElement("NextRole",list[sort+5]);
	SetElement("NextFlowStep",list[16]);
	SetElement("ApproveStatu",list[17]);
	SetElement("ApproveRoleDR",list[18]);
	SetElement("ApproveRole",list[sort+6]);
	SetElement("EquipTypeDR",list[19]);
	SetElement("EquipType",list[sort+7]);
	SetElement("Condition",list[20]);
	SetElement("RequestReason",list[21]);
	SetElement("Remark",list[22]);
	SetElement("RejectReason",list[23]);
	SetElement("RejectUserDR",list[24]);
	SetElement("RejectUser",list[sort+8]);
	SetElement("RejectDate",list[25]);
	SetElement("RejectTime",list[26]);
	SetElement("Hold1",list[27]);
	SetElement("Hold2",list[28]);
	SetElement("Hold3",list[29]);
	SetElement("Hold4",list[30]);
	SetElement("Hold5",list[31]);
	
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	if (Status== "0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status=="")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Type=="0")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	else
	{
		DisableElement("RejectReason",false);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);

		var NextStep=GetElementValue("NextFlowStep");
		if (Type=="3")
		{
			if (Status!="2") DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
			DisableElement("RejectReason",true);
		}
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
}


function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("RequestNo") ;
  	combindata=combindata+"^"+GetElementValue("SourceType") ;
  	combindata=combindata+"^"+GetElementValue("SourceID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintFee") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("NextRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("NextFlowStep") ;
  	combindata=combindata+"^"+GetElementValue("ApproveStatu") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Condition") ;
  	combindata=combindata+"^"+GetElementValue("RequestReason") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("RejectReason") ;
  	combindata=combindata+"^"+GetElementValue("RejectUserDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectDate") ;
  	combindata=combindata+"^"+GetElementValue("RejectTime") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	
  	return combindata;
}

function UpdateData(ValueList,AppType)
{
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType);
	return ReturnValue;
}

function BUpdate_Clicked()
{
	if (CheckMustItemNull()) return;
	var combindata=GetValue();
	///alertShow(combindata);
    var Return=UpdateData(combindata,"0");
    if (Return>0)
    {
	    var RowID=GetElementValue("RowID");
	    alertShow(t["0"]);
	    if (RowID=="")
	    {
		    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOuterRequest&RowID='+Return+'&Type='+GetElementValue("Type");
	    }
	    if (RowID!="") window.location.reload();
	}
    else
    {
	    alertShow(t[Return]);
    }
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var rowid=GetElementValue("RowID");
	var Return=UpdateData(rowid,"3");
	if (Return=="")
    {
	    alertShow(t["0"]);
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOuterMaintRequest&RowID=&Type='+GetElementValue("Type")
	    
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BSubmit_Clicked()
{
	var rowid=GetElementValue("RowID");
	var Return=UpdateData(rowid,"1");
    if (Return>0)
    {
	    alertShow(t["0"]);
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
	}
    else
    {
	    alertShow(t[Return]);
    }
}

function BCancelSubmit_Clicked()
{
	if (CheckItemNull(2,"RejectReason")) return;
	var RejectReason=GetElementValue("RejectReason");
	var rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var Return=UpdateData(rowid+"^"+RejectReason,"4");
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false;
}

function BAudit_Clicked()
{
	var RowID=GetElementValue("RowID");
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var combindata=GetOpinion();
		combindata=RowID+"^"+combindata;
		var Return=UpdateData(combindata,"2");
	}
	if (Type=="2")
	{
		var Return=UpdateData(RowID,"5");
	}
	if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type")
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}

function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	combindata=combindata+"^"+GetElementValue("QXType") ;
  	return combindata;  	
}

function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}

function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}


function BSource_Clicked()
{
	var RowID=GetElementValue("SourceID");
	var EquipDR=GetElementValue("EquipDR");
	if ((RowID=="")||(EquipDR=="")) return;
	var LinkUrl="dhceqmaintrequest.csp?"+"&RowID="+RowID+"&Status=КЬАн&EquipDR="+EquipDR+"&Add=1";
	window.open(LinkUrl,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=920,height=650,left=220,top=0')
}

document.body.onload = BodyLoadHandler;