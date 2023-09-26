// 名称: KPI目标设置
// 描述: KPI目标设置
// 编写者：李明忠
// 编写日期:2010-08-23
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[deptMain]            //去掉了目标分解执行 autohisoutmedvouchForm                
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});