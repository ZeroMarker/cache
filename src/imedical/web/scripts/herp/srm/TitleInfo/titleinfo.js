
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
	
	var uPanel = new Ext.Panel({
		title: '职称维护',
		region: 'center',
		layout: 'border',
		items: [itemGrid]//combos
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:uPanel                                 //添加Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});