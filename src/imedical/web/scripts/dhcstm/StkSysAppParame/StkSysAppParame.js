// 名称:参数设置管理
// 编写日期:2012-06-7
// Modify:zdm,2012-07-10,修改界面布局

var StkSysAppId = "";
var StkSysAppParameId = "";
var GroupId = session['LOGON.GROUPID'];
//区域项目标志(1:区域,其他:非区域)
var gGroupFlag = tkMakeServerCall("web.DHCSTM.Common.AppCommon","GetAppPropValue","DHCSTCOMMONM","GroupFlag","");

var ReSetAppParame = new Ext.Button({
	text : '初始化参数',
	iconCls : 'page_gear',
	//hidden : true,
	width : 70,
	height : 30,
	handler : function(){
		if(!confirm('第一次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
			return;
		}
		if(!confirm('第二次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
			return;
		}
		if(!confirm('最后一次提示: 您正在重置参数, 这会删除之前的所有参数数据, 是否继续?')){
			return;
		}
		
		var result = tkMakeServerCall('web.DHCSTM.Tools.CreateAppPara', 'ReSetParame');
		if(!Ext.isEmpty(result)){
			Msg.info('error', '处理失败:' + result);
		}else{
			Msg.info('success', '重置成功!');
			StkSysAppParameGridDs.reload();
		}
	}
});

var synAppParame = new Ext.Toolbar.Button({
	text:'同步参数',
	tooltip:'同步参数',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateApp","App");
		var synRet = tkMakeServerCall("web.DHCSTM.Tools.CreateAppPara","Prop");
		var synRetArr = synRet.split("^");
		Msg.info("success","遍历"+synRetArr[2]+"个, 新增"+synRetArr[0]+"个, 修改"+synRetArr[1]+"个!");
		StkSysAppParameValueGridDs.removeAll();
		StkSysAppParameGridDs.reload();
	}
});

//配置数据源
var StkSysAppGridUrl = 'dhcstm.stksysappaction.csp';
var StkSysAppGridDs = new Ext.data.JsonStore({
	url : StkSysAppGridUrl+'?actiontype=selectAll',
	totalProperty : 'results',
	root:'rows',
	fields : ['RowId','Code','Desc','Type']
});

//模型
var StkSysAppGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"代码",
		dataIndex:'Code',
		width:170,
		align:'left',
		sortable:true
	},{
		header:"名称",
		dataIndex:'Desc',
		width:120,
		align:'left',
		sortable:true
	}
]);

//表格
var StkSysAppGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppGrid',
	store:StkSysAppGridDs,
	cm:StkSysAppGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm,rowIndex,r){
				StkSysAppId = r.get("RowId");
				StkSysAppParameGridDs.load({params:{StkSysAppId:StkSysAppId}});
				StkSysAppParameValueGrid.getStore().removeAll();
			}
		}
	}),
	viewConfig : {
		forceFit : true
	},
	loadMask:true,
	tbar : [ReSetAppParame, '-', synAppParame]
});

StkSysAppGridDs.load();
//=========================应用系统设置=================================

//=========================应用系统属性设置=============================
function addNewMXRow() {
	var MXRecord = CreateRecordInstance(StkSysAppParameGridDs.fields);
	StkSysAppParameGridDs.add(MXRecord);
	StkSysAppParameGrid.startEditing(StkSysAppParameGridDs.getCount() - 1, 2);
}

//配置数据源
var StkSysAppParameGridUrl = 'dhcstm.stksysappparameaction.csp';
var StkSysAppParameGridDs = new Ext.data.JsonStore({
	url : StkSysAppParameGridUrl+'?actiontype=selectParame',
	totalProperty : 'results',
	root : 'rows',
	fields : ['RowId','Parref','Code','Desc','Memo','PropValue'],
	pruneModifiedRecords : true,
	listeners : {
		load : function(store,records,options){
			gGroupFlag = tkMakeServerCall("web.DHCSTM.Common.AppCommon","GetAppPropValue","DHCSTCOMMONM","GroupFlag","");
		}
	}
});

//模型
var StkSysAppParameGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"Id",
		dataIndex:'RowId',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"名称",
		dataIndex:'Code',
		width:150,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'nameField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'Desc');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"描述",
		dataIndex:'Desc',
		width:180,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'Memo');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"备注",
		dataIndex:'Memo',
		width:220,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'memoField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var row = StkSysAppParameGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameGrid,'PropValue');
						StkSysAppParameGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"缺省值",
		dataIndex:'PropValue',
		width:80,
		align:'left',
		editor: new Ext.form.TextField({
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewMXRow();
					}
				}
			}
		})
	}
]);

var addStkSysAppParame = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkSysAppId!=""){
			addNewMXRow();
		}else{
			Msg.info("error", "请选择应用系统!");
			return false;
		}
	}
});

