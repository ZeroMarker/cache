/**
 * ����: ���ͳ��-ȫԺ����ͳ��
 * ����޸���:yunhaibao
 * ����޸�����:2015-11-13
 **/
var unitsUrl = 'dhcst.dispstatallaction.csp';
var StrParam = "";
var gIncId = "";
var UserName=session['LOGON.USERNAME'];
var gHospId = session['LOGON.HOSPID'];
var comwidth = 120;
Ext.onReady(function() {
	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var StDateField = new Ext.ux.DateField({
		xtype: 'datefield',
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		anchor: '90%',
		value: new Date
	}) 
	var EndDateField = new Ext.ux.DateField({
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		anchor: '90%',
		value: new Date
	})
	var FindTypeData = [['��ҩƷ', '1'], ['��ҽ������', '2'], ['����Ӧ��', '3'], ['������ҩ�����', '4'], ['������ͳ�ƴ���', '5']];
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
		fieldLabel: 'ͳ�Ʒ�ʽ',
		valueField: 'typeid',
		triggerAction: 'all'
	});
	var IOTypeData = [['ȫ��', ''], ['����', 'O'], ['סԺ', 'I']]; 
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
		fieldLabel: '����',
		valueField: 'rowid',
		triggerAction: 'all'
	}); 
	var PhaLoc = new Ext.ux.DispLocComboBox({
		fieldLabel: 'ҩ������',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%'
	}); 
	var ExeLoc = new Ext.ux.ExeLocComboBox({
		fieldLabel: 'ִ�п���',
		id: 'ExeLoc',
		name: 'ExeLoc',
		anchor: '90%'
	}); 
	var InciDesc = new Ext.form.TextField({
		fieldLabel: 'ҩƷ����',
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
		fieldLabel: '����ҩ��',
		id: 'BasicFlag',
		name: 'BasicFlag',
		anchor: '90%',
		checked: false
	});
	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: 'ͳ��',
		tooltip: 'ͳ�Ƹ�ҩ�����ҵķ���ҩ��������',
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
		title: 'ȫԺ����ͳ��',
		frame: true,
		height: 170,
		tbar: [FindButton],
		items: [{
			xtype : 'fieldset',
			title : '��ѯ����',
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
	/*Tabs����*/
	var QueryTabs = new Ext.TabPanel({
		region: 'center',
		id: 'TblTabPanel',
		margins: '3 3 3 0',
		activeTab: 0,
		items: [{
			title: 'ͳ���б�',
			id: 'list',
			frameName: 'list',
			html: '<iframe id="list" width=100% height=100% style="border:none;" src='+DHCSTBlankBackGround+'></iframe>'
		}],
		listeners: {
			tabchange: function(tp, p) {}
		}
	}); 
	/*��ܶ���*/
	var port = new Ext.Viewport({
		layout: 'border',
		items: [QueryForm, QueryTabs]
	}); ///----------------Events----------------
	Ext.getCmp("FindTypeCombo").setValue("1");
	Ext.getCmp("IOTypeCombo").setValue("");
	/* ����ҩƷ���岢���ؽ��*/
	function GetPhaOrderInfo(item, stkgrp) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "", getDrugList);
		}
	}
	/*���ط���*/
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
	/*��ѯ����*/
	function FindData() {
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		if (findtype == "") {
			Msg.info("error", "ͳ�Ʒ�ʽ����Ϊ��!");
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
	/*��ȡ����*/
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
