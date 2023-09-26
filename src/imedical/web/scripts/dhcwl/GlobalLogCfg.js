dhcwl.mkpi.GlobalLogCfg = function(){
	
	//*************************************************************全局日志配置*********************************************************//
	
	var globalLogCfgStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysvarcfg.csp?action=lookup'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'ID'},
				{name:'SysVarCode'},
				{name:'SysVarValue'}
			]
		}),
		listeners:{
			'load':function(){
				Ext.getCmp('mkpiLogSave').disable();
			}
		}
	});
	
	//		定义Form表单
	var globalLogCfgForm = new Ext.FormPanel({
		//title:'日志全局配置',
		id:'globalLogCfgForm',
		width:1000,
		//height:400,
		layout:'table',
		monitorResize:true,
		loadMask: true,
		columnLines: true,
		//viewConfig:{forceFit: true},
		layoutConfig:{columns:4},
		defaults:{
			width:100,
			height:50
		},
		items:[{
			html:'',
			height:20,
			colspan:4
		},{
			html:'以下是支持的日志记录类型，请选择您希望所有指标的日志记录类型：',
			width:800,
			height:60,
			colspan:4
		},{
			xtype:'checkbox',
			boxLabel:'指标定义日志',
			name:'mkpiLogDefinition',
			id:'mkpiLogDefinition',
			//rowspan:4,
			//colspan:4,
			listeners:{
				'check':function(){
					Ext.getCmp('mkpiLogSave').setText("<font size=3 color=red><b>保存</b></font>");
					Ext.getCmp('mkpiLogSave').enable();
					Ext.getCmp('globalLogCfgForm').doLayout();
				}
			}
		},{
			xtype:'checkbox',
			boxLabel:'数据处理日志',
			name:'mkpiLogDataProcess',
			id:'mkpiLogDataProcess',
			//rowspan:4,
			//colspan:4,
			listeners:{
				'check':function(){
					Ext.getCmp('mkpiLogSave').setText("<font size=3 color=red><b>保存</b></font>");
					Ext.getCmp('mkpiLogSave').enable();
				}
			}
		},{
			xtype:'checkbox',
			boxLabel:'数据查询日志',
			name:'mkpiLogDataQuery',
			id:'mkpiLogDataQuery',
			//rowspan:4,
			//colspan:4,
			listeners:{
				'check':function(){
					Ext.getCmp('mkpiLogSave').setText("<font size=3 color=red><b>保存</b></font>");
					Ext.getCmp('mkpiLogSave').enable();
				}
			}
		},{
			xtype:'checkbox',
			boxLabel:'任务错误日志',
			name:'mkpiLogTaskErr',
			id:'mkpiLogTaskErr',
			//rowspan:4,
			//colspan:4,
			listeners:{
				'check':function(){
					Ext.getCmp('mkpiLogSave').setText("<font size=3 color=red><b>保存</b></font>");
					Ext.getCmp('mkpiLogSave').enable();
				}
			}
		},{
			xtype:'tbspacer',
			rowspan:4,
			colspan:2
		},{
			xtype:'button',
			id:'mkpiLogSave',
			text:'保存',
			disabled:true,
			//width:100,
			//rowspan:2,
			width:50,
			height:25,	
			listeners:{
				'click':function(){
					var logDefCfg=Ext.getCmp('mkpiLogDefinition').getValue();
					var dataProcessCfg=Ext.getCmp('mkpiLogDataProcess').getValue();
					var dataQueryCfg=Ext.getCmp('mkpiLogDataQuery').getValue();
					var taskErrCfg=Ext.getCmp('mkpiLogTaskErr').getValue();
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalKpiLogDefinitionCfg&SysVarDesc=指标定义日志全局配置&SysVarValue='+logDefCfg);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalKpiLogDataProcessCfg&SysVarDesc=指标数据处理日志全局配置&SysVarValue='+dataProcessCfg);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalKpiLogDataQueryCfg&SysVarDesc=指标数据查询日志全局配置&SysVarValue='+dataQueryCfg);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalKpiLogTaskErrCfg&SysVarDesc=指标任务错误日志全局配置&SysVarValue='+taskErrCfg);
					//刷新页面
					globalLogCfgStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysvarcfg.csp?action=lookup'));
					globalLogCfgStore.load();
					//globalLogCfgForm.doLayout();
				}
			}
		}]
	});
	
	var globalLogCfgPanel = new Ext.Panel({
		id:'globalLogCfgPanel',
		monitorResize:true,
		layout:'table',
		layoutConfig:{columns:3},
		items:[{
			height:550,
			items:globalLogCfgForm,
			colspan:3
		}],
		listeners:{
			'beforeshow':function(){
				var index1 = globalLogCfgStore.find('SysVarCode','GlobalKpiLogDefinitionCfg');
				if (("undefined"!=typeof(index1)) && ("-1"!=index1)){
					var value1 = globalLogCfgStore.getAt(index1).get('SysVarValue');
					Ext.getCmp('mkpiLogDefinition').setValue(value1);
				}
				var index2 = globalLogCfgStore.find('SysVarCode','GlobalKpiLogDataProcessCfg');
				if (("undefined"!=typeof(index2)) && ("-1"!=index2)) {
					var value2 = globalLogCfgStore.getAt(index2).get('SysVarValue');
					Ext.getCmp('mkpiLogDataProcess').setValue(value2);
				}
				var index3 = globalLogCfgStore.find('SysVarCode','GlobalKpiLogDataQueryCfg');
				if (("undefined"!=typeof(index3)) && ("-1"!=index3)) {
					var value3 = globalLogCfgStore.getAt(index3).get('SysVarValue');
					Ext.getCmp('mkpiLogDataQuery').setValue(value3);
				}
				var index4 = globalLogCfgStore.find('SysVarCode','GlobalKpiLogTaskErrCfg');
				if (("undefined"!=typeof(index4)) && ("-1"!=index4)){
					var value4 = globalLogCfgStore.getAt(index4).get('SysVarValue');
					Ext.getCmp('mkpiLogTaskErr').setValue(value4);
				}
			}
		}
	});
	
	this.GetGlobalLogCfgPanel = function(){
		globalLogCfgStore.load();
		return globalLogCfgPanel;
	}
	
}