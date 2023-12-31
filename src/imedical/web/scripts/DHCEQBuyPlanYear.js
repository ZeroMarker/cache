
function BodyLoadHandler() 
{
	InitStyle("PlanName","2");
	InitPage();
	InitUserInfo();
	FillData();
	SetEnabled();
	KeyUp("EquipType^PurchaseType^PurposeType");
	Muilt_LookUp("EquipType^PurchaseType^PurposeType");
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type")
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		//DisableBElement("BCreatePlan",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BBuyPlanItem",true);
		//DisableBElement("BCreatePlan",true);
	}
	if (Status=="")
	{
		DisableBElement("BBuyPlanItem",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		//DisableBElement("BCreatePlan",true);
	}
	if (Status=="2")
	{
		DisableBElement("BBuyPlanItem",true);
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
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableElement("RejectReason",false);
		var NextStep=GetElementValue("NextFlowStep")
		if (Type=="1")
		{
			var RoleStep=GetElementValue("RoleStep")
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
	var Return=ISHaveData();
	if (Return==0)
	{
		DisableElement("PlanYear",true)
		DisableLookup("EquipType",true)
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
	var sort=42
	SetElement("PlanName",list[0]);
	SetElement("QuantityNum",list[1]);
	SetElement("TotalFee",list[2]);
	SetElement("Remark",list[3]);
	SetElement("PlanDate",list[4]);
	SetElement("Status",list[5]);
	SetElement("ApproveSetDR",list[6]);
	SetElement("ApproveSet",list[sort+0]);
	SetElement("NextRoleDR",list[7]);
	SetElement("NextRole",list[sort+1]);
	SetElement("NextFlowStep",list[8]);
	SetElement("ApproveStatu",list[9]);
	SetElement("ApproveRoleDR",list[10]);
	SetElement("ApproveRole",list[sort+2]);
	SetElement("EquipTypeDR",list[11]);
	SetElement("EquipType",list[sort+3]);
	SetElement("PlanNo",list[24]);
	SetElement("PlanType",list[25]);
	SetElement("PlanYear",list[26]);
	SetElement("PurchaseTypeDR",list[27]);
	SetElement("PurchaseType",list[sort+8]);
	SetElement("RejectReason",list[28]);
	SetChkElement("UrgencyFlag",list[32]);
	SetElement("BuyRemark",list[36]);
	SetElement("BuyStatus",list[37]);
	SetElement("PurposeTypeDR",list[41]);
	SetElement("PurposeType",list[sort+11]);
	SetElement("AddUser",list[sort+6]);
}
function IsUniqueYear()
{
	var RowID=GetElementValue("RowID");
	var YearStr=GetElementValue("PlanYear");
	var encmeth=GetElementValue("IsUniqueYear");
	var EquipType=GetElementValue(EquipType);
	var i=cspRunServerMethod(encmeth,RowID,YearStr,EquipType);
	if (i>0)
	{
		alertShow(t["06"])
		return true;
	}
	return false;
}
function InitPage()
{
	var obj=document.getElementById("BBuyPlanItem");
	if (obj) obj.onclick=BBuyPlanItem_Click;
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
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
}
function BPrint_Clicked()
{
	PrintClickBuyPlan();
}
function BDelete_Clicked()
{
	/*var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateData("","3")*/
	var objtbl=document.getElementById('tDHCEQBuyPlanYear');
	var rows=objtbl.rows.length;
	var encmeth=GetElementValue('updDetail');
	var UpdValue=""
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById('TRefuseFlagz'+i);
		if (obj.checked)
		{
			var RefuseFlag="Y"
		}
		else
		{
			var RefuseFlag="N"
		}
		var RefuseReason=GetElementValue('TRefuseReasonz'+i);
		var RowID=GetElementValue('TRowIDz'+i);
		var UpdNum=GetElementValue('TQuantityNumz'+i);
		var BRNum=GetCElementValue('TBRQuantityz'+i);
		var Price=GetElementValue('TPriceFeez'+i);
		if (UpdNum=="") {UpdNum=0;}
		if (parseFloat(UpdNum)<=0)
		{
			alertShow("��"+i+"��,"+t["08"]);
			return;
		}
		if (parseFloat(UpdNum)>parseFloat(BRNum))
		{
			alertShow("��"+i+"��,"+t["07"]);
			return;
		}
		UpdValue=UpdValue+";;"+RowID+"^"+RefuseFlag+"^"+RefuseReason+"^"+UpdNum+"^"+Price;
	}
	var Return=cspRunServerMethod(encmeth,UpdValue);
	if (Return=="0")
    {
	    window.location.reload()//.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYear&BuyPlanDR='+GetElementValue("RowID")+'&Type='+GetElementValue("Type")+'&PlanType='+GetElementValue("PlanType")+'&Year='+GetElementValue("Year")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var Return=ISHaveData();
	if (Return!=0)
	{
		alertShow(Return+"  "+t["03"]);
		return
	}
	var Return=UpdateData("","1");
    if (Return>0)
    {
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
	var Return=UpdateData(RejectReason,"4");
    if (Return>0)
    {
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
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
		var combindata=GetOpinion();
		var Return=UpdateData(combindata,"2");
	}
	if (Type=="2")
	{
		var Return=UpdateData("","5");
	}
    if (Return>0)
    {
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
	    
	}
    else
    {
	    alertShow(Return+" "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValue();
    var Return=UpdateData(combindata,"0");
    if (Return>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYear&BuyPlanDR='+Return+'&Type='+GetElementValue("Type")+'&PlanType='+GetElementValue("PlanType")+'&Year='+GetElementValue('PlanYear')+'&EquipTypeID='+GetElementValue('EquipTypeDR')
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
	var combindata=""
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("PlanName") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("PlanDate") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("NextRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("NextFlowStep") ;
  	combindata=combindata+"^"+GetElementValue("ApproveStatu") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("PlanNo") ;
  	combindata=combindata+"^"+GetElementValue("PlanType") ;
  	combindata=combindata+"^"+GetElementValue("PlanYear") ;
  	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectReason") ;
  	combindata=combindata+"^"+GetElementValue("RejectUserDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectDate") ;
  	combindata=combindata+"^"+GetElementValue("RejectTime") ;
  	combindata=combindata+"^"+GetChkElementValue("UrgencyFlag") ;
  	combindata=combindata+"^"+GetElementValue("BuyAuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyAuditDate") ;
  	combindata=combindata+"^"+GetElementValue("BuyAuditTime") ;
  	combindata=combindata+"^"+GetElementValue("BuyRemark") ;
  	combindata=combindata+"^"+GetElementValue("BuyStatus") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("PurposeTypeDR") ;
  	return combindata;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(2,"PlanName")) return true;
	if (CheckItemNull(2,"PlanDate")) return true;
	if (CheckItemNull(2,"PlanYear")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	if (CheckItemNull(1,"PurchaseType")) return true;*/
	return false;
}
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
function ISHaveData()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("ISHaveData");
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID);
	return ReturnValue;
}
function BBuyPlanItem_Click() 
{
	var encmeth=GetElementValue("SumRequest");
	var Return=cspRunServerMethod(encmeth,GetElementValue("RowID"),curUserID);
	if (Return>=0)
	{
		window.location.reload() ;//href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYear&BuyPlanDR='+GetElementValue("RowID")+'&Type='+GetElementValue("Type")+'&Year='+GetElementValue("Year")//+'&PlanType='+GetElementValue("PlanType")
	}
	else
	{
		alertShow(t['05']);
	}
}

function IsVaildYear()
{
	var encmeth=GetElementValue("IsVaildYear")
	if (cspRunServerMethod(encmeth,GetElementValue("PlanYear"))==1)
	{
		alertShow(t["04"]);
		return ture;
	}
	return false
}
function UpdateData(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	ValueList=RowID+"^"+ValueList
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType,"Y")
	return ReturnValue;
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetPurposeType (value)
{ 
    GetLookUpID("PurposeTypeDR",value);
}
document.body.onload = BodyLoadHandler;

