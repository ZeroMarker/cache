///��ֵ����ҵ��ʹ��Ȩ������
///lihui 20170628
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var loginparams = gHospId + "^" + gGroupId + "^" + gLocId + "^" + gUserId;
var PermLocId = "";
var CTLocId = "";
var DHCSTMUrl = "dhcstm.hvusepermissonlocaction.csp";

var OperLoc = new Ext.ux.LocComboBox({
		fieldLabel: 'ִ�п���',
		id: 'OperLoc',
		name: 'OperLoc',
		defaultLoc: ''
	});
var ActiveField = new Ext.grid.CheckColumn({
		header: '�Ƿ񼤻�',
		dataIndex: 'Active',
		width: 100,
		sortable: true
	});
//����Ȩ�����Ӽ�¼
function addNewRowPerMLoc() {
	var record = Ext.data.Record.create([{
					name: 'HUPLrowid',
					type: 'int'
				}, {
					name: 'OperLoc',
					type: 'string'
				}, {
					name: 'StartDate',
					type: 'date'
				}, {
					name: 'StartTime',
					type: 'string'
				}, {
					name: 'EndDate',
					type: 'date'
				}, {
					name: 'EndTime',
					type: 'string'
				}, {
					name: 'Active',
					type: 'string'
				}
			]);

	var NewRecord = new record({
			HUPLrowid: '',
			LocdId: '',
			StartDate: '',
			StartTime: '',
			EndDate: '',
			EndTime: '',
			Active: ''
		});

	PerMLocGridDs.add(NewRecord);
	PerMLocGrid.startEditing(PerMLocGridDs.getCount() - 1, 2);
}
var PerMLocGrid = "";
//��������Դ
var PerMLocGridProxy = new Ext.data.HttpProxy({
		url: DHCSTMUrl + '?actiontype=selectAll',
		method: 'GET'
	});
var PerMLocGridDs = new Ext.data.Store({
		proxy: PerMLocGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows'
		}, ['HUPLrowid', 'LocdId', 'Locdesc', {
					name: 'CreateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'CreateUserDr', 'CreateUser', {
					name: 'UpdateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'UpdateUserDr', 'UpdateUser', {
					name: 'StartDate',
					type: 'date',
					dateFormat: DateFormat
				}, {
					name: 'EndDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'StartTime', 'EndTime', 'Active']),
		pruneModifiedRecords: true,
		remoteSort: false
	});

//ģ��
var PerMLocGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "HUPLrowid",
				dataIndex: 'HUPLrowid',
				saveColIndex: 0,
				hidden: true
			}, {
				header: "ִ�п���",
				dataIndex: "LocdId",
				width: 150,
				xtype: 'combocolumn',
				valueField: "LocdId",
				displayField: "Locdesc",
				editor: OperLoc
			}, {
				header: "��ʼ����",
				dataIndex: 'StartDate',
				width: 100,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editor: new Ext.ux.DateField({
					selectOnFocus: true
				})
			}, {
				header: '��ʼʱ��',
				dataIndex: 'StartTime',
				width: 100,
				sortable: false,
				editor: new Ext.form.TextField({
					regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
					regexText: 'ʱ���ʽ������ȷ��ʽhh:mm:ss',
					width: 120
				})
			}, {
				header: "��ֹ����",
				dataIndex: 'EndDate',
				width: 100,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editor: new Ext.ux.DateField({
					selectOnFocus: true
				})
			}, {
				header: '��ֹʱ��',
				dataIndex: 'EndTime',
				width: 100,
				sortable: false,
				editor: new Ext.form.TextField({
					regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
					regexText: 'ʱ���ʽ������ȷ��ʽhh:mm:ss',
					width: 120
				})
			}, ActiveField
		]);

