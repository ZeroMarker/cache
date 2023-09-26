//新设备论证
//Mozy	2011-2-18
function BodyLoadHandler()
{
	InitUserInfo();
  	InitEvent();
  	FillData();
  	SetBEnabled();
  	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
  	var CanEditFlag=ReadOnlyCustomItem(GetParentTable("ARBuyReason"),GetElementValue("ARStatus"));
  	if (CanEditFlag==0)
  	{
	  	DisableBElement("BUpdate",true);
	}
	initButtonWidth()  //hisui改造 add by lmm 2018-08-20
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");//更新
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");//删除
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BClose");//提交
	if (obj) obj.onclick=BClose_Clicked;
	var obj=document.getElementById("BPrint");//打印
	if (obj) obj.onclick=BPrint_Clicked;
}
function SetBEnabled()
{
	var Status=GetElementValue("ARStatus");
	//var WaitAD=GetElementValue("WaitAD");
	//alertShow(GetElementValue("BRRowID"));
	if (Status>0)	//提交
	{
		//DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
}
function FillData() 
{
    var obj=document.getElementById("BRLRowID");
	var BRLRowID=obj.value;
	if ((BRLRowID=="")||(BRLRowID<1))	return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,BRLRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList)
	var list=ReturnList.split("@");
	var valueRequestDetail=list[1].split("^");
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
	
	if (list[0]=="")
	{
		DisableBElement("BDelete",true);
		return;
	}
	var valueArgumentation=list[0].split("^");
	var sort=35;
	SetElement("ARRowID",valueArgumentation[0]);
	SetElement("ARProductIntroduce",valueArgumentation[2]);
	SetElement("ARActuality",valueArgumentation[3]);
	SetElement("ARBuyReason",valueArgumentation[4]);
	SetElement("ARAffectAnalyse",valueArgumentation[5]);
	SetElement("ARCondition",valueArgumentation[6]);
	SetElement("ARService",valueArgumentation[7]);
	SetElement("ARRemark",valueArgumentation[12]);
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
function BUpdate_Clicked() 
{
	if (CheckNull()) return;
	var combindata=CombinData();
	UpdateData(combindata,"0");
}
function BDelete_Clicked() 
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	UpdateData(GetElementValue("ARRowID"),"1");
}
function BClose_Clicked() 
{
	var openerType=typeof(window.opener)	//HISUI改造 modified by czf 20190220
	if (openerType!="undefined")
	{
		window.close();
	}
	closeWindow('modal');
}
function UpdateData(val,AppType)
{
	///检测申请单是否已审核完成
	var flag=false;
	var obj=document.getElementById("GetOneBuyRequest");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",GetElementValue("BRRowID"),GetElementValue("CurRole"));
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var list=ReturnList.split("@");
	var valueRequest=list[0].split("^");
	var sortRequest=41;
	//alertShow(valueRequest[sortRequest+12])
	SetElement("NextRoleDR",valueRequest[sortRequest+12]);
	if (GetElementValue("ApproveSetDR")!="")
	{
		var curRole=GetElementValue("CurRole");
		var nextRole=GetElementValue("NextRoleDR");
		var WaitAD=GetElementValue("WaitAD");
		if (curRole!=nextRole) flag=true;
		if ((WaitAD!="off")&&(curRole=="")) flag=true;
	}
	if (flag)
	{
		alertShow("该采购申请单已经审核,论证信息保存无效!");
		return;
		//window.close();	//关闭当前页面
	}
	var plist=PackageData("BRLRowID^BRDRowID^BRDMaterial^BRDOperatorCount^BRDMedicalItem^BRDConsumption^BRDYearRunTime^BRDRatingPower^BRDCountInLoc^BRDDepreLimitYear^BRDFeeOfEmployee^BRDFeeOfDepre^BRDFeeOfMaterial^BRDUsePerWeekNum^BRDWorkLoadPerWeekNum^BRDUsePriceFee^BRDUseYearsNum^BRDReclaimYearsNum^BRDCountNum^BRDUseRate^BRDGoodRate^BRDYearIncomeFee^BRDCostFee^BRDYearMaintFee^BRDAdviseModel^BRDHold1^BRDHold2^BRDHold3^BRDHold4^BRDHold5");
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,val,plist,AppType);
	//alertShow(ReturnValue)
	if (ReturnValue<0)
	{
		alertShow(ReturnValue);
	}
	else
	{
		SetOpenerValue();
		//opener.SetElement("ARProductIntroduce",GetElementValue("ARProductIntroduce"));
		//opener.SetElement("ARActuality",GetElementValue("ARActuality"));
		//opener.SetElement("ARBuyReason",GetElementValue("ARBuyReason"));
		//opener.SetElement("ARAffectAnalyse",GetElementValue("ARAffectAnalyse"));
		//opener.SetElement("ARCondition",GetElementValue("ARCondition"));
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	//if (CheckItemNull(2,"ProductIntroduce")) return true;
	return false;
}

