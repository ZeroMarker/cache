Ext.BLANK_IMAGE_URL = '../scripts/ext2/resources/images/default/s.gif';

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'预算项字典',
		region: 'center',
		layout: 'border',
		items: [mainGrid]
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

