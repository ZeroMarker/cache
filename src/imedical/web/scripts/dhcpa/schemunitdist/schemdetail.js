// 名称: KPI指标区间设置界面启动
// 描述: 引入KPI指标区间设置各元素
// 编写者：wang ying
// 编写日期:2010-09-14
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[SchemUnitDetailGrid1]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});