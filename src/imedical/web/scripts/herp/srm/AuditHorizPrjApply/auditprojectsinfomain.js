
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'横向项目申请材料审核',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
	
 var uDetailGridPanel = new Ext.Panel({
 	    id :'uDetailGridPanel',
	    title:'项目研究情况',
		region: 'center',
		layout: 'border',
		items: DetailGrid
	});
	var uParticipantsInfoPanel = new Ext.Panel({
		  id:'uParticipantsInfoPanel',
	    title:'课题组人员信息',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'经费信息',
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