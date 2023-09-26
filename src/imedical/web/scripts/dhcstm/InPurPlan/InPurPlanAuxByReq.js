// 名称:采购计划单----请求转移
// 编写日期:2012-06-27
//=========================定义全局变量=================================
var InRequestId = "";
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var GroupId = session['LOGON.GROUPID'];
var URL = 'dhcstm.inpurplanaction.csp';
var strParam = "";
var scgflag = "";
var gInciRowId="";
var timer = null; ///定义全局变量定时器   防止全选的时候 执行多次查询的问题
var LocField = new Ext.ux.LocComboBox({
		id: 'LocField',
		fieldLabel: '科室',
		anchor: '90%',
		listWidth: 210,
		emptyText: '科室...',
		groupId: session['LOGON.GROUPID']
	});
// 请求部门
var ReqLoc = new Ext.ux.LocComboBox({
		fieldLabel : '请求部门',
		id : 'ReqLoc',
		emptyText : '请求部门...',
		defaultLoc:{}
});	
// 物资类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		name: 'StkGrpType',
		StkType: App_StkTypeCode, //标识类组类型
		LocId: CtLocId,
		UserId: UserId,
		anchor: '90%'
	});
// 物资名称
var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'InciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});

/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var InciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(InciDesc);
		gInciRowId=inciDr;
	}	
var includeDefLoc = new Ext.form.Checkbox({
		id: 'includeDefLoc',
		fieldLabel: '包含支配科室',
		allowBlank: true
	});

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		width: 150,
		listWidth: 150,
		allowBlank: true,
		fieldLabel: '起始日期',
		anchor: '90%',
		value: new Date()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		width: 150,
		listWidth: 150,
		allowBlank: true,
		fieldLabel: '截止日期',
		anchor: '90%',
		value: new Date()
	});

var planNnmber = new Ext.form.TextField({
		id: 'planNnmber',
		fieldLabel: '单号',
		allowBlank: true,
		width: 150,
		listWidth: 150,
		emptyText: '',
		anchor: '90%',
		selectOnFocus: true
	});

//状态
var RequestStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [["", '全部'], ["C", '申领计划'], ["O", '临时请求']]
	});

