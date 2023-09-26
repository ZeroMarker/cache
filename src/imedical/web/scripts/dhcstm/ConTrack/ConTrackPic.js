// 名称:合同管理
// 编写日期:2012-05-14
var RowId = '';
var gParam = [];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];

// 类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		name: 'StkGrpType',
		StkType: App_StkTypeCode, //标识类组类型
		LocId: gLocId,
		UserId: gUserId,
		width: 100
	});

function addpic(data) {
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.contrackaction.csp?actiontype=UploadCont&contdata=' + data, ///全局rowid
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '上传供应商资质图片'
		});
	dialog.show();
};
var contracknum = new Ext.form.TextField({
		id: 'contracknum',
		fieldLabel: '合同号',
		allowBlank: true,
		listWidth: 150,
		anchor: '90%',
		selectOnFocus: true

	});
var remark = new Ext.form.TextField({
		id: 'remark',
		fieldLabel: '备注',
		allowBlank: true,
		listWidth: 150,
		anchor: '90%',
		selectOnFocus: true

	});
var VendorCont = new Ext.ux.VendorComboBox({
		id: 'VendorCont',
		name: 'VendorCont',
		anchor: '95%',
		width: 100
	});

var findBT = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			exequery();
		}
	});

function exequery() {
	var contnum = Ext.getCmp("contracknum").getValue();
	var vendid = Ext.getCmp("VendorCont").getValue();
	var remark = Ext.getCmp("remark").getValue();
	var data = contnum + "^" + remark + "^" + vendid;
	VendorUserGridDs.load({
		params: {
			start: 0,
			limit: VendorUserPagingToolbar.pageSize,
			ContrackData: data
		}
	});

}

function rtquery(contnum) {
	var data = contnum;
	VendorUserGridDs.load({
		params: {
			start: 0,
			limit: VendorUserPagingToolbar.pageSize,
			ContrackData: data
		}
	});

}
var addContrackBt = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			CreateEditWin("", rtquery);
		}
	});
var editContrackBt = new Ext.Toolbar.Button({
		text: '编辑',
		tooltip: '编辑',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var rowObj = VendorUserGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				var rowid = rowObj[0].get('RowId');
				CreateEditWin(rowid, rtquery);
				//窗口显示
			}
		}
	});
var ClearBT = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '点击清空',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			Ext.getCmp("contracknum").setValue("");
			Ext.getCmp("remark").setValue("");
			Ext.getCmp("VendorCont").setValue("");
			VendorUserGridDs.removeAll();
			ItmGridDs.removeAll();
			ItmAPCGridDs.removeAll();
		}
	});

var UpLoadBT = new Ext.Toolbar.Button({
		text: '合同图片',
		tooltip: '查看合同图片',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			var rowData = VendorUserGrid.getSelectionModel().getSelected();
			var RowId = rowData.get("RowId");
			if (RowId == "") {
				Msg.info("error", "请选择合同!");
				return;
			}
			var PicStore = new Ext.data.JsonStore({
					url: 'dhcstm.contrackaction.csp?actiontype=GetContProductImage',
					root: 'rows',
					totalProperty: "results",
					fields: ["rowid", "cont", "picsrc", "imgtype"]
				});
			var type = "'product','productmaster'";
			ShowProductImageWindow(PicStore, RowId, type);
		}
	});
var LooKBT = new Ext.Toolbar.Button({
		text: '查看图片',
		tooltip: '查看图片',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			getpic();
		}
	});

function GetPhaOrderInfo(item, group) {

	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
			getDrugList);
	}
}

function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = ItmGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = ItmGrid.getStore().getAt(row);
	var inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	var spec = record.get("Spec");
	rowData.set("InciId", inciDr);
	rowData.set("InciCode", inciCode);
	rowData.set("InciDesc", inciDesc);
	rowData.set("Spec", spec);
	SaveItmCont();

}

var VendorUserGridUrl = 'dhcstm.contrackaction.csp';
var VendorUserGridProxy = new Ext.data.HttpProxy({
		url: VendorUserGridUrl + '?actiontype=querycont',
		method: 'POST'
	});
var VendorUserGridDs = new Ext.data.Store({
		proxy: VendorUserGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			pageSize: 15
		}, [{
					name: 'RowId'
				}, {
					name: 'ContrackNum'
				}, {
					name: 'Remarks'
				}

			]),
		remoteSort: false
	});

