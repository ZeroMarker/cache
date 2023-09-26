// 名称:科室采购人员维护
// 编写日期:2015-05-23
//lihui

var groupId = session['LOGON.GROUPID'];
var CTLocId = "";

//=========================科室信息=================================
//安全组
var groupComboStore = new Ext.data.JsonStore({
    autoDestroy: true,
    url: 'dhcstm.orgutil.csp?actiontype=QueryGroup',
    storeId: 'groupComboStore',
    root: 'rows',
    totalProperty : "results",
    fields: ['RowId', 'Description']
});

var groupCombo = new Ext.ux.ComboBox({
	fieldLabel : '安全组',
	id : 'groupCombo',
	name : 'groupCombo',
	store : groupComboStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'FilterDesc',
	listeners : {
		"select":function() {
			CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
		}
	}
});

//科室代码
var locCode = new Ext.form.TextField({
	id:'locCode',
	allowBlank:true,
	anchor:'90%',
	width:70
});
//科室名称
var locName = new Ext.form.TextField({
	id:'locName',
	allowBlank:true,
	anchor:'90%',
	width:70
});

var CTLocGrid="";
//配置数据源
var gridUrl = 'dhcstm.locpurplanuseraction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'POST'});
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
	remoteSort:false,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			var strFilter = Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
			var selectGroup = Ext.getCmp("groupCombo").getValue();
			if(selectGroup == ""){
				selectGroup=groupId
			}
			store.setBaseParam('strFilter',strFilter);
			store.setBaseParam('groupId',selectGroup);
		}
	}
});

//模型
var CTLocGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:150,
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
		CTLocGridDs.load({params:{start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
	store:CTLocGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1} 条，一共 {2} 条'
});

//表格
CTLocGrid = new Ext.grid.GridPanel({
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	tbar:['安全组:',groupCombo,'科室代码:',locCode,'科室名称:',locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar,
	listeners : {
		'rowclick' : function(grid,rowIndex,e){
			var selectedRow = CTLocGridDs.data.items[rowIndex];
			CTLocId = selectedRow.data["Rowid"];
			LocPurUserGridDs.load({params:{start:0,limit:LocPurUserPagingbar.pageSize,sort:'Rowid',dir:'desc'}});
			RefreshLocUser();
		}
	}
});

function RefreshLocUser(){
	UStore.load();
	
}
//=========================科室信息end==========================

//=========================人员维护=============================

var UStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
	
var UCG = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'UCG',
	name : 'UCG',
	anchor : '90%',
	width : 120,
	store : UStore,
	valueField : 'RowId',
	displayField : 'Description',
	//allowBlank : false,
	triggerAction : 'all',
	emptyText : '名称...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});		
	
UCG.on('beforequery', function(e) {
	UStore.removeAll();
	UStore.setBaseParam('name',Ext.getCmp('UCG').getRawValue());
	UStore.setBaseParam('locId',CTLocId);
	var pageSize=Ext.getCmp("UCG").pageSize;
	UStore.load({
		params:{start:0,limit:pageSize},
		callback : function(r,options, success){
					var tmprecode=new  Ext.data.Record()
					for(var i=0; i<LocPurUserGridDs.getCount()-1;i++ ){
						var name=LocPurUserGridDs.getAt(i).get("Name");
						UStore.removeAt(UStore.find("Description",name));
					}
				}
	});
});

//配置数据源
var LocPurUserGridProxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryUser',method:'GET'});
var LocPurUserGridDs = new Ext.data.Store({
	proxy:LocPurUserGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'Rowid'},
		{name:'UserId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Default'},
		{name:'Active'}
	]),
	pruneModifiedRecords:true,
	remoteSort:false,
	listeners : {
		beforeload : function(store,options){
			store.removeAll();
			store.setBaseParam('ctlocid',CTLocId);
			
		}
	}
});

var DefaultField = new Ext.grid.CheckColumn({
	header:'是否默认',
	dataIndex:'Default',
	width:100,
	sortable:true
});

var ActiveField = new Ext.grid.CheckColumn({
	header:'是否有效',
	dataIndex:'Active',
	width:100,
	sortable:true
});

//模型
var LocPurUserGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"人员ID",
		dataIndex:'Code',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"姓名",
		dataIndex:'UserId',
		width:200,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer2(UCG,"UserId","Name"),
		editor:new Ext.grid.GridEditor(UCG)
	},DefaultField,ActiveField
]);

var addLocPurUser = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(CTLocId!=""){
			addRow();
		}else{
			Msg.info("error", "请选择科室!");
		}
		
	}
});

function addRow() {
	var rec = CreateRecordInstance(LocPurUserGridDs.fields,{Default:'Y',Active:'Y'});
	LocPurUserGridDs.add(rec);
	var col = GetColIndex(LocPurUserGrid,'UserId');
	LocPurUserGrid.startEditing(LocPurUserGridDs.getCount() - 1, col);
}

var saveLocPurUser = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		//获取所有的新记录
		var mr=LocPurUserGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var RowId = mr[i].data["Rowid"];
			var userId = mr[i].data["UserId"];
			if(userId==""){
				continue;
			}
			var active = mr[i].data["Active"];
			var def = mr[i].data["Default"];
			var name = mr[i].data["Name"];
			var dataRow = RowId+"^"+userId+"^"+active+"^"+def+"^"+name;
			if(data==""){
				data = dataRow;
			}else{
				data = data+xRowDelim()+dataRow;
			}
		}
		if(data==""){
			Msg.info("error","没有需要保存的数据!");
			return false;
		}else{
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=SaveUser',
				params: {data:data,ctlocid:CTLocId},
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					data="";
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						LocPurUserGridDs.reload();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","人员重复!");
						}else{
							Msg.info("error", "保存失败"+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
    }
});

var deleteLocPurUser = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = LocPurUserGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","请选择数据!");
			return false;
		}else{
			var record = LocPurUserGrid.getStore().getAt(cell[0]);
			var RowId = record.get("Rowid");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=deleteUser&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										LocPurUserGridDs.reload();
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

var LocPurUserPagingbar = new Ext.PagingToolbar({
	store:LocPurUserGridDs,
	pageSize:30,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条，一共 {2} 条'
});

//表格
var LocPurUserGrid = new Ext.grid.EditorGridPanel({
	store:LocPurUserGridDs,
	cm:LocPurUserGridCm,
	trackMouseOver:true,
	height:370,
	plugins:[DefaultField,ActiveField],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[addLocPurUser,'-',saveLocPurUser,'-',deleteLocPurUser],
	bbar:LocPurUserPagingbar,
	listeners : {
		beforeedit : function(e){
			if(e.field=='UserId' && e.record.get('Rowid')!=''){
				e.cancel = true;
			}
		}
	}
});
//=========================人员维护end=============================

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var CTLocPanel = new Ext.Panel({
		deferredRender : true,
		title:'科室信息',
		activeTab: 0,
		region:'north',
		collapsible: true,
		split: true,
		height:300,
		layout:'fit',
		items:[CTLocGrid]
	});
	
	var StkLocUserCatGroupPanel = new Ext.Panel({
		deferredRender : true,
		title:'人员维护',
		activeTab: 0,
		region:'center',
		height:300,
		layout:'fit',
		split:true,
		collapsible:true,
		items:[LocPurUserGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[CTLocPanel,StkLocUserCatGroupPanel],
		renderTo:'mainPanel'
	});
	queryCTLoc.handler();
	//获取登陆值
	SetLogGroup(groupCombo.getStore(), "groupCombo");
});
