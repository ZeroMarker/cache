
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var uPanel =  new Ext.Panel({
		//title: 'ƾ֤��ѯ',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //���Tabs
    });
/*
    var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});
	*/
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });

});