//模型
var VendorUserGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'RowId',
				width: 150,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "合同号",
				dataIndex: 'ContrackNum',
				width: 160,
				align: 'left',
				sortable: true
			}, {
				header: "备注",
				dataIndex: 'Remarks',
				width: 150,
				align: 'left',
				sortable: false
			}
		]);
var DeleteDetailBT = new Ext.Toolbar.Button({
		id: 'DeleteDetailBT',
		text: '删除一条',
		tooltip: '点击删除',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			var cell = ItmGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "没有要删除的数据！");
				return;
			}
			var row = cell[0];
			var rowData = ItmGrid.getStore().getAt(row);
			if (rowData == null) {
				Msg.info("warning", "请选择需要删除的物资!");
				return;
			}
			var RowId = rowData.get("RowId");
			if (RowId == "") {
				var cell2 = ItmGrid.getSelectionModel().getSelectedCell();
				if (cell2 == null) {
					Msg.info("warning", "没有选中行!");
					return;
				}
				var row2 = cell2[0];
				var record2 = ItmGrid.getStore().getAt(row2);
				ItmGrid.getStore().remove(record2);
				ItmGrid.getView().refresh();
				return;
			}
			var inci = rowData.get("InciId");
			if (inci == "") {
				Msg.info("warning", "请选择需要删除的物资!");
				return;
			}
			var ListData = RowId + "^" + inci;
			var url = "dhcstm.contrackaction.csp?actiontype=deleteContInci";
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					ContInciRowId: ListData
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON
						.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "删除成功!");
						loadMask.hide();
						ItmGridDs.reload();
					} else {
						Msg.info("warning", "删除失败!");
						loadMask.hide();
						return false;
					}
				},
				scope: this
			});

		}
	});
var AddBT = new Ext.Toolbar.Button({
		id: "AddBT",
		text: '增加一条',
		tooltip: '点击增加',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		handler: function () {
			// 新增一行
			var rowData = VendorUserGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择需要匹配的合同!");
				return;
			}
			var RowId = rowData.get("RowId");
			addNewRow();
		}
	});
function SaveItmCont() {
	// 新增一行
	var rowDataDD = VendorUserGrid.getSelectionModel().getSelected();
	if (rowDataDD == null || rowDataDD == "undefined") {
		Msg.info("warning", "请选择需要绑定的合同号！");
		return;
	}
	var RowId = rowDataDD.get("RowId");
	if (RowId == "" || RowId == null) {
		Msg.info("warning", "请选择需要绑定的合同号！");
		return;
	}
	var rowCount = ItmGrid.getStore().getCount();
	var ListDetail = "";

	for (var i = 0; i < rowCount; i++) {
		var rowData = ItmGridDs.getAt(i);
		//新增或数据发生变化时执行下述操作
		if (rowData.data.newRecord || rowData.dirty) {
			var ConRowId = rowData.get("RowId");
			var IncId = rowData.get("InciId");
			var str = ConRowId + "^" + IncId
				if (ListDetail == "") {
					ListDetail = str;
				} else {
					ListDetail = ListDetail + RowDelim + str;
				}
		}
	}

	if (ListDetail == "") {
		Msg.info("error", "没有内容需要保存!");
		return;
	}
	var url = "dhcstm.contrackaction.csp?actiontype=SaveContComp";
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			ContRowId: RowId,
			ListDetail: ListDetail
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				loadMask.hide();
				Msg.info("success", "保存成功!");
				ItmGridDs.reload();

			} else {
				Msg.info("warning", "保存失败!");
				loadMask.hide();
				return false;
			}
		},
		scope: this
	});
}

function addNewRow() {
	// 判断是否已经有添加行
	var rowCount = ItmGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = ItmGridDs.data.items[rowCount - 1];
		var data = rowData.get("InciId");
		if (data == null || data.length <= 0) {
			var inciIndex = GetColIndex(ItmGrid, "InciCode");
			ItmGrid.startEditing(ItmGridDs.getCount() - 1, inciIndex);
			return;
		}
	}

	var record = Ext.data.Record.create([{
					name: 'RowId',
					type: 'int'
				}, {
					name: 'InciId',
					type: 'string'
				}, {
					name: 'InciCode',
					type: 'string'
				}, {
					name: 'InciDesc',
					type: 'string'
				}, {
					name: 'Spec',
					type: 'string'
				}
			]);
	var NewRecord = new record({
			RowId: '',
			InciId: '',
			InciCode: '',
			InciDesc: '',
			Spec: ''

		});

	ItmGridDs.add(NewRecord);
	var inciIndex = GetColIndex(ItmGrid, "InciDesc");
	ItmGrid.startEditing(ItmGridDs.getCount() - 1, inciIndex);
}

