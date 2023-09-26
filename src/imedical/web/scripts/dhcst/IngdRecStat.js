/**
 * ����: ������ҩ����������ϱ�
	creator:zhaoxinlong 2018-7-30 14:39:01
	// ../scripts/dhcst/IngdRecStat.js
 **/

var StrParam = "";
var gIncId = "";
var UserName=session['LOGON.USERNAME'];
var comwidth = 120;
var gGroupId=session['LOGON.GROUPID'];
var HospId=session['LOGON.HOSPID'];
Ext.onReady(function() {

	var StDateField = new Ext.ux.DateField({
		xtype: 'datefield',
		format: 'Y-m-d',
		fieldLabel: '��ʼ����',
		name: 'startdt',
		id: 'startdt',
		invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
		anchor: '90%',
		value: new Date
	}) 
	var EndDateField = new Ext.ux.DateField({
		format: 'Y-m-d',
		fieldLabel: '��ֹ����',
		name: 'enddt',
		id: 'enddt',
		anchor: '90%',
		value: new Date
	})
	var PhaLoc = new Ext.ux.DispLocComboBox({
		fieldLabel: 'ҩ������',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%'
	}); 
	/// �����ѡ by  zhaoxinlong 
	var StkGrpType = new Ext.ux.form.LovCombo({
		id : 'StkGrpType',
		name : 'StkGrpType',
		fieldLabel : '����',
		listWidth : 400,
		anchor: '90%',
		labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:'^',	//����id��^����
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetGrpCatStkStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	var FindTypeData = [['���', '1'], ['�ż���', '2'], ['סԺ', '3']];
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
	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: 'ͳ��',
		tooltip: 'ͳ������',
		icon: "../scripts/dhcpha/img/find.gif",
		listeners: {
			"click": function() {
				FindData();
			}
		}
	}) 
	
	var HelpBT = new Ext.Button({
	��������id:'HelpBtn',
			text : '����',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});


	var QueryForm = new Ext.FormPanel({
		labelWidth: 90,
		labelAlign: 'right',
		region: 'north',
		title: '������ҩ����������ϱ�',
		frame: true,
		height: 120,
		tbar: [FindButton,'-',HelpBT],
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
				items: [StDateField,]
			},
			{
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [EndDateField] 
			},
			{
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [FindTypeCombo]
			},
			{
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [PhaLoc]
			},
			{
				xtype: 'fieldset',
				columnWidth: .2,
				border: false,
				items: [StkGrpType]
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
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
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
	/*��ѯ����*/
	function FindData() {
	
		//GetStrParam();
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		if (findtype == "") {
			Msg.info("error", "ͳ�Ʒ�ʽ����Ϊ��!");
			return;
		}
		var sdate = Ext.getCmp("startdt").getRawValue();
		var edate = Ext.getCmp("enddt").getRawValue();
		var StkGrpType = Ext.getCmp("StkGrpType").getValue();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		
		var p = Ext.getCmp("TblTabPanel").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		if (findtype == "1") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_INgdRecStat.raq&stdate=' + sdate+'&eddate='+edate+'&UserName='+UserName+'&grpid='+StkGrpType+'&PhaLoc='+PhaLoc+'&HospId='+HospId;
		}else if (findtype == "2") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatOP.raq&stdate=' + sdate+'&eddate='+edate+'&UserName='+UserName+'&loc='+PhaLoc+'&type=F';

		}else if (findtype == "3") {
			iframe.src = 'dhccpmrunqianreport.csp?reportName=DHCST_DispStatIP.raq&stdate=' + sdate+'&eddate='+edate+'&UserName='+UserName+'&loc='+PhaLoc+'&type=P';

		}	
	} 
	/*��ȡ����*/
	function GetStrParam() {
		var sdate = Ext.getCmp("startdt").getRawValue();
		var edate = Ext.getCmp("enddt").getRawValue();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		var StkGrpType = Ext.getCmp("StkGrpType").getValue();
		StrParam = sdate + "^" + edate  + "^" +StkGrpType;
	}
	
	 new Ext.ToolTip({
        target: 'HelpBtn',
        anchor: 'buttom',
        width: 250,
        anchorOffset: 50,
		hideDelay : 90000,
        html: "<font size=2 color=blue ><b>1.��⣺����ѡ��������ѯ���еĿ����е�ҩƷ;����ֻ����ҵ�����ݣ������˿��ҵ�ǰ���п����<br>2.�ż��סԺ�����ұ��ֻͳ�ƿ��ҷ�ҩ����</b></font>"
   });
    Ext.getCmp('HelpBtn').focus('',100); //��ʼ��ҳ���ĳ��Ԫ�����ý���

	
});
