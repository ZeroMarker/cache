/**
  *name:interperiod
  *author:limingzhong
  *Date:2010-11-11
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '接口期间设置',
		layout: 'border',
		
		items: [PeriodGrid]
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
