// 名称:库存类组
// 编写日期:2012-05-8
//=========================定义全局变量===============================
var StkCatGroupId = "";
//=========================定义全局变量===============================
//=========================库存组=====================================
//配置数据源
var StkCatGroupGridUrl = 'dhcstm.stkcatgroupaction.csp';
var StkCatGroupGridProxy= new Ext.data.HttpProxy({url:StkCatGroupGridUrl+'?actiontype=selectAll',method:'GET'});
var StkCatGroupGridDs = new Ext.data.Store({
	proxy:StkCatGroupGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'SpReq'},
		{name:'SCGSet'}
	]),
	remoteSort:false
});
var SpReq = new Ext.grid.CheckColumn({
	header:'售价必填项',
	dataIndex:'SpReq',
	width:80,
	sortable:true
});
var SCGSetStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['MM', '医用材料'], ['MO', '后勤材料'], ['MR', '试剂'], ['MF', '固定资产']]
	});

var SCGSet=new Ext.form.ComboBox({
			id:'SCGSet',
			name:'SCGSet',
			anchor : '90%',
			width : 120,
			store: SCGSetStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});

//模型
var StkCatGroupGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:100,
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
						addNewRow();
					}
				}
			}
		})
	},SpReq,
	{
		header:"归类",
		dataIndex:'SCGSet',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(SCGSet),
		editor:new Ext.grid.GridEditor(SCGSet)
	}
]);

// 查询入库单按钮
var SearchBT = new Ext.Toolbar.Button({
	id : "SearchBT",
	text : '查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
		StkCatGroupGridDs.setBaseParam('Type',Other)
		StkCatGroupGridDs.load();
	}
});

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

function addNewRow() {
	var NewRecord = CreateRecordInstance(StkCatGroupGridDs.fields);
	StkCatGroupGridDs.add(NewRecord);
	StkCatGroupGrid.startEditing(StkCatGroupGridDs.getCount() - 1, 1);
}

var saveStkCatGroup = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录
		var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
		var mr=StkCatGroupGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code=mr[i].data["Code"].trim();
			var desc=mr[i].data["Desc"].trim();
			var spreq=mr[i].data["SpReq"].trim();
			var SCGSet=mr[i].data["SCGSet"].trim()
			if(code!="" && desc!=""){
				var dataRow = mr[i].data["RowId"]+"^"+code+"^"+desc+"^"+Other+"^"+spreq+"^"+SCGSet;
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
										if(jsonData.info==-1){
											Msg.info("error","该类组维护了库存分类不能删除!");
										}else{
											Msg.info("error","删除失败!");
										}
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkCatGroupGridDs.remove(record);
				StkCatGroupGrid.getView().refresh();
			}
		}
	}
});
var OtherFlag = new Ext.form.Checkbox({
		boxLabel : '财务类组',
		id : 'OtherFlag',
		name : 'OtherFlag',
		anchor : '90%',
		checked : false,
		listeners:{
			check:function(chk,bool){
				SearchBT.handler()
			}
		}
	});
//表格
var StkCatGroupGrid = new Ext.grid.EditorGridPanel({
	title:'库存类组维护',
	region:'west',
	width:600,
	collapsible: true,
	split: true,
	minSize: 0,
	maxSize: 600,
	id : 'StkCatGroupGrid',
	store:StkCatGroupGridDs,
	cm:StkCatGroupGridCm,
	trackMouseOver:true,
	plugins:[SpReq],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[SearchBT,'-',addStkCatGroup,'-',saveStkCatGroup,'-',OtherFlag],
	listeners :　{
		'rowclick' : function(grid,rowIndex,e){
			//单击库存组刷新库存小类记录
			var selectedRow = StkCatGroupGridDs.data.items[rowIndex];
			StkCatGroupId = selectedRow.data["RowId"];
			StkCatGridDs.proxy = new Ext.data.HttpProxy({url:StkCatGridUrl+'?actiontype=selectStkCatBySCG',method:'GET'});
			StkCatGridDs.load({params:{StkCatGroupId:StkCatGroupId}});
		}
	}
});

//=========================库存组=====================================

//=========================库存小类===================================
var IncScStkGrpStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcstm.stkcatgroupaction.csp?actiontype=INCSCStkGrp&StkType=M&start=0&limit=200'
	}),
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
});

var INCStkCat = new Ext.form.ComboBox({
	fieldLabel : '名称',
	id : 'INCStkCat',
	anchor : '90%',
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
	valueNotFoundText : '',
	listeners:{
		'beforequery':function(e){
			IncScStkGrpStore.removeAll();	//load之前remove原记录，否则容易出错
			var Other=Ext.getCmp('OtherFlag').getValue()==true?"O":"M"
			IncScStkGrpStore.setBaseParam("Type",Other)
			IncScStkGrpStore.load();
		},
		'beforeselect' : function(combo, record, index){
			var Incsc = record.get(this.valueField);
			var FindIndex = StkCatGridDs.findExact('catId', Incsc, 0);
			if(FindIndex != -1){
				Msg.info('warning', '已存在于第' + (FindIndex + 1) + '行!');
				return false;
			}
		}
	}
});

//配置数据源
var StkCatGridUrl = 'dhcstm.stkcatgroupaction.csp';
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
		dataIndex:'catId',
		width:300,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.comboRenderer2(INCStkCat,'catId','desc'),
		editor:new Ext.grid.GridEditor(INCStkCat)
	}
]);

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
			Msg.info("warning","请选择库存组!");
			return false;
		}
	}
});

function addNewSCRow() {
	var NewSCRecord = CreateRecordInstance(StkCatGridDs.fields);
	StkCatGridDs.add(NewSCRecord);
	StkCatGrid.startEditing(StkCatGridDs.getCount() - 1, 1);
}

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
			if(mr[i].data["catId"].trim()!=""){
				var dataRow = StkCatGroupId+"^"+mr[i].data["catId"].trim();
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
				StkCatGridDs.remove(record);
				StkCatGrid.getView().refresh();
			}
		}
	}
});

//表格
var StkCatGrid = new Ext.grid.EditorGridPanel({
	title:'库存分类',
	region:'center',
	id : 'StkCatGrid',
	store:StkCatGridDs,
	cm:StkCatGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addStkCat,'-',saveStkCat,'-',deleteStkCat]
});
//=========================库存小类===================================

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[StkCatGroupGrid,StkCatGrid],
		renderTo: 'mainPanel'
	});
	SearchBT.handler()
});
//===========模块主页面===============================================