//���
PerMLocGrid = new Ext.grid.EditorGridPanel({
		id: 'PerMLocGrid',
		store: PerMLocGridDs,
		cm: PerMLocGridCm,
		trackMouseOver: true,
		height: 600,
		plugins: [ActiveField],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		clicksToEdit: 1,
		listeners: {
			'rowclick': function (grid, rowIndex, e) {
				var selectedRow = PerMLocGridDs.data.items[rowIndex];
				PermLocId = selectedRow.data["HUPLrowid"];
				CTLocId = selectedRow.data["LocdId"];
				PerLocUserGridDs.load();
			}
		}

	});

// ��ѯ����Ȩ�޼�¼
var PerMLocSearchBT = new Ext.Toolbar.Button({
		id: "PerMLocSearchBT",
		text: '��ѯ',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			PerMLocGridDs.load();
		}
	});
//�½�����Ȩ�޼�¼
var addPerMLoc = new Ext.Toolbar.Button({
		text: '�½�',
		tooltip: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			addNewRowPerMLoc();
		}
	});
// ����Ȩ�޼�¼grid�任����ɫ
function ChangeBgColor(row, color) {
	PerMLocGrid.getView().getRow(row).style.backgroundColor = color;
}
//�������Ȩ�޼�¼
function SavePerMLoc() {
	if (PerMLocGrid.activeEditor != null) {
		PerMLocGrid.activeEditor.completeEdit();
	}
	var rowCount = PerMLocGrid.getStore().getCount();
	var modRecords = PerMLocGridDs.getModifiedRecords();
	var DataStr = "";
	for (var i = 0; i < rowCount; i++) {
		var rowData = PerMLocGridDs.getAt(i);
		if (rowData.data.newRecord || rowData.dirty) {
			var HUPLrowid = rowData.get("HUPLrowid");
			var LocdId = rowData.get("LocdId");
			var StartDate = Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var StartTime = rowData.get("StartTime");
			var EndDate = Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			var EndTime = rowData.get("EndTime");
			var Active = rowData.get("Active");
			if ((LocdId != "") || (StartDate != "") || (EndDate != "")) {
				if (LocdId == "") {
					Msg.info("warning", "���Ҳ���Ϊ��!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (StartDate == "") {
					Msg.info("warning", "��ʼ���ڲ���Ϊ��!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (EndDate == "") {
					Msg.info("warning", "��ֹ���ڲ���Ϊ��!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (EndDate < StartDate) {
					Msg.info("warning", "��ֹ���ڲ������ڿ�ʼ����");
					ChangeBgColor(i, "yellow");
					return false;
				}
				if ((StartTime != "") && (EndTime != "") && (EndTime < StartTime)) {
					Msg.info("warning", "��ֹʱ�䲻�����ڿ�ʼʱ��");
					ChangeBgColor(i, "yellow");
					return false;
				}
				var ret = tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc", "ExitOverlapped", HUPLrowid, LocdId, StartDate, EndDate);
				if (ret != 0) {
					Msg.info("warning", "��ʼ��ֹ������������¼�ص�!");
					ChangeBgColor(i, "red");
					return false;
				}
				var rowdata = HUPLrowid + "^" + LocdId + "^" + StartDate + "^" + StartTime + "^" + EndDate + "^" + EndTime + "^" + Active;
				if (DataStr == "") {
					DataStr = rowdata;
				} else {
					DataStr = DataStr + xRowDelim() + rowdata;
				}
			}
		}
	}
	if (DataStr == "") {
		Msg.info("warning", "û����Ҫ���������!");
		PerMLocGridDs.load();
		return false;
	} else {
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		var url = DHCSTMUrl + "?actiontype=SavePerMLoc";
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				DataStr: DataStr,
				loginparams: loginparams
			},
			waitMsg: '������...',
			success: function (result, request) {
				var jsondata = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsondata.success == 'true') {
					Msg.info("success", "����ɹ�!");
					PerMLocGridDs.load();
				} else {
					Msg.info("error", "����ʧ��" + jsondata.info);
					//PerMLocGridDs.load();
				}
			},
			scope: this
		});
	}

}
//�������Ȩ�޼�¼
var savePerMLoc = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {

			SavePerMLoc();
		}
	});
