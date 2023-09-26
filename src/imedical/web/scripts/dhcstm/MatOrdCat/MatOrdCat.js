// 名称:物资医嘱大类管理
// 编写日期:2012-06-14

var gridUrl='dhcstm.matordcataction.csp'

function RefreshGrid(){
	MatOrdCatGridDs.load();
	UnAuthorOrdCatGridStore.load();
}
function AddMatOrdCat(OrdCatRowId){
	Ext.Ajax.request({
	url:gridUrl+'?actiontype=AddMatOrdCat&OrdCatRowId='+OrdCatRowId,
	failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
			},
	success: function(result, request) {
		var jsonData = Ext.util.JSON.decode( result.responseText );
		if (jsonData.success=='true') {
			Msg.info("success","操作成功!");
			RefreshGrid();
		}else{
			Msg.info("error","操作成功!");
			}
		},
	scope: this
	});
}
function DelMatOrdCat(MatOrdCatRowId){
	Ext.Ajax.request({
	url:gridUrl+'?actiontype=DelMatOrdCat&MatOrdCatRowId='+MatOrdCatRowId,
	failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
			},
	success: function(result, request) {
		var jsonData = Ext.util.JSON.decode( result.responseText );
		if (jsonData.success=='true') {
			Msg.info("success","操作成功!");
			RefreshGrid();
		}else{
			Msg.info("error","操作成功!");
			}
		},
	scope: this
	});
}
var MatOrdCatGridDs = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=MatOrdCat',
	totalProperty : "results",
	root : 'rows',
	fields : ["MatOrdCatRowId","OrdCatDesc"]
});

var MatOrdCatGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'MatOrdCatRowId',
		dataIndex : 'MatOrdCatRowId',
		hidden : true
	},{
		header : ' 物资医嘱大类',
		dataIndex : 'OrdCatDesc',
		width : 200
	}
]);
//表格
var MatOrdCatGrid = new Ext.ux.EditorGridPanel({
	id : 'MatOrdCatGrid',
	title : '物资医嘱大类(双击快速取消授权)',
	region : 'west',
	width : 300,
	store:MatOrdCatGridDs,
	cm:MatOrdCatGridCm,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	listeners : {
		'rowdblclick' : function(grid,rowIndex,e){
			var MatOrdCatRowId = grid.store.getAt(rowIndex).get('MatOrdCatRowId');
			DelMatOrdCat(MatOrdCatRowId);
			
		}
	}
});

var UnAuthorOrdCatGridStore = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=UnAuthorOrdCat',
	totalProperty : "results",
	root : 'rows',
	fields : ["OrdCatRowId","OrdCatDesc"]
});

var UnAuthorOrdCatGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'OrdCatRowId',
		dataIndex : 'OrdCatRowId',
		hidden : true
	},{
		header : ' 医嘱大类',
		dataIndex : 'OrdCatDesc',
		width : 200
	}
]);
///---------------------
var UnAuthorOrdCatGrid = new Ext.ux.GridPanel({
	id : 'UnAuthorOrdCatGrid',
	title : '医嘱大类未授权(双击快速授权)',
	region : 'center',
	store : UnAuthorOrdCatGridStore,
	cm : UnAuthorOrdCatGridCm,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	listeners : {
		rowdblclick : function(grid,rowIndex,e){
			var OrdCatRowId = grid.store.getAt(rowIndex).get('OrdCatRowId');
			AddMatOrdCat(OrdCatRowId);
		}
	}
});


//=====================================================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[MatOrdCatGrid,UnAuthorOrdCatGrid]
	});
	RefreshGrid()
});
