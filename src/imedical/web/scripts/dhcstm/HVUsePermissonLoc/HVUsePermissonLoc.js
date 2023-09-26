///高值紧急业务使用权限配置
///lihui 20170628
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var loginparams = gHospId + "^" + gGroupId + "^" + gLocId + "^" + gUserId;
var PermLocId = "";
var CTLocId = "";
var DHCSTMUrl = "dhcstm.hvusepermissonlocaction.csp";

var OperLoc = new Ext.ux.LocComboBox({
		fieldLabel: '执行科室',
		id: 'OperLoc',
		name: 'OperLoc',
		defaultLoc: ''
	});
var ActiveField = new Ext.grid.CheckColumn({
		header: '是否激活',
		dataIndex: 'Active',
		width: 100,
		sortable: true
	});
//科室权限增加记录
function addNewRowPerMLoc() {
	var record = Ext.data.Record.create([{
					name: 'HUPLrowid',
					type: 'int'
				}, {
					name: 'OperLoc',
					type: 'string'
				}, {
					name: 'StartDate',
					type: 'date'
				}, {
					name: 'StartTime',
					type: 'string'
				}, {
					name: 'EndDate',
					type: 'date'
				}, {
					name: 'EndTime',
					type: 'string'
				}, {
					name: 'Active',
					type: 'string'
				}
			]);

	var NewRecord = new record({
			HUPLrowid: '',
			LocdId: '',
			StartDate: '',
			StartTime: '',
			EndDate: '',
			EndTime: '',
			Active: ''
		});

	PerMLocGridDs.add(NewRecord);
	PerMLocGrid.startEditing(PerMLocGridDs.getCount() - 1, 2);
}
var PerMLocGrid = "";
//配置数据源
var PerMLocGridProxy = new Ext.data.HttpProxy({
		url: DHCSTMUrl + '?actiontype=selectAll',
		method: 'GET'
	});
var PerMLocGridDs = new Ext.data.Store({
		proxy: PerMLocGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows'
		}, ['HUPLrowid', 'LocdId', 'Locdesc', {
					name: 'CreateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'CreateUserDr', 'CreateUser', {
					name: 'UpdateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'UpdateUserDr', 'UpdateUser', {
					name: 'StartDate',
					type: 'date',
					dateFormat: DateFormat
				}, {
					name: 'EndDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'StartTime', 'EndTime', 'Active']),
		pruneModifiedRecords: true,
		remoteSort: false
	});

//模型
var PerMLocGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "HUPLrowid",
				dataIndex: 'HUPLrowid',
				saveColIndex: 0,
				hidden: true
			}, {
				header: "执行科室",
				dataIndex: "LocdId",
				width: 150,
				xtype: 'combocolumn',
				valueField: "LocdId",
				displayField: "Locdesc",
				editor: OperLoc
			}, {
				header: "开始日期",
				dataIndex: 'StartDate',
				width: 100,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editor: new Ext.ux.DateField({
					selectOnFocus: true
				})
			}, {
				header: '开始时间',
				dataIndex: 'StartTime',
				width: 100,
				sortable: false,
				editor: new Ext.form.TextField({
					regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
					regexText: '时间格式错误，正确格式hh:mm:ss',
					width: 120
				})
			}, {
				header: "截止日期",
				dataIndex: 'EndDate',
				width: 100,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editor: new Ext.ux.DateField({
					selectOnFocus: true
				})
			}, {
				header: '截止时间',
				dataIndex: 'EndTime',
				width: 100,
				sortable: false,
				editor: new Ext.form.TextField({
					regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
					regexText: '时间格式错误，正确格式hh:mm:ss',
					width: 120
				})
			}, ActiveField
		]);