//初始化默认排序功能
var VendorUserPagingToolbar = new Ext.PagingToolbar({
		store: VendorUserGridDs,
		pageSize: 15,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"

	});

VendorUserGridCm.defaultSortable = true;
VendorUserGrid = new Ext.grid.EditorGridPanel({
		store: VendorUserGridDs,
		cm: VendorUserGridCm,
		title: '合同信息',
		trackMouseOver: true,
		region: 'west',
		width: 320,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: false
		}),
		loadMask: true,
		bbar: VendorUserPagingToolbar
	});
VendorUserGrid.getSelectionModel().on('rowselect', function (sm, rowIndex, r) {
	var RowId = VendorUserGridDs.getAt(rowIndex).get("RowId");
	ItmGridDs.load({
		params: {
			start: 0,
			limit: VendorUserPagingToolbar.pageSize,
			Parref: RowId
		}
	});
});

var ItmUrl = 'dhcstm.contrackaction.csp';
var ItmrGridProxy = new Ext.data.HttpProxy({
		url: ItmUrl + '?actiontype=queryitmbycont',
		method: 'POST'
	});
var ItmGridDs = new Ext.data.Store({
		proxy: ItmrGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			pageSize: 35
		}, [{
					name: 'RowId'
				}, {
					name: 'InciId'
				}, {
					name: 'InciCode'
				}, {
					name: 'InciDesc'
				}, {
					name: 'Spec'
				}

			]),
		remoteSort: false
	});

//模型
var ItmGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'RowId',
				width: 150,
				align: 'left',
				sortable: true,
				hidden: true

			}, {
				header: "物资RowId",
				dataIndex: 'InciId',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资代码",
				dataIndex: 'InciCode',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资名称",
				dataIndex: 'InciDesc',
				width: 250,
				align: 'left',
				sortable: true,
				editor: new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus: true,
						allowBlank: false,
						listeners: {
							specialkey: function (field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var rowDataDD = VendorUserGrid.getSelectionModel().getSelected();
									if (rowDataDD == null || rowDataDD == "undefined") {
										Msg.info("warning", "请选择需要绑定的合同号！");
										return;
									}
									var group = Ext.getCmp("StkGrpType").getValue();
									GetPhaOrderInfo(field.getValue(), group);
								}
							}
						}
					}))
			}, {
				header: "规格",
				dataIndex: 'Spec',
				width: 200,
				align: 'left',
				sortable: true
			}
		]);

//初始化默认排序功能
var ItmPagingToolbar = new Ext.PagingToolbar({
		store: ItmGridDs,
		pageSize: 40,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"

	});

ItmGridCm.defaultSortable = true;
ItmGrid = new Ext.grid.EditorGridPanel({
		store: ItmGridDs,
		cm: ItmGridCm,
		title: '物资信息',
		trackMouseOver: true,
		region: 'center',
		tbar: [AddBT, '-', DeleteDetailBT, '-', '类组：', StkGrpType],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		bbar: ItmPagingToolbar

	});

var ItmAPCUrl = 'dhcstm.contrackaction.csp';
var ItmrAPCGridProxy = new Ext.data.HttpProxy({
		url: ItmAPCUrl + '?actiontype=GetContItmByVendor',
		method: 'POST'
	});
var ItmAPCGridDs = new Ext.data.Store({
		proxy: ItmrAPCGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			pageSize: 35
		}, [{
					name: 'PCRowId'
				}, {
					name: 'PCInciId'
				}, {
					name: 'PCInciCode'
				}, {
					name: 'PCInciDesc'
				}, {
					name: 'PCSpec'
				}

			]),
		remoteSort: false
	});

//模型
var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly: true
	});
var ItmAPCGridCm = new Ext.grid.ColumnModel([sm,
			new Ext.grid.RowNumberer(), {
				header: "PCRowId",
				dataIndex: 'PCRowId',
				width: 150,
				align: 'left',
				sortable: true,
				hidden: true

			}, {
				header: "物资RowId",
				dataIndex: 'PCInciId',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资代码",
				dataIndex: 'PCInciCode',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资名称",
				dataIndex: 'PCInciDesc',
				width: 250,
				align: 'left',
				sortable: true
			}, {
				header: "规格",
				dataIndex: 'PCSpec',
				width: 200,
				align: 'left',
				sortable: true
			}
		]);

