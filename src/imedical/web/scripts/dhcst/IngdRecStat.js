/**
 * 名称: 合理用药监测网数据上报
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
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		invalidText: '无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		anchor: '90%',
		value: new Date
	}) 
	var EndDateField = new Ext.ux.DateField({
		format: 'Y-m-d',
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		anchor: '90%',
		value: new Date
	})
	var PhaLoc = new Ext.ux.DispLocComboBox({
		fieldLabel: '药房科室',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%'
	}); 
	/// 类组多选 by  zhaoxinlong 
	var StkGrpType = new Ext.ux.form.LovCombo({
		id : 'StkGrpType',
		name : 'StkGrpType',
		fieldLabel : '类组',
		listWidth : 400,
		anchor: '90%',
		labelStyle : "text-align:right;width:100;",
		labelSeparator : '',
		separator:'^',	//科室id用^连接
		hideOnSelect : false,
		maxHeight : 300,
		editable:false,
		store : GetGrpCatStkStore ,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	var FindTypeData = [['入库', '1'], ['门急诊', '2'], ['住院', '3']];
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
	var FindButton = new Ext.Button({
		width: 65,
		id: "FindButton",
		text: '统计',
		tooltip: '统计数据',
		icon: "../scripts/dhcpha/img/find.gif",
		listeners: {
			"click": function() {
				FindData();
			}
		}
	}) 
	
	var HelpBT = new Ext.Button({
	　　　　id:'HelpBtn',
			text : '帮助',
			width : 70,
			height : 30,
			renderTo: Ext.get("tipdiv"),
			iconCls : 'page_help'
			
		});


	var QueryForm = new Ext.FormPanel({
		labelWidth: 90,
		labelAlign: 'right',
		region: 'north',
		title: '合理用药监测网数据上报',
		frame: true,
		height: 120,
		tbar: [FindButton,'-',HelpBT],
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
			html: '<iframe id="list" width=100% height=100% src= ></iframe>'
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
	/*查询数据*/
	function FindData() {
	
		//GetStrParam();
		var findtype = Ext.getCmp("FindTypeCombo").getValue();
		if (findtype == "") {
			Msg.info("error", "统计方式不能为空!");
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
	/*获取参数*/
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
        html: "<font size=2 color=blue ><b>1.入库：科室选填，不填则查询所有的科室有的药品;日期只过滤业务数据，不过滤科室当前所有库存项<br>2.门急诊、住院：科室必填；只统计科室发药数据</b></font>"
   });
    Ext.getCmp('HelpBtn').focus('',100); //初始化页面给某个元素设置焦点

	
});
