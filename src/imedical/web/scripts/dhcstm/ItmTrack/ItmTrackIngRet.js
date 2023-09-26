// 名称:未使用高值退库退货
// 编写日期:2016-11-30
//=========================定义全局变量=================================
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var GroupId = session['LOGON.GROUPID'];
var URL = 'dhcstm.itmtrackaction.csp';
var URLX = 'dhcstm.itmtrackingretaction.csp';
var CURRENT_INIT = "";
var CURRENT_INGT = "";
var gIncId = "";

var LocField = new Ext.ux.LocComboBox({
		id: 'LocField',
		fieldLabel: '库房',
		anchor: '90%',
		listWidth: 210,
		emptyText: '库房...',
		groupId: GroupId
	});

var VirtualFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: G_VIRTUAL_STORE,
		id: 'VirtualFlag',
		name: 'VirtualFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			check: function (chk, bool) {
				if (bool) {
					var phaloc = Ext.getCmp("LocField").getValue();
					var url = "dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc=" + phaloc;
					var response = ExecuteDBSynAccess(url);
					var jsonData = Ext.util.JSON.decode(response);
					if (jsonData.success == 'true') {
						var info = jsonData.info;
						var infoArr = info.split("^");
						var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
						addComboData(Ext.getCmp("LocField").getStore(), vituralLoc, vituralLocDesc);
						Ext.getCmp("LocField").setValue(vituralLoc);
					}
				} else {
					SetLogInDept(Ext.getCmp("LocField").getStore(), "LocField");
				}
			}
		}
	});
VirtualFlag.setValue(true);

var CurrPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '科室',
		id: 'CurrPhaLoc',
		anchor: '90%',
		width: 210,
		emptyText: '科室...',
		defaultLoc: {}
	});

var VendorField = new Ext.ux.VendorComboBox({
		id: 'VendorField',
		anchor: '90%'
	});

var groupField = new Ext.ux.StkGrpComboBox({
		id: 'groupField',
		StkType: App_StkTypeCode,
		LocId: CtLocId,
		anchor: '90%',
		UserId: UserId
	});

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		width: 150,
		listWidth: 150,
		allowBlank: true,
		fieldLabel: '起始日期',
		anchor: '90%',
		value: DefaultStDate()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		width: 150,
		listWidth: 150,
		allowBlank: true,
		fieldLabel: '截止日期',
		anchor: '90%',
		value: DefaultEdDate()
	});

var InciDesc = new Ext.form.TextField({
		fieldLabel: '物资名称',
		id: 'InciDesc',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("groupField").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
	 GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gIncId = record.get("InciDr");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);
}

var find = new Ext.Toolbar.Button({
		id: 'findreq',
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			Query()
		}
	});

var clear = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '清空',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			ClearData();
		}
	});

var retgoods = new Ext.ux.Button({
		text: '生成单据',
		tooltip: '生成单据',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			CreatIngRet();
		}
	});

var MasterGridCm = [{
		header: "rowid",
		dataIndex: 'rowid',
		hidden: true
	}, {
		header: "inci",
		dataIndex: 'inci',
		width: 100,
		align: 'left',
		hidden: true
	}, {
		header: "物资代码",
		dataIndex: 'inciCode',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "物资名称",
		dataIndex: 'inciDesc',
		width: 200,
		align: 'left',
		sortable: true
	}, {
		header: "条码",
		dataIndex: 'label',
		width: 150,
		align: 'left',
		sortable: true
	}, {
		header: "自带条码",
		dataIndex: 'originalCode',
		width: 150
	}, {
		header: "状态",
		dataIndex: 'status',
		renderer: statusRenderer,
		width: 60,
		align: 'center',
		sortable: true
	}, {
		header: "批号id",
		dataIndex: 'incib',
		width: 150,
		align: 'left',
		hidden: true,
		sortable: true
	}, {
		header: "批号~效期",
		dataIndex: 'incibNo',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "规格",
		dataIndex: 'spec',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "具体规格",
		dataIndex: 'specDesc',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "单位",
		dataIndex: 'uomDesc',
		width: 60,
		align: 'left',
		sortable: true
	}, {
		header: "供应商",
		dataIndex: 'vendor',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "厂商",
		dataIndex: 'manfName',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "当前位置",
		dataIndex: 'currentLoc',
		width: 150,
		align: 'left',
		sortable: true
	}, {
		header: "日期",
		dataIndex: 'date',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "时间",
		dataIndex: 'time',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "操作人",
		dataIndex: 'user',
		width: 100,
		align: 'left',
		sortable: true
	}
];

