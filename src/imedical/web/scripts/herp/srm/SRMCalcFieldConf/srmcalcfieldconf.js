
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	
	var uPanel = new Ext.Panel({
		region: 'center',
		layout: 'border',
		items: [itemGrid]
	});
	/* 
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //���Tabs
  });
 */
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});