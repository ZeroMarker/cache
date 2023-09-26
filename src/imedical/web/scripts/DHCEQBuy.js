
function BodyLoadHandler() 
{
	InitStyle("PlanName","4");
	InitPage();
	InitUserInfo();
	FillData();
	SetEnabled();
}
function SetEnabled()
{
	var Status=GetElementValue("BuyStatus");
	var Type=GetElementValue("Type");
	if (+Status>1)
	{
		DisableBElement("BAudit",true);
	}
	var NextStep=GetElementValue("NextFlowStep");
	if (Type=="1")
	{
		var RoleStep=GetElementValue("RoleStep");
		if (RoleStep!=NextStep)
		{
			DisableBElement("BAudit",true);
		}
		DisableBElement("BPartExec",true);
		DisableBElement("BAllExec",true);
	}
	if (Type=="2")
	{
		if (NextStep!="")
		{
			DisableBElement("BAudit",true);
		}
		DisableBElement("BPartExec",true);
		DisableBElement("BAllExec",true);
	}
	if (Type=="3")
	{
		if (Status!="4")
		{
			DisableBElement("BPartExec",false);
			DisableBElement("BAllExec",false);
		}
		else
		{
			DisableBElement("BPartExec",true);
			DisableBElement("BAllExec",true);
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
	var sort=42;
	SetElement("PlanName",list[0]);
	SetElement("QuantityNum",list[1]);
	SetElement("TotalFee",list[2]);
	SetElement("Remark",list[3]);
	SetElement("PlanDate",list[4]);
	SetElement("Status",list[5]);
	SetElement("NextRoleDR",list[7]);
	SetElement("NextRole",list[sort+1]);
	SetElement("NextFlowStep",list[8]);
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
	SetElement("BuyApproveStatu",list[38]);
	SetElement("BuyApproveRoleDR",list[39]);
	SetElement("ApproveSetDR",list[40]);
	SetElement("PurposeTypeDR",list[41]);
	SetElement("PurposeType",list[sort+11]);
}
function InitPage()
{
	var obj=document.getElementById("BBuyPlanItem");
	if (obj) obj.onclick=BBuyPlanItem_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BPartExec")
	if (obj) obj.onclick=BPartExec_Clicked;
	var obj=document.getElementById("BAllExec")
	if (obj) obj.onclick=BAllExec_Clicked;
	
}
function BPartExec_Clicked()
{
	var objtbl=parent.DHCEQBuyPlanItem.document.getElementById('tDHCEQBuyItem');
	var rows=objtbl.rows.length;
	var NumList="";
	var RowID="";
	var BPRowID=GetElementValue("RowID");
	for (var i=1;i<rows;i++)
	{
		if (NumList!="") NumList=NumList+"^";
		var obj=parent.DHCEQBuyPlanItem.document.getElementById('TRowIDz'+i);
		if (obj) RowID=obj.value;
		var obj=parent.DHCEQBuyPlanItem.document.getElementById('TExecNumz'+i);
		if (obj) ExecNum=obj.value;
		var obj=parent.DHCEQBuyPlanItem.document.getElementById('TQuantityNumz'+i);
		if (obj) QuantityNum=obj.innerText;
		var obj=parent.DHCEQBuyPlanItem.document.getElementById('TContractNumz'+i);
		if (obj) ContractNum=obj.innerText;
		if (ExecNum=="")
		{
			ExecNum=0
		}
		else
		{
			ExecNum=parseFloat(ExecNum)
		}
		if (ContractNum=="")
		{
			ContractNum=0
		}
		else
		{
			ContractNum=parseFloat(ContractNum)
		}
		if (QuantityNum=="")
		{
			QuantityNum=0
		}
		else
		{
			QuantityNum=parseFloat(QuantityNum)
		}
		if (ExecNum<0)
		{
			alertShow("第"+i+"行"+t["05"]);
			return;
		}
		if (ExecNum>QuantityNum)
		{
			alertShow("第"+i+"行"+t["04"]);
			return;
		}
		if (ContractNum>ExecNum)
		{
			alertShow("第"+i+"行"+t["07"]);
			return;
		}
		NumList=NumList+RowID+","+ExecNum; //if (ExecNum!=""&&ExecNum!=0) 
	}
	var encmeth=GetElementValue("PartExec");
	var Return=cspRunServerMethod(encmeth,BPRowID,NumList);
	if (Return>0)
	{
		parent.location.reload();
	}
	else
	{
		alertShow(t[Return]+" "+t["01"]);
	}
}
function BAllExec_Clicked()
{
	var encmeth=GetElementValue("AllExec");
	var RowID=GetElementValue("RowID");
	var Return=cspRunServerMethod(encmeth,RowID);
	if (Return>0)
	{
		parent.location.reload();
	}
	else
	{
		alertShow(t[Return]+" "+t["01"]);
	}
}
function BAudit_Clicked()
{
	var RowID=GetElementValue("RowID");
	var Type=GetElementValue("Type");
	var combindata=GetOpinion();
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var Return=UpdateData(combindata,"0");
	}
	if (Type=="2")
	{
		var Return=UpdateData(combindata,"1");
	}
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
	    
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
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
  	combindata=combindata+"^"+GetElementValue("BuyRemark") ;
  	return combindata;
  	
}
function UpdateData(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	ValueList=RowID+"^"+ValueList;
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType);
	return ReturnValue;
}
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false;
}
function BBuyPlanItem_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanItem&BuyPlanDR='+GetElementValue("RowID");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}

document.body.onload = BodyLoadHandler;