//表格
PerMLocGrid = new Ext.grid.EditorGridPanel({
		id: 'PerMLocGrid',
		store: PerMLocGridDs,
		cm: PerMLocGridCm,
		trackMouseOver: true,
		height: 600,
		plugins: [ActiveField],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		clicksToEdit: 1,
		listeners: {
			'rowclick': function (grid, rowIndex, e) {
				var selectedRow = PerMLocGridDs.data.items[rowIndex];
				PermLocId = selectedRow.data["HUPLrowid"];
				CTLocId = selectedRow.data["LocdId"];
				PerLocUserGridDs.load();
			}
		}

	});

// 查询科室权限记录
var PerMLocSearchBT = new Ext.Toolbar.Button({
		id: "PerMLocSearchBT",
		text: '查询',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			PerMLocGridDs.load();
		}
	});
//新建科室权限记录
var addPerMLoc = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			addNewRowPerMLoc();
		}
	});
// 科室权限记录grid变换行颜色
function ChangeBgColor(row, color) {
	PerMLocGrid.getView().getRow(row).style.backgroundColor = color;
}
//保存科室权限记录
function SavePerMLoc() {
	if (PerMLocGrid.activeEditor != null) {
		PerMLocGrid.activeEditor.completeEdit();
	}
	var rowCount = PerMLocGrid.getStore().getCount();
	var modRecords = PerMLocGridDs.getModifiedRecords();
	var DataStr = "";
	for (var i = 0; i < rowCount; i++) {
		var rowData = PerMLocGridDs.getAt(i);
		if (rowData.data.newRecord || rowData.dirty) {
			var HUPLrowid = rowData.get("HUPLrowid");
			var LocdId = rowData.get("LocdId");
			var StartDate = Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var StartTime = rowData.get("StartTime");
			var EndDate = Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			var EndTime = rowData.get("EndTime");
			var Active = rowData.get("Active");
			if ((LocdId != "") || (StartDate != "") || (EndDate != "")) {
				if (LocdId == "") {
					Msg.info("warning", "科室不可为空!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (StartDate == "") {
					Msg.info("warning", "开始日期不可为空!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (EndDate == "") {
					Msg.info("warning", "截止日期不可为空!");
					ChangeBgColor(i, "red");
					return false;
				}
				if (EndDate < StartDate) {
					Msg.info("warning", "截止日期不能早于开始日期");
					ChangeBgColor(i, "yellow");
					return false;
				}
				if ((StartTime != "") && (EndTime != "") && (EndTime < StartTime)) {
					Msg.info("warning", "截止时间不能早于开始时间");
					ChangeBgColor(i, "yellow");
					return false;
				}
				var ret = tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc", "ExitOverlapped", HUPLrowid, LocdId, StartDate, EndDate);
				if (ret != 0) {
					Msg.info("warning", "开始截止日期与其他记录重叠!");
					ChangeBgColor(i, "red");
					return false;
				}
				var rowdata = HUPLrowid + "^" + LocdId + "^" + StartDate + "^" + StartTime + "^" + EndDate + "^" + EndTime + "^" + Active;
				if (DataStr == "") {
					DataStr = rowdata;
				} else {
					DataStr = DataStr + xRowDelim() + rowdata;
				}
			}
		}
	}
	if (DataStr == "") {
		Msg.info("warning", "没有需要保存的数据!");
		PerMLocGridDs.load();
		return false;
	} else {
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍后...");
		var url = DHCSTMUrl + "?actiontype=SavePerMLoc";
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				DataStr: DataStr,
				loginparams: loginparams
			},
			waitMsg: '处理中...',
			success: function (result, request) {
				var jsondata = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if (jsondata.success == 'true') {
					Msg.info("success", "保存成功!");
					PerMLocGridDs.load();
				} else {
					Msg.info("error", "保存失败" + jsondata.info);
					//PerMLocGridDs.load();
				}
			},
			scope: this
		});
	}

}
//保存科室权限记录
var savePerMLoc = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {

			SavePerMLoc();
		}
	});