var MasterGrid = new Ext.dhcstm.EditorGridPanel({
		title: '材料信息',
		id: 'MasterGrid',
		childGrid: ["DetailGrid"],
		contentColumns: MasterGridCm,
		actionUrl: URL,
		queryAction: "Query",
		idProperty: "rowid",
		paramsFn: MatParamsFn,
		smType: "checkbox",
		singleSelect: false,
		checkOnly: false,
		smRowSelFn: MatRowSelFn,
		editable: false
	});

var DetailGridCm = [{
		header: "RowId",
		dataIndex: 'RowId',
		hidden: true
	}, {
		header: "类型",
		dataIndex: 'Type',
		width: 100,
		align: 'left',
		renderer: TypeRenderer
	}, {
		header: "Pointer",
		dataIndex: 'Pointer',
		width: 100,
		hidden: true
	}, {
		header: "处理号",
		dataIndex: 'OperNo',
		width: 200
	}, {
		header: "日期",
		dataIndex: 'Date',
		width: 100
	}, {
		header: "时间",
		dataIndex: 'Time',
		width: 100
	}, {
		header: "操作人",
		dataIndex: 'User',
		width: 100
	}, {
		header: "位置信息",
		dataIndex: 'OperOrg',
		width: 200
	}
];

var DetailGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'DetailGrid',
		contentColumns: DetailGridCm,
		actionUrl: URL,
		queryAction: "QueryItem",
		idProperty: "RowId",
		editable: false
	});

var initGridCm = [{
		header: 'init',
		dataIndex: 'init',
		width: 100,
		hidden: true
	}, {
		header: '退库单号',
		dataIndex: 'initNo',
		width: 160
	}, {
		header: '供应部门',
		dataIndex: 'frLoc',
		width: 140
	}, {
		header: '请求部门',
		dataIndex: 'toLoc',
		width: 140
	}, {
		header: '日期',
		dataIndex: 'initDate',
		width: 100
	}, {
		header: '时间',
		dataIndex: 'initTime',
		width: 100
	}, {
		header: '类组',
		dataIndex: 'scgDesc',
		width: 100
	}
];

var initGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'initGrid',
		childGrid: ["initDetailGrid"],
		contentColumns: initGridCm,
		actionUrl: URLX,
		queryAction: "QueryInit",
		idProperty: "init",
		valueParams: {
			"init": CURRENT_INIT
		},
		smType: "row",
		singleSelect: true,
		smRowSelFn: initRowSelFn,
		editable: false
	});

var initDetailGridCm = [{
		header: "退库细项RowId",
		dataIndex: 'initi',
		width: 100,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "物资代码",
		dataIndex: 'inciCode',
		width: 80,
		align: 'left',
		sortable: true
	}, {
		header: "物资名称",
		dataIndex: 'inciDesc',
		width: 180,
		align: 'left',
		sortable: true
	}, {
		header: "高值条码",
		dataIndex: 'HVBarCode',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "规格",
		dataIndex: 'spec',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "批次/效期",
		dataIndex: 'batexp',
		width: 150,
		align: 'left',
		sortable: true
	}, {
		header: "生产厂商",
		dataIndex: 'manfName',
		width: 180,
		align: 'left',
		sortable: true
	}, {
		header: "转移数量",
		dataIndex: 'qty',
		width: 80,
		align: 'right'
	}, {
		header: "单位",
		dataIndex: 'uom',
		width: 80,
		align: 'left'
	}, {
		header: "进价",
		dataIndex: 'rp',
		xtype: 'numbercolumn',
		width: 60,
		align: 'right'
	}, {
		header: "售价",
		dataIndex: 'sp',
		xtype: 'numbercolumn',
		width: 60,
		align: 'right'
	}, {
		header: "售价金额",
		dataIndex: 'spAmt',
		xtype: 'numbercolumn',
		width: 100,
		align: 'right'
	}, {
		header: "进价金额",
		dataIndex: 'rpAmt',
		xtype: 'numbercolumn',
		width: 100,
		align: 'right'
	}
];

var initDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'initDetailGrid',
		contentColumns: initDetailGridCm,
		actionUrl: URLX,
		queryAction: "QueryIniti",
		idProperty: "initi",
		editable: false
	});

var ingRetGridCm = [{
		header: 'ingt',
		dataIndex: 'ingt',
		width: 100,
		hidden: true
	}, {
		header: '退货单号',
		dataIndex: 'ingtNo',
		width: 160
	}, {
		header: '供应商',
		dataIndex: 'vendor',
		width: 140
	}, {
		header: '日期',
		dataIndex: 'ingtDate',
		width: 100
	}, {
		header: '时间',
		dataIndex: 'ingtTime',
		width: 100
	}, {
		header: '类组',
		dataIndex: 'scgDesc',
		width: 100
	}
];

var ingRetGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'ingRetGrid',
		childGrid: ["ingRetDetailGrid"],
		contentColumns: ingRetGridCm,
		actionUrl: URLX,
		queryAction: "QueryIngt",
		idProperty: "ingt",
		valueParams: {
			"ingt": CURRENT_INGT
		},
		smType: "row",
		singleSelect: true,
		smRowSelFn: ingRetRowSelFn,
		editable: false
	});

var ingRetDetailGridCm = [{
		header: "退货细项RowId",
		dataIndex: 'ingti',
		width: 100,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "物资代码",
		dataIndex: 'inciCode',
		width: 80,
		align: 'left',
		sortable: true
	}, {
		header: "物资名称",
		dataIndex: 'inciDesc',
		width: 180,
		align: 'left',
		sortable: true
	}, {
		header: "高值条码",
		dataIndex: 'HVBarCode',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "规格",
		dataIndex: 'spec',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		header: "批次/效期",
		dataIndex: 'batexp',
		width: 150,
		align: 'left',
		sortable: true
	}, {
		header: "生产厂商",
		dataIndex: 'manfName',
		width: 180,
		align: 'left',
		sortable: true
	}, {
		header: "退货数量",
		dataIndex: 'qty',
		width: 80,
		align: 'right'
	}, {
		header: "单位",
		dataIndex: 'uom',
		width: 80,
		align: 'left'
	}, {
		header: "进价",
		dataIndex: 'rp',
		xtype: 'numbercolumn',
		width: 60,
		align: 'right'
	}, {
		header: "售价",
		dataIndex: 'sp',
		xtype: 'numbercolumn',
		width: 60,
		align: 'right'
	}, {
		header: "售价金额",
		dataIndex: 'spAmt',
		xtype: 'numbercolumn',
		width: 100,
		align: 'right'
	}, {
		header: "进价金额",
		dataIndex: 'rpAmt',
		xtype: 'numbercolumn',
		width: 100,
		align: 'right'
	}
];

var ingRetDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'ingRetDetailGrid',
		contentColumns: ingRetDetailGridCm,
		actionUrl: URLX,
		queryAction: "QueryIngti",
		idProperty: "ingti",
		editable: false
	});

