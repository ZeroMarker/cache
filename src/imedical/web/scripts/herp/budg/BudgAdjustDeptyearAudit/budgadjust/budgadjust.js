
Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	var uPanel = new Ext.Panel({
		title: 'Ô¤Ëãµ÷ÕûÆô¶¯',
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
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


