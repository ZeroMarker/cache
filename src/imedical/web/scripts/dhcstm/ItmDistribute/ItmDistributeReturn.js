// 名称: 物资退回
// 编写者: tsr
// 编写日期: 2017-02-22

var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var URL = 'dhcstm.matdispretaction.csp';

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		fieldLabel: '起始日期',
		anchor: '90%',
		value: new Date()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		fieldLabel: '截止日期',
		anchor: '90%',
		value: new Date()
	});

var InvNo = new Ext.form.TextField({
		id: 'InvNo',
		fieldLabel: '收据号',
		allowBlank: true,
		emptyText: '收据号...',
		anchor: '90%',
		selectOnFocus: true
	});

var PatNo = new Ext.form.TextField({
		id: 'PatNo',
		fieldLabel: '登记号',
		allowBlank: true,
		emptyText: '登记号...',
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				var PatNo = field.getValue();
				if (e.getKey() == e.ENTER) {
					if (PatNo != "") {
						var PatNoLen = tkMakeServerCall("web.DHCSTM.DHCMatDisp", "GetPatNoLen");
						var newPatNo = NumZeroPadding(PatNo, PatNoLen);
						Ext.getCmp("PatNo").setValue(newPatNo);
					}
				}
			}
		}
	});

var CardTypeStore = new Ext.data.Store({
		proxy: new Ext.data.HttpProxy({
			url: 'dhcstm.matdispaction.csp?actiontype=GetCardType'
		}),
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['Description', 'RowId'])
	});
CardTypeStore.load();
var CardType = new Ext.ux.ComboBox({
		id: 'CardType',
		fieldLabel: '卡类型',
		width: 180,
		listWidth: 180,
		store: CardTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		emptyText: '卡类型...',
		selectOnFocus: true,
		forceSelection: true
	});

var CardNo = new Ext.form.TextField({
		id: 'CardNo',
		fieldLabel: '卡号',
		allowBlank: true,
		emptyText: '卡号...',
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				var CardType = Ext.getCmp("CardType").getValue();
				if (CardType == "" || CardType == null) {
					Msg.info("warning", "请先选择卡类型!");
					return;
				}
				var CardNo = field.getValue();
				if (e.getKey() == e.ENTER) {
					if (CardNo != "") {
						var CardNoLen = CardType.split("^")[17];
						var newCardNo = NumZeroPadding(CardNo, CardNoLen);
						Ext.getCmp("CardNo").setValue(newCardNo);
					}
				}
			}
		}
	});

var FindBT = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			Query();
		}
	});

var MatReturnBT = new Ext.Toolbar.Button({
		text: '退回',
		tooltip: '退回',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			MatReturn();
		}
	});

var ClearBT = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '清空',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			Clear();
		}
	});

var ReadCardBT = new Ext.Button({
		text: '读卡',
		tooltip: '读卡',
		iconCls: 'page_readcard',
		handler: function () {
			ReadCardHandler();
		}
	});

function ReqReturnParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空!');
		return false;
	}
	var endDate = Ext.getCmp("endDateField").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '截止日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	endDate = endDate.format(ARG_DATEFORMAT);
	var PatNo = Ext.getCmp("PatNo").getValue();
	var DisFlag = "Y";
	var CardNo = Ext.getCmp("CardNo").getValue();
	var params = startDate + "^" + endDate + "^" + gLocId + "^" + PatNo + "^" + DisFlag + "^" + CardNo;
	return {
		"params": params
	};
}

function ReqReturnRowSelFn(grid, rowIndex, r) {
	var disp = r.get("disp");
	var params = disp + "^" + gLocId;
	MatDispReturnGrid.load({
		params: {
			params: params
		}
	});
}

var ReqReturnCm = [{
		header: 'disp',
		dataIndex: 'disp',
		width: 30,
		hidden: true
	}, {
		header: '姓名',
		dataIndex: 'patName',
		width: 80
	}, {
		header: '登记号',
		dataIndex: 'papmino',
		width: 80
	}, {
		header: '收据ID',
		dataIndex: 'prt',
		width: 30,
		hidden: true
	}, {
		header: '收据号',
		dataIndex: 'prtcode',
		width: 80
	}, {
		header: '收费日期',
		dataIndex: 'prtdate',
		width: 80
	}, {
		header: '申请人',
		dataIndex: 'refUser',
		width: 80
	}, {
		header: '申请日期',
		dataIndex: 'refDate',
		width: 80
	}
];

var ReqReturnGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'ReqReturnGrid',
		region: 'west',
		title: '退回申请列表',
		width: 260,
		split: true,
		collapsible: true,
		layout: 'fit',
		contentColumns: ReqReturnCm,
		autoLoadStore: true,
		childGrid: ["MatDispReturnGrid"],
		actionUrl: URL,
		queryAction: "QueryMatRetByReq",
		idProperty: "disp",
		paramsFn: ReqReturnParamsFn,
		editable: false,
		smType: "row",
		singleSelect: true,
		smRowSelFn: ReqReturnRowSelFn
	});

function MatDispRetParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空!');
		return false;
	}
	var endDate = Ext.getCmp("endDateField").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '截止日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	endDate = endDate.format(ARG_DATEFORMAT);
	var PatNo = Ext.getCmp("PatNo").getValue();
	var CardNo = Ext.getCmp("CardNo").getValue();
	var params = "^" + gLocId + "^" + startDate + "^" + endDate + "^" + PatNo + "^" + CardNo;
	return {
		"params": params
	};
}

var MatDispReturnCm = [{
		header: "发放记录子表id",
		dataIndex: 'dispiRow',
		width: 80,
		hidden: true
	}, {
		header: "库存项id",
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '物资代码',
		dataIndex: 'incCode',
		width: 100
	}, {
		header: '物资名称',
		dataIndex: 'incDesc',
		width: 100
	}, {
		header: '规格',
		dataIndex: 'spec',
		width: 80
	}, {
		header: '单位',
		dataIndex: 'dispUomDesc',
		width: 80
	}, {
		header: '单价',
		dataIndex: 'sp',
		width: 80
	}, {
		header: '可退回数量',
		dataIndex: 'qty',
		width: 80
	}, {
		header: '申请退回数量',
		dataIndex: 'refundQtyReq',
		width: 100
	}, {
		header: '申请退回金额',
		dataIndex: 'refundAmt',
		width: 100
	}, {
		header: '退回数量',
		dataIndex: 'retqty',
		width: 80,
		editor: new Ext.ux.NumberField({
			selectOnFocus: true,
			allowBlank: false,
			allowNegative: false,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var retqty = field.getValue();
						if (retqty == null || retqty.length <= 0) {
							Msg.info("warning", "退回数量不能为空!");
							return;
						}
						if (retqty <= 0) {
							Msg.info("warning", "退回数量不能小于或等于0!");
							return;
						}
						var cell = MatDispReturnGrid.getSelectedCell();
						var record = MatDispReturnGrid.getAt(cell[0]);
						var qty = record.get("qty")
							if (retqty > qty) {
								Msg.info("warning", "退回数量大于可退回数量!");
								return;
							}
							var retMoney = Number(record.get("sp")).mul(retqty);
						record.set("retAmt", retMoney);
					}
				}
			}
		})
	}, {
		header: '退回金额',
		dataIndex: 'retAmt',
		width: 80
	}, {
		header: '发放批号',
		dataIndex: 'batCode',
		width: 80
	}, {
		header: '退回批号',
		dataIndex: 'batCode',
		width: 80
		/*	},{
		header : '高值标志',
		dataIndex : 'hvFlag',
		width : 80
		},{
		header : '高值条码',
		dataIndex : 'barCode',
		width : 80*/
	}
];

var MatDispReturnGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'MatDispReturnGrid',
		region: 'center',
		title: '物资列表',
		layout: 'fit',
		contentColumns: MatDispReturnCm,
		actionUrl: URL,
		queryAction: "QueryMatRetItmByReq",
		idProperty: "inci",
		paramsFn: MatDispRetParamsFn,
		editable: true,
		showTBar: false,
		singleSelect: true
	});

function Query() {
	ReqReturnGrid.load();
	if (ReqReturnGrid.getCount() == 0) {
		MatDispReturnGrid.load();
	}
}

