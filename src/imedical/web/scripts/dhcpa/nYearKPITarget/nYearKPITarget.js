/**
  *name:dimenstype
  *author:limingzhong
  *Date:2010-7-14
 */
Ext.onReady(function(){
	
	/*
	Ext.getDoc().on("contextmenu", function(e){   
		e.stopEvent();   
	}); 
	*/
	
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[KPITargetTab]                                
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});