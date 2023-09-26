//���豸��֤
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
	initButtonWidth()  //hisui���� add by lmm 2018-08-20
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");//����
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");//ɾ��
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BClose");//�ύ
	if (obj) obj.onclick=BClose_Clicked;
	var obj=document.getElementById("BPrint");//��ӡ
	if (obj) obj.onclick=BPrint_Clicked;
}
function SetBEnabled()
{
	var Status=GetElementValue("ARStatus");
	//var WaitAD=GetElementValue("WaitAD");
	//alertShow(GetElementValue("BRRowID"));
	if (Status>0)	//�ύ
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
	var openerType=typeof(window.opener)	//HISUI���� modified by czf 20190220
	if (openerType!="undefined")
	{
		window.close();
	}
	closeWindow('modal');
}
function UpdateData(val,AppType)
{
	///������뵥�Ƿ���������
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
		alertShow("�òɹ����뵥�Ѿ����,��֤��Ϣ������Ч!");
		return;
		//window.close();	//�رյ�ǰҳ��
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
	alertShow("����ʵ����...");
	return;
	var obj=document.getElementById("ARRowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1))
	{
		alertShow("����֤��Ϣ���д�ӡ!");
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
	    xlsheet.cells(row,3)=equipList[5];//�������
	    xlsheet.cells(row,5)=equipList[0];//�豸����
	    xlsheet.cells(row,7)=equipList[2];//��������
	   	row=row+1;
	    xlsheet.cells(row,3)=equipList[4];//Ԥ�Ƶ���
	    xlsheet.cells(row,5)=equipList[6];//�깺̨��
	    xlsheet.cells(row,7)=equipList[7];//Ԥ���ܼ�
	    xlsheet.cells(row,9)=equipList[1];//����ͺ�
	    
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[5];	//�������� BuyReason
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[3];	//��Ʒ���� "ProductIntroduce"
	    row=row+2;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[4];	//��״����	"Actuality"
	    row=row+2;
	    xlsheet.cells(row,3)=list[41];	//��Ա�䱸���	PersonnelState
	    row=row+1;
	    xlsheet.cells(row,3)=list[15];	//�ۺ����	Service
	    row=row+1;
	    xlsheet.cells(row,3)=list[6];	//Ԥ��ʹ������	UseYearsNum
	    xlsheet.cells(row,6)=list[44];	//������������	OperatorCount
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[37];	//����ˮ���䱸���	SettleState
	    xlsheet.cells(row,7)=xlsheet.cells(row,7)+list[40];	//������������	OtherState
	    row=row+1;
	    xlsheet.cells(row,3)=list[45];	//���豸�ɿ�չ��ҽ�Ʒ�����Ŀ	MedicalItem
	    row=row+2;
	    xlsheet.cells(row,3)=list[33];	//ÿ�깤����	WorkLoadPerWeekNum
	    xlsheet.cells(row,6)=list[46];	//ÿ������������Ʒ����	Consumption
	    row=row+1;
	    xlsheet.cells(row,3)=list[47];	//�꿪��ʱ��	YearRunTime
	    xlsheet.cells(row,6)=list[48];	//�����豸����	RatingPower
	    row=row+1;
	    xlsheet.cells(row,3)=list[43];	//�Ĳļ۸�	Material
	    row=row+1;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//ҽ��ƻ�����ƽ̰���д
	    row=row+5;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[8];	//ԭ���豸����ԭ�� "AffectAnalyse"
	    row=row+2;
	    xlsheet.cells(row,4)=list[49];	//���벿��Ŀǰ�и����豸̨��	CountInLoc
	    row=row+1;
	    xlsheet.cells(row,4)=list[28];	//ȫԺ�и����豸̨��	CountNum
	    row=row+1;
	    xlsheet.cells(row,4)=list[50];	//�涨�۾�����	DepreLimitYear
	    row=row+1;
	    xlsheet.cells(row,2)=xlsheet.cells(row,2)+list[31];	//�ܷ��ڱ����Ż�ȫԺ����ʹ�ü�ԭ��	ClinicEffect
	    row=row+5;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//��۰�; �������豸�ṩҽ�Ʒ���ÿ���շѱ�׼
	    row=row+4;
	    //xlsheet.cells(row,2)=xlsheet.cells(row,2);	//�����; ����,ˮ���������ʩ���?���۽����ʩ
	    
	    row=2;
	    row=row+6;
	    xlsheet.cells(row,13)=list[51];	//��Ա���� ���ò���	FeeOfEmployee
	    ///�������
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
		///Ч�����
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
	    xlsheet.cells(row,13)=list[52];	//�����۾� ���ò���	FeeOfDepre
	    row=row+1;
	    xlsheet.cells(row,13)=list[36];	//�ĵ�� ���ò���	CostFee
	    row=row+1;
	    xlsheet.cells(row,13)=list[53];	//����Ʒ��� ���ò���	FeeOfMaterial
	    row=row+2;
	    sum=0;
	    if (list[36]!="") sum=sum+parseFloat(list[36]);
		if (list[51]!="") sum=sum+parseFloat(list[51]);
		if (list[52]!="") sum=sum+parseFloat(list[52]);
		if (list[53]!="") sum=sum+parseFloat(list[53]);
	    xlsheet.cells(row,13)=sum;	//���ò���	�ϼ�
	    
	    var GetOpinionByRole=GetElementValue("GetOpinionByRole");
	    
	    var role=11;///ҽ��
	    var Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    if (Opinion=="")
	    {
		    role=12;///�ƽ�
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
		if (Opinion=="")
	    {
		    role=16;///����
	    	Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
		}
	    xlsheet.cells(22,2)=xlsheet.cells(22,2)+Opinion;
	    
	    role=15;///��۰�
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(37,2)=xlsheet.cells(37,2)+Opinion;
	    role=10;///����
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(42,2)=xlsheet.cells(42,2)+Opinion;
	    role=13;///�����
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(2,12)=xlsheet.cells(2,12)+Opinion;
	    role=17;///��Ʋ���
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(14,12)=xlsheet.cells(14,12)+Opinion;
	    role=9;///Ժ�ɹ�ίԱ��
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(18,12)=xlsheet.cells(18,12)+Opinion;
	    role=6;///�ɹ�����
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(27,12)=xlsheet.cells(27,12)+Opinion;
	    role=4;///��ư�
	    Opinion=cspRunServerMethod(GetOpinionByRole,BuyRequestList,role);
	    xlsheet.cells(33,12)=Opinion;
	    
	    ////�ƻ���Ϣ
	    var buyplaninfo=GetElementValue("GetBuyPlanListInfo");
	    buyplaninfo=cspRunServerMethod(buyplaninfo,BuyRequestList);
	    list=buyplaninfo.split("^");
		sort=25
		
		xlsheet.cells(25,13)=list[1];		///Name
		var model=list[sort+2];
		if (model!="") model=":";
		model=model+list[sort+1];
		xlsheet.cells(25,15)=model;			///Ʒ��  "ManuFac",list[sort+2]///"Model",list[sort+1]
		xlsheet.cells(25,17)=list[6];		///QuantityNum
		xlsheet.cells(25,19)=list[5];		///PriceFee
		xlsheet.cells(26,13)=list[7];		///TotalFee
		xlsheet.cells(26,15)=list[sort+11];		///Hold1Desc ��Ӧ��
		///xlsheet.cells(26,17)=list[6];		///��Ӧ������
		///xlsheet.cells(26,19)=list[5];		///��Ӧ�̵绰
		
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
    	
	    xlsheet.printout; //��ӡ���
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