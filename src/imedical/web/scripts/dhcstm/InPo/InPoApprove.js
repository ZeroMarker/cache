// /名称: 订单验收
// /描述: 订单验收
// /编写者：zhangdongmei
// /编写日期: 2012.10.08
var InPoParamObj = GetAppPropValue('DHCSTPOM');
var gGroupId = session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '科室',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%',
		groupId: gGroupId
	});
// 登录设置默认值
SetLogInDept(PhaLoc.getStore(), "PhaLoc");
var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '请求部门',
		id: 'RequestPhaLoc',
		name: 'RequestPhaLoc',
		anchor: '90%',
		width: 120,
		emptyText: '请求部门...',
		defaultLoc: {}
	});
// 起始日期
var StartDate = new Ext.ux.DateField({
		fieldLabel: '起始日期',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		value: new Date().add(Date.DAY,  - 7)
	});
// 截止日期
var EndDate = new Ext.ux.DateField({
		fieldLabel: '截止日期',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		value: new Date()
	});

var inpoNoField = new Ext.form.TextField({
		id: 'inpoNoField',
		fieldLabel: '订单号',
		allowBlank: true,
		emptyText: '订单号...',
		anchor: '90%',
		selectOnFocus: true
	});
// 物资名称
var InciDesc = new Ext.form.TextField({
		fieldLabel: '物资名称',
		id: 'InciDesc',
		name: 'InciDesc',
		anchor: '90%',
		width: 150,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});
var IncId = new Ext.form.TextField({
		fieldLabel: '物资名称',
		id: 'IncId',
		name: 'IncId',
		hidden: true
	});
/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
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
	var InciDesc = record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);
	Ext.getCmp("IncId").setValue(inciDr);
}
// 供应商
var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel: '供应商',
		id: 'apcVendorField',
		name: 'apcVendorField',
		anchor: '90%',
		emptyText: '供应商...'
	});

var approveStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['0', '全部'], ['1', '验收通过'], ['2', '验收不通过'], ['3', '未验收']]
	});

var approveflag = new Ext.form.ComboBox({
		fieldLabel: '验收状态',
		id: 'approveflag',
		name: 'approveflag',
		anchor: '90%',
		width: 120,
		store: approveStore,
		triggerAction: 'all',
		mode: 'local',
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: true,
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		editable: true,
		valueNotFoundText: ''
	});
Ext.getCmp("approveflag").setValue("3");
var includeDefLoc = new Ext.form.Checkbox({
		id: 'includeDefLoc',
		hideLabel: true,
		boxLabel: '包含支配科室',
		anchor: '90%',
		width: 150,
		checked: true,
		allowBlank: true
	});
var includeCancelInPo = new Ext.form.Checkbox({
		id: 'includeCancelInPo',
		hideLabel: true,
		boxLabel: '包含已取消订单',
		anchor: '90%',
		width: 150,
		checked: false,
		allowBlank: true
	});
// 订单取消原因
var CauseField = new Ext.ux.ComboBox({
	id:'CauseField',
	fieldLabel:'取消原因',
	emptyText:'订单取消原因...',
	anchor:'90%',
	allowBlank:true,
	store:ReasonForCancelInPoStore
});
// 当页条数 
var NumAmount = new Ext.form.TextField({
	emptyText : '当页条数',
	id : 'NumAmount',
	name : 'NumAmount',
	anchor : '90%',
	disabled:true,
	width:200
});	
// 进价合计
var RpAmount = new Ext.form.TextField({
	emptyText : '进价合计',
	id : 'RpAmount',
	name : 'RpAmount',
	anchor : '90%',
	disabled:true,
	width : 200
});
//合计
function GetAmount(){
	var rpAmt=0,spAmt=0;
	var Count = DetailGrid.getStore().getCount();
	for(var i=0; i<Count; i++){
		var rowData = DetailStore.getAt(i);
		var qty = Number(rowData.get("PurQty"));
		var Rp = Number(rowData.get("Rp"));
		var rpAmt1=Rp.mul(qty);
		rpAmt=rpAmt.add(rpAmt1);
	}
	var	rpAmt=rpAmt.toFixed(2);
	Count="当前条数:"+" "+Count;
	rpAmt="进价合计:"+" "+rpAmt+" "+"元";
	Ext.getCmp("NumAmount").setValue(Count);
	Ext.getCmp("RpAmount").setValue(rpAmt);

}
// 入库单号
var SxNo = new Ext.form.TextField({
		fieldLabel: '随行条码',
		id: 'SxNo',
		name: 'SxNo',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var SxNo = Ext.getCmp("SxNo").getValue();
					//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
					var mianinfo = tkMakeServerCall("web.DHCSTM.SCI.Web.DHCSTMDataExchangeSCM", "GetPoMainInfo", SxNo);
					var arrinfo = mianinfo.split("^")
						inpoNoField.setValue(arrinfo[0])
						Query();
				}
			}
		}
	});
