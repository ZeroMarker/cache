
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId = session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];

	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel: '����',
			id: 'PhaLoc',
			name: 'PhaLoc',
			anchor: '90%',
			valueNotFoundText: '',
			groupId: gGroupId
		});

	var UCG = new Ext.ux.ComboBox({
			fieldLabel: '����',
			id: 'UCG',
			name: 'UCG',
			store: UStore,
			valueNotFoundText: '',
			valueParams: {
				'locId': PhaLoc.value
			},
			filterName: 'name'
		});

	function addNewRow() {
		var rec = CreateRecordInstance(PurStore.fields);
		PurStore.add(rec);
		var col = GetColIndex(PurGrid, 'UserId');
		PurGrid.startEditing(PurStore.getCount() - 1, col);
	}
	// ��ѯ��ť
	var SearchBT = new Ext.ux.Button({
			text: '��ѯ',
			iconCls: 'page_find',
			handler: function () {
				Query();
			}
		});
	function Query() {
		// ��ѡ����
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (Ext.isEmpty(phaLoc)) {
			Msg.info("warning", "���Ҳ���Ϊ�գ�");
			Ext.getCmp("PhaLoc").focus();
			return;
		}

		PurStore.setBaseParam('Params', phaLoc);
		PurStore.removeAll();
		PurStore.load();
	}

	var AddBT = new Ext.ux.Button({
			text: '�½�',
			iconCls: 'page_add',
			handler: function () {
				addNewRow();
			}
		});
	// ���水ť
	var SaveBT = new Ext.ux.Button({
			id: "SaveBT",
			text: '����',
			iconCls: 'page_save',
			handler: function () {
				// ������ҿ�������Ϣ
				save();
			}
		});

	function save() {
		var ListDetail = "";
		var mr = PurStore.getModifiedRecords();
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		for (var i = 0; i < mr.length; i++) {
			var Rowid = mr[i].data["Rowid"];
			var UserId = mr[i].data["UserId"];
			var StartTime1 = mr[i].data["StartTime1"];
			var EndTime1 = mr[i].data["EndTime1"];
			var StartTime2 = mr[i].data["StartTime2"];
			var EndTime2 = mr[i].data["EndTime2"];
			var StartTime3 = mr[i].data["StartTime3"];
			var EndTime3 = mr[i].data["EndTime3"];
			var Holidays = mr[i].data["Holidays"];
			var dataRow = Rowid + "^" + phaLoc + "^" + UserId + "^" + StartTime1 + "^" + EndTime1 + "^" + StartTime2 + "^" + EndTime2
				 + "^" + StartTime3 + "^" + EndTime3 + "^" + Holidays;
			if (ListDetail == "") {
				ListDetail = dataRow;
			} else {
				ListDetail = ListDetail + xRowDelim() + dataRow;
			}
		}
		var url = DictUrl + "autohandlepurplanaction.csp?actiontype=Save";
		Ext.Ajax.request({
			url: url,
			params: {
				ListDetail: ListDetail
			},
			method: 'POST',
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {

					Msg.info("success", "����ɹ�!");
					// ˢ�½���
					Query();

				} else {
					var ret = jsonData.info;
					Msg.info("error", "����ʧ��!");
				}
			},
			scope: this
		});
	}

	var nm = new Ext.grid.RowNumberer();
	var PurCm = new Ext.grid.ColumnModel([nm, {
					header: "Rowid",
					dataIndex: 'Rowid',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: "����",
					dataIndex: 'UserId',
					width: 80,
					align: 'left',
					sortable: true,
					renderer: Ext.util.Format.comboRenderer2(UCG, "UserId", "UserName"),
					editor: new Ext.grid.GridEditor(UCG)
				}, {
					header: "��ʼʱ��1",
					dataIndex: 'StartTime1',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "����ʱ��1",
					dataIndex: 'EndTime1',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "��ʼʱ��2",
					dataIndex: 'StartTime2',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "����ʱ��2",
					dataIndex: 'EndTime2',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "��ʼʱ��3",
					dataIndex: 'StartTime3',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "����ʱ��3",
					dataIndex: 'EndTime3',
					width: 80,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.TimeField({})
				}, {
					header: "�ڼ���",
					xtype: 'datecolumn',
					dataIndex: 'Holidays',
					width: 100,
					align: 'left',
					sortable: true,
					editor: new Ext.ux.DateField({
						selectOnFocus: true,
						allowBlank: false
					})
				}
			])

		// ����·��
		var DspPhaUrl = DictUrl
		 + 'autohandlepurplanaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
			url: DspPhaUrl,
			method: "POST"
		});
	// ָ���в���
	var fields = ["Rowid", "LocId", "UserId", "UserName", "StartTime1", "EndTime1", "StartTime2", "EndTime2", "StartTime3", "EndTime3", "Holidays"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			fields: fields
		});
	// ���ݼ�
	var PurStore = new Ext.data.Store({
			proxy: proxy,
			pruneModifiedRecords: true,
			reader: reader

		});
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: PurStore,
			pageSize: PageSize,
			displayInfo: true
		});
	var PurGrid = new Ext.ux.EditorGridPanel({
			title: '�ɹ������������',
			id: 'PurGrid',
			cm: PurCm,
			store: PurStore,
			sm: new Ext.grid.CellSelectionModel({}),
			clicksToEdit: 1,
			bbar: StatuTabPagingToolbar,
			tbar: ['����:', "", PhaLoc, '-', SearchBT, '-', SaveBT, '-', AddBT],
			loadMask: true
		});
	// 5.2.ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout: 'fit',
			items: [PurGrid]
		});
})
