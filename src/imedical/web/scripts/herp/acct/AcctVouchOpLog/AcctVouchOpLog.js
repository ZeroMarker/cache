Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

 	var uPanel = new Ext.Panel({
		title: 'ƾ֤�����¼��ѯ',
		iconCls:'find',
		height:20,
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
	});

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});