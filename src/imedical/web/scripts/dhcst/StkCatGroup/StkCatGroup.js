// 名称:库存类组
// 编写日期:2012-05-8
//=========================定义全局变量===============================
var StkCatGroupId = "";
//=========================定义全局变量===============================
//=========================库存组=====================================
var StruModeFlag=new Ext.grid.CheckColumn({
    header:'是否一对多',
    align:'center',
    dataIndex:'StruModeFlag',
    width:80,
    sortable : true
});

function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'SetCode',
			type : 'string'
		},{
			name : 'StruModeFlag',
			type : 'string'
		}
	]);
					
	var NewRecord = new record({
		RowId : '',
		Code : '',
		Desc : '',
		SetCode : '',
		StruModeFlag:''
	});
					
	StkCatGroupGridDs.add(NewRecord);
	StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 1);
}

var SetStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['GX', '西药'], ['GZ', '中成药'], ['GC', '草药']]
});

var SCGSet = new Ext.form.ComboBox({
	fieldLabel : '类型',
	id : 'SCGSet',
	name : 'SCGSet',
	anchor : '90%',
	store : SetStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,	
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addNewRow();
			}
		}
	}
});

var StkCatGroupGrid="";
//配置数据源
var StkCatGroupGridUrl = 'dhcst.stkcatgroupaction.csp';
var StkCatGroupGridProxy= new Ext.data.HttpProxy({url:StkCatGroupGridUrl+'?actiontype=selectAll',method:'GET'});
var StkCatGroupGridDs = new Ext.data.Store({
	proxy:StkCatGroupGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SetCode'},
		{name:'SetDesc'},
		{name:'StruModeFlag'}
	]),
    remoteSort:false
});



//模型
var StkCatGroupGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 2);
					}
				}
			}
        })
    },{
        header:"名称",
        dataIndex:'Desc',
        width:150,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 3);
					}
				}
			}
        })
    },{
        header:"类型",
        dataIndex:'SetCode',
        width:150,
        align:'center',
        sortable:true,
        editor: new Ext.grid.GridEditor(SCGSet),
		renderer: Ext.util.Format.comboRenderer2(SCGSet,'SetCode','SetDesc')
	},StruModeFlag  
]);

//初始化默认排序功能
StkCatGroupGridCm.defaultSortable = true;

var addStkCatGroup = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		addNewRow();
	}
});

var saveStkCatGroup = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		
		if(HospId==""){
			Msg.info("warning","请先选择医院!");
			return false;
		}
		//获取所有的新记录 
		var mr=StkCatGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){ 
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var setCode=mr[i].data["SetCode"].trim();
			var strumodeflag = mr[i].data["StruModeFlag"];
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+setCode+"^"+strumodeflag;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		
		if(data==""){
			Msg.info("warning","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StkCatGroupGridUrl+'?actiontype=save',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
					StkCatGroupGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						StkCatGroupGridDs.load();
					}else{
						Msg.info("error","记录重复"+jsonData.info);
						StkCatGroupGridDs.load();
					}
					StkCatGroupGridDs.commitChanges();
				},
				scope: this
			});
		}
    }
});

var deleteStkCatGroup = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(HospId==""){
			Msg.info("warning","请先选择医院!");
			return false;
		}
		var cell = StkCatGroupGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = StkCatGroupGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkCatGroupGridUrl+'?actiontype=delete&rowid='+RowId,
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
										StkCatGrid.store.removeAll();
										StkCatGrid.getView().refresh();
										StkCatGroupGridDs.load();
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
				Msg.info("warning","数据有误,没有RowId!");
			}
		}
    }
});

//表格
StkCatGroupGrid = new Ext.grid.EditorGridPanel({
	store:StkCatGroupGridDs,
	cm:StkCatGroupGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins: [StruModeFlag],
    tbar:[addStkCatGroup,'-',saveStkCatGroup],		//,'-',deleteStkCatGroup
	clicksToEdit:1
});

StkCatGroupGridDs.load();
//=========================库存组=====================================

//=========================库存小类===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});
function addNewSCRow() {
	var scRecord = Ext.data.Record.create([
		{
			name : 'relationId',
			type : 'int'
		},{
			name : 'catId',
			type : 'int'
		}, {
			name : 'code',
			type : 'string'
		}, {
			name : 'desc',
			type : 'string'
		}
	]);
					
	var NewSCRecord = new scRecord({
		relationId:'',
		catId:'',
		code:'',
		desc:''
	});
		
	StkCatGridDs.add(NewSCRecord);
	StkCatGrid.startEditing(StkCatGridDs.getCount() - 1, 1);
}

