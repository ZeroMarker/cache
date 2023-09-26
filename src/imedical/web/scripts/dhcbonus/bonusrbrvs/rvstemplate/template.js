
/*
 *工作量模板
 * 2016-05-05  guojing
*/


Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	

	
	var uPanel = new Ext.Panel({
		title: '工作量模板',
		region: 'center',
		autoScroll:true,
		layout: 'border',
		items: [templateMain,detailMain]
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