var saveStkSysAppParame = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		if(StkSysAppParameGrid.activeEditor != null){
			StkSysAppParameGrid.activeEditor.completeEdit();
		} 
		//获取所有的新记录
		var mr=StkSysAppParameGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var code = mr[i].data["Code"];
			var rowid =mr[i].data["RowId"];
			var desc = mr[i].data["Desc"];
			var memo = mr[i].data["Memo"];
			var propValue = mr[i].data["PropValue"];
			if((code!="")&&(StkSysAppId!="")){
				var dataRow = rowid+"^"+StkSysAppId+"^"+code+"^"+desc+"^"+memo
					+"^"+propValue;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data!=""){
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StkSysAppParameGridUrl+'?actiontype=saveParame',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						data="";
						Msg.info("success", "保存成功!");
						StkSysAppParameGridDs.reload();
					}else{
						if(jsonData.info=="RepRec"){
							data="";
							Msg.info("error", "记录重复!");
						}else{
							data="";
							Msg.info("error", "保存失败!");
						}
					}
				},
				scope: this
			});
		}
		else(Msg.info("error", "没有修改或添加新数据!"));
	}
});

var deleteStkSysAppParame = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	width : 70,
	height : 30,
	iconCls:'page_delete',
	handler:function(){
		var cell = StkSysAppParameGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = StkSysAppParameGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkSysAppParameGridUrl+'?actiontype=deleteParame&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										StkSysAppParameGridDs.load({params:{StkSysAppId:StkSysAppId}});
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkSysAppParameGridDs.remove(record);
				StkSysAppParameGrid.getView().refresh();
			}
		}
	}
});
//表格
var StkSysAppParameGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppParameGrid',
	store:StkSysAppParameGridDs,
	cm:StkSysAppParameGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({
		listeners : {
			cellselect : function(sm,rowIndex,colIndex){
				var selectedRow = StkSysAppParameGridDs.data.items[rowIndex];
				StkSysAppParameId = selectedRow.data["RowId"];
				StkSysAppParameValueGridDs.load({params:{StkSysAppParameId:StkSysAppParameId}});
			}
		}
	}),
	viewConfig : {
		forceFit : true
	},
	loadMask:true,
	tbar:[addStkSysAppParame,'-',saveStkSysAppParame,'-',deleteStkSysAppParame],
	clicksToEdit:1,
	listeners : {
		beforeedit : function(e){
			if(e.field=="Code"){
				if(!Ext.isEmpty(e.record.get("RowId"))){
					e.cancel=true;   //不能修改名称
				}
			}else if(e.field=='PropValue'){
				if(gGroupFlag==1 && !Ext.isEmpty(e.record.get("RowId")) && e.record.get('Code')!='GroupFlag'){
					e.cancel = true;
				}
			}
		}
	}
});
//=========================应用系统属性设置=============================

//=========================应用系统属性值设置===========================
var typeStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["G",'安全组'], ["L",'科室'], ["U",'人员'], ["D",'全院']]
});

var typeField = new Ext.form.ComboBox({
	id:'typeField',
	width:200,
	listWidth:200,
	allowBlank:true,
	store:typeStore,
	value:'', // 默认值""
	valueField:'key',
	displayField:'keyValue',
	emptyText:'',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	mode:'local',
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var PointerStore = new Ext.data.JsonStore({
	url : 'dhcstm.orgutil.csp?actiontype=GetSSPPoint',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
});

var PointerField = new Ext.ux.ComboBox({
	fieldLabel : '类型值',
	id : 'PointerField',
	width : 120,
	store : PointerStore,
	filterName : 'filter',
	valueParams : {Group:GroupId},
	listeners:{
		beforequery : function(e){
			var rowIndex=StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
			var record=StkSysAppParameValueGrid.store.getAt(rowIndex);
			var type=record.get("Type");
			this.store.setBaseParam('Type',type);
		},
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var row = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
				var col = GetColIndex(StkSysAppParameValueGrid,'Value');
				StkSysAppParameValueGrid.startEditing(row, col);
			}
		}
	}
});

var Hosp = new Ext.ux.ComboBox({
	fieldLabel : '医院',
	id : 'Hosp',
	store : HospStore,
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				addRow();
			}
		}
	}
});

function addRow() {
	var MXRec = CreateRecordInstance(StkSysAppParameValueGridDs.fields);
	StkSysAppParameValueGridDs.add(MXRec);
	StkSysAppParameValueGrid.startEditing(StkSysAppParameValueGridDs.getCount() - 1, 1);
}

//配置数据源
var StkSysAppParameValueGridUrl = 'dhcstm.stksysappparameaction.csp';
var StkSysAppParameValueGridDs = new Ext.data.JsonStore({
	url : StkSysAppParameValueGridUrl+'?actiontype=selectParameValue',
	totalProperty : 'results',
	root : 'rows',
	fields : ['ParRef','RowId','Type','TypeName','Pointer',
		'PointerName','Value','HospDr','HospName'],
	pruneModifiedRecords : true
});

