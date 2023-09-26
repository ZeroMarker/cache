// 名称: 文件管理
// 编写者：李明忠
// 编写日期:2012-2-13
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[FileManagerTab]                            
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});