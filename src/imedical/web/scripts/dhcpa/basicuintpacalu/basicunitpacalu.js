/**
  *author:liuyang
  *Date:2011-12-13
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
   
    var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'������Ҽ�Ч���˼���',
		region: 'center',
		layout: 'border',
		items: [itemGrid,jxunitGrid,kpiGrid]
	});
	
	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:uPanel                                
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});