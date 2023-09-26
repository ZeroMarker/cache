/// scripts/hisui/DHCEQSerContract.js
function BodyLoadHandler() 
{
	InitPage();
	SetEnabled();
	initButtonWidth();
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
	}
	KeyUp("Provider");
	Muilt_LookUp("Provider");
	InitUserInfo();
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status=="0")
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
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status=="")
	{
		DisableBElement("BEquipList",true);
		DisableBElement("BPayList",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
	}
}

///选择表格行触发此方法
var SelectedRow = -1;
var rowid=0;
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		ElementClear();
		DisableBElement("BDelete",true);
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		FillData(rowid);//调用函数
		if (GetElementValue("ReadOnly")!=1)
		{
			InitPage();
			DisableBElement("BDelete",false);
		}
	}
}
function ElementClear()
{
	SetElement("RowID","");
	SetElement("ContractName","");
	SetElement("ContractNo","");
	SetElement("QuantityNum","");
	SetElement("TotalFee","");
	SetElement("PreFeeFee","");
	SetElement("PayedTotalFee","");
	SetElement("SignDate","");
	SetElement("SignLocDR","");
	SetElement("SignLoc","");
	SetElement("DeliveryDate","");
	SetElement("ArriveDate","");
	SetElement("StartDate","");
	SetElement("EndDate","");
	SetElement("ClaimPeriodNum","");
	SetElement("Service","");
	SetElement("PayTypeDR","");
	SetElement("PayType","");
	SetElement("PayItem","");
	SetElement("CheckStandard","");
	SetElement("ProviderDR","");
	SetElement("Provider","");
	SetElement("ProviderTel","");
	SetElement("ProviderHandler","");
	SetElement("BreakItem","");
	SetElement("NeedHandlerDR","");
	SetElement("NeedHandler","");
	SetElement("GuaranteePeriodNum","");
	SetElement("Status","");
	SetElement("Remark","");
	/*SetElement("AddUserDR",list[25]);
	SetElement("AddUser",list[sort+4]);
	SetElement("AddDate",list[26]);
	SetElement("AddTime",list[27]);
	SetElement("UpdateUserDR",list[28]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[29]);
	SetElement("UpdateTime",list[30]);
	SetElement("AuditUserDR",list[31]);
	SetElement("AuditUser",list[sort+6]);
	SetElement("AuditDate",list[32]);
	SetElement("AuditTime",list[33]);*/
	SetElement("ArriveMonthNum","");
	SetElement("ServiceProDR","");
	SetElement("ServicePro","");
	SetElement("ServiceHandler","");
	SetElement("ServiceTel","");
}
function FillData(RowID)
{
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=57;
	SetElement("RowID",RowID);
	SetElement("ContractName",list[0]);
	SetElement("ContractNo",list[1]);
	SetElement("QuantityNum",list[2]);
	SetElement("TotalFee",list[3]);
	SetElement("PreFeeFee",list[4]);
	SetElement("PayedTotalFee",list[5]);
	SetElement("SignDate",list[6]);
	SetElement("SignLocDR",list[7]);
	SetElement("SignLoc",list[sort+0]);
	SetElement("DeliveryDate",list[8]);
	SetElement("ArriveDate",list[9]);
	SetElement("StartDate",list[10]);
	SetElement("EndDate",list[11]);
	SetElement("ClaimPeriodNum",list[12]);
	SetElement("Service",list[13]);
	SetElement("PayTypeDR",list[14]);
	SetElement("PayType",list[sort+1]);
	SetElement("PayItem",list[15]);
	SetElement("CheckStandard",list[16]);
	SetElement("ProviderDR",list[17]);
	SetElement("Provider",list[sort+2]); 
	SetElement("ProviderTel",list[18]);
	SetElement("ProviderHandler",list[19]);
	SetElement("BreakItem",list[20]);
	SetElement("NeedHandlerDR",list[21]);
	SetElement("NeedHandler",list[sort+3]);
	SetElement("GuaranteePeriodNum",list[22]);
	SetElement("Status",list[23]);
	SetElement("Remark",list[24]);
	/*SetElement("AddUserDR",list[25]);
	SetElement("AddUser",list[sort+4]);
	SetElement("AddDate",list[26]);
	SetElement("AddTime",list[27]);
	SetElement("UpdateUserDR",list[28]);
	SetElement("UpdateUser",list[sort+5]);
	SetElement("UpdateDate",list[29]);
	SetElement("UpdateTime",list[30]);
	SetElement("AuditUserDR",list[31]);
	SetElement("AuditUser",list[sort+6]);
	SetElement("AuditDate",list[32]);
	SetElement("AuditTime",list[33]);*/
	SetElement("ArriveMonthNum",list[34]);
	SetElement("ServiceProDR",list[35]);
	SetElement("ServicePro",list[sort+7]);
	SetElement("ServiceHandler",list[36]);
	SetElement("ServiceTel",list[37]);
	SetElement("ContractType",list[38]);
	SetElement("ArriveItem",list[39]);
	SetElement("QualityItem",list[40]);
}

