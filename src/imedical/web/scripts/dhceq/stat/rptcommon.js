var SessionObj = {
	GUSERID : curUserID,
	GUSERCODE : curUserCode,
	GUSERNAME : curUserName,
	GGROURPID : session['LOGON.GROUPID'],
	GGROURPDESC : session['LOGON.GROUPDESC'],
	GLOCID : curLocID,
	GHOSPID : session['LOGON.HOSPID'],
	LANGID : session['LOGON.LANGID']
}
var QUERY_URL = {
	QUERY_GRID_URL : "./dhceq.jquery.grid.easyui.csp",
	QUERY_COMBO_URL : "./dhceq.jquery.combo.easyui.csp"
};
var GlobalObj = {
	EquipDR : "",
	BenifitEquipDR : "",         //add by czf
	UseLocDR : "",
	ServiceDR : "",
	MaintUserDR : "",
	ProviderDR : "",
	ManuFacturerDR : "",
	ModelDR : "",
	MaintGroupDR : "",
	ItemDR : "",
	EquipTypeDR : "",
	StatCatDR : "",
	EquipCatDR : "",
	InsurFlagDR : "",
	DisplayTxt : "",
	FundsTypeDR : "",
	HospitalDR : "",
	FinanceTypeDR : "",
	ReportTypeDR : "",
	EQUserDR : "",			//20171107 Mozy0201
	IncludeFinishDR : "",		//20190215	Mozy0219
	ClearData : function(vElementID)
	{
		if (vElementID=="Equip") {this.EquipDR = "";}
		if (vElementID=="BenifitEquip") {this.BenifitEquipDR = "";}
		if (vElementID=="UseLoc") {this.UseLocDR = "";}
		if (vElementID=="Service") {this.ServiceDR = "";}
		if (vElementID=="MaintUser") {this.MaintUserDR = "";}
		if (vElementID=="Provider") {this.ProviderDR = "";}
		if (vElementID=="ManuFacturer") {this.ManuFacturerDR = "";}
		if (vElementID=="Model") {this.ModelDR = "";}
		if (vElementID=="MaintGroup") {this.MaintGroupDR = "";}
		if (vElementID=="Item") {this.ItemDR = "";}
		if (vElementID=="EquipType") {this.EquipTypeDR = "";}
		if (vElementID=="StatCat") {this.StatCatDR = "";}
		if (vElementID=="EquipCat") {this.EquipCatDR = "";}
		if (vElementID=="FundsType") {this.FundsTypeDR = "";}
		if (vElementID=="Hospital") {this.HospitalDR = "";}
		if (vElementID=="FinanceType") {this.FinanceTypeDR = "";}
		if (vElementID=="EQUser") {this.EQUserDR = "";}		//20171107 Mozy0201
	},
	ClearAll : function()
	{
		this.EquipDR = "";
		this.BenifitEquipDR = "";
		this.UseLocDR = "";
		this.ServiceDR = "";
		this.MaintUserDR = "";
		this.ProviderDR = "";
		this.ManuFacturerDR = "";
		this.ModelDR = "";
		this.MaintGroupDR = "";
		this.ItemDR = "";
		this.EquipTypeDR = "";
		this.StatCatDR = "";
		this.EquipCatDR = "";
		this.InsurFlagDR = "";
		this.FundsTypeDR = "";
		this.HospitalDR = "";
		this.FinanceTypeDR = "";
		this.ReportTypeDR = "";
		this.EQUserDR="";					//20171107 Mozy0201
		this.IncludeFinishDR = "";	//20190215	Mozy0219
	}
}

function log(val)
{
	//console.log(val);
}
//Modify By DJ 2017-12-14 JQuery+��Ǭ����������������Ը������ӦJS��
//�������
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);

function initDocument()
{
	//GlobalObj.ClearAll();
	initPanel();
	//setFocus("Equip");;
}