//删除科室权限记录
function DeletePerMLoc() {
	var cell = PerMLocGrid.getSelectionModel().getSelectedCell();
	if (cell == "") {
		Msg.info("warning", "没有选中需要删除的数据!");
		return false;
	} else {
		var record = PerMLocGrid.getStore().getAt(cell[0]);
		var HUPLrowid = record.get("HUPLrowid");
		if (HUPLrowid != "") {
			Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
				function (btn) {
				if (btn == "yes") {
					var durl = DHCSTMUrl + "?actiontype=DeletePerMLoc&HUPLrowid=" + HUPLrowid;
					var mask = ShowLoadMask(Ext.getBody(), "数据处理中请稍后...");
					Ext.Ajax.request({
						url: durl,
						waitMsg: "处理中...",
						failure: function (result, request) {
							mask.hide();
							Msg.info("error", "请检查网络链接!");
						},
						success: function (result, request) {
							var jsondata = Ext.util.JSON.decode(result.responseText);
							mask.hide();
							if (jsondata.success == "true") {
								Msg.info("success", "删除成功!");
								PerMLocGrid.store.removeAll();
								PerMLocGrid.getView().refresh();
								PerMLocGridDs.load();
							} else {
								Msg.info("error", "删除失败!");
								PerMLocGridDs.load();
							}
						},
						scope: this
					})
				}
			})
		} else {}
	}

}
//删除科室权限记录
var DelPerMLoc = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			DeletePerMLoc();
		}
	});
//---------------------------科室授权-----------------------------
//---------------------------人员授权-----------------------------
var UserStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: 'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['Description', 'RowId']),
		listeners: {
			load: function (store) {
				for (var i = 0; i < PerLocUserGridDs.getCount() - 1; i++) {
					var name = PerLocUserGridDs.getAt(i).get("Name");
					store.removeAt(store.find("Description", name));
				}
			}
		}
	});

var LocUser = new Ext.form.ComboBox({
		fieldLabel: '名称',
		id: 'LocUser',
		name: 'LocUser',
		anchor: '90%',
		width: 120,
		store: UserStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '名称...',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		pageSize: 10,
		listWidth: 250,
		valueNotFoundText: ''
	});

LocUser.on('beforequery', function (e) {
	UserStore.removeAll();
	UserStore.setBaseParam('name', Ext.getCmp('LocUser').getRawValue());
	UserStore.setBaseParam('locId', CTLocId);
	var pageSize = Ext.getCmp('LocUser').pageSize;
	UserStore.load({
		params: {
			start: 0,
			limit: pageSize
		}
	});
});

//配置数据源
var PerLocUserGridProxy = new Ext.data.HttpProxy({
		url: DHCSTMUrl + '?actiontype=QueryPerLocUser',
		method: 'GET'
	});
var PerLocUserGridDs = new Ext.data.Store({
		proxy: PerLocUserGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['HUPLUParref', 'HUPLURowid', 'LocdId', 'UserId', 'Code', 'Name', {
					name: 'CreateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'CreateUserDr', 'CreateUser', {
					name: 'UpdateDate',
					type: 'date',
					dateFormat: DateFormat
				}, 'UpdateUserDr', 'UpdateUser', 'Active'
			]),
		pruneModifiedRecords: true,
		remoteSort: false,
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				store.setBaseParam('PermLocId', PermLocId);
			}
		}
	});

var ActiveField = new Ext.grid.CheckColumn({
		header: '是否使用',
		dataIndex: 'Active',
		width: 100,
		sortable: true
	});

//模型
var PerLocUserGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "HUPLURowid",
				dataIndex: 'HUPLURowid',
				saveColIndex: 0,
				hidden: true
			}, {
				header: "人员工号",
				dataIndex: 'Code',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "姓名",
				dataIndex: 'UserId',
				width: 200,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.comboRenderer2(LocUser, "UserId", "Name"),
				editor: new Ext.grid.GridEditor(LocUser)
			}, ActiveField
		]);

