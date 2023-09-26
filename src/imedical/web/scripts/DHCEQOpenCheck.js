/// 修改:zy 2009-10-28 BugNo.ZY0016
/// 修改函数BUpdate_Clicked,InitPage,CheckNull
/// 描述:改进功能,对机型,供应商,生产厂商取RowID?
/// 备注0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
/// -------------------------------
/// 修改:zy 2009-07-15 BugNo.ZY0005
/// 修改函数?Print
/// 描述:医疗器械验收单及附件打印
/// -------------------------------
function BodyLoadHandler() 
{
	InitStyle("Equip","7");
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	KeyUp("CheckResult^Provider^EquipTechLevel^ManageLevel^UseLoc^ManageLoc^Model^EquipCat^Unit^Country^ManuFactory^Origin^FromDept^BuyType^PackType^EquipType^PurchaseType^PurposeType^Keeper^Service^StatCat","N");
	Muilt_LookUp("Equip^Contract^CheckResult^Provider^EquipTechLevel^ManageLevel^UseLoc^ManageLoc^Contract^Model^EquipCat^Unit^Country^ManuFactory^Origin^FromDept^BuyType^PackType^EquipType^PurchaseType^PurposeType^Keeper^Service^StatCat");
}

function SetContractEnabled()
{
	var SelectType=GetElementValue("SelectEquipType");
	if (SelectType=="0")
	{
		DisableLookup("Contract",true);
	}
}

