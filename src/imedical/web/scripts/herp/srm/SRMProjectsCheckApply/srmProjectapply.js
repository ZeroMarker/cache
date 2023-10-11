
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'纵向课题验收申请',
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
		//items: [uPanel,uPrjItemInfoPanel] 
		items: [uPanel] 		 //xm--20160524删除项目科目维护
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});