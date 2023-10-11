
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var uPanel =  new Ext.Panel({
		title: '凭证录入',
		layout: 'border',
		region:'center',
		items:[Panel]                                 //添加Tabs
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