/**
  *name:locsetkpi
  *author:limingzhong
  *Date:2010-11-10
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '指标来源规则',
		region: 'center',
		layout: 'border',
		items: [LocSetGrid,outKpiGrid]
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