Ext.onReady(function(){
	Ext.QuickTips.init();  

	//��ʼ������Tips
	var acctCheckPanel = new Ext.Panel({
    //title : '��λ���ж���',
    layout : 'border',
	region:'center',
    items:[queryPanel,Detail,itemGrid]   // acctCheckTypeGrid,acctCheckItemGrid     
	});
	
	// var tabPanel = new Ext.TabPanel({
  	// activeTab:0,
  	// region:'center',
  	// items:[acctCheckPanel]                                 //���Tabs
  // });
 
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : acctCheckPanel,
      renderTo: 'MainViewPort'
  });
});

