
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
	    title:'���������������',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
  /* var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'������Ϣ',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	}); */
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		//items: [uPanel,uPrjItemInfoPanel] 
		items: [uPanel] 		 //xm--20160524ɾ����Ŀ��Ŀά��
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});