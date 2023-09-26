/**
  *name:schemaudit
  *author:limingzhong
  *Date:2010-8-19
 */
Ext.onReady(function(){
	Ext.QuickTips.init();  
	var reportTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	frame:true,
    	items:[detailReport]         
  	});
	var reportPanel = new Ext.Panel({
		title:'º®–ß∑Ω∞∏…Û∫À',
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