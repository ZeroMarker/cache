// 名称:科室类组管理
// 编写日期:2012-06-14

var groupId = session['LOGON.GROUPID'];
var CTLocId = "";
var LocGrpId = "";

//=========================科室信息=================================
//安全组
var groupComboStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: 'dhcstm.orgutil.csp?actiontype=QueryGroup',
		storeId: 'groupComboStore',
		root: 'rows',
		totalProperty: "results",
		fields: ['RowId', 'Description']
	});

var groupCombo = new Ext.ux.ComboBox({
		fieldLabel: '安全组',
		id: 'groupCombo',
		name: 'groupCombo',
		store: groupComboStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'FilterDesc',
		listeners: {
			"select": function () {
				CTLocGridDs.load({
					params: {
						start: 0,
						limit: CTLocPagingToolbar.pageSize,
						sort: 'RowId',
						dir: 'desc'
					}
				});
			}
		}
	});

//科室代码
var locCode = new Ext.form.TextField({
		id: 'locCode',
		allowBlank: true,
		anchor: '90%',
		width: 70
	});
//科室名称
var locName = new Ext.form.TextField({
		id: 'locName',
		allowBlank: true,
		anchor: '90%',
		width: 70
	});

var CTLocGrid = "";
//配置数据源
var gridUrl = 'dhcstm.stkloccatgroupaction.csp';
var CTLocGridProxy = new Ext.data.HttpProxy({
		url: gridUrl + '?actiontype=QueryLoc',
		method: 'POST'
	});
var CTLocGridDs = new Ext.data.Store({
		proxy: CTLocGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, [{
					name: 'Rowid'
				}, {
					name: 'Code'
				}, {
					name: 'Desc'
				}
			]),
		remoteSort: false,
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				var strFilter = Ext.getCmp('locCode').getValue() + "^" + Ext.getCmp('locName').getValue();
				var selectGroup = Ext.getCmp("groupCombo").getValue();
				if (selectGroup == "") {
					selectGroup = groupId
				}
				//alert(selectGroup);
				store.setBaseParam('strFilter', strFilter);
				store.setBaseParam('groupId', selectGroup);
			}
		}
	});

//模型
var CTLocGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "代码",
				dataIndex: 'Code',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "名称",
				dataIndex: 'Desc',
				width: 200,
				align: 'left',
				sortable: true
			}
		]);

var queryCTLoc = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			CTLocGridDs.load({
				params: {
					start: 0,
					limit: CTLocPagingToolbar.pageSize,
					sort: 'Rowid',
					dir: 'desc'
				}
			});
		}
	});

var CTLocPagingToolbar = new Ext.PagingToolbar({
		store: CTLocGridDs,
		pageSize: 30,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1} 条，一共 {2} 条'
	});

//表格
CTLocGrid = new Ext.grid.GridPanel({
		store: CTLocGridDs,
		cm: CTLocGridCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({}),
		loadMask: true,
		tbar: ['安全组:', groupCombo, '科室代码:', locCode, '科室名称:', locName, '-', queryCTLoc],
		bbar: CTLocPagingToolbar,
		viewConfig: {
			forceFit: true
		},
		listeners: {
			'rowclick': function (grid, rowIndex, e) {
				var selectedRow = CTLocGridDs.data.items[rowIndex];
				CTLocId = selectedRow.data["Rowid"];
				RefreshLocStkGrp();
			}
		}
	});

function RefreshLocStkGrp() {
	StkLocCatGroupGridDs.load({
		callback : function(r, options, success) {
			if(r.length>0){
				StkLocCatGroupGrid.getSelectionModel().selectFirstRow();
			}
		}
	});
	
	UnAuthorizedGrpStore.load();
}
//=========================科室信息================================

//=========================科室类组设置=============================
//配置数据源
var StkLocCatGroupGridProxy = new Ext.data.HttpProxy({
		url: gridUrl + '?actiontype=Query',
		method: 'GET'
	});
var StkLocCatGroupGridDs = new Ext.data.Store({
		proxy: StkLocCatGroupGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows'
		}, [{
					name: 'Rowid'
				}, {
					name: 'GrpId'
				}, {
					name: 'GrpCode'
				}, {
					name: 'GrpDesc'
				}, {
					name: 'DefaultFlag'
				}, {
					name: 'MonFlag'
				}
			]),
		pruneModifiedRecords: true,
		remoteSort: true,
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				StkLocUserCatGroupGridDs.removeAll();
				UnAuthorizedUserStore.load();
				store.setBaseParam('locId', CTLocId);
			}
		}
	});