function Clear() {
	Ext.getCmp("startDateField").setValue(new Date());
	Ext.getCmp("endDateField").setValue(new Date());
	Ext.getCmp("PatNo").setValue("");
	Ext.getCmp("CardNo").setValue("");
	Ext.getCmp("InvNo").setValue("");
	MatDispReturnGrid.removeAll();
	ReqReturnGrid.removeAll();
	Common_ClearPaging(MatDispReturnGrid.getBottomToolbar());
	Common_ClearPaging(ReqReturnGrid.getBottomToolbar());
}

function MatReturn() {
	var count = MatDispReturnGrid.getCount();
	if (count <= 0) {
		Msg.info("warning", "没有要退回的明细数据!");
		return;
	}
	var data = "";
	var tempqty = 0;
	for (var i = 0; i < count; i++) {
		var record = MatDispReturnGrid.getAt(i);
		var inci = record.get("inci");
		var retqty = record.get("retqty");
		var qty = record.get("qty");
		var refundQtyReq = record.get("refundQtyReq");
		var dispiRow = record.get("dispiRow");
		if (retqty > qty) {
			Msg.info("warning", "退回数量大于发放数量!");
			return;
		}
		if (retqty > refundQtyReq) {
			Msg.info("warning", "退回数量大于申请退回数量!");
			return;
		}
		if (retqty == 0 || retqty == "") {
			continue;
		} else {
			tempqty = retqty;
		}
		if (dispiRow == "") {
			continue;
		}
		var tmp = dispiRow + "^" + inci + "^" + retqty;
		if (data == "") {
			data = tmp;
		} else {
			data = data + xRowDelim() + tmp;
		}
	}
	if (tempqty <= 0) {
		Msg.info("warning", "请填写退回数量!");
		return;
	}
	var invRowId = "";
	var url = URL + "?actiontype=MatDisReturn";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			LocId: gLocId,
			UserId: gUserId,
			data: data,
			dispiRow: dispiRow,
			invRowId: invRowId
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "退回成功!");
				MatDispReturnGrid.removeAll();
				ReqReturnGrid.removeAll();
				Query();
			} else {
				if (jsonData.info == "-4") {
					Msg.info("error", "没有可用退费申请，请重新查询")
				} else {
					Msg.info("error", "退回物资失败!")
				}
			}
		},
		scope: this
	});
}

function ReadCardHandler() {
	var CardType = Ext.getCmp("CardType").getValue();
	var CardNo = Ext.getCmp("CardNo").getValue();
	var PatNo = Ext.getCmp("PatNo").getValue();
	if (CardType == "" || CardType == null) {
		Msg.info("warning", "卡类型错误!");
		return;
	}
	var CardTypeArr = CardType.split("^");
	var CardTypeRowId = CardTypeArr[0];
	var readRet = DHCACC_GetAccInfo(CardTypeRowId, CardType);
	if (readRet == -200) {
		Msg.info("warning", "卡无效!");
		return;
	}
	var PatientNo = "",CardNo = "";
	var readRetArr = readRet.split("^");
	var readRtn = readRetArr[0];
	switch (readRtn) {
	case "0":
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1];
		Ext.getCmp("PatNo").setValue(PatientNo);
		Ext.getCmp("CardNo").setValue(CardNo);
		Query();
		break;
	case "-200":
		Msg.info("warning", "卡无效!");
		break;
	case "-201":
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1]
			Ext.getCmp("PatNo").setValue(PatientNo);
		Ext.getCmp("CardNo").setValue(CardNo);
		Query();
		break;
	default:
	}
}

function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		Msg.info("warning", "输入错误!");
		return;
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}

//===========模块主页面===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.ux.FormPanel({
			title: '物资退回',
			tbar: [FindBT, '-', MatReturnBT, '-', ClearBT],
			items: [{
					xtype: 'fieldset',
					title: '查询条件',
					layout: 'column',
					style: 'padding:5px 0px 0px 5px',
					defaults: {
						xtype: 'fieldset',
						border: false
					},
					items: [{
							columnWidth: .33,
							items: [startDateField, endDateField]
						}, {
							columnWidth: .33,
							items: [{
									xtype: 'compositefield',
									items: [CardType, ReadCardBT]
								}, CardNo]
						}, {
							columnWidth: .33,
							items: [PatNo]
						}
					]
				}
			]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, ReqReturnGrid, MatDispReturnGrid]
		});
});
//===========模块主页面===========================================