var onlyRequest = new Ext.form.ComboBox({
		id: 'onlyRequest',
		fieldLabel: '单据分类',
		allowBlank: true,
		store: RequestStore,
		value: '', // 默认值"使用"
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		anchor: '90%',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

//单据转移状态
var TransStatus0 = new Ext.form.Checkbox({
		id: 'TransStatus0',
		fieldLabel: '未转移',
		allowBlank: true,
		checked: true
	});
var TransStatus1 = new Ext.form.Checkbox({
		id: 'TransStatus1',
		fieldLabel: '部分转移',
		allowBlank: true,
		checked: true
	});
var TransStatus2 = new Ext.form.Checkbox({
		id: 'TransStatus2',
		fieldLabel: '全部转移',
		allowBlank: true
	});

// 退回申请按钮
var returnDataBT = new Ext.Toolbar.Button({
		text: '退回申请',
		tooltip: '点击退回转移信息',
		iconCls: 'page_gear',
		height: 30,
		width: 70,
		handler: function () {
			returnDurgData();
		}
	});
/**
 * 退回请求单
 */
function returnDurgData() {
	var selectRow = InRequestGrid.getSelectionModel().getSelected();
	if (Ext.isEmpty(selectRow)) {
		Msg.info("warning", "请选择要退回记录!");
		return;
	}
	var reqid = selectRow.get("RowId");
	if (reqid == null || reqid == "") {
		Msg.info("warning", "请选择要退回的请求单!");
		return;
	}

	var url = DictUrl + "inrequestaction.csp?actiontype=CancelComp&req=" + reqid;
	var responsetext = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responsetext);
	if (jsonData.success == 'true') {
		// 刷新界面
		Msg.info("success", "退回申请单成功!");
		var end = InRequestDetailGridDs.getCount();
		sm1.deselectRange(0, end);
		InRequestDetailGridDs.removeAll()
		InRequestGridDs.reload()
	} else {
		Msg.info("error", "退回申请单失败!");
	}
}
// 拒绝申请按钮
var refDetailBT = new Ext.Toolbar.Button({
		text: '拒绝一条明细',
		tooltip: '点击拒绝转移信息',
		iconCls: 'page_gear',
		height: 30,
		width: 70,
		handler: function () {
			refDetail();
		}
	});
/////拒绝申请明细
function refDetail() {
	var selectRow = InRequestDetailGrid.getSelectionModel().getSelected();
	if (Ext.isEmpty(selectRow)) {
		Msg.info("warning", "请选择要拒绝的明细记录!");
		return;
	}

	var reqi = selectRow.get("RowId");
	var url = DictUrl + "inrequestaction.csp?actiontype=refuse&reqi=" + reqi;
	var responsetext = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(responsetext);
	if (jsonData.success == 'true') {
		// 刷新界面
		Msg.info("success", "拒绝申请单明细成功!");
		singleDeSelectFun(selectRow)
		InRequestDetailGrid.getStore().reload()
	} else {
		Msg.info("error", "拒绝申请单失败!");
	}
}
var find = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			var locId = Ext.getCmp('LocField').getValue();
			var startDate = Ext.getCmp('startDateField').getValue();
			if ((startDate != "") && (startDate != null)) {
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			var endDate = Ext.getCmp('endDateField').getValue();
			if ((endDate != "") && (endDate != null)) {
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var requestType = Ext.getCmp('onlyRequest').getValue();
			//strParam:供应科室RowId^起始日期^截止日期^请求单类型
			var no = Ext.getCmp('planNnmber').getValue();
			var scg = Ext.getCmp('StkGrpType').getValue();
			var ReqLocId = Ext.getCmp('ReqLoc').getValue(); //请求科室Id
			var Inci=gInciRowId;
			if(Ext.getCmp("InciDesc").getValue()==""){
				Inci="";
				gInciRowId="";
			}
			var includeDefLoc = (Ext.getCmp('includeDefLoc').getValue() == true ? 1 : 0); //是否包含支配科室
			var TransStatus0 = (Ext.getCmp('TransStatus0').getValue() == true ? 1 : 0); //是否包含支配科室
			var TransStatus1 = (Ext.getCmp('TransStatus1').getValue() == true ? 1 : 0); //是否包含支配科室
			var TransStatus2 = (Ext.getCmp('TransStatus2').getValue() == true ? 1 : 0); //是否包含支配科室
			strParam = locId + "^" + startDate + "^" + endDate + "^" + requestType + "^" + UserId
				 + "^" + no + "^" + scg + "^" + includeDefLoc + "^" + TransStatus0 + "^" + TransStatus1
				 + "^" + TransStatus2 + "^" + ReqLocId + "^" + Inci;
			InRequestGridDs.setBaseParam('strParam', strParam);

			InRequestDetailGrid.store.removeAll();
			grid.store.removeAll();
			InRequestGridDs.removeAll();
			InRequestGridDs.load({
				params: {
					start: 0,
					limit: 9999,
					sort: 'RowId',
					dir: 'desc'
				}
			});
		}
	});

var clear = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '清空',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			//Ext.getCmp('LocField').setValue("");
			//SetLogInDept(GetGroupDeptStore,'locField')
			Ext.getCmp('startDateField').setValue(new Date());
			Ext.getCmp('endDateField').setValue(new Date());
			Ext.getCmp('onlyRequest').setValue("");
			Ext.getCmp('planNnmber').setValue("");

			InRequestGrid.getStore().removeAll();
			InRequestGrid.getView().refresh();

			InRequestDetailGrid.getStore().removeAll();
			InRequestDetailGrid.getView().refresh();

			grid.getStore().removeAll();
			grid.getView().refresh();
		}
	});

