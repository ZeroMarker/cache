
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
	title:"ƾ֤��ӡ����",
	iconCls : 'find',
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});