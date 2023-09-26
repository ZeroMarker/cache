dhcwl.mkpi.GlobalTaskCfg = function(){
	
	//*************************************************************全局任务配置*********************************************************//
	
	var globalTaskCfgStore = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:'dhcwl/kpi/sysvarcfg.csp?action=lookup'}),
		reader:new Ext.data.JsonReader({
			totalProperty:'totalNum',
			root:'root',
			fields:[
				{name:'ID'},
				{name:'SysVarCode'},
				{name:'SysVarValue'}
			]
		})
	});
	
	//		定义Form表单
	var globalTaskCfgForm = new Ext.FormPanel({
		//title:'任务全局配置',
		id:'globalTaskCfgForm',
		width:1000,
		//height:400,
		layout:'table',
		loadMask: true,
		columnLines: true,
		viewConfig:{forceFit: true},
		layoutConfig:{columns:10},
		buttonAlign:'center',
		items:[{
			html:' ',
			height:20,
			colspan:10
		},{
			html:'添加指标任务时，默认激活添加的指标任务？',
			colspan:8
		},{
			xtype:'combo',
			editable:false,
			id:'defaultTaskStatus',
			width:100,
			colspan:2,
			mode:'local',
			triggerAction:'all',
			displayField:'displayValue',
			valueField:'realValue',
			store:new Ext.data.JsonStore({
				fields:['displayValue','realValue'],
				data:[{
					displayValue:'是',
					realValue:'Y'
				},{
					displayValue:'否',
					realValue:'N'
				}]
			}),
			listeners:{
				'select':function(combox){
					Ext.getCmp('defaultTaskStatus').setValue(combox.getValue());
				}
			}
		},{
			html:' ',
			height:20,
			colspan:10
		},{
			html:'当某个指标任务出错时，任务挂起，同时将指标数据整个任务挂起？',
			colspan:8
		},{
			xtype:'combo',
			editable:false,
			id:'defaultSuspendStatus',
			width:100,
			colspan:2,
			mode:'local',
			triggerAction:'all',
			displayField:'displayValue',
			valueField:'realValue',
			store:new Ext.data.JsonStore({
				fields:['displayValue','realValue'],
				data:[{
					displayValue:'是',
					realValue:'Y'
				},{
					displayValue:'否',
					realValue:'N'
				}]
			}),
			listeners:{
				'select':function(combox){
					Ext.getCmp('defaultSuspendStatus').setValue(combox.getValue());
				}
			}
		},{
			html:' ',
			height:40,
			colspan:10
		},{
			html:' ',
			colspan:4
		},{
			html:' ',
			height:20,
			colspan:4
		}/*,{
			xtype:'button',
			id:'mkpiTaskSave',
			buttonAlign:'center',
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			//rowspan:2,
			//width:100,
			listeners:{
				'click':function(){
					globalTaskCfgStore.removeAll();
					var globalTaskInitStatus=Ext.getCmp('defaultTaskStatus').getValue();
					var globalTaskSuspend=Ext.getCmp('defaultSuspendStatus').getValue();
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalTaskInitCfg&SysVarDesc=指标任务添加时的默认激活配置&SysVarValue='+globalTaskInitStatus);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalTaskSuspendCfg&SysVarDesc=指标任务出错时的挂起配置&SysVarValue='+globalTaskSuspend);//刷新页面
					//globalTaskCfgStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysvarcfg.csp?action=lookup'));
					//globalTaskCfgStore.load();
				}
			}
		}*/
		],
		buttons: [{
			id:'mkpiTaskSave',
			
			//text:'保存',
			text: '<span style="line-Height:1">保存</span>',
			icon: '../images/uiimages/filesave.png',
			//rowspan:2,
			//width:100,
			listeners:{
				'click':function(){
					globalTaskCfgStore.removeAll();
					var globalTaskInitStatus=Ext.getCmp('defaultTaskStatus').getValue();
					var globalTaskSuspend=Ext.getCmp('defaultSuspendStatus').getValue();
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalTaskInitCfg&SysVarDesc=指标任务添加时的默认激活配置&SysVarValue='+globalTaskInitStatus);
					dhcwl.mkpi.Util.ajaxExc('dhcwl/kpi/sysvarcfg.csp?action=save&SysVarCode=GlobalTaskSuspendCfg&SysVarDesc=指标任务出错时的挂起配置&SysVarValue='+globalTaskSuspend);//刷新页面
					//globalTaskCfgStore.proxy.setUrl(encodeURI('dhcwl/kpi/sysvarcfg.csp?action=lookup'));
					//globalTaskCfgStore.load();
				}
			}
        }] 
	});
	
	var globalTaskCfgPanel = new Ext.Panel({
		id:'globalTaskCfgPanel',
		monitorResize:true,
		layout:'table',
		layoutConfig:{columns:3},
		items:[{
			height:550,
			items:globalTaskCfgForm,
			colspan:3
		}],
		listeners:{
			'beforeshow':function(){
				var index1 = globalTaskCfgStore.find('SysVarCode','GlobalTaskInitCfg');
				if (("undefined"!=typeof(index1)) && ("-1"!=index1)) {
					var value1 = globalTaskCfgStore.getAt(index1).get('SysVarValue');
					Ext.getCmp('defaultTaskStatus').setValue(value1);
				}
				var index2 = globalTaskCfgStore.find('SysVarCode','GlobalTaskSuspendCfg');
				if (("undefined"!=typeof(index2)) && ("-1"!=index2)) {
					var value2 = globalTaskCfgStore.getAt(index2).get('SysVarValue');
					Ext.getCmp('defaultSuspendStatus').setValue(value2);
				}
			}
		}
	});
	
	this.GetGlobalTaskCfgPanel = function(){
		globalTaskCfgStore.load();
		return globalTaskCfgPanel;
	}
	
}