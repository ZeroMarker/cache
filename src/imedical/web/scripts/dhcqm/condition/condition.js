// 名称: 绩效质量管理科室分类设置界面启动
// 描述: 引入绩效科室分类设置界面各元素
// 编写者：刘小明
// 编写日期:2015-06-15
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[JXQMConditionMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});