function initPanel()
{
	initTopPanel();
	initInsurFlagData();		//�ڱ���־
	initReportTypeData();		//��������
	initIncludeFinishData();	//���̱�ʶ	20190215	Mozy0219	
	//initTopData();	//����������ݳ�ʼ����
}

//��ʼ����ѯͷ���
function initTopPanel()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BPrint").linkbutton({iconCls: 'icon-print'});
	jQuery("#BPrint").on("click", BPrint_Clicked);
	//��ֵԪ�ض���onchange�¼�,��У����Ч��
	initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");
	initEquipPanel();			//�豸
	initBenifitEquipPanel();			//Ч������豸
	initUseLocPanel();			//����
	initServicePanel();			//ά����
	initMaintUserPanel();		//ά����
	initProviderPanel();			//��Ӧ��
	initManuFacturerPanel();		//��������
	initModelPanel();			//�ͺ�
	initMaintGroupPanel();		//ά����
	initItemPanel();				//�豸��
	initEquipTypePanel();		//�豸����
	initStatCatPanel();			//�豸����
	initEquipCatPanel();			//�豸����
	initFundsTypePanel();			//�ʽ���Դ
	initHospitalPanel();			//Ժ��
	initFinanceTypePanel();
	initEQUserPanel();			//�û�	20171107 Mozy0201
}
function initInsurFlagData()
{
	if (jQuery("#InsurFlag").prop("type")!="hidden")
	{
		jQuery("#InsurFlag").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: 'ȫ��ҵ��'
			},{
				id: '1',
				text: '����'
			},{
				id: 'Y',
				text: '��������'
			},{
				id: 'N',
				text: '��������'
			}],
			onSelect: function() {GlobalObj.InsurFlagDR=jQuery("#InsurFlag").combobox("getValue");}
		});
	}
}
function initReportTypeData()
{
	if (jQuery("#ReportType").prop("type")!="hidden")
	{
		jQuery("#ReportType").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '1',
				text: '�����½�'
			},{
				id: '0',
				text: 'ʵ���½�'
			}],
			onSelect: function() {GlobalObj.ReportTypeDR=jQuery("#ReportType").combobox("getValue");}
		});
	}
}
function initTopData()
{
	initEquipData();			//�豸
	initBenifitEquipData();		//Ч������豸  add by czf
	initUseLocData();			//����
	initServiceData();			//ά����
	initMaintUserData();		//ά����
	initProviderData();			//��Ӧ��
	initManuFacturerData();		//��������
	initModelData();			//�ͺ�
	initMaintGroupData();		//ά����
	initItemData();				//�豸��
	initEquipTypeData();		//�豸����
	initStatCatData();			//�豸����
	initEquipCatData();			//�豸����
	initInsurFlagData();		//�ڱ���־
	initFundsTypeData();		//�ʽ���Դ
	initHospitalData();			//Ժ��
	initFinanceTypeData();
	initEQUserData();			//�û�	20171107 Mozy0201
}
function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Equip") {initEquipData();}
	if (vElementID=="BenifitEquip") {initBenifitEquipData();}      //add by czf
	if (vElementID=="UseLoc") {initUseLocData();}
	if (vElementID=="Service") {initServiceData();}
	if (vElementID=="MaintUser") {initMaintUserData();}
	if (vElementID=="Provider") {initProviderData();}
	if (vElementID=="ManuFacturer") {initManuFacturerData();}
	if (vElementID=="Model") {initModelData();}
	if (vElementID=="MaintGroup") {initMaintGroupData();}
	if (vElementID=="Item") {initItemData();}
	if (vElementID=="EquipType") {initEquipTypeData();}
	if (vElementID=="StatCat") {initStatCatData();}
	if (vElementID=="EquipCat") {initEquipCatData();}
	if (vElementID=="FundsType") {initFundsTypeData();}
	if (vElementID=="Hospital") {initHospitalData();}
	if (vElementID=="FinanceType") {initFinanceTypeData();}
	if (vElementID=="EQUser") {initEQUserData();}		//20171107 Mozy0201
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Equip") {GlobalObj.EquipDR = CurValue;}
	if (vElementID=="BenifitEquip") {GlobalObj.BenifitEquipDR = CurValue;}
	if (vElementID=="UseLoc") {GlobalObj.UseLocDR = CurValue;}
	if (vElementID=="Service") {GlobalObj.ServiceDR = CurValue;}
	if (vElementID=="MaintUser") {GlobalObj.MaintUserDR = CurValue;}
	if (vElementID=="Provider") {GlobalObj.ProviderDR = CurValue;}
	if (vElementID=="ManuFacturer") {GlobalObj.ManuFacturerDR = CurValue;}
	if (vElementID=="Model") {GlobalObj.ModelDR = CurValue;}
	if (vElementID=="MaintGroup") {GlobalObj.MaintGroupDR = CurValue;}
	if (vElementID=="Item") {GlobalObj.ItemDR = CurValue;}
	if (vElementID=="EquipType") {GlobalObj.EquipTypeDR = CurValue;}
	if (vElementID=="StatCat") {GlobalObj.StatCatDR = CurValue;}
	if (vElementID=="EquipCat") {GlobalObj.EquipCatDR = CurValue;}
	if (vElementID=="FundsType") {GlobalObj.FundsTypeDR = CurValue;}
	if (vElementID=="Hospital") {GlobalObj.HospitalDR = CurValue;}
	if (vElementID=="FinanceType") {GlobalObj.FinanceTypeDR = CurValue;}
	if (vElementID=="EQUser") {GlobalObj.EQUserDR = CurValue;}	//20171107 Mozy0201
}
function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});
		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		alertShow("����ȷ������ֵ!")
		return
	}
}
/*****************************************��ʼ���Ŵ�******************************************/
function initEquipPanel()
{
	var vElementID="Equip"
	var vElementName="�豸����"
	var vWidth=450
	var vEditFlag=true
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		jQuery("#"+vElementID).combogrid({
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'���ݼ����С���', 
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		    idField: 'TRowID',    
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:200},
		        {field:'TRowID',title:'ID',width:30,hidden:true},
		        {field:'TFileNo',title:'������',width:80},
		        {field:'TNo',title:'�豸���',width:120},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "����"+vElementName+"�б�ʧ��!");},
			onChange: function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
			onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function initEquipData()
{
	var vParams=jQuery("#Equip").combogrid("getText")+",,,,,"
	initComboData("Equip","web.DHCEQ.Process.DHCEQFind","GetShortEquip",vParams,6)
}
//Ч������豸
//add by czf begin
function initBenifitEquipPanel()
{
	var vElementID="BenifitEquip"
	var vElementName="�豸����"
	var vWidth=550
	var vEditFlag=true
	if (jQuery("#"+vElementID).prop("type")!="hidden")		//��ʾԪ�ؼ���
	{
		jQuery("#"+vElementID).combogrid({
			panelWidth:vWidth,
			border:false,
			checkOnSelect: false, 
			selectOnCheck: false,
			striped: true,
			singleSelect : true,
			url: null,
			fitColumns:false,
			autoRowHeight:false,
			cache: false,
			editable: vEditFlag,
			loadMsg:'���ݼ����С���', 
			rownumbers: true,  //���Ϊtrue������ʾһ���к���
		    idField: 'TRowID',       //add by czf 388779
		    textField: 'TName',
		    pagination:true,
		    pageSize:10,
		    pageNumber:1,
		    pageList:[10,20,30,40,50],
		    columns:[[
		        {field:'TName',title:vElementName,width:250},
		        {field:'TNo',title:'�豸���',width:30,width:100},
		        {field:'TUseLoc',title:'ʹ�ÿ���',width:30,width:200},
		        ]],
		    onLoadSuccess:function(data) {},
		    onLoadError:function() {jQuery.messager.messageShow("","","",vElementName, "����"+vElementName+"�б�ʧ��!");},
			onChange: function(newValue, oldValue){GlobalObj.ClearData(vElementID);},
			onSelect: function(rowIndex, rowData) {SetValue(vElementID);},
		    keyHandler:{
			    query:function(){},
			    enter:function(){ComboGridKeyEnter(vElementID);},
			    up:function(){ComboGridKeyUp(vElementID);},
			    down:function(){ComboGridKeyDown(vElementID);},
			    left:function(){},
			    right:function(){}
			    }
		});
		jQuery("#TD"+vElementID).focusin(function(){LoadData(vElementID)});
	}
}
function initBenifitEquipData()
{
	var GROUPID=session['LOGON.GROUPID']
	var vParams=jQuery("#BenifitEquip").combogrid("getText")+',,'+GROUPID
	initComboData("BenifitEquip","web.DHCEQBenefitAnalyReport","GetBenefitEquip",vParams,3)   //add by czf end
}

