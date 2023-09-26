// /描述: 付款单管理
// /编写者：gwj
// /编写日期: 2012.09.24
var win;
var payRowId = "";
var URL = "dhcstm.payaction.csp";
var gGroupId = session['LOGON.GROUPID'];

//保存参数值的object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

var GetPaymodeStore = new Ext.data.Store({
		url: URL + "?actiontype=GetPayMode",
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results',
			fields: [{
					name: 'RowId',
					mapping: 'rowid'
				}, {
					name: 'Description',
					mapping: 'payDesc'
				}, 'payCode']
		})
	});

// 入库科室
var Paymod = new Ext.ux.ComboBox({
		fieldLabel: '支付方式',
		id: 'Paymod',
		name: 'Paymod',
		anchor: '90%',
		store: GetPaymodeStore,
		valueField: 'RowId',
		displayField: 'Description',
		emptyText: '支付方式...'
	});

// 入库科室
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '采购科室',
		id: 'PhaLoc',
		name: 'PhaLoc',
		emptyText: '采购科室...',
		groupId: gGroupId,
		childCombo: 'Vendor'
	});

// 供货厂商
var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel: '供应商',
		id: 'Vendor',
		name: 'Vendor',
		anchor: '90%',
		emptyText: '供应商...',
		params: {
			LocId: 'PhaLoc'
		}
	});

// 起始日期
var StartDate = new Ext.ux.DateField({
		fieldLabel: '起始日期',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		value: new Date().add(Date.DAY,  - 30)
	});
// 截止日期
var EndDate = new Ext.ux.DateField({
		fieldLabel: '截止日期',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		value: new Date()
	});

var AccAckFlag = new Ext.form.Checkbox({
		fieldLabel: '已会计确认',
		id: 'AccAckFlag',
		name: 'AccAckFlag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("NoAccAckFlag").setValue(!chk.getValue());
				}
			}
		}
	});
var NoAccAckFlag = new Ext.form.Checkbox({
		fieldLabel: '未会计确认',
		id: 'NoAccAckFlag',
		name: 'NoAccAckFlag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("AccAckFlag").setValue(!chk.getValue());
				}
			}
		}
	});

//是否采购确认
var PurAckFlag = new Ext.form.Checkbox({
		fieldLabel: '已采购确认',
		id: 'PurAckFlag',
		name: 'PurAckFlag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("NoPurAckFlag").setValue(!chk.getValue());
				}
			}
		}
	});
var NoPurAckFlag = new Ext.form.Checkbox({
		fieldLabel: '未采购确认',
		id: 'NoPurAckFlag',
		name: 'NoPurAckFlag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("PurAckFlag").setValue(!chk.getValue());
				}
			}
		}
	});

var Ack3Flag = new Ext.form.Checkbox({
		fieldLabel: '已财务确认',
		id: 'Ack3Flag',
		name: 'Ack3Flag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("NoAck3Flag").setValue(!chk.getValue());
				}
			}
		}
	});
var NoAck3Flag = new Ext.form.Checkbox({
		fieldLabel: '未财务确认',
		id: 'NoAck3Flag',
		name: 'NoAck3Flag',
		anchor: '90%',
		width: 120,
		checked: false,
		listeners: {
			'check': function (chk) {
				if (chk.getValue()) {
					Ext.getCmp("Ack3Flag").setValue(!chk.getValue());
				}
			}
		}
	});

//业务单号
var GRNo = new Ext.form.TextField({
		fieldLabel: '业务单号',
		id: 'GRNo',
		name: 'GRNo',
		anchor: '90%',
		width: 120,
		disabled: false
	});

// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '点击查询',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			Query();
		}
	});
/**
 * 查询方法
 */
