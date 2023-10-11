Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[ListTab,reportPanel]                                 //添加Tabs,main函数里写queryPanel
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });

		// 页面布局
		// var mainPanel = new Ext.Viewport({
					// layout : 'border',
					// renderTo:'mainPanel',
					// items : [{
						// region:'north',
						// title:"初始余额核对表",
						// height:70,
						// split:true,
						// collapsible:true,
						// layout:'fit',
						// items:ListTab
					// },{
						// region:'center',
						// layout:'fit',
						// items:reportPanel
					// }]
				// });
});