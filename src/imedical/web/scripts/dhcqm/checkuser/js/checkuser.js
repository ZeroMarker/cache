//检查人员维护 
Ext.onReady(function(){
		Ext.QuickTips.init();
			
		var uPanel = new Ext.Panel({
			title: '检查人员',
    		layout : 'border',
			region:'center',
			items: itemGrid
		});


		var uViewPort = new Ext.Viewport({
			layout: 'border',
			items : uPanel,
			renderTo: 'uViewPort'
	});
	
})