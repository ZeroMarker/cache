
Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'项目立项备案',
		region: 'center',
		layout: 'border',
		items: [queryPanel,itemGrid]
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
	    title:'项目人员信息',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	/* var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'经费信息',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	}); */
	
	var uPrjCompInfoPanel = new Ext.Panel({
		id :'uPrjCompInfoPanel',
	    title:'合作研究单位责任分工、科技经费分配',
		region: 'center',
		layout: 'border',
		items: ProjCompGrid
	});
	
	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		//items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjItemInfoPanel,uPrjCompInfoPanel] 
		items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjCompInfoPanel] 		//xm--20160524删除项目科目维护
	});
//Ext.getCmp('uPanel').on('tabchange',this.tabChange,this);
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});