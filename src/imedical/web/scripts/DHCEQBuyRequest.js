
function BodyLoadHandler() 
{
	InitStyle("RequestLoc","1");
	InitPage();
	FillData();
	IsYear();
	SetEnabled();
	KeyUp("RequestLoc^UseLoc^PurchaseType^EquipType^PurposeType");//
	Muilt_LookUp("RequestLoc^UseLoc^PurchaseType^EquipType^PurposeType");
	InitUserInfo();
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	if (Status== "0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BCreatePlan",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCreatePlan",true);
		DisableBElement("BRequestItem",true);
	}
	if (Status=="")
	{
		DisableBElement("BRequestItem",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCreatePlan",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BRequestItem",true);
		if (Type!="3")
		{
			DisableBElement("BCreatePlan",true);
		}
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
		DisableElement("YearFlag",true);
		DisableLookup("Year",true);
		DisableElement("PrjName",true);
		DisableLookup("RequestDate",true);
		DisableLookup("RequestNo",true);
		DisableLookup("RequestLoc",true);
		DisableLookup("LocOpinion",true);
		DisableLookup("UseLoc",true);
		DisableLookup("EquipType",true);
		DisableLookup("PurchaseType",true);
		DisableElement("UrgencyFlag",true);
		DisableElement("Remark",true);
		DisableLookup("PurposeType",true);
		DisableElement("RejectReason",false);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BRequestItem",true);
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
	var sort=41
	SetElement("PrjName",list[0]);
	SetElement("RequestLocDR",list[1]);
	SetElement("RequestLoc",list[sort+0]);
	SetChkElement("YearFlag",list[2]);
	SetChkElement("HiddenYear",list[2]);
	SetElement("UseLocDR",list[3]);
	SetElement("UseLoc",list[sort+1]);
	SetElement("Year",list[4]);
	SetElement("RequestDate",list[5]);
	SetChkElement("GatherFlag",list[6]);
	SetElement("QuantityNum",list[7]);
	SetElement("TotalFee",list[8]);
	/*SetElement("SubmitUserDR",list[9]);
	SetElement("SubmitUser",list[sort+2]);
	SetElement("SubmitDate",list[10]);
	SetElement("SubmitTime",list[11]);
	SetElement("AuditUserDR",list[12]);
	SetElement("AuditUser",list[sort+3]);
	SetElement("AuditDate",list[13]);
	SetElement("AuditTime",list[14]);*/
	SetElement("Status",list[15]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("ApproveSetDR",list[19]);
	SetElement("ApproveSet",list[sort+4]);
	SetElement("NextRoleDR",list[20]);
	SetElement("NextRole",list[sort+5]);
	SetElement("NextFlowStep",list[21]);
	SetElement("ApproveStatus",list[22]);
	SetElement("ApproveRoleDR",list[23]);
	SetElement("ApproveRole",list[sort+6]);
	SetElement("EquipTypeDR",list[24]);
	SetElement("EquipType",list[sort+7]);
	SetElement("PurchaseTypeDR",list[25]);
	SetElement("PurchaseType",list[sort+8]);
	SetElement("Remark",list[26]);
	SetElement("AddUser",list[sort+9]);
	/*SetElement("AddUserDR",list[27]);
	SetElement("AddUser",list[sort+9]);
	SetElement("AddDate",list[28]);
	SetElement("AddTime",list[29]);
	SetElement("UpdateUserDR",list[30]);
	SetElement("UpdateUser",list[sort+10]);
	SetElement("UpdateDate",list[31]);
	SetElement("UpdateTime",list[32]);*/
	SetElement("LocOpinion",list[33]);
	SetElement("RequestNo",list[34]);
	SetChkElement("UrgencyFlag",list[35]);
	SetElement("RejectReason",list[36]);
	/*SetElement("RejectUserDR",list[37]);
	SetElement("RejectUser",list[sort+11]);
	SetElement("RejectDate",list[38]);
	SetElement("RejectTime",list[39]);*/
	SetElement("PurposeTypeDR",list[40]);
	SetElement("PurposeType",list[sort+12]);
}

function InitPage()
{
	var obj=document.getElementById("BRequestItem");
	if (obj) obj.onclick=BRequestItem_Click;
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
	var obj=document.getElementById("YearFlag")
	if (obj) obj.onchange=IsYear;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BCreatePlan");
	if (obj) obj.onclick=BCreatePlan_Clicked;
}
function BCreatePlan_Clicked()
{
	var obj=document.getElementById("YearFlag");
	if (!obj) return;
	if (obj.checked)
	{
		alertShow(t["05"]);
		return;
	}
	var encmeth=GetElementValue("CreatePlan");
	var RowID=GetElementValue("RowID");
	var User=curUserID;
	var Return=cspRunServerMethod(encmeth,RowID+"^"+User,"Y");
	if (Return>0)
    {
	    parent.location.href= 'dhceqbuyplan.csp?RowID='+Return+'&Type=0';
	}
    else
    {
	    if (Return==-100) Return="没有明细或者已经生成计划";
	    alertShow(Return+"   "+t["01"]);
    }
}
function IsYear()
{
	var obj=document.getElementById("YearFlag");
	if (obj.checked)
	{
		DisableElement("Year",false);
	}
	else
	{
		DisableElement("Year",true);
		SetElement("Year","");
	}
}
function BPrint_Clicked()
{
	PrintClickBuyRequest();
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateBuyRequest("","3");
	if (Return=="")
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type")
	    parent.frames["DHCEQBuyRequestItem"].location.reload();			// Mozy	2010-12-16
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var RowID=GetElementValue("RowID");
	var MustArg=GetElementValue("MustArg");
	var encmeth=GetElementValue("CheckArgumentation");
	var Return=ISHaveData();
	if (Return!=0)
	{
		alertShow(Return+"  "+t["03"]);
		return;
	}
	var Argu=cspRunServerMethod(encmeth,RowID,"1");
	if (Argu==1)
	{
		if (MustArg=="1")
		{
			var truthBeTold = window.confirm(t["06"]+"继续吗");
			if (!truthBeTold) return;
		}
		if (MustArg=="2")
		{
			alertShow(t["06"]);
			return;
		}
	}
	
	var obj=document.getElementById("HiddenYear");
	if (!obj.checked)
	{
		var encmeth=GetElementValue("MustIsYear");
		var Must=cspRunServerMethod(encmeth,RowID);
		if (Must=="1")
		{
			alertShow(t["08"]);
			return;
		}
	}
	if (obj.checked)
	{
		if (CheckItemNull(2,"LocOpinion")) return ;
	}
	var Return=UpdateBuyRequest(GetElementValue("LocOpinion"),"1");
    if (Return>0)
    {
	   	window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type")
	}
    else
    {
	    alertShow(t[Return]);
    }
}
function ISHaveData()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("ISHaveData");
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID);
	return ReturnValue;
}
function BCancelSubmit_Clicked()
{
	if (CheckItemNull(2,"RejectReason")) return;
	var RejectReason=GetElementValue("RejectReason");
	var Return=UpdateBuyRequest(RejectReason,"4");
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BAudit_Clicked()
{
	var RowID=GetElementValue("RowID");
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
	}
	var encmeth=GetElementValue("CheckArgumentation");
	var SubStep=GetElementValue("ArgSubStep");
	var Argu=cspRunServerMethod(encmeth,RowID,SubStep);
	var MustArg=GetElementValue("MustArg");
	if (Argu==1)
	{
		if (SubStep=="2")
		{
			if (MustArg=="1")
			{
				var truthBeTold = window.confirm(t["07"]+"继续吗");
				if (!truthBeTold) return;
			}
			if (MustArg=="2")
			{
				alertShow(t["07"]);
				return;
			}
		}
		else
		{
			if (MustArg=="1")
			{
				var truthBeTold = window.confirm(t["06"]+"继续吗");
				if (!truthBeTold) return;
			}
			if (MustArg=="2")
			{
				alertShow(t["06"]);
				return;
			}
		}
	}
	if (Type=="1")
	{
		var combindata=GetOpinion();
		var Return=UpdateBuyRequest(combindata,"2");
	}
	if (Type=="2")
	{
		var Return=UpdateBuyRequest("","5");
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
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	if (IsVaildYear()) return;
	var combindata=GetValue();
    var Return=UpdateBuyRequest(combindata,"0");
    if (Return>0)
    {
	    var RowID=GetElementValue("RowID");
	    if (RowID=="")
	    {
		    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequest&RowID='+Return+'&Type='+GetElementValue("Type");
		    parent.frames["DHCEQBuyRequestItem"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestItem&BuyRequestDR='+Return;
	    }
	    if (RowID!="") window.location.reload();
	}
    else
    {
	    //alertShow(Return+"   "+t["01"]);
	    alertShow(t[Return]);
    }
}
function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata="";
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	combindata=combindata+"^"+GetElementValue("QXType") ;
  	return combindata;
  	
}
function GetValue()
{
	var combindata="";
  	combindata=combindata+GetElementValue("PrjName") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetChkElementValue("YearFlag") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("Year") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetChkElementValue("GatherFlag") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("NextRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("NextFlowStep") ;
  	combindata=combindata+"^"+GetElementValue("ApproveStatus") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("LocOpinion") ;
  	combindata=combindata+"^"+GetElementValue("RequestNo") ;
  	combindata=combindata+"^"+GetChkElementValue("UrgencyFlag") ;
  	combindata=combindata+"^"+GetElementValue("RejectReason") ;
  	combindata=combindata+"^"+GetElementValue("RejectUserDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectDate") ;
  	combindata=combindata+"^"+GetElementValue("RejectTime") ;
  	combindata=combindata+"^"+GetElementValue("PurposeTypeDR") ;
  	return combindata;
}
function BRequestItem_Click() 
{
	var str='dhceqbuyrequestitem.csp?BuyRequestDR='+GetElementValue("RowID");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}


function UpdateBuyRequest(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	ValueList=RowID+"^"+ValueList;
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType);
	return ReturnValue;
}
function IsVaildYear()
{
	var obj=document.getElementById("YearFlag");
	if (obj.checked)
	{
		var encmeth=GetElementValue("IsVaildYear");
		if (cspRunServerMethod(encmeth,GetElementValue("Year"))==1)
		{
			alertShow(t["04"]);
			return ture;
		}
	}
	return false;
}
function CheckNull()
{
	if (CheckMustItemNull("Year")) return true;
	/*if (CheckItemNull(2,"RequestDate")) return true;
	if (CheckItemNull(1,"RequestLoc")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	if (CheckItemNull(1,"PurchaseType")) return true;*/
	var obj=document.getElementById("YearFlag");
	if (obj.checked)
	{
		if (CheckItemNull(2,"Year")) return true;
	}
	return false;
}

function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false;
}
function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetPurposeType (value)
{ 
    GetLookUpID("PurposeTypeDR",value);
}
document.body.onload = BodyLoadHandler;

