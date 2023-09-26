Ext.onReady(function() {
	var DHCTimeLineTabPanel = new Ext.TabPanel({
		activeTab:0,
		id: 'DHCTimeLineTabPanel',
		enableTabScroll:true,
		minTabWidth: 115,
	    tabWidth:135,
		region:'center',
		items:[{
			id: 'btnTimeLineSetting',
	        title: '时间线管理',
	        closable: false,
			html: '<iframe src="TimeLine/timelinesetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnTimeLineCatogorySetting',
	        title: '显示项管理',
	        closable: false,
			html: '<iframe src="TimeLine/timelinecategroysetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnDataTypeSetting',
	        title: '显示子项管理',
	        closable: false,
			html: '<iframe src="TimeLine/datatypesetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnDataTypeActSetting',
	        title: '显示子项行为管理',
	        closable: false,
			html: '<iframe src="TimeLine/datatypeactsetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnViewTypeSetting',
	        title: '显示配置管理',
	        closable: false,
			html: '<iframe src="TimeLine/viewtypesetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnDiagnoseSetting',
	        title: '诊断类型显示顺序管理',
	        closable: false,
			html: '<iframe src="TimeLine/diagnosesetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		},{
			id: 'btnCriticallyIllSetting',
	        title: '危重医嘱项管理',
	        closable: false,
			html: '<iframe src="TimeLine/criticallyillsetting.csp" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		}
		/*,{
			id: 'btnContinueOrderSetting',
	        title: '科室特殊医嘱项管理',
	        closable: false,
			html: '<iframe src="websys.default.jquery.csp?WEBSYS.TCOMPONENT=DHCTimeLineContinueOrder" id="frameMain" scrolling="auto" frameborder="0" width="100%" height="100%" > </iframe>'
		}*/]
	});
	viewport = new Ext.Viewport({
		id:'docmainviewport',
		layout:'border',
		items:[DHCTimeLineTabPanel]
	});
});