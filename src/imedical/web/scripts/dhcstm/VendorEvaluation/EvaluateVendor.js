//���۹�Ӧ��
var Url = 'dhcstm.vendorindexaction.csp';
evaluateWin = function (ingr) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var Confirm = new Ext.Button({
			id: 'Confirm',
			name: 'Confirm',
			text: '����',
			iconCls : 'page_save',
			handler: function () {
				if (VenEvaIndexGrid.activeEditor != null) {
					VenEvaIndexGrid.activeEditor.completeEdit();
				}
				var List = "";
				var rowCount = VenEvaIndexGrid.getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = VenEvaIndexGrid.getAt(i);
						var RowId = rowData.get("RowId");
						var Index = rowData.get("Index");
						var Score = rowData.get("Score");
						if (Score == null || Score == "") {
							Score = 0;
						}
						var Remark = rowData.get("Remark");
						var nowDate = new Date().format(ARG_DATEFORMAT);
						var ReasonDR = rowData.get("ReasonDR");
						var str = RowId + "^" + Index + "^" + Score + "^" + Remark + "^" + nowDate + "^" + ReasonDR;
						if (List == "") {
							List = str;
						} else {
							List = List + RowDelim + str;
						}
				}
				if (List == "") {
					Msg.info("error", "û��������Ҫ����!");
					return false;
				}
				var url = Url + "?actiontype=SaveByIngr";
				Ext.Ajax.request({
					url: url,
					method: 'POST',
					params: {
						Ingr: ingr,
						List: List
					},
					waitMsg: '������...',
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "����ɹ�!");
							VenEvaIndexGrid.load();
						} else {
							var ret = jsonData.info;
							Msg.info("error", "���۲��ɹ���" + ret);
							loadMask.hide();
						}
					},
					scope: this
				});
			}
		});

	var Submit = new Ext.Button({
			id: 'Submit',
			name: 'Submit',
			text: '�ύ',
			iconCls : 'page_gear',
			handler: function () {
				if (isDataChanged()) {
					Ext.MessageBox.show({
						title: '��ʾ',
						msg: '�Ѿ��Թ�Ӧ�����������޸ģ�����ִ�н���ʧ���޸ģ�������',
						buttons: Ext.Msg.YESNO,
						fn: function (btn) {
							if (btn == 'yes') {
								submitEvaluation();
							}
						}
					})
				} else {
					submitEvaluation();
				}
			}
		});

	function submitEvaluation() {
		Ext.MessageBox.show({
			title: '��ʾ',
			msg: '�Ƿ�ȷ���ύ,�ύ�󲻿��޸�!',
			buttons: Ext.MessageBox.YESNO,
			fn: function (btn) {
				if (btn == "yes") {
					var List = "";
					var rowCount = VenEvaIndexGrid.getCount();
					for (var i = 0; i < rowCount; i++) {
						var rowData = VenEvaIndexGrid.getAt(i);
						var RowId = rowData.get("RowId");
						if (List == "") {
							List = RowId;
						} else {
							List = List + RowDelim + RowId;
						}
					}
					var url = Url + "?actiontype=SubmitEvaluation";
					Ext.Ajax.request({
						url: url,
						method: 'POST',
						params: {
							List: List
						},
						waitMsg: '��ѯ��...',
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "�ύ�ɹ�!");
								isEditable("Y");
							} else {
								var ret = jsonData.info;
								if (ret == -1) {
									Msg.info("error", "�ύʧ��!");
								} else {
									Msg.info("error", "�ύʧ��!");
								}
							}
						},
						scope: this
					});
				}
			},
			icon: Ext.MessageBox.QUESTION
		});

	}

	function isDataChanged() {
		var changed = false;
		var count1 = VenEvaIndexGrid.getCount();
		if ((IsFormChanged(panel)) && (count1 != 0)) {
			changed = true;
		}
		if (changed)
			return changed;
		var count = VenEvaIndexGrid.getCount();
		for (var index = 0; index < count; index++) {
			var rec = VenEvaIndexGrid.getAt(index);
			if (rec.data.newRecord || rec.dirty) {
				changed = true;
			}
		}
		return changed;
	}

	function isEditable(rr) {
		if (rr == "Y") {
			Submit.setDisabled(true);
			Confirm.setDisabled(true);
			scoreEdit.disable();
			remarkEdit.disable();
			evalReasonEdit.disable();
		} else {
			Submit.setDisabled(false);
			Confirm.setDisabled(false);
			scoreEdit.enable();
			remarkEdit.enable();
			evalReasonEdit.enable();
		}
	}

	var scoreEdit = new Ext.form.NumberField({
			allowBlank: false,
			allowNegative: false,
			maxValue: 5,
			minValue: 0
		});

	var remarkEdit = new Ext.form.TextField({
			allowBlank: true
		});

	var GetEvalReasonStore = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url: Url + '?actiontype=EvalReason'
			}),
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows'
			}, ['Description', 'RowId'])
		});

	var evalReasonEdit = new Ext.ux.form.LovCombo({
			id: 'evalReasonEdit',
			fieldLabel: '�۷���',
			anchor: '90%',
			separator: ',',
			store: GetEvalReasonStore,
			valueField: 'RowId',
			displayField: 'Description',
			triggerAction: 'all',
			mode: 'local',
			onSelect:function(record, index) {
				if(this.fireEvent('beforeselect', this, record, index) !== false){
					record.set(this.checkField, !record.get(this.checkField));
					if(this.store.isFiltered()) {
						this.doQuery(this.allQuery);
					}
					if(record.data[this.valueField] === this.selectAllOn){
						if(record.get(this.checkField)){
							this.selectAll();
						}else{
							this.deselectAll();
						}                
					}else{
						this.setValue(this.getCheckedValue());
					}
					this.fireEvent('select', this, record, index);
					var RowId = this.getCheckedValue();
					var row = VenEvaIndexGrid.getSelectedCell()[0];
					var rowData = VenEvaIndexGrid.getAt(row);
					var evalScore = tkMakeServerCall('web.DHCSTM.DHCVendorEvaluationIndex', 'EvalScoreByReason', RowId);
					rowData.set("Score", evalScore);
				}
			}
		});

	evalReasonEdit.on('beforequery', function (combo) {
		var cell = VenEvaIndexGrid.getSelectedCell();
		var Index = VenEvaIndexGrid.getCell(cell[0], "Index");
		GetEvalReasonStore.removeAll();
		GetEvalReasonStore.load({
			params: {
				Index: Index
			}
		});
	});

	/* evalReasonEdit.on('change', function (field, newValue, oldValue) {
		var row = VenEvaIndexGrid.getSelectedCell()[0];
		var rowData = VenEvaIndexGrid.getAt(row);
		var evalScore = tkMakeServerCall('web.DHCSTM.DHCVendorEvaluationIndex', 'EvalScoreByReason', newValue);		
		rowData.set("Score", evalScore);
	}); */

	var EvalIndexCm = [{
			header: 'RowId',
			dataIndex: 'RowId',
			hidden: true
		}, {
			header: '����ָ��ID',
			dataIndex: 'Index',
			hidden: true
		}, {
			header: '����ָ��',
			dataIndex: 'Desc',
			width: 110,
			align: 'left',
			sortable: true
		}, {
			header: '����',
			dataIndex: 'Score',
			sortable: true,
			editor: scoreEdit
		}, {
			header: '�۷���',
			sortable: false,
			dataIndex: 'ReasonDR',
			width: 150,
			align: 'left',
			valueField: 'ReasonDR',
			displayField: 'ReasonDesc',
			editor: evalReasonEdit,
			renderer: function (value, cellmeta, record) {
				var returnvalue = "";
				if (value == record.json.ReasonDR) {
					returnvalue = record.json.ReasonDesc;
				} else {
					var values = value.split(',');
					for (i = 0; i < values.length; i++) {
						var index = GetEvalReasonStore.find(evalReasonEdit.valueField, values[i]);
						var ehrRecord = GetEvalReasonStore.getAt(index);
						if (ehrRecord) {
							if (returnvalue == "" || returnvalue == null) {
								returnvalue = ehrRecord.get('Description');
							} else {
								returnvalue = returnvalue + "," + ehrRecord.get('Description');
							}
						}
					}
				}
				return returnvalue;
			}
		}, {
			header: '��ע',
			dataIndex: 'Remark',
			width: 100,
			editor: remarkEdit
		}, {
			header: '�ύ״̬',
			dataIndex: 'SubmitFlag',
			hidden: true,
			width: 100
		}, {
			header: '�Ƿ���޸ķ���',
			dataIndex: 'ScoreEdited',
			hidden: true,
			width: 100
		}
	];

	var VenEvaIndexGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'VenEvaIndexGrid',
			region: 'center',
			contentColumns: EvalIndexCm,
			singleSelect: true,
			selectFirst: false,
			actionUrl: Url,
			queryAction: "GetIndexByIngr",
			idProperty: "RowId",
			checkProperty: 'RowId',
			valueParams: {
				ingr: ingr
			},
			showTBar: false,
			listeners: {
				beforeedit: function (e) {
					if (e.field == "Score") {
						if (e.record.get("ScoreEdited") == 'N') {
							e.cancel = true;
						}
					}
				}
			}
		});

	var panel = new Ext.form.FormPanel({
			id: 'panel',
			region: 'center',
			frame: true,
			labelAlign: 'right',
			layout: 'fit',
			items: [VenEvaIndexGrid]
		});

	var window = new Ext.Window({
			title: '���۹�Ӧ��----<font color=blue>ע�⣺����Ϊ�����</font>',
			id: 'window',
			width: 600,
			height: 400,
			modal: true,
			layout: 'border',
			bodyStyle: 'padding:10px;',
			items: [panel],
			buttons: [Confirm, Submit],
			buttonAlign: 'center',
			listeners: {
				'show': function (win) {}
			}
		});

	window.show();

	VenEvaIndexGrid.load({
		callback: function (r, options, success) {
			var sub = VenEvaIndexGrid.getAt(0).get('SubmitFlag');
			if (sub == "" || sub == null) {
				sub = "N"
			}
			isEditable(sub);
		}
	});
}
