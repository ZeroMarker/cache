Ext.onReady(function(){
	Ext.QuickTips.init();                        
	var reportTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	frame:true,
    	items:[itemGrid]         
  	});
	var reportPanel = new Ext.Panel({
		title:'现金流量项目表',
      	layout:'fit',
      	collapsible: false,
      	plain:true,
      	frame:true,
		region:'center',
      	items:reportTabPanel,           
	  	tbar:menubar                             
	});
	var mainPanel = new Ext.Viewport({
      	layout:'border',
      	items : reportPanel,
      	renderTo: 'mainPanel'
  	})
});