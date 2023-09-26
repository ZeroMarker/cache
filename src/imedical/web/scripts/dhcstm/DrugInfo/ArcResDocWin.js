//限制科室使用
function ArcResDocEdit(ArcRowid) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var RestrictDocUrl = 'dhcstm.restrictdocaction.csp';
	var SaveBT = new Ext.ux.Button({
			id: "SaveBT",
			text: '保存',
			tooltip: '点击保存',
			width: 70,
			height: 30,
			iconCls: 'page_save',
			handler: function () {
				Save();
			}
		});
	function Save() {
		var rowCount = MasterGrid.getStore().getCount();
		var ListData = "";
		if (CheckDataBeforeSave() == true) {
			for (var i = 0; i < rowCount; i++) {
				var resDocId = MasterGrid.getAt(i).get("resDocId");
				var resDocRelation = MasterGrid.getAt(i).get("resDocRelation");
				var resDocType = MasterGrid.getAt(i).get("resDocType");
				var resDocOperate = MasterGrid.getAt(i).get("resDocOperate");
				var resDocPointer = MasterGrid.getAt(i).get("resDocPointer");
				if (resDocPointer == "") {
					continue;
				}
				if (ListData == "") {
					ListData = resDocId + "^" + resDocRelation + "^" + resDocType + "^" + resDocOperate + "^" + resDocPointer;
				} else {
					ListData = ListData + "!" + resDocId + "^" + resDocRelation + "^" + resDocType + "^" + resDocOperate + "^" + resDocPointer;
				}
			}
			RestrictDocSave(ArcRowid, ListData);
		}
	}
	function CheckDataBeforeSave() {
		var rowCount = MasterGrid.getCount();
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var pointer = MasterGrid.getAt(i).get("resDocPointer");
			var operate = MasterGrid.getAt(i).get("resDocOperate");
			var resDocType = MasterGrid.getAt(i).get("resDocType");
			var resDocRelation = MasterGrid.getAt(i).get("resDocRelation");
			if ((pointer != "") || (operate != "") || (resDocType != "") || (resDocRelation != "")) {
				if ((pointer == "") || (pointer == null)) {
					Msg.info("warning", "名称不能为空！");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((operate == "") || (operate == null)) {
					Msg.info("warning", "操作不能为空！");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((resDocType == "") || (resDocType == null)) {
					Msg.info("warning", "类型不能为空！");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((resDocRelation == "") || (resDocRelation == null)) {
					Msg.info("warning", "关系不能为空！");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
			}
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var relation_i = MasterGrid.getAt(i).get("resDocRelation"); ;
					var relation_j = MasterGrid.getAt(j).get("resDocRelation"); ;
					var type_i = MasterGrid.getAt(i).get("resDocType"); ;
					var type_j = MasterGrid.getAt(j).get("resDocType"); ;
					var Operate_i = MasterGrid.getAt(i).get("resDocOperate"); ;
					var Operate_j = MasterGrid.getAt(j).get("resDocOperate"); ;
					var Pointer_i = MasterGrid.getAt(i).get("resDocPointer"); ;
					var Pointer_j = MasterGrid.getAt(j).get("resDocPointer"); ;
					var icnt = i + 1;
					var jcnt = j + 1;
					if (relation_i == relation_j && type_i == type_j && Operate_i == Operate_j && Pointer_i == Pointer_j) {
						Msg.info("warning", "第" + icnt + "," + jcnt + "行" + "重复，请重新输入!");
						return false;
					}
				}
			}
		}
		return true;
	}
	function RestrictDocSave(Arcitm, ListData) {
		if(Arcitm==""||ListData==""){
			Msg.info("warning", "保存内容为空");
			return ;
		}
		var url = RestrictDocUrl
			 + '?actiontype=Save';
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				Arcitm: Arcitm,
				ListData: ListData
			},
			waitMsg: '处理中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
					GetRestrictDocInfo();
				} else {
					Msg.info("error", "保存失败:" + jsonData.info);
				}
			},
			scope: this
		});
	}
	function GetRestrictDocInfo() {
		MasterGrid.removeAll();
		MasterGrid.load({
			params: {
				ArcRowid: ArcRowid
			}
		});
	}
	function Delete() {
		var cell = MasterGrid.getSelectionModel().getSelectedCell();
		var record = MasterGrid.getStore().getAt(cell[0]);
		var resDocId = record.get("resDocId");
		if (resDocId == "") {
			MasterGrid.getStore().remove(record);
			MasterGrid.getView().refresh();
			return;
		}
		var url = RestrictDocUrl + '?actiontype=Delete';
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				resDocId: resDocId
			},
			waitMsg: '处理中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");
				} else {
					Msg.info("error", "删除失败:" + jsonData.info);
				}
			},
			scope: this
		});
		GetRestrictDocInfo();
	}
	var resDocRelationStore = new Ext.data.SimpleStore({
			fields: ['RowId', 'Description'],
			data: [['AND', '并且'], ['OR', '或者']]
		});
	var resDocRelationCom = new Ext.form.ComboBox({
			fieldLabel: '关系',
			id: 'resDocRelationCom',
			name: 'resDocRelationCom',
			anchor: '90%',
			store: resDocRelationStore,
			mode: 'local',
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: false,
			triggerAction: 'all'
		});
	var resDocTypeStore = new Ext.data.SimpleStore({
			fields: ['RowId', 'Description'],
			data: [['KS', '科室'], ['ZC', '职称'], ['YS', '医生'], ['JB', '病人级别']]
		});
	var resDocTypeCom = new Ext.form.ComboBox({
			fieldLabel: '类型',
			id: 'resDocTypeCom',
			name: 'resDocTypeCom',
			anchor: '90%',
			store: resDocTypeStore,
			mode: 'local',
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: false,
			triggerAction: 'all',
			listeners: {
				'change': function (c, n, o) {
					resDocPointerStore.removeAll();
					Ext.getCmp("resDocPointerCom").setValue('');
				}
			}
		});
	var resDocOperateStore = new Ext.data.SimpleStore({
			fields: ['RowId', 'Description'],
			data: [['=', '等于'], ['<>', '不等于'], ['>=', '大于等于']]
		});
	var resDocOperateCom = new Ext.form.ComboBox({
			fieldLabel: '操作',
			id: 'resDocOperateCom',
			name: 'resDocOperateCom',
			anchor: '90%',
			store: resDocOperateStore,
			mode: 'local',
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: false,
			triggerAction: 'all'
		});
	var resDocPointerStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url: RestrictDocUrl + '?actiontype=GetResDocPointer'
			}),
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows'
			}, ['Description', 'RowId'])
		});
	var resDocPointerCom = new Ext.ux.ComboBox({
			fieldLabel: '名称',
			id: 'resDocPointerCom',
			name: 'resDocPointerCom',
			anchor: '90%',
			store: resDocPointerStore,
			valueField: 'RowId',
			displayField: 'Description',
			allowBlank: false,
			triggerAction: 'all',
			params: {
				resDocType: 'resDocTypeCom'
			},
			filterName: 'PointerDesc',
			listeners: {
				'beforequery': function (e) {
					resDocPointerStore.removeAll();
				}
			}
		});
	var MasterCm = [{
			header: "RowId",
			dataIndex: 'resDocId',
			width: 10,
			sortable: true,
			hidden: true
		}, {
			header: "关系",
			dataIndex: 'resDocRelation',
			xtype: 'combocolumn',
			valueField: "resDocRelation",
			displayField: "resDocRelationDesc",
			editor: resDocRelationCom,
			width: 100
		}, {
			header: "类型",
			dataIndex: 'resDocType',
			xtype: 'combocolumn',
			valueField: "resDocType",
			displayField: "resDocTypeDesc",
			editor: resDocTypeCom,
			width: 100
		}, {
			header: "操作",
			dataIndex: 'resDocOperate',
			xtype: 'combocolumn',
			valueField: "resDocOperate",
			displayField: "resDocOperateDesc",
			editor: resDocOperateCom,
			width: 100
		}, {
			header: "名称",
			dataIndex: 'resDocPointer',
			xtype: 'combocolumn',
			valueField: "resDocPointer",
			displayField: "resDocPointerDesc",
			editor: resDocPointerCom,
			width: 150
		}
	];
	MasterCm.defaultSortable = true;
	var MasterGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'MasterGrid',
			autoLoadStore: true,
			valueParams: {
				ArcRowid: ArcRowid
			},
			tbar: [SaveBT],
			contentColumns: MasterCm,
			smType: "cell",
			actionUrl: RestrictDocUrl,
			queryAction: "GetResDoc",
			selectFirst: false,
			delRowAction: "Delete",
			delRowParam: "resDocId",
			idProperty: 'resDocId',
			checkProperty: 'resDocPointer',
			paging: false
		});

	var ArcResDocWin = new Ext.Window({
			title: '限制科室使用',
			id: 'ArcResDocWin',
			width: 500,
			height: 500,
			modal: true,
			layout: 'fit',
			items: [MasterGrid]
		});

	ArcResDocWin.show();
}
