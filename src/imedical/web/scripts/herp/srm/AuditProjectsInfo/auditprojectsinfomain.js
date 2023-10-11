
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'������Ŀ����������',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
    var uItemPanel = new Ext.Panel({
	    title:'������Ϣ',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	});
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,uItemPanel]                   
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});