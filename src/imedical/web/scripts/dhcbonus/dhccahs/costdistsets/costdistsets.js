// 名称: 成本分摊套成本分摊套动
// 描述: 成本分摊套成本分摊套面各元素
// 成本分摊套旭
// 编写日期:2009-10-13
Ext.onReady(function(){
	Ext.QuickTips.init();                             //成本分摊套Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[costDistSetsMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});