var SCG = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'SCG',
	name : 'SCG',
	anchor : '90%',
	width : 120,
	store : IncScStkGrpStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '名称...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	//pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});		
SCG.on('expand', function(combo) {
	SCG.store.removeAll();
	SCG.store.load();	
});				
function rendererSCG(value, p, r) {
	var combo = Ext.getCmp('SCGList');
	var index = SCGStoreList.find(combo.valueField, value);
	var record = SCGStoreList.getAt(index);
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
		
var SCGStoreList = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=G&start=0&limit=999'
	}),
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
		
SCGStoreList.load();
var SCGList = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'SCGList',
	name : 'SCGList',
	anchor : '90%',
	width : 120,
	store : SCGStoreList,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '名称...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : ''
});

var StkCatGrid="";
//配置数据源
var StkCatGridUrl = 'dhcst.stkcatgroupaction.csp';
var StkCatGridProxy= new Ext.data.HttpProxy({url:StkCatGridUrl,method:'GET'});
var StkCatGridDs = new Ext.data.Store({
	proxy:StkCatGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'relationId'},
		{name:'catId'},
		{name:'code'},
		{name:'desc'}
	]),
    remoteSort:true
});



//模型
var StkCatGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
        header:"名称",
        dataIndex:'desc',
        width:300,
        align:'left',
        sortable:true,
		sortable:true,renderer : rendererSCG,
		editor:new Ext.grid.GridEditor(SCG)
    }
]);

//初始化默认排序功能
StkCatGridCm.defaultSortable = true;

var addStkCat = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkCatGroupId!=""){
			addNewSCRow();
		}else{
			Msg.info("warning","请先选择库存类组!");
			return false;
		}
	}
});

var saveStkCat = new Ext.Toolbar.Button({
	text:'保存',
    tooltip:'保存',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录 
		var mr=StkCatGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			if(mr[i].data["desc"].trim()!=""){
				var dataRow = StkCatGroupId+"^"+mr[i].data["desc"].trim();
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data==""){
			Msg.info("error","没有修改或添加新数据!");
			return false;
		}else{
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StkCatGridUrl+'?actiontype=addRelation',
				params: {data:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
					StkCatGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success","添加成功!");
						StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
					}else{
						Msg.info("error",jsonData.info+" 添加失败!");
						StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
					}
					StkCatGridDs.commitChanges();
					IncScStkGrpStore.load();
					SCGStoreList.load();
				},
				scope: this
			});
		}
    }
});

var deleteStkCat = new Ext.Toolbar.Button({
	text:'删除',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = StkCatGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = StkCatGrid.getStore().getAt(cell[0]);
			var RowId = record.get("relationId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkCatGridUrl+'?actiontype=deleteRelation&rowid='+RowId,
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
										StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
										IncScStkGrpStore.load();
										SCGStoreList.load();
									}else{
										Msg.info("error","删除失败!"+jsonData.info);
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("warning","数据有误,没有RowId!");
			}
		}
    }
});

//表格
StkCatGrid = new Ext.grid.EditorGridPanel({
	store:StkCatGridDs,
	cm:StkCatGridCm,
	trackMouseOver:true,
	height:770,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[addStkCat,'-',saveStkCat,'-',deleteStkCat]
});
//=========================库存小类===================================

//===========库存组与库存小类二级联动=================================
StkCatGroupGrid.on('rowclick',function(grid,rowIndex,e){
	//单击库存组刷新库存小类记录
	var selectedRow = StkCatGroupGridDs.data.items[rowIndex];
	StkCatGroupId = selectedRow.data["RowId"];
	StkCatGridDs.proxy = new Ext.data.HttpProxy({url:StkCatGridUrl+'?actiontype=selectStkCatBySCG',method:'GET'});
	StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
});

var HospPanel = InitHospCombo('DHC_StkCatGroup',function(combo, record, index){
	HospId = this.value; 
	StkCatGridDs.reload();
	StkCatGroupGridDs.reload();
	IncScStkGrpStore.reload();
	SCGStoreList.reload();
	
});
//===========库存组与库存小类二级联动=================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var StkCatGroupPanel = new Ext.Panel({
		id:"StkCatGroupPanel",
		title:'库存类组维护',
		activeTab: 0,
		region:'center',
		region:'west',
		width:600,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 600,
		items:[StkCatGroupGrid]                                 
	});
	
	var StkCatPanel = new Ext.Panel({
		id:"StkCatPanel",
		title:'库存分类',
		activeTab: 0,
		region:'center',
		width:1200,
		items:[StkCatGrid]                                 
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items:[HospPanel,StkCatGroupPanel,StkCatPanel],
		renderTo: 'mainPanel'
	});
	
});
//===========模块主页面===============================================