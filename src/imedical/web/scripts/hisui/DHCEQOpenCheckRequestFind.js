//װ��ҳ��  �������ƹ̶�
// Mozy0247	1190959		2020-02-17
var valRowIDs="";
var inflag="";
var outflag="";
var CurRole="";
var RoleStep="";
function BodyLoadHandler() {
	SetElement("ProviderCHeck",GetElementValue("ProviderCHeckID"));
	InitUserInfo();
	InitEvent();
	SetElement("AssetTypeList",GetElementValue("GetAssetTypeList"));
	fillData();
	RefreshData();
	initButtonWidth()  //hisui���� add by lmm 2018-08-20
	setButtonText()	//hisui���� add by czf 20180929
}
function InitEvent()
{
	KeyUp("Equip^ManuFactory^Provider^Status");	//���ѡ��
	Muilt_LookUp("Equip^ManuFactory^Provider^Status"); //�س�ѡ��
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BImport",true);
		// Mozy0247	1190959		2020-02-17
		var obj=document.getElementById("BatchOpt");
		if (obj) obj.onclick=BatchOpt_Clicked;
	}
	else
	{
		$("#WaitAD").parent().empty()	//Mozy	1012982	2019-9-14
		//HiddenCheckBox("WaitAD");  //hisui���� add by lmm 2018-08-18
		EQCommon_HiddenElement("cWaitAD");
		EQCommon_HiddenElement("BatchOpt");	// Mozy0247	1190959		2020-02-17
		// Mozy0253	1215648		2020-3-4	����CheckBoxԪ�ؼ���Ԫ��
		$("#AllSelect").parent().empty();
		EQCommon_HiddenElement("cAllSelect");
		HiddenTblColumn("tDHCEQOpenCheckRequestFind","TChk");
		var obj=document.getElementById("BAdd");
		if (obj) obj.onclick=BAdd_Click;
		var obj=document.getElementById("BImport");
		if (obj) obj.onclick=BImport_Click;
	}
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var CancelOper=GetElementValue("CancelOper");
	if (CancelOper=="Y")
	{
		$("#WaitAD").parent().empty()	//Mozy	1015142	2019-9-14
		//HiddenCheckBox("WaitAD");  //hisui���� add by lmm 2018-08-18
		EQCommon_HiddenElement("cWaitAD");
		//document.getElementById("ld"+GetElementValue("GetComponentID")+"iStatus").removeNode(true)	//hisui���� modified by czf 20181011
		DisableElement("Status",true);	//HISUI���� modified by czf 20181011 
		EQCommon_HiddenElement("BatchOpt");	// Mozy0247	1190959		2020-02-17
		// Mozy0253	1215648		2020-3-4	����CheckBoxԪ�ؼ���Ԫ��
		$("#AllSelect").parent().empty();
		EQCommon_HiddenElement("cAllSelect");
		HiddenTblColumn("tDHCEQOpenCheckRequestFind","TChk");
	}
	// Mozy0247	1190959		2020-02-17
	var obj=document.getElementById("AllSelect");
	if (obj) obj.onclick=AllSelect_Clicked;
}
///add by lmm 2018-08-18
///������hisui���� ���ع�ѡ��
///��Σ�name ��ѡ��id
function HiddenCheckBox(name)
{
	$("#"+name).parent(".hischeckbox_square-blue").css("display","none");
}
function GetEquip(value)
{
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
}

function GetManuFactory(value) {
	var user=value.split("^");
	
	var obj=document.getElementById("ManuFactoryDR");
	obj.value=user[1];
}

function GetProvider(value) {
	var user=value.split("^");
	var obj=document.getElementById("ProviderDR");
	obj.value=user[1];
}

function GetStatus(value) {
	var user=value.split("^");
	var obj=document.getElementById("StatusDR");
	obj.value=user[1];
}
/// Mozy0145	20141017
function BAdd_Click()
{
	var AssetType=GetElementValue("AssetTypeList");
	var encmeth=GetElementValue("GetAssetTypeComponent");
  	if (encmeth=="") return;
	var Component=cspRunServerMethod(encmeth,AssetType);
	if (Component=="")
	{
		alertShow("��Ч�ʲ�����");
		return;
	}
	var ApproveRole=GetElementValue("ApproveRole");
	var Type=GetElementValue("Type");
	var ReadOnly=GetElementValue("ReadOnly");
	//GR0026 ����������´��ڴ�ģ̬����
	url="dhceqopencheckrequestfind.csp?&DHCEQMWindow=1&AssetTypeList="+AssetType+"&ApproveRole="+ApproveRole+"&Type="+Type+"&ReadOnly="+ReadOnly+"&CheckTypeDR="+GetElementValue("CheckTypeDR")
	//modify by lmm 2020-02-07 1189098
	showWindow(url,"�豸���չ���","","","icon-w-paper","modal","","","large");	//modified by lmm 2020-06-04 UI
	//var val=Component+"&Type=0&CheckTypeDR="+GetElementValue("CheckTypeDR")+"&AssetType="+AssetType;
	//window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+val;
}