// 查询订单按钮
var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '查询',
		tooltip: '点击查询订单',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			Query();
		}
	});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
		id: "ClearBT",
		text: '清空',
		tooltip: '点击清空',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			clearData();
		}
	});
// 打印订单按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '点击打印订单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的订单!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var DhcIngr=record.get("PoId");
					//var HVflag=GetCertDocHVFlag(DhcIngr,"G");
					
					PrintInPo(DhcIngr);
					
				}
			}
});

var cancelBt = new Ext.Toolbar.Button({
		id: "cancelBT",
		text: '验收不通过',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			approve("N")
		}
	})
	var cancelInPoBt = new Ext.Toolbar.Button({
		id: "cancelInPoBt",
		text: '取消订单',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			cancelInPo();
		}
	})
	// 验收
	var ApproveBT = new Ext.Toolbar.Button({
		id: "ApproveBT",
		text: '验收通过',
		tooltip: '验收通过',
		width: 70,
		height: 30,
		iconCls: 'page_goto',
		handler: function () {
			approve("Y")
		}
	});

function approve(flag) {

	var recarr = MasterGrid.getSelectionModel().getSelections();
	var count = recarr.length;
	if (count == 0) {
		Msg.info("warning", "请选择处理的订单!");
		return
	};
	var poistr = "";
	for (i = 0; i < count; i++) {
		var rec = recarr[i];
		var poi = rec.get('PoId');
		var Approveed = rec.get('Approveed');
		if (Approveed != "") {
			Msg.info("warning", "存在已经验收单据，不能重复验收!");
			return;
		};
		if (poistr == "") {
			poistr = poi;
		} else {
			poistr = poistr + ',' + poi;
		}
	}
	var url = DictUrl + "inpoaction.csp?actiontype=Approve";
	Ext.Ajax.request({
		url: url,
		params: {
			poistr: poistr,
			user: userId,
			flag: flag
		},
		method: 'POST',
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var ret = jsonData.info;
				Msg.info("success", "成功!");
				MasterStore.reload();
			} else {
			  if (jsonData.info == -1) {
			      Msg.info("error", "此单据没有完成，不能验收!");
				} else {
				     if(jsonData.info == -4){
				     Msg.info("error", "此单据已取消!");
					}else
					 Msg.info("error", jsonData.info);
				}

			}
		},
		scope: this
	});
}
/**
 * 订单取消操作
 * @param {} flag
 */
function cancelInPo() {

	var recarr = MasterGrid.getSelectionModel().getSelections();
	var count = recarr.length;
	if (count == 0) {
		Msg.info("warning", "请选择处理的订单!");
		return;
	};
	var cancelreason = Ext.getCmp('CauseField').getValue();
	if(Ext.isEmpty(cancelreason)){
		Msg.info("error","请选择取消原因!");
		return false;
	}
	var poistr = "";
	for (i = 0; i < count; i++) {
		var rec = recarr[i];
		var poi = rec.get('PoId');
		var CancelReason = rec.get('CancelReason');
		if(!Ext.isEmpty(CancelReason)){
			var PoNo = rec.get('PoNo');
			Msg.info('warning', PoNo + '已经取消!');
			return;
		}
		if (poistr == "") {
			poistr = poi;
		} else {
			poistr = poistr + ',' + poi;
		}
	}
	var url = DictUrl + "inpoaction.csp?actiontype=CancelInPo";
	Ext.Ajax.request({
		url: url,
		params: {
			poistr: poistr,
			user: userId,
			cancelreason:cancelreason
		},
		method: 'POST',
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var ret = jsonData.info;
				Msg.info("success", "成功!");
				MasterStore.reload();
			} else {
				if (jsonData.info == -1) {
					Msg.info("error", "该订单处于未完成状态，请先进行完成操作!");
				} else if (jsonData.info == -2) {
					Msg.info("error", "此单据已经入库不能取消订单!");
				} else if (jsonData.info == -10) {
					Msg.info("error", "此单据已经取消!不能重复取消");
				} else {
					Msg.info("error", jsonData.info);
				}

			}
		},
		scope: this
	});
}