function Query() {
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择采购科室!");
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var startDate = Ext.getCmp("StartDate").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("EndDate").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '截止日期不可为空');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	//20161128获取是否会计确认  YN已会计确认  NY未会计确认  NN不控制
	var accackflag = (Ext.getCmp("AccAckFlag").getValue() == true ? 'Y' : 'N');
	var noaccackflag = (Ext.getCmp("NoAccAckFlag").getValue() == true ? 'Y' : 'N');
	if (accackflag == "N") {
		if (noaccackflag == "Y") {
			accackflag = "N";
		} else {
			accackflag = "";
		}
	} else {
		accackflag = "Y";
	}
	//20161128获取是否采购确认  YN已采购确认  NY未采购确认  NN不控制
	var purackflag = (Ext.getCmp("PurAckFlag").getValue() == true ? 'Y' : 'N');
	var nopurackflag = (Ext.getCmp("NoPurAckFlag").getValue() == true ? 'Y' : 'N');
	if (purackflag == "N") {
		if (nopurackflag == "Y") {
			purackflag = "N";
		} else {
			purackflag = "";
		}
	} else {
		purackflag = "Y";
	}
	var Ack3Flag = (Ext.getCmp("Ack3Flag").getValue() == true ? 'Y' : 'N');
	var NoAck3Flag = (Ext.getCmp("NoAck3Flag").getValue() == true ? 'Y' : 'N');
	if (Ack3Flag == "N") {
		if (NoAck3Flag == "Y") {
			Ack3Flag = "N";
		} else {
			Ack3Flag = "";
		}
	} else {
		Ack3Flag = "Y";
	}
	var grno = Ext.getCmp("GRNo").getValue();
	var CmpFlag = "Y";
	//开始日期^截止日期^科室id^供应商id
	var ListParam = startDate + '^' + endDate + '^' + phaLoc + '^' + vendor + '^' + "" + '^' + "" + '^' + accackflag + '^' + purackflag + '^' + grno + '^' + Ack3Flag;
	var Page = GridPagingToolbar.pageSize;
	MasterStore.load();

}
// 打印付款单按钮
var PrintBT = new Ext.Toolbar.Button({
		id: "PrintBT",
		text: '打印',
		tooltip: '点击打印付款单',
		width: 70,
		height: 30,
		iconCls: 'page_print',
		handler: function () {
			var rowData = MasterGrid.getSelectionModel().getSelected()
				if (rowData == "") {
					Msg.info("warning", "请选择需要打印的付款单！");
					return;
				}
				var RowId = rowData.get("RowId")
				PrintPay(RowId);
		}
	});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '点击清空',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			clearData();
		}
	});

/**
 * 清空方法
 */
function clearData() {
	//Ext.getCmp("PhaLoc").setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("AccAckFlag").setValue(false);
	Ext.getCmp("NoAccAckFlag").setValue(false);
	Ext.getCmp("PurAckFlag").setValue(false);
	Ext.getCmp("NoPurAckFlag").setValue(false);
	Ext.getCmp("Ack3Flag").setValue(false);
	Ext.getCmp("NoAck3Flag").setValue(false);
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}

// 采购确认按钮
var Ack1BT = new Ext.Toolbar.Button({
		id: "Ack1BT",
		text: '采购确认',
		tooltip: '点击确认',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck1();
		}
	});
// 会计确认按钮
var Ack2BT = new Ext.Toolbar.Button({
		id: "Ack2BT",
		text: '会计确认',
		tooltip: '点击确认',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck2();
		}
	});
	
// 财务确认按钮	
var Ack3BT = new Ext.Toolbar.Button({
		id: "Ack3BT",
		text: '财务确认',
		tooltip: '点击确认',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck3();
		}
	});
/**
 * 采购确认付款单
 */
function SetAck1() {
	var rec = MasterGrid.getSelectionModel().getSelected();
	if (rec == undefined) {
		return;
	}
	var PayId = rec.get('RowId');
	if (PayId == '') {
		return;
	}
	var url = URL + "?actiontype=SetAck1&PayId=" + PayId;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '更新中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 确认单据
				Msg.info("success", "确认成功!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "此付款单未完成!");
				} else if (Ret == -3) {
					Msg.info("error", "此付款单已经确认!");
				} else if (Ret == -1) {
					Msg.info("error", "未找到此付款单!");
				} else {
					Msg.info("error", "确认失败:"+Ret);
				}
			}
		},
		scope: this
	});
}

function ExecuteAck2(rowid, paymodeInfo) {
	var url = URL + "?actiontype=SetAck2&PayId=" + rowid + "&PayInfo=" + paymodeInfo;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '更新中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 确认单据
				Msg.info("success", "确认成功!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "此付款单未完成!");
				} else if (Ret == -3) {
					Msg.info("error", "此付款单已经确认!");
				} else if (Ret == -1) {
					Msg.info("error", "未找到此付款单!");
				} else {
					Msg.info("error", "确认失败:" + Ret);
				}
			}
		},
		scope: this
	});

}

