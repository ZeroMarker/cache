// 调价数据导入
var AdjSpReason = new Ext.ux.ComboBox({
		fieldLabel: '调价原因',
		id: 'AdjSpReason',
		name: 'AdjSpReason',
		width: 150,
		anchor: '90%',
		store: ReasonForAdjSpStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '调价原因...',
		selectOnFocus: true,
		forceSelection: true
	});

var AdjPricePhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '调价部门',
		id: 'AdjPricePhaLoc',
		name: 'AdjPricePhaLoc',
		width: 150,
		anchor: '90%',
		emptyText: '调价部门...'
	});

var AdjPriceGrid = new Ext.grid.GridPanel({
		id: 'AdjPriceGrid',
		tbar: [AdjSpReason, '-', AdjPricePhaLoc, '-', {
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = AdjPriceGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "没有选中行");
						return;
					};
					if (selectedarr.length > 0) {
						AdjPriceGrid.getStore().remove(selectedarr);
						AdjPriceGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "检测数据",
				iconCls: 'page_gear',
				handler: function () {
					AdjPriceGrid.CheckDataBeforeSave()

				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					AdjPriceGrid.clearData();
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {

					if (AdjPriceGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "存在检测不通过的数据行");
						return
					}
					AdjPriceGrid.Save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
			fields: [
				'InciCode',
				'InciDesc',
				'Uom',
				{name:'Rp',type: 'float'},
				{name:'Sp',type: 'float'},
				{name:'PreExeDate'},
				{name:'WarrentNo'},
				{name:'WarrentDate'}
			]
		}),
		columns:[new Ext.grid.RowNumberer(),
			{header: '物资代码', width: 120,dataIndex: 'InciCode'},
			{header: '物资名称', width: 150, dataIndex: 'InciDesc'},
			{header: '调价单位', width: 80, dataIndex: 'Uom'},
			{header: '调后进价', width: 80,xtype: 'numbercolumn', dataIndex: 'Rp'},
			{header: '调后售价', width: 80,xtype: 'numbercolumn', dataIndex: 'Sp'},
			{header: '计划生效日期', width: 100, dataIndex: 'PreExeDate'},
			{header: '物价文件号', width: 150, dataIndex: 'WarrentNo'},
			{header: '物价文件日期', width: 100, dataIndex: 'WarrentDate'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '调价数据导入',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},

		GetMaxSp: function (code) {
			var url = 'dhcstm.datainputaction.csp?actiontype=GetMaxSp&InciCode=' + code;
			var response = ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(response);
			if (jsonData.success == 'true') {
				var info = jsonData.info;
				return info;
			}

		},

		CheckDataBeforeSave: function () {
			var ret = 0
				var emp = 0
				var rowCount = this.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "没有需要导入调价记录!");
				return;
			}
			for (var i = 0; i < rowCount; i++) {
				var rowData = this.getStore().getAt(i);
				emp = emp + 1;
				var InciCode = rowData.get("InciCode");

				if (Ext.isEmpty(InciCode)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var InciDesc = rowData.get("InciDesc");
				var Uom = rowData.get("Uom");
				if (Ext.isEmpty(Uom)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Rp = rowData.get("Rp");
				if (isNaN(Rp)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Sp = rowData.get("Sp");
				if (isNaN(Sp)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}

				if (!(Ext.isEmpty(InciCode))) {
					var maxsp = this.GetMaxSp(InciCode);
					if (!(Ext.isEmpty(maxsp)) && (maxsp < Sp)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
				}

				var PreExeDate = rowData.get("PreExeDate");
				var WarrentNo = rowData.get("WarrentNo");
				var WarrentDate = rowData.get("WarrentDate");

			}

			for (var j = emp + 1; j <= rowCount; j++) {
				this.ChangeBgColor(j, "yellow");
				ret = ret + 1
			}
			return ret;
		},

		Save: function () {
			var listData = "";
			var AdjSpReasonId = Ext.getCmp('AdjSpReason').getValue();
			if (AdjSpReasonId == "") {
				Msg.info("warning", "请选择调价原因!");
				return;
			}
			var AdjPricePhaLoc = Ext.getCmp('AdjPricePhaLoc').getValue();
			if (AdjPricePhaLoc == "") {
				Msg.info("warning", "请选择调价科室!");
				return;
			}
			//保存明细
			var rowCount = this.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = this.getStore().getAt(i);
				var InciCode = rowData.get("InciCode");
				var InciDesc = rowData.get("InciDesc");
				var Uom = rowData.get("Uom");
				var Rp = rowData.get("Rp");
				var Sp = rowData.get("Sp");
				var PreExeDate = rowData.get("PreExeDate");
				var WarrentNo = rowData.get("WarrentNo");
				var WarrentDate = rowData.get("WarrentDate");
				var data = InciCode + "^" + InciDesc + "^" + Uom + "^" + Rp + "^" + Sp + "^" +
					PreExeDate + "^" + WarrentNo + "^" + WarrentDate + "^" + AdjSpReasonId
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
			var url = URL + "?actiontype=SaveAdjPrice";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData,
					Loc: AdjPricePhaLoc,
					User: gUserId
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