/**
 * 清空方法
 */
function clearData() {
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	Ext.getCmp("apcVendorField").setValue("");
	Ext.getCmp("inpoNoField").setValue("");
	Ext.getCmp("IncId").setValue("");
	Ext.getCmp("InciDesc").setValue("");
	Ext.getCmp("approveflag").setValue("3");
	Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY,  - 7));
	Ext.getCmp('EndDate').setValue(new Date());
	Ext.getCmp("RequestPhaLoc").setValue("");
	Ext.getCmp("SxNo").setValue("");
	Ext.getCmp("includeDefLoc").setValue(true);
	Ext.getCmp("includeCancelInPo").setValue(false);
	Ext.getCmp('CauseField').setValue("");
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();

}

// 显示订单数据
function Query() {
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == '' || phaLoc.length <= 0) {
		Msg.info("warning", "请选择订购部门!");
		return;
	}
	var startDate = Ext.getCmp("StartDate").getValue();
	/*if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空');
		return false;
	}*/
	if (startDate!=""){startDate = startDate.format(ARG_DATEFORMAT);}
	var endDate = Ext.getCmp("EndDate").getValue();
	/*if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '截止日期不可为空');
		return false;
	}*/
	if (endDate!=""){endDate = endDate.format(ARG_DATEFORMAT);}
	var venDesc = Ext.getCmp("apcVendorField").getValue();
	if (venDesc == "") {
		Ext.getCmp("apcVendorField").setValue("");
	}
	var Vendor = Ext.getCmp("apcVendorField").getValue();
	var PoNo = Ext.getCmp('inpoNoField').getValue();
	var Status = '';
	var AuditFlag = Ext.getCmp('approveflag').getValue();

	var inciDesc = Ext.getCmp("InciDesc").getValue();
	if (inciDesc == "") {
		Ext.getCmp("IncId").setValue("");
	}
	var InciId = Ext.getCmp("IncId").getRawValue();
	var includeDefLoc = (Ext.getCmp('includeDefLoc').getValue() == true ? 1 : 0); //是否包含支配科室
	var includeCancelInPo = (Ext.getCmp('includeCancelInPo').getValue() == true ? 'Y' : 'N');
	var RequestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
	//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^物资id
	var ListParam = startDate + '^' + endDate + '^' + PoNo + '^' + Vendor + '^' + phaLoc + '^' + '' + '^' + AuditFlag + '^' + Status + '^' + InciId + '^' + includeDefLoc + '^' + RequestPhaLoc + '^^^' + includeCancelInPo;
	var Page = GridPagingToolbar.pageSize;
	MasterStore.setBaseParam('ParamStr', ListParam);
	MasterStore.load({
		params: {
			start: 0,
			limit: Page
		}
	});
}
// 显示订单明细数据
function getDetail(Parref) {
	if (Parref == null || Parref == '') {
		return;
	}
	DetailStore.load({
		params: {
			start: 0,
			limit: 999,
			Parref: Parref
		}
	});
}

function renderPoStatus(value) {
	var PoStatus = '';
	if (value == "Y") {
		PoStatus = '验收通过';
	} else if (value == "N") {
		PoStatus = '验收不通过';
	} else {
		PoStatus = '未验收';
	}
	return PoStatus;
}
// 访问路径
var MasterUrl = DictUrl + 'inpoaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
		url: MasterUrl,
		method: "POST"
	});
// 指定列参数
var fields = ["PoId", "PoNo", "PoLoc", "Vendor", "PoStatus", "PoDate", "PurUserId", "StkGrpId", "VenId", "CmpFlag", "Approveed", "ApproveedUser", "ApproveedDate", "ReqLocDesc","CancelReasonId","CancelReason"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "PoId",
		fields: fields
	});
// 数据集
var MasterStore = new Ext.data.Store({
		proxy: proxy,
		reader: reader,
		listeners: {
			'load': function (ds) {
				DetailGrid.store.removeAll();
				DetailGrid.getView().refresh();
			}
		}
	});
