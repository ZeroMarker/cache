///����:ȫԺ�±�(�ٴ�����)
///��д��:wangjiabin
///��д����:2017-08-04

	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		defaultLoc : {}
	});
	
	var lastMon = new Date().add(Date.MONTH,-1);
	var lastYearMon = lastMon.format('Y-m');
	
	var YearNum = new Ext.form.TextField({
		fieldLabel : '�·�',
		id : 'YearNum',
		anchor : '90%',
		allowBlank : false,
		value : lastYearMon,
		regex : /^2\d{3}-(0[1-9]|1[0-2])$/,
		regexText : '��������ȷ����ݸ�ʽ!'
	});
	
	var ScgSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		//data : [['MM', 'ҽ�ò���'], ['MO', '���ڲ���'], ['MR', '�Լ�'], ['MF', '�̶��ʲ�']]
		data : [['MM', 'ҽ�ò���'], ['MR', '�Լ�']]
	});

	var ScgSet = new Ext.form.ComboBox({
		id : 'ScgSet',
		fieldLabel : '�������',
		anchor : '90%',
		store: ScgSetStore,
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction: 'all',
		valueNotFoundText : ''
	});
	Ext.getCmp('ScgSet').setValue('MM');
	
	var StatType = new Ext.form.RadioGroup({
		fieldLabel : 'ͳ�Ʒ�ʽ',
		id : 'StatType',
		columns : 1,
		anchor : '90%',
		items : [
			{boxLabel : '�ٴ����һ���', name : 'StatType', inputValue : 'LocSum', checked : true},
			{boxLabel : '���ҷ������', name : 'StatType', inputValue : 'LocStkCatSum'},
			{boxLabel : '���ҵ�Ʒ', name : 'StatType', inputValue : 'LocInci'},
			{boxLabel : '��Ʒ����', name : 'StatType', inputValue : 'InciSum'}
		]
	});

	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_refresh',
		handler : function() {
			Ext.getCmp('PhaLoc').setValue('');
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : 'ͳ��',
		tooltip : '���ͳ��',
		width : 70,
		iconCls : 'page_find',
		height : 30,
		handler : function() {
			ShowReport();
		}
	}); 
	
	function ShowReport(){
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		var SMMonth = Ext.getCmp("YearNum").getValue();
		if(SMMonth == ""){
			Msg.info("warning","��ѡ���·�!");
			return;
		}
		var ScgId = '', IncscId = '', IncDesc = '';
		var ScgSet = Ext.getCmp('ScgSet').getValue();		//����,���Ÿ���
		var ScgSetDesc = Ext.getCmp('ScgSet').getRawValue();
		if(Ext.isEmpty(ScgSet)){
			Msg.info('warning', '��ѡ���������!');
			return;
		}
		var HVFlag = '';
		var StrParam = ScgId + '^' + IncscId + '^' + IncDesc + '^' + PhaLoc + '^' + ScgSet
			+ '^' + HVFlag;
		
		var RaqTitle = '';		//�����ͷ
		var reportFrame = document.getElementById("frameReport");
		var StatType = Ext.getCmp("StatType").getValue().getGroupValue();
		var RaqName = 'DHCSTM_ReportAll_LocSum.raq';
		if(StatType == 'LocSum'){
			RaqName = 'DHCSTM_ReportAll_LocSum.raq';
			RaqTitle = '�ٴ����Ҷ������±������һ��ܣ�';
			if(!Ext.isEmpty(ScgSet)){
				RaqTitle = RaqTitle + '[' + ScgSetDesc + ']';
			}
		}else if(StatType == 'LocStkCatSum'){
			RaqName = 'DHCSTM_ReportAll_LocStkCatSum.raq';
			RaqTitle = '�ٴ����Ҷ������±���������ܣ�';
			if(!Ext.isEmpty(ScgSet)){
				RaqTitle = RaqTitle + '[' + ScgSetDesc + ']';
			}
		}else if(StatType == 'LocInci'){
			RaqName = 'DHCSTM_ReportAll_LocInci.raq';
			RaqTitle = '�ٴ����Ҷ������±���ϸ��';
			if(!Ext.isEmpty(ScgSet)){
				RaqTitle = RaqTitle + '[' + ScgSetDesc + ']';
			}
		}else if(StatType == 'InciSum'){
			RaqName = 'DHCSTM_ReportAll_InciSum.raq';
		}
		var PmRunQianUrl = 'dhccpmrunqianreport.csp';
		var p_URL = PmRunQianUrl + '?reportName=' + RaqName
				+'&SMMonth=' + SMMonth + '&StrParam=' + StrParam + '&RaqTitle=' + RaqTitle;
		reportFrame.src=p_URL;
	}
		
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5,0,5,0',
		tbar : [OkBT,'-',ClearBT],
		items : [{
				xtype : 'fieldset',
				title : '��ѯ����',
				items : [PhaLoc,YearNum,ScgSet]
			},{
				xtype : 'fieldset',
				title : '��������',
				items : [StatType]
			}]
	});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"�������±�(�ٴ�)",
			width:300,
			split:true,
			collapsible:true,
			minSize:260,
			maxSize:350,
			layout:'fit',
			items:HisListTab
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});

});