function CombinData()
{
	var combindata="";
  	combindata=combindata+GetElementValue("ARRowID");
	combindata=combindata+"^"+GetElementValue("BRLRowID");
	combindata=combindata+"^"+GetElementValue("ARProductIntroduce");
	combindata=combindata+"^"+GetElementValue("ARActuality");
	combindata=combindata+"^"+GetElementValue("ARBuyReason");
	combindata=combindata+"^"+GetElementValue("ARAffectAnalyse");
	combindata=combindata+"^"+GetElementValue("ARCondition");
	combindata=combindata+"^"+GetElementValue("ARService");
	combindata=combindata+"^"+GetElementValue("ARRemark");
	combindata=combindata+"^"+GetElementValue("ARClinicEffect");
	combindata=combindata+"^"+GetElementValue("ARSettleState");
	combindata=combindata+"^"+GetElementValue("ARResourceState");
	combindata=combindata+"^"+GetElementValue("ARPolluteState");
	combindata=combindata+"^"+GetElementValue("AROtherState");
	combindata=combindata+"^"+GetElementValue("ARPersonnelState");
	combindata=combindata+"^"+GetElementValue("ARIncome");
	combindata=combindata+"^"+GetElementValue("AREffect");
	combindata=combindata+"^"+GetElementValue("ARHold1");
	combindata=combindata+"^"+GetElementValue("ARHold2");
	combindata=combindata+"^"+GetElementValue("ARHold3");
	combindata=combindata+"^"+GetElementValue("ARHold4");
	combindata=combindata+"^"+GetElementValue("ARHold5");
	//alertShow(combindata);
  	return combindata;
}