/**
 * 会计确认付款单
 */
function SetAck2() {
	var rowData = MasterGrid.getSelectionModel().getSelected();
	if (rowData == undefined) {
		return;
	}
	payRowId = rowData.get('RowId');
	if (payRowId == '') {
		return;
	}
	var ack2Flag=rowData.get('ack2Flag');
	if(ack2Flag=="Y"){
		Msg.info("warning","此付款单已经会计确认!");
		return;
	}
	if (payRowId != "") {
		var vendorName = rowData.get("vendorName");
		var payNo = rowData.get("payNo");
		var payAmt = rowData.get("payAmt");
		var PayNoinfo = payNo + "^" + vendorName + "^" + payAmt;
		SetInfo(PayNoinfo); //确认附加信息
	}
}

/**
 * 财务审核付款单
 */
function SetAck3() {
	var rec = MasterGrid.getSelectionModel().getSelected();
	if (rec == undefined) {
		return;
	}
	var PayId = rec.get('RowId');
	if (PayId == '') {
		return;
	}
	var url = URL + "?actiontype=SetAck3&PayId=" + PayId;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '更新中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "确认成功!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "此付款单未完成!");
				} else if (Ret == -3) {
					Msg.info("error", "此付款单已经确认!");
				} else if (Ret == -1) {
					Msg.info("error", "未找到此付款单!");
				} else {
					Msg.info("error", "确认失败:"+Ret);
				}
			}
		},
		scope: this
	});
}

// 访问路径
var MasterUrl = URL + '?actiontype=query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
		url: MasterUrl,
		method: "POST"
	});
// 指定列参数
var fields = [{name: "RowId",mapping: 'pay'}, "PurNo", "payNo", "locDesc", "vendorName", "payDate", "payTime", "payUserName", "payAmt",
		{name: "ack1Flag",mapping: 'ack1'}, "ack1UserName", "ack1Date", {name: "ack2Flag",mapping: 'ack2'}, "ack2UserName", "ack2Date",
		"payMode", "checkNo", "checkDate", "checkAmt", {name: "completed",mapping: 'payComp'}, "ack3", "ack3UserName", "ack3Date"];
// 支持分页显示的读取方式
var mReader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "RowId",
		fields: fields
	});