var nm = new Ext.grid.RowNumberer();
var sm1 = new Ext.grid.CheckboxSelectionModel({});
var MasterCm = new Ext.grid.ColumnModel([nm, sm1, {
				header: "RowId",
				dataIndex: 'PoId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "订单号",
				dataIndex: 'PoNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "订购科室",
				dataIndex: 'PoLoc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "请求科室",
				dataIndex: 'ReqLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "供应商",
				dataIndex: 'Vendor',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "验收状态",
				dataIndex: 'Approveed',
				width: 90,
				align: 'left',
				sortable: true,
				renderer: renderPoStatus
			}, {
				header: "订单日期",
				dataIndex: 'PoDate',
				width: 80,
				align: 'right',
				sortable: true
			}, {

				header: "验收人",
				dataIndex: 'ApproveedUser',
				width: 80,
				align: 'right',
				sortable: true
			}, {

				header: "验收日期",
				dataIndex: 'ApproveedDate',
				width: 80,
				align: 'right',
				sortable: true
			},	{
				header: "取消原因",
				dataIndex: 'CancelReason',
				width: 80,
				align: 'left',
				sortable: true
			}

		]);
var GridPagingToolbar = new Ext.PagingToolbar({
		store: MasterStore,
		pageSize: PageSize,
		displayInfo: true
	});
var MasterGrid = new Ext.grid.GridPanel({
		region: 'west',
		title: '订单',
		collapsible: true,
		split: true,
		layout: 'fit',
		width: 400,
		minSize: 200,
		maxSize: 550,
		cm: MasterCm,
		sm: sm1,
		store: MasterStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: GridPagingToolbar
	});

MasterGrid.getSelectionModel().on('rowselect', function (sm, rowIndex, rec) {
	var CancelReasonId = rec.get('CancelReasonId');
	var CancelReason = rec.get('CancelReason');
	addComboData(null, CancelReasonId, CancelReason, CauseField);
	Ext.getCmp('CauseField').setValue(CancelReasonId);
	var PoId = rec.get("PoId");
	var Size = DetailPagingToolbar.pageSize;
	DetailStore.setBaseParam('Parref', PoId);
	DetailStore.load({
		params: {
			start: 0,
			limit: Size
		}
	});
});
MasterGrid.getSelectionModel().on('rowdeselect', function(sm, rowIndex, rec) {
	Ext.getCmp('CauseField').setValue('');
});
// 订单明细
// 访问路径
var DetailUrl = DictUrl +
	'inpoaction.csp?actiontype=QueryDetail';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	});
// 指定列参数
//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
var fields = ["PoItmId", "IncId", "IncCode", "IncDesc", "PurUomId", "PurUom", "NotImpQty", "Rp", "PurQty", "ImpQty", "CerNo", "CerExpDate", "Cancleflag"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "PoItmId",
		fields: fields
	});
var DetailStore = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
var DetailPagingToolbar = new Ext.PagingToolbar({
		store: DetailStore,
		pageSize: PageSize,
		displayInfo: true,
		displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg: "没有记录"
	});

var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
				header: "订单明细id",
				dataIndex: 'PoItmId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资RowId",
				dataIndex: 'IncId',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '物资代码',
				dataIndex: 'IncCode',
				width: 80,
				align: 'left',
				renderer: Ext.util.Format.InciPicRenderer('IncId'),
				sortable: true
			}, {
				header: '物资名称',
				dataIndex: 'IncDesc',
				width: 230,
				align: 'left',
				sortable: true
			}, {
				header: "注册证号",
				dataIndex: 'CerNo',
				width: 240,
				align: 'left',
				sortable: true
			}, {
				header: "注册证效期",
				dataIndex: 'CerExpDate',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "单位",
				dataIndex: 'PurUom',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "进价",
				dataIndex: 'Rp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "订购数量",
				dataIndex: 'PurQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "到货数量",
				dataIndex: 'ImpQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "未到货数量",
				dataIndex: 'NotImpQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "是否撤销",
				dataIndex: 'Cancleflag',
				width: 80,
				align: 'left',
				sortable: true
			}
		]);
var rightClick = new Ext.menu.Menu({
		id: 'rightClick',
		items: [{
				id: 'Pack',
				handler: PackLink,
				text: '包明细'
			}, {
				id: 'Approve',
				handler: DenyDetail,
				text: '撤销'
			}
		]
	});