//Add By QW0005-2014-11-04��Ӧ��ģ����ѯ
function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	val=val+"&Equip="+GetElementValue("Equip");
	val=val+"&ManuFactoryDR="+GetElementValue("ManuFactoryDR");
	val=val+"&ManuFactory="+GetElementValue("ManuFactory");  //�����������̴���ֵ  ����ţ�268233  add by mwz 2016-10-09
	val=val+"&StatusDR="+GetElementValue("StatusDR")
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&InvalidFlag="+GetElementValue("InvalidFlag"); 
	val=val+"&Type="+GetElementValue("Type");   
	val=val+"&CheckTypeDR="+GetElementValue("CheckTypeDR");
	val=val+"&AssetTypeList="+GetElementValue("AssetTypeList");
	val=val+"&ApproveRole="+GetElementValue("ApproveRole");		/// 20150327  Mozy0153
	val=val+"&CancelOper="+GetElementValue("CancelOper");
	val=val+"&TMENU="+GetElementValue("TMENU");
	val=val+"&CurRole="+GetElementValue("ApproveRole");		//add by czf 20180928 HISUI����
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQOpenCheckRequestFind"+val;   //hisui���� modify by lmm 2018-08-17
}
//Add By QW0005-2014-11-04��Ӧ��ģ����ѯ
function GetVData()
{
	var val="^ProviderQuery="+GetElementValue("ProviderQuery");   //���ӹ�Ӧ��ģ����ѯ
	val=val+"^ProviderCHeck="+GetElementValue("ProviderCHeck");   //ģ����ѯ����
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");   
	val=val+"^WaitAD=";	/// 20150327  Mozy0153
	if (GetElementValue("WaitAD")) val=val+"1";	//HISUI���� add by czf 20180928
	val=val+"^ProviderDR="+GetElementValue("ProviderDR");      
	val=val+"^StartDate="+GetElementValue("StartDate");     
	val=val+"^RequestNo="+GetElementValue("RequestNo");   
	val=val+"^FileNo="+GetElementValue("FileNo");      
	val=val+"^CommonName="+GetElementValue("CommonName");  

	return val;
}
//Add By QW0005-2014-11-04
function fillData()
{
	var vData=GetElementValue("vData")
	var EquipDR = GetElementValue("Equip");
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"prov=Provider="+GetElementValue("ProviderDR")+"^";
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}
//Add By QW0005-2014-11-04
function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}
function filepath(oldpath,findstr,replacestr)
{
	if (oldpath=="") return ""
	var newpath=""
	var pathcount=oldpath.length
	for (var i=0;i<pathcount;i++)
	{
		var curchar=oldpath.substr(0,1)
		if (curchar==findstr)
		{
			newpath=newpath+replacestr
		}
		else
		{
			newpath=newpath+curchar
		}
		oldpath=oldpath.substr(1,oldpath.length)
	}
	return newpath
}
///Add By DJ 2020-04-10
function BImport_Click()
{
	if (GetElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
}
function BImport_Chrome()
{
	var encmeth=GetElementValue("CheckLocType");
	if (encmeth=="") return 0;
	var val=curLocID;
	if (val!="")
	{
		var result=cspRunServerMethod(encmeth,'0101',val);
		if (result=="-1")
		{
			alertShow("��ǰ�豸�ⷿ���ǿⷿ")
			return 0;
		}
		var encmeth=GetElementValue("LocIsInEQ");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"1",val);
		if (result=="1")
		{
			alertShow("��ǰ�豸�ⷿ���ڵ�¼��ȫ�����Χ��")
			return 0;
		}
	}
	var RowInfo=websys_ReadExcel('');
	if (RowInfo=="")		//add by czf 20200611 1342552 begin
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}		//add by czf 20200611 1342552 end
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var Provider=trim(RowInfo[Row-1][Col++]);
		var ProviderHandler=trim(RowInfo[Row-1][Col++]);
		var ProviderTel=trim(RowInfo[Row-1][Col++]);
		var Name=trim(RowInfo[Row-1][Col++]);
		var Model=trim(RowInfo[Row-1][Col++]);
		var OriginalFee=trim(RowInfo[Row-1][Col++]);
		var Quantity=trim(RowInfo[Row-1][Col++]);
		var ManuFactory=trim(RowInfo[Row-1][Col++]);
		var Country=trim(RowInfo[Row-1][Col++]); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
		var LeaveFactoryDate=trim(RowInfo[Row-1][Col++]);
		var CheckDate=trim(RowInfo[Row-1][Col++]);
		var GuaranteePeriodNum=trim(RowInfo[Row-1][Col++]);	//������
		var ContractNo=trim(RowInfo[Row-1][Col++]);	//��ͬ��
		var Remark=trim(RowInfo[Row-1][Col++]);
		var Origin=trim(RowInfo[Row-1][Col++]);
		var OriginDR="";
		var BuyType=trim(RowInfo[Row-1][Col++]);
		var BuyTypeDR="";
		var PurchaseType=trim(RowInfo[Row-1][Col++]);
		var PurchaseTypeDR="";
		var PurposeType=trim(RowInfo[Row-1][Col++]);
		var PurposeTypeDR="";    
		var UseLoc=trim(RowInfo[Row-1][Col++]);
		var UseLocDR="";
		var FileNo=trim(RowInfo[Row-1][Col++]);
		var Expenditures=trim(RowInfo[Row-1][Col++]);
		var ExpendituresDR="";
		var Location=trim(RowInfo[Row-1][Col++]);
		var MeasureFlag=trim(RowInfo[Row-1][Col++]);
		//Modify By zx 2020-02-18 BUG ZX0074
		var Hold7=trim(RowInfo[Row-1][Col++]);  //��ҽ��־
		var Hold6=trim(RowInfo[Row-1][Col++]);  //�����־
		var Hold2=trim(RowInfo[Row-1][Col++])  //ע��֤��
		var Brand=trim(RowInfo[Row-1][Col++])  //Ʒ��
		var Hold1=trim(RowInfo[Row-1][Col++])  //��Ʊ��
		var Hold11=trim(RowInfo[Row-1][Col++])  //��Ŀ����
		var CheckResult=trim(RowInfo[Row-1][Col++])  //���ս���
		var ConfigState=trim(RowInfo[Row-1][Col++])  //�������
		var RunningState=trim(RowInfo[Row-1][Col++])  //�������
		var FileState=trim(RowInfo[Row-1][Col++])  //����ļ����
		var PackageState=trim(RowInfo[Row-1][Col++])  //��������
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetItemInfo");
		var ItemInfo=cspRunServerMethod(encmeth,Name);
		if (ItemInfo=="")
		{
			alertShow("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		if (Country!="")
		{
			CountryDR=cspRunServerMethod(encmeth,"CTCountry",Country);
			if (CountryDR=="")
			{
				alertShow("��"+Row+"�� �������Ϣ����ȷ:"+Country);
				return 0;
			}
		}
		if (Origin!="")
		{
			OriginDR=cspRunServerMethod(encmeth,"DHCEQCOrigin",Origin);
			if (OriginDR=="")
			{
				alertShow("��"+Row+"�� �豸��Դ����Ϣ����ȷ:"+Origin);
				return 0;
			}
		}
		if (BuyType!="")
		{
			BuyTypeDR=cspRunServerMethod(encmeth,"DHCEQCBuyType",BuyType);
			if (BuyTypeDR=="")
			{
				alertShow("��"+Row+"�� �ɹ���ʽ����Ϣ����ȷ:"+BuyType);
				return 0;
			}
		}
		if (PurchaseType!="")
		{
			PurchaseTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurchaseType",PurchaseType);
			if (PurchaseTypeDR=="")
			{
				alertShow("��"+Row+"�� �깺������Ϣ����ȷ:"+PurchaseType);
				return 0;
			}
		}
		if (PurposeType!="")
		{
			PurposeTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurposeType",PurposeType);
			if (PurposeTypeDR=="")
			{
				alertShow("��"+Row+"�� �豸��;����Ϣ����ȷ:"+PurposeType);
				return 0;
			}
		}
		if (UseLoc!="")
		{
			UseLocDR=cspRunServerMethod(encmeth,"CTLoc",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (Expenditures!="")
		{
			ExpendituresDR=cspRunServerMethod(encmeth,"DHCEQCExpenditures",Expenditures);
			if (ExpendituresDR=="")
			{
				alertShow("��"+Row+"�� �豸������Դ����Ϣ����ȷ:"+Expenditures);
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
		{
			alertShow("��"+Row+"�� �豸��������,������ȷ��������!")
			return 0;
		}
		if (parseInt(Quantity)!=Quantity)
		{
			alertShow("��"+Row+"�� �豸��������,����������С��λ����,��������!");
			return 0;
		}
		//�Զ����ñ������յ�
		var list=ItemInfo.split("^");
		var sort=22;
		var combindata=""; //1	RowID
		combindata=combindata+"^"+list[0]	//GetElementValue("Name") ;//2
		combindata=combindata+"^"+list[1]	//GetElementValue("Code");//3
		combindata=combindata+"^"+PurchaseTypeDR; //4
		combindata=combindata+"^"+list[2]	//GetElementValue("EquipTypeDR"); //5
		combindata=combindata+"^"+list[4]	//GetElementValue("StatCatDR"); //6
		combindata=combindata+"^"+list[3]	//GetElementValue("EquiCatDR"); //7
		combindata=combindata+"^"	//+GetElementValue("MemoryCode"); //8
		combindata=combindata+"^"+BuyTypeDR	//+GetElementValue("BuyTypeDR"); //9     //modified by czf 370967
		combindata=combindata+"^"	//+GetElementValue("StoreLocDR"); //10
		combindata=combindata+"^"	//+GetElementValue("ABCType"); //11
		combindata=combindata+"^"	//+GetElementValue("PackTypeDR"); //12
		combindata=combindata+"^"+list[6]	//GetElementValue("UnitDR"); //13
		if (Model=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var encmeth=GetElementValue("UpdModel");
			var rtn=cspRunServerMethod(encmeth,Model,list[sort+8]);
			combindata=combindata+"^"+rtn; //14	Model
		}
		combindata=combindata+"^"+CountryDR; //15
		combindata=combindata+"^"+list[9]	//GetElementValue("CurrencyDR"); //16
		combindata=combindata+"^"+Quantity; //17
		combindata=combindata+"^"+PurposeTypeDR; //18
		combindata=combindata+"^"	//+GetElementValue("CurrencyFee"); //19
		var val=GetPYCode(Provider)+"^"+Provider+"^"+ProviderHandler+"^"+ProviderTel;
		var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
		combindata=combindata+"^"+rtn;//20
		combindata=combindata+"^"+ProviderHandler; //21	������ϵ��
		combindata=combindata+"^"+ProviderTel; //22
		if (ManuFactory=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(ManuFactory)+"^"+ManuFactory;
			var encmeth=GetElementValue("UpdManuFactory");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;//23
		}
		combindata=combindata+"^"	//+GetElementValue("MakeDate"); //24
		combindata=combindata+"^"+LeaveFactoryDate; //25
		combindata=combindata+"^"	//+GetElementValue("ServiceDR"); //26
		if (Location=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(Location)+"^"+Location;
			var encmeth=GetElementValue("UpdLocation");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;
		}
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+OriginalFee; //29
		combindata=combindata+"^"	//+GetElementValue("NetRemainFee"); //30
		combindata=combindata+"^"+OriginDR; //31
		combindata=combindata+"^"+UseLocDR; //32
		combindata=combindata+"^"+list[sort+5]	//GetElementValue("LimitYearsNum"); //33
		combindata=combindata+"^"+list[sort+6]	//GetElementValue("DepreMethodDR"); //34
		combindata=combindata+"^"	//+GetElementValue("InstallDate"); //35
		combindata=combindata+"^"	//+GetElementValue("InstallLocDR"); //36
		combindata=combindata+"^"	//+GetElementValue("DesignWorkLoadNum"); //37
		combindata=combindata+"^"	//+GetElementValue("WorkLoadUnitDR"); //38
		combindata=combindata+"^"	//+GetElementValue("GuaranteeStartDate"); //39
		combindata=combindata+"^"	//+GetElementValue("GuaranteeEndDate"); //40
		combindata=combindata+"^"	//+GetElementValue("FromDeptDR"); //41
		combindata=combindata+"^"	//+GetChkElementValue("GuaranteeFlag"); //42
		combindata=combindata+"^"	//+GetChkElementValue("UrgencyFlag"); //43
		combindata=combindata+"^"; //44
		if (MeasureFlag.toUpperCase()=="Y") combindata=combindata+"Y";
		combindata=combindata+"^"	//+GetChkElementValue("MedicalFlag"); //45
		combindata=combindata+"^"	//+GetChkElementValue("TestFlag"); //46
		combindata=combindata+"^"	//+GetElementValue("AffixState"); //47
		combindata=combindata+"^"+CheckResult;	//+GetElementValue("CheckResult"); //48//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("CheckUser"); //49
		combindata=combindata+"^"+ConfigState;	//+GetElementValue("ConfigState"); //50//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+FileState;	//+GetElementValue("FileState"); //51
		combindata=combindata+"^"	//+GetElementValue("OpenState"); //52
		combindata=combindata+"^"+PackageState;	//+GetElementValue("PackageState"); //53//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("RejectReason"); //54
		combindata=combindata+"^"+Remark; //55
		combindata=combindata+"^"+RunningState;	//+GetElementValue("RunningState"); //56//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("ContractListDR"); //57
		combindata=combindata+"^"+ContractNo; //58
		combindata=combindata+"^"+GetElementValue("CheckTypeDR"); //59
		combindata=combindata+"^"+CheckDate; //60
		combindata=combindata+"^"+CheckDate; //61OpenCheckDate
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("ItemDR"); //62
		combindata=combindata+"^0"	//+GetElementValue("Status"); //63
		combindata=combindata+"^"+LeaveFactoryNo; //64
		combindata=combindata+"^"+Hold1; //+GetElementValue("Hold1"); //65	InvoiceInfos//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+Hold2;	//+GetElementValue("Hold2"); //66 //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("Hold3"); //67
		//Modify By zx 2020-02-18 BUG ZX0074
		if (Brand=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(Brand)+"^"+Brand;
			var encmeth=GetElementValue("UpdBrand");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;//23
		}
		combindata=combindata+"^"	//+GetElementValue("Hold4"); //68
		//combindata=combindata+"^"+GetElementValue("Hold5"); //69
		combindata=combindata+"^"+ExpendituresDR; //69	������Դ20150819  Mozy0159
		combindata=combindata+"^"	//+GetChkElementValue("BenefitAnalyFlag");//65
		combindata=combindata+"^"	//+GetChkElementValue("CommonageFlag");//66
		combindata=combindata+"^"	//+GetChkElementValue("AutoCollectFlag");//67
		combindata=combindata+"^0"  //Modify By zx 2020-02-18 BUG ZX0074 ������Դ����	//+GetElementValue("HSourceType");//68
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("SourceID");//69
		combindata=combindata+"^"	//+GetElementValue("WorkLoadPerMonth");//70
		combindata=combindata+"^"	//+GetElementValue("RequestHold1");//76
		combindata=combindata+"^"	//+GetElementValue("RequestHold2");//77
		combindata=combindata+"^"	//+GetElementValue("RequestHold3");//78
		combindata=combindata+"^"	//+GetElementValue("RequestHold4");//79
		combindata=combindata+"^"	//+GetElementValue("RequestHold5");//80
		combindata=combindata+"^"+list[0]	//GetElementValue("CommonName");//81
		combindata=combindata+"^"	//+GetElementValue("ValueType");//82 ��ֵ����
		combindata=combindata+"^"	//+GetElementValue("DirectionsUse");//83 ʹ�÷���
		combindata=combindata+"^"	//+GetElementValue("UserDR"); //84 UserDR
		combindata=combindata+"^"	//+GetElementValue("AccountShape");  //85 ������ʽ
		combindata=combindata+"^"	//+GetElementValue("ProjectNo"); //86 ��ĿԤ����
		combindata=combindata+"^"	//+GetElementValue("AccountNo");  //87 ���ƾ֤��
		combindata=combindata+"^"+Hold6    //�����־ //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+Hold7;   //��ҽ��־ //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("Hold8");
		combindata=combindata+"^"	//+GetElementValue("Hold9");
		combindata=combindata+"^"	//+GetElementValue("Hold10");
		combindata=combindata+"^"+FileNo //GetElementValue("FileNo");  //modified by czf 370967
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") return 0;
		var result=cspRunServerMethod(encmeth,'','',combindata,'2');
		if (result<0)
		{
			Error="��"+Row+"����Ϣ����ʧ��!!!"
			alertShow(Error);
			Row=RowInfo.length+1
		}
	}
	if (Error=="")
	{
		messageShow('alert','info','��ʾ','����������Ϣ�������!��˶������Ϣ.','',importreload,'');		
	}
}
function importreload()
{
	window.location.reload();
}
function BImport_IE()
{
	var encmeth=GetElementValue("CheckLocType");
	if (encmeth=="") return 0;
	var val=curLocID;
	if (val!="")
	{
		var result=cspRunServerMethod(encmeth,'0101',val);
		if (result=="-1")
		{
			alertShow("��ǰ�豸�ⷿ���ǿⷿ")
			return 0;
		}
		var encmeth=GetElementValue("LocIsInEQ");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"1",val);
		if (result=="1")
		{
			alertShow("��ǰ�豸�ⷿ���ڵ�¼��ȫ�����Χ��")
			return 0;
		}
	}
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets("���յ�");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var Provider=trim(xlsheet.cells(Row,Col++).text);
		var ProviderHandler=trim(xlsheet.cells(Row,Col++).text);
		var ProviderTel=trim(xlsheet.cells(Row,Col++).text);
		var Name=trim(xlsheet.cells(Row,Col++).text);
		var Model=trim(xlsheet.cells(Row,Col++).text);
		var OriginalFee=trim(xlsheet.cells(Row,Col++).text);
		var Quantity=trim(xlsheet.cells(Row,Col++).text);
		var ManuFactory=trim(xlsheet.cells(Row,Col++).text);
		var Country=trim(xlsheet.cells(Row,Col++).text); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(xlsheet.cells(Row,Col++).text);
		var LeaveFactoryDate=trim(xlsheet.cells(Row,Col++).text);
		var CheckDate=trim(xlsheet.cells(Row,Col++).text);
		var GuaranteePeriodNum=trim(xlsheet.cells(Row,Col++).text);	//������
		var ContractNo=trim(xlsheet.cells(Row,Col++).text);	//��ͬ��
		var Remark=trim(xlsheet.cells(Row,Col++).text);
		var Origin=trim(xlsheet.cells(Row,Col++).text);
		var OriginDR="";
		var BuyType=trim(xlsheet.cells(Row,Col++).text);
		var BuyTypeDR="";
		var PurchaseType=trim(xlsheet.cells(Row,Col++).text);
		var PurchaseTypeDR="";
		var PurposeType=trim(xlsheet.cells(Row,Col++).text);
		var PurposeTypeDR="";    
		var UseLoc=trim(xlsheet.cells(Row,Col++).text);
		var UseLocDR="";
		var FileNo=trim(xlsheet.cells(Row,Col++).text);
		var Expenditures=trim(xlsheet.cells(Row,Col++).text);
		var ExpendituresDR="";
		var Location=trim(xlsheet.cells(Row,Col++).text);
		var MeasureFlag=trim(xlsheet.cells(Row,Col++).text);
		//Modify By zx 2020-02-18 BUG ZX0074
		var Hold7=trim(xlsheet.cells(Row,Col++).text);  //��ҽ��־
		var Hold6=trim(xlsheet.cells(Row,Col++).text);  //�����־
		var Hold2=trim(xlsheet.cells(Row,Col++).text)  //ע��֤��
		var Brand=trim(xlsheet.cells(Row,Col++).text)  //Ʒ��
		var Hold1=trim(xlsheet.cells(Row,Col++).text)  //��Ʊ��
		var Hold11=trim(xlsheet.cells(Row,Col++).text)  //��Ŀ����
		var CheckResult=trim(xlsheet.cells(Row,Col++).text)  //���ս���
		var ConfigState=trim(xlsheet.cells(Row,Col++).text)  //�������
		var RunningState=trim(xlsheet.cells(Row,Col++).text)  //�������
		var FileState=trim(xlsheet.cells(Row,Col++).text)  //����ļ����
		var PackageState=trim(xlsheet.cells(Row,Col++).text)  //��������
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetItemInfo");
		var ItemInfo=cspRunServerMethod(encmeth,Name);
		if (ItemInfo=="")
		{
			alertShow("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		if (Country!="")
		{
			CountryDR=cspRunServerMethod(encmeth,"CTCountry",Country);
			if (CountryDR=="")
			{
				alertShow("��"+Row+"�� �������Ϣ����ȷ:"+Country);
				return 0;
			}
		}
		if (Origin!="")
		{
			OriginDR=cspRunServerMethod(encmeth,"DHCEQCOrigin",Origin);
			if (OriginDR=="")
			{
				alertShow("��"+Row+"�� �豸��Դ����Ϣ����ȷ:"+Origin);
				return 0;
			}
		}
		if (BuyType!="")
		{
			BuyTypeDR=cspRunServerMethod(encmeth,"DHCEQCBuyType",BuyType);
			if (BuyTypeDR=="")
			{
				alertShow("��"+Row+"�� �ɹ���ʽ����Ϣ����ȷ:"+BuyType);
				return 0;
			}
		}
		if (PurchaseType!="")
		{
			PurchaseTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurchaseType",PurchaseType);
			if (PurchaseTypeDR=="")
			{
				alertShow("��"+Row+"�� �깺������Ϣ����ȷ:"+PurchaseType);
				return 0;
			}
		}
		if (PurposeType!="")
		{
			PurposeTypeDR=cspRunServerMethod(encmeth,"DHCEQCPurposeType",PurposeType);
			if (PurposeTypeDR=="")
			{
				alertShow("��"+Row+"�� �豸��;����Ϣ����ȷ:"+PurposeType);
				return 0;
			}
		}
		if (UseLoc!="")
		{
			UseLocDR=cspRunServerMethod(encmeth,"CTLoc",UseLoc);
			if (UseLocDR=="")
			{
				alertShow("��"+Row+"�� ʹ�ò��ŵ���Ϣ����ȷ:"+UseLoc);
				return 0;
			}
		}
		if (Expenditures!="")
		{
			ExpendituresDR=cspRunServerMethod(encmeth,"DHCEQCExpenditures",Expenditures);
			if (ExpendituresDR=="")
			{
				alertShow("��"+Row+"�� �豸������Դ����Ϣ����ȷ:"+Expenditures);
				return 0;
			}
		}
		if (parseInt(Quantity)<=0)
		{
			alertShow("��"+Row+"�� �豸��������,������ȷ��������!")
			return 0;
		}
		if (parseInt(Quantity)!=Quantity)
		{
			alertShow("��"+Row+"�� �豸��������,����������С��λ����,��������!");
			return 0;
		}
		//�Զ����ñ������յ�
		var list=ItemInfo.split("^");
		var sort=22;
		var combindata=""; //1	RowID
		combindata=combindata+"^"+list[0]	//GetElementValue("Name") ;//2
		combindata=combindata+"^"+list[1]	//GetElementValue("Code");//3
		combindata=combindata+"^"+PurchaseTypeDR; //4
		combindata=combindata+"^"+list[2]	//GetElementValue("EquipTypeDR"); //5
		combindata=combindata+"^"+list[4]	//GetElementValue("StatCatDR"); //6
		combindata=combindata+"^"+list[3]	//GetElementValue("EquiCatDR"); //7
		combindata=combindata+"^"	//+GetElementValue("MemoryCode"); //8
		combindata=combindata+"^"+BuyTypeDR	//+GetElementValue("BuyTypeDR"); //9     //modified by czf 370967
		combindata=combindata+"^"	//+GetElementValue("StoreLocDR"); //10
		combindata=combindata+"^"	//+GetElementValue("ABCType"); //11
		combindata=combindata+"^"	//+GetElementValue("PackTypeDR"); //12
		combindata=combindata+"^"+list[6]	//GetElementValue("UnitDR"); //13
		if (Model=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var encmeth=GetElementValue("UpdModel");
			var rtn=cspRunServerMethod(encmeth,Model,list[sort+8]);
			combindata=combindata+"^"+rtn; //14	Model
		}
		combindata=combindata+"^"+CountryDR; //15
		combindata=combindata+"^"+list[9]	//GetElementValue("CurrencyDR"); //16
		combindata=combindata+"^"+Quantity; //17
		combindata=combindata+"^"+PurposeTypeDR; //18
		combindata=combindata+"^"	//+GetElementValue("CurrencyFee"); //19
		var val=GetPYCode(Provider)+"^"+Provider+"^"+ProviderHandler+"^"+ProviderTel;
		var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
		combindata=combindata+"^"+rtn;//20
		combindata=combindata+"^"+ProviderHandler; //21	������ϵ��
		combindata=combindata+"^"+ProviderTel; //22
		if (ManuFactory=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(ManuFactory)+"^"+ManuFactory;
			var encmeth=GetElementValue("UpdManuFactory");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;//23
		}
		combindata=combindata+"^"	//+GetElementValue("MakeDate"); //24
		combindata=combindata+"^"+LeaveFactoryDate; //25
		combindata=combindata+"^"	//+GetElementValue("ServiceDR"); //26
		if (Location=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(Location)+"^"+Location;
			var encmeth=GetElementValue("UpdLocation");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;
		}
		combindata=combindata+"^"+GuaranteePeriodNum;
		combindata=combindata+"^"+OriginalFee; //29
		combindata=combindata+"^"	//+GetElementValue("NetRemainFee"); //30
		combindata=combindata+"^"+OriginDR; //31
		combindata=combindata+"^"+UseLocDR; //32
		combindata=combindata+"^"+list[sort+5]	//GetElementValue("LimitYearsNum"); //33
		combindata=combindata+"^"+list[sort+6]	//GetElementValue("DepreMethodDR"); //34
		combindata=combindata+"^"	//+GetElementValue("InstallDate"); //35
		combindata=combindata+"^"	//+GetElementValue("InstallLocDR"); //36
		combindata=combindata+"^"	//+GetElementValue("DesignWorkLoadNum"); //37
		combindata=combindata+"^"	//+GetElementValue("WorkLoadUnitDR"); //38
		combindata=combindata+"^"	//+GetElementValue("GuaranteeStartDate"); //39
		combindata=combindata+"^"	//+GetElementValue("GuaranteeEndDate"); //40
		combindata=combindata+"^"	//+GetElementValue("FromDeptDR"); //41
		combindata=combindata+"^"	//+GetChkElementValue("GuaranteeFlag"); //42
		combindata=combindata+"^"	//+GetChkElementValue("UrgencyFlag"); //43
		combindata=combindata+"^"; //44
		if (MeasureFlag.toUpperCase()=="Y") combindata=combindata+"Y";
		combindata=combindata+"^"	//+GetChkElementValue("MedicalFlag"); //45
		combindata=combindata+"^"	//+GetChkElementValue("TestFlag"); //46
		combindata=combindata+"^"	//+GetElementValue("AffixState"); //47
		combindata=combindata+"^"+CheckResult;	//+GetElementValue("CheckResult"); //48//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("CheckUser"); //49
		combindata=combindata+"^"+ConfigState;	//+GetElementValue("ConfigState"); //50//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+FileState;	//+GetElementValue("FileState"); //51
		combindata=combindata+"^"	//+GetElementValue("OpenState"); //52
		combindata=combindata+"^"+PackageState;	//+GetElementValue("PackageState"); //53//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("RejectReason"); //54
		combindata=combindata+"^"+Remark; //55
		combindata=combindata+"^"+RunningState;	//+GetElementValue("RunningState"); //56//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("ContractListDR"); //57
		combindata=combindata+"^"+ContractNo; //58
		combindata=combindata+"^"+GetElementValue("CheckTypeDR"); //59
		combindata=combindata+"^"+CheckDate; //60
		combindata=combindata+"^"+CheckDate; //61OpenCheckDate
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("ItemDR"); //62
		combindata=combindata+"^0"	//+GetElementValue("Status"); //63
		combindata=combindata+"^"+LeaveFactoryNo; //64
		combindata=combindata+"^"+Hold1; //+GetElementValue("Hold1"); //65	InvoiceInfos//Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+Hold2;	//+GetElementValue("Hold2"); //66 //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("Hold3"); //67
		//Modify By zx 2020-02-18 BUG ZX0074
		if (Brand=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(Brand)+"^"+Brand;
			var encmeth=GetElementValue("UpdBrand");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;//23
		}
		combindata=combindata+"^"	//+GetElementValue("Hold4"); //68
		//combindata=combindata+"^"+GetElementValue("Hold5"); //69
		combindata=combindata+"^"+ExpendituresDR; //69	������Դ20150819  Mozy0159
		combindata=combindata+"^"	//+GetChkElementValue("BenefitAnalyFlag");//65
		combindata=combindata+"^"	//+GetChkElementValue("CommonageFlag");//66
		combindata=combindata+"^"	//+GetChkElementValue("AutoCollectFlag");//67
		combindata=combindata+"^0"  //Modify By zx 2020-02-18 BUG ZX0074 ������Դ����	//+GetElementValue("HSourceType");//68
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("SourceID");//69
		combindata=combindata+"^"	//+GetElementValue("WorkLoadPerMonth");//70
		combindata=combindata+"^"	//+GetElementValue("RequestHold1");//76
		combindata=combindata+"^"	//+GetElementValue("RequestHold2");//77
		combindata=combindata+"^"	//+GetElementValue("RequestHold3");//78
		combindata=combindata+"^"	//+GetElementValue("RequestHold4");//79
		combindata=combindata+"^"	//+GetElementValue("RequestHold5");//80
		combindata=combindata+"^"+list[0]	//GetElementValue("CommonName");//81
		combindata=combindata+"^"	//+GetElementValue("ValueType");//82 ��ֵ����
		combindata=combindata+"^"	//+GetElementValue("DirectionsUse");//83 ʹ�÷���
		combindata=combindata+"^"	//+GetElementValue("UserDR"); //84 UserDR
		combindata=combindata+"^"	//+GetElementValue("AccountShape");  //85 ������ʽ
		combindata=combindata+"^"	//+GetElementValue("ProjectNo"); //86 ��ĿԤ����
		combindata=combindata+"^"	//+GetElementValue("AccountNo");  //87 ���ƾ֤��
		combindata=combindata+"^"+Hold6    //�����־ //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"+Hold7;   //��ҽ��־ //Modify By zx 2020-02-18 BUG ZX0074
		combindata=combindata+"^"	//+GetElementValue("Hold8");
		combindata=combindata+"^"	//+GetElementValue("Hold9");
		combindata=combindata+"^"	//+GetElementValue("Hold10");
		combindata=combindata+"^"+FileNo //GetElementValue("FileNo");  //modified by czf 370967
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") return 0;
		var result=cspRunServerMethod(encmeth,'','',combindata,'2');
		if (result==0) alertShow("��"+i+"�� <"+xlsheet.cells(i,4).text+"> ��Ϣ����ʧ��!!!���ؼ�������Ϣ����������ٴε��������Ϣ.");;
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("����������Ϣ�������!��˶������Ϣ.");
	window.location.reload();
}
// Mozy0247	1190959		2020-02-17
function AllSelect_Clicked()
{
	var SelectAll=0;
	if (getElementValue("AllSelect")==true) SelectAll=1;
	var rows = $("#tDHCEQOpenCheckRequestFind").datagrid('getRows');
	for (var i=0;i<rows.length;i++)
	{
		setColumnValue(i,"TChk",SelectAll);
	}
}
function BatchOpt_Clicked()
{
	var count=0;
	var rows = $('#tDHCEQOpenCheckRequestFind').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		if (getColumnValue(i,"TChk")==1)
		{
			if (valRowIDs!="") valRowIDs=valRowIDs+",";
			valRowIDs=valRowIDs+rows[i].TRowID;
			count=count+1;
		}
	}
	if (count==0)
	{
		messageShow('alert','error','������ʾ','δѡ������ҵ��.');
	}
	else
	{
		messageShow("confirm","","","���Ե�ǰ�б� "+count+" �����յ�����������˴���,ȷ��ִ����?","",ConfirmOpt);
	}
}
function ConfirmOpt()
{
	var tmplist=valRowIDs.split(",");
	var AppInfo=tkMakeServerCall("web.DHCEQApprove","GetApproveInfoBySourceID",7,tmplist[0]);
	var tmpapp=AppInfo.split("^");
	CurRole=GetElementValue("ApproveRole");
	RoleStep=tmpapp[3];
	var AutoInOutInfo=cspRunServerMethod(GetElementValue("GetAutoInOut"),tmplist[0]+"^"+CurRole+"^"+RoleStep);
	var list=AutoInOutInfo.split("^");
	// ��ȡϵͳ��������
	inflag=list[0];
	outflag=list[1];
	if (inflag==1)
	{
		ConfirmInStock();
	}
	else if (inflag==2)
	{
		messageShow("confirm","","","�Ƿ�����Զ�������?","",ConfirmInStock,DisConfirmInStock);
	}
	else
	{
		/*���Զ����*/
		inflag=0;
		outflag=0;
		OptAudit();
	}
}
//�Զ����
function ConfirmInStock()
{
	//�ж���ⵥ�еĿ��������Ƿ����ڿⷿ
	if (cspRunServerMethod(GetElementValue("CheckLocStock"),1,session['LOGON.CTLOCID'])<0)
	{
		messageShow("alert","error","������ʾ","��ǰ��½���Ҳ��ǿⷿ���ܰ����Զ����.")
	}
	else
	{
		if(outflag==1)
		{
			ConfirmStoreMove();
		}
		else if(outflag==2)
		{
			messageShow("confirm","","","�Ƿ�����Զ��������?","",ConfirmStoreMove,DisConfirmStoreMove);
		}
		else
		{
			/*ֻ�Զ����*/
			outflag=0;
			OptAudit();
		}
	}
}
function DisConfirmInStock()
{
	inflag=0;
	outflag=0;
	OptAudit();
}
//�Զ�����
function ConfirmStoreMove()
{
	var ReturnList=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","CheckToLoc",valRowIDs);
	var Templist=ReturnList.split("^");
	if (outflag>0)
	{
		valRowIDs=Templist[1];
		if (Templist[0]=="-1") messageShow("alert","error","������ʾ","�������յ�ʹ�ò��ŵĿ������ʹ���,�䲻�ܰ����Զ�����.")
	}
	outflag=1;
	OptAudit();
}
//���Զ�����
function DisConfirmStoreMove()
{
	outflag=0;
	OptAudit();
}
function OptAudit()
{

	var ReturnList=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","Execute",valRowIDs,CurRole,RoleStep,inflag,outflag);
	if (ReturnList>0)
	{
		 messageShow('','','��ʾ',"ִ�гɹ�!");
		 location.reload();
	}
	else
	{
		messageShow('alert','error','������ʾ',"ִ��ʧ��!");
	}
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
