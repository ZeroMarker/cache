// 名称:下属科室管理(2016-12-23用于科室消耗管理的跨科室发放)
// 编写日期:2012-06-15

var groupId = session['LOGON.GROUPID'];
var gCTLocId = "";

//=========================科室信息=================================
//科室代码
var locCode = new Ext.form.TextField({
	id:'locCode',
	allowBlank:true,
	anchor:'90%'
});
//科室名称
var locName = new Ext.form.TextField({
	id:'locName',
	allowBlank:true,
	anchor:'90%'
});

//配置数据源
var gridUrl = 'dhcstm.deflocaction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'GET'});
var CTLocGridDs = new Ext.data.Store({
	proxy:CTLocGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'Code'},
		{name:'Desc'}
	]),
	remoteSort:false
});

//模型
var CTLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"名称",
		dataIndex:'Desc',
		width:200,
		align:'left',
		sortable:true
	}
]);

var queryCTLoc = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var StrParam = Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		CTLocGridDs.setBaseParam('strFilter',StrParam);
		CTLocGridDs.setBaseParam('groupId',groupId);
		CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
	store:CTLocGridDs,
	pageSize:30,
	displayInfo:true
});

//表格
var CTLocGrid = new Ext.grid.GridPanel({
	title:'科室信息',
	region:'west',
	width:600,
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({
		listeners : {
			rowselect : function(sm,rowIndex,r){
				gCTLocId = r.data["Rowid"];
				DefLocGridDs.setBaseParam('locId',gCTLocId);
				DefLocGridDs.setBaseParam('sort','Rowid');
				DefLocGridDs.load({params:{start:0,limit:DefLocPagingToolbar.pageSize}});
			}
		}
	}),
	loadMask:true,
	tbar:['科室代码:',locCode,'科室名称:',locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar
});
//=========================科室信息=================================

//=========================下属科室=============================
function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'Rowid',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'SubLocId',
			type : 'int'
		}, {
			name : 'UseFlag',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		Rowid:'',
		Code:'',
		Desc:'',
		SubLocId:'',
		UseFlag:''
	});
	
	DefLocGridDs.add(NewRecord);
	DefLocGrid.startEditing(DefLocGridDs.getCount() - 1, 2);
}

var DefLoc = new Ext.ux.LocComboBox({
	fieldLabel : '科室',
	id : 'DefLoc',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();
			}
		},
		beforeselect : function(combo,record,index){
			var selIndex = DefLocGridDs.findExact('SubLocId',record.get('RowId'),0);
			if(selIndex>=0){
				Msg.info('warning','科室重复!');
				return false;
			}
		}
	}
});

//配置数据源
var DefLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query',method:'GET'});
var DefLocGridDs = new Ext.data.Store({
	proxy:DefLocGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SubLocId'},
		{name:'UseFlag'}
	]),
	remoteSort:true,
	pruneModifiedRecords : true
});

var UseFlag = new Ext.grid.CheckColumn({
	header:'是否使用',
	dataIndex:'UseFlag',
	width:100,
	sortable:true,
	hidden : true
});

//模型
var DefLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"代码",
		dataIndex:'Code',
		width:180,
		align:'left',
		sortable:true
	},{
		header:"描述",
		dataIndex:'SubLocId',
		width:180,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(DefLoc,'SubLocId','Desc'),
		editor:new Ext.grid.GridEditor(DefLoc)
	},UseFlag
]);

var addDefLoc = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(Ext.isEmpty(gCTLocId)){
			Msg.info('warning','请选择科室!');
			return;
		}
		addNewRow();
	}
});

var saveDefLoc = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		if(DefLocGrid.activeEditor!=null){
			DefLocGrid.activeEditor.completeEdit();
		}
		var mr=DefLocGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var subLocId = mr[i].data["SubLocId"];
			if(subLocId=='')continue;
			var desc= mr[i].data["Desc"];
			var flag= mr[i].data["UseFlag"];
			var dataRow= subLocId+"^"+flag;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("warning","没有需要保存的信息!");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: gridUrl+'?actiontype=Save',
			params : {locId : gCTLocId, data : data},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "保存成功!");
					DefLocGridDs.reload();
				}else{
					Msg.info("error", "保存失败!");
				}
			},
			scope: this
		});
	}
});

var deleteDefLoc = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = DefLocGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = DefLocGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										DefLocGridDs.reload();
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
				var rowInd=cell[0];
				if (rowInd>=0){
					DefLocGrid.getStore().removeAt(rowInd);
					DefLocGrid.getView().refresh();
				}
			}
		}
	}
});

var DefLocPagingToolbar = new Ext.PagingToolbar({
	store:DefLocGridDs,
	pageSize:30,
	displayInfo:true
});

//表格
var DefLocGrid = new Ext.grid.EditorGridPanel({
	title:'下属科室',
	region:'center',
	store:DefLocGridDs,
	cm:DefLocGridCm,
	trackMouseOver:true,
	plugins:UseFlag,
	stripeRows:true,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	sm:new Ext.grid.CellSelectionModel({}),
	tbar:[addDefLoc,'-',saveDefLoc,'-',deleteDefLoc],
	bbar:DefLocPagingToolbar,
	listeners : {
		beforeedit : function(e){
			if(e.record.get('Rowid')!=''){
				return false;
			}
		}
	}
});
//=========================下属科室=============================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[CTLocGrid,DefLocGrid],
		renderTo:'mainPanel'
	});
	
	queryCTLoc.handler();
});
