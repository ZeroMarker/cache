
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'������Ŀ����������',
		region: 'center',
		layout: 'border',
		items: itemGrid
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
	    title:'��������Ա��Ϣ',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'������Ϣ',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	});
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjItemInfoPanel]                           
	});
//Ext.getCmp('uPanel').on('tabchange',this.tabChange,this);
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});