function initUseLocPanel()
{
	initComboGrid("UseLoc","��������",400,true);
}
function initUseLocData()
{
	var vParams=","+jQuery("#UseLoc").combogrid("getText")+",,0102,"
	initComboData("UseLoc","web.DHCEQ.Process.DHCEQFind","GetEQLoc",vParams,5)
}
function initServicePanel()
{
	initComboGrid("Service","ά����",400,true);
}
function initServiceData()
{
	var vParams=jQuery("#Service").combogrid("getText")
	initComboData("Service","web.DHCEQ.Process.DHCEQFind","ServiceLookUp",vParams,1)
}
function initMaintUserPanel()
{
	initComboGrid("MaintUser","ά����",400,true);
}
function initMaintUserData()
{
	var vParams=jQuery("#MaintUser").combogrid("getText")
	initComboData("MaintUser","web.DHCEQ.Process.DHCEQFind","User",vParams,1)
}
function initManuFacturerPanel()
{
	initComboGrid("ManuFacturer","��������",400,true);
}
function initManuFacturerData()
{
	var vParams=jQuery("#ManuFacturer").combogrid("getText")
	initComboData("ManuFacturer","web.DHCEQ.Process.DHCEQFind","GetManuFacturer",vParams,1)
}
function initModelPanel()
{
	initComboGrid("Model","����ͺ�",400,true);
}
function initModelData()
{
	var vParams=GlobalObj.ItemDR+","+jQuery("#Model").combogrid("getText")
	initComboData("Model","web.DHCEQ.Process.DHCEQFind","GetModel",vParams,2)
}
function initMaintGroupPanel()
{
	initComboGrid("MaintGroup","ά����",400,true);
}
function initMaintGroupData()
{
	var vParams=jQuery("#MaintGroup").combogrid("getText")
	initComboData("MaintGroup","web.DHCEQ.Process.DHCEQFind","MaintGroupLookUp",vParams,1)
}
function initItemPanel()
{
	initComboGrid("Item","�豸��",400,true);
}
function initItemData()
{
	var vParams=GlobalObj.EquipTypeDR+","+GlobalObj.StatCatDR+","+jQuery("#Item").combogrid("getText")+","
	initComboData("Item","web.DHCEQ.Process.DHCEQFind","GetMasterItem",vParams,4)
}
function initEquipTypePanel()
{
	initComboGrid("EquipType","�豸����",400,true);
}
function initEquipTypeData()
{
	var vParams=jQuery("#EquipType").combogrid("getText")
	initComboData("EquipType","web.DHCEQ.Process.DHCEQFind","GetEquipType",vParams,1)
}
function initStatCatPanel()
{
	initComboGrid("StatCat","�豸����",400,true);
}
function initStatCatData()
{
	var vParams=jQuery("#StatCat").combogrid("getText")+","+GlobalObj.EquipTypeDR
	initComboData("StatCat","web.DHCEQ.Process.DHCEQFind","StatCatLookUp",vParams,2)
}
function initEquipCatPanel()
{
	initComboGrid("EquipCat","�豸����",400,true);
}
function initEquipCatData()
{
	var vParams=jQuery("#EquipCat").combogrid("getText")
	initComboData("EquipCat","web.DHCEQ.Process.DHCEQFind","EquipCatLookUp",vParams,1)
}
function initProviderPanel()
{
	initComboGrid("Provider","��Ӧ��",400,true);
}
function initProviderData()
{
	var vParams=jQuery("#Provider").combogrid("getText")
	initComboData("Provider","web.DHCEQ.Process.DHCEQFind","GetVendor",vParams,1)
}
//�ʽ���Դ
function initFundsTypePanel()
{
	initComboGrid("FundsType","�ʽ���Դ",400,true);
}
function initFundsTypeData()
{
	var vParams=","+jQuery("#FundsType").combogrid("getText")                          //modify by jyp 2018-02-26 546003
	initComboData("FundsType","web.DHCEQ.Process.DHCEQFind","FundsType",vParams,2)  //modify by jyp 2018-02-26 546003
}
//Ժ��
function initHospitalPanel()
{
	initComboGrid("Hospital","Ժ��",400,true);
}
function initHospitalData()
{
	var vParams=jQuery("#Hospital").combogrid("getText")
	initComboData("Hospital","web.DHCEQ.Process.DHCEQFind","GetHospital",vParams,1)
}