var edit = new Ext.Toolbar.Button({
		text: '生成采购计划',
		tooltip: '生成采购计划',
		iconCls: 'page_edit',
		width: 70,
		height: 30,
		handler: function () {
			var OkCount = 0;
			var rowCount = gridDs.getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = gridDs.getAt(i);
				var RepQty = rowData.get('RepQty'); //标准库存
				var PurQty = accAdd(accSub(rowData.get('RepQty'), rowData.get('Locqty')), rowData.get('Qty'));
				if ((PurQty <= 0) && (RepQty != 0)) {
					var InciCode = rowData.get('IncCode');
					Ext.Msg.show({
						title: '提示',
						msg: '部分明细库存量大于标准库存,是否继续生成采购计划单!？',
						buttons: Ext.Msg.YESNO,
						fn: function (btn) {
							if (btn == 'yes') {
								CreateInpurPlan();
							}
						}
					});
					break;
				} else {
					++OkCount;
				}
				if (rowCount == OkCount) {
					CreateInpurPlan();
				}
			}
		}
	});

/**
 * 生成采购计划
 */
function CreateInpurPlan() {
	var locId = Ext.getCmp('LocField').getValue();
	var stkGrpId = Ext.getCmp('StkGrpType').getValue();
	var count = gridDs.getCount();
	var listReqId = "";
	for (var k = 0; k < count; k++) {
		if (listReqId == "") {
			listReqId = gridDs.getAt(k).get('DetailIdStr');
		} else {
			listReqId = listReqId + "^" + gridDs.getAt(k).get('DetailIdStr');
		}
	}
	if (listReqId == "") {
		Msg.info("warning", "请选择需要生成采购计划的数据!");
		return;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url: URL,
		method: 'POST',
		params: {
			actiontype: 'create',
			userId: UserId,
			locId: locId,
			listReqId: listReqId,
			stkGrpId: stkGrpId
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				window.location.href = "dhcstm.inpurplan.csp?planNnmber=" + jsonData.info + '&locId=' + locId;
			} else {
				if (jsonData.info == -1) {
					Msg.info("error", "科室或人员为空!");
				} else if (jsonData.info == -99) {
					Msg.info("error", "加锁失败!");
				} else if (jsonData.info == -2) {
					Msg.info("error", "生成计划单号失败!");
				} else if (jsonData.info == -3) {
					Msg.info("error", "生成计划单失败!");
				} else if (jsonData.info == -4) {
					Msg.info("error", "生成计划单明细失败!");
				} else if (jsonData.info == -5) {
					Msg.info("error", "插入采购计划明细和请求明细关联!");
				} else if (jsonData.info == -6) {
					Msg.info("error", "没有需要生成采购计划的明细,检查可用数量!");
				} else {
					Msg.info("error", "生成采购计划单失败!");
				}
			}
			loadMask.hide();
		},
		scope: this
	});
}

// 变换行颜色
function changeBgColor(row, color) {
	grid.getView().getRow(row).style.backgroundColor = color;
}
//=========================定义全局变量=================================
//=========================请求单主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly: true,
		listeners: {
			beforerowselect: function (sm) {
				if (sm.getCount() == 0 & gridDs.getCount() == 0) {
					scgflag = ""
				}
			}
		}
	});

//配置数据源
var InRequestGridProxy = new Ext.data.HttpProxy({
		url: URL + '?actiontype=INReqM',
		method: 'GET'
	});
var InRequestGridDs = new Ext.data.Store({
		proxy: InRequestGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, [{
					name: 'RowId'
				}, {
					name: 'ReqNo'
				}, {
					name: 'ReqLocId'
				}, {
					name: 'ReqLoc'
				}, {
					name: 'StkGrpId'
				}, {
					name: 'StkGrp'
				}, {
					name: 'Date'
				}, {
					name: 'Time'
				}, {
					name: 'User'
				}, {
					name: 'transStatus'
				}
			]),
		remoteSort: false
	});
//模型
var InRequestGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), sm, {
				header: "请求单号",
				dataIndex: 'ReqNo',
				width: 150,
				align: 'left',
				sortable: true
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
			}, {
				header: "转移状态",
				dataIndex: 'transStatus',
				width: 80,
				align: 'left',
				renderer: renderStatus,
				sortable: true
			}
		]);

function renderStatus(value) {
	var InstrfStatus = '';
	if (value == 0) {
		InstrfStatus = '未转移';
	} else if (value == 1) {
		InstrfStatus = '部分转移';
	} else if (value == 2) {
		InstrfStatus = '全部转移';
	}
	return InstrfStatus;
}

