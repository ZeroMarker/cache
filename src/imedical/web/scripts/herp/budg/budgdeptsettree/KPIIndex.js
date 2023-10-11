/**
  *name:kpi科室维护
  *author:limingzhong
  *Date:2010-7-21
 */

Ext.onReady(function(){
	
	Ext.QuickTips.init();                        
	var reportTabPanel = new Ext.TabPanel({
    	activeTab:0,
    	frame:true,
    	items:[detailReport]         
  	});
	var reportPanel = new Ext.Panel({
		title:'科室维护',
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