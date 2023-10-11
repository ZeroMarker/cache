
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
	    title:'纵向项目立项审核',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
  /* var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'经费信息',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	}); */
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		//items: [uPanel,uPrjItemInfoPanel]    //xm--删除项目科目维护
		items: [uPanel]    		
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});