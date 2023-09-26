///业务审核等级维护
var DictUrl="dhcst."
var unitsUrl = 'dhcst.stkauditlevelaction.csp';
Ext.onReady(function() {
	
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.QuickTips.init(); // 浮动信息提示
	Ext.Ajax.timeout = 900000;
	var QueryButton = new Ext.Button({
		width: 65,
		id: "QueryBtn",
		text: '查询',
		iconCls: 'page_find',
		listeners: {
			"click": function() {
				QueryAuditLevel();
			}
		}
	}) 
	var SaveButton = new Ext.Button({
		width: 65,
		id: "SaveBtn",
		text: '保存',
		iconCls: 'page_save',
		listeners: {
			"click": function() {
				SaveAuditLevel();
			}
		}
	}) 
	// 增加按钮
	var AddButton = new Ext.Toolbar.Button({
		id: "AddBtn",
		text: '增加',
		tooltip: '点击增加',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		handler: function() { // 判断是否已经有添加行
			var rowCount = StkAuditLevelgrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = StkAuditLevelgridds.data.items[rowCount - 1];
				var data = rowData.get("ActiveFlagId");
				if (data == null || data.length <= 0) {
					Msg.info("warning", "已存在新建行!");
					return;
				}
			}
			addNewRow();
		}
	});
	var DelButton = new Ext.Toolbar.Button({
		id: 'DelBtn',
		text: '删除',
		width: '70',
		height: '30',
		tooltip: '点击删除',
		iconCls: 'page_delete',
		handler: function() {
			DelAuditLevel();
		}
	}); 
	// 启用标识	
	var ActiveFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['Y','启用'],['N','未启用']]
	});
	
	// 启用标识
	var ActiveFlag = new Ext.form.ComboBox({
	    id:'ActiveFlag',
	    listWidth:50,
	    store:ActiveFlagStore,
	    valueField:'RowId',
	    displayField:'Description',
	    triggerAction:'all',
	    mode:'local',
	    selectOnFocus:true,
	    forceSelection:true,
	    editable:true
	})
	// 项目类型	
	var STALTypeStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : DictUrl+'stkauditlevelaction.csp?action=GetSTALType'
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['RowId','Description'])
	});	
 
	// 项目类型 
	var STALType = new Ext.ux.ComboBox({
		fieldLabel: '项目类型',
		id: 'STALType',
		name: 'STALType',
		//anchor : '90%',
		width: 50,
		store: STALTypeStore,
		//valueField : 'TypeId',
		valueField: 'RowId',
		displayField: 'Description'
	}); 

	//项目操作安全级
	var STALSSGroup = new Ext.ux.ComboBox({
		fieldLabel: '项目操作安全级',
		id: 'STALSSGroup',
		name: 'STALSSGroup',
		//anchor : '90%',
		width: 50,
		store: GroupComboStore,
		valueField: 'RowId',
		displayField: 'Description'
	}); 
	STALSSGroup.on('beforequery', function(e) {
		var groupdesc=Ext.getCmp("STALSSGroup").getRawValue();
		GroupComboStore.removeAll();
		GroupComboStore.setBaseParam('FilterDesc',groupdesc);
		GroupComboStore.load({});	
	}); 
	//科室
	var STALItmLoc = new Ext.ux.ComboBox({
		fieldLabel: '科室',
		id: 'STALItmLoc',
		name: 'STALItmLoc',
		//anchor : '90%',
		width: 50,
		store: DeptLocStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'ItmLocName',
		listeners:{
			select:function()
			{  
			   var cell = StkAuditLevelgrid.getSelectionModel().getSelectedCell(); 
			   var rowData = StkAuditLevelgrid.getStore().getAt(cell[0]);
			   rowData.set("SSUserId","");
			   rowData.set("SSUserDesc","");
			} 
		}  
		
	}); 
	STALItmLoc.on('beforequery', function(e) {
		var ctlocdesc=Ext.getCmp("STALItmLoc").getRawValue();
		DeptLocStore.removeAll();
		DeptLocStore.setBaseParam('locDesc',ctlocdesc);
		DeptLocStore.load({});	
	}); 
	//审核人
	var STALSSUser = new Ext.ux.ComboBox({
		fieldLabel: '审核人',
		id: 'STALSSUser',
		name: 'STALSSUser',
		width: 50,
		store: DeptUserStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'SSUserName'
	});
	STALSSUser.on('beforequery', function(e) {
		var ctlocid=Ext.getCmp("STALItmLoc").getValue();
		var userdesc=Ext.getCmp("STALSSUser").getRawValue();
		DeptUserStore.removeAll();
		DeptUserStore.setBaseParam('locId',ctlocid);
		DeptUserStore.setBaseParam('Desc',userdesc);
		DeptUserStore.load({});	
	}); 
	// 访问路径
	var DetailUrl = unitsUrl+'?action=QueryAuditLevel'; // 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	}); 
	// 指定列参数  //"OriginId","OriginDesc"
	var fields = ["STALRowId", "ActiveFlagId", "ActiveFlagDesc", "TypeId", "TypeDesc", "STALItmDesc", "ItmLevel", "SSGroupId", "SSGroupDesc", "ItmLocId", "ItmLocDesc", "SSUserId", "SSUserDesc"]; // 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "StkAuditLevel",
		fields: fields
	}); 
	// 数据集
	var StkAuditLevelgridds = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
	var nm = new Ext.grid.RowNumberer();
	var StkAuditLevelgridcm = new Ext.grid.ColumnModel([nm, {
		header: "RowId",
		dataIndex: 'STALRowId',
		width: 20,
		align: 'left',
		sortable: true,
		hidden: true
	},
	{
		header: "启用标识",
		dataIndex: 'ActiveFlagId',
		width: 70,
		align: 'center',
		sortable: true,
		editor: new Ext.grid.GridEditor(ActiveFlag),
		renderer: Ext.util.Format.comboRenderer2(ActiveFlag, "ActiveFlagId", "ActiveFlagDesc")
	},
	{
		header: '项目类型',
		dataIndex: 'TypeId',
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALType),
		renderer: Ext.util.Format.comboRenderer2(STALType, "TypeId", "TypeDesc")
	},
	{
		header: '项目描述',
		dataIndex: 'STALItmDesc',
		width: 100,
		align: 'left',
		sortable: true,
		hidden:true,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus: true,
			allowBlank: false,
			listeners: {
				specialkey: function(field, e) {

				}
			}
		}))
	},
	{
		header: "项目等级代码",
		dataIndex: 'ItmLevel',
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.form.NumberField  
	},
	{
		header: "安全组",
		dataIndex: 'SSGroupId',
		width: 150,
		align: 'center',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALSSGroup),
		renderer: Ext.util.Format.comboRenderer2(STALSSGroup, "SSGroupId", "SSGroupDesc")
	},

	{
		header: "科室",
		dataIndex: 'ItmLocId',
		width: 180,
		align: 'right',
		sortable: true,
		editor: new Ext.grid.GridEditor(STALItmLoc),
		renderer: Ext.util.Format.comboRenderer2(STALItmLoc, "ItmLocId", "ItmLocDesc")
	},
	{
		header: "审核人",
		dataIndex: 'SSUserId',
		width: 100,
		align: 'right',
		editor: new Ext.grid.GridEditor(STALSSUser),
		renderer: Ext.util.Format.comboRenderer2(STALSSUser, "SSUserId", "SSUserDesc")
	}]); 
	function addNewRow() {
		var record = Ext.data.Record.create([{
			name: 'STALRowId',
			type: 'string'
		},
		{
			name: 'ActiveFlagId',
			type: 'string'
		},
		{
			name: 'TypeId',
			type: 'string'
		},
		{
			name: 'STALItmDesc',
			type: 'string'
		},
		{
			name: 'ItmLevel',
			type: 'string'
		},
		{
			name: 'SSGroupId',
			type: 'string'
		},
		{
			name: 'ItmLocId',
			type: 'string'
		},
		{
			name: 'SSUserId',
			type: 'string'
		}]);
		var NewRecord = new record({
			STALRowId: '',
			ActiveFlagId: '',
			TypeId: '',
			STALItmDesc: '',
			ItmLevel: '',
			SSGroupId: '',
			ItmLocId: '',
			SSUserId: ''
		});
	StkAuditLevelgridds.add(NewRecord); 
	StkAuditLevelgrid.startEditing(StkAuditLevelgridds.getCount() - 1, 2);
	};
	var StkAuditLevelgrid = new Ext.grid.EditorGridPanel({
		id: 'StkAuditLeveltbl',
		title: '业务审核等级维护',
		region: 'center',
		autoScroll: true,//自动生成滚动条
		enableHdMenu: false,
		frame: true,
		height: 690,
		ds: StkAuditLevelgridds,
		cm: StkAuditLevelgridcm,
		stripeRows: true,
		loadMask: true,
		sm: new Ext.grid.CellSelectionModel({}),
		enableColumnMove: false,
		stripeRows: true,
		clicksToEdit: 1,
		tbar: [ AddButton, "-", DelButton, "-", SaveButton],
		trackMouseOver: 'true'
	});
	var HospPanel = InitHospCombo('DHC_StkAuditLevel',function(combo, record, index){
		HospId = this.value; 
		GroupComboStore.removeAll();
		GroupComboStore.reload();
		DeptLocStore.removeAll();
		DeptLocStore.reload();
		QueryAuditLevel();
	});		
	var QueryForm = new Ext.Panel({
		id:"QueryForm",
		region: 'center',
		frame: true,
		items: [StkAuditLevelgrid]
	}) 
	var port = new Ext.Viewport({
		layout: 'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel]
			},QueryForm
		],

		renderTo: 'mainPanel'
	}); 

	
	///-----------------------------------------------------------------
	///查找数据
	function QueryAuditLevel() {
		//StkAuditLevelgridds.removeAll(); 
		StkAuditLevelgridds.load({params:{start:0,limit:30,sort:"",dir:""}});
	}
	function SaveAuditLevel() {
		var ListDetail = ""
		var rowCount = StkAuditLevelgrid.getStore().getCount(); 
		for (var i = 0; i < rowCount; i++) {
			var rowData = StkAuditLevelgridds.getAt(i);
			if (rowData.data.newRecord || rowData.dirty) {
				var STALRowId = rowData.get("STALRowId");
				var ActiveFlagId = rowData.get("ActiveFlagId");
				var TypeId = rowData.get("TypeId");
				var STALItmDesc = rowData.get("STALItmDesc");
				var ItmLevel = rowData.get("ItmLevel");
				var SSGroupId = rowData.get("SSGroupId");
				var StkGrpId ="G";  // rowData.get("StkGrpId");
				var ItmLocId = rowData.get("ItmLocId");
				var SSUserId = rowData.get("SSUserId");
				if ((ActiveFlagId==null)||(ActiveFlagId==""))
				{
					Msg.info("warning", "请维护启用状态!");
					return
				}
				if ((TypeId==null)||(TypeId==""))
				{
					Msg.info("warning", "请维护项目类型!");
					return
				}
				if ((TypeId==null)||(TypeId==""))
				{
					Msg.info("warning", "请维护项目类型!");
					return
				}
				if((TypeId=="Basic")&&((SSUserId=="")||(SSUserId==null))) 
				{
					Msg.info("warning", "项目类型为药品信息时,审核人必填!");
					return	
				}
				if ((SSUserId=="")&&(ItmLocId=="")&&(SSGroupId==""))
				{
					Msg.info("warning", "安全组,科室,审核人不能同时为空!");
					return	
				}
				var str = STALRowId + "^" + ActiveFlagId + "^" + TypeId + "^" + STALItmDesc + "^" + ItmLevel + "^" + SSGroupId + "^" + StkGrpId + "^" + ItmLocId + "^" + SSUserId
				if (ListDetail == "") {
					ListDetail = str;
				} else {
					ListDetail = ListDetail + "!!" + str;
				}
			}
		}
		if (ListDetail == "") {
			Msg.info("Warning", "没有需要保存的明细!");
			return false;
		} 
		///数据库交互
		Ext.Ajax.request({
			url: unitsUrl + '?action=SaveAuditLevel&ListDetail=' + ListDetail,
			failure: function(result, request) {
				Ext.Msg.show({
					title: '错误',
					msg: '请检查网络连接!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) { 
					Msg.info("success", "保存成功!");
					QueryAuditLevel();
				} else if (jsonData.retvalue == -1) {
					Ext.Msg.alert("提示", "数据重复！");
				} else if (jsonData.retvalue == -5) {
					Ext.Msg.alert("提示", "没有需要保存的数据!返回值: " + jsonData.retinfo);
				} else {
					Ext.Msg.alert("提示", "添加失败!返回值: " + jsonData.retinfo);
				}
			},
			scope: this
		});
	}
	function DelAuditLevel() {
		var cell = StkAuditLevelgrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "请选择要删除的记录！");
			return;
		}
		var row = cell[0];
		var record = StkAuditLevelgridds.getAt(row);
		var STALRowid = record.get("STALRowId");
		if (STALRowid == null || STALRowid.length < 1) {
			Msg.info("warning", "所选记录尚未保存，不能删除!");
			return;
		} else {
			Ext.MessageBox.show({
				title: '提示',
				msg: '是否确定删除该记录',
				buttons: Ext.MessageBox.YESNO,
				fn: showResult,
				icon: Ext.MessageBox.QUESTION
			});
		}
		function showResult(btn) {
			if (btn == "yes") { 
				var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
				Ext.Ajax.request({
					url: unitsUrl + '?action=DelAuditLevel&STALRowid=' + STALRowid,
					success: function(response, opts) {
						var jsonData = Ext.util.JSON.decode(response.responseText);
						mask.hide();
						if (jsonData.retvalue == 0) {
							Msg.info("success", "删除成功!");
							QueryAuditLevel();
						} else if (jsonData.retvalue == -1) {
							Msg.info("error", "请选择需删除记录!");
						} else {
							Msg.info("error", "删除失败!");
						}
					}
				});
			}
		}
	}
});