
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var uPanel =  new Ext.Panel({
		title: 'ƾ֤¼��',
		layout: 'border',
		region:'center',
		items:[Panel]                                 //���Tabs
    });

    var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uTabPanel,
  	renderTo: 'mainPanel'
  });
});