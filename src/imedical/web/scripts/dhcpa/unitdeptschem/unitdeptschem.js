/**
  *name:deptschem
  *author:limingzhong
  *Date:2010-7-30
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '◊‘≤È…Ë÷√',
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