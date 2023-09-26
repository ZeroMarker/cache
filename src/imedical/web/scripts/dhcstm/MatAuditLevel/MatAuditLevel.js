// 名称: 业务多级审核维护
// 编写日期: 20190225

//配置数据源
var AuditLevelGridUrl = 'dhcstm.matauditlevelaction.csp';
var AuditLevelGridProxy= new Ext.data.HttpProxy({url:AuditLevelGridUrl+'?actiontype=QueryMatAuditLevel',method:'GET'});
var AuditLevelGridDs = new Ext.data.Store({
	proxy:AuditLevelGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows'
	}, ['RowId','ActiveFlag','Type','Level','SSGroupId','SSGroupDesc','LocdId','Locdesc','SSUserId','SSUserDesc'
	]),
	remoteSort:false
});
var ActiveFlag = new Ext.grid.CheckColumn({
	header:'激活标志',
	dataIndex:'ActiveFlag',
	width:80,
	sortable:true
});
var TypeStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['G', '入库'], ['T', '转移出库'], ['K', '转移入库'], ['R', '退货'], ['D', '报损'], ['A', '调整'], ['Basic', '物资信息']]
	});

var Type=new Ext.form.ComboBox({
			id:'Type',
			name:'Type',
			anchor : '90%',
			width : 120,
			store: TypeStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});
var LevelStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '0'], ['1', '1'], ['2', '2'], ['3', '3'], ['4', '4']]
	});

var Level=new Ext.form.ComboBox({
			id:'Level',
			name:'Level',
			anchor : '90%',
			width : 120,
			store: LevelStore,
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			valueNotFoundText : ''
});

// 安全组
var groupComboStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'dhcstm.orgutil.csp?actiontype=GetGroup',
		storeId: 'groupComboStore',
		root: 'rows',
		totalProperty: "results",
		fields: ['RowId', 'Description']
	});
var DMALSSGroup = new Ext.ux.ComboBox({
	fieldLabel: '安全组',
	id: 'DMALSSGroup',
	name: 'DMALSSGroup',
	width: 50,
	store: groupComboStore,
	filterName: 'FilterDesc',
	valueField: 'RowId',
	displayField: 'Description'
});
//科室
var DMALLoc = new Ext.ux.ComboBox({
	fieldLabel: '科室',
	id: 'DMALLoc',
	name: 'DMALLoc',
	width: 50,
	store: DeptLocStore,
	valueField: 'RowId',
	displayField: 'Description',
	filterName: 'locDesc',
	listeners:{
		select:function()
		{  
		   var cell = AuditLevelGrid.getSelectionModel().getSelectedCell(); 
		   var rowData = AuditLevelGrid.getStore().getAt(cell[0]);
		   rowData.set("SSUserId","");
		   rowData.set("SSUserDesc","");
		} 
	}  
	
}); 
DMALLoc.on('beforequery', function(e) {
	var ctlocdesc=Ext.getCmp("DMALLoc").getRawValue();
	DeptLocStore.removeAll();
	DeptLocStore.setBaseParam('locDesc',ctlocdesc);
	DeptLocStore.load({});	
}); 
//审核人
var DMALSSUser = new Ext.ux.ComboBox({
	fieldLabel: '审核人',
	id: 'DMALSSUser',
	name: 'DMALSSUser',
	width: 50,
	store: DeptUserStore,
	valueField: 'RowId',
	displayField: 'Description',
	filterName: 'SSUserName'
});
DMALSSUser.on('beforequery', function(e) {
	var ctlocid=Ext.getCmp("DMALLoc").getValue();
	var userdesc=Ext.getCmp("DMALSSUser").getRawValue();
	DeptUserStore.removeAll();
	DeptUserStore.setBaseParam('locId',ctlocid);
	DeptUserStore.setBaseParam('name',userdesc);
	DeptUserStore.load({});	
}); 
//模型
var AuditLevelGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	ActiveFlag,
	{
		header:"业务类型",
		dataIndex:'Type',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(Type),
		editor:new Ext.grid.GridEditor(Type)
	},{
		header:"审核级别",
		dataIndex:'Level',
		width:100,
		align:'left',
		sortable:true,
		renderer:Ext.util.Format.comboRenderer(Level),
		editor:new Ext.grid.GridEditor(Level)
	}, {
		header: "安全组",
		dataIndex: "SSGroupId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALSSGroup,"SSGroupId","SSGroupDesc"),
		editor: DMALSSGroup
	}, {
		header: "科室",
		dataIndex: "LocdId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALLoc,"LocdId","Locdesc"),
		editor: DMALLoc
	}, {
		header: "审核人",
		dataIndex: "SSUserId",
		width: 150,
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(DMALSSUser,"SSUserId","SSUserDesc"),
		editor: DMALSSUser
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
		AuditLevelGridDs.load({
				params: {
					start: 0,
					limit: 9999,
					sort: 'RowId',
					dir: 'desc'
				}
			});
	}
});

var addAuditLevel = new Ext.Toolbar.Button({
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
	var NewRecord = CreateRecordInstance(AuditLevelGridDs.fields);
	AuditLevelGridDs.add(NewRecord);
	AuditLevelGrid.startEditing(AuditLevelGridDs.getCount() - 1, 1);
}

var saveAuditLevel = new Ext.Toolbar.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		//获取所有的新记录
		var mr=AuditLevelGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var RowId=mr[i].data["RowId"].trim();
			var Level=mr[i].data["Level"].trim();
			var ActiveFlag=mr[i].data["ActiveFlag"].trim();
			var Type=mr[i].data["Type"].trim();
			var SSGroupId=mr[i].data["SSGroupId"].trim();
			var LocdId=mr[i].data["LocdId"].trim();
			var SSUserId=mr[i].data["SSUserId"].trim();
			if((Type!="" && Level!="")&&((SSGroupId!="")||(LocdId!="")||(SSUserId!=""))){
				var dataRow = RowId+"^"+Type+"^"+Level+"^"+ActiveFlag+"^"+SSGroupId+"^"+LocdId+"^"+SSUserId;
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
				url: AuditLevelGridUrl+'?actiontype=SaveMatAuditLevel',
				params: {dataStr:data},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error","请检查网络连接!");
					AuditLevelGridDs.commitChanges();
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						SearchBT.handler();
					}else{
						Msg.info("error",jsonData.info);
						SearchBT.handler();
					}
					AuditLevelGridDs.commitChanges();
				},
				scope: this
			});
		}
	}
});

var deleteAuditLevel = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = AuditLevelGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择数据!");
			return false;
		}else{
			var record = AuditLevelGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if(RowId!=""){
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
					function(btn) {
						if(btn == 'yes'){
							var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
							Ext.Ajax.request({
								url:AuditLevelGridUrl+'?actiontype=delete&rowid='+RowId,
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
										AuditLevelGridDs.load();
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
				AuditLevelGridDs.remove(record);
				AuditLevelGrid.getView().refresh();
			}
		}
	}
});

//表格
var AuditLevelGrid = new Ext.grid.EditorGridPanel({
	title:'审核等级维护',
	region:'center',
	height:600,
	collapsible: true,
	split: true,
	minSize: 0,
	maxSize: 600,
	id : 'AuditLevelGrid',
	store:AuditLevelGridDs,
	cm:AuditLevelGridCm,
	trackMouseOver:true,
	plugins:[ActiveFlag],
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[SearchBT,'-',addAuditLevel,'-',saveAuditLevel]

});

//===========模块主页面===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout: 'border',
		items:[AuditLevelGrid],
		renderTo: 'mainPanel'
	});
	SearchBT.handler()
});
//===========模块主页面===============================================