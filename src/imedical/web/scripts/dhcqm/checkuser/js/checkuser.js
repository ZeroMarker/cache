//�����Աά�� 
Ext.onReady(function(){
		Ext.QuickTips.init();
			
		var uPanel = new Ext.Panel({
			title: '�����Ա',
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