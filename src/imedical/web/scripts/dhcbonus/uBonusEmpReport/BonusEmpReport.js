Ext.onReady(function(){
	Ext.QuickTips.init();
	formu='';

	var uPanel = new Ext.Panel({
		title: '人员报表权限',  //页面最上面的面板主标题
		region: 'center',
		layout: 'border',
		//items: [itemGrid,combos]
	    items: [itemGrid]
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