var InRequestPagingToolbar = new Ext.PagingToolbar({
		store: InRequestGridDs,
		pageSize: 999,
		displayInfo: true
	});

//表格
var InRequestGrid = new Ext.grid.EditorGridPanel({
		title: '请求单信息----<font color=blue>请选择相同类组生成一个采购计划单</font>',
		store: InRequestGridDs,
		cm: InRequestGridCm,
		trackMouseOver: true,
		height: 220,
		stripeRows: true,
		sm: sm,
		loadMask: true //,
		//bbar:[InRequestPagingToolbar]
	});
// 添加表格单击行事件
InRequestGrid.getSelectionModel().on('selectionchange', function (ssm) {
	clearTimeout(timer)
	timer = change.defer(100, this, [ssm])
});

function change(ssm) {
	var recarr = ssm.getSelections();
	var count = recarr.length;
	var reqidstr = ""
		for (i = 0; i < count; i++) {
			var rec = recarr[i];
			var reqid = rec.get('RowId');
			if (reqidstr == "") {
				reqidstr = reqid
			} else {
				reqidstr = reqidstr + "," + reqid
			}

		}
		InRequestDetailGridDs.removeAll();
	InRequestDetailGridDs.setBaseParam('parref', reqidstr);
	var LocId = Ext.getCmp('LocField').getValue();
	InRequestDetailGridDs.setBaseParam('locId', LocId);
	InRequestDetailGridDs.setBaseParam('start', 0);
	InRequestDetailGridDs.setBaseParam('limit', 9999);
	InRequestDetailGridDs.setBaseParam('sort', 'RowId');
	InRequestDetailGridDs.setBaseParam('dir', 'desc');
	InRequestDetailGridDs.load();

}
//=============请求单主信息与请求单明细二级联动===================
/*
InRequestGrid.on('cellclick',function(grid, rowIndex, columnIndex, e) {

if(sm.getCount()==0&gridDs.getCount()==0){scgflag="";};
var selectedRow = InRequestGridDs.data.items[rowIndex];
InRequestId = selectedRow.data["RowId"];
var scgdesc=selectedRow.data["StkGrp"];
if (scgflag==""||scgflag==scgdesc){
scgflag=scgdesc;
stkGrpId=selectedRow.data["StkGrpId"];
InRequestDetailGridDs.setBaseParam('parref',InRequestId);
var LocId = Ext.getCmp('LocField').getValue();
InRequestDetailGridDs.setBaseParam('locId',LocId);
InRequestDetailGridDs.setBaseParam('start',0);
InRequestDetailGridDs.setBaseParam('limit',999);
InRequestDetailGridDs.setBaseParam('sort','RowId');
InRequestDetailGridDs.setBaseParam('dir','desc');
if(columnIndex==7){
if(sm.isSelected(rowIndex)==true){
InRequestDetailGridDs.load({
callback:function(){
sm1.selectAll();
}
});
}else{
InRequestDetailGridDs.load({
callback:function(){
var end=InRequestDetailGridDs.getCount();
sm1.deselectRange(0,end);
}
});
}
}else{
InRequestDetailGridDs.load();
}
}else{
Msg.info("warning", "请选择类组相同的生成采购计划单!");
sm.deselectRow(rowIndex);
}
});
 */
//=========================请求单主信息=================================

//=========================请求单明细=============================
var sm1 = new Ext.grid.CheckboxSelectionModel({
		listeners: {
			rowselect: function (sm1, rowIndex, record) {
				singleSelectFun(record);
			},
			rowdeselect: function (sm1, rowIndex, record) {
				singleDeSelectFun(record);
			}
		}
	});

//配置数据源
var InRequestDetailGridProxy = new Ext.data.HttpProxy({
		url: URL + '?actiontype=INReqD',
		method: 'GET'
	});