var addPerLocUser = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			if (PermLocId != "") {
				addRow();
			} else {
				Msg.info("error", "请选择科室授权记录!");
			}
		}
	});

function addRow() {
	var rec = CreateRecordInstance(PerLocUserGridDs.fields);
	PerLocUserGridDs.add(rec);
	var col = GetColIndex(PerLocUserGrid, 'UserId');
	PerLocUserGrid.startEditing(PerLocUserGridDs.getCount() - 1, col);
}

var savePerLocUserGrid = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			//获取所有的新记录
			var mr = PerLocUserGridDs.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var HUPLURowid = mr[i].data["HUPLURowid"];
				var userId = mr[i].data["UserId"];
				if (userId == "") {
					continue;
				}
				var active = mr[i].data["Active"];
				var name = mr[i].data["Name"];
				var dataRow = HUPLURowid + "^" + userId + "^" + active + "^" + name;
				if (data == "") {
					data = dataRow;
				} else {
					data = data + xRowDelim() + dataRow;
				}
			}
			if (data == "") {
				Msg.info("error", "没有需要保存的数据!");
				return false;
			} else {
				Ext.Ajax.request({
					url: DHCSTMUrl + '?actiontype=SavePerLocUser',
					params: {
						data: data,
						PermLocId: PermLocId,
						loginparams: loginparams
					},
					failure: function (result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function (result, request) {
						data = "";
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							PerLocUserGridDs.reload();
						} else {
							if (jsonData.info == -3) {
								Msg.info("error", "人员重复!");
							} else {
								Msg.info("error", "保存失败" + jsonData.info);
							}
						}
					},
					scope: this
				});
			}
		}
	});

var deletePerLocUserGrid = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var cell = PerLocUserGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				var record = PerLocUserGrid.getStore().getAt(cell[0]);
				var HUPLURowid = record.get("HUPLURowid");
				if (HUPLURowid != "") {
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: DHCSTMUrl + '?actiontype=deletePerLocUser&HUPLURowid=' + HUPLURowid,
								waitMsg: '删除中...',
								failure: function (result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "删除成功!");
										PerLocUserGridDs.reload();
									} else {
										Msg.info("error", "删除失败!");
									}
								},
								scope: this
							});
						}
					})
				} else {
					Msg.info("error", "数据有错!");
				}
			}
		}
	});

//表格
var PerLocUserGrid = new Ext.grid.EditorGridPanel({
		store: PerLocUserGridDs,
		cm: PerLocUserGridCm,
		trackMouseOver: true,
		height: 370,
		plugins: [ActiveField],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		clicksToEdit: 1,
		tbar: [addPerLocUser, '-', savePerLocUserGrid, '-', deletePerLocUserGrid],
		listeners: {
			beforeedit: function (e) {
				if (e.field == 'UserId' && e.record.get('HUPLURowid') != '') {
					e.cancel = true;
				}
			}
		}
	});

//-----------------------------人员授权-------------------------------

//===========模块主页面===============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var PerMLocPanel = new Ext.Panel({
			title: '科室授权',
			activeTab: 0,
			region: 'center',
			width: 600,
			collapsible: true,
			split: true,
			minSize: 0,
			maxSize: 600,
			tbar: [PerMLocSearchBT, '-', addPerMLoc, '-', savePerMLoc, '-', DelPerMLoc], //,'-',deleteStkCatGroup
			layout: 'fit',
			items: [PerMLocGrid]
		});

	var PerLocUserPanel = new Ext.Panel({
			deferredRender: true,
			title: '人员维护',
			activeTab: 0,
			region: 'south',
			height: 300,
			layout: 'fit',
			split: true,
			collapsible: true,
			items: [PerLocUserGrid]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [PerMLocPanel, PerLocUserPanel],
			renderTo: 'mainPanel'
		});
	PerMLocSearchBT.handler()
});
//===========模块主页面===============================================
