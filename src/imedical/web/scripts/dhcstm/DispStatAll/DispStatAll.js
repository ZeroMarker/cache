var StrParam = "";
var gIncId = "";
var comwidth = 120;
var gGroupId = session['LOGON.GROUPID'];

Ext.onReady(function () {
	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	var StDateField = new Ext.ux.DateField({
			xtype: 'datefield',
			fieldLabel: '��ʼ����',
			anchor: '90%',
			id: 'startdt',
			invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
			value: new Date
		});

	var EndDateField = new Ext.ux.DateField({
			fieldLabel: '��ֹ����',
			anchor: '90%',
			id: 'enddt',
			value: new Date
		});

	var FindTypeData = [['������', '1'], ['��ҽ������', '2'], ['��������', '3'], ['�����߿���', '4'], ['�����տ���', '5']];
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
			triggerAction: 'all', //ȡ���Զ�����
			forceSelection: true,
			valueField: 'typeid'
		});

	//ҩ������
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel: 'ͳ�ƿ���',
			id: 'PhaLoc',
			name: 'PhaLoc',
			anchor: '90%',
			width: 120,
			emptyText: 'ͳ�ƿ���...',
			defaultLoc: {}
		});

	//����ҩƷ����
	var InciDesc = new Ext.form.TextField({
			fieldLabel: '��������',
			id: 'InciDesc',
			name: 'InciDesc',
			anchor: '90%',
			listeners: {
				specialkey: function (field, e) {
					var keyCode = e.getKey();
					if (keyCode == Ext.EventObject.ENTER) {
						GetPhaOrderInfo(field.getValue(), '');
					}
				},
				change: function (field,newValue,oldValue) {
					gIncId = "";
				}
			}
		});
		
	var hvFlag = new Ext.form.RadioGroup({
			id : 'hvFlag',
			hideLabel : true,
			items : [
				{boxLabel:'ȫ��',name:'hv_Flag',id:'all',inputValue:'',checked:true},
				{boxLabel:'��ֵ',name:'hv_Flag',id:'hv',inputValue:'Y'},
				{boxLabel:'�Ǹ�ֵ',name:'hv_Flag',id:'nhv',inputValue:'N'}
			]
		});

	var FindButton = new Ext.Button({
			width: 65,
			height : 30,
			id: "FindButton",
			text: 'ͳ��',
			iconCls: 'page_find',
			tooltip: 'ͳ�Ƹ�ҩ�����ҵķ���ҩ��������',
			icon: "../scripts/dhcpha/img/find.gif",
			listeners: {
				"click": function () {
					FindData();
				}
			}
		});

	var QueryForm = new Ext.ux.FormPanel({
			title: '��������ͳ��',
			tbar: [FindButton],
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
					layout: 'column',
					style: 'padding:5px 0px 0px 5px',
					defaults: {
						border: false,
						columnWidth: .33,
						xtype: 'fieldset'
					},
					items: [{
							items: [StDateField, EndDateField]
						}, {
							items: [FindTypeCombo, InciDesc]
						}, {
							items: [PhaLoc,hvFlag]
						}
					]
				}
			]
		});

	//Tabs����
	var QueryTabs = new Ext.TabPanel({
			region: 'center',
			id: 'TblTabPanel',
			margins: '3 3 3 0',
			activeTab: 0,
			items: [{
					title: 'ͳ���б�',
					id: 'list',
					frameName: 'list',
					html: '<iframe id="list" width=100% height=100% src= ></iframe>'
				}, {
					title: 'ͳ���б�����',
					id: 'listDetail',
					frameName: 'listDetail',
					html: '<iframe id="list" width=100% height=100% src= ></iframe>'
				}
			],
			listeners: {
				tabchange : function(tp,p){
					var findtype = Ext.getCmp("FindTypeCombo").getValue();
					if(findtype!=""){
						FindData();
					}
				}
			}
		});

	//��ܶ���
	var port = new Ext.ux.Viewport({
			layout: 'border',
			items: [QueryForm, QueryTabs]
		});

	//----------------Events----------------
	Ext.getCmp("FindTypeCombo").setValue("1");
	/**
	 * ����ҩƷ���岢���ؽ��
	 */
	function GetPhaOrderInfo(item, stkgrp) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "", getDrugList);
		}
	}

	/**
	 * ���ط���
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}

	//��ѯ����
	function FindData() {
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		if (findtype == "") {
			Msg.info("error", "ͳ�Ʒ�ʽ����Ϊ��!");
			return;
		}
		GetStrParam();
		var p = Ext.getCmp("TblTabPanel").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		var tabId = QueryTabs.getActiveTab().id;
		if(tabId == "list"){
			if (findtype == "1") {
				iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_INCI_Common.raq&input=' + StrParam;
			}
			else if (findtype == "2") {
				iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_DOCLOC_Common.raq&input=' + StrParam;
			}
			else if (findtype == "3") {
				iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_STKCAT_Common.raq&input=' + StrParam;
			}
			else if (findtype == "4") {
				iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_AdmLoc.raq&input=' + StrParam;
			}
			else if (findtype == "5") {
				iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_RecLoc.raq&input=' + StrParam;
			}
		}else if (tabId == "listDetail") {
			iframe.src = PmRunQianUrl + '?reportName=DHCSTM_DispStatAll_INCI_Common_Detail.raq&input=' + StrParam;
		}
	}

	//��ȡ����
	function GetStrParam() {
		var sdate = Ext.getCmp("startdt").getValue();
		var edate = Ext.getCmp("enddt").getValue();
		if (sdate != "") {
			sdate = sdate.format(ARG_DATEFORMAT);
		}
		if (edate != "") {
			edate = edate.format(ARG_DATEFORMAT);
		}
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		var InciDesc = Ext.getCmp("InciDesc").getValue();
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		if (gIncId != "" & gIncId != null) {
			InciDesc = "";
		}
		StrParam = sdate + "^" + edate + "^" + phaLoc + "^" + gIncId + "^" + findtype + "^" + InciDesc + "^" + hvFlag;
	}
});