var InRequestDetailGridDs = new Ext.data.Store({
		proxy: InRequestDetailGridProxy,
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, [{
					name: 'RowId'
				}, {
					name: 'IncId'
				}, {
					name: 'IncCode'
				}, {
					name: 'IncDesc'
				}, {
					name: 'Locqty'
				}, {
					name: 'ReqQty'
				}, {
					name: 'TransQty'
				}, {
					name: 'ReqUomId'
				}, {
					name: 'ReqUom'
				}, {
					name: 'RepQty'
				},
				'ConFac', {
					name: 'Brand'
				}, {
					name: 'Spec'
				}, {
					name: 'LocAvaQty'
				}
			]),
		remoteSort: true
	});

//模型
var InRequestDetailGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), sm1, {
				header: "物资代码",
				dataIndex: 'IncCode',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "物资名称",
				dataIndex: 'IncDesc',
				width: 120,
				align: 'left',
				sortable: true
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
				header: "已转移数量",
				dataIndex: 'TransQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "标准库存",
				dataIndex: 'RepQty',
				width: 100,
				align: 'right',
				sortable: true,
				hidden: true
			}, {
				header: "品牌",
				dataIndex: 'Brand',
				width: 100,
				align: 'right'
			}, {
				header: "规格",
				dataIndex: 'Spec',
				width: 100,
				align: 'right'
			}, {
				header: "本科室可用数量",
				dataIndex: 'LocAvaQty',
				width: 100,
				align: 'right'
			}
		]);

var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
		store: InRequestDetailGridDs,
		pageSize: 20,
		displayInfo: true
	});

//表格
var InRequestDetailGrid = new Ext.ux.EditorGridPanel({
		title: '请求单明细信息',
		id: 'InRequestDetailGrid',
		store: InRequestDetailGridDs,
		cm: InRequestDetailGridCm,
		trackMouseOver: true,
		height: 220,
		stripeRows: true,
		sm: sm1,
		loadMask: true,
		clicksToEdit: 1,
		deferRowRender: false
		//不适合使用分页工具条
		//	,
		//	bbar:InRequestDetailPagingToolbar
	});
//=========================请求单明细=============================

//=========================采购明细===============================
function addNewMXRow() {
	var mxRecord = Ext.data.Record.create([{
					name: 'IncId',
					type: 'int'
				}, {
					name: 'IncCode',
					type: 'string'
				}, {
					name: 'IncDesc',
					type: 'string'
				}, {
					name: 'UomId',
					type: 'int'
				}, {
					name: 'Uom',
					type: 'string'
				}, {
					name: 'Qty',
					type: 'int'
				}, {
					name: 'Rp',
					type: 'double'
				}, {
					name: 'VendorId',
					type: 'int'
				}, {
					name: 'Vendor',
					type: 'string'
				}, {
					name: 'DetailIdStr',
					type: 'string'
				}, {
					name: 'RepQty',
					type: 'double'
				}, {
					name: 'ConFac',
					type: 'double'
				}, {
					name: 'Brand',
					type: 'string'
				}, {
					name: 'Spec',
					type: 'string'
				}, {
					name: 'LocAvaQty',
					type: 'string'
				}
			]);

	var MXRecord = new mxRecord({
			IncId: '',
			IncCode: '',
			IncDesc: '',
			UomId: '',
			Uom: '',
			Qty: '',
			Rp: '',
			VendorId: '',
			Vendor: '',
			DetailIdStr: '',
			RepQty: '',
			ConFac: '',
			Brand: '',
			Spec: '',
			LocAvaQty: ''

		});

	gridDs.add(MXRecord);
}

//配置数据源
var gridProxy = new Ext.data.HttpProxy({
		url: URL,
		method: 'GET'
	});