// 数据集
var MasterStore = new Ext.data.Store({
		proxy: proxy,
		reader: mReader,
		listeners: {
			'beforeload': function (store) {
				var phaLoc = Ext.getCmp("PhaLoc").getValue();
				var vendor = Ext.getCmp("Vendor").getValue();
				var startDate = Ext.getCmp("StartDate").getValue();
				var endDate = Ext.getCmp("EndDate").getValue();
				if (startDate != "") {
					startDate = startDate.format(ARG_DATEFORMAT);
				}
				if (endDate != "") {
					endDate = endDate.format(ARG_DATEFORMAT);
				}
				var completed = "Y"; //完成标志="Y"
				var paymode = Ext.getCmp("Paymod").getValue();
				//20161128获取是否会计确认  YN已会计确认  NY未会计确认  NN不控制
				var accackflag = (Ext.getCmp("AccAckFlag").getValue() == true ? 'Y' : 'N');
				var noaccackflag = (Ext.getCmp("NoAccAckFlag").getValue() == true ? 'Y' : 'N');
				if (accackflag == "N") {
					if (noaccackflag == "Y") {
						accackflag = "N";
					} else {
						accackflag = "";
					}
				} else {
					accackflag = "Y";
				}
				//20161128获取是否采购确认  YN已采购确认  NY未采购确认  NN不控制
				var purackflag = (Ext.getCmp("PurAckFlag").getValue() == true ? 'Y' : 'N');
				var nopurackflag = (Ext.getCmp("NoPurAckFlag").getValue() == true ? 'Y' : 'N');
				if (purackflag == "N") {
					if (nopurackflag == "Y") {
						purackflag = "N";
					} else {
						purackflag = "";
					}
				} else {
					purackflag = "Y";
				}
				var Ack3Flag = (Ext.getCmp("Ack3Flag").getValue() == true ? 'Y' : 'N');
				var NoAck3Flag = (Ext.getCmp("NoAck3Flag").getValue() == true ? 'Y' : 'N');
				if (Ack3Flag == "N") {
					if (NoAck3Flag == "Y") {
						Ack3Flag = "N";
					} else {
						Ack3Flag = "";
					}
				} else {
					Ack3Flag = "Y";
				}
				var grno = Ext.getCmp("GRNo").getValue();
				var ListParam = startDate + '^' + endDate + '^' + phaLoc + '^' + vendor + '^' + completed + '^' + paymode + '^' + accackflag + '^' + purackflag + '^' + grno + '^' + Ack3Flag;
				var Page = GridPagingToolbar.pageSize;
				DetailGrid.store.removeAll();
				DetailGrid.getView().refresh();
				MasterStore.baseParams = {
					start: 0,
					limit: Page,
					strParam: ListParam
				};
			},
			'load': function (store) {
				if (store.getCount() > 0) {
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
var nm = new Ext.grid.RowNumberer();
var MasterCm = new Ext.grid.ColumnModel([nm, {
				header: "RowId",
				dataIndex: 'RowId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "付款单号",
				dataIndex: 'payNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "采购科室",
				dataIndex: 'locDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "供应商",
				dataIndex: 'vendorName',
				width: 190,
				align: 'center',
				sortable: true,
				align: 'left'
			}, {
				header: "制单日期",
				dataIndex: 'payDate',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "制单时间",
				dataIndex: 'payTime',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "制单人",
				dataIndex: 'payUserName',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "付款金额",
				dataIndex: 'payAmt',
				width: 90,
				sortable: true,
				align: 'right'
			}, {
				header: "完成标志",
				dataIndex: 'completed',
				width: 50,
				align: 'center'
			}, {
				header: "是否财务确认",
				dataIndex: 'ack3',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: "财务确认人",
				dataIndex: 'ack3UserName',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "财务确认日期",
				dataIndex: 'ack3Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "是否采购确认",
				dataIndex: 'ack1Flag',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: "采购确认人",
				dataIndex: 'ack1UserName',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "采购确认日期",
				dataIndex: 'ack1Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "是否会计确认",
				dataIndex: 'ack2Flag',
				width: 100,
				align: 'center',
				sortable: true

			}, {
				header: "会计确认人",
				dataIndex: 'ack2UserName',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "会计确认日期",
				dataIndex: 'ack2Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "支付方式",
				dataIndex: 'payMode',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "支付票据号",
				dataIndex: 'checkNo',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "支付票据日期",
				dataIndex: 'checkDate',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "支付票据金额",
				dataIndex: 'checkAmt',
				width: 100,
				align: 'left',
				sortable: true,
				align: 'right'
			}
		]);

MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
		store: MasterStore,
		pageSize: PageSize,
		displayInfo: true
	});
var MasterGrid = new Ext.grid.GridPanel({
		region: 'center',
		title: '付款单',
		cm: MasterCm,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		store: MasterStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: GridPagingToolbar,
		listeners: {
			'rowcontextmenu': rightClickFn
		}
	});
var rightClick = new Ext.menu.Menu({
		id: 'rightClickCont',
		items: [{
				id: 'mnuDelete',
				handler: ShowRecinfo,
				text: '查看入库信息'
			}
		]
	});

//右键菜单代码关键部分
function rightClickFn(grid, rowindex, e) {
	e.preventDefault();
	grid.getSelectionModel().selectRow(rowindex);
	rightClick.showAt(e.getXY());
}
function ShowRecinfo() {
	var record = MasterGrid.getSelectionModel().getSelected();
	if (record == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	var payid = record.get("RowId");
	if (payid == "") {
		Msg.info("warning", "无效付款单");
		return;
	} else {
		payRowId = payid;
		CreateRecinfowin();
	}
}

// 添加表格单击行事件
MasterGrid.getSelectionModel().on('rowselect', function (sm, rowIndex, r) {
	var PayId = MasterStore.getAt(rowIndex).get("RowId");
	DetailStore.setBaseParam('parref', PayId)
	DetailStore.load({
		params: {
			start: 0,
			limit: GridDetailPagingToolbar.pageSize
		}
	});
});

// 转移明细
// 访问路径
var DetailUrl = URL
	 + '?actiontype=queryItem'; ; ;
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	});
// 指定列参数
var fields = ["payi", "pointer", "TransType", "INCI", "inciCode", "inciDesc", "spec", "manf", "qty",
	"uomDesc", "rp", "sp", "rpAmt", "spAmt", "OverFlag", "invNo", "invDate", "invAmt", "batNo", "ExpDate", "payAmt", "grNo"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "RowId",
		fields: fields
	});
// 数据集
var DetailStore = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
				header: "RowId",
				dataIndex: 'payi',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "入库退货Id",
				dataIndex: 'pointer',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资Id",
				dataIndex: 'INCI',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '物资代码',
				dataIndex: 'inciCode',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: '物资名称',
				dataIndex: 'inciDesc',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "规格",
				dataIndex: 'spec',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "厂商",
				dataIndex: 'manf',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "数量",
				dataIndex: 'qty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "单位",
				dataIndex: 'uomDesc',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "进价",
				dataIndex: 'rp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "售价",
				dataIndex: 'sp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "进价金额",
				dataIndex: 'rpAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "付款金额",
				dataIndex: 'payAmt',
				width: 100,
				align: 'right',
				editor: new Ext.form.NumberField({
					selectOnFocus: true
				}),
				sortable: true
			}, {
				header: "售价金额",
				dataIndex: 'spAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "结清标志",
				dataIndex: 'OverFlag',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				header: "发票号",
				dataIndex: 'invNo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "发票日期",
				dataIndex: 'invDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "发票金额",
				dataIndex: 'invAmt',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "批号",
				dataIndex: 'batNo',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "效期",
				dataIndex: 'ExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "单号(入库/退货)",
				dataIndex: "grNo",
				width: 120,
				align: "left"
			}, {
				header: "类型",
				dataIndex: 'TransType',
				width: 100,
				align: 'left',
				sortable: true
			}
		]);
