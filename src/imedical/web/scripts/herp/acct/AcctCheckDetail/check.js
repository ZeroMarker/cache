Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips


  var uPanel = new Ext.Panel({
		title: 'δ�ɼ����ݲ�ѯ',
		region: 'center',
		layout: 'border',
  	    items: [itemGrid]
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