//ɾ������Ȩ�޼�¼
function DeletePerMLoc() {
	var cell = PerMLocGrid.getSelectionModel().getSelectedCell();
	if (cell == "") {
		Msg.info("warning", "û��ѡ����Ҫɾ��������!");
		return false;
	} else {
		var record = PerMLocGrid.getStore().getAt(cell[0]);
		var HUPLrowid = record.get("HUPLrowid");
		if (HUPLrowid != "") {
			Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
				function (btn) {
				if (btn == "yes") {
					var durl = DHCSTMUrl + "?actiontype=DeletePerMLoc&HUPLrowid=" + HUPLrowid;
					var mask = ShowLoadMask(Ext.getBody(), "���ݴ��������Ժ�...");
					Ext.Ajax.request({
						url: durl,
						waitMsg: "������...",
						failure: function (result, request) {
							mask.hide();
							Msg.info("error", "������������!");
						},
						success: function (result, request) {
							var jsondata = Ext.util.JSON.decode(result.responseText);
							mask.hide();
							if (jsondata.success == "true") {
								Msg.info("success", "ɾ���ɹ�!");
								PerMLocGrid.store.removeAll();
								PerMLocGrid.getView().refresh();
								PerMLocGridDs.load();
							} else {
								Msg.info("error", "ɾ��ʧ��!");
								PerMLocGridDs.load();
							}
						},
						scope: this
					})
				}
			})
		} else {}
	}

}
//ɾ������Ȩ�޼�¼
var DelPerMLoc = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			DeletePerMLoc();
		}
	});
//---------------------------������Ȩ-----------------------------
//---------------------------��Ա��Ȩ-----------------------------
var UserStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: 'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['Description', 'RowId']),
		listeners: {
			load: function (store) {
				for (var i = 0; i < PerLocUserGridDs.getCount() - 1; i++) {
					var name = PerLocUserGridDs.getAt(i).get("Name");
					store.removeAt(store.find("Description", name));
				}
			}
		}
	});

var LocUser = new Ext.form.ComboBox({
		fieldLabel: '����',
		id: 'LocUser',
		name: 'LocUser',
		anchor: '90%',
		width: 120,
		store: UserStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '����...',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		pageSize: 10,
		listWidth: 250,
		valueNotFoundText: ''
	});

LocUser.on('beforequery', function (e) {
	UserStore.removeAll();
	UserStore.setBaseParam('name', Ext.getCmp('LocUser').getRawValue());
	UserStore.setBaseParam('locId', CTLocId);
	var pageSize = Ext.getCmp('LocUser').pageSize;
	UserStore.load({
		params: {
			start: 0,
			limit: pageSize
		}
	});
});

//��������Դ
var PerLocUserGridProxy = new Ext.data.HttpProxy({
		url: DHCSTMUrl + '?actiontype=QueryPerLocUser',
		method: 'GET'
	});
var PerLocUserGridDs = new Ext.data.Store({
		proxy: PerLocUserGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['HUPLUParref', 'HUPLURowid', 'LocdId', 'UserId', 'Code', 'Name', {
					name: 'CreateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'CreateUserDr', 'CreateUser', {
					name: 'UpdateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'UpdateUserDr', 'UpdateUser', 'Active'
			]),
		pruneModifiedRecords: true,
		remoteSort: false,
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				store.setBaseParam('PermLocId', PermLocId);
			}
		}
	});

var ActiveField = new Ext.grid.CheckColumn({
		header: '�Ƿ�ʹ��',
		dataIndex: 'Active',
		width: 100,
		sortable: true
	});

//ģ��
var PerLocUserGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "HUPLURowid",
				dataIndex: 'HUPLURowid',
				saveColIndex: 0,
				hidden: true
			}, {
				header: "��Ա����",
				dataIndex: 'Code',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'UserId',
				width: 200,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.comboRenderer2(LocUser, "UserId", "Name"),
				editor: new Ext.grid.GridEditor(LocUser)
			}, ActiveField
		]);

var addPerLocUser = new Ext.Toolbar.Button({
		text: '�½�',
		tooltip: '�½�',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			if (PermLocId != "") {
				addRow();
			} else {
				Msg.info("error", "��ѡ�������Ȩ��¼!");
			}
		}
	});