var defaultFlag = new Ext.grid.CheckColumn({
		header: '缺省标志',
		dataIndex: 'DefaultFlag',
		width: 60,
		sortable: true
	});
var monFlag = new Ext.grid.CheckColumn({
		header: '月报标志',
		dataIndex: 'MonFlag',
		width: 60,
		sortable: true
	});
//模型
var StkLocCatGroupGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "代码",
				dataIndex: 'GrpCode',
				width: 100,
				align: 'left',
				hidden: true,
				sortable: true
			}, {
				header: "描述",
				dataIndex: 'GrpDesc',
				width: 200,
				align: 'left',
				sortable: true
			}, defaultFlag, monFlag
		]);

var saveStkLocCatGroup = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			//获取所有的新记录
			var mr = StkLocCatGroupGridDs.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var rowId = mr[i].data["Rowid"];
				var grpId = mr[i].data["GrpId"];
				var defaultflag = mr[i].data["DefaultFlag"];
				var monflag = mr[i].data["MonFlag"];
				var dataRow = rowId + "^" + grpId + "^" + defaultflag + "^" + monflag;
				if (data == "") {
					data = dataRow;
				} else {
					data = data + xRowDelim() + dataRow;
				}
			}
			if (data != "") {
				Ext.Ajax.request({
					url: gridUrl + '?actiontype=Save',
					params: {
						data: data,
						locId: CTLocId
					},
					failure: function (result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							StkLocCatGroupGridDs.load();
						} else {
							Msg.info("error", "保存失败!");
						}
					},
					scope: this
				});
			}
		}
	});

var deleteStkLocCatGroup = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var record = StkLocCatGroupGrid.getSelectionModel().getSelected();
			if (record == null) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				var RowId = record.get("Rowid");
				if (RowId != "") {
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: gridUrl + '?actiontype=delete&rowid=' + RowId,
								waitMsg: '删除中...',
								failure: function (result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "删除成功!");
										RefreshLocStkGrp();
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
var StkLocCatGroupGrid = new Ext.grid.EditorGridPanel({
		id: 'StkLocCatGroupGrid',
		title: '已授权',
		region: 'center',
		store: StkLocCatGroupGridDs,
		cm: StkLocCatGroupGridCm,
		trackMouseOver: true,
		plugins: [defaultFlag, monFlag],
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({
			listeners:{
				rowselect : function(sm,rowIndex,record){
					var selectedRow = StkLocCatGroupGridDs.data.items[rowIndex];
					LocGrpId = selectedRow.data["Rowid"];
					StkLocUserCatGroupGridDs.load({
						params: {
							start: 0,
							limit: LocUserCatGrpPagingbar.pageSize,
							sort: 'Rowid',
							dir: 'desc'
						}
					});
					UnAuthorizedUserStore.load();
				}
			}
		}),
		loadMask: true,
		clicksToEdit: 1,
		deferRowRender: false,
		viewConfig: {
			forceFit: true
		}
	});

var UnAuthorizedGrpStore = new Ext.data.JsonStore({
		url: gridUrl + '?actiontype=UnAuthorizedGrp',
		totalProperty: "results",
		root: 'rows',
		fields: ["Scg", "ScgDesc"],
		baseParams: {
			start: 0,
			limit: 999
		},
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				store.setBaseParam('locId', CTLocId);
			}
		}
	});

var UnAuthorGrpCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: '类组id',
				dataIndex: 'Scg',
				hidden: true
			}, {
				header: '类组描述',
				dataIndex: 'ScgDesc',
				width: 120
			}
		]);

var UnAuthorGrpGrid = new Ext.grid.GridPanel({
		id: 'UnAuthorGrpGrid',
		title: '未授权(双击快速授权)',
		region: 'east',
		store: UnAuthorizedGrpStore,
		cm: UnAuthorGrpCm,
		width: 250,
		viewConfig: {
			forceFit: true
		},
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		listeners: {
			rowdblclick: function (grid, rowIndex, e) {
				var Scg = grid.store.getAt(rowIndex).get('Scg');
				//alert(Scg)
				AddLocStkGrp(CTLocId, Scg);
			}
		}
	});

function AddLocStkGrp(loc, scg) {
	var slcgId = "", defaFlag = 'Y', stkMonFlag = 'Y';
	var data = slcgId + '^' + scg + '^' + defaFlag + '^' + stkMonFlag;
	Ext.Ajax.request({
		url: gridUrl + '?actiontype=Save',
		params: {
			data: data,
			locId: CTLocId
		},
		failure: function (result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "保存成功!");
				RefreshLocStkGrp();
			} else {
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}
//=========================科室类组设置=============================

//=========================人员维护=============================

var UStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: 'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['Description', 'RowId'])
	});