function SetEnabled()
{
	SetContractEnabled();
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
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
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="")
	{
		//DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BDoc",true);
		DisableBElement("BPictureInfo",true);
		DisableBElement("BAffix",true);
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
	//var sort=49;
	var sort=54;
	SetElement("EquipDR",list[0]);
	FillEquipData(list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("GroupDR",list[1]);
	SetElement("Group",list[sort+1]);
	SetElement("ManageLocDR",list[2]);
	SetElement("ManageLoc",list[sort+2]);
	SetElement("UseLocDR",list[3]);
	SetElement("UseLoc",list[sort+3]);
	SetElement("OpenState",list[4]);
	SetElement("CheckResultDR",list[5]);
	SetElement("CheckResult",list[sort+4]);
	SetElement("CheckResultRemark",list[6]);
	SetElement("CheckUser",list[7]);
	SetElement("Status",list[8]);
	SetElement("Remark",list[9]);
	SetElement("PackTypeDR",list[19]);
	SetElement("PackType",list[sort+8]);
	SetElement("PackNum",list[20]);
	
	SetElement("RejectReason",list[21]);
	//SetElement("RejectUserDR",list[22]);
	//SetElement("RejectUser",list[sort+9]);
	//SetElement("RejectDate",list[23]);
	//SetElement("RejectTime",list[24]);
	SetElement("ApproveSetDR",list[25]);
	//SetElement("ApproveSet",list[sort+10]);
	SetElement("NextRoleDR",list[26]);
	//SetElement("NextRole",list[sort+11]);
	SetElement("NextFlowStep",list[27]);
	SetElement("ApproveStatu",list[28]);
	SetElement("ApproveRoleDR",list[29]);
	//SetElement("ApproveRole",list[sort+12]);
	SetElement("Equip",list[30]);
	SetElement("ModelDR",list[31]);
	SetElement("Model",list[sort+13]);
	SetElement("EquipCatDR",list[32]);
	SetElement("EquipCat",list[sort+14]);
	SetElement("UnitDR",list[33]);
	SetElement("Unit",list[sort+15]);
	SetElement("Code",list[34]);
	SetElement("ItemDR",list[35]);
	//SetElement("Item",list[sort+16]);
	SetElement("LeaveFactoryNo",list[36]);
	SetElement("LeaveFactoryDate",list[37]);
	SetElement("OpenCheckDate",list[38]);
	SetElement("CountryDR",list[39]);
	SetElement("Country",list[sort+17]);
	SetElement("OriginDR",list[40]);
	SetElement("Origin",list[sort+18]);
	SetElement("FromDeptDR",list[41]);
	SetElement("FromDept",list[sort+19]);
	SetElement("ProviderDR",list[42]);
	SetElement("Provider",list[sort+20]);
	SetElement("ManuFactoryDR",list[43]);
	SetElement("ManuFactory",list[sort+21]);
	SetElement("OriginalValueFee",list[44]);
	SetElement("NetValueFee",list[45]);
	SetElement("EquipTypeDR",list[46]);
	SetElement("EquipType",list[sort+22]);
	SetElement("PurchaseTypeDR",list[47]);
	SetElement("PurchaseType",list[sort+23]);
	SetElement("StatCatDR",list[48]);
	SetElement("StatCat",list[sort+24]);
	SetElement("ContractDR",list[sort+25]);
	SetElement("Contract",list[sort+26]);
	
	SetElement("Hold1",list[49]);
	SetElement("Hold2",list[50]);
	SetElement("Hold3",list[51]);
	SetElement("Hold4",list[52]);
	SetElement("Hold5",list[53]);
}
function FillEquipData(RowID)
{
	var obj=document.getElementById("fillEquipData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("^");
	var sort=EquipGlobalLen;
	SetElement("EquipNo",list[70]);
	SetChkElement("ComputerFlag",list[14]);
	SetElement("ManageLevelDR",list[17]);
	SetElement("ManageLevel",list[sort+6]);
	SetElement("BuyTypeDR",list[22]);
	SetElement("BuyType",list[sort+11]);
	SetElement("EquipTechLevelDR",list[23]);
	SetElement("ContractListDR",list[31]);
	SetElement("ProviderHandler",list[40]);
	SetElement("ProviderTel",list[41]);
	SetChkElement("GuaranteeFlag",list[45]);
	SetChkElement("TestFlag",list[47]);
	SetChkElement("MedicalFlag",list[48]);
	SetElement("GuaranteeStartDate",list[49]);
	SetElement("GuaranteeEndDate",list[50]);
	SetChkElement("InvalidFlag",list[58]);
	SetChkElement("UrgencyFlag",list[61]);
	SetElement("PurposeTypeDR",list[64]);
	SetElement("PurposeType",list[sort+24]);
	SetElement("KeeperDR",list[65]);
	SetElement("Keeper",list[sort+25]);
	SetElement("ServiceDR",list[68]);
	SetElement("ServiceHandler",list[71]);
	SetElement("ServiceTel",list[72]);
	SetElement("Service",list[sort+27]);
	SetElement("EquipTechLevel",list[sort+30]);
}

function InitPage()
{
	var obj=document.getElementById("BAffix");
	if (obj) obj.onclick=BAffix_Click;
	var obj=document.getElementById("BPictureInfo");
	if (obj) obj.onclick=BPictureInfo_Click;
	var obj=document.getElementById("BDoc");
	if (obj) obj.onclick=BDoc_Click;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=ValueClear;
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
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquiCat_Click;	
	var obj=document.getElementById(GetLookupName("Equip"));
	if (obj) obj.onclick=Equip_Click;
	var obj=document.getElementById("Contract");
	if (obj) obj.onchange=ClearContract;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=DHCEQOpenCheckPrintBar;
	
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	//2009-11-11 ZY begin ZY0016
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod") 
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (ModelOperMethod==1)
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").removeNode(true)
	} 
	if (GetManuFactoryOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iManuFactory").removeNode(true)
	}
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}	
	//2009-11-11 ZY end  ZY0016
}
function ClearContract()
{
	SetElement("ContractDR","");
	SetElement("ContractListDR","");
	SetElement("Equip","");
	SetElement("ItemDR","");
}
function Equip_Click()
{
	var SelectType=GetElementValue("SelectEquipType");
	var Contract=GetElementValue("ContractDR");
	if ((SelectType=="1")&&(Contract==""))
	{
		alertShow(t["04"]);
		return;
	}
	if (Contract=="")
	{
		LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,Equip")
	}
	else
	{
		LookUpOpenCheckSelectEquipByContract("GetContractList","ContractDR")
	}
}
function GetMasterItem(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("ItemDR",list[1]);
	SetElement("Code",list[2]);
	SetElement("EquipCat",list[4]);
	SetElement("EquipCatDR",list[3]);
	SetElement("EquipType",list[8]);
	SetElement("EquipTypeDR",list[7]);
	SetElement("StatCat",list[10]);
	SetElement("StatCatDR",list[9]);
	SetElement("Unit",list[6]);
	SetElement("UnitDR",list[5]);
	
}
function EquiCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateOpenCheck("","3");
	if (Return=="")
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheck&Type=0&RowID='+Return
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var Return=UpdateOpenCheck("","1");
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheck&RowID='+Return
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked()
{
	if (CheckItemNull(2,"RejectReason")) return;
	var RejectReason=GetElementValue("RejectReason");
	var Return=UpdateOpenCheck(RejectReason,"4");
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAudit_Clicked()
{
	var Type=GetElementValue("Type");
	if (Type=="2")
	{
		if (GetArriveNum()<=0)
		{
			alertShow(t["03"]);
			return;
		}
		var ContractListDR=GetElementValue("ContractListDR");
		var Return=UpdateOpenCheck(ContractListDR,"2");
	}
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var combindata=GetOpinion();
		var Return=UpdateOpenCheck(combindata,"5");
	}
    if (Return>0)
    {
	    window.location.reload(); //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheck&RowID='+Return
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (CheckNull()) return;
	var combindata="";
    combindata=GetElementValue("RowID") ; //1
    combindata=combindata+"^"+GetElementValue("EquipDR") ;//2
	combindata=combindata+"^"+GetElementValue("GroupDR") ;//3
    combindata=combindata+"^"+GetElementValue("ManageLocDR") ;//4
    combindata=combindata+"^"+GetElementValue("UseLocDR") ;//5
    combindata=combindata+"^"+GetElementValue("OpenState") ;//6
    combindata=combindata+"^"+GetElementValue("CheckResultDR") ;//7
    combindata=combindata+"^"+GetElementValue("CheckResultRemark") ;//8
    combindata=combindata+"^"+GetElementValue("CheckUser") ;//9
    combindata=combindata+"^"+GetElementValue("Status") ;//10
    combindata=combindata+"^"+GetElementValue("Remark") ;//11
    combindata=combindata+"^"+GetElementValue("ContractListDR");//12
    combindata=combindata+"^"+GetModelRowID(ModelOperMethod);//   2009-11-11  ZY  ZY0016 GetElementValue("ModelDR");//13
    combindata=combindata+"^"+GetManuFactoryRowID(GetManuFactoryOperMethod);//   2009-11-11  ZY  ZY0016 GetElementValue("ManuFactoryDR");//14
    combindata=combindata+"^"+GetElementValue("UnitDR");//15
    combindata=combindata+"^"+GetElementValue("EquipCatDR");//16
    combindata=combindata+"^"+GetChkElementValue("ComputerFlag");//17
    combindata=combindata+"^"+GetChkElementValue("MedicalFlag");//18
    combindata=combindata+"^"+GetChkElementValue("TestFlag");//19
    combindata=combindata+"^"+GetElementValue("CountryDR");//20
    combindata=combindata+"^"+GetElementValue("LeaveFactoryNo");//21
    combindata=combindata+"^"+GetElementValue("LeaveFactoryDate");//22
    combindata=combindata+"^"+GetProviderRowID(GetProviderOperMethod);//   2009-11-11  ZY  ZY0016 GetElementValue("ProviderDR");//23
    combindata=combindata+"^"+GetElementValue("ProviderHandler");//24
    combindata=combindata+"^"+GetElementValue("ProviderTel");//25
    combindata=combindata+"^"+GetElementValue("OriginalValueFee");//26
    combindata=combindata+"^"+GetElementValue("NetValueFee");//27
    combindata=combindata+"^"+GetElementValue("OriginDR");//28
    combindata=combindata+"^"+GetElementValue("FromDeptDR");//29
    combindata=combindata+"^"+GetElementValue("BuyTypeDR");//30
    combindata=combindata+"^"+GetElementValue("ManageLevelDR");//31
    combindata=combindata+"^"+GetElementValue("EquipTechLevelDR");//32
    combindata=combindata+"^"+GetElementValue("OpenCheckDate");//33
    combindata=combindata+"^"+GetChkElementValue("GuaranteeFlag");//34
    combindata=combindata+"^"+GetElementValue("GuaranteeStartDate");//35
    combindata=combindata+"^"+GetElementValue("GuaranteeEndDate");//36
    combindata=combindata+"^"+GetElementValue("Equip");//37
    combindata=combindata+"^"+GetElementValue("PackTypeDR");//38
    combindata=combindata+"^"+GetElementValue("PackNum");//39
    combindata=combindata+"^"+GetElementValue("EquipNo");//40
    combindata=combindata+"^"+GetElementValue("Code");//41
    combindata=combindata+"^"+GetChkElementValue("UrgencyFlag");//42 
    combindata=combindata+"^"+GetElementValue("EquipTypeDR");//43
    combindata=combindata+"^"+GetElementValue("PurchaseTypeDR");//44
    combindata=combindata+"^"+GetElementValue("PurposeTypeDR");//45
    combindata=combindata+"^"+GetElementValue("KeeperDR");//46
    combindata=combindata+"^"+GetElementValue("ServiceDR");//47
    combindata=combindata+"^"+GetElementValue("ServiceHandler");//48
    combindata=combindata+"^"+GetElementValue("ServiceTel");//49
    combindata=combindata+"^"+GetElementValue("ItemDR");//50
    combindata=combindata+"^"+GetElementValue("StatCatDR");//51
    
    combindata=combindata+"^"+GetElementValue("Hold1");//52
    combindata=combindata+"^"+GetElementValue("Hold2");//53
    combindata=combindata+"^"+GetElementValue("Hold3");//54
    combindata=combindata+"^"+GetElementValue("Hold4");//55
    combindata=combindata+"^"+GetElementValue("Hold5");//56
    
    var Return=UpdateOpenCheck(combindata,"0");
    var ReturnList=Return.split("^");
    var Return=ReturnList[0];
    var EquipDR=ReturnList[1];
    
    if (Return>0)
    {
	    var RowID=GetElementValue("RowID");
	    var ContractList=GetElementValue("ContractListDR")
	    if ((RowID=="")&&(ContractList!=""))
	    {
		    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+EquipDR
    		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	    }
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheck&Type=0&RowID='+Return
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}

function BAffix_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAffix&EquipDR='+GetElementValue("EquipDR")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BPictureInfo_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPicture&EquipDR='+GetElementValue("EquipDR")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function BDoc_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDoc&EquipDR='+GetElementValue("EquipDR")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function GetArriveNum()
{
	var encmeth=GetElementValue("getArriveNum");
	var ContractListDR=GetElementValue("ContractListDR");
	return cspRunServerMethod(encmeth,"","",ContractListDR);
}
function GetContract(value)
{
	SetElement("Equip","");
	SetElement("ItemDR","");
	SetElement("ContractListDR","");
	GetLookUpID("ContractDR",value);
}
function GetModel(value)
{
	GetLookUpID("ModelDR",value);
}
function GetEquipCat(value)
{
	GetLookUpID("EquipCatDR",value);
}
function GetUnit(value)
{
	GetLookUpID("UnitDR",value);
}
function GetCountry(value)
{
	GetLookUpID("CountryDR",value);
}
function GetManuFactory(value)
{
	GetLookUpID("ManuFactoryDR",value);
}
function GetOrigin(value)
{
	GetLookUpID("OriginDR",value);
}
function GetFromDept(value)
{
	GetLookUpID("FromDeptDR",value);
}
function GetBuyType(value)
{
	GetLookUpID("BuyTypeDR",value);
}
function GetManageLoc(value)
{
	GetLookUpID("ManageLocDR",value);
}
function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}
function GetManageLevel(value)
{
	GetLookUpID("ManageLevelDR",value);
}
function GetTechLevel(value)
{
	GetLookUpID("EquipTechLevelDR",value);
}
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetCheckResult(value)
{
	GetLookUpID("CheckResultDR",value);
}
function GetContractList(value)
{
	val=value.split("^");
	SetElement("Equip",val[0]);
	var encmeth=GetElementValue("GetContractListInfo");
	var ValueList=cspRunServerMethod(encmeth,"","",val[1]);
	val=ValueList.split("^");
	SetElement("ContractListDR",val[0]);
	SetElement("ModelDR",val[2]);
	SetElement("Model",val[3]);
	SetElement("ManuFactoryDR",val[4]);
	SetElement("ManuFactory",val[5]);
	SetElement("ProviderDR",val[6]);
	SetElement("Provider",val[7]);
	var obj=document.getElementById("TestFlag")
	if (val[8]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	SetElement("OriginalValueFee",val[9]);
	SetElement("ProviderHandler",val[10]);
	SetElement("ProviderTel",val[11]);
	var obj=document.getElementById("UrgencyFlag")
	if (val[12]=="Y"){
		if (obj) {obj.checked=true;}
		}
	else{
		if (obj) {obj.checked=false;}}
	SetElement("EquipTypeDR",val[13]);
	SetElement("EquipType",val[14]);
	SetElement("PurchaseTypeDR",val[15]);
	SetElement("PurchaseType",val[16]);
	SetElement("PurposeTypeDR",val[17]);
	SetElement("PurposeType",val[18]);
	SetElement("ServiceDR",val[19]);
	SetElement("Service",val[20]);
	SetElement("ServiceHandler",val[21]);
	SetElement("ServiceTel",val[22]);
	SetElement("ItemDR",val[23]);
	SetElement("EquipCatDR",val[24]);
	SetElement("EquipCat",val[25]);
	SetElement("UnitDR",val[26]);
	SetElement("Unit",val[27]);
	SetElement("Code",val[28]);
}
function CheckNull()
{
	var SelectType=GetElementValue("SelectEquipType");
	var Contract=GetElementValue("ContractDR");
	if ((SelectType=="1")||(SelectType==""))
	{
		if (CheckItemNull(1,"Contract")) return true;
	}
	if (Contract!="")
	{
		if (CheckItemNull(2,"ContractListDR","设备名称")) return true;
	}
	if (CheckItemNull(2,"Equip")) return true;
	//2009-10-26 ZY begin ZY0013
	if (CheckMustItemNull("Contract^Equip^Provider^ManuFactory^Model")) return true;
	
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Provider")==true) return true;
		}		
	}
	var obj=document.getElementById("cManuFactory");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetManuFactoryOperMethod")==0)
		{
			if (CheckItemNull(1,"ManuFactory")==true) return true;
		}
		else
		{
			if (CheckItemNull("","ManuFactory")==true) return true;
		}		
	} 
	var obj=document.getElementById("cModel");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetModelOperMethod")==0)
		{
			if (CheckItemNull(1,"Model")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Model")==true) return true;
		}		
	} 
	/*
	if (CheckItemNull(2,"Equip")) return true;
	if (CheckItemNull(1,"EquipCat")) return true;
	if (CheckItemNull(2,"OpenCheckDate")) return true;
	if (CheckItemNull(1,"CheckResult")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	if (CheckItemNull(1,"StatCat")) return true;
	if (CheckItemNull(1,"PurchaseType")) return true;
	*/
	return false;
}
function ValueClear()
{
	//SetElement("EquipDR","");
	//SetElement("ModelDR","");
	//SetElement("Model","");
	//SetElement("ManuFactory","");
	//SetElement("ManuFactoryDR","");
	SetElement("ContractListDR","");
	//SetElement("Provider","");
	//SetElement("ProviderDR","");
	//var obj=document.getElementById("TestFlag");
	//if (obj) obj.checked=false;
	//var obj=document.getElementById("UrgencyFlag");
	//if (obj) obj.checked=false;
	//SetElement("OriginalValueFee","");
	//SetElement("ProviderHandler","");
	//SetElement("ProviderTel","");
	//SetElement("EquipTypeDR","");
	//SetElement("EquipType","");
	//SetElement("PurchaseTypeDR","");
	//SetElement("PurchaseType","");
	//SetElement("PurposeTypeDR","");
	//SetElement("PurposeType","");
	//SetElement("ServiceDR","");
	//SetElement("Service","");
	//SetElement("ServiceHandler","");
	//SetElement("ServiceTel","");
	SetElement("ItemDR","");
}
function GetPackType (value)
{
    GetLookUpID("PackTypeDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetPurposeType (value)
{
    GetLookUpID("PurposeTypeDR",value);
}
function GetKeeper (value)
{
    GetLookUpID("KeeperDR",value);
}
function GetService (value)
{
    GetLookUpID("ServiceDR",value);
}
function UpdateOpenCheck(ValueList,AppType)
{
	var OCRowID=GetElementValue("RowID");
	var encmeth=GetElementValue("upd");
	var EquipDR=GetElementValue("EquipDR");
	var ReturnValue=cspRunServerMethod(encmeth,"","",OCRowID,ValueList,AppType,EquipDR);
	return ReturnValue;
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
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
//--------------------------------判断电话号码/手机号码
function PhoneCheck(s) 
{
 var str=s;
 var reg=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/;
 return reg.test(str);
}

/// 修改:zy 2009-07-15 BugNo.ZY0005
/// 描述:医疗器械验收单及附件打印
/// ----------------------------------
function Print()
{	
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1))
	{
		return;
	}	
	var encmeth=GetElementValue("fillData");
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	encmeth=GetElementValue("fillEquipData");
	var EquipInfo=cspRunServerMethod(encmeth,"","",list[0]);
	var EquipList=EquipInfo.split("^");
	var otherInfo=cspRunServerMethod(GetElementValue("GetList"),RowID);  //取附件数据
	var otherlist=otherInfo.split("@");
	var affixlist=otherlist[0].split("&");
	var doclist=otherlist[1].split("&");
	var affixrows=affixlist.length;
	var sort=54;
	var TemplatePath=GetElementValue("GetRepPath");	
	try {
        	var xlApp,xlsheet,xlBook;
	    	var Template=TemplatePath+"DHCEQCheck.xls";
	    	xlApp = new ActiveXObject("Excel.Application");
		   	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	var row=4;
	    	xlsheet.cells(row,2)=list[sort+0];///设备名称
	    	xlsheet.cells(row+1,2)=list[sort+21];//生产厂家
	    	xlsheet.cells(row+1,4)=list[sort+17];//国别
	    	xlsheet.cells(row+2,2)=list[sort+20];//供应商
	    	xlsheet.cells(row+3,2)=list[sort+13];///规格型号
	    	xlsheet.cells(row+3,4)="1"+list[sort+15];//产品数量
	    	xlsheet.cells(row+4,2)=FormatDate(list[37]);  //生产日期
	    	xlsheet.cells(row+4,4)=list[36];//出厂编号
	    	xlsheet.cells(row+5,2)=list[sort+3]; //使用科室
	    	xlsheet.cells(row+5,4)=EquipList[70]; //资产编号
	    	xlsheet.cells(row+6,2)=EquipList[104]; //用途
	    	xlsheet.cells(row+6,4)=list[44]; //原值
	    	xlsheet.cells(row+7,2)=list[6];//验收结论
	    	xlsheet.cells(row+7,4)=FormatDate(list[38]);  //验收日期(开箱日期)
	    	xlsheet.cells(row+8,1)=list[9];//备注
	    	xlsheet.cells(row+9,1)="工程师签字及公章";//工程师签字及公章
	    	xlsheet.cells(row+9,3)="供应商签字及公章";//供应商签字及公章
	    	xlsheet.cells(row+11,1)="使用科室签字:";//使用科室签字
	    	xlsheet.cells(row+11,3)="设备科签字:";//设备科签字
	    	xlsheet.printout; //打印输出
	   		xlBook.Close (savechanges=false);
	   		xlsheet.Quit;
	    	xlsheet=null;
	    	if ((affixlist!="")&&confirm("是否打印附件?") )   //判断是否有附件
	    	{
		    	var rows=affixrows
	    		var PageRows=40; //每页固定行数
				var Pages=parseInt(rows / PageRows); //总页数-1
				var ModRows=rows%PageRows; //最后一页行数
				if (ModRows==0) Pages=Pages-1;
				try {
	    				var xlApp,xlsheet,xlBook;
	    				var Template=TemplatePath+"DHCEQAffix.xls";
	    				xlApp = new ActiveXObject("Excel.Application")
	    				var Count=0
						var Amount=0
	    				for (var i=0;i<=Pages;i++)
	    				{
							xlBook = xlApp.Workbooks.Add(Template);
	    					xlsheet = xlBook.ActiveSheet;
	    					var OnePageRow=0
	    					if (ModRows==0)
	    					{
		    					OnePageRow=PageRows
	    					}
	    					else
	    					{
	    						if (i==Pages)
	    						{
		    						OnePageRow=ModRows
	    						}
		    					else
		    					{
			    					OnePageRow=PageRows
		    					}
	    					}	    				
		    				for (var k=1;k<=OnePageRow;k++)
		    				{
			    				var l=i*PageRows+k			    				
			    				var affix=affixlist[l-1].split("^")
	    						var row=4;
			    				xlsheet.Rows(row+k).Insert();
			    				xlsheet.cells(3,1)=list[sort+0]+"-"+EquipList[70];
								xlsheet.cells(row+k,1)=affix[0];
								xlsheet.cells(row+k,2)=affix[4];
								xlsheet.cells(row+k,3)=affix[1];								
								if (affix[2]!="")
								{
									xlsheet.cells(row+k,4)=affix[2];
									Count=Count+parseInt(affix[2]);
								}
								else
								{
									xlsheet.cells(row+k,4)=""									
									Count=Count+0;
								}								
								if (affix[3]!="")
								{
									xlsheet.cells(row+k,5)=Number(affix[3]);
									Amount=Amount+xlsheet.cells(row+k,5);
								}
								else
								{
									xlsheet.cells(row+k,5)=""									
									Amount=Amount+0;
								}
		    				}
	    					xlsheet.Rows(row+k+1).Delete();
		    				xlsheet.cells(OnePageRow+5,1)="合计:"
		    				xlsheet.cells(OnePageRow+5,4)=Count;
		    				xlsheet.cells(OnePageRow+5,5)=Amount;
							xlsheet.cells(row+k+1,5)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间    	
		    				xlsheet.printout; //打印输出
	   						xlBook.Close (savechanges=false);
	   						xlsheet.Quit;
	    					xlsheet=null;
	    					xlApp=null;
						}
					} 
				catch(e)
					{
						alertShow(e.message);
					}
	    			xlApp=null;
				} 
				
	}
	catch(e)
		{
			alertShow(e.message);
		}
	}

function BPrint_Click()
{
	Print();
}

document.body.onload = BodyLoadHandler;