function PackLink(item, e) {
	var Record = DetailGrid.getSelectionModel().getSelected();
	var PackrowId = Record.get("IncId");
	PackLink(PackrowId);

}
function DenyDetail() {
	var rowData = DetailGrid.getSelectionModel().getSelected();
	if (rowData == null) {
		Msg.info("warning", "请选择明细!");
		return;
	}
	var inppi = rowData.get('PoItmId');
	var url = DictUrl + "inpoaction.csp?actiontype=DenyDetail";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '查询中...',
		params: {
			RowIdStr: inppi
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				var Ret = jsonData.info;
				if (Ret == 0) {
					Msg.info("success", "成功!");
					DetailGrid.getStore().reload();
				}
				if (Ret == -1) {
					Msg.info("error", "单据已经入库 不能处理!");
				} else if (Ret == -2) {
					Msg.info("error", "已处理,不能重复处理!");
				}
			}
		},
		scope: this
	});
}

var DetailGrid = new Ext.ux.GridPanel({
		id: 'DetailGrid',
		//region: 'center',
		title: '订单明细',
		cm: DetailCm,
		tbar: [NumAmount,RpAmount],
		store: DetailStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		bbar: DetailPagingToolbar,
		listeners: {
			'rowcontextmenu': function (grid, rowindex, e) {
				e.preventDefault();
				grid.getSelectionModel().selectRow(rowindex);
				rightClick.showAt(e.getXY());
			}
		}
	});
DetailGrid.getView().on('refresh',function(grid){
	GetAmount();
});
// 访问路径
var DetailUrl =DictUrl+
	'sciaction.csp?actiontype=getOrderDetail';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
		});
// 指定列参数
var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
		 "ManfId", "Manf", "Sp","BatNo",{name:'ExpDate',type:'date',dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
		 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag","BarCode","OrderDetailSubId"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			fields : fields
		});
// 数据集
var SciPoDetailStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			pruneModifiedRecords:true
		});
var sm2=new Ext.grid.CheckboxSelectionModel({
		listeners : {
			beforerowselect :function(sm,rowIndex,keepExisting ,record  ) {
			}
		}
})
var nm = new Ext.grid.RowNumberer();
var SciPoDetailCm = new Ext.grid.ColumnModel([nm,sm2,{
			header : "订单明细id",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "物资RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '具体规格',
			dataIndex : 'SpecDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '高值标志',
			dataIndex : 'HighValueFlag',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "数量",
			dataIndex : 'AvaBarcodeQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "售价",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			
			sortable : true
		},{
			header : "订购数量",
			dataIndex : 'PurQty',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "已入库数量",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "已生成数量",
			dataIndex : 'BarcodeQty',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "注册证号码",
			dataIndex : 'CerNo',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "注册证效期",
			dataIndex : 'CerExpDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "条码",
			dataIndex : 'BarCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "批号",
			dataIndex : 'BatNo',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "效期",
			dataIndex : 'ExpDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "生成日期",
			dataIndex : 'BarCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "OrderDetailSubId",
			dataIndex : 'OrderDetailSubId',
			width : 80,
			align : 'left',
			hidden : true
		}, {
			header : "RefuseReason",
			dataIndex : 'RefuseReason',
			width : 80,
			align : 'left',
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : true
			}))
		}]);