//模型
var StkSysAppParameValueGridCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),{
		header:"类型",
		dataIndex:'Type',
		width:120,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(typeField),
		renderer : Ext.util.Format.comboRenderer(typeField)
	},{
		header:"类型值",
		dataIndex:'Pointer',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(PointerField),
		renderer:Ext.util.Format.comboRenderer2(PointerField,'Pointer','PointerName')
	},{
		header:"参数值",
		dataIndex:'Value',
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			id:'valueField',
			allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					var keyCode=e.getKey();
					if(keyCode==e.ENTER){
						var row = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell()[0];
						var col = GetColIndex(StkSysAppParameValueGrid,'HospDr')
						StkSysAppParameValueGrid.startEditing(row, col);
					}
				}
			}
		})
	},{
		header:"医院",
		dataIndex:'HospDr',
		width:300,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(Hosp),
		renderer:Ext.util.Format.comboRenderer2(Hosp,'HospDr','HospName')
	}
]);

var addStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'新建',
	tooltip:'新建',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if(StkSysAppParameId!=""){
			addRow();
		}else{
			Msg.info("error", "请选择参数属性!");
			return false;
		}
	}
});

var saveStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	width : 70,
	height : 30,
	iconCls:'page_save',
	handler:function(){
		//获取所有的新记录
		if(StkSysAppParameValueGrid.activeEditor != null){
			StkSysAppParameValueGrid.activeEditor.completeEdit();
		}
		var mr=StkSysAppParameValueGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var value = mr[i].data["Value"];
			var rowid =mr[i].get('RowId');
			var type = mr[i].data["Type"];
			var pointer = mr[i].data["Pointer"];
			var hosp = mr[i].data["HospDr"];
			if(gGroupFlag!=1 && type=='D'){
				//非区域项目
				Msg.info('warning','非区域项目,不推荐使用"全院"类型,请使用参数缺省值维护!');
				return;
			}
			if(gGroupFlag==1 && hosp==""){
				hosp = session['LOGON.HOSPID'];
				if(Ext.isEmpty(hosp)){
					Msg.info('warning','区域项目,必须设置"医院"!');
					return;
				}
			}
			if((StkSysAppParameId!="")&&(pointer!="")){
				var dataRow = rowid+"^"+StkSysAppParameId+"^"+type+"^"+pointer+"^"+value+"^"+hosp;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
		}
		if(data!=""){
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: StkSysAppParameValueGridUrl+'?actiontype=saveParameValue',
				params: {data:data},
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					mask.hide();
					if (jsonData.success=='true') {
						data="";
						Msg.info("success", "保存成功!");
						StkSysAppParameValueGridDs.reload();
					}else{
						if(jsonData.info=="RepRec"){
							data="";
							Msg.info("error", "记录重复!");
						}else{
							data="";
							Msg.info("error", "保存失败!");
						}
					}
				},
				scope: this
			});
		}
		else{Msg.info("error", "没有修改或添加新数据!")};
	}
});

var deleteStkSysAppParameValue = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	width : 70,
	height : 30,
	iconCls:'page_delete',
	handler:function(){
		var cell = StkSysAppParameValueGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "请选择数据!");
			return false;
		}else{
			var record = StkSysAppParameValueGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:StkSysAppParameValueGridUrl+'?actiontype=deleteParameValue&rowid='+RowId,
								waitMsg:'删除中...',
								failure: function(result, request) {
									mask.hide();
									Msg.info("error", "请检查网络连接!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									mask.hide();
									if (jsonData.success=='true') {
										Msg.info("success", "删除成功!");
										StkSysAppParameValueGridDs.reload();
									}else{
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				StkSysAppParameValueGridDs.remove(record);
				StkSysAppParameValueGrid.getView().refresh();
			}
		}
	}
});

//表格
var StkSysAppParameValueGrid = new Ext.grid.EditorGridPanel({
	id : 'StkSysAppParameValueGrid',
	store:StkSysAppParameValueGridDs,
	cm:StkSysAppParameValueGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:[addStkSysAppParameValue,'-',saveStkSysAppParameValue,'-',deleteStkSysAppParameValue,'-','非区域项目,不需维护"医院". 区域项目"医院"按登陆医院保存.'],
	clicksToEdit:1,
	listeners : {
		beforeedit : function(e){
			if(e.field == 'HospDr' && gGroupFlag==1 && session['LOGON.GROUPDESC']!='Demo Group'){
				e.cancel = true;
			}
		},
		afteredit : function(e){
			if(e.field=='Type'){
				e.record.set('Pointer','');
			}
		}
	}
});
//=========================应用系统属性值设置===========================

//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items : [
			{
				region: 'west',
				collapsible: true,
				title: '应用程序',
				split: true,
				width: 350,
				minSize: 200,
				maxSize: 400,
				margins: '0 5 0 0',
				layout: 'fit',
				items:StkSysAppGrid
			}, {
				region: 'center',
				title: '参数',
				layout: 'fit',
				items: StkSysAppParameGrid
			}, {
				region: 'south',
				split: true,
				height: 250,
				minSize: 100,
				maxSize: 250,
				collapsible: true,
				title: '参数值',
				layout: 'fit',
				items: StkSysAppParameValueGrid
			}
		],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================