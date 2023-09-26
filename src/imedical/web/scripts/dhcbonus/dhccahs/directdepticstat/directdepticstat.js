// 名称: 直接医疗科室收入成本收益明细报表
// 描述: 核算月份，同时对报表的展示、导出、打印
// 编写者：李明忠
// 编写日期:2010-04-16
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