/*
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
  
});
*/
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips


	var uPanel = new Ext.Panel({
		title: '����ģ��ά��',
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
	