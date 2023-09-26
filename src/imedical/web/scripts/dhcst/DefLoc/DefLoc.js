// 名称:支配科室管理
// 编写日期:2012-06-15
//=========================定义全局变量=================================
var groupId = session['LOGON.GROUPID'];
var CTLocId = "";
//=========================定义全局变量=================================
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

var CTLocGrid="";
//配置数据源
var gridUrl = 'dhcst.deflocaction.csp';
var CTLocGridProxy= new Ext.data.HttpProxy({url:gridUrl+'?actiontype=selectAll',method:'GET'});
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

//初始化默认排序功能
CTLocGridCm.defaultSortable = true;

var queryCTLoc = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		CTLocGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=QueryLoc',method:'GET'});
		CTLocGridDs.load({params:{strFilter:Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue(),start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc',groupId:groupId}});
	}
});

var CTLocPagingToolbar = new Ext.PagingToolbar({
    store:CTLocGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['strFilter']=Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		B['groupId']=groupId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
CTLocGrid = new Ext.grid.GridPanel({
	store:CTLocGridDs,
	cm:CTLocGridCm,
	trackMouseOver:true,
	height:665,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	tbar:['科室代码:',locCode,'科室名称:',locName,'-',queryCTLoc],
	bbar:CTLocPagingToolbar
});
//=========================科室信息=================================

//=========================支配科室=============================
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
		}
	]);
	
	var NewRecord = new record({
		Rowid:'',
		Code:'',
		Desc:'',
		SubLocId:''
	});
					
	DefLocGridDs.add(NewRecord);
	DefLocGrid.startEditing(DefLocGridDs.getCount() - 1, 2);
}

var DefLocStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.orgutil.csp?actiontype=DeptLoc&start=0&limit=999&desc='
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
	
var DefLoc = new Ext.form.ComboBox({
	fieldLabel : '科室',
	id : 'DefLoc',
	name : 'DefLoc',
	anchor : '90%',
	width : 120,
	store : DefLocStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '科室...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();
			}
		}
	}
});		
				
function rendererDefLoc(value, p, r) {
	var combo = Ext.getCmp('DefLocList');
	var index = DefLocStoreList.find(combo.valueField, value);
	var record = DefLocStoreList.getAt(index);
	var recordv = combo.findRecord(combo.valueField, value);
	if (value == '' || !recordv) {
		return value;
	}
	var displayText = "";
	if (record == null) {
		displayText = value;
	} else {
		displayText = recordv.get(combo.displayField);
	}
	return displayText;
}
		
var DefLocStoreList = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.orgutil.csp?actiontype=DeptLoc&start=0&limit=999&desc='
	}),
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
		
DefLocStoreList.load();
var DefLocList = new Ext.form.ComboBox({
	fieldLabel : '科室',
	id : 'DefLocList',
	name : 'DefLocList',
	anchor : '90%',
	width : 120,
	store : DefLocStoreList,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '科室...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : ''
});

var DefLocGrid="";
//配置数据源
var DefLocGridProxy= new Ext.data.HttpProxy({url:gridUrl,method:'GET'});
var DefLocGridDs = new Ext.data.Store({
	proxy:DefLocGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'Rowid'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SubLocId'}
	]),
    remoteSort:true
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
        dataIndex:'Desc',
        width:180,
        align:'left',
        sortable:true,
		renderer : rendererDefLoc,
		editor:new Ext.grid.GridEditor(DefLoc)
    }
]);

//初始化默认排序功能
DefLocGridCm.defaultSortable = true;

var addDefLoc = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
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
		//获取所有的新记录
		var mr=DefLocGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var id = mr[i].data["SubLocId"];
			if(id!=""){
				if(data==""){
					data = id;
				}else{
					data = data+"^"+id;
				}
			}else{
				id = mr[i].data["Desc"];
				if(id!=""){
					if(data==""){
						data = id;
					}else{
						data = data+"^"+id;
					}
				}
			}
		}
		if(data!=""){
			Ext.Ajax.request({
				url: gridUrl+'?actiontype=Save&data='+data+'&locId='+CTLocId,
				failure: function(result, request) {
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						DefLocGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
						DefLocGridDs.load({params:{start:0,limit:DefLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
					}else{
						Msg.info("error", "保存失败!");
					}
				},
				scope: this
			});
		}
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
							Ext.Ajax.request({
								url:gridUrl+'?actiontype=delete&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									Msg.info("error","请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","删除成功!");
										DefLocGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
										DefLocGridDs.load({params:{start:0,limit:DefLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
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

var DefLocPagingToolbar = new Ext.PagingToolbar({
    store:DefLocGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['locId']=CTLocId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
DefLocGrid = new Ext.grid.EditorGridPanel({
	store:DefLocGridDs,
	cm:DefLocGridCm,
	trackMouseOver:true,
	height:665,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	tbar:[addDefLoc,'-',saveDefLoc,'-',deleteDefLoc],
	bbar:[DefLocPagingToolbar]
});
//=========================支配科室=============================

//=============科室与支配科室二级联动===================
CTLocGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = CTLocGridDs.data.items[rowIndex];
	CTLocId = selectedRow.data["Rowid"];
	DefLocGridDs.proxy = new Ext.data.HttpProxy({url:gridUrl+'?actiontype=Query&locId='+CTLocId,method:'GET'});
	DefLocGridDs.load({params:{start:0,limit:DefLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc'}});
});
//=============科室与支配科室二级联动===================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var CTLocPanel = new Ext.Panel({
		deferredRender : true,
		title:'科室信息',
		activeTab: 0,
		region:'west',
		height:328,
		width:600,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 600,
		items:[CTLocGrid]                                 
	});
	
	var DefLocPanel = new Ext.Panel({
		deferredRender : true,
		title:'支配科室',
		activeTab: 0,
		region:'center',
		height:328,
		width:1200,
		items:[DefLocGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[CTLocPanel,DefLocPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================