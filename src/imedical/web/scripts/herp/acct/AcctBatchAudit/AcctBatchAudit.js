Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.Panel({
	title:"ƾ֤���",
	iconCls:'find',
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //���Tabs
  });

 /*  var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: tabPanel                           
	}); */
	
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});