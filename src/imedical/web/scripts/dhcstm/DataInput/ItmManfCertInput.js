// 注册证信息导入
var ItmManfCertGrid = new Ext.grid.GridPanel({
		id: 'ItmManfCertGrid',
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = ItmManfCertGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						ItmManfCertGrid.getStore().remove(selectedarr);
						ItmManfCertGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					ItmManfCertGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					ItmManfCertGrid.clearData();
				}
			}, '-', {
				text: "导入",
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
				header: '物资代码',
				dataIndex: 'Code'
			}, {
				header: '物资名称',
				dataIndex: 'Desc'
			}, {
				header: '厂商',
				dataIndex: 'Phmanf'
			}, {
				header: '注册证号',
				dataIndex: 'CertNo'
			}, {
				header: '注册证效期',
				dataIndex: 'CertNoExpDate'
			}, {
				header: '注册证名称',
				dataIndex: 'CertItmDesc'
			}, {
				header: '注册证发证日期',
				width: 150,
				dataIndex: 'CertDateOfIssue'
			}, {
				header: '注册证延长效期标志',
				width: 150,
				dataIndex: 'CertExpDateExtended'
			}
		],
		title: '注册证信息导入',
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
				Msg.info("warning", "没有需要上传的数据");
				return;
			}
			var mask = ShowLoadMask(Ext.getBody(), "上传中请稍候...");
			var url = URL + "?actiontype=SaveItmManfCert";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData
				},
				waitMsg: '保存中...',
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
							Msg.info("success", "保存成功!");
						} else {
							Msg.info("warning", "共" + commitno + "条数据  " + "导入成功" + successno + "数据  " + "导入失败" + defaultno + "数据");
						}
					}
				},
				failure: function (resp, opts) {
					alert("服务器出现异常!!");
				}
			});
		},
		CheckDataBeforeSave: function () {
			var grid = this;
			var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "没有需要导入数据!");
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
