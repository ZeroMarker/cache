var GlobalObj = {
	EquipDR : "",
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
	FundsTypeDR	: "",
	DisplayTxt : "",
	ClearData : function(vElementID)
	{
		if (vElementID=="Equip") {this.EquipDR = "";}
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
	},
	ClearAll : function()
	{
		this.EquipDR = "";
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
	}
}

function log(val)
{
	//console.log(val);
}
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
	//initTopData();	//����������ݳ�ʼ����
}

//��ʼ����ѯͷ���
function initTopPanel()
{
	jQuery("#EndDate").datebox("setValue",jQuery("#CurDate").val());
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	//��ֵԪ�ض���onchange�¼�,��У����Ч��
	initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");
	initEquipPanel();			//�豸
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
				text: 'All'
			},{
				id: 'Y',
				text: 'Yes'
			},{
				id: 'N',
				text: 'No'
			}],
			onSelect: function() {GlobalObj.InsurFlagDR=jQuery("#InsurFlag").combobox("getValue");}
		});
	}
}
function initTopData()
{
	initEquipData();			//�豸
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
}
function LoadData(vElementID)
{
	var ElementTxt = jQuery("#"+vElementID).combogrid("getText");
	if (vElementID=="Equip") {initEquipData();}
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
	jQuery("#"+vElementID).combogrid("setValue",ElementTxt);
}
function SetValue(vElementID)
{
	var CurValue=jQuery("#"+vElementID).combogrid("getValue");
	if (vElementID=="Equip") {GlobalObj.EquipDR = CurValue;}
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
}
/***************************************��ť���ú���*****************************************************/
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pMonthStr="+jQuery("#MonthStr").val();
	lnk=lnk+"&pUseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&pEquipNo="+jQuery("#EquipNo").val();
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pFundsTypeDR="+GlobalObj.FundsTypeDR;
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
}