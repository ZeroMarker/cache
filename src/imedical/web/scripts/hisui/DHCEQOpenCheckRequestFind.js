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
	initButtonColor();//cjc 2023-01-17 ���ü��������ť��ɫ
	initPanelHeaderStyle();//cjc 2023-01-17 ��ʼ�����������ʽ
}

function InitEvent()
{
	KeyUp("Equip^ManuFactory^Provider^Status^Hospital^MakeUser^UseLoc");	//���ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	Muilt_LookUp("Equip^ManuFactory^Provider^Status^Hospital^MakeUser^UseLoc"); //�س�ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	var obj = document.getElementById("BBatchPrint");	//������ӡ zyq 2022-10-18
	if (obj) obj.onclick = BBatchPrint_Clicked;
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BImport",true);
		//add by ZY0306 20220704  ���Ӹ����豸���빦��
		DisableBElement("BImportConfig",true);
		// Mozy0247	1190959		2020-02-17
		var obj=document.getElementById("BatchOpt");
		if (obj) obj.onclick=BatchOpt_Clicked;
		EQCommon_HiddenElement("BBatchPrint");//add by zyq 2023-02-11
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
		//HiddenTblColumn("tDHCEQOpenCheckRequestFind", "TChk");
		var obj = document.getElementById("BAdd");
		if (obj) obj.onclick = BAdd_Click;
		var obj = document.getElementById("BImport");
		if (obj) obj.onclick = BImport_Click;
		//add by ZY0306 20220704  ���Ӹ����豸���빦��
		var obj=document.getElementById("BImportConfig");
		if (obj) obj.onclick=BImportConfig_Clicked;
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
		EQCommon_HiddenElement("BBatchPrint");//add by zyq 2023-02-11
		// Mozy0253	1215648		2020-3-4	����CheckBoxԪ�ؼ���Ԫ��
		$("#AllSelect").parent().empty();
		EQCommon_HiddenElement("cAllSelect");
		HiddenTblColumn("tDHCEQOpenCheckRequestFind","TChk");
	}
	// Mozy0247	1190959		2020-02-17
	var obj=document.getElementById("AllSelect");
	if (obj) obj.onclick=AllSelect_Clicked;
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	$HUI.datagrid("#tDHCEQOpenCheckRequestFind",{
		nowrap:false,
	})
	//Add By QW20210629 BUG:QW0131 Ժ�� end
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
	//modified  by ZY0306 20220704  ���ӻص�������ˢ�½���
	showWindow(url,"�豸���չ���","","","icon-w-paper","modal","","","large",BFind_Click);	//modified by lmm 2020-06-04 UI
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
	val=val+"&StatusDR="+GetElementValue("StatusDR");
	val=val+"&StartDate="+GetElementValue("StartDate");
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
	if ("function"==typeof websys_getMWToken){
		val += "&MWToken="+websys_getMWToken()
	}
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
	val=val+"^HospitalDR="+GetElementValue("HospitalDR");   //Add By QW20210629 BUG:QW0131 Ժ��
	val=val+"^MakeUserDR="+GetElementValue("MakeUserDR");	//add by czf 2022-10-25
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");	//add by ZY0270 20210616
	
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
	val=val+"hos=Hospital="+GetElementValue("HospitalDR")+"^"; //Add By QW20210629 BUG:QW0131 Ժ��
	val=val+"user=MakeUser="+GetElementValue("MakeUserDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^";
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
    if (vdata1=='') return;     //��ʼ������Ϊ��Ĭ�ϲ���ѯ
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
	var url="dhceq.tools.dataimport.csp?&BussType=11";
	showWindow(url,"���ݵ���","","","icon-w-paper","modal","","","large",function(){
		$("#tDHCEQOpenCheckRequestFind").datagrid('reload');
	});
	/*
	if (GetElementValue("ChromeFlag")=="1")
	{
		BImport_Chrome()
	}
	else
	{
		BImport_IE()
	}
	*/
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
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
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
		var EquipType=trim(RowInfo[Row-1][Col++]);		//czf 20200811
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
		if (Provider=="")		// MZY0141	2969623,2969850		2022-11-02
		{
			alertShow("��Ӧ�̲���Ϊ��!");
		    return 0;
		}
		if (EquipType=="")		//modified by czf 20200811 begin 1456821
		{
			alertShow("�豸���鲻��Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		var EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
		if (EquipTypeDR=="")
		{
			alertShow("��"+Row+"�� ������Ϣ����ȷ:"+EquipType);
			return 0;
		}
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetItemInfo");
		var ItemInfo=cspRunServerMethod(encmeth,Name,EquipTypeDR);	//modified by czf 20200811 end
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
		//modified  by ZY0306 20220704  �豸���ṹ�޸�
		var sort=26;	
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
		//combindata=combindata+"^"	//+GetElementValue("Hold4"); //68  //Modefied by zc0100 2021-3-15 ��Ϣƴ����λ����
		//combindata=combindata+"^"+GetElementValue("Hold5"); //69
		combindata=combindata+"^"+ExpendituresDR; //69	������Դ20150819  Mozy0159
		combindata=combindata+"^"	//+GetChkElementValue("BenefitAnalyFlag");//65
		combindata=combindata+"^"	//+GetChkElementValue("CommonageFlag");//66
		combindata=combindata+"^"	//+GetChkElementValue("AutoCollectFlag");//67
		combindata=combindata+"^0"  //Modify By zx 2020-02-18 BUG ZX0074 ������Դ����	//+GetElementValue("HSourceType");//68
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("SourceID");//69
		combindata=combindata+"^"	//+GetElementValue("WorkLoadPerMonth");//70
		combindata=combindata+"^"	//+GetElementValue("RequestHold1");//76
		combindata=combindata+"^"+curSSHospitalID	//+GetElementValue("RequestHold2");//77		 MZY0141	2969623,2969850		2022-11-02
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
		var EquipType=trim(xlsheet.cells(Row,Col++).text);		//czf 20200811
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
		if (Provider=="")		// MZY0141	2969623,2969850		2022-11-02
		{
			alertShow("��Ӧ�̲���Ϊ��!");
		    return 0;
		}
		if (EquipType=="")		//modified by czf 20200811 begin
		{
			alertShow("�豸���鲻��Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		var EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
		if (EquipTypeDR=="")
		{
			alertShow("��"+Row+"�� ������Ϣ����ȷ:"+EquipType);
			return 0;
		}
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetItemInfo");
		var ItemInfo=cspRunServerMethod(encmeth,Name,EquipTypeDR);		//modified by czf 20200811 end
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
		var sort=26;	// MZY0145	2969850		2022-11-30
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
		//combindata=combindata+"^"	//+GetElementValue("Hold4"); //68	MZY0058	1549254		2020-10-18
		if (Brand=="")
		{
			combindata=combindata+"^";
		}
		else
		{
			var val=GetPYCode(Brand)+"^"+Brand;
			var encmeth=GetElementValue("UpdBrand");
			var rtn=cspRunServerMethod(encmeth,val);
			combindata=combindata+"^"+rtn;
		}
		//combindata=combindata+"^"+GetElementValue("Hold5"); //69
		combindata=combindata+"^"+ExpendituresDR; //69	������Դ20150819  Mozy0159
		combindata=combindata+"^"	//+GetChkElementValue("BenefitAnalyFlag");//70
		combindata=combindata+"^"	//+GetChkElementValue("CommonageFlag");//71
		combindata=combindata+"^"	//+GetChkElementValue("AutoCollectFlag");//72
		combindata=combindata+"^0"  //Modify By zx 2020-02-18 BUG ZX0074 ������Դ����	//+GetElementValue("HSourceType");//73
		combindata=combindata+"^"+list[sort+8]	//GetElementValue("SourceID");//74
		combindata=combindata+"^"	//+GetElementValue("WorkLoadPerMonth");//75
		combindata=combindata+"^"	//+GetElementValue("RequestHold1");//76
		combindata=combindata+"^"+curSSHospitalID	//+GetElementValue("RequestHold2");//77		 MZY0141	2969623,2969850		2022-11-02
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
		combindata=combindata+"^^^^^^^"+Hold11	//100 ��Ŀ����  MZY0058	1549254		2020-10-18
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
	if (cspRunServerMethod(GetElementValue("CheckLocStock"),1,curLocID)<0)			//modified by czf 2020-12-08 1638785
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
	///modified by ZY0259  20210402
	var LocListFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",201015);
	var ReturnList=tkMakeServerCall("web.DHCEQ.EM.BUSOpenCheckRequest","CheckToLoc",valRowIDs);
	var Templist=ReturnList.split("^");
	if (outflag>0)
	{
		valRowIDs=Templist[1];
		///modified by ZY0266  20210531
		if (LocListFlag!=1)
		{
			if (Templist[0]=="-1")
			{
				alertShow("�������յ�ʹ�ò��ŵĿ������ʹ���,�䲻�ܰ����Զ�����.");
				return;
			}
		}
		else
		{
			if (Templist[0]!=0)
			{
				alertShow(Templist[0]+",�䲻�ܰ����Զ�����.");
				return;
			}
		}
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
//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}

//add by ZY0306 20220704  ���Ӹ����豸���빦��
function BImportConfig_Clicked()
{
	if (GetElementValue("ChromeFlag")=="1")
	{
		BImportConfig_Chrome()
	}
	else
	{
		BImportConfig_IE()
	}
}

function BImportConfig_Chrome()
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
	if ((RowInfo=="")||(RowInfo.length<=1))		//add by czf 20200611 1342552 begin		//czf 20200811 1456821
	{
		alertShow("û�����ݵ��룡")
		return 0;
	}		//add by czf 20200611 1342552 end
	var Error=""
	for (var Row=2;Row<=RowInfo.length;Row++)
	{
		var Col=0;
		var CheckRequestNo=trim(RowInfo[Row-1][Col++]);
		var EquipType=trim(RowInfo[Row-1][Col++]);
		var StatCat=trim(RowInfo[Row-1][Col++]);
		var EquipCat=trim(RowInfo[Row-1][Col++]);
		var Name=trim(RowInfo[Row-1][Col++]);
		var Unit=trim(RowInfo[Row-1][Col++]);
		var UnitDR=""
		var OriginalFee=trim(RowInfo[Row-1][Col++]);
		var Quantity=trim(RowInfo[Row-1][Col++]);
		var Model=trim(RowInfo[Row-1][Col++]);
		var Specs=trim(RowInfo[Row-1][Col++]);
		var Brand=trim(RowInfo[Row-1][Col++]);
		var BrandDR=""
		var ManuFactory=trim(RowInfo[Row-1][Col++]);
		var ManuFactoryDR="";
		var Country=trim(RowInfo[Row-1][Col++]); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
		var LeaveFactoryDate=trim(RowInfo[Row-1][Col++]);
		var GuaranteePeriodNum=trim(RowInfo[Row-1][Col++]);
		var Remark=trim(RowInfo[Row-1][Col++]);
		var Location=trim(RowInfo[Row-1][Col++]);
		var MeasureFlag=trim(RowInfo[Row-1][Col++]);
		var JiJiu=trim(RowInfo[Row-1][Col++]);  //�������־
		var CFDA=trim(RowInfo[Row-1][Col++]);  //ҽ����е����
		var CFDADR="";
		if (EquipType=="")
		{
			alertShow("�豸���鲻��Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		var SourceID=cspRunServerMethod(encmeth,"DHCEQOpenCheckRequest",CheckRequestNo);
		if ((SourceID=="")||(typeof(SourceID) == undefined))
		{
			alertShow("��"+Row+"�� ���յ�����Ϣ����ȷ:"+CheckRequestNo);
			return 0;
		}
		var EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
		if ((EquipTypeDR=="")||(typeof(EquipTypeDR) == undefined))
		{
			alertShow("��"+Row+"�� ������Ϣ����ȷ:"+EquipType);
			return 0;
		}
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var ItemDR=cspRunServerMethod(encmeth,"DHCEQCMasterItem",Name,EquipTypeDR);	//modified by czf 20200811 end
		if (ItemDR=="")
		{
			alertShow("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		if (Country!="")
		{
			CountryDR=cspRunServerMethod(encmeth,"CTCountry",Country);
			if ((CountryDR=="")||(typeof(CountryDR) == undefined))
			{
				alertShow("��"+Row+"�� �������Ϣ����ȷ:"+Country);
				return 0;
			}
		}
		if (ManuFactory!="")
		{
			ManuFactoryDR=cspRunServerMethod(encmeth,"DHCEQCVendor",ManuFactory);
			if ((ManuFactoryDR=="")||(typeof(ManuFactoryDR) == undefined))
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+ManuFactory);
				return 0;
			}
		}
		if (Unit!="")
		{
			UnitDR=cspRunServerMethod(encmeth,"DHCEQCUOM",Unit);
			if ((UnitDR=="")||(typeof(UnitDR) == undefined))
			{
				alertShow("��"+Row+"�� ��λ����Ϣ����ȷ:"+Unit);
				return 0;
			}
		}
		if (Brand!="")
		{
			BrandDR=cspRunServerMethod(encmeth,"Brand",Brand);
			if ((BrandDR=="")||(typeof(BrandDR) == undefined))
			{
				alertShow("��"+Row+"�� Ʒ�Ƶ���Ϣ����ȷ:"+Brand);
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
		
		var combindata="";//1	RowID
		combindata=combindata+"^"+"1"			//getElementValue("CType");
		combindata=combindata+"^"+"1"			//getElementValue("CSourceType");
		combindata=combindata+"^"+SourceID		//getElementValue("CSourceID");
		combindata=combindata+"^"+ItemDR	//getElementValue("CItemDR");
		combindata=combindata+"^"+Name			//NamegetElementValue("CItem");
		combindata=combindata+"^"+OriginalFee	//getElementValue("CPrice");
		combindata=combindata+"^"+Quantity		//getElementValue("CQuantityNum");
		combindata=combindata+"^"+UnitDR		//getElementValue("CUnitDR");
		combindata=combindata+"^"+Brand			//getElementValue("CBrandDR");
		combindata=combindata+"^"+""			//getElementValue("CProviderDR");
		combindata=combindata+"^"+ManuFactoryDR	//getElementValue("CManuFactoryDR");
		combindata=combindata+"^"+Specs			//getElementValue("CSpec");
		combindata=combindata+"^"+Model			//getElementValue("CModel");
		combindata=combindata+"^"+""			//getElementValue("CParameters");
		combindata=combindata+"^"+GuaranteePeriodNum			//getElementValue("CGuaranteePeriodNum");
		combindata=combindata+"^"+CountryDR		//getElementValue("CCountryDR");
		combindata=combindata+"^"+LeaveFactoryNo			//getElementValue("CLeaveFacNo");
		combindata=combindata+"^"+LeaveFactoryDate			//getElementValue("CLeaveDate");
		combindata=combindata+"^"+Location			//getElementValue("CLocation");
		combindata=combindata+"^"+""			//
		combindata=combindata+"^"+MeasureFlag  ;
		combindata=combindata+"^";
	  	combindata=combindata+"^";
	  	combindata=combindata+"^";
	  	combindata=combindata+"^";
		combindata=combindata+"^"			//+getElementValue("CInvoiceNo");
		combindata=combindata+"^"			//+getElementValue("COpenFlag");
		combindata=combindata+"^"+Remark			//getElementValue("CRemark");
	  	combindata=combindata+"^";  ///Status
		combindata=combindata+"^"			//getElementValue("ServiceHandler");
		combindata=combindata+"^"			//getElementValue("ServiceTel");
		combindata=combindata+"^"			//getElementValue("Hold1");
		combindata=combindata+"^"+JiJiu			//getElementValue("Hold2");
		combindata=combindata+"^"			//getElementValue("Hold3");
		combindata=combindata+"^"			//getElementValue("Hold4");
		combindata=combindata+"^"			//getElementValue("Hold5");
		
		var result=tkMakeServerCall("web.DHCEQ.EM.BUSConfig","SaveData",combindata);
		result=result.split("^");
		if (result[0]<0)
		{
			Error="��"+Row+"��ǰ��������Ѿ�������ɣ���"+Row+"����Ϣ����ʧ��,��鿴����!!!"
			alertShow(result);
			Row=RowInfo.length+1
		}
	}
	if (Error=="")
	{
		messageShow('alert','info','��ʾ','�������յ���Ӧ�����豸�������!��˶������Ϣ.','',importreload,'');		
	}
}

function BImportConfig_IE()
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
	xlsheet =xlBook.Worksheets("�����豸");
	xlsheet = xlBook.ActiveSheet;
	var ExcelRows=xlsheet.UsedRange.Cells.Rows.Count;
	for (var Row=2;Row<=ExcelRows;Row++)
	{
		var Col=1;
		var CheckRequestNo=trim(RowInfo[Row-1][Col++]);
		var EquipType=trim(RowInfo[Row-1][Col++]);
		var StatCat=trim(RowInfo[Row-1][Col++]);
		var EquipCat=trim(RowInfo[Row-1][Col++]);
		var Name=trim(RowInfo[Row-1][Col++]);
		var Unit=trim(RowInfo[Row-1][Col++]);
		var UnitDR=""
		var OriginalFee=trim(RowInfo[Row-1][Col++]);
		var Quantity=trim(RowInfo[Row-1][Col++]);
		var Model=trim(RowInfo[Row-1][Col++]);
		var Specs=trim(RowInfo[Row-1][Col++]);
		var Brand=trim(RowInfo[Row-1][Col++]);
		var BrandDR=""
		var ManuFactory=trim(RowInfo[Row-1][Col++]);
		var ManuFactoryDR="";
		var Country=trim(RowInfo[Row-1][Col++]); 
		var CountryDR="";   
		var LeaveFactoryNo=trim(RowInfo[Row-1][Col++]);
		var LeaveFactoryDate=trim(RowInfo[Row-1][Col++]);
		var GuaranteePeriodNum=trim(RowInfo[Row-1][Col++]);
		var Remark=trim(RowInfo[Row-1][Col++]);
		var Location=trim(RowInfo[Row-1][Col++]);
		var MeasureFlag=trim(RowInfo[Row-1][Col++]);
		var JiJiu=trim(RowInfo[Row-1][Col++]);  //�������־
		var CFDA=trim(RowInfo[Row-1][Col++]);  //ҽ����е����
		var CFDADR="";
		if (EquipType=="")
		{
			alertShow("�豸���鲻��Ϊ��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		var SourceID=cspRunServerMethod(encmeth,"DHCEQOpenCheckRequest",CheckRequestNo);
		if ((SourceID=="")||(typeof(SourceID) == undefined))
		{
			alertShow("��"+Row+"�� ���յ�����Ϣ����ȷ:"+CheckRequestNo);
			return 0;
		}
		var EquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",EquipType);
		if ((EquipTypeDR=="")||(typeof(EquipTypeDR) == undefined))
		{
			alertShow("��"+Row+"�� ������Ϣ����ȷ:"+EquipType);
			return 0;
		}
		if (Name=="")
		{
		    alertShow("�豸����Ϊ��!");
		    return 0;
		}
		var ItemDR=cspRunServerMethod(encmeth,"DHCEQCMasterItem",Name,EquipTypeDR);	//modified by czf 20200811 end
		if ((ItemDR=="")||(typeof(ItemDR) == undefined))
		{
			alertShow("��"+Row+"�� "+Name+":��δ�����豸��,���ȶ����豸��!");
		    return 0;
		}
		var encmeth=GetElementValue("GetIDByDesc");
		if (Country!="")
		{
			CountryDR=cspRunServerMethod(encmeth,"CTCountry",Country);
			if ((CountryDR=="")||(typeof(CountryDR) == undefined))
			{
				alertShow("��"+Row+"�� �������Ϣ����ȷ:"+Country);
				return 0;
			}
		}
		if (ManuFactory!="")
		{
			ManuFactoryDR=cspRunServerMethod(encmeth,"DHCEQCVendor",ManuFactory);
			if ((ManuFactoryDR=="")||(typeof(ManuFactoryDR) == undefined))
			{
				alertShow("��"+Row+"�� �������ҵ���Ϣ����ȷ:"+ManuFactory);
				return 0;
			}
		}
		if (Unit!="")
		{
			UnitDR=cspRunServerMethod(encmeth,"DHCEQCUOM",Unit);
			if ((UnitDR=="")||(typeof(UnitDR) == undefined))
			{
				alertShow("��"+Row+"�� ��λ����Ϣ����ȷ:"+Unit);
				return 0;
			}
		}
		if (Brand!="")
		{
			BrandDR=cspRunServerMethod(encmeth,"Brand",Brand);
			if ((BrandDR=="")||(typeof(BrandDR) == undefined))
			{
				alertShow("��"+Row+"�� Ʒ�Ƶ���Ϣ����ȷ:"+Brand);
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
		var combindata="";//1	RowID
		combindata=combindata+"^"+"1"			//getElementValue("CType");
		combindata=combindata+"^"+"1"			//getElementValue("CSourceType");
		combindata=combindata+"^"+SourceID		//getElementValue("CSourceID");
		combindata=combindata+"^"+ItemDR	//getElementValue("CItemDR");
		combindata=combindata+"^"+Name			//NamegetElementValue("CItem");
		combindata=combindata+"^"+OriginalFee	//getElementValue("CPrice");
		combindata=combindata+"^"+Quantity		//getElementValue("CQuantityNum");
		combindata=combindata+"^"+UnitDR		//getElementValue("CUnitDR");
		combindata=combindata+"^"+Brand			//getElementValue("CBrandDR");
		combindata=combindata+"^"+""			//getElementValue("CProviderDR");
		combindata=combindata+"^"+ManuFactoryDR	//getElementValue("CManuFactoryDR");
		combindata=combindata+"^"+Spec			//getElementValue("CSpec");
		combindata=combindata+"^"+Model			//getElementValue("CModel");
		combindata=combindata+"^"+""			//getElementValue("CParameters");
		combindata=combindata+"^"+GuaranteePeriodNum			//getElementValue("CGuaranteePeriodNum");
		combindata=combindata+"^"+CountryDR		//getElementValue("CCountryDR");
		combindata=combindata+"^"+LeaveFactoryNo			//getElementValue("CLeaveFacNo");
		combindata=combindata+"^"+LeaveFactoryDate			//getElementValue("CLeaveDate");
		combindata=combindata+"^"+Location			//getElementValue("CLocation");
		combindata=combindata+"^"+""			//
		combindata=combindata+"^"+MeasureFlag  ;
		combindata=combindata+"^";
	  	combindata=combindata+"^";
	  	combindata=combindata+"^";
	  	combindata=combindata+"^";
		combindata=combindata+"^"			//+getElementValue("CInvoiceNo");
		combindata=combindata+"^"				//+getElementValue("COpenFlag");
		combindata=combindata+"^"+Remark			//getElementValue("CRemark");
	  	combindata=combindata+"^";  			///Status
		combindata=combindata+"^"			//getElementValue("ServiceHandler");
		combindata=combindata+"^"			//getElementValue("ServiceTel");
		combindata=combindata+"^"			//getElementValue("Hold1");
		combindata=combindata+"^"+JiJiu			//getElementValue("Hold2");
		combindata=combindata+"^"			//getElementValue("Hold3");
		combindata=combindata+"^"			//getElementValue("Hold4");
		combindata=combindata+"^"			//getElementValue("Hold5");
		
		var encmeth=GetElementValue("updConfig");
		if (encmeth=="") return 0;
		var result=cspRunServerMethod(encmeth,combindata);
		result=result.replace(/\\n/g,"\n");
		list=result.split("^");
		if (list[0]<0)
		{
			Error="��"+Row+"��ǰ��������Ѿ�������ɣ���"+Row+"����Ϣ����ʧ��,���ؼ�������Ϣ����������ٴε��������Ϣ.!!!"
			alertShow(Error);
			Row=RowInfo.length+1
		}
	}
	xlsheet.Quit;
	xlsheet=null;
	xlBook.Close (savechanges=false);
	xlApp=null;
	alertShow("���յ���Ӧ�����豸�������!��˶������Ϣ.");
	window.location.reload();
	
}

function GetMakeUser(value)
{
	var user=value.split("^");
	var obj=document.getElementById("MakeUserDR");
	obj.value=user[1];
}

function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=user[1];
}
///add by zyq 2023-02-11 begin ������ӡ
function BBatchPrint_Clicked() {
	var PrintRowIDs = ""
	var count = 0;
	var rows = $('#tDHCEQOpenCheckRequestFind').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) {
		if (getColumnValue(i, "TChk") == 1) {
			if (PrintRowIDs != "") PrintRowIDs = PrintRowIDs + ",";
			PrintRowIDs = PrintRowIDs + rows[i].TRowID;
			count = count + 1;
		}
	}
	if (count == 0) {
		messageShow('alert', 'error', '������ʾ', 'δѡ�����յ�.');
	}
	else {
		PrintOpt(PrintRowIDs);
	}
}
function PrintOpt(PrintRowIDs) {
	//modify by zyq 2023-02-11 begin �м����ӡʱ����������Ҫsettimeout9��
	var RowIDArr = PrintRowIDs.split(",");
	var timelist = []
	RowIDArr.forEach(function (RowID, index) {
		if (RowID == "") return
		var CheckListDR = tkMakeServerCall("web.DHCEQOpenCheckRequest", "GetCheckListID", RowID);
		if (CheckListDR == "") return
		//��ӡ���յ�
		var timer = setTimeout(function timer() {
			PrintOpenCheck(RowID, CheckListDR);
			clearTimeout(timelist[index])
		}, 2000 * index);
		timelist[index] = timer
	});
	//modify by zyq 2023-02-11 end
}
function PrintOpenCheck(RowID, CheckListDR) {
	var PrintFlag = tkMakeServerCall("web.DHCEQCommon", "GetSysInfo", "990062");
	var PrintBuss = tkMakeServerCall("web.DHCEQCommon", "GetSysInfo", 990087);
	var PrintNumFlag = tkMakeServerCall("web.DHCEQCommon", "Find", PrintBuss, "11", "N");
	var id = CheckListDR
	if ((id == "") || (id < 1))
		return;
	if (PrintFlag == 0) {
		Print(RowID, CheckListDR);
	}
	if (PrintFlag == 1) {
		var PreviewRptFlag = tkMakeServerCall("web.DHCEQCommon", "GetSysInfo", "990075"); //add by wl 2019-11-11 WL0010 begin   ������ǬԤ����־
		var fileName = "";
		//Add By QW20210913 BUG:QW0147 �������Ӳ�����	begin
		var EQTitle = "";
		if (PrintNumFlag == 1) {
			var num = tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog", "GetOperateTimes", "11", id)
			if (num > 0) EQTitle = "(����)";
		}
		//Add By QW20210913 BUG:QW0147 �������Ӳ�����	end
		if (PreviewRptFlag == 0) {
			fileName = "{DHCEQOpenCheck.raq(TRowID=" + id + ";EQTitle=" + EQTitle + ")}"; //Modified By QW20210913 BUG:QW0147 �������Ӳ�����
			DHCCPM_RQDirectPrint(fileName);
		}
		if (PreviewRptFlag == 1) {
			fileName = "DHCEQOpenCheck.raq&TRowID=" + id + "&EQTitle=" + EQTitle; //Modified By QW20210913 BUG:QW0147 �������Ӳ�����
			DHCCPM_RQPrint(fileName);
		}		//add by wl 2019-11-11 WL0010 end
	}
	//Modified By QW20210913 BUG:QW0147	begin
	var OpenCheckOperateInfo = "^11^" + id + "^^���մ�ӡ����^0"
	var PrintFlag = tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog", "SaveData", OpenCheckOperateInfo)
	//Modified By QW20210913 BUG:QW0147 end

}

//add by jdl 2010-4-19
function Print(RowID) {
	if ((RowID == "") || (RowID < 1)) {
		return;
	}
	var ReturnList = tkMakeServerCall("web.DHCEQOpenCheckRequest", "GetOneOpenCheckRequest", RowID);
	ReturnList = ReturnList.replace(/\\n/g, "\n");
	list = ReturnList.split("^");
	var TemplatePath = tkMakeServerCall("web.DHCEQStoreMoveSP", "GetPath", RowID);

	try {
		var xlApp, xlsheet, xlBook;
		var Template = TemplatePath + "DHCEQOpenCheck.xls";
		xlApp = new ActiveXObject("Excel.Application");

		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		//Add By QW20210913 BUG:QW0147 �������Ӳ�����	begin
		if (PrintNumFlag == 1) {
			var num = tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog", "GetOperateTimes", "11", RowID)
			if (num > 0) {
				xlsheet.cells(2, 1) = "�豸���յ�(����)"

			}
		}
		//Add By QW20210913 BUG:QW0147 �������Ӳ�����	end
		xlsheet.cells(3, 2) = list[4];		//����
		xlsheet.cells(3, 6) = curUserName;	//�Ƶ���	modified by csj 20190528	usernameȫ�ֱ�������ΪcurUserName
		xlsheet.cells(4, 2) = list[68];	//����
		xlsheet.cells(4, 6) = list[12];	//�豸��Դ
		xlsheet.cells(5, 2) = list[34];	//��������
		xlsheet.cells(5, 6) = list[26];	//�ͺŹ��
		xlsheet.cells(6, 2) = list[73];	//ԭֵ
		xlsheet.cells(6, 4) = list[72];	//����
		xlsheet.cells(6, 6) = list[73] * list[72];	//�ܶ�

		xlsheet.cells(7, 2) = GetShortName(list[10], "-");  //��Ӧ��
		xlsheet.cells(7, 6) = ChangeDateFormat(list[49]);  //��������
		xlsheet.cells(8, 2) = GetShortName(list[38], "-");  //ʹ�ÿ���
		xlsheet.cells(8, 6) = list[32];	//��;

		xlsheet.cells(9, 2) = list[92];  //���к�
		//add by zyq 2023-02-14 begin
		if (LeaveFactoryNo != "") {
			xlsheet.cells(10, 2) = "�������:" + LeaveFactoryNo; //��ע
		}
		else {
			xlsheet.cells(10, 2) = "�������:" + document.getElementById("LeaveFactoryNo").value;
		}
		//add by zyq 2023-02-14 end
		// xlsheet.cells(10,2)=list[61]//��ע

		xlsheet.cells(11, 2) = ChangeDateFormat(GetCurrentDate());  //��ӡ����
		//xlsheet.cells(11,6)=;  //������ǩ��
		//ChangeDateFormat(lista[3])

		//var obj = new ActiveXObject("PaperSet.GetPrintInfo");		/// 20150327  Mozy0153
		//var size=obj.GetPaperInfo("DHCEQInStock");
		//if (0!=size) xlsheet.PageSetup.PaperSize = size;
		xlsheet.printout; //��ӡ���
		//xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
		xlBook.Close(savechanges = false);

		xlsheet.Quit;
		xlsheet = null;
		xlApp = null;
	}
	catch (e) {
		messageShow("", "", "", e.message);
	}
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
