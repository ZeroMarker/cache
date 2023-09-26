///名称:全院月报(临床科室)
///编写者:wangjiabin
///编写日期:2017-08-04

	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		defaultLoc : {}
	});
	
	var lastMon = new Date().add(Date.MONTH,-1);
	var lastYearMon = lastMon.format('Y-m');
	
	var YearNum = new Ext.form.TextField({
		fieldLabel : '月份',
		id : 'YearNum',
		anchor : '90%',
		allowBlank : false,
		value : lastYearMon,
		regex : /^2\d{3}-(0[1-9]|1[0-2])$/,
		regexText : '请输入正确的年份格式!'
	});
	
	var ScgSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		//data : [['MM', '医用材料'], ['MO', '后勤材料'], ['MR', '试剂'], ['MF', '固定资产']]
		data : [['MM', '医用材料'], ['MR', '试剂']]
	});

	var ScgSet = new Ext.form.ComboBox({
		id : 'ScgSet',
		fieldLabel : '类组归类',
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
		fieldLabel : '统计方式',
		id : 'StatType',
		columns : 1,
		anchor : '90%',
		items : [
			{boxLabel : '临床科室汇总', name : 'StatType', inputValue : 'LocSum', checked : true},
			{boxLabel : '科室分类汇总', name : 'StatType', inputValue : 'LocStkCatSum'},
			{boxLabel : '科室单品', name : 'StatType', inputValue : 'LocInci'},
			{boxLabel : '单品汇总', name : 'StatType', inputValue : 'InciSum'}
		]
	});

	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
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
		text : '统计',
		tooltip : '点击统计',
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
			Msg.info("warning","请选择月份!");
			return;
		}
		var ScgId = '', IncscId = '', IncDesc = '';
		var ScgSet = Ext.getCmp('ScgSet').getValue();		//如多个,逗号隔开
		var ScgSetDesc = Ext.getCmp('ScgSet').getRawValue();
		if(Ext.isEmpty(ScgSet)){
			Msg.info('warning', '请选择类组归类!');
			return;
		}
		var HVFlag = '';
		var StrParam = ScgId + '^' + IncscId + '^' + IncDesc + '^' + PhaLoc + '^' + ScgSet
			+ '^' + HVFlag;
		
		var RaqTitle = '';		//报表表头
		var reportFrame = document.getElementById("frameReport");
		var StatType = Ext.getCmp("StatType").getValue().getGroupValue();
		var RaqName = 'DHCSTM_ReportAll_LocSum.raq';
		if(StatType == 'LocSum'){
			RaqName = 'DHCSTM_ReportAll_LocSum.raq';
			RaqTitle = '临床科室二级库月报（科室汇总）';
			if(!Ext.isEmpty(ScgSet)){
				RaqTitle = RaqTitle + '[' + ScgSetDesc + ']';
			}
		}else if(StatType == 'LocStkCatSum'){
			RaqName = 'DHCSTM_ReportAll_LocStkCatSum.raq';
			RaqTitle = '临床科室二级库月报（分类汇总）';
			if(!Ext.isEmpty(ScgSet)){
				RaqTitle = RaqTitle + '[' + ScgSetDesc + ']';
			}
		}else if(StatType == 'LocInci'){
			RaqName = 'DHCSTM_ReportAll_LocInci.raq';
			RaqTitle = '临床科室二级库月报明细表';
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
				title : '查询条件',
				items : [PhaLoc,YearNum,ScgSet]
			},{
				xtype : 'fieldset',
				title : '报表类型',
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
			title:"二级库月报(临床)",
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