var UCG = new Ext.form.ComboBox({
		fieldLabel: '名称',
		id: 'UCG',
		name: 'UCG',
		anchor: '90%',
		width: 120,
		store: UStore,
		valueField: 'RowId',
		displayField: 'Description',
		//allowBlank : false,
		triggerAction: 'all',
		emptyText: '名称...',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		pageSize: 10,
		listWidth: 250,
		valueNotFoundText: ''
	});

UCG.on('beforequery', function (e) {
	UStore.removeAll();
	UStore.setBaseParam('name', Ext.getCmp('UCG').getRawValue());
	UStore.setBaseParam('locId', CTLocId);
	var pageSize = Ext.getCmp("UCG").pageSize;
	UStore.load({
		params: {
			start: 0,
			limit: pageSize
		},
		callback: function (r, options, success) {
			var tmprecode = new Ext.data.Record()
				for (var i = 0; i < StkLocUserCatGroupGridDs.getCount() - 1; i++) {
					var name = StkLocUserCatGroupGridDs.getAt(i).get("Name");
					UStore.removeAt(UStore.find("Description", name));
				}
		}
	});
});

//配置数据源
var StkLocUserCatGroupGridProxy = new Ext.data.HttpProxy({
		url: gridUrl + '?actiontype=QueryUser',
		method: 'GET'
	});
var StkLocUserCatGroupGridDs = new Ext.data.Store({
		proxy: StkLocUserCatGroupGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, [{
					name: 'Rowid'
				}, {
					name: 'UserId'
				}, {
					name: 'Code'
				}, {
					name: 'Name'
				}, {
					name: 'Default'
				}, {
					name: 'Active'
				}
			]),
		pruneModifiedRecords: true,
		remoteSort: false,
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				store.setBaseParam('locGrpId', LocGrpId);
			}
		}
	});

var DefaultField = new Ext.grid.CheckColumn({
		header: '是否默认',
		dataIndex: 'Default',
		width: 100,
		sortable: true
	});

var ActiveField = new Ext.grid.CheckColumn({
		header: '是否有效',
		dataIndex: 'Active',
		width: 100,
		sortable: true
	});

//模型
var StkLocUserCatGroupGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "人员ID",
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
				renderer: Ext.util.Format.comboRenderer2(UCG, "UserId", "Name"),
				editor: new Ext.grid.GridEditor(UCG)
			}, DefaultField, ActiveField
		]);
var UnAuthorizedUserStore = new Ext.data.JsonStore({
		url: ' dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp',
		totalProperty: "results",
		root: 'rows',
		fields: ["RowId", "Description"],
		baseParams: {
			start: 0,
			limit: 999
		},
		listeners: {
			beforeload: function (store, options) {
				store.removeAll();
				store.setBaseParam('locId', CTLocId);
			}
		}
	});

var UnAuthorUserCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: '人员id',
				dataIndex: 'RowId',
				hidden: true
			}, {
				header: '名称',
				dataIndex: 'Description'
				//width : 200
			}
		]);

var UnAuthorUserGrid = new Ext.grid.GridPanel({
		id: 'UnAuthorUserGrid',
		title: '(双击快速授权)',
		region: 'east',
		store: UnAuthorizedUserStore,
		cm: UnAuthorUserCm,
		width: 350,
		viewConfig: {
			forceFit: true
		},
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		listeners: {
			rowdblclick: function (grid, rowIndex, e) {
				var Userid = grid.store.getAt(rowIndex).get('RowId');
				var UserName = grid.store.getAt(rowIndex).get('Description');
				AddLocUser(Userid, UserName);
			}
		}
	});
var addStkLocUserCatGroup = new Ext.Toolbar.Button({
		text: '新建',
		tooltip: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			if (LocGrpId != "") {
				addRow();
			} else {
				Msg.info("error", "请选择科室类组!");
			}
		}
	});

function addRow() {
	var rec = CreateRecordInstance(StkLocUserCatGroupGridDs.fields,{Default:'Y',Active:'Y'});
	StkLocUserCatGroupGridDs.add(rec);
	var col = GetColIndex(StkLocUserCatGroupGrid, 'UserId');
	StkLocUserCatGroupGrid.startEditing(StkLocUserCatGroupGridDs.getCount() - 1, col);
}

var saveStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			//获取所有的新记录
			var mr = StkLocUserCatGroupGridDs.getModifiedRecords();
			var data = "";
			for (var i = 0; i < mr.length; i++) {
				var RowId = mr[i].data["Rowid"];
				var userId = mr[i].data["UserId"];
				if (userId == "") {
					continue;
				}
				var active = mr[i].data["Active"];
				var def = mr[i].data["Default"];
				var name = mr[i].data["Name"];
				var dataRow = RowId + "^" + userId + "^" + active + "^" + def + "^" + name;
				//alert(dataRow)
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
					url: gridUrl + '?actiontype=SaveUser',
					params: {
						data: data,
						locGrpId: LocGrpId
					},
					failure: function (result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function (result, request) {
						data = "";
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							StkLocUserCatGroupGridDs.reload();
						} else {
							if (jsonData.info == -1) {
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
function AddLocUser(Userid, UserName) {
	var active = "Y";
	var def = "";
	var Rowid = "";
	var data = Rowid + "^" + Userid + "^" + active + "^" + def + "^" + UserName;
	if (LocGrpId == ""){
		Msg.info("error", "请先授权科室类组!");
		return false;
	}
	if (data == "") {
		Msg.info("error", "没有需要授权的数据!");
		return false;
	} else {
		Ext.Ajax.request({
			url: gridUrl + '?actiontype=SaveUser',
			params: {
				data: data,
				locGrpId: LocGrpId
			},
			failure: function (result, request) {
				Msg.info("error", "请检查网络连接!");
			},
			success: function (result, request) {
				data = "";
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "授权成功!");
					StkLocUserCatGroupGridDs.reload();
				} else {
					if (jsonData.info == -100) {
						Msg.info("error", "人员重复，已维护!");
					} else {
						Msg.info("error", "授权失败" + jsonData.info);
					}
				}
			},
			scope: this
		});
	}

}
var deleteStkLocUserCatGroupGrid = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		handler: function () {
			var cell = StkLocUserCatGroupGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("error", "请选择数据!");
				return false;
			} else {
				var record = StkLocUserCatGroupGrid.getStore().getAt(cell[0]);
				var RowId = record.get("Rowid");
				if (RowId != "") {
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?',
						function (btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url: gridUrl + '?actiontype=deleteUser&rowid=' + RowId,
								waitMsg: '删除中...',
								failure: function (result, request) {
									Msg.info("error", "请检查网络连接!");
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Msg.info("success", "删除成功!");
										StkLocUserCatGroupGridDs.reload();
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

var LocUserCatGrpPagingbar = new Ext.PagingToolbar({
		store: StkLocUserCatGroupGridDs,
		pageSize: 30,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条，一共 {2} 条'
	});

//表格
var StkLocUserCatGroupGrid = new Ext.grid.EditorGridPanel({
		store: StkLocUserCatGroupGridDs,
		cm: StkLocUserCatGroupGridCm,
		trackMouseOver: true,
		height: 370,
		region: 'center',
		plugins: [DefaultField, ActiveField],
		stripeRows: true,
		sm: new Ext.grid.CellSelectionModel({}),
		loadMask: true,
		clicksToEdit: 1,
		tbar: [saveStkLocUserCatGroupGrid, '-', deleteStkLocUserCatGroupGrid],
		bbar: LocUserCatGrpPagingbar,
		listeners: {
			beforeedit: function (e) {
				if (e.field == 'UserId' && e.record.get('Rowid') != '') {
					e.cancel = true;
				}
			}
		}
	});
//=========================人员维护=============================

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var CTLocPanel = new Ext.Panel({
			deferredRender: true,
			title: '科室信息',
			activeTab: 0,
			region: 'west',
			collapsible: true,
			split: true,
			width: 600,
			minSize: 0,
			maxSize: 600,
			layout: 'fit',
			items: [CTLocGrid]
		});

	var StkLocCatGroupPanel = new Ext.Panel({
			title: '科室类组',
			deferredRender: true,
			region: 'center',
			tbar: [saveStkLocCatGroup, '-', deleteStkLocCatGroup],
			layout: 'border',
			items: [StkLocCatGroupGrid, UnAuthorGrpGrid]
		});

	var StkLocUserCatGroupPanel = new Ext.Panel({
			deferredRender: true,
			title: '人员维护',
			activeTab: 0,
			region: 'south',
			height: 200,
			//width:100,
			layout: 'border',
			split: true,
			collapsible: true,
			viewConfig: {
				forceFit: true
			},
			items: [StkLocUserCatGroupGrid, UnAuthorUserGrid]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			collapsible: true,
			split: true,
			items: [CTLocPanel, StkLocCatGroupPanel, StkLocUserCatGroupPanel],
			renderTo: 'mainPanel'
		});
	queryCTLoc.handler();
	//获取登陆值
	SetLogGroup(groupCombo.getStore(), "groupCombo");
});
