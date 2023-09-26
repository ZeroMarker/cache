// 名称:配送出库----请求转移
// 编写日期:2012-06-27
//=========================定义全局变量=================================
var InRequestId = "";
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var GroupId = session['LOGON.GROUPID'];
var URL = "dhcstm.inrequestaction.csp";
var urlx = "dhcstm.dhcinistrfvendormanaction.csp";
var scgflag = "";
var stkGrpId = "";
var CURRENT_DSTR = "";

var LocField = new Ext.ux.LocComboBox({
		id: 'LocField',
		fieldLabel: '科室',
		anchor: '95%',
		listWidth: 210,
		emptyText: '科室...',
		groupId: GroupId
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
		allowBlank: true,
		fieldLabel: '起始日期',
		anchor: '90%',
		value: DefaultStDate()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		allowBlank: true,
		fieldLabel: '截止日期',
		anchor: '90%',
		value: DefaultEdDate()
	});

var onlyRequest = new Ext.form.Checkbox({
		id: 'onlyRequest',
		hideLabel: true,
		boxLabel: '仅申请计划',
		allowBlank: true
	});

var PartTransfer = new Ext.form.Checkbox({
		id: 'PartTransfer',
		hideLabel: true,
		boxLabel: '部分转移',
		anchor: '90%',
		allowBlank: true
	});

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

function Query() {
	var locId = Ext.getCmp('LocField').getValue();
	if (locId == '') {
		Msg.info("error", '请选择科室!');
		Ext.getCmp('LocField').focus();
		return;
	}
	var startDate = Ext.getCmp('startDateField').getValue();
	if ((startDate != "") && (startDate != null)) {
		startDate = startDate.format(ARG_DATEFORMAT);
	}
	var endDate = Ext.getCmp('endDateField').getValue();
	if ((endDate != "") && (endDate != null)) {
		endDate = endDate.format(ARG_DATEFORMAT);
	}
	var grp = Ext.getCmp('groupField').getValue();
	if (grp == '') {
		Msg.info("error", '请选择类组!');
		Ext.getCmp('groupField').focus();
		return;
	}
	var requestType = (Ext.getCmp('onlyRequest').getValue() == true ? 'C' : "");
	var partTrans = (Ext.getCmp('PartTransfer').getValue() == true ? 'Y' : 'N');
	InRequestGridDs.setBaseParam("sort", 'RowId');
	InRequestGridDs.setBaseParam("dir", 'desc');
	InRequestGridDs.setBaseParam("StartDate", startDate);
	InRequestGridDs.setBaseParam("EndDate", endDate);
	InRequestGridDs.setBaseParam("LocId", locId);
	InRequestGridDs.setBaseParam("StkGrp", grp);
	InRequestGridDs.setBaseParam("ReqType", requestType);
	InRequestGridDs.setBaseParam("PartTrans", partTrans);
	InRequestDetailGrid.store.removeAll();
	grid.store.removeAll();
	InRequestGridDs.removeAll();
	InRequestGridDs.load({
		params: {
			start: 0,
			limit: InRequestPagingToolbar.pageSize
		}
	});
}

var clear = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '清空',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			Ext.getCmp('startDateField').setValue(new Date());
			Ext.getCmp('endDateField').setValue(new Date());
			InRequestGrid.getStore().removeAll();
			InRequestGrid.getView().refresh();
			InRequestDetailGrid.getStore().removeAll();
			InRequestDetailGrid.getView().refresh();
			grid.getStore().removeAll();
			grid.getView().refresh();
			CURRENT_DSTR = "";
			initOfDstrGrid.getStore().removeAll();
			initDetailGrid.getStore().removeAll();
		}
	});

