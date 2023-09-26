// 名称: 问卷各科室最终分计算
// 描述: 问卷各科室最终分计算
// 编写者：wang ying
// 编写日期:2011-07-22
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