var gridDs = new Ext.data.Store({
		proxy: gridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows'
		}, [{
					name: 'IncId'
				}, {
					name: 'IncCode'
				}, {
					name: 'IncDesc'
				}, {
					name: 'UomId'
				}, {
					name: 'Uom'
				}, {
					name: 'Locqty'
				}, {
					name: 'Qty'
				}, {
					name: 'Rp'
				}, {
					name: 'VendorId'
				}, {
					name: 'Vendor'
				}, {
					name: 'DetailIdStr'
				}, {
					name: 'ManfredId'
				}, {
					name: 'Manf'
				}, {
					name: 'RepQty'
				},
				'ConFac', {
					name: 'Brand'
				}, {
					name: 'Spec'
				}, {
					name: 'LocAvaQty'
				}
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
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "物资名称",
				dataIndex: 'IncDesc',
				width: 200,
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
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "本科室数量",
				dataIndex: 'Locqty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "本科室可用数量",
				dataIndex: 'LocAvaQty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "请求数量",
				dataIndex: 'Qty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "已转移数量",
				dataIndex: 'TransQty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "进价(入库单位)",
				dataIndex: 'Rp',
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
				header: "标准库存",
				dataIndex: 'RepQty',
				width: 100,
				align: 'right',
				sortable: true,
				hidden: true
			}, {
				header: "品牌",
				dataIndex: 'Brand',
				width: 100,
				align: 'left'
			}, {
				header: "规格",
				dataIndex: 'Spec',
				width: 100,
				align: 'left'
			}
		]);

//表格
var grid = new Ext.ux.EditorGridPanel({
		title: '采购计划单明细信息',
		id: 'grid',
		store: gridDs,
		cm: gridCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel(),
		loadMask: true,
		clicksToEdit: 1
	});

//=========================采购明细===============================
//选择请求单明细
var singleSelectFun = function (record) {
	//存在同一个明细的时候,不能允许再被添加
	var bool = false;
	//物资Id
	var IncId = record.get('IncId');
	var index = gridDs.findExact('IncId', IncId);
	//明细Id
	var rowId = record.get('RowId');
	if (gridDs.getCount() != 0) {
		if (index >= 0) {
			var arr = gridDs.getAt(index).get('DetailIdStr').split("^");
			var length = arr.length;
			for (var j = 0; j < length; j++) {
				if (arr[j] == rowId) {
					bool = true;
				}
			}
		}
	}
	if (bool == false) {
		if (index >= 0) {
			var rowData = gridDs.getAt(index);
			var NewQty = accAdd(rowData.get('Qty'),
					accDiv(accMul(record.get('ReqQty'), record.get('ConFac')), rowData.get('ConFac')));
			rowData.set("Qty", NewQty);
			var NewTransQty = accAdd(rowData.get('TransQty'),
					accDiv(accMul(record.get('TransQty'), record.get('ConFac')), rowData.get('ConFac')));
			rowData.set("TransQty", NewTransQty);
			rowData.set("DetailIdStr", rowData.get('DetailIdStr') + "^" + rowId);
			var PurQty = accAdd(accSub(rowData.get('RepQty'), rowData.get('Locqty')), rowData.get('Qty'));
			if (PurQty <= 0) {
				changeBgColor(index, "yellow");
			} else {
				changeBgColor(index, "white");
			}
		} else {
			addNewMXRow();
			var rowData = grid.getStore().getAt(gridDs.getCount() - 1);
			rowData.set("IncId", IncId);
			rowData.set("IncCode", record.get('IncCode'));
			rowData.set("IncDesc", record.get('IncDesc'));
			rowData.set("UomId", record.get('ReqUomId'));
			rowData.set("Uom", record.get('ReqUom'));
			rowData.set("ConFac", record.get("ConFac"));
			rowData.set("Locqty", record.get('Locqty'));
			rowData.set("TransQty", record.get('TransQty'));
			rowData.set("Qty", record.get('ReqQty'));
			rowData.set("RepQty", record.get('RepQty'));
			rowData.set("DetailIdStr", rowId);
			rowData.set("Brand", record.get('Brand'));
			rowData.set("Spec", record.get('Spec'));
			rowData.set("LocAvaQty", record.get('LocAvaQty'));
			var PurQty = accAdd(accSub(rowData.get('RepQty'), rowData.get('Locqty')), rowData.get('Qty'));
			if (PurQty <= 0) {
				changeBgColor(gridDs.getCount() - 1, "yellow");
			}
			//发送请求获取
			var LocId = Ext.getCmp('LocField').getValue();

			var Params = GroupId + "^" + LocId + "^" + UserId
				if (LocId != "") {
					Ext.Ajax.request({
						url: 'dhcstm.inpurplanaction.csp?actiontype=GetItmInfo&lncId=' + IncId + '&Params=' + Params,
						method: 'POST',
						waitMsg: '查询中...',
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g, "").replace(/\n/g, ""));
							if (jsonData.success == 'true') {
								var data = jsonData.info.split("^");
								rowData.set("Rp", data[8]);
								rowData.set("VendorId", data[0]);
								rowData.set("Vendor", data[1]);
								rowData.set("ManfId", data[2]);
								rowData.set("Manf", data[3]);
								//资质判断
								var vendor = data[0]
									var inci = rowData.get("IncId")
									var phmanf = data[2]
									var DataList = vendor + "^" + inci + "^" + phmanf
									Ext.Ajax.request({
										url: 'dhcstm.utilcommon.csp?actiontype=Check',
										params: {
											DataList: DataList
										},
										method: 'POST',
										waitMsg: '查询中...',
										success: function (result, request) {
											var jsonData = Ext.util.JSON.decode(result.responseText);
											if (jsonData.success == 'true') {
												if (jsonData.info != "") {
													Msg.info("warning", jsonData.info);
												}
											}
										},
										scope: this
									});
							}
						},
						scope: this
					});
				} else {
					Msg.info("error", "请选择科室!");
				}
		}
	}
};

