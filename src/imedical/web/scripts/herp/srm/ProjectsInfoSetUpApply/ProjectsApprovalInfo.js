Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel =  new Ext.Panel({
	title:'��Ŀ����',
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	//items:[itemGrid,DetailGrid]                       //���Tabs
	items:itemGrid                  //���Tabs
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});