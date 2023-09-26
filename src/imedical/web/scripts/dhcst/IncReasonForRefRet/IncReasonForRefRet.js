/**
 * ������ҩԭ��ά��
 */
function addNewRow() {
	var record = Ext.data.Record.create([{
		name: 'RowId',
		type: 'int'
	}, {
		name: 'Desc',
		type: 'string'
	}]);

	var NewRecord = new record({
		RowId: '',
		Desc: ''
	});

	IncReasonForRefRetGridDs.add(NewRecord);
	IncReasonForRefRetGrid.startEditing(IncReasonForRefRetGridDs.getCount() - 1, 1);
}

var IncReasonForRefRetGrid = "";
//��������Դ
var IncReasonForRefRetGridUrl = 'dhcst.increasonforrefretaction.csp';
var IncReasonForRefRetGridProxy = new Ext.data.HttpProxy({
	url: IncReasonForRefRetGridUrl + '?actiontype=query',
	method: 'GET'
});
var IncReasonForRefRetGridDs = new Ext.data.Store({
	proxy: IncReasonForRefRetGridProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results',
		pageSize: 35
	}, [{
			name: 'RowId'
		},
		{
			name: 'Desc'
		}
	]),
	remoteSort: false,
	pruneModifiedRecords: true
});

//ģ��
var IncReasonForRefRetGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: "����",
		dataIndex: 'Desc',
		width: 300,
		align: 'left',
		sortable: true,
		editor: new Ext.form.TextField({
			id: 'descField',
			allowBlank: false,
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();
					}
				}
			}
		})
	}
]);

//��ʼ��Ĭ��������
IncReasonForRefRetGridCm.defaultSortable = true;
var addIncReasonForRefRet = new Ext.Toolbar.Button({
	text: '�½�',
	tooltip: '�½�',
	iconCls: 'page_add',
	width: 70,
	height: 30,
	handler: function () {
		addNewRow();
	}
});

var saveIncReasonForRefRet = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '����',
	iconCls: 'page_save',
	width: 70,
	height: 30,
	handler: function () {
		//��ȡ���е��¼�¼ 
		var mr = IncReasonForRefRetGridDs.getModifiedRecords();
		var data = "";
		for (var i = 0; i < mr.length; i++) {
			var rowId = mr[i].data["RowId"];
			var desc = mr[i].data["Desc"].trim();
			var rowNum = IncReasonForRefRetGridDs.indexOf(mr[i]) + 1;
			if (desc == "") {
				Msg.info("warning", "��" + rowNum + "������Ϊ��!");
				return;
			}
			if (desc != "") {
				var dataRow = rowId + "^" + desc;
				if (data == "") {
					data = dataRow;
				} else {
					data = data + xRowDelim() + dataRow;
				}
			}
		}

		if (data == "") {
			Msg.info("warning", "û���޸Ļ����������!");
			return false;
		} else {
			var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
			Ext.Ajax.request({
				url: IncReasonForRefRetGridUrl + '?actiontype=save',
				params: {
					data: data
				},
				failure: function (result, request) {
					mask.hide();
					Msg.info("error", "������������!");
					IncReasonForRefRetGridDs.commitChanges();
				},
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "����ɹ�!");
					} else {
						if (jsonData.info == -2) {
							Msg.info("warning", "�����ظ�!");
						} else {
							Msg.info("warning", "����ʧ��!");
						}
					}
					IncReasonForRefRetGridDs.commitChanges();
					IncReasonForRefRetGridDs.load();
				},
				scope: this
			});
		}
	}
});


var deleteIncReasonForRefRet = new Ext.Toolbar.Button({
	text: 'ɾ��',
	tooltip: 'ɾ��',
	iconCls: 'page_delete',
	width: 70,
	height: 30,
	handler: function () {
		var cell = IncReasonForRefRetGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "��ѡ������!");
			return false;
		} else {
			var record = IncReasonForRefRetGrid.getStore().getAt(cell[0]);
			var RowId = record.get("RowId");
			if (RowId != "") {
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
					function (btn) {
						if (btn == 'yes') {
							var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
							Ext.Ajax.request({
								url: IncReasonForRefRetGridUrl + '?actiontype=delete&rowid=' + RowId,
								waitMsg: 'ɾ����...',
								failure: function (result, request) {
									mask.hide();
									Msg.info("error", "������������!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									mask.hide();
									if (jsonData.success == 'true') {
										Msg.info("success", "ɾ���ɹ�!");
										IncReasonForRefRetGridDs.remove(record);
										IncReasonForRefRetGrid.getView().refresh();
									} else {
										if (jsonData.info == "-2") {
											Msg.info("warning", "��ԭ���ѱ�ʹ��,�޷�ɾ��!");
										} else {
											Msg.info("error", "ɾ��ʧ��!");
										}
									}
								},
								scope: this
							});
						}
					}
				)
			} else {
				IncReasonForRefRetGridDs.remove(record);
				IncReasonForRefRetGrid.getView().refresh();
			}
		}
	}
});

//���
IncReasonForRefRetGrid = new Ext.grid.EditorGridPanel({
	store: IncReasonForRefRetGridDs,
	cm: IncReasonForRefRetGridCm,
	trackMouseOver: true,
	region: 'center',
	height: 690,
	stripeRows: true,
	sm: new Ext.grid.CellSelectionModel({}),
	loadMask: true,
	tbar: [addIncReasonForRefRet, '-', saveIncReasonForRefRet, '-', deleteIncReasonForRefRet],
	clicksToEdit: 1
});

IncReasonForRefRetGridDs.load();

var HospPanel = InitHospCombo('DHC_StkRefuseRetReason',function(combo, record, index){
	HospId = this.value; 
	IncReasonForRefRetGridDs.reload();
});

//===========ģ����ҳ��=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var panel = new Ext.Panel({
		title: '������ҩԭ��',
		activeTab: 0,
		region: 'center',
		items: [IncReasonForRefRetGrid]
	});

	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items: [HospPanel,panel],
		renderTo: 'mainPanel'
	});
});
//===========ģ����ҳ��=============================================