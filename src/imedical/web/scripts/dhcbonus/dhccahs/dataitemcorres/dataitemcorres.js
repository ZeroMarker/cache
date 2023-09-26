// 名称: 数据项对应维护界面启动
// 描述: 引入数据项对应维护界面各元素
// 编写者：杨旭
// 编写日期:2009-10-14
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[dataItemCorresMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});