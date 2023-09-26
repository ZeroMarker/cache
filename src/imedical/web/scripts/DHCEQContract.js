
function BodyLoadHandler() 
{
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		DisableAllTxt();
		DisableElement("RejectReason",false);
	}
	InitStyle("ContractNo","8");
	InitPage();
	FillData();
	SetEnabled();
	KeyUp("NeedHandler^Provider^PayType^SignLoc^ServicePro");
	Muilt_LookUp("NeedHandler^Provider^PayType^SignLoc^ServicePro");
	InitUserInfo();
	EnterToTab("ContractNo");
	SetElementEnable();
}
function SetEnabled()
{
	var Type=GetElementValue("Type");
	var Status=GetElementValue("Status");
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BImportExecel",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BImportExecel",true);
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
	//alertShow("Status:"+Status+" Type:"+Type);
	if (Type=="0")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	else
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BImportExecel",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
}

function SetElementEnable()
{
	var Type=GetElementValue("Type");
	var NextStep=GetElementValue("NextFlowStep")
	if (Type=="1")
	{
		//DisableAllTxt();
		//DisableElement("RejectReason",false);
		var RoleStep=GetElementValue("RoleStep");
		//alertShow('RoleStep:'+RoleStep+"  NextStep:"+NextStep);
		if (RoleStep==NextStep)
		{
			SetItemDisabale(3,0,GetElementValue("CurRole"))
		}
	}
	GetDisabledElement();
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
	//var sort=41
	var sort=49;
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
	
	SetElement("ApproveSetDR",list[41]);
	SetElement("NextRoleDR",list[42]);
	SetElement("NextFlowStep",list[43]);
	SetElement("ApproveStatu",list[44]);
	SetElement("ApproveRoleDR",list[45]);
	SetElement("RejectReason",list[46]);
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
	
	var obj=document.getElementById("BImportExecel");
	if (obj) obj.onclick=BImportExecel_Clicked;
}
function BImportExecel_Clicked()
{
	try {
		
	var   result=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCEQGetFileName','','')   
  	//在弹出窗口中给window.returnValue="值";   
   	if (result=="") return
    var Template=result
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.open(Template);
	
	xlsheet = xlBook.Worksheets("HeTong");
	//xlsheet = xlBook.ActiveSheet;
	//对窗口赋值
	SetElement("ContractName",GetExcelValue(xlsheet,1,1));
	SetElement("ContractNo",GetExcelValue(xlsheet,2,2));
	//SetElement("QuantityNum",xlsheet.cells(1,1));
	//SetElement("TotalFee",xlsheet.cells(1,1));
	//SetElement("PreFeeFee",xlsheet.cells(1,1));
	//SetElement("PayedTotalFee",xlsheet.cells(1,1));
	SetElement("SignDate",GetExcelValue(xlsheet,9,4));
	//SetElement("SignLocDR",xlsheet.cells(1,1));
	//SetElement("SignLoc",xlsheet.cells(1,1));
	//SetElement("DeliveryDate",xlsheet.cells(1,1));
	//SetElement("ArriveDate",xlsheet.cells(1,1));
	//SetElement("StartDate",xlsheet.cells(1,1));
	//SetElement("EndDate",xlsheet.cells(1,1));
	//SetElement("ClaimPeriodNum",xlsheet.cells(1,1));
	SetElement("Service",GetExcelValue(xlsheet,12,2));
	//SetElement("PayTypeDR",xlsheet.cells(1,1));
	//SetElement("PayType",xlsheet.cells(1,1));
	SetElement("PayItem",GetExcelValue(xlsheet,14,2));
	SetElement("CheckStandard",GetExcelValue(xlsheet,13,2));
	var ProviderCode=GetExcelValue(xlsheet,3,4);
	var encmeth=GetElementValue("GetProviderByCode");
	var ReturnList=cspRunServerMethod(encmeth,ProviderCode);
	var List=ReturnList.split("^");
	SetElement("ProviderDR",List[0]);
	SetElement("Provider",List[1]);
	SetElement("ProviderTel",GetExcelValue(xlsheet,7,4));
	SetElement("ProviderHandler",GetExcelValue(xlsheet,6,4));
	SetElement("BreakItem",GetExcelValue(xlsheet,15,2));
	//SetElement("NeedHandlerDR",xlsheet.cells(1,1));
	//SetElement("NeedHandler",xlsheet.cells(1,1));
	SetElement("GuaranteePeriodNum",GetExcelValue(xlsheet,9,2));
	SetElement("Remark",GetExcelValue(xlsheet,16,2));
	//SetElement("ArriveMonthNum",xlsheet.cells(1,1));
	//SetElement("ServiceProDR",xlsheet.cells(1,1));
	//SetElement("ServicePro",xlsheet.cells(1,1));
	SetElement("ServiceHandler",GetExcelValue(xlsheet,8,2));
	SetElement("ServiceTel",GetExcelValue(xlsheet,8,4));
	//SetElement("ContractType",xlsheet.cells(1,1));
	SetElement("ArriveItem",GetExcelValue(xlsheet,10,2));
	SetElement("QualityItem",GetExcelValue(xlsheet,11,2));
	
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet.Quit;
	xlsheet=null;
	alertShow(t["04"]);
	} 
	catch(e)
	 {
		 if (e.number==-2146827284) return;
		alertShow(e.message);
		};
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateCheck("","3");
	if (Return=="")
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContract&RowID='+Return
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
	var Return=UpdateCheck("","1");
    if (Return>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked()
{
	var rejectreason=GetElementValue("RejectReason");
	if (rejectreason=="") 
	{
		alertShow('拒绝原因不能为空!');
		return;
	}
	
	var Return=UpdateCheck(rejectreason,"4");
    if (Return>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BAudit_Clicked()
{
	var combindata="";
	var AppType="2";
	var Type=GetElementValue("Type");
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		combindata=GetOpinion();
		AppType="5";		
	}
	var Return=UpdateCheck(combindata,AppType);
    if (Return>0)
    {
	   	window.location.reload();
	}
    else
    {
	   	alertShow(Return+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
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
  	/*
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("NextRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("NextFlowStep") ;
  	combindata=combindata+"^"+GetElementValue("ApproveStatu") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	*/
  	/*
  	combindata=combindata+"^"+GetElementValue("AddUserDR") ;
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
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContract&RowID='+Return+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType");
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
	/*if (CheckItemNull(2,"ContractNo")) return true;
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
	var combindata="";
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	combindata=combindata+"^"+GetElementValue("QXType") ;
  	return combindata;
  	
}

document.body.onload = BodyLoadHandler;