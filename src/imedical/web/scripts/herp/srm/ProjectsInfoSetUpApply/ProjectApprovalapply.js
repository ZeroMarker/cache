
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
	    title:'������Ŀ�����',
		region: 'center',
		layout: 'border',
		items: srmprjitemGrid
	});

    var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'������Ϣ����',
		region: 'center',
		layout: 'border',
		items: [itemGrid,itemDetail]
	}); 
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,uPrjItemInfoPanel]    //xm-ɾ����Ŀ���ѱ���20160523--��Ԥ��ľ��ѱ������롢���ҳ��ᵽ����ϵͳ20161019
        //items: [uPanel]   		
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});