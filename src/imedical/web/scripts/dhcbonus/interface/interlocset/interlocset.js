/**
  *name:interlocset
  *author:limingzhong
  *Date:2010-11-10
 */
Ext.onReady(function(){
	
	/*
	Ext.getDoc().on("contextmenu", function(e){   
		e.stopEvent();   
	}); 
	*/
	
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[InterLocSetTab]                                
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});