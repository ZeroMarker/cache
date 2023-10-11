
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'纵向项目申请材料审核',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
    var uItemPanel = new Ext.Panel({
	    title:'经费信息',
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