function InitPage()
{
	var obj=document.getElementById("BEquipList");
	if (obj) obj.onclick=BEquipList_Click;
	
	var obj=document.getElementById("BPayList");
	if (obj) obj.onclick=BPayList_Click;
	
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
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Clicked;
}
function BClose_Clicked()
{
	window.close()
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateCheck("","3");
	if (Return=="")
    {
	    window.location.reload();//href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&RowID='+Return+"&EquipDR="+GetElementValue("EquipDR")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	//var Return=ISHaveData();
	//if (Return!=0)
	//{
	//	alertShow(Return+"  "+t["03"]);
	//	return
	//}
	var Return=UpdateCheck("","1");
    if (Return>0)
    {
	    window.location.reload();//.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&RowID='+Return+"&EquipDR="+GetElementValue("EquipDR")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked()
{
	var Return=UpdateCheck("","4");
    if (Return>0)
    {
	    window.location.reload();//.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&RowID='+Return+"&EquipDR="+GetElementValue("EquipDR")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BAudit_Clicked()
{
	var combindata="";
	var Return=UpdateCheck(combindata,"2");
    if (Return>0)
    {
	    window.location.reload();//.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&RowID='+Return+"&EquipDR="+GetElementValue("EquipDR")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	
/*************************************************************/
// add By 20150826 HHM0009
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	
	if (DateDiff(StartDate,EndDate)>0)
	{
		alertShow("开始日期大于结束日期！");
		return;
	}
/*************************************************/
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ContractName") ;
  	combindata=combindata+"^"+GetElementValue("ContractNo") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("TotalFee") ;
  	combindata=combindata+"^"+GetElementValue("PreFeeFee") ;
  	combindata=combindata+"^"+GetElementValue("PayedTotalFee") ;
  	combindata=combindata+"^"+GetElementValue("SignDate") ;
  	combindata=combindata+"^"+GetElementValue("SignLocDR") ;
  	combindata=combindata+"^"+GetElementValue("DeliveryDate") ;
  	combindata=combindata+"^"+GetElementValue("ArriveDate") ;
  	combindata=combindata+"^"+GetElementValue("StartDate") ;
  	combindata=combindata+"^"+GetElementValue("EndDate") ;
  	combindata=combindata+"^"+GetElementValue("ClaimPeriodNum") ;
  	combindata=combindata+"^"+GetElementValue("Service") ;
  	combindata=combindata+"^"+GetElementValue("PayTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PayItem") ;
  	combindata=combindata+"^"+GetElementValue("CheckStandard") ;
  	combindata=combindata+"^"+GetElementValue("ProviderDR") ;
  	combindata=combindata+"^"+GetElementValue("ProviderTel") ;
  	combindata=combindata+"^"+GetElementValue("ProviderHandler") ;
  	combindata=combindata+"^"+GetElementValue("BreakItem") ;
  	combindata=combindata+"^"+GetElementValue("NeedHandlerDR") ;
  	combindata=combindata+"^"+GetElementValue("GuaranteePeriodNum") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("ArriveMonthNum") ;
  	combindata=combindata+"^"+GetElementValue("ServiceProDR") ;
  	combindata=combindata+"^"+GetElementValue("ServiceHandler") ;
  	combindata=combindata+"^"+GetElementValue("ServiceTel") ;
  	combindata=combindata+"^"+GetElementValue("ContractType") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("ArriveItem") ;
  	combindata=combindata+"^"+GetElementValue("QualityItem") ;
  	/*combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;*/
    var Return=UpdateCheck(combindata,"0");
    if (Return>0)
    {
	    window.location.reload();//.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&RowID='+Return+"&EquipDR="+GetElementValue("EquipDR")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BEquipList_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractEquip&ContractDR='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BPayList_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractPay&ContractDR='+GetElementValue("RowID")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"ContractNo")) return true;
	if (CheckItemNull(2,"ContractName")) return true;
	if (CheckItemNull(1,"SignLoc")) return true;
	if (CheckItemNull(2,"SignDate")) return true;
	if (CheckItemNull(1,"Provider")) return true;
	*/
	return false;
}
function UpdateCheck(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("upd");
	var user=curUserID;
	var ReturnValue=cspRunServerMethod(encmeth,"","",ValueList,AppType,RowID,user);
	return ReturnValue;
}
function ISHaveData()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("ISHaveData");
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID);
	return ReturnValue;
}
function GetNeedHandler (value)
{
    GetLookUpID("NeedHandlerDR",value);
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetPayType (value)
{
    GetLookUpID("PayTypeDR",value);
}
function GetSignLoc (value)
{
    GetLookUpID("SignLocDR",value);
}
function GetServicePro (value)
{
    GetLookUpID("ServiceProDR",value);
}
document.body.onload = BodyLoadHandler;