//初始化默认排序功能
var ItmAPCPagingToolbar = new Ext.PagingToolbar({
		store: ItmAPCGridDs,
		pageSize: 40,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"

	});

ItmAPCGridCm.defaultSortable = true;
var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		name: 'Vendor',
		anchor: '95%',
		width: 100
	});
var PCChooseBT = new Ext.Toolbar.Button({
		id: "PCChooseBT",
		text: '筛选',
		tooltip: '点击筛选',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		handler: function () {
			var Vendor = Ext.getCmp("Vendor").getValue();
			if (Ext.getCmp("Vendor").getRawValue() == "") {
				Vendor = "";
			}
			if (Vendor == "") {
				Msg.info("warning", "请选择筛选条件");
				return;
			}
			var Page = ItmAPCPagingToolbar.pageSize;
			ItmAPCGridDs.setBaseParam("Others", Vendor);
			ItmAPCGridDs.removeAll();

			ItmAPCGridDs.load({
				params: {
					start: ItmAPCPagingToolbar.cursor,
					limit: Page
				}

			});

		}
	});
var PCAddBT = new Ext.Toolbar.Button({
		id: "PCAddBT",
		text: '保存',
		tooltip: '点击保存',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		handler: function () {
			var rowDataDD = VendorUserGrid.getSelectionModel().getSelected();
			if (rowDataDD == null || rowDataDD == "undefined") {
				Msg.info("warning", "请选择需要绑定的合同号！");
				return;
			}
			var RowId = rowDataDD.get("RowId");
			if (RowId == "" || RowId == null) {
				Msg.info("warning", "请选择需要绑定的合同号！");
				return;
			}
			var ListDetail = "";
			var sm = ItmAPCGrid.getSelectionModel();
			var store = ItmAPCGrid.getStore();
			var rowCount = ItmAPCGrid.getStore().getCount();
			var detaildata = "";
			for (var i = 0; i < rowCount; i++) {
				if (sm.isSelected(i)) {
					var rowData = store.getAt(i);
					var ConRowId = rowData.get("PCRowId");
					var IncId = rowData.get("PCInciId");

					var str = ConRowId + "^" + IncId
						if (ListDetail == "") {
							ListDetail = str;
						} else {
							ListDetail = ListDetail + RowDelim + str;
						}
				}
			}

			if (ListDetail == "") {
				Msg.info("error", "没有内容需要保存!");
				return;
			}
			var url = "dhcstm.contrackaction.csp?actiontype=SaveContComp";
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					ContRowId: RowId,
					ListDetail: ListDetail
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON
						.decode(result.responseText);
					if (jsonData.success == 'true') {
						// 刷新界面
						loadMask.hide();
						Msg.info("success", "保存成功!");
						ItmGridDs.reload();

					} else {
						Msg.info("error", "保存失败!");
						loadMask.hide();
						return false;
					}
				},
				scope: this
			});

		}
	});
ItmAPCGrid = new Ext.grid.EditorGridPanel({
		store: ItmAPCGridDs,
		cm: ItmAPCGridCm,
		title: '物资信息',
		tbar: [Vendor, '-', PCChooseBT, '-', PCAddBT],
		trackMouseOver: true,
		region: 'east',
		width: 420,
		stripeRows: true,
		sm: sm,
		loadMask: true,
		bbar: ItmAPCPagingToolbar

	});

var formPanel = new Ext.form.FormPanel({
		labelwidth: 30,
		autoScroll: true,
		labelAlign: 'right',
		frame: true,
		bodyStyle: 'padding:5px;',
		tbar: [findBT, '-', addContrackBt, '-', editContrackBt, '-', ClearBT, '-', UpLoadBT],
		items: [{
				xtype: 'fieldset',
				title: '查询条件',
				autoHeight: true,
				layout: 'column',
				items: [{
						columnWidth: .25,
						layout: 'form',
						items: [contracknum]
					}, {
						columnWidth: .25,
						layout: 'form',
						items: [remark]
					}, {
						columnWidth: .25,
						layout: 'form',
						items: [VendorCont]
					}
				]
			}
		]

	});

//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var panel = new Ext.Panel({
			title: '合同维护',
			region: 'north',
			height: 162,
			layout: 'fit',
			items: [formPanel]
		});

	var mainPanel = new Ext.Viewport({
			layout: 'border',
			items: [panel, VendorUserGrid, ItmGrid, ItmAPCGrid],
			renderTo: 'mainPanel'
		});

});

//===========模块主页面===========================================
