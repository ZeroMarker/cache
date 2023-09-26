/**
  *name:deptschem
  *author:limingzhong
  *Date:2010-7-30
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '科室绩效方案设置',
		region: 'center',
		layout: 'border',
		items: [SchemGrid,jxUnitGrid]
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