
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		//title: '��ƿ�Ŀά���޸�',
		iconCls:'maintain',
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid,CheckitemGrid]
	});
/* 	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	}); */

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'uViewPort'
	});
});