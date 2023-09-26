/**
  *name:interperson
  *author:limingzhong
  *Date:2010-11-25
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '接口人员设置',
		region: 'center',
		layout: 'border',
		items: [InGrid,OutGrid]
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