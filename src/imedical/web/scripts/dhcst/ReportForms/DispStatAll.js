/**
 * 名称: 库存统计-全院消耗统计
 * 最后修改人:yunhaibao
 * 最后修改日期:2015-11-13
 **/
var unitsUrl = 'dhcst.dispstatallaction.csp';
var StrParam = "";
var gIncId = "";
var UserName=session['LOGON.USERNAME'];
var gHospId = session['LOGON.HOSPID'];
var comwidth = 120;
Ext.onReady(function() {
	Ext.QuickTips.init(); // 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var StDateField = new Ext.ux.DateField({
		xtype: 'datefield',
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		invalidText: '无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		anchor: '90%',
		value: new Date
	}) 
	var EndDateField = new Ext.ux.DateField({
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		anchor: '90%',
		value: new Date
	})
	var FindTypeData = [['按药品', '1'], ['按医生科室', '2'], ['按供应商', '3'], ['按基本药物比例', '4'], ['按剂型统计处方', '5']];
	var FindTypeStore = new Ext.data.SimpleStore({
		fields: ['typedesc', 'typeid'],
		data: FindTypeData
	});
	var FindTypeCombo = new Ext.form.ComboBox({
		store: FindTypeStore,
		displayField: 'typedesc',
		mode: 'local',
		anchor: '90%',
		emptyText: '',
		id: 'FindTypeCombo',
		fieldLabel: '统计方式',
		valueField: 'typeid',
		triggerAction: 'all'
	});
	var IOTypeData = [['全部', ''], ['门诊', 'O'], ['住院', 'I']]; 
	var IOTypeStore = new Ext.data.SimpleStore({
		fields: ['desc', 'rowid'],
		data: IOTypeData
	});
	var IOTypeCombo = new Ext.form.ComboBox({
		store: IOTypeStore,
		displayField: 'desc',
		mode: 'local',
		anchor: '90%',
		emptyText: '',
		id: 'IOTypeCombo',
		fieldLabel: '类型',
		valueField: 'rowid',
		triggerAction: 'all'
	}); 
	var PhaLoc = new Ext.ux.DispLocComboBox({
		fieldLabel: '药房科室',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%'
	}); 
	var ExeLoc = new Ext.ux.ExeLocComboBox({
		fieldLabel: '执行科室',
		id: 'ExeLoc',
		name: 'ExeLoc',
		anchor: '90%'
	}); 
	var InciDesc = new Ext.form.TextField({
		fieldLabel: '药品名称',
		id: 'InciDesc',
		name: 'InciDesc',
		anchor: '90%',
		listeners: {
			specialkey: function(field, e) {
				var keyCode = e.getKey();
				if (keyCode == Ext.EventObject.ENTER) {
					GetPhaOrderInfo(field.getValue(), '');
				}
			}
		}
	});
	var BasicFlag = new Ext.form.Checkbox({
		fieldLabel: '基本药物',
		id: 'BasicFlag',
		name: 'BasicFlag',
		anchor: '90%',
		checked: false
	});
	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: '统计',
		tooltip: '统计各药房科室的发退药消耗总数',
		iconCls : 'page_find',
		listeners: {
			"click": function() {
				FindData();
			}
		}
	}) 
	var QueryForm = new Ext.FormPanel({
		labelWidth: 60,
		labelAlign: 'right',
		region: 'north',
		title: '全院消耗统计',
		frame: true,
		height: 170,
		tbar: [FindButton],
		items: [{
			xtype : 'fieldset',
			title : '查询条件',
			style: 'padding-top:5px;padding-bottom:5px',
			defaults:{border:false},
			layout : 'column',	
			
			items: [{				
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [StDateField,EndDateField]
			},
			{
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [IOTypeCombo,FindTypeCombo]
			},
			{
				xtype: 'fieldset',
				columnWidth: .25,
				border: false,
				items: [PhaLoc,ExeLoc]
			},
			{
				xtype: 'fieldset',
				columnWidth: .25,
				border: false,
				items: [InciDesc,BasicFlag]
			}]
		}]
	}); 
	/*Tabs定义*/
	var QueryTabs = new Ext.TabPanel({
		region: 'center',
		id: 'TblTabPanel',
		margins: '3 3 3 0',
		activeTab: 0,
		items: [{
			title: '统计列表',
			id: 'list',
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% style="border:none;" src='+DHCSTBlankBackGround+'></iframe>'
		}],
		listeners: {
			tabchange: function(tp, p) {}
		}
	}); 
	/*框架定义*/
	var port = new Ext.Viewport({
		layout: 'border',
		items: [QueryForm, QueryTabs]
	}); ///----------------Events----------------
	Ext.getCmp("FindTypeCombo").setValue("1");
	Ext.getCmp("IOTypeCombo").setValue("");
	/* 调用药品窗体并返回结果*/
	function GetPhaOrderInfo(item, stkgrp) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "", getDrugList);
		}
	}
	/*返回方法*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");;
		Ext.getCmp("InciDesc").setValue(inciDesc); 
		//Ext.getCmp('InciDr').setValue(inciDr);			
	} 
	/*查询数据*/
	function FindData() {
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		if (findtype == "") {
			Msg.info("error", "统计方式不能为空!");
			return;
		}
		GetStrParam();
		var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
		var p = Ext.getCmp("TblTabPanel").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		if (findtype == "1") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatAll_INCI_Common.raq&input=' + StrParam+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&StartDate='+Ext.getCmp("startdt").getRawValue()+'&EndDate='+Ext.getCmp("enddt").getRawValue()+'&RQDTFormat='+RQDTFormat;
		}else if (findtype == "2") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatAll_DOCLOC_Common.raq&input=' + StrParam+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&StartDate='+Ext.getCmp("startdt").getRawValue()+'&EndDate='+Ext.getCmp("enddt").getRawValue()+'&RQDTFormat='+RQDTFormat;
		}else if(findtype == "3") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatAll_Vendor_Common.raq&input=' + StrParam+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&StartDate='+Ext.getCmp("startdt").getRawValue()+'&EndDate='+Ext.getCmp("enddt").getRawValue()+'&RQDTFormat='+RQDTFormat;
		}else if(findtype == "4") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatAll_BasicRatio_Common.raq&input=' + StrParam+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&StartDate='+Ext.getCmp("startdt").getRawValue()+'&EndDate='+Ext.getCmp("enddt").getRawValue()+'&RQDTFormat='+RQDTFormat;
		}else{
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatAll_PhcformDisp_Common.raq&input=' + StrParam+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&StartDate='+Ext.getCmp("startdt").getRawValue()+'&EndDate='+Ext.getCmp("enddt").getRawValue()+'&RQDTFormat='+RQDTFormat;
		}
	} 
	/*获取参数*/
	function GetStrParam() {
		var sdate = Ext.getCmp("startdt").getRawValue();
		var edate = Ext.getCmp("enddt").getRawValue();
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		var InciDesc = Ext.getCmp("InciDesc").getValue();
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		var exeLoc = Ext.getCmp("ExeLoc").getValue();
		var BasicFlag=(Ext.getCmp("BasicFlag").getValue()==true?'Y':'N'); 
		if (InciDesc == null || InciDesc == "") {
			gIncId = "";
		}
		var IOType=Ext.getCmp("IOTypeCombo").getValue();
		
		StrParam = sdate + "^" + edate + "^" + phaLoc + "^" + gIncId + "^" + findtype + "^" + exeLoc + "^" + BasicFlag+"^"+IOType+"^"+gHospId;
	}
});
