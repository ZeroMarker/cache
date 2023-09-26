// /名称: 包明细
var PackLink=function(PackRowId) {	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var ItmGridDs = new Ext.data.JsonStore({
	url :'dhcstm.packchargelinkaction.csp?actiontype=GetDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["PCL","Inci","InciDesc","Spec","InciCode","CerNo","CerExpDate"]
});

var ItmLinkGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'PCL',
		dataIndex : 'PCL',
		hidden : true
	},{
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true
	},{
		header : '物资代码',
		dataIndex : 'InciCode',
		width : 120,
		renderer :Ext.util.Format.InciPicRenderer('Inci')
	},{
		header : '物资名称',
		dataIndex : 'InciDesc',
		width : 320
	},{
		header : '规格',
		dataIndex : 'Spec',
		width : 120
	},{
		header : "注册证号",
		dataIndex : 'CerNo',
		width : 240,
		align : 'right',
		sortable : true
	},{
		header : "注册证效期",
		dataIndex : 'CerExpDate',
		width : 80,
		align : 'right',
		sortable : true
	}
]);
///---------------------

var ItmLinkGrid = new Ext.ux.GridPanel({
	id : 'ItmLinkGrid',
	store : ItmGridDs,
	cm : ItmLinkGridCm,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true})
}
);
	var findWin = new Ext.Window({
		title:'包明细',
		id:'findWin',
		width:1000,
		height:520,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'fit',
		items : [ItmLinkGrid]           // create instance immediately
		
	});
	ItmGridDs.setBaseParam("Pack",PackRowId)
	ItmGridDs.load()	
	//显示窗口
	findWin.show();		
}