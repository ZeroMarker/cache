// 名称:
// 描述: 
// 编写者：wy
// 编写日期:2010-01-20
Ext.onReady(function(){
	Ext.QuickTips.init();

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[detailReport]
	});

	var mainPanel = new Ext.Viewport({
		
		layout: 'border',
		items : [tabPanel],
		renderTo: 'mainPanel'
	});
});