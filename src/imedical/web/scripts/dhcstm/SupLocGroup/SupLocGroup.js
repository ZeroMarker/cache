// 名称:类组字典授权
// 编写日期:2015-11-3

var gGroupId=""
var gridUrl="dhcstm.locinfoaction.csp"
//安全组
var groupComboStore = new Ext.data.JsonStore({
    url: 'dhcstm.orgutil.csp?actiontype=GetGroup',
    root: 'rows',
    totalProperty : "results",
    fields: ['RowId', 'Description']
});

var groupCombo = new Ext.ux.ComboBox({
	fieldLabel : '安全组',
	id : 'groupCombo',
	store : groupComboStore,
	width:140,
	filterName:'FilterDesc',
	listeners : {
		"select":function(c,r,i) {
			gGroupId=c.getValue()
			RefreshLocStk()
		}
	}
});

var StkLocGroupStore = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=AuthorizedLoc',
	totalProperty : "results",
	root : 'rows',
	fields:[
		{name:'Rowid'},
		{name:'Loc'},
		{name:'LocCode'},
		{name:'LocDesc'},
		{name:'DefaultFlag'}
	],
	pruneModifiedRecords:true,
	remoteSort:true,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			store.setBaseParam('group',gGroupId);
		}
	}
});

var defaultFlag = new Ext.grid.CheckColumn({
	header:'缺省标志',
	dataIndex:'DefaultFlag',
	width:60,
	sortable:true
});
//模型
var StkLocGroupCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"代码",
		dataIndex:'LocCode',
		width:180,
		align:'left',
		sortable:true
	},{
		header:"描述",
		dataIndex:'LocDesc',
		width:150,
		align:'left',
		sortable:true
	},defaultFlag
]);

var saveStkLocGroup = new Ext.ux.Button({
	text:'保存',
	iconCls:'page_save',
	handler:function(){
		//获取所有的新记录
		var mr=StkLocGroupStore.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var RowId=mr[i].data["Rowid"];
			var defaultflag = mr[i].data["DefaultFlag"];
			var dataRow = RowId+"^"+defaultflag;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=Savedefat',
				params: {data:data},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						RefreshLocStk();
					}else{
						Msg.info("error", "保存失败!");
					}
				},
				scope: this
			});
		}
	}
});

var deleteStkLocGroup = new Ext.ux.Button({
	text:'删除',
	iconCls:'page_delete',
	handler:function(){
		var cell = StkLocGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = StkLocGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=deleteFrLoc&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										RefreshLocStk();
									}else{
										Msg.info("error","删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error","数据有错!");
			}
		}
    }
});

var StkLocGroupGrid = new Ext.ux.EditorGridPanel({
	id : 'StkLocGroupGrid',
	title : '安全组已授权供应科室',
	region : 'center',
	store:StkLocGroupStore,
	cm:StkLocGroupCm,
	trackMouseOver:true,
	plugins:[defaultFlag],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:['安全组:',groupCombo,saveStkLocGroup,deleteStkLocGroup]
});

var UnAuthorizedLocStore = new Ext.data.JsonStore({
	url : gridUrl+'?actiontype=UnAuthorizedLoc',
	totalProperty : "results",
	root : 'rows',
	fields : ["Loc","LocCode","LocDesc"],
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			store.setBaseParam('group',gGroupId);
		}
	}
});
var LocFilter = new Ext.form.TextField({
    id:'LocFilter',
    fieldLabel:'科室',
    allowBlank:true,
    emptyText:'科室...',
    anchor:'90%',
    selectOnFocus:true
});
var FilterButton = new Ext.Toolbar.Button({
    text : '过滤',
    tooltip : '过滤',
    iconCls : 'page_gear',
    width : 70,
    height : 30,
    handler:function(){
    	var FilterDesc = Ext.getCmp("LocFilter").getValue();
		UnAuthorizedLocStore.setBaseParam('FilterDesc',FilterDesc);
		UnAuthorizedLocStore.setBaseParam('group',gGroupId);
		UnAuthorizedLocStore.load();
    }
});
var UnAuthorLocCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'id',
		dataIndex : 'Loc',
		hidden : true
	},{
		header : '科室代码',
		dataIndex : 'LocCode',
		width : 200
	},{
		header : '科室描述',
		dataIndex : 'LocDesc',
		width : 200
	}
]);

var UnAuthorLocGrid = new Ext.ux.GridPanel({
	id : 'UnAuthorLocGrid',
	title : '未授权科室(双击快速授权)',
	region : 'east',
	store : UnAuthorizedLocStore,
	cm : UnAuthorLocCm,
	width : 600,
	tbar:[LocFilter,FilterButton],
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	listeners : {
		rowdblclick : function(grid,rowIndex,e){
			var Loc = grid.store.getAt(rowIndex).get('Loc');
			AddLocStkGrp(Loc);
		}
	}
});

function AddLocStkGrp(Loc){
	Ext.Ajax.request({
		url: gridUrl+'?actiontype=addFrLoc',
		params: {frLoc:Loc,group:gGroupId},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshLocStk();
			}else{
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}

function RefreshLocStk(){
	StkLocGroupStore.load();
	UnAuthorizedLocStore.load();
}
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	new Ext.ux.Viewport({
		layout:'border',
		items:[StkLocGroupGrid,UnAuthorLocGrid]
	});
	SetLogGroup(groupCombo.getStore(), "groupCombo");
	gGroupId=groupCombo.getValue()
	RefreshLocStk();
});