function BPrint_Clicked()
{
	alertShow("功能实现中...");
	return;
	var obj=document.getElementById("ARRowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1))
	{
		alertShow("无论证信息进行打印!");
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=61;
	var sum=0;
	
	var BuyRequestList=GetElementValue("BRLRowID");
	if ((BuyRequestList=="")||(BuyRequestList<1)) return;
	var encmeth=GetElementValue("fillEquipData");
	var ReturnList=cspRunServerMethod(encmeth,BuyRequestList);
	var equipList=ReturnList.split("^");
	
	var TemplatePath=GetElementValue("GetRepPath");
	try
	{
        var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQArgumentation.xls";
	    xlApp = new ActiveXObject("Excel.Application");	 
		xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    //xlsheet.PageSetup.LeftMargin=0;
	    //xlsheet.PageSetup.RightMargin=0;
	    xlsheet.PageSetup.TopMargin=0;
	    
	    var row=2;
	    xlsheet.cells(row,3)=equipList[5];//申请科室
	    xlsheet.cells(row,5)=equipList[0];//设备名称
	    xlsheet.cells(row,7)=equipList[2];//生产厂商
	   	row=row+1;
	    xlsheet.cells(row,3)=equipList[4];//预计单价
	    xlsheet.cells(row,5)=equipList[6];//申购台数
	    xlsheet.cells(row,7)=equipList[7];//预计总价
	    xlsheet.cells(row,9)=equipList[1];//规格型号
	    
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[5];	//购置理由 BuyReason
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[3];	//产品介绍 "ProductIntroduce"
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[4];	//现状介绍	"Actuality"
	    row=row+2;
	    xlsheet.cells(row,3)=list[41];	//人员配备情况	PersonnelState
	    row=row+1;
	    xlsheet.cells(row,3)=list[15];	//售后服务	Service
	    row=row+1;
	    xlsheet.cells(row,3)=list[6];	//预计使用年限	UseYearsNum
	    xlsheet.cells(row,6)=list[44];	//操作仪器人数	OperatorCount
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[37];	//房屋水电配备情况	SettleState
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[40];	//其他特殊需求	OtherState
	    row=row+1;
	    xlsheet.cells(row,3)=list[45];	//该设备可开展的医疗服务项目	MedicalItem
	    row=row+2;
	    xlsheet.cells(row,3)=list[33];	//每年工作量	WorkLoadPerWeekNum
	    xlsheet.cells(row,6)=list[46];	//每工作量用消耗品用量	Consumption
	    row=row+1;
	    xlsheet.cells(row,3)=list[47];	//年开机时间	YearRunTime
	    xlsheet.cells(row,6)=list[48];	//仪器设备功率	RatingPower
	    row=row+1;
	    xlsheet.cells(row,3)=list[43];	//耗材价格	Material
	    row=row+1;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//医务科或护理部或科教办填写
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[8];	//原有设备更新原因 "AffectAnalyse"
	    row=row+2;
	    xlsheet.cells(row,4)=list[49];	//申请部门目前有该类设备台数	CountInLoc
	    row=row+1;
	    xlsheet.cells(row,4)=list[28];	//全院有该类设备台数	CountNum
	    row=row+1;
	    xlsheet.cells(row,4)=list[50];	//规定折旧年限	DepreLimitYear
	    row=row+1;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[31];	//能否在本部门或全院调剂使用及原因	ClinicEffect
	    row=row+5;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//物价办; 该仪器设备提供医疗服务每次收费标准
	    row=row+4;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//总务科; 房屋,水电等配套设施情况?排污解决措施
	    
	    row=2;
	    row=row+6;
	    xlsheet.cells(row,13)=list[51];	//人员经费 费用测算	FeeOfEmployee
	    ///收入测算
		if (list[54]!="")
		{
			sum=0;
			var IncomeList=list[54].split("&");
			for (var i=1;i<=5;i++)
			{
				try
				{
					if (IncomeList[i-1]!="") sum=sum+parseFloat(IncomeList[i-1]);
				}
				catch(e)
				{}
				xlsheet.cells(row+i-1,15)=IncomeList[i-1];
			}
			if (sum>0) xlsheet.cells(row+i-1,15)=sum;
		}
		///效益测算
		if (list[55]!="")
		{
			sum=0;
			var EffectList=list[55].split("&");
			for (var i=1;i<=5;i++)
			{
				try
				{
					if (EffectList[i-1]!="") sum=sum+parseFloat(EffectList[i-1]);
				}
				catch(e)
				{}
				xlsheet.cells(row+i-1,17)=EffectList[i-1];
			}
			if (sum>0) xlsheet.cells(row+i-1,17)=sum;
		}
	    row=row+1;
	    xlsheet.cells(row,13)=list[52];	//仪器折旧 费用测算	FeeOfDepre
	    row=row+1;
	    xlsheet.cells(row,13)=list[36];	//耗电额 费用测算	CostFee
	    row=row+1;
	    xlsheet.cells(row,13)=list[53];	//消耗品金额 费用测算	FeeOfMaterial
	    row=row+2;
	    sum=0;
	    if (list[36]!="") sum=sum+parseFloat(list[36]);
		if (list[51]!="") sum=sum+parseFloat(list[51]);
		if (list[52]!="") sum=sum+parseFloat(list[52]);
		if (list[53]!="") sum=sum+parseFloat(list[53]);
	    xlsheet.cells(row,13)=sum;	//费用测算	合计
	    
	    var GetOpinionByRole=GetElementValue("GetOpinionByRole");
	    
	    var role=11;///医务
	    var Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    if (Opinion=="")
	    {
		    role=12;///科教
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
		if (Opinion=="")
	    {
		    role=16;///护理
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
	    xlsheet.cells(22,2)=xlsheet.cells(22,2)+Opinion;
	    
	    role=15;///物价办
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(37,2)=xlsheet.cells(37,2)+Opinion;
	    role=10;///总务
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(42,2)=xlsheet.cells(42,2)+Opinion;
	    role=13;///财务科
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(2,12)=xlsheet.cells(2,12)+Opinion;
	    role=17;///会计测算
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(14,12)=xlsheet.cells(14,12)+Opinion;
	    role=9;///院采购委员会
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(18,12)=xlsheet.cells(18,12)+Opinion;
	    role=6;///采购中心
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(27,12)=xlsheet.cells(27,12)+Opinion;
	    role=4;///审计办
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(33,12)=Opinion;
	    
	    ////计划信息
	    var buyplaninfo=GetElementValue("GetBuyPlanListInfo");
	    buyplaninfo=cspRunServerMethod(buyplaninfo,BuyRequestList);
	    list=buyplaninfo.split("^");
		sort=25
		
		xlsheet.cells(25,13)=list[1];		///Name
		var model=list[sort+2];
		if (model!="") model=":";
		model=model+list[sort+1];
		xlsheet.cells(25,15)=model;			///品牌  "ManuFac",list[sort+2]///"Model",list[sort+1]
		xlsheet.cells(25,17)=list[6];		///QuantityNum
		xlsheet.cells(25,19)=list[5];		///PriceFee
		xlsheet.cells(26,13)=list[7];		///TotalFee
		xlsheet.cells(26,15)=list[sort+11];		///Hold1Desc 供应商
		///xlsheet.cells(26,17)=list[6];		///供应商信誉
		///xlsheet.cells(26,19)=list[5];		///供应商电话
		
		/*
		SetElement("BuyPlan",list[sort+0]);
		SetElement("Name",list[1]);
		SetElement("ModelDR",list[2]);
		SetElement("Model",list[sort+1]);
		SetElement("ManuFacDR",list[3]);
		SetElement("ManuFac",list[sort+2]);
		SetChkElement("TestFlag",list[4]);
		SetElement("PriceFee",list[5]);
		SetElement("QuantityNum",list[6]);
		SetElement("TotalFee",list[7]);
		SetElement("Remark",list[8]);
		SetElement("BRLRowID",list[9]);
		SetElement("BuyRequestList",list[sort+3]);
		SetElement("ContractDR",list[10]);
		SetElement("Contract",list[sort+4]);
		SetElement("UpdateUserDR",list[11]);
		SetElement("UpdateUser",list[sort+5]);
		SetElement("UpdateDate",list[12]);
		SetElement("UpdateTime",list[13]);
		SetElement("CurrencyDR",list[14]);
		SetElement("Currency",list[sort+6]);
		SetElement("EquipCatDR",list[15]);
		SetElement("EquipCat",list[sort+7]);
		SetElement("Hold1",list[16]);
		SetElement("ItemDR",list[17]);
		//SetElement("PurchaseType",list[sort+8]);
		SetElement("ArriveDate",list[18]);
		SetElement("PurposeTypeDR",list[19]);
		SetElement("PurposeType",list[sort+8]);
		SetChkElement("RefuseFlag",list[20]);
		SetElement("RefuseReason",list[21]);
		SetElement("BuyRequestDR",list[sort+9]);
		SetElement("BuyRequest",list[sort+10]);
		*/
    	
	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\Return"+i+".xls");
	    xlBook.Close (savechanges=false);
	    xlsheet.Quit;
	    xlsheet=null;
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function SetOpenerValue()
{
	SetSpecialElement("INPUT");
	SetSpecialElement("TEXTAREA");
}

function SetSpecialElement(TagName)
{
	var All = document.getElementsByTagName(TagName);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		try
		{
			if (All[I].id!="")
			{
				if ((!All[I].disabled)&&(All[I].type!="hidden")&&(!All[I].readOnly))
				{
					opener.SetElement(All[I].id,All[I].value);
				}
			}
		}
		catch(e)
		{}
	}
}

document.body.onload = BodyLoadHandler;