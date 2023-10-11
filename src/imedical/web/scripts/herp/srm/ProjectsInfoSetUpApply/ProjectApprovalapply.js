
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
	    title:'纵向项目立项备案',
		region: 'center',
		layout: 'border',
		items: srmprjitemGrid
	});

    var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'经费信息编制',
		region: 'center',
		layout: 'border',
		items: [itemGrid,itemDetail]
	}); 
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,uPrjItemInfoPanel]    //xm-删除项目经费编制20160523--把预算的经费编制申请、审核页面搬到科研系统20161019
        //items: [uPanel]   		
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});