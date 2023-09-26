// 名称: 考评计算
// 描述: 考评计算
// 编写者：李明忠
// 编写日期:2010-9-1
//--------------------------------------------------------------
			
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		region:'center',
		items:[autohisoutmedvouchForm]                            
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tabPanel,
		renderTo: 'mainPanel'
	});
});