// 名称: 战略调整界面启动
// 描述: 引入战略调整界面各元素
// 编写者：wang ying
// 编写日期:2010-07-05
//--------------------------------------------------------------
Ext.onReady(function(){
	//初始化所有Tips
	Ext.QuickTips.init();                             

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[ParamMain]    //添加Tabs                             
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});