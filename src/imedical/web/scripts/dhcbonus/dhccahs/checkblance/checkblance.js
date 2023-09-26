// 名称: 绩效核算收入汇总表
// 描述: 核算月份、科室分层套的选择，同时对报表的展示、导出、打印
// 编写者：李明忠
// 编写日期:2010-03-31
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