//取消请求单明细
var singleDeSelectFun = function (record) {
	//获取物资的Id的Index
	var index = gridDs.findExact('IncId', record.get('IncId'));
	if (index >= 0) {
		var rowData = grid.getStore().getAt(index);
		var qty = accSub(rowData.get('Qty'),
				accDiv(accMul(record.get('ReqQty'), record.get('ConFac')), rowData.get('ConFac')));
		var TransQty = accSub(rowData.get('TransQty'),
				accDiv(accMul(record.get('TransQty'), record.get('ConFac')), rowData.get('ConFac')));
		if (qty == 0) {
			gridDs.remove(rowData);
		} else {
			rowData.set("Qty", qty);
			rowData.set("TransQty", TransQty);
			rowData.set("RepQty", record.get('RepQty'));
			var PurQty = accAdd(accSub(rowData.get('RepQty'), rowData.get('Locqty')), rowData.get('Qty'));
			if (PurQty <= 0) {
				changeBgColor(index, "yellow");
			}
			var rowId = record.get('RowId');
			var arr = rowData.get('DetailIdStr').split("^");
			var length = arr.length;
			var newDetailId = "";
			for (var i = 0; i < length; i++) {
				detailId = arr[i];
				if (detailId != rowId) {
					if (newDetailId == "") {
						newDetailId = detailId;
					} else {
						newDetailId = newDetailId + "^" + detailId;
					}
				}
			}
			rowData.set("DetailIdStr", newDetailId);
		}
	}
};

//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.ux.FormPanel({
			title: '采购计划-依据请求单',
			labelWidth: 80,
			tbar: [find, '-', clear, '-', refDetailBT, '-', edit],
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
							items: [LocField, StkGrpType,ReqLoc]
						}, {
							columnWidth: .2,
							xtype: 'fieldset',
							items: [startDateField, endDateField,InciDesc]
						}, {
							columnWidth: .25,
							xtype: 'fieldset',
							items: [planNnmber, onlyRequest]
						}, {
							columnWidth: .15,
							xtype: 'fieldset',
							labelWidth: 100,
							items: [includeDefLoc, TransStatus0]
						}, {
							columnWidth: .15,
							xtype: 'fieldset',
							items: [TransStatus1, TransStatus2]
						}
					]
				}
			]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, {
					region: 'west',
					width: 670,
					minSize: 400,
					maxSize: 700,
					split: true,
					collapsible: true,
					layout: 'fit',
					items: [InRequestGrid]
				}, {
					region: 'center',
					layout: 'fit',
					items: [InRequestDetailGrid]
				}, {
					region: 'south',
					height: 210,
					minSize: 200,
					maxSize: 350,
					split: true,
					layout: 'fit',
					items: [grid]
				}
			]
		});
});
//===========模块主页面===========================================
