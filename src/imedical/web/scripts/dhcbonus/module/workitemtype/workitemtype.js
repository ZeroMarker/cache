// 名称: 奖金工作量类别设置界面启动
// 描述: 引入奖金工作量类别设置界面各元素
// 编写者：weijiangtao
// 编写日期:2015-04-14
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[WorkItemTypeMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});
