
Ext.onReady(function(){
	Ext.QuickTips.init();                             

  var tPanel =  new Ext.Panel({
		title:'项目经费报销审核',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 
  });
  
	var tabPanel =  new Ext.TabPanel({
  	activeTab: 0,
  	
  	region:'center',
  	items:tPanel                                
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tPanel,
  	renderTo: 'mainPanel'
  });
});