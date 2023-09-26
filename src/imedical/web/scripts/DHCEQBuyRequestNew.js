/// Mozy0041	2011-2-15
/// DHCEQBuyRequestNew.js
///----------------------------------------------------------------
/// modified by GR 2014-09-15 begin  �ж������������̴�web����ǰ��js�� ȱ�ݺ�3118 3211 3215 3194
/// �޸�λ�ã�BApprove_Clicked()
///----------------------------------------------------------------
///modfied by GR 2014-09-15 begin ȱ�ݺ�3127 �豸�ɹ�����-�豸�ɹ�����-�б��е�Ԥ�Ʒ�����ʾ��
/// �޸�λ�ã�GetRequestValue()
///----------------------------------------------------------------
/// Modefied by zc 2014-10-21 
/// �޸�λ��BUpdate_Clicked(),BDelete_Clicked(),BSubmit_Clicked(),BCancelSubmit_Clicked()
/// �رյ�ǰ���游�����Զ�ˢ��
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	FillData();
	IsYear();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetDisplay();
	
	KeyUp("RequestLoc^PurchaseType^PurposeType^BRLModel^UseLoc^BRLManuFactory^BRLCurrency^EquipType","N");
	Muilt_LookUp("BRLName^RequestLoc^PurchaseType^PurposeType^BRLModel^UseLoc^BRLManuFactory^BRLCurrency^EquipType");
	
	///ReplaceTitle("�豸","�Ҿ�");
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
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BArgumentation");
	if (obj) obj.onclick=BArgumentation_Clicked;
	
	var obj=document.getElementById("YearFlag")
	if (obj) obj.onchange=IsYear;
	var obj=document.getElementById("BRLPriceFee");
	if (obj) obj.onchange=SetFeeByPriceFee;
	var obj=document.getElementById("BRLRequestNum");	//2013-11-01 DJ0120
	if (obj) obj.onchange=SetTotal;
	
	// Mozy0047	2011-3-22
	var obj=document.getElementById("BRDMaterial");
	if (obj) obj.onchange=SetTotalCostFee;
	var obj=document.getElementById("BRDYearMaintFee");
	if (obj) obj.onchange=SetTotalCostFee;
	var obj=document.getElementById("BRDFeeOfEmployee");
	if (obj) obj.onchange=SetTotalCostFee;
	var obj=document.getElementById("BRDFeeOfMaterial");
	if (obj) obj.onchange=SetTotalCostFee;
	//add by zy 2012-12-25 zy0103
	var obj=document.getElementById("BALter");
	if (obj) obj.onclick=BALter_click;
	//20150822  Mozy0162	������հ�ť
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BRDYearIncomeFee");	/// 20150918  Mozy0166
	if (obj) obj.onchange=SetReclaimYearsNum;
	
	// 2015-09-28 ZY0144  �Զ���д��Ŀ����
	var obj=document.getElementById("CommonName");
	if (obj) obj.onchange=CommonName;
}
// 2015-09-28 ZY0144  �Զ���д��Ŀ����
function CommonName()
{
	var CommonName=GetElementValue("CommonName")
	var PrjName=GetElementValue("PrjName");		//Add By DJ 2016-12-01
	if (PrjName=="")
	{
		SetElement("PrjName",CommonName);
	}
}
function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1))	return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID,GetElementValue("CurRole"));
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("@");
	
	var valueRequest=list[0].split("^");
	//alertShow(RowID);
	var sortRequest=45;
	SetElement("PrjName",valueRequest[0]);
	SetElement("RequestLocDR",valueRequest[1]);
	SetElement("RequestLoc",valueRequest[sortRequest+0]);
	SetChkElement("YearFlag",valueRequest[2]);
	SetElement("UseLocDR",valueRequest[3]);
	SetElement("UseLoc",valueRequest[sortRequest+1]);
	SetElement("Year",valueRequest[4]);
	SetElement("RequestDate",valueRequest[5]);
	//SetChkElement("GatherFlag",valueRequest[6]);
	SetElement("QuantityNum",valueRequest[7]);
	SetElement("TotalFee",valueRequest[8]);
	/*SetElement("SubmitUserDR",valueRequest[9]);
	SetElement("SubmitUser",valueRequest[sortRequest+2]);
	SetElement("SubmitDate",valueRequest[10]);
	SetElement("SubmitTime",valueRequest[11]);
	SetElement("AuditUserDR",valueRequest[12]);
	SetElement("AuditUser",valueRequest[sortRequest+3]);
	SetElement("AuditDate",valueRequest[13]);
	SetElement("AuditTime",valueRequest[14]);*/
	SetElement("Status",valueRequest[15]);
	SetElement("Hold1",valueRequest[16]);
	SetElement("Hold2",valueRequest[17]);
	SetElement("Hold3",valueRequest[18]);
	SetElement("Hold4",valueRequest[19]);
	SetElement("Hold5",valueRequest[20]);
	SetElement("Hold6",valueRequest[21]);
	SetElement("Hold7",valueRequest[22]);
	SetElement("Hold8",valueRequest[23]);
	SetElement("EquipTypeDR",valueRequest[24]);
	SetElement("EquipType",valueRequest[sortRequest+4]);
	SetElement("PurchaseTypeDR",valueRequest[25]);
	SetElement("PurchaseType",valueRequest[sortRequest+5]);
	SetElement("Remark",valueRequest[26]);
	SetElement("AuditOpinion",valueRequest[sortRequest+20]);
	
	encmeth=GetElementValue("GetApproveByRource");
	var ApproveListInfo=cspRunServerMethod(encmeth,"1",RowID);
	
	FillEditOpinion(ApproveListInfo,"EditOpinion")
	
	SetElement("OpinionRemark",valueRequest[sortRequest+7]);
	SetElement("AddUserDR",valueRequest[27]);
	SetElement("AddUser",valueRequest[sortRequest+6]);
	/*
	SetElement("AddDate",valueRequest[28]);
	SetElement("AddTime",valueRequest[29]);
	SetElement("UpdateUserDR",valueRequest[30]);
	SetElement("UpdateUser",valueRequest[sortRequest+7]);
	SetElement("UpdateDate",valueRequest[31]);
	SetElement("UpdateTime",valueRequest[32]);*/
	SetElement("LocOpinion",valueRequest[33]);
	SetElement("RequestNo",valueRequest[34]);
	SetChkElement("UrgencyFlag",valueRequest[35]);
	SetElement("RejectReason",valueRequest[36]);
	/*SetElement("RejectUserDR",valueRequest[37]);
	SetElement("RejectUser",valueRequest[sortRequest+8]);
	SetElement("RejectDate",valueRequest[38]);
	SetElement("RejectTime",valueRequest[39]);*/
	SetElement("PurposeTypeDR",valueRequest[40]);
	SetElement("PurposeType",valueRequest[sortRequest+9]);
	//alertShow(valueRequest[sortRequest+16])
	SetElement("ApproveSetDR",valueRequest[sortRequest+11]);
	SetElement("NextRoleDR",valueRequest[sortRequest+12]);
	SetElement("NextFlowStep",valueRequest[sortRequest+13]);
	SetElement("ApproveStatus",valueRequest[sortRequest+14]);
	SetElement("ApproveRoleDR",valueRequest[sortRequest+15]);
	SetElement("CancelFlag",valueRequest[sortRequest+16]);
	SetElement("CancelToFlowDR",valueRequest[sortRequest+17]);
	
	var valueRequestList=list[1].split("^");
	var sortRequestList=32;	//2013-11-01 DJ0120
	//alertShow(valueRequestList[sortRequestList+1])
	SetElement("BRLRowID",valueRequestList[0]);
	SetElement("BRLName",valueRequestList[sortRequestList+8]); //2013-06-24 DJ0118
	SetElement("BRLModelDR",valueRequestList[3]);
	SetElement("BRLModel",valueRequestList[sortRequestList+0]);
	SetElement("BRLManuFactoryDR",valueRequestList[4]);
	SetElement("BRLManuFactory",valueRequestList[sortRequestList+1]);
	SetChkElement("BRLTestFlag",valueRequestList[5]);
	SetElement("BRLPriceFee",valueRequestList[6]);
	SetElement("BRLQuantityNum",valueRequestList[7]);
	SetElement("BRLTotalFee",valueRequestList[8]);
	SetElement("BRLRemark",valueRequestList[9]);
	/*SetElement("UpdateUserDR",valueRequestList[10]);
	SetElement("UpdateUser",valueRequestList[sortRequestList+2]);
	SetElement("UpdateDate",valueRequestList[11]);
	SetElement("UpdateTime",valueRequestList[12]);
	SetElement("BuyPlanDR",valueRequestList[13]);
	SetElement("BuyPlan",valueRequestList[sortRequestList+3]);
	*/
	SetElement("BRLCurrencyDR",valueRequestList[14]);
	SetElement("BRLCurrency",valueRequestList[sortRequestList+4]);
	SetElement("BRLEquipCatDR",valueRequestList[15]);
	SetElement("BRLEquipCat",valueRequestList[sortRequestList+5]);
	SetElement("BRLHold1",valueRequestList[16]);
	SetElement("BRLItemDR",valueRequestList[17]);
	SetElement("BRLRequestReason",valueRequestList[18]);
	SetElement("BRLArriveDate",valueRequestList[19]);
	SetElement("BRLRequestNum",valueRequestList[20]);	//2013-11-01 DJ0120 begin
	SetElement("BRLHold1",valueRequestList[27]);
	SetElement("BRLHold2",valueRequestList[28]);
	SetElement("BRLHold3",valueRequestList[29]);
	SetElement("BRLHold4",valueRequestList[30]);
	SetElement("BRLHold5",valueRequestList[31]);
	//SetElement("BRLHold6",valueRequestList[32]);	//2013-11-01 DJ0120 end
	SetElement("StatCat",valueRequestList[sortRequestList+6]);
	SetElement("Unit",valueRequestList[sortRequestList+7]);
	SetElement("CommonName",valueRequestList[2]); //2013-06-24 DJ0118
	
	var valueRequestDetail=list[2].split("^");
	var sortRequestDetail=29;
	//alertShow(valueRequestList[sortRequestDetailt+1])
	SetElement("BRDRowID",valueRequestDetail[0]);
	SetElement("BRDMaterial",valueRequestDetail[2]);
	SetElement("BRDOperatorCount",valueRequestDetail[3]);
	SetElement("BRDMedicalItem",valueRequestDetail[4]);
	SetElement("BRDConsumption",valueRequestDetail[5]);
	SetElement("BRDYearRunTime",valueRequestDetail[6]);
	SetElement("BRDRatingPower",valueRequestDetail[7]);
	SetElement("BRDCountInLoc",valueRequestDetail[8]);
	SetElement("BRDDepreLimitYear",valueRequestDetail[9]);
	SetElement("BRDFeeOfEmployee",valueRequestDetail[10]);
	SetElement("BRDFeeOfDepre",valueRequestDetail[11]);
	SetElement("BRDFeeOfMaterial",valueRequestDetail[12]);
	SetElement("BRDUsePerWeekNum",valueRequestDetail[13]);
	SetElement("BRDWorkLoadPerWeekNum",valueRequestDetail[14]);
	SetElement("BRDUsePriceFee",valueRequestDetail[15]);
	SetElement("BRDUseYearsNum",valueRequestDetail[16]);
	SetElement("BRDReclaimYearsNum",valueRequestDetail[17]);
	SetElement("BRDCountNum",valueRequestDetail[18]);
	SetElement("BRDUseRate",valueRequestDetail[19]);
	SetElement("BRDGoodRate",valueRequestDetail[20]);
	SetElement("BRDYearIncomeFee",valueRequestDetail[21]);
	SetElement("BRDCostFee",valueRequestDetail[22]);
	SetElement("BRDYearMaintFee",valueRequestDetail[23]);
	SetElement("BRDAdviseModel",valueRequestDetail[24]);
	SetElement("BRDHold1",valueRequestDetail[25]);
	SetElement("BRDHold2",valueRequestDetail[26]);
	SetElement("BRDHold3",valueRequestDetail[27]);
	SetElement("BRDHold4",valueRequestDetail[28]);
	SetElement("BRDHold5",valueRequestDetail[29]);
	
	var valueArgumentation=list[3].split("^");
	if (list[3]=="") return;
	var sortArgumentation=35;
	//alertShow(valueArgumentation[4])
	SetElement("ARRowID",valueArgumentation[0]);
	SetElement("ARProductIntroduce",valueArgumentation[2]);
	SetElement("ARActuality",valueArgumentation[3]);
	SetElement("ARBuyReason",valueArgumentation[4]);
	SetElement("ARAffectAnalyse",valueArgumentation[5]);
	SetElement("ARCondition",valueArgumentation[6]);
	SetElement("ARService",valueArgumentation[7]);
	SetElement("ARRejectReason",valueArgumentation[8]);
	/*SetElement("ARRejectUserDR",valueArgumentation[9]);
	SetElement("ARRejectDate",valueArgumentation[10]);
	SetElement("ARRejectTime",valueArgumentation[11]);*/
	SetElement("ARRemark",valueArgumentation[12]);
	SetElement("ARStatus",valueArgumentation[13]);
	/*SetElement("ARAddUserDR",valueArgumentation[14]);
	SetElement("ARAddDate",valueArgumentation[15]);
	SetElement("ARAddTime",valueArgumentation[16]);
	SetElement("ARSubmitUserDR",valueArgumentation[17]);
	SetElement("ARSubmitDate",valueArgumentation[18]);
	SetElement("ARSubmitTime",valueArgumentation[19]);
	SetElement("ARAuditUserDR",valueArgumentation[20]);
	SetElement("ARAuditDate",valueArgumentation[21]);
	SetElement("ARAuditTime",valueArgumentation[22]);*/
	SetElement("ARClinicEffect",valueArgumentation[23]);
	SetElement("ARSettleState",valueArgumentation[24]);
	SetElement("ARResourceState",valueArgumentation[25]);
	SetElement("ARPolluteState",valueArgumentation[26]);
	SetElement("AROtherState",valueArgumentation[27]);
	SetElement("ARPersonnelState",valueArgumentation[28]);
	SetElement("ARIncome",valueArgumentation[29]);
	SetElement("AREffect",valueArgumentation[30]);
	SetElement("ARHold1",valueArgumentation[31]);
	SetElement("ARHold2",valueArgumentation[32]);
	SetElement("ARHold3",valueArgumentation[33]);
	SetElement("ARHold4",valueArgumentation[34]);
	SetElement("ARHold5",valueArgumentation[35]);
}
function SetEnabled()
{
	var flag=true;
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BPrint",true);
		flag=false;
	}
	if (Status==0)
	{
		flag=false;
	}
	if ((Status==1)||(Status==2))
	{
		if (Status==1) SetElement("EditOpinion","ͬ��");	//2013-06-24 DJ0118
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BClear",true);	//20150822  Mozy0162	������հ�ť
		// ������������Ƿ�����֤�༭�ֶ�
		var encmeth=GetElementValue("GetReqFields");
		var GetValue=cspRunServerMethod(encmeth,GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
		//alertShow(GetValue)
		if (GetValue!="")
		{
			var Fields=GetValue.split("^");
			var Len=Fields.length;
			for (var i=0;i<Len;i++)
			{
				var infor=Fields[i];
				var infor=infor.split(",");
				if (trim(infor[2])=="DHC_EQArgumentation")
				{
					//alertShow(infor[3])	// �������õı�����
					flag=false;
				}
			}
		}
		// �Ƿ�����֤��Ϣ
		var encmeth=GetElementValue("GetArgumentation");
		var GetValue=cspRunServerMethod(encmeth,GetElementValue("RowID"));
		//alertShow(GetValue)
		if (GetValue=="1")
		{
			flag=false;
		}
	}

	// �Ƿ���˶����Ѿ����
	if (GetElementValue("ApproveSetDR")!="")
	{
		var nextStep=GetElementValue("NextFlowStep");
		var curRole=GetElementValue("CurRole");
		var nextRole=GetElementValue("NextRoleDR");
		//alertShow(nextStep+","+curRole+","+nextRole+","+flag)
		if (curRole!=nextRole) flag=true;
		if ((WaitAD!="off")&&(curRole=="")) flag=true;
	}
	DisableBElement("BArgumentation",flag);
	
	if (WaitAD=="on")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BClear",true);	//20150822  Mozy0162	������հ�ť
		DisableBElement("BCreatePlan",true);
		DisableBElement("BAppendFile",true);
		//DisableBElement("BPrint",true);
	}
}
function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("PrjName"),GetElementValue("Status"));
	ReadOnlyElements("RequestNo^StatCat^BRLEquipCat^BRLTotalFee^Unit^AuditOpinion^BRDUseYearsNum^BRDFeeOfDepre^BRDCostFee",true)
	if (GetElementValue("Status")<1)
	{
		ReadOnlyElement("BRLQuantityNum",true);
	}
	else
	{
		//ReadOnlyElement("BRLQuantityNum",false);
	}
}