//��������
function initFinanceTypePanel()
{
	initComboGrid("FinanceType","��������",400,true);
}
function initFinanceTypeData()
{
	var vParams=jQuery("#FinanceType").combogrid("getText")
	initComboData("FinanceType","web.DHCEQ.Process.DHCEQFind","FinanceType",vParams,1)
}
//�û�	20171107 Mozy0201
function initEQUserPanel()
{
	initComboGrid("EQUser","�û�",400,true);
}
function initEQUserData()
{
	var vParams=jQuery("#UserType").val()+","+jQuery("#EQUser").combogrid("getText");
	initComboData("EQUser","web.DHCEQ.Process.DHCEQFind","EQUser",vParams,2)
}
/***************************************��ť���ú���*****************************************************/
function BPrint_Clicked()
{
	document.getElementById('ReportFilePrint').contentWindow.document.frames["RunQianReport"].report1_print()
}
function GetComboGridDesc(vElements,vElements2)
{
	var ReturnStr=""
	if (vElements!="")
	{
		var ElementsInfo=vElements.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var vElementID=ElementsInfo[i-1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vElementID+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	if (vElements2!="")
	{
		var ElementsInfo=vElements2.split("^");
		for(var i=1; i<=ElementsInfo.length; i++)
		{
			var CurElement=ElementsInfo[i-1]
			var CurElementInfo=CurElement.split("=");
			var vParamName=CurElementInfo[0];
			var vElementID=CurElementInfo[1];
			if (jQuery("#"+vElementID).prop("type")!="hidden")
			{
				ReturnStr=ReturnStr+"&"+vParamName+"="+jQuery("#"+vElementID).combogrid("getText");
			}
		}
	}
	return ReturnStr
}
//20190215	Mozy0219
function initIncludeFinishData()
{
	if (jQuery("#IncludeFinish").prop("type")!="hidden")
	{
		jQuery("#IncludeFinish").combobox({
			height: 24,
			multiple: false,
			editable: false,
			disabled: false,
			readonly: false,
	    	valueField:'id', 
	    	url:null,   
	    	textField:'text',
			data: [{
				id: '',
				text: '��������ɽ���ҵ��'
			},{
				id: 'Y',
				text: 'ȫ��ҵ��'
			}],
			onSelect: function() {GlobalObj.IncludeFinishDR=jQuery("#IncludeFinish").combobox("getValue");}
		});
	}
}