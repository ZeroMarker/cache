
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var uPanel =  new Ext.Panel({
		//title: '��Ŀ��ʼ���¼��',
		layout: 'border',
		region:'center',
		items:[query,itemGrid]                                 //���Tabs
    });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : uPanel,
  	renderTo: 'mainPanel'
  });
});