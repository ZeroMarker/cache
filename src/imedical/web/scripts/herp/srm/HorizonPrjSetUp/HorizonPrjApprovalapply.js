
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'��Ŀ�����',
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
	});
	
 var uDetailGridPanel = new Ext.Panel({
 	    id :'uDetailGridPanel',
	    title:'��Ŀ�о����',
		region: 'center',
		layout: 'border',
		items: DetailGrid
	});
	var uParticipantsInfoPanel = new Ext.Panel({
		  id:'uParticipantsInfoPanel',
	    title:'��Ŀ��Ա��Ϣ',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	/* var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'������Ϣ',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	}); */
	
	var uPrjCompInfoPanel = new Ext.Panel({
		id :'uPrjCompInfoPanel',
	    title:'�����о���λ���ηֹ����Ƽ����ѷ���',
		region: 'center',
		layout: 'border',
		items: ProjCompGrid
	});
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		//items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjItemInfoPanel,uPrjCompInfoPanel] 
		items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjCompInfoPanel] 		//xm--20160524ɾ����Ŀ��Ŀά��
	});
//Ext.getCmp('uPanel').on('tabchange',this.tabChange,this);
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});