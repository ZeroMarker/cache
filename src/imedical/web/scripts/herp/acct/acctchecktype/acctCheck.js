Ext.onReady(function(){
	Ext.QuickTips.init();  
	//��ʼ������Tips
	var acctCheckPanel = new Ext.Panel({
    title : '��ƺ���ά��',
    layout : 'border',
	region:'center',
    items:[acctCheckTypeGrid]   // acctCheckTypeGrid,acctCheckItemGrid     
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab:0,
  	region:'center',
  	items:[acctCheckPanel]                                 //���Tabs
  });
 
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : tabPanel,
      renderTo: 'MainViewPort'
  });
});