/// 拒绝收货
var RefuseInPoiBT = new Ext.Toolbar.Button({
		id : "RefuseInPoiBT",
		text : '拒绝收货',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			    var rowDataArr=SciPoDetailGrid.getSelectionModel().getSelections();
			    var rowcount=rowDataArr.length;
				if (Ext.isEmpty(rowDataArr)) {
					Msg.info("warning", "请选择需要拒绝的明细!");
					return false;
				}
				var OrderDetailSubIdStr="";
				var count=0;
				for (var i=0;i<rowcount;i++){
					var rowData=rowDataArr[i];
					var OrderDetailSubId = rowData.get("OrderDetailSubId");
					var RefuseReason=rowData.get("RefuseReason");
					if (RefuseReason==""){count=count+1;}
					if (OrderDetailSubIdStr==""){
						OrderDetailSubIdStr=OrderDetailSubId+"@"+RefuseReason;
					}else{
						OrderDetailSubIdStr=OrderDetailSubIdStr+"^"+OrderDetailSubId+"@"+RefuseReason;
					}
				}
				if (count>0){
					Msg.info("warning", "请填写拒绝原因!");
					return false;
				}
				if (OrderDetailSubIdStr=="") {
					Msg.info("warning", "请选择需要拒绝的明细!");
					return false;
				}
				Refuseinpoi("N",OrderDetailSubIdStr);
			
		}
});
function Refuseinpoi(type,OrderDetailSubIdStr){
 	var Refuseurl = DictUrl
                + "inpoaction.csp?actiontype=Refuseinpoi";
        var loadMask=ShowLoadMask(Ext.getBody(),"发送中...");
        Ext.Ajax.request({
                    url : Refuseurl,
                    method : 'GET',
                    params:{Type:type,OrderDetailSubIdStr:OrderDetailSubIdStr},
                    waitMsg : '处理中...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON
                                .decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success","消息发送成功！");
                        }else{
                            var retinfo=jsonData.info;
                            Msg.info("success","消息发送失败:"+retinfo);
                        }
                        
                    },
                    scope : this
                });
        loadMask.hide();
}
var SciPoDetailGrid = new Ext.ux.EditorGridPanel({
			id:'SciPoDetailGrid',
			cm : SciPoDetailCm,
			store : SciPoDetailStore,
			sm:sm2,
			tbar:new Ext.Toolbar({items:[RefuseInPoiBT]}),
			clicksToEdit:1
		});

function QuerySci(){
		var SxNo = Ext.getCmp("SxNo").getValue();
		var HVFlag = "";
		var mask = ShowLoadMask(Ext.getBody(), "处理中请稍候...");
		Ext.Ajax.request({
			url: 'dhcstm.sciaction.csp?actiontype=getOrderDetail',
			params: {SxNo : SxNo, HVFlag : HVFlag},
			waitMsg: '处理中...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				mask.hide();
				if(!Ext.isEmpty(jsonData)){
					if(!Ext.isEmpty(jsonData['Main']) && !Ext.isEmpty(jsonData['Detail'])){
						if(jsonData['Detail']['results'] > 0){
							Ext.getCmp("inpoNoField").setValue(jsonData['Main'].SCIPoNo);
							SciPoDetailGrid.getStore().loadData(jsonData['Detail']);
							Ext.getCmp("StartDate").setValue("");
							Ext.getCmp("EndDate").setValue("");
							Ext.getCmp("approveflag").setValue(0);
							Query();
						}else{
							Msg.info('warning', '未找到符合的单据明细!');
						}
					}else{
						Msg.info('warning', '该单据已处理!');
					}
				}else{
					Msg.info("warning", "未找到符合的单据!");
				}
			},
			scope: this
		});
	}
// 随行单号
var SxNo = new Ext.form.TextField({
		fieldLabel: '随行条码',
		id: 'SxNo',
		name: 'SxNo',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					QuerySci();
				}
			}
		}
	});

var HisListTab = new Ext.ux.FormPanel({
		region: 'north',
		autoHeight: true,
		title: '订单验收',
		tbar: [SearchBT, '-', ClearBT, '-', ApproveBT, '-', cancelBt, '-', cancelInPoBt,'-',PrintBT],
		items: [{
				xtype: 'fieldset',
				title: '查询信息',
				layout: 'column',
				items: [{
						columnWidth: .3,
						layout: 'form',
						items: [PhaLoc, apcVendorField, RequestPhaLoc]
					}, {
						columnWidth: .25,
						layout: 'form',
						items: [StartDate, EndDate, approveflag]
					}, {
						columnWidth: .25,
						layout: 'form',
						items: [inpoNoField, InciDesc, SxNo]
					}, {
						columnWidth: .2,
						layout: 'form',
						labelWidth: 60,
						items: [includeDefLoc, includeCancelInPo,CauseField]
					}
				]

			}
		]

	});

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var SciPoDetailPanel=new Ext.Panel({
			title:"随行单明细",
			id:"SciPoDetailPanel",
			layout:"fit",
			items:SciPoDetailGrid
	});
	var InpoTabPanel = new Ext.TabPanel({
		id:"SXTabPanel",
		activeTab:0,
		height: gGridHeight,
		region: 'center',
		items:[DetailGrid,SciPoDetailPanel],
		listeners:{}
	});
	new Ext.ux.Viewport({
		layout: 'border',
		items: [HisListTab, MasterGrid,InpoTabPanel]
	});
});
