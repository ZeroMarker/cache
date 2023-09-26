// ע��֤��Ϣ����
var ItmManfCertGrid = new Ext.grid.GridPanel({
		id: 'ItmManfCertGrid',
		tbar: [{
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = ItmManfCertGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "û��ѡ����");
						return;
					};
					if (selectedarr.length > 0) {
						ItmManfCertGrid.getStore().remove(selectedarr);
						ItmManfCertGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					ItmManfCertGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					ItmManfCertGrid.clearData();
				}
			}, '-', {
				text: "����",
				iconCls: 'page_add',
				handler: function () {
					ItmManfCertGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
			fields: [{
					name: 'Code'
				}, {
					name: 'Desc'
				}, {
					name: 'Phmanf'
				}, {
					name: 'CertNo'
				}, {
					name: 'CertNoExpDate'
				}, {
					name: 'CertItmDesc'
				}, {
					name: 'CertDateOfIssue'
				}, {
					name: 'CertExpDateExtended'
				}
			]
		}),
		columns: [new Ext.grid.RowNumberer(), {
				header: '���ʴ���',
				dataIndex: 'Code'
			}, {
				header: '��������',
				dataIndex: 'Desc'
			}, {
				header: '����',
				dataIndex: 'Phmanf'
			}, {
				header: 'ע��֤��',
				dataIndex: 'CertNo'
			}, {
				header: 'ע��֤Ч��',
				dataIndex: 'CertNoExpDate'
			}, {
				header: 'ע��֤����',
				dataIndex: 'CertItmDesc'
			}, {
				header: 'ע��֤��֤����',
				width: 150,
				dataIndex: 'CertDateOfIssue'
			}, {
				header: 'ע��֤�ӳ�Ч�ڱ�־',
				width: 150,
				dataIndex: 'CertExpDateExtended'
			}
		],
		title: 'ע��֤��Ϣ����',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		save: function () {
			var grid = this;
			var listData = "";
			var rowCount = grid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var data = "";
				var Code = rowData.get("Code");
				var Desc = rowData.get("Desc");
				var Phmanf = rowData.get("Phmanf");
				var CertNo = rowData.get("CertNo");
				var CertNoExpDate = rowData.get("CertNoExpDate");
				var CertItmDesc = rowData.get("CertItmDesc");
				var CertDateOfIssue = rowData.get("CertDateOfIssue");
				var CertExpDateExtended = rowData.get("CertExpDateExtended");
				var data = Code + "^" + Desc + "^" + Phmanf + "^" + CertNo + "^" + CertNoExpDate + "^" +
					CertItmDesc + "^" + CertDateOfIssue + "^" + CertExpDateExtended;
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
			var url = URL + "?actiontype=SaveItmManfCert";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData
				},
				waitMsg: '������...',
				success: function (result, request) {
					mask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
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
				failure: function (resp, opts) {
					alert("�����������쳣!!");
				}
			});
		},
		CheckDataBeforeSave: function () {
			var grid = this;
			var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ��������!");
				return;
			}
			var ret = 0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var Desc = rowData.get("Desc");
				if (Ext.isEmpty(Desc)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var codetmp = rowData.get("Code");
				for (var j = 0; j < i; j++) {
					var tmpdata = grid.getStore().getAt(j);
					var repeatcode = tmpdata.get("Code");
					if (repeatcode == codetmp) {
						this.ChangeBgColor(i, "yellow");
						this.ChangeBgColor(j, "yellow");
						ret = ret + 1;
					}
				}
				var findindex = grid.getStore().findExact('Code', codetmp);
				if ((findindex != -1) && (findindex != i)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var Phmanf = rowData.get("Phmanf");
				if (Ext.isEmpty(Phmanf)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var CertNo = rowData.get("CertNo");
				if (Ext.isEmpty(CertNo)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
			}
			return ret;
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