function MatParamsFn() {
	var locId = Ext.getCmp("LocField").getValue();
	var vendor = Ext.getCmp("VendorField").getValue();
	var currLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var grp = Ext.getCmp("groupField").getValue();
	var startDate = Ext.getCmp("startDateField").getValue();
	var endDate = Ext.getCmp("endDateField").getValue();
	var inciDesc = Ext.getCmp("InciDesc").getValue();
	if (locId == "") {
		Msg.info("error", '请选择库房!');
		Ext.getCmp("LocField").focus();
		return false;
	}
	if (vendor == "") {
		Msg.info("error", '请选择供应商!');
		Ext.getCmp("VendorField").focus();
		return false;
	}
	if (currLoc == "") {
		Msg.info("error", '请选择科室!');
		Ext.getCmp("CurrPhaLoc").focus();
		return false;
	}
	if (grp == "") {
		Msg.info("error", '请选择类组!');
		Ext.getCmp("groupField").focus();
		return false;
	}
	if ((startDate != "") && (startDate != null)) {
		startDate = startDate.format(ARG_DATEFORMAT);
	}
	if ((endDate != "") && (endDate != null)) {
		endDate = endDate.format(ARG_DATEFORMAT);
	}
	var inciDr = gIncId;
	var label = "";
	var Others = vendor + "^" + startDate + "^" + endDate + "^^" + "Enable" + "^" + "N" + "^^" + currLoc + "^^^" + inciDesc + "^^^";
	return {
		"inci": inciDr,
		"label": label,
		"others": Others
	};
}

function MatRowSelFn(grid, rowIndex, r) {
	var parref = r.get("rowid");
	DetailGrid.load({
		params: {
			dir: 'ASC',
			Parref: parref
		}
	});
}

function initRowSelFn(grid, rowIndex, r) {
	var init = r.get("init");
	initDetailGrid.load({
		params: {
			Parref: init
		}
	});
}

function ingRetRowSelFn(grid, rowIndex, r) {
	var ingt = r.get("ingt");
	ingRetDetailGrid.load({
		params: {
			Parref: ingt
		}
	});
}

function Query() {
	CURRENT_INIT = "";
	CURRENT_INGT = "";
	MasterGrid.removeAll();
	DetailGrid.removeAll();
	initGrid.removeAll();
	ingRetGrid.removeAll();
	initDetailGrid.removeAll();
	ingRetDetailGrid.removeAll();
	MasterGrid.load();
}

function ClearData() {
	CURRENT_INIT = "";
	CURRENT_INGT = "";
	gIncId = "";
	Ext.getCmp("CurrPhaLoc").setValue("");
	Ext.getCmp("VendorField").setValue("");
	Ext.getCmp("LocField").getStore().load();
	Ext.getCmp("groupField").getStore().load();
	Ext.getCmp("startDateField").setValue(DefaultStDate());
	Ext.getCmp("endDateField").setValue(DefaultEdDate());
	Ext.getCmp("InciDesc").setValue("");
	MasterGrid.removeAll();
	DetailGrid.removeAll();
	initGrid.removeAll();
	ingRetGrid.removeAll();
	initDetailGrid.removeAll();
	ingRetDetailGrid.removeAll();
}

