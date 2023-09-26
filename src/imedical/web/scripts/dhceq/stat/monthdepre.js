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
//界面入口
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
	initInsurFlagData();		//在保标志
	//initTopData();	//整体加载数据初始化。
}

//初始化查询头面板
function initTopPanel()
{
	jQuery("#EndDate").datebox("setValue",jQuery("#CurDate").val());
	jQuery("#BFind").linkbutton({iconCls: 'icon-search'});
	jQuery("#BFind").on("click", BFind_Clicked);
	//数值元素定义onchange事件,可校验有效性
	initNumElement("FromOriginalFee^ToOriginalFee^FromYear^ToYear");
	initEquipPanel();			//设备
	initUseLocPanel();			//科室
	initServicePanel();			//维修商
	initMaintUserPanel();		//维修人
	initProviderPanel();			//供应商
	initManuFacturerPanel();		//生产厂家
	initModelPanel();			//型号
	initMaintGroupPanel();		//维修组
	initItemPanel();				//设备项
	initEquipTypePanel();		//设备类组
	initStatCatPanel();			//设备类型
	initEquipCatPanel();			//设备分类
	initFundsTypePanel();			//资金来源
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
	initEquipData();			//设备
	initUseLocData();			//科室
	initServiceData();			//维修商
	initMaintUserData();		//维修人
	initProviderData();			//供应商
	initManuFacturerData();		//生产厂家
	initModelData();			//型号
	initMaintGroupData();		//维修组
	initItemData();				//设备项
	initEquipTypeData();		//设备类组
	initStatCatData();			//设备类型
	initEquipCatData();			//设备分类
	initInsurFlagData();		//在保标志
	initFundsTypeData();		//资金来源
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
/***************************************按钮调用函数*****************************************************/
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