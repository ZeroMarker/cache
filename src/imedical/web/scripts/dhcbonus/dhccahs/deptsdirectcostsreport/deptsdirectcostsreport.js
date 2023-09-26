// 名称:
// 描述: 
// 编写者：wyy
// 编写日期:2009-12-15
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