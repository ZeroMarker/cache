
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	  var viewPanel = new Ext.Viewport({
    	layout: 'border',
    	renderTo:'mainPanel',
		items : [{
			title:"ƾ֤¼��",
			region:'center',
			layout:'fit',
			items:ListTab
		}]
    
    });
	
	/* var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		title:'ƾ֤¼��',
		height:85,
		// layout: 'border',
		region: 'center',
		items:  [ListTab]                         
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	}); */
	
});