function BUpdate_Clicked()
{
	if (CheckNull()) return;
	//2013-06-24 DJ0118
	var Model=GetElementValue("BRLModel");
	if (Model!="")
	{
		var ItemDR=GetElementValue("BRLItemDR");
		var encmeth=GetElementValue("UpdModel");
		var RModelDR=cspRunServerMethod(encmeth,Model,ItemDR);
	    if (RModelDR<=0)
	    {
		    alertShow("����ͺŵǼǴ���!")
		    return
	    }
	    else
	    {
		    SetElement("BRLModelDR",RModelDR)
	    }
	}
	if (IsVaildYear()) return;
	var RequestValue=GetRequestValue();
	var ListValue=GetListValue();
	var DetailValue=PackageData("BRDMaterial^BRDOperatorCount^BRDMedicalItem^BRDConsumption^BRDYearRunTime^BRDRatingPower^BRDCountInLoc^BRDDepreLimitYear^BRDFeeOfEmployee^BRDFeeOfDepre^BRDFeeOfMaterial^BRDUsePerWeekNum^BRDWorkLoadPerWeekNum^BRDUsePriceFee^BRDUseYearsNum^BRDReclaimYearsNum^BRDCountNum^BRDUseRate^BRDGoodRate^BRDYearIncomeFee^BRDCostFee^BRDYearMaintFee^BRDAdviseModel^BRDHold1^BRDHold2^BRDHold3^BRDHold4^BRDHold5");
	//alertShow(DetailValue)
    var Return=UpdateBuyRequest(RequestValue,ListValue,DetailValue,"0");
    //alertShow(Return)
    var list=Return.split("^");
	if (list[1]!="0")
	{
		alertShow("�����쳣   "+list[1])
	}
	else
	{
		if (list[0]>0)
		{
			//add by HHM 20150910 HHM0013
			//���ҵ�񵥾ݲ����ɹ����Ƿ���ʾ
			ShowMessage();
			//***************************************
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew&RowID='+list[0]+"&WaitAD=off"+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	    	window.opener.location.reload();  //Modefied by zc 2014-10-21 zc0015
		}
		else
		{
			alertShow(t["01"])
		}
	}
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateBuyRequest("","","","1");
    var list=Return.split("^");
	if (list[1]!="0")
	{
		alertShow("�����쳣   "+list[1])
	}
	else
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew'+"&YearFlag="+GetElementValue("YearFlag");//modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	    window.opener.location.reload();   //Modefied by zc 2014-10-21 zc0015
	}
}

