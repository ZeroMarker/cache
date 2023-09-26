// 请领信息导入
var ItmRefuserreGrid = new Ext.grid.GridPanel({
		id: 'ItmRefuserreGrid',
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = ItmRefuserreGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						ItmRefuserreGrid.getStore().remove(selectedarr);
						ItmRefuserreGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					ItmRefuserreGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					ItmRefuserreGrid.clearData();
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					ItmRefuserreGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
			fields: [{
					name: 'Code'
				}, {
					name: 'Desc'
				}, {
					name: 'Frloc'
				}, {
					name: 'Toloc'
				}, {
					name: 'StartDate'
				}, {
					name: 'EndDate'
				}, {
					name: 'Remarks'
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
				header: '供应科室',
				dataIndex: 'Frloc'
			}, {
				header: '请领科室',
				dataIndex: 'Toloc'
			}, {
				header: '开始效期',
				dataIndex: 'StartDate'
			}, {
				header: '截止日期',
				dataIndex: 'EndDate'
			}, {
				header: '备注',
				width: 150,
				dataIndex: 'Remarks'
			}
		],
		title: '科室禁止请领导入',
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
				var Frloc = rowData.get("Frloc");
				var Toloc = rowData.get("Toloc");
				var StartDate = rowData.get("StartDate");
				var EndDate = rowData.get("EndDate");
				var Remarks = rowData.get("Remarks");
				var data = Code + "^" + Desc + "^" + Frloc + "^" + Toloc + "^" + StartDate + "^" +
					EndDate + "^" + Remarks
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
			var url = URL + "?actiontype=SaveItmRefuesloc";
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
				var Frloc = rowData.get("Frloc");
				if (Ext.isEmpty(Frloc)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var Toloc = rowData.get("Toloc");
				if (Ext.isEmpty(Toloc)) {
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
