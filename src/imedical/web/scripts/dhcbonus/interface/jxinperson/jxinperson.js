/**
  *name:jxinperson
  *author:limingzhong
  *Date:2010-11-25
 */
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		title: '�ڲ���Ա����',
		region: 'center',
		layout: 'border',
		items: [JXUnitGrid,personGrid]
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