function BSubmit_Clicked()
{
	var encmeth=GetElementValue("CheckArgumentation");
	var Check=cspRunServerMethod(encmeth,GetElementValue("RowID"));
	if (Check!=0)
	{
		alertShow(Check);
		return;
	}
	var combindata=GetAuditData();
  	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&YearFlag="+GetElementValue("YearFlag");  //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	     window.opener.location.reload();  //Modefied by zc 2014-10-21 zc0015
	}
    else
    {
	    alertShow(t[rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() 
{
	if (CheckItemNull(2,"RejectReason")) return;
	var combindata=GetAuditData();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	//Modified by jdl 2011-3-17  jdl0073
	var rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD")+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	     window.opener.location.reload();   //Modefied by zc 2014-10-21 zc0015
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}
function GetAuditData()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("EditOpinion");
  	ValueList=ValueList+"^"+GetElementValue("OpinionRemark");
	ValueList=ValueList+"^"+GetElementValue("RejectReason");
	
	return ValueList;
}
function BApprove_Clicked()
{
	//modified by GR 2014-09-15 begin  �ж������������̴�web����ǰ��js�� ȱ�ݺ�3118 3211 3215 
	var BRLQuantityNum=parseInt(GetElementValue("BRLQuantityNum"))
	var BRLRequestNum=parseInt(GetElementValue("BRLRequestNum"))
	//if (!(BRLQuantityNum>0&&BRLQuantityNum<=BRLRequestNum)) {alertShow(t[-1002]);return;}		//Modify DJ 2015-09-14 DJ0164
	//modified by GR 2014-09-15 end
	if (CheckItemNull(2,"EditOpinion")) return;
	var combindata=GetAuditData();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep");
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQBuyRequestNew');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
	//alertShow(combindata+","+CurRole+","+RoleStep+","+EditFieldsInfo+","+rtn)
    if (rtn>0)
    {
	    window.location.reload();
	    //modified by GR 2015-07-09 ȱ�ݺ�3118 ���Ӷ�window.opener���
	    if (window.opener!=undefined) window.opener.location.reload();   //Modefied by zc 2014-10-21 zc0015
	}
    else
    {
	    if (rtn=="-1002")
	    {
		    alertShow(t[rtn]);
	    }
	    alertShow(t["01"]);
    }
}
// Mozy0041	2011-2-14
function BArgumentation_Clicked()
{
	var BRLRowID=GetElementValue("BRLRowID");
	if (BRLRowID=="")
	{
		alertShow("�޲ɹ������豸��Ϣ!");
		return;
	}
	var BRDRowID=GetElementValue("BRDRowID");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQArgumentationNew&BRRowID='+GetElementValue("RowID")+'&BRLRowID='+BRLRowID+'&BRDRowID='+BRDRowID+'&ApproveSetDR='+GetElementValue("ApproveSetDR")+'&CurRole='+GetElementValue("CurRole")+'&Status='+GetElementValue("Status")+'&WaitAD='+GetElementValue("WaitAD");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=640,left=80,top=0')
}
function UpdateBuyRequest(RequestValue,ListValue,DetailValue,AppType)
{
	var RowID=GetElementValue("RowID");
	RequestValue=RowID+"^"+RequestValue;
	//alertShow(ValueList)
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,RequestValue,ListValue,DetailValue,AppType);
	return ReturnValue;
}
function GetRequestValue()
{
	var combindata="";
  	combindata=combindata+GetElementValue("PrjName");
	combindata=combindata+"^"+GetElementValue("RequestLocDR");
	//modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
	if (GetElementValue("YearFlag")=="Y")
	{
		YearFlag=1
	}else
	{
		YearFlag=0
	}
	combindata=combindata+"^"+YearFlag;
	combindata=combindata+"^"+GetElementValue("UseLocDR");
	combindata=combindata+"^"+GetElementValue("Year");
	combindata=combindata+"^"+GetElementValue("RequestDate");
	combindata=combindata+"^";	///+GetChkElementValue("GatherFlag");
	SetElement("QuantityNum",GetElementValue("BRLRequestNum"));//modfied by GR 2014-09-15 begin ȱ�ݺ�3127 �豸�ɹ�����-�豸�ɹ�����-�б��е�Ԥ�Ʒ�����ʾ��
	combindata=combindata+"^"+GetElementValue("QuantityNum");
	var TotalFee=GetElementValue("BRLTotalFee");
	combindata=combindata+"^"+TotalFee;	///+GetElementValue("BRLTotalFee");//modfied by GR 2014-09-15 end
	combindata=combindata+"^"+GetElementValue("Hold1");
	combindata=combindata+"^"+GetElementValue("Hold2");
	combindata=combindata+"^"+GetElementValue("Hold3");
	combindata=combindata+"^"+GetElementValue("Hold4");
	combindata=combindata+"^"+GetElementValue("Hold5");
	combindata=combindata+"^"+GetElementValue("Hold6");
	combindata=combindata+"^"+GetElementValue("Hold7");
	combindata=combindata+"^"+GetElementValue("Hold8");
	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("LocOpinion");
	combindata=combindata+"^"+GetElementValue("RequestNo");
	combindata=combindata+"^"+GetChkElementValue("UrgencyFlag");
	combindata=combindata+"^"+GetElementValue("PurposeTypeDR");
	combindata=combindata+"^"+GetElementValue("AddUserDR"); //Add By DJ 2011-10-26 DJ0097
	combindata=combindata+"^"+GetElementValue("RejectReason"); //Add By DJ 2013-06-24 DJ0118
  	return combindata;
}
function GetListValue()
{
	var combindata="";
	combindata=combindata+GetElementValue("BRLName");
	combindata=combindata+"^"+GetElementValue("BRLModelDR");
	combindata=combindata+"^"+GetElementValue("BRLManuFactoryDR");
	combindata=combindata+"^"+GetElementValue("BRLTestFlag");
	combindata=combindata+"^"+GetElementValue("BRLPriceFee");
	combindata=combindata+"^";
	if (GetElementValue("BRLQuantityNum")!="")
	{	combindata=combindata+parseInt(GetElementValue("BRLQuantityNum"));}
	combindata=combindata+"^"+GetElementValue("BRLTotalFee");
	combindata=combindata+"^"+GetElementValue("BRLRemark");
	combindata=combindata+"^";		//+GetElementValue("BuyPlanDR")
	combindata=combindata+"^"+GetElementValue("BRLCurrencyDR");
	combindata=combindata+"^"+GetElementValue("BRLEquipCatDR");
	combindata=combindata+"^";	//2013-11-01 DJ0120
	combindata=combindata+"^"+GetElementValue("BRLItemDR");
	combindata=combindata+"^"+GetElementValue("BRLRequestReason");
	combindata=combindata+"^"+GetElementValue("BRLArriveDate");
	combindata=combindata+"^"+GetElementValue("BRLRequestNum");	//2013-11-01 DJ0120 begin
	combindata=combindata+"^"+GetElementValue("BRLHold1");
	combindata=combindata+"^"+GetElementValue("BRLHold2");
	combindata=combindata+"^"+GetElementValue("BRLHold3");
	combindata=combindata+"^"+GetElementValue("BRLHold4");
	combindata=combindata+"^"+GetElementValue("BRLHold5");	//2013-11-01 DJ0120 end
	combindata=combindata+"^"+GetElementValue("CommonName");	//2013-06-24 DJ0118
  	return combindata;
}
/*
function GetDetailValue()
{
	var combindata="";
	combindata=combindata+GetElementValue("BRDMaterial");
	combindata=combindata+"^"+GetElementValue("BRDOperatorCount");
	combindata=combindata+"^"+GetElementValue("BRDMedicalItem");
	combindata=combindata+"^"+GetElementValue("BRDConsumption");
	combindata=combindata+"^"+GetElementValue("BRDYearRunTime");
	combindata=combindata+"^"+GetElementValue("BRDRatingPower");
	combindata=combindata+"^"+GetElementValue("BRDCountInLoc");
	combindata=combindata+"^"+GetElementValue("BRDDepreLimitYear");
	combindata=combindata+"^"+GetElementValue("BRDFeeOfEmployee");
	combindata=combindata+"^"+GetElementValue("BRDFeeOfDepre");
	combindata=combindata+"^"+GetElementValue("BRDFeeOfMaterial");
	combindata=combindata+"^"+GetElementValue("BRDUsePerWeekNum");
	combindata=combindata+"^"+GetElementValue("BRDWorkLoadPerWeekNum");
	combindata=combindata+"^"+GetElementValue("BRDUsePriceFee");
	combindata=combindata+"^"+GetElementValue("BRDUseYearsNum");
	combindata=combindata+"^"+GetElementValue("BRDReclaimYearsNum");
	combindata=combindata+"^"+GetElementValue("BRDCountNum");
	combindata=combindata+"^"+GetElementValue("BRDUseRate");
	combindata=combindata+"^"+GetElementValue("BRDGoodRate");
	combindata=combindata+"^"+GetElementValue("BRDYearIncomeFee");
	combindata=combindata+"^"+GetElementValue("BRDCostFee");
	combindata=combindata+"^"+GetElementValue("BRDYearMaintFee");
	combindata=combindata+"^"+GetElementValue("BRDAdviseModel");
	combindata=combindata+"^"+GetElementValue("BRDHold1");
	combindata=combindata+"^"+GetElementValue("BRDHold2");
	combindata=combindata+"^"+GetElementValue("BRDHold3");
	combindata=combindata+"^"+GetElementValue("BRDHold4");
	combindata=combindata+"^"+GetElementValue("BRDHold5");

  	return combindata;
}*/
function SetTotal()
{
	var PriceFee=parseFloat(+GetElementValue("BRLPriceFee"));	
	//var QuantityNum=GetElementValue("QuantityNum");			// ���뵥����
	var QuantityNum=+GetElementValue("BRLRequestNum");			// ��ϸ������	2013-11-01 DJ0120
	//Mozy0049	2011-3-30
	if (IsValidateNumber(PriceFee,1,1,0,1)==0)
	{
		alertShow("Ԥ�㵥�������쳣,������.");
		//SetElement("BRLPriceFee","");
		return;
	}
	if (IsValidateNumber(QuantityNum,1,0,0,0)==0)    //modify by mwz 2017-10-25 �����467117
	{
		alertShow("�豸���������쳣,������.");
		//SetElement("QuantityNum","");
		//SetElement("BRLQuantityNum","");
		return;
	}
	var fee=PriceFee*QuantityNum;
	SetElement("BRLTotalFee",fee.toFixed(2));
}
function SetFeeOfDepre()
{
	var UseYearsNum=+GetElementValue("BRDUseYearsNum");
	if (IsValidateNumber(UseYearsNum,0,1,0,0)==0) return;
	var PriceFee=+GetElementValue("BRLPriceFee");
	if (IsValidateNumber(PriceFee,0,1,0,0)==0) return;
	UseYearsNum=parseFloat(UseYearsNum);
	PriceFee=parseFloat(PriceFee);
	var depre=PriceFee/UseYearsNum;
	SetElement("BRDFeeOfDepre",depre.toFixed(2));
}
function SetFeeByPriceFee()
{
	SetTotal();
	SetFeeOfDepre();
	SetTotalCostFee();
	SetReclaimYearsNum();	//Add By DJ 2016-12-02
}
// Mozy0047	2011-3-22
function SetTotalCostFee()
{
	var Material=+GetElementValue("BRDMaterial");
	if (IsValidateNumber(Material,1,1,0,1)==0)
	{
		alertShow("�Ĳķ��������쳣,������.");
		return;
	}
	if (Material=="") Material=0;
	Material=parseFloat(Material);
	var YearMaintFee=+GetElementValue("BRDYearMaintFee");
	if (IsValidateNumber(YearMaintFee,1,1,0,1)==0)
	{
		alertShow("ά�޷������쳣,������.");
		return;
	}
	if (YearMaintFee=="") YearMaintFee=0;
	YearMaintFee=parseFloat(YearMaintFee);
	var FeeOfEmployee=+GetElementValue("BRDFeeOfEmployee");
	if (IsValidateNumber(FeeOfEmployee,1,1,0,1)==0)
	{
		alertShow("��Ա���������쳣,������.");
		return;
	}
	if (FeeOfEmployee=="") FeeOfEmployee=0;
	FeeOfEmployee=parseFloat(FeeOfEmployee);
	var FeeOfMaterial=+GetElementValue("BRDFeeOfMaterial");
	if (IsValidateNumber(FeeOfMaterial,1,1,0,1)==0)
	{
		alertShow("ˮ��ȷ��������쳣,������.");
		return;
	}
	if (FeeOfMaterial=="") FeeOfMaterial=0;
	FeeOfMaterial=parseFloat(FeeOfMaterial);
	
	var FeeDepre=0;
	if (GetElementValue("BRDFeeOfDepre")!="") FeeDepre=GetElementValue("BRDFeeOfDepre");
	FeeDepre=parseFloat(FeeDepre);
	SetElement("BRDCostFee",Material+YearMaintFee+FeeOfEmployee+FeeOfMaterial+FeeDepre);
	SetReclaimYearsNum();	//Add By DJ 2016-12-02
}

