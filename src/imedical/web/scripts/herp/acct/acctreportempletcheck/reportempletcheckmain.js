Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';
	

	
	var uPanel = new Ext.Panel({
	//	title: '����ģ����˴���',
		region: 'center',
		layout: 'border',
		items: [itemMain,itemDetail,queryPanel] //queryPanel,,itemDetail itemMain,
	});

	// var uTabPanel = new Ext.TabPanel({
		// activeTab: 0,
		// region: 'center',
		// items: uPanel                           
	// });

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uPanel,
		renderTo: 'uViewPort'
	});
});

/* 
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'����ģ�����',
		region: 'center',
		layout: 'border',
		items: [itemGrid,MAitemGrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                           
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});
 */