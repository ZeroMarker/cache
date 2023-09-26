// 名称: 绩效科室分类设置界面启动
// 描述: 引入绩效科室分类设置界面各元素
// 编写者：wang ying
// 编写日期:2010-07-16
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[JXQMLocTypeMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});