function IsYear()
{
	//modified by  ZY 2015-09-28 ZY0144  �����������������Ԫ��Year��cYear��ʾ
	var YearFlag=GetElementValue("YearFlag");
	if (YearFlag=="Y")
	{
		HiddenObj("YearFlag",1)
		var Year=new Date();
		Year=Year.getFullYear()+1;
		SetElement("Year",Year)
		DisableElement("Year",true);
	}
	else
	{
		HiddenObj("Year",1);
		HiddenObj("cYear",1);
		//DisableElement("Year",true);
		//SetElement("Year","");
	}
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
		if (CheckItemNull(2,"Year","���")) return true;
	}
	return false;
}
function GetMasterItem(value)
{
	var ReturnList=value.split("^");
	SetElement("BRLName",ReturnList[0]);
	SetElement("BRLItemDR",ReturnList[1]);
	SetElement("BRLEquipCatDR",ReturnList[3]);
	SetElement("BRLEquipCat",ReturnList[4]);
	SetElement("UnitDR",ReturnList[5]);
	SetElement("Unit",ReturnList[6]);
	SetElement("EquipTypeDR",ReturnList[7]);
	SetElement("EquipType",ReturnList[8]);
	SetElement("StatCatDR",ReturnList[9]);
	SetElement("StatCat",ReturnList[10]);
	SetElement("BRDUseYearsNum",ReturnList[13]);
	SetElement("CommonName",ReturnList[0]); 	//2013-06-24 DJ0118
	if (GetElementValue("PrjName")=="") SetElement("PrjName",ReturnList[0]);	/// 20150918  Mozy0166	�Զ������Ŀ����
	GetCountInLoc();		//Add By DJ 2015-08-21 DJ0157
	SetFeeOfDepre();
}

