// 名称: 接口部门套维护界面启动
// 描述: 引入接口部门套维护界面各元素
// 编写者：杨旭
// 编写日期:2009-10-13
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[InDeptSetsMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});