var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store: DetailStore,
		pageSize: PageSize,
		displayInfo: true
	});
var DetailGrid = new Ext.ux.EditorGridPanel({
		region: 'south',
		split: true,
		height: 190,
		minSize: 200,
		maxSize: 350,
		collapsible: true,
		title: '付款单明细',
		cm: DetailCm,
		store: DetailStore,
		trackMouseOver: true,
		stripeRows: true,
		bbar: GridDetailPagingToolbar,
		loadMask: true,
		listeners: {
			'beforeedit': function (e) {
				var rec = MasterGrid.getSelectionModel().getSelected();
				if (rec.get('ack2Flag') == 'Y') {
					e.cancel = true;
				}
			},
			'afteredit': function (e) {
				if (e.field == "payAmt") {
					var payAmt = e.value
						var payi = e.record.get('payi')
						var ret = tkMakeServerCall("web.DHCSTM.DHCPayItm", "UpdateItm", payi, payAmt)
						if (ret == 0) {
							e.record.commit();
						}
				}
			}
		}
	});

var HisListTab = new Ext.ux.FormPanel({
		title: '付款单管理',
		tbar: [SearchBT, '-', ClearBT, '-', Ack3BT, '-', Ack1BT, '-', Ack2BT, '-', PrintBT],
		items: [{
				xtype: 'fieldset',
				title: '查询条件',
				layout: 'column',
				autoHeight: true,
				items: [{
						columnWidth: 0.33,
						layout: 'form',
						items: [PhaLoc, Vendor, Paymod]
					}, {
						columnWidth: 0.33,
						layout: 'form',
						items: [StartDate, EndDate, GRNo]
					}, {
						columnWidth: 0.16,
						layout: 'form',
						items: [AccAckFlag, PurAckFlag, Ack3Flag]
					}, {
						columnWidth: 0.16,
						layout: 'form',
						items: [NoAccAckFlag, NoPurAckFlag, NoAck3Flag]
					}
				]
			}
		]
	});

//===========模块主页面=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [HisListTab, MasterGrid, DetailGrid],
			renderTo: 'mainPanel'
		});
});
//===========模块主页面=============================================
