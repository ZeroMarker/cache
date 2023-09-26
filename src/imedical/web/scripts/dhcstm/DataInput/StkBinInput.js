// 货位码数据导入
var StkBinPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '科室部门',
		id: 'StkBinPhaLoc',
		name: 'StkBinPhaLoc',
		width: 150,
		anchor: '90%',
		emptyText: '科室部门...'
	});

var StkBinGrid = new Ext.grid.GridPanel({
		id: 'StkBinGrid',
		tbar: [StkBinPhaLoc, '-', {
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = StkBinGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						StkBinGrid.getStore().remove(selectedarr);
						StkBinGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					StkBinGrid.CheckDataBeforeSave();
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					StkBinGrid.clearData();
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					if (StkBinGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "存在检测不通过的数据行");
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
				header: "货位名称",
				width: 170,
				sortable: true,
				dataIndex: 'StkBin'
			}
		],
		title: '货位码数据导入',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		CheckDataBeforeSave: function () {
			var ret = 0
				var rowCount = this.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "没有需要导入的货位码记录!");
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
				Msg.info("warning", "请选择科室部门!");
				return;
			}
			//保存明细
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
				Msg.info("warning", "没有需要上传的数据");
				return;
			}
			var mask = ShowLoadMask(Ext.getBody(), "上传中请稍候...");
			var url = URL + "?actiontype=SaveStkBin";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					stklistData: listData,
					stkLoc: StkBinPhaLoc
				},
				waitMsg: '保存中...',
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
							Msg.info("success", "保存成功!");
						} else {
							Msg.info("warning", "共" + commitno + "条数据  " + "导入成功" + successno + "数据  " + "导入失败" + defaultno + "数据");
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
