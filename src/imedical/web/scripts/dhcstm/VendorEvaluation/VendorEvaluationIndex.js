// ����:��Ӧ������ָ��ά��
// ��д����:2016-06-13
var isSysIndexEdit=true;
var VenEvaIndexUrl = 'dhcstm.vendorevaluationindexaction.csp';

var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '��ѯ',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			VenEvaIndexGrid.load();
		}
	});

var addEvalIndex = new Ext.Toolbar.Button({
		text:'�½�',
		tooltip:'�½�',
		iconCls:'page_add',
		width : 70,
		height : 30,
		handler:function(){
			VenEvaIndexGrid.addNewRow();
		}
	});

var saveVenEvaIndex = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {
			if (VenEvaIndexGrid.activeEditor != null) {
				VenEvaIndexGrid.activeEditor.completeEdit();
			}
			var SumWeight = 0;
			var count = VenEvaIndexGrid.getCount();
			for (var index = 0; index < count; index++) {
				var rec = VenEvaIndexGrid.getAt(index);
				var Weight = Number(rec.data['Weight']);
				if (Weight == "" || Weight <= 0 || Weight > 1) {
					Msg.info("warning", "��" + (VenEvaIndexGrid.indexOf(rec) + 1) + "��Ȩ�ر������0С�ڵ���1!");
					return;
				}
				SumWeight = accAdd(SumWeight,Weight);
			}
			if (SumWeight != 1) {
				Msg.info("warning", "Ȩ��֮�ͱ������1!")
				return;
			}
			//��ȡ���е��¼�¼
			var mr = VenEvaIndexGrid.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var rowid = mr[i].get("RowId");
				var code = mr[i].get("Code");
				var desc = mr[i].get("Desc");
				var weight = mr[i].get("Weight");
				var sysIndex = mr[i].get("SysIndex");
				var scoreEdited = mr[i].get("ScoreEdited");
				var CalculationRules = mr[i].get("CalculationRules");
				if (code != "" && desc != "" && weight != "") {
					var dataRow = rowid + "^" + code + "^" + desc + "^" + weight + "^" + sysIndex + "^" + scoreEdited + "^" + CalculationRules;
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
				Ext.Ajax.request({
					url: VenEvaIndexUrl + '?actiontype=save',
					params: {
						data: data
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "����ɹ�!");
							VenEvaIndexGrid.load();
						} else {
							Msg.info("error", "��¼�ظ���" + jsonData.info);
							VenEvaIndexGrid.load();
						}
					},
					scope: this
				});
			}
		}
	});

var deleteVenEvaIndex = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var cell = VenEvaIndexGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "��ѡ������!");
				return false;
			} else {
				var record = VenEvaIndexGrid.getAt(cell[0]);
				var RowId = record.get("RowId");
				if (RowId != "") {
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: VenEvaIndexUrl + '?actiontype=delete&rowid=' + RowId,
								waitMsg: 'ɾ����...',
								failure: function (result, request) {
									Msg.info("error", "������������!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "ɾ���ɹ�!");
										VenEvaIndexGrid.load();
									} else {
										Msg.info("error", "ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					})
				} else {
					Msg.info("warning", "��������,û��RowId!");
				}
			}
		}
	});

var VenEvaIndexGridCm = [{
			header : 'RowId',
			dataIndex : 'RowId',
			hidden : true
		},{
			header: "����",
			dataIndex: 'Code',
			width: 80,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(VenEvaIndexGrid, 'Desc');
							VenEvaIndexGrid.startEditing(VenEvaIndexGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "����",
			dataIndex: 'Desc',
			width: 150,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(VenEvaIndexGrid, 'Weight');
							VenEvaIndexGrid.startEditing(VenEvaIndexGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "Ȩ��",
			dataIndex: 'Weight',
			width: 100,
			align: 'left',
			xtype: 'numbercolumn',
			format: '0.0000',
			sortable: true,
			editor: new Ext.form.NumberField({
				allowBlank: false,
				decimalPrecision: 4,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var weight = field.getValue();
							if (weight == null || weight.length <= 0) {
								Msg.info("warning", "Ȩ�ز���Ϊ��!");
								return;
							}
							if (weight <= 0) {
								Msg.info("warning", "Ȩ�ز���С�ڵ���0!");
								return;
							}
							if (weight > 1) {
								Msg.info("warning", "Ȩ�ز��ܴ���1!");
								return;
							}
							var col = GetColIndex(EvalReasonGrid, 'CalculationRules');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
							
						}
					}
				}
			})
		}, {
			header: 'ϵͳָ��',
			dataIndex: 'SysIndex',
			align: 'center',
			width: 80,
			xtype: 'checkcolumn'
		}, {
			header: '�Ƿ���޸ķ���',
			dataIndex: 'ScoreEdited',
			align: 'center',
			width: 110,
			xtype: 'checkcolumn'
		}, {
			header: "�������",
			dataIndex: 'CalculationRules',
			width: 200,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							VenEvaIndexGrid.addNewRow();
							
						}
					}
				}
			})
		}
	];

var VenEvaIndexGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'VenEvaIndexGrid',
		title: '��Ӧ������ָ��ά��',
		region: 'west',
		width : 650,
		tbar: [SearchBT,'-', addEvalIndex,'-', saveVenEvaIndex,"<font color=blue>ע��Ȩ����Ϊ����0С�ڵ���1����</font>"],
		contentColumns: VenEvaIndexGridCm,
		actionUrl : VenEvaIndexUrl,
		queryAction : "selectAll",
		idProperty : "RowId",
		checkProperty : "Code",
		smType : "row",
		showTBar : false,
		childGrid : ["EvalReasonGrid"],
		smRowSelFn : VenEvaIndexRowSelFn
	});

var addEvalReason = new Ext.Toolbar.Button({
		text:'�½�',
		tooltip:'�½�',
		iconCls:'page_add',
		width : 70,
		height : 30,
		handler:function(){
			var record = VenEvaIndexGrid.getSelectionModel().getSelected();
			var rowId = record.get("RowId");
			if(rowId==null||rowId==""){
				Msg.info("warning", "���ȱ�������ָ��!");
				return false;
			}
			EvalReasonGrid.addNewRow();
		}
	});

var SaveEvalReason = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {
			var record = VenEvaIndexGrid.getSelectionModel().getSelected();
			var VEIrowId = record.get("RowId");
			if(VEIrowId==null||VEIrowId==""){
				Msg.info("warning", "���ȱ�������ָ��!");
				return false;
			}
			if (EvalReasonGrid.activeEditor != null) {
				EvalReasonGrid.activeEditor.completeEdit();
			}
			var SumWeight = 0;
			var count = EvalReasonGrid.getCount();
			for (var index = 0; index < count; index++) {
				var rec = EvalReasonGrid.getAt(index);
				var Weight = Number(rec.data['Weight']);
				if (Weight == "" || Weight <= 0 || Weight > 1) {
					Msg.info("warning", "��" + (EvalReasonGrid.indexOf(rec) + 1) + "��Ȩ�ر������0С�ڵ���1!");
					return;
				}
				SumWeight = accAdd(SumWeight, Weight);
			}
			if (SumWeight != 1) {
				Msg.info("warning", "Ȩ��֮�ͱ������1!")
				return;
			}
			//��ȡ���е��¼�¼
			var mr = EvalReasonGrid.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var rowid = mr[i].get("RowId");
				var code = mr[i].get("Code");
				var desc = mr[i].get("Desc");
				var weight = mr[i].get("Weight");
				if (code != "" && desc != "" && weight != "") {
					var dataRow = rowid + "^" + code + "^" + desc + "^" + weight;
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
				Ext.Ajax.request({
					url: VenEvaIndexUrl + '?actiontype=saveEvalReason',
					params: {
						rowid: VEIrowId,
						data: data
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "����ɹ�!");
							EvalReasonGrid.load({params:{rowid:VEIrowId}});
						} else {
							Msg.info("error", "��¼�ظ���" + jsonData.info);
							EvalReasonGrid.load({params:{rowid:VEIrowId}});
						}
					},
					scope: this
				});
			}
		}
	});

var EvalReasonGridCm = [{
			header : 'RowId',
			dataIndex : 'RowId',
			hidden : true
		},{
			header: "����",
			dataIndex: 'Code',
			width: 80,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(EvalReasonGrid, 'Desc');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "����",
			dataIndex: 'Desc',
			width: 150,
			align: 'left',
			sortable: true,
			editor: new Ext.form.TextField({
				allowBlank: false,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var col = GetColIndex(EvalReasonGrid, 'Weight');
							EvalReasonGrid.startEditing(EvalReasonGrid.getCount() - 1, col);
						}
					}
				}
			})
		}, {
			header: "Ȩ��",
			dataIndex: 'Weight',
			width: 100,
			align: 'left',
			xtype: 'numbercolumn',
			format: '0.0000',
			sortable: true,
			editor: new Ext.form.NumberField({
				allowBlank: false,
				decimalPrecision: 4,
				listeners: {
					specialKey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var weight = field.getValue();
							if (weight == null || weight.length <= 0) {
								Msg.info("warning", "Ȩ�ز���Ϊ��!");
								return;
							}
							if (weight <= 0) {
								Msg.info("warning", "Ȩ�ز���С�ڵ���0!");
								return;
							}
							if (weight > 1) {
								Msg.info("warning", "Ȩ�ز��ܴ���1!");
								return;
							}
							EvalReasonGrid.addNewRow();
						}
					}
				}
			})
		}
	];

var EvalReasonGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'EvalReasonGrid',
		title : '�۷���',
		region : 'center',
		contentColumns : EvalReasonGridCm,
		actionUrl : VenEvaIndexUrl,
		queryAction : "GetEvalReason",
		idProperty : "RowId",
		checkProperty : "Code",
		showTBar : false,
		tbar : [addEvalReason,SaveEvalReason,"<font color=blue>ע��Ȩ����Ϊ����0С�ڵ���1����</font>"]
	});

function VenEvaIndexRowSelFn(grid,rowIndex,r){
	var rowid = r.get('RowId');
	EvalReasonGrid.load({params:{rowid:rowid}});
}
//===========ģ����ҳ��===============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [VenEvaIndexGrid,EvalReasonGrid],
			renderTo: 'mainPanel'
		});
	SearchBT.handler();
});
//===========ģ����ҳ��===============================================
