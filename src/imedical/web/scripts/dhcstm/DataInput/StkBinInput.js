// ��λ�����ݵ���
var StkBinPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '���Ҳ���',
		id: 'StkBinPhaLoc',
		name: 'StkBinPhaLoc',
		width: 150,
		anchor: '90%',
		emptyText: '���Ҳ���...'
	});

var StkBinGrid = new Ext.grid.GridPanel({
		id: 'StkBinGrid',
		tbar: [StkBinPhaLoc, '-', {
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = StkBinGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "û��ѡ����");
						return;
					};
					if (selectedarr.length > 0) {
						StkBinGrid.getStore().remove(selectedarr);
						StkBinGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					StkBinGrid.CheckDataBeforeSave();
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					StkBinGrid.clearData();
				}
			}, '-', {
				text: "����",
				iconCls: 'page_add',
				handler: function () {
					if (StkBinGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "���ڼ�ⲻͨ����������");
						return

					}
					StkBinGrid.Save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
			fields: ['StkBin']
		}),
		columns: [
			new Ext.grid.RowNumberer(), {
				header: "��λ����",
				width: 170,
				sortable: true,
				dataIndex: 'StkBin'
			}
		],
		title: '��λ�����ݵ���',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		CheckDataBeforeSave: function () {
			var ret = 0
				var rowCount = this.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ����Ļ�λ���¼!");
				return;
			}
			for (var i = 0; i < rowCount; i++) {
				var rowData = this.getStore().getAt(i);
				var StkBinCode = rowData.get("StkBin");
				if (StkBinCode == "") {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
			}
			return ret
		},
		Save: function () {
			var listData = "";
			var StkBinPhaLoc = Ext.getCmp('StkBinPhaLoc').getValue();
			if (StkBinPhaLoc == "") {
				Msg.info("warning", "��ѡ����Ҳ���!");
				return;
			}
			//������ϸ
			var rowCount = this.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = this.getStore().getAt(i);
				var StkBinCode = rowData.get("StkBin");
				var data = StkBinCode;
				if (listData == "") {
					listData = data;
				} else {
					listData = listData + xRowDelim() + data;
				}
			}
			if (listData == "") {
				Msg.info("warning", "û����Ҫ�ϴ�������");
				return;
			}
			var mask = ShowLoadMask(Ext.getBody(), "�ϴ������Ժ�...");
			var url = URL + "?actiontype=SaveStkBin";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					stklistData: listData,
					stkLoc: StkBinPhaLoc
				},
				waitMsg: '������...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						var ret = jsonData.info;

						var arr = ret.split("^");
						var commitno = parseInt(arr[0]);
						var successno = parseInt(arr[1]);

						var defaultno = commitno - successno;
						if (commitno == successno) {
							Msg.info("success", "����ɹ�!");
						} else {
							Msg.info("warning", "��" + commitno + "������  " + "����ɹ�" + successno + "����  " + "����ʧ��" + defaultno + "����");
						}
					}
				},
				scope: this
			});
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