function addRow() {
	var rec = CreateRecordInstance(PerLocUserGridDs.fields);
	PerLocUserGridDs.add(rec);
	var col = GetColIndex(PerLocUserGrid, 'UserId');
	PerLocUserGrid.startEditing(PerLocUserGridDs.getCount() - 1, col);
}

var savePerLocUserGrid = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			//��ȡ���е��¼�¼
			var mr = PerLocUserGridDs.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var HUPLURowid = mr[i].data["HUPLURowid"];
				var userId = mr[i].data["UserId"];
				if (userId == "") {
					continue;
				}
				var active = mr[i].data["Active"];
				var name = mr[i].data["Name"];
				var dataRow = HUPLURowid + "^" + userId + "^" + active + "^" + name;
				if (data == "") {
					data = dataRow;
				} else {
					data = data + xRowDelim() + dataRow;
				}
			}
			if (data == "") {
				Msg.info("error", "û����Ҫ���������!");
				return false;
			} else {
				Ext.Ajax.request({
					url: DHCSTMUrl + '?actiontype=SavePerLocUser',
					params: {
						data: data,
						PermLocId: PermLocId,
						loginparams: loginparams
					},
					failure: function (result, request) {
						Msg.info("error", "������������!");
					},
					success: function (result, request) {
						data = "";
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "����ɹ�!");
							PerLocUserGridDs.reload();
						} else {
							if (jsonData.info == -3) {
								Msg.info("error", "��Ա�ظ�!");
							} else {
								Msg.info("error", "����ʧ��" + jsonData.info);
							}
						}
					},
					scope: this
				});
			}
		}
	});

var deletePerLocUserGrid = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var cell = PerLocUserGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("error", "��ѡ������!");
				return false;
			} else {
				var record = PerLocUserGrid.getStore().getAt(cell[0]);
				var HUPLURowid = record.get("HUPLURowid");
				if (HUPLURowid != "") {
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: DHCSTMUrl + '?actiontype=deletePerLocUser&HUPLURowid=' + HUPLURowid,
								waitMsg: 'ɾ����...',
								failure: function (result, request) {
									Msg.info("error", "������������!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "ɾ���ɹ�!");
										PerLocUserGridDs.reload();
									} else {
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					})
				} else {
					Msg.info("error", "�����д�!");
				}
			}
		}
	});

//���
var PerLocUserGrid = new Ext.grid.EditorGridPanel({
		store: PerLocUserGridDs,
		cm: PerLocUserGridCm,
		trackMouseOver: true,
		height: 370,
		plugins: [ActiveField],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		clicksToEdit: 1,
		tbar: [addPerLocUser, '-', savePerLocUserGrid, '-', deletePerLocUserGrid],
		listeners: {
			beforeedit: function (e) {
				if (e.field == 'UserId' && e.record.get('HUPLURowid') != '') {
					e.cancel = true;
				}
			}
		}
	});

//-----------------------------��Ա��Ȩ-------------------------------

//===========ģ����ҳ��===============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var PerMLocPanel = new Ext.Panel({
			title: '������Ȩ',
			activeTab: 0,
			region: 'center',
			width: 600,
			collapsible: true,
			split: true,
			minSize: 0,
			maxSize: 600,
			tbar: [PerMLocSearchBT, '-', addPerMLoc, '-', savePerMLoc, '-', DelPerMLoc], //,'-',deleteStkCatGroup
			layout: 'fit',
			items: [PerMLocGrid]
		});

	var PerLocUserPanel = new Ext.Panel({
			deferredRender: true,
			title: '��Աά��',
			activeTab: 0,
			region: 'south',
			height: 300,
			layout: 'fit',
			split: true,
			collapsible: true,
			items: [PerLocUserGrid]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [PerMLocPanel, PerLocUserPanel],
			renderTo: 'mainPanel'
		});
	PerMLocSearchBT.handler()
});
//===========ģ����ҳ��===============================================
