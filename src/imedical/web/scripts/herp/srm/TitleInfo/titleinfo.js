
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	
	var uPanel = new Ext.Panel({
		title: 'ְ��ά��',
		region: 'center',
		layout: 'border',
		items: [itemGrid]//combos
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:uPanel                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});