function CreatIngRet() {
	var locId = Ext.getCmp("LocField").getValue();
	var locdesc = Ext.getCmp("LocField").getRawValue();
	var vendor = Ext.getCmp("VendorField").getValue();
	var currLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var scg = Ext.getCmp("groupField").getValue();
	var str = getItmStr();
	if (str == '') {
		Msg.info("error", "请选择物资");
		return false;
	}
	if (locId == currLoc) {
		Msg.info("error", "库房与科室不允许相同");
		return false;
	}
	Ext.Ajax.request({
		url: URLX + "?actiontype=CreatIngRet",
		method: 'POST',
		params: {
			locId: locId,
			vendor: vendor,
			currLoc: currLoc,
			scg: scg,
			str: str,
			user: UserId
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var ret = jsonData.info.split("^");
				Msg.info('success', '处理成功!');
				CURRENT_INIT = ret[1];
				CURRENT_INGT = ret[2];
				initGrid.load({
					params: {
						init: CURRENT_INIT
					}
				});
				ingRetGrid.load({
					params: {
						ingt: CURRENT_INGT
					}
				});
				Query();
			} else {
				var ret = jsonData.info;
				if (ret == -1) {
					Msg.info("error", "保存失败!");
				} else if (ret == -1) {
					Msg.info("error", "生成退库单失败!");
				} else if (ret == -2) {
					Msg.info("error", "生成退库单明细失败!");
				} else if (ret == -3) {
					Msg.info("error", "退库单审核失败!");
				} else if (ret == -6) {
					Msg.info("error", "生成退货单失败!");
				} else if (ret == -8) {
					Msg.info("error", "退货单审核失败!");
				} else if (ret == -11) {
					Msg.info("error", "存在不是出自" + locdesc + "的条码");
				} else {
					Msg.info("error", "保存不成功：" + ret);
				}
			}
		},
		scope: this
	});
}

function getItmStr() {
	var str = "";
	var cnt = MasterGrid.getSelections().length;
	for (var i = 0; i < cnt; i++) {
		var r = MasterGrid.getSelections()[i];
		var rowid = r.get("rowid");
		if (str == '') {
			str = rowid;
		} else {
			str = str + RowDelim + rowid;
		}
	}
	return str;
}
//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.ux.FormPanel({
			title: '未用高值退库退货',
			labelWidth: 80,
			tbar: [find, '-', clear, '-', retgoods],
			items: [{
					layout: 'column',
					xtype: 'fieldset',
					title: '查询条件',
					defaults: {
						border: false
					},
					style: 'padding:5px 0px 0px 5px',
					items: [{
							columnWidth: .25,
							xtype: 'fieldset',
							items: [LocField, CurrPhaLoc]
						}, {
							columnWidth: .05,
							xtype: 'fieldset',
							items: [VirtualFlag]
						}, {
							columnWidth: .25,
							xtype: 'fieldset',
							items: [VendorField, groupField]
						}, {
							columnWidth: .2,
							xtype: 'fieldset',
							items: [startDateField, endDateField]
						}, {
							columnWidth: .25,
							xtype: 'fieldset',
							items: [InciDesc]
						}
					]
				}
			]
		});

	var tp = new Ext.TabPanel({
			activeTab: 0,
			items: [{
					title: '本次退库',
					id: 'initMaster',
					layout: 'border',
					items: [{
							region: 'north',
							height: 200,
							layout: 'fit',
							items: initGrid
						}, {
							region: 'center',
							layout: 'fit',
							items: initDetailGrid
						}
					]
				}, {
					title: '本次退货',
					id: 'ingtMaster',
					layout: 'border',
					items: [{
							region: 'north',
							height: 200,
							layout: 'fit',
							items: ingRetGrid
						}, {
							region: 'center',
							layout: 'fit',
							items: ingRetDetailGrid
						}
					]
				}
			],
			listeners: {
				'tabchange': function (t, p) {
					if (p.getId() == 'initMaster') {
						if (CURRENT_INIT != "") {
							initGrid.load({
								params: {
									init: CURRENT_INIT
								}
							});
						}
					}
					if (p.getId() == 'ingtMaster') {
						if (CURRENT_INGT != "") {
							ingRetGrid.load({
								params: {
									ingt: CURRENT_INGT
								}
							});
						}
					}
				}
			}
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, {
					region: 'west',
					width: 300,
					autoScroll: true,
					split: true,
					collapsible: true,
					layout: 'border',
					items:
					[{
							region: 'north',
							layout: 'fit',
							height: 200,
							items: MasterGrid
						}, {
							region: 'center',
							layout: 'fit',
							items: DetailGrid
						}
					]
				}, {
					region: 'center',
					layout: 'fit',
					items: [tp]
				}
			]
		});
});
//===========模块主页面===========================================