//�豸�ɹ�����	��ӡ
function BPrint_Clicked()
{
	//alertShow("����ʵ����...");
	//return;
	try
	{
		//û�б��淵��
		var RowID=GetElementValue("RowID");
		if (RowID=="") return;
		//û����ϸ����
		var encmeth=GetElementValue("GetDetail");
		var Result=cspRunServerMethod(encmeth,RowID);
		if (Result=="")
		{
			alertShow("����ϸ�ɴ�ӡ!")
			return;
		}
		var encmeth=GetElementValue("GetRepPath");
		var TemplatePath=cspRunServerMethod(encmeth);
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQBuyRequestSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;
	    //xlsheet.PageSetup.RightMargin=0;
		var RequestLoc=GetElementValue("RequestLoc");
		var RequestLoc=GetShortName(RequestLoc,"-");
		var RequestDate=GetElementValue("RequestDate");
		var YearFlag=GetChkElementValue("YearFlag");
		var YearPlan="����ȼƻ�"
		if (YearFlag) {YearPlan="��ȼƻ�";}
		var RequestNo=GetElementValue("RequestNo");
		var Year=ChangeDateFormat(RequestDate);
		xlsheet.cells(2,1)=xlsheet.cells(2,1)+" "+RequestLoc;
		xlsheet.cells(2,3)=xlsheet.cells(2,3)+" "+RequestNo;
		xlsheet.cells(2,6)=Year;
		xlsheet.cells(3,1)=xlsheet.cells(3,1)+" "+GetElementValue("PrjName");
		xlsheet.cells(3,3)=xlsheet.cells(3,3)+" "+YearPlan
		xlsheet.cells(3,6)=GetElementValue("EquipType");
		var ResultList=Result.split("^");
		var BRLTotal=ResultList.length;
		var StartRow=5;
		var List=0;
		var encmeth=GetElementValue("GetOneDetail");
		var sort=24; //2011-10-26 DJ DJ0097
		for (List=0;List<BRLTotal;List++)
		{
			var BRLID=ResultList[List];
			var OneDetail=cspRunServerMethod(encmeth,"","",BRLID);
			var OneList=OneDetail.split("^");
			var Row=StartRow+List;
			xlsheet.Rows(Row).Insert();
			xlsheet.cells(Row,1)=OneList[1];
			xlsheet.cells(Row,2)=OneList[sort+1];
			xlsheet.cells(Row,3)=OneList[sort+6];
			xlsheet.cells(Row,4)=OneList[sort+2];
			xlsheet.cells(Row,5)=OneList[6];
			xlsheet.cells(Row,6)=OneList[5];
			xlsheet.cells(Row,7)=OneList[7];
		}
		xlsheet.cells(Row+1,1)="�ϼ�";
		xlsheet.cells(Row+1,5)=GetElementValue("QuantityNum");
		xlsheet.cells(Row+1,7)=GetElementValue("BRLTotalFee");
		xlsheet.cells(Row+2,5)=xlsheet.cells(Row+2,5)+" "+GetElementValue("AddUser");
		xlsheet.printout; //��ӡ���
	    //xlBook.SaveAs("D:\\DHCEQBuyRequest.xls");
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
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
    GetCountInLoc();		//Add By DJ 2015-08-21 DJ0157
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetPurposeType (value)
{ 
    GetLookUpID("PurposeTypeDR",value);
}
function GetModel (value)
{
    GetLookUpID("BRLModelDR",value);
}
function GetCurrencyDR(value)
{
	GetLookUpID("BRLCurrencyDR",value);
}
function GetBRLManuFactoryID(value)
{
	GetLookUpID("BRLManuFactoryDR",value);
}
function GetUser(value)
{
	GetLookUpID("AddUserDR",value);
}
//add by zy 2012-12-25 zy0103
function BALter_click()
{
	var BRLRowID=GetElementValue("BRLRowID");
	if (BRLRowID=="")
	{
		alertShow("�޲ɹ������豸��Ϣ!");
		return;
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyReqListAlter&BuyReqListDR='+BRLRowID+'&ReadOnly='+GetElementValue("ReadOnly");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=600,left=80,top=0')
}
///Add By DJ 2015-08-21 DJ0157
function GetCountInLoc()
{
	var ItemDR=GetElementValue("BRLItemDR");
	var UseLocDR=GetElementValue("UseLocDR");
  	var encmeth=GetElementValue("GetCountInLoc");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,ItemDR,UseLocDR);
	var list=rtn.split("^");
	SetElement("BRDCountNum",list[0]);
	SetElement("BRDCountInLoc",list[1]);
}

//20150822  Mozy0162	������հ�ť
function BClear_Clicked()
{
	//modified by  ZY 2015-09-28 ZY0144  ��յ�ʱ����ȱ�ǲ�����
	var lnkvar="&WaitAD="+GetElementValue("YearFlag");
	lnkvar=lnkvar+"&YearFlag="+GetElementValue("YearFlag");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew'+lnkvar;
	//window.opener.location.reload(); // 278192 Delete by BRB 2016-11-01 ʹ���ʱ������ת����ҳ��
}
/// 20150918  Mozy0166
function SetReclaimYearsNum()
{
	var PriceFee=+GetElementValue("BRLPriceFee");
	if (IsValidateNumber(PriceFee,1,1,0,1)==0)
	{
		alertShow("Ԥ�㵥�������쳣,������.");
		return;
	}
	if (PriceFee=="") PriceFee=0;
	PriceFee=parseFloat(PriceFee);
	var CostFee=+GetElementValue("BRDCostFee");
	if (IsValidateNumber(CostFee,1,1,0,1)==0)
	{
		alertShow("��ɱ�Ԥ�������쳣,������.");
		return;
	}
	if (CostFee=="") CostFee=0;
	CostFee=parseFloat(CostFee);
	var YearIncomeFee=+GetElementValue("BRDYearIncomeFee");
	if (IsValidateNumber(YearIncomeFee,1,1,0,1)==0)
	{
		alertShow("������Ԥ�������쳣,������.");
		return;
	}
	if (YearIncomeFee=="") YearIncomeFee=0;
	YearIncomeFee=parseFloat(YearIncomeFee);
	if (YearIncomeFee<=CostFee)
	{
		SetElement("BRDReclaimYearsNum",9999);
	}
	else
	{
		var ReclaimYearsNum=PriceFee/(YearIncomeFee-CostFee);
		SetElement("BRDReclaimYearsNum",ReclaimYearsNum.toFixed(2));
	}
}
document.body.onload = BodyLoadHandler;