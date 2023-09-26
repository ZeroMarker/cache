// 名称: 问卷分数明细界面启动
// 描述: 引入问卷分数明细界面各元素
// 编写者：wang ying
// 编写日期:2011-07-20
//--------------------------------------------------------------
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[SurveyScoreDetailMain]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});