function CheckBeforeHandle() {
	var count = gridDs.getCount();
	if (count < 1) {
		return false;
	}
	var v;
	var batNo,batReq;
	var expDate,expReq;
	var transQty;
	var reqQty;
	var qtyTransfered;
	for (var k = 0; k < count; k++) {
		v = gridDs.getAt(k).get('VendorId');
		batNo = gridDs.getAt(k).get('BatNo');
		expDate = gridDs.getAt(k).get('ExpDate');
		batReq = gridDs.getAt(k).get('batReq');
		expReq = gridDs.getAt(k).get('expReq');
		rp = gridDs.getAt(k).get('Rp');
		transQty = gridDs.getAt(k).get('TransQty');
		reqQty = gridDs.getAt(k).get('Qty');
		if (parseFloat(transQty) == 0) continue;
		if ((rp == "") || (rp <= 0)) {
			Msg.info("error", "第" + (k + 1) + "行进价不可为零！");
			return false;
		}
		if ((v == "") || (v == null)) {
			Msg.info("error", "第" + (k + 1) + "行供应商不可为空！");
			return false;
		}
		if ((batReq == 'R') && (batNo == "")) {
			Msg.info("error", "第" + (k + 1) + "行批号不可为空！");
			return false;
		}
		if ((expReq == 'R') && (expDate == "")) {
			Msg.info("error", "第" + (k + 1) + "行效期不可为空！");
			return false;
		}
		if (transQty > reqQty) {
			Msg.info("error", "第" + (k + 1) + "行配送数量超过请求数量！");
			return false;
		}
	}
	return true;
}

// 导出按钮
var ExportAllToExcelBT = new Ext.Toolbar.Button({
		text: 'Excel另存',
		tooltip: 'Excel另存',
		width: 70,
		height: 30,
		iconCls: 'page_excel',
		handler: function () {
			ExportAllToExcel(grid);
		}
	});

var distribute = new Ext.ux.Button({
		text: '配送出库',
		tooltip: '配送出库',
		iconCls: 'page_goto',
		width: 70,
		height: 30,
		handler: function () {
			if (!CheckBeforeHandle()) {
				return;
			}
			var locId = Ext.getCmp('LocField').getValue();
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			//获取存储ID，并传送数据
			Ext.Ajax.request({
				url: urlx + "?actiontype=GetStoreId",
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var storeId = jsonData.info;
						if (storeId != "") {
							/*上传数据到后台*/
							var count = gridDs.getCount();
							for (var k = 0; k < count; k++) {
								var rec = gridDs.getAt(k);
								var rowNO = k;
								var inci = rec.get('IncId');
								var batNo = rec.get('BatNo');
								if (rec.get('ExpDate') != "") {
									var expDate = rec.get('ExpDate').format(ARG_DATEFORMAT);
								} else {
									var expDate = "";
								}
								var qty = rec.get('TransQty');
								if (parseFloat(qty)==0) continue;
								var uom = rec.get('UomId');
								var vendor = rec.get('VendorId');
								var rp = rec.get('Rp');
								var sp = rec.get('Sp');
								var manf = rec.get('ManfId');
								var rqi = rec.get('DetailIdStr');
								var loc = locId;
								var stkgrpid = Ext.getCmp("groupField").getValue();

								var url = urlx + "?actiontype=StoreData" + "&storeId=" + storeId + "&rowNO=" + rowNO
									 + "&inci=" + inci + "&stkgrp=" + stkgrpid + "&batNo=" + batNo + "&expDate=" + expDate
									 + "&qty=" + qty + "&uom=" + uom + "&vendor=" + vendor + "&rp=" + rp + "&sp=" + sp
									 + "&manf=" + manf + "&rqi=" + rqi + "&loc=" + loc;

								var ret = ExecuteDBSynAccess(url);
							}
							//处理
							Ext.Ajax.request({
								url: urlx + "?actiontype=Handle&storeId=" + storeId,
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										CURRENT_DSTR = jsonData.info;
										Msg.info('success', '处理成功');
										gridDs.removeAll();
										Ext.getCmp('findreq').handler();
										loadMask.hide();
									} else {
										var errinfo = jsonData.info;
										var errMsg = "";
										switch (errinfo) {
										case '-1': {
												errMsg = "生成入库单错误！";
												break;
											}
										case '-10': {
												errMsg = "插入入库子表记录错误！";
												break;
											}
										case '-11': {
												errMsg = "入库单设置完成错误！";
												break;
											}
										case '-100': {
												errMsg = "没有生成库存转移单数据！";
												break;
											}
										case '-2': {
												errMsg = "自动审核入库单错误！";
												break;
											}
										case '-20': {
												errMsg = "没有生成入库单！";
												break;
											}
										case '-3': {
												errMsg = "生成库存转移单单错误！";
												break;
											}
										case '-30': {
												errMsg = "插入库存转移子表记录错误！";
												break;
											}
										case '-31': {
												errMsg = "处理占用库存错误！";
												break;
											}
										case '-4': {
												errMsg = "库存转移单出库审核错误！";
												break;
											}
										}
										Msg.info('error', '处理失败:' + errinfo + "<" + errMsg + ">");
										loadMask.hide();
									}

								}
							})
						}
					}
				},
				failure: function () {
					Msg.info('error', '处理失败！请通知管理员。')
					loadMask.hide();
				}
			})

		}
	});
//=========================定义全局变量=================================
//=========================请求单主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly: true,

		listeners: {
			beforerowselect: function (sm) {
				if (sm.getCount() == 0) {
					scgflag = ""
				}
			}
		}
	});

//配置数据源
var InRequestGridProxy = new Ext.data.HttpProxy({
		url: urlx + '?actiontype=ReqList',
		method: 'GET'
	});

var InRequestGridDs = new Ext.data.Store({
		proxy: InRequestGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, [
			{name:'RowId'},
			{name:'ReqNo'},
			{name:'ReqLocId'},
			{name:'ReqLoc'},
			{name:'StkGrpId'},
			{name:'StkGrp'},
			{name:'Date'},
			{name:'Time',type:'time'},
			{name:'User'}
		]),
		remoteSort: false
	});
//模型
var InRequestGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), sm, {
				header: "请求单号",
				dataIndex: 'ReqNo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: 'req',
				hidden: true,
				dataIndex: 'RowId'
			}, {
				header: "请求部门",
				dataIndex: 'ReqLoc',
				width: 130,
				align: 'left',
				sortable: true
			}, {
				header: "类组",
				dataIndex: 'StkGrp',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "制单日期",
				dataIndex: 'Date',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "制单时间",
				dataIndex: 'Time',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "制单人",
				dataIndex: 'User',
				width: 60,
				align: 'left',
				sortable: true
			}
		]);

//初始化默认排序功能
InRequestGridCm.defaultSortable = true;

var InRequestPagingToolbar = new Ext.PagingToolbar({
		store: InRequestGridDs,
		pageSize: 20,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"
	});

//表格
var InRequestGrid = new Ext.grid.EditorGridPanel({
		store: InRequestGridDs,
		cm: InRequestGridCm,
		trackMouseOver: true,
		height: 220,
		stripeRows: true,
		sm: sm,
		loadMask: true,
		autoScroll: true,
		bbar: InRequestPagingToolbar
	});
//=========================请求单主信息=================================

//=========================请求单明细=============================
var sm1 = new Ext.grid.CheckboxSelectionModel();
//配置数据源
var InRequestDetailGridProxy = new Ext.data.HttpProxy({
		url: urlx + '?actiontype=INReqD',
		method: 'GET'
	});

var InRequestDetailGridDs = new Ext.data.Store({
		proxy: InRequestDetailGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, [
			{name:'RowId'},
			{name:'IncId'},
			{name:'IncCode'},
			{name:'IncDesc'},
			{name:'spec'},
			{name:'Locqty'},
			{name:'ReqQty'},
			{name:'TransQty'},
			{name:'ReqUomId'},
			{name:'ReqUom'},
			{name:'QtyApproved'}
		]),
		remoteSort: true
	});

//模型
var InRequestDetailGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "物资名称",
				dataIndex: 'IncDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: '规格',
				dataIndex: 'spec',
				width: '80',
				align: 'left'
			}, {
				header: "单位",
				dataIndex: 'ReqUom',
				width: 50,
				align: 'left',
				sortable: true
			}, {
				header: "本科室数量",
				dataIndex: 'Locqty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "请求数量",
				dataIndex: 'ReqQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "批准数量",
				dataIndex: 'QtyApproved',
				width: 80,
				align: 'right'
			}, {
				header: "已转移数量",
				dataIndex: 'TransQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "物资代码",
				dataIndex: 'IncCode',
				width: 100,
				align: 'left',
				sortable: true
			} /*,sm1*/
		]);

//初始化默认排序功能
InRequestDetailGridCm.defaultSortable = true;

var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
		store: InRequestDetailGridDs,
		pageSize: 20,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"
	});

//表格
var InRequestDetailGrid = new Ext.grid.EditorGridPanel({
		store: InRequestDetailGridDs,
		cm: InRequestDetailGridCm,
		trackMouseOver: true,
		height: 220,
		stripeRows: true,
		bbar: InRequestDetailPagingToolbar,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		loadMask: true,
		clicksToEdit: 1,
		deferRowRender: false
	});
//=========================请求单明细=============================

var gridProxy = new Ext.data.HttpProxy({
		url: urlx + "?actiontype=SumReqItm",
		method: 'GET'
	});

var gridDs = new Ext.data.Store({
		proxy: gridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows'
		}, [
			{name:'IncId',mapping:'inci'},
			{name:'IncCode',mapping:'inciCode'},
			{name:'IncDesc',mapping:'inciDesc'},
			{name:'spec'},
			{name:'UomId',mapping:'uom'},
			{name:'Uom',mapping:'uomDesc'},
			{name:'Locqty'},
			{name:'BatNo',mapping:'batNo'},
			{name:'ExpDate',mapping:'expDate'},
			{name:'Qty'},
			{name:'TransQty'},
			{name:'Rp'},
			{name:'Sp'},
			{name:'VendorId',mapping:'vendor'},
			{name:'Vendor',mapping:'vendorName'},
			{name:'DetailIdStr',mapping:"rqi"},
			{name:'ManfId',mapping:'manf'},
			{name:'Manf',mapping:'manfName'},
			{name:'batReq'},
			{name:'expReq'},
			{name:'qtyTransfered'}
		]),
		remoteSort: false
	});

//模型
var gridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "物资Id",
				dataIndex: 'IncId',
				width: 180,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资代码",
				dataIndex: 'IncCode',
				width: 100,
				hidden: true,
				align: 'left',
				sortable: true
			}, {
				header: "物资名称",
				dataIndex: 'IncDesc',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "规格型号",
				dataIndex: 'spec',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "单位Id",
				dataIndex: 'UomId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "单位",
				dataIndex: 'Uom',
				width: 60,
				align: 'left',
				sortable: true
			}, {
				header: "本科室数量",
				dataIndex: 'Locqty',
				width: 100,
				align: 'right',
				hidden: true,
				sortable: true
			}, {
				header: "批准数量",
				dataIndex: 'Qty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "本次配送数量",
				dataIndex: 'TransQty',
				width: 80,
				align: 'right',
				sortable: true,
				editor: new Ext.form.NumberField({
					selectOnFocus: true,
					listeners: {
						'change': function () {}
					}
				})

			}, {
				header: "批号",
				dataIndex: 'BatNo',
				width: 100,
				align: 'left',
				sortable: true,
				editor: new Ext.form.TextField({})
			}, {
				header: "效期",
				dataIndex: 'ExpDate',
				width: 100,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				align: 'left',
				editor: new Ext.ux.DateField({
					selectOnFocus: true
				})
			}, {
				header: "进价",
				dataIndex: 'Rp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "已转移数量",
				dataIndex: 'qtyTransfered',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "供应商Id",
				dataIndex: 'VendorId',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "供应商",
				dataIndex: 'Vendor',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: "请求明细rowId",
				dataIndex: 'DetailIdStr',
				width: 300,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "厂商Id",
				dataIndex: 'ManfId',
				width: 200,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "厂商",
				dataIndex: 'Manf',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				header: '要求批号',
				dataIndex: 'batReq'
			}, {
				header: '要求效期',
				dataIndex: 'expReq'
			}
		]);

//初始化默认排序功能
gridCm.defaultSortable = true;
//表格
var grid = new Ext.grid.EditorGridPanel({
		store: gridDs,
		id: 'ReqItmsToTransfer',
		cm: gridCm,
		trackMouseOver: true,
		height: 260,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel(),
		loadMask: true,
		clicksToEdit: 1
	});

var tb2 = new Ext.Toolbar.Button({
		text: '请求单拒绝',
		iconCls: 'page',
		height: 30,
		width: 70,
		handler: function () {
			var reqs = getReqStr();
			if (reqs == '') {
				Msg.info("error", "请选择请求单");
				return;
			}
			Ext.Msg.show({
				title: '提示',
				msg: '是否确定拒绝？',
				buttons: Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn: function (b, txt) {
					if (b == 'no') {
						return;
					} else {
						Ext.Ajax.request({
							url: DictUrl + "inrequestaction.csp?actiontype=ProvLocDeny",
							method: 'POST',
							params: {
								reqs: reqs
							},
							success: function (response, opts) {
								var jsonData = Ext.util.JSON.decode(response.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "拒绝成功!");
									Query();
								} else {
									if (jsonData.info == -1) {
										Msg.info("warning", "该申领计划单已部分转移，不允许拒绝！");
									} else {
										Msg.info("error", "拒绝失败:" + jsonData.info);
									}
								}
							},
							failure: function (response, opts) {
								Msg.info("error", "server-side failure with status code：" + response.status);
							}

						});
					}
				}
			});
		}
	})

	var tb1 = new Ext.Toolbar.Button({
		text: '请求单汇总',
		iconCls: 'page_gear',
		height: 30,
		width: 70,
		handler: function () {
			var reqs = getReqStr();

			if (reqs == '') {
				Msg.info("error", "请选择请求单");
				return;
			}

			gridDs.load({
				params: {
					reqs: reqs
				}
			});
		}
	})

function getReqStr() {
	var rq = "";
	var st = InRequestGrid.getStore();
	Ext.getCmp('ReqItmsToTransfer').getStore().removeAll();
	var cnt = st.getCount();
	for (var i = 0; i < cnt; i++) {
		var r = st.getAt(i);
		var reqRowId = r.get('RowId');
		if (sm.isSelected(i)) {
			if (rq == '') {
				rq = reqRowId;
			} else {
				rq = rq + "," + reqRowId;
			}
		}
	}
	return rq;
}

//=============请求单主信息与请求单明细二级联动===================
InRequestGrid.on('cellclick', function (grid, rowIndex, columnIndex, e) {
	var selectedRow = InRequestGridDs.data.items[rowIndex];
	InRequestId = selectedRow.data["RowId"];
	var scgdesc = selectedRow.data["StkGrp"];
	scgflag = scgdesc;
	stkGrpId = selectedRow.data["StkGrpId"];
	InRequestDetailGridDs.proxy = new Ext.data.HttpProxy({
			url: urlx + '?actiontype=INReqD',
			method: 'GET'
		});
	InRequestDetailGridDs.setBaseParam('parref', InRequestId);
	var LocId = Ext.getCmp('LocField').getValue();
	InRequestDetailGridDs.setBaseParam('locId', LocId);
	InRequestDetailGridDs.setBaseParam('start', 0);
	InRequestDetailGridDs.setBaseParam('limit', InRequestDetailPagingToolbar.pageSize);
	InRequestDetailGridDs.setBaseParam('sort', 'RowId');
	InRequestDetailGridDs.setBaseParam('dir', 'ASC')
	InRequestDetailGridDs.load();
});
//=============请求单主信息与请求单明细二级联动===================

var initOfDstrStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: urlx + '?actiontype=GetInitOfDstr',
			method: "POST"
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['initDate', 'initTime', 'scgDesc', 'init', 'initNo', 'frLoc', 'toLoc']),
		listeners: {
			'load': function (ds) {
				initOfDstrGrid.getSelectionModel().selectFirstRow();
			}
		}
	});

var initCM = new Ext.grid.ColumnModel([{
				header: 'init',
				dataIndex: '',
				width: 100,
				hidden: true
			}, {
				header: '库存转移单号',
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
		]);

var initOfDstrGrid = new Ext.grid.GridPanel({
		id: 'initOfDstrGrid',
		store: initOfDstrStore,
		cm: initCM,
		title: '库存转移单',
		height: 200,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				'rowselect': function (sm, ind, rec) {
					var init = rec.data.init;
					var pageSize = initDetailGrid.getBottomToolbar().pageSize;
					var store = initDetailGrid.getStore();
					store.setBaseParam('Parref', init);
					store.removeAll();
					store.load({
						params: {
							start: 0,
							limit: pageSize
						},
						callback: function (r, options, success) {
							if (!success) {
								Msg.info("error", "查询有误,请查看日志!");
							}
						}
					});
				}
			}
		})
	});

var initDetailCm = new Ext.grid.ColumnModel([{
				header: "转移细项RowId",
				dataIndex: 'initi',
				width: 100,
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
				header: "批次库存",
				dataIndex: 'inclbQty',
				width: 80,
				align: 'right',
				hidden: true
			}, {
				header: "转移数量",
				dataIndex: 'qty',
				width: 80,
				align: 'right'
			}, {
				header: "单位",
				dataIndex: 'TrUomDesc',
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
				header: "请求数量",
				dataIndex: 'reqQty',
				width: 80,
				align: 'right'
			}, {
				header: "货位码",
				dataIndex: 'stkbin',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "请求方库存",
				dataIndex: 'reqLocStkQty',
				width: 100,
				align: 'right'
			}, /*{
			header : "占用数量",
			dataIndex : 'inclbDirtyQty',
			width : 80,
			align : 'right',
			sortable : true
			}, {
			header : "可用数量",
			dataIndex : 'inclbAvaQty',
			width : 80,
			align : 'right',
			sortable : true
			}, */
			{
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
		]);

var initDetailStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: 'dhcstm.dhcinistrfaction.csp?actiontype=QueryDetail',
			method: "POST"
		}),
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "initi"
		}, ["initi", "inrqi", "inci", "inciCode",
				"inciDesc", "inclb", "batexp", "manf", "manfName",
				"qty", "uom", "sp", "status", "remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec", "gene", "form", "newSp",
				"spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc"])
	});

var initDetailGrid = new Ext.grid.GridPanel({
		id: 'initDetailGrid',
		store: initDetailStore,
		cm: initDetailCm,
		title: '转移明细',
		height: 200,
		bbar: new Ext.PagingToolbar({
			store: initDetailStore,
			pageSize: 20,
			displayInfo: true
		})
	});

//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var formPanel = new Ext.form.FormPanel({
			region: 'north',
			title: '配送出库-依据请求单',
			autoHeight: true,
			labelWidth: 60,
			labelAlign: 'right',
			frame: true,
			tbar: [find, '-', clear, '-', tb1, '-', tb2, '-', distribute, '-', ExportAllToExcelBT],
			items: [{
					layout: 'column',
					xtype: 'fieldset',
					title: '查询条件',
					defaults: {
						border: false,
						xtype: 'fieldset'
					},
					style: 'padding:5px 0px 0px 5px',
					items: [{
							columnWidth: .2,
							items: [LocField]
						}, {
							columnWidth: .18,
							items: [startDateField]
						}, {
							columnWidth: .18,
							items: [endDateField]
						}, {
							columnWidth: .2,
							items: [groupField]
						}, {
							columnWidth: .12,
							items: [PartTransfer]
						}, {
							columnWidth: .12,
							items: [onlyRequest]
						}
					]
				}
			]
		});

	var tp = new Ext.TabPanel({
			activeTab: 0,
			items: [{
					title: '配送出库汇总信息',
					layout: 'fit',
					items: grid
				}, {
					title: '本次配送',
					id: 'distributed',
					layout: 'border',
					items: [{
							region: 'north',
							height: 200,
							items: initOfDstrGrid
						}, {
							region: 'center',
							layout: 'fit',
							items: initDetailGrid
						}
					]
				}
			],
			listeners: {
				'tabchange': function (t, p) {
					if (p.getId() == 'distributed') {
						if (CURRENT_DSTR != "") {
							initOfDstrGrid.getStore().load({
								params: {
									dstr: CURRENT_DSTR
								}
							})
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
					title: '请求单',
					//minSize:150,
					//maxSize:300,
					split: true,
					collapsible: true,
					layout: 'border',
					items:
					[{
							region: 'north',
							layout: 'fit',
							height: 200,
							items: InRequestGrid
						}, {
							region: 'center',
							layout: 'fit',
							items: InRequestDetailGrid
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
