//���ƿ���ʹ��
function ArcResDocEdit(ArcRowid) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var RestrictDocUrl = 'dhcstm.restrictdocaction.csp';
	var SaveBT = new Ext.ux.Button({
			id: "SaveBT",
			text: '����',
			tooltip: '�������',
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
					Msg.info("warning", "���Ʋ���Ϊ�գ�");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((operate == "") || (operate == null)) {
					Msg.info("warning", "��������Ϊ�գ�");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((resDocType == "") || (resDocType == null)) {
					Msg.info("warning", "���Ͳ���Ϊ�գ�");
					var cell = MasterGrid.getSelectionModel()
						.getSelectedCell();
					MasterGrid.getSelectionModel().select(cell[0], 1);
					return false;
				}
				if ((resDocRelation == "") || (resDocRelation == null)) {
					Msg.info("warning", "��ϵ����Ϊ�գ�");
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
						Msg.info("warning", "��" + icnt + "," + jcnt + "��" + "�ظ�������������!");
						return false;
					}
				}
			}
		}
		return true;
	}
	function RestrictDocSave(Arcitm, ListData) {
		if(Arcitm==""||ListData==""){
			Msg.info("warning", "��������Ϊ��");
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
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					GetRestrictDocInfo();
				} else {
					Msg.info("error", "����ʧ��:" + jsonData.info);
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
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");
				} else {
					Msg.info("error", "ɾ��ʧ��:" + jsonData.info);
				}
			},
			scope: this
		});
		GetRestrictDocInfo();
	}
	var resDocRelationStore = new Ext.data.SimpleStore({
			fields: ['RowId', 'Description'],
			data: [['AND', '����'], ['OR', '����']]
		});
	var resDocRelationCom = new Ext.form.ComboBox({
			fieldLabel: '��ϵ',
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
			data: [['KS', '����'], ['ZC', 'ְ��'], ['YS', 'ҽ��'], ['JB', '���˼���']]
		});
	var resDocTypeCom = new Ext.form.ComboBox({
			fieldLabel: '����',
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
			data: [['=', '����'], ['<>', '������'], ['>=', '���ڵ���']]
		});
	var resDocOperateCom = new Ext.form.ComboBox({
			fieldLabel: '����',
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
			fieldLabel: '����',
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
			header: "��ϵ",
			dataIndex: 'resDocRelation',
			xtype: 'combocolumn',
			valueField: "resDocRelation",
			displayField: "resDocRelationDesc",
			editor: resDocRelationCom,
			width: 100
		}, {
			header: "����",
			dataIndex: 'resDocType',
			xtype: 'combocolumn',
			valueField: "resDocType",
			displayField: "resDocTypeDesc",
			editor: resDocTypeCom,
			width: 100
		}, {
			header: "����",
			dataIndex: 'resDocOperate',
			xtype: 'combocolumn',
			valueField: "resDocOperate",
			displayField: "resDocOperateDesc",
			editor: resDocOperateCom,
			width: 100
		}, {
			header: "����",
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
			title: '���ƿ���ʹ��',
			id: 'ArcResDocWin',
			width: 500,
			height: 500,
			modal: true,
			layout: 'fit',
			items: [MasterGrid]
		});

	ArcResDocWin.show();
}
