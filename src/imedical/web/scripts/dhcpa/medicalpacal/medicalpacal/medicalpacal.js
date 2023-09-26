/*
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
  
});
*/
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips


	var uPanel = new Ext.Panel({
		title: '报表模板维护',
		region: 'center',
		layout: 'border',
		items: [itemGrid,itemGridDetail] 
		//items: [itemGrid] 
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});

  
});
	