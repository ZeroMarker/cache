// 名称: 单位部门码表界面启动
// 描述: 引入单位部门码表维护界面各元素
// 编写者：王赢赢
// 编写日期:2009-9-25
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[unitDeptsMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});