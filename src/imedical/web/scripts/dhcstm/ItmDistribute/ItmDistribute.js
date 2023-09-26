// 名称: 材料发放
// 编写者: tsr
// 编写日期: 2016-09-09
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];

var URL = 'dhcstm.matdispaction.csp';

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
					Msg.info("warning","请先选择卡类型!");
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

var DisFlag = new Ext.form.Checkbox({
		id: 'DisFlag',
		boxLabel: '已发放',
		anchor: '90%',
		allowBlank: true
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

var DistributeBT = new Ext.Toolbar.Button({
		text: '发放',
		tooltip: '发放',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			Distribute();
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

function NeedMatDispParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var params = startDate + "^" + gLocId;
	return {
		"params": params
	};
}

function NeedMatDispRowSelFn(grid, rowIndex, r) {
	var regno = r.get("regno");
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
	var DisFlag = Ext.getCmp("DisFlag").getValue() == true ? "Y" : "N";
	var params = startDate + "^" + endDate + "^" + gLocId + "^" + regno + "^" + DisFlag;
	MatDispGrid.load({
		params: {
			params: params
		}
	});
}

var NeedMatDispCm = [{
		header: '病人id',
		dataIndex: 'patMasDR',
		width: 80,
		hidden: true
	}, {
		header: '姓名',
		dataIndex: 'patname',
		width: 80
	}, {
		header: '登记号',
		dataIndex: 'regno',
		width: 80
	}
];

var NeedMatDispGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'east',
		title: '待发材料列表',
		width: 200,
		split: true,
		collapsible: true,
		layout: 'fit',
		id: 'NeedMatDispGrid',
		contentColumns: NeedMatDispCm,
		autoLoadStore: true,
		actionUrl: URL,
		queryAction: "QueryNeedMatDisp",
		idProperty: "patMasDR",
		paramsFn: NeedMatDispParamsFn,
		editable: false,
		smType: "row",
		singleSelect: true,
		smRowSelFn: NeedMatDispRowSelFn
	});

function MatDispParamsFn() {
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
	var DisFlag = Ext.getCmp("DisFlag").getValue() == true ? "Y" : "N";
	var CardNo = Ext.getCmp("CardNo").getValue();

	var params = startDate + "^" + endDate + "^" + gLocId + "^" + PatNo + "^" + DisFlag + "^" + CardNo;
	return {
		"params": params
	};
}

function MatDispRowSelFn(grid, rowIndex, r) {
	var adm = r.get('adm');
	var prt = r.get('prt');
	var DisFlag = Ext.getCmp("DisFlag").getValue() == true ? "Y" : "N";
	var params = gLocId + "^" + adm + "^" + DisFlag + "^" +prt;
	MatDispDetailGrid.load({
		params: {
			params: params
		}
	});
}

var MatDispCm = [{
		header: 'adm',
		dataIndex: 'adm',
		width: 30,
		hidden: true
	}, {
		header: '姓名',
		dataIndex: 'patienname',
		width: 100
	}, {
		header: '登记号',
		dataIndex: 'papmino',
		width: 100
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
		width: 100
	}, {
		header: '收费时间',
		dataIndex: 'prttime',
		width: 100
	}, {
		header: '性别',
		dataIndex: 'papsex',
		width: 50
	}, {
		header: '年龄',
		dataIndex: 'perold',
		width: 60
	}, {
		header: '电话',
		dataIndex: 'tel',
		width: 120
	}, {
		header: '发放日期',
		dataIndex: 'dspdate',
		width: 100
	}, {
		header: '科室',
		dataIndex: 'patlocdesc',
		width: 100
	}, {
		header: '发放id',
		dataIndex: 'dspid',
		width: 80,
		hidden: true
	}
];

var MatDispGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		title: '发材料列表',
		layout: 'fit',
		id: 'MatDispGrid',
		childGrid: ["MatDispDetailGrid"],
		contentColumns: MatDispCm,
		actionUrl: URL,
		queryAction: "QueryMatDisp",
		idProperty: "prt",
		paramsFn: MatDispParamsFn,
		smType: "row",
		singleSelect: true,
		smRowSelFn: MatDispRowSelFn,
		editable: false
	});

var MatDispDetailCm = [{
		header: '医嘱明细id',
		dataIndex: 'orditm',
		width: 80,
		hidden: true
	}, {
		header: '库存项id',
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '物资代码',
		dataIndex: 'incicode',
		width: 100
	}, {
		header: '物资名称',
		dataIndex: 'incidesc',
		width: 100
	}, {
		header: '数量',
		dataIndex: 'qty',
		width: 80,
		align: 'right'
	}, {
		header: '单位',
		dataIndex: 'dispUomDesc',
		width: 40
	}, {
		header: '单价',
		dataIndex: 'Sp',
		width: 40
	}, {
		header: '金额',
		dataIndex: 'SpAmt',
		width: 80
	}, {
		header: '医嘱状态',
		dataIndex: 'oeflag',
		width: 80
	}, {
		header: '医师',
		dataIndex: 'orduserName',
		width: 60
	}, {
		header: '货位',
		dataIndex: 'stkbin',
		width: 80
	}, {
		header: '厂家',
		dataIndex: 'manf',
		width: 80
	}, {
		header: '库存量',
		dataIndex: 'logQty',
		width: 80,
		align: 'right'
	}, {
		header: '在途库存',
		dataIndex: 'reservedQty',
		width: 80,
		align: 'right'
	}, {
		header: '发放状态',
		dataIndex: 'dspstatus',
		width: 80,
		hidden: true
	}, {
		header: '高值标志',
		dataIndex: 'hvFlag',
		width: 80
	}, {
		header: '高值条码',
		dataIndex: 'barCode',
		width: 80
	}, {
		header: '扫描条码',
		dataIndex: 'HVBarCode',
		width: 80,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var record = MatDispDetailGrid.getSelectionModel().getSelected();
							var hvFlag = record.get("hvFlag");
							if (hvFlag == "Y") {
								var HVBarCode = field.getValue();
								if (HVBarCode == "" || HVBarCode == null) {
									Msg.info("warning", "请扫描高值条码!");
									field.focus();
									return;
								} else {
									var barCode = record.get("barCode");
									if (HVBarCode != barCode) {
										Msg.info("warning", "扫描的高值条码不匹配!");
										field.setValue("");
										field.focus();
										return;
									} else {
										Msg.info("success", "匹配成功!");
									}
								}
							}
							var count = MatDispDetailGrid.getCount();
							var row = 0;
							for (i = 0; i < count; i++) {
								if (MatDispDetailGrid.getAt(i).get("hvFlag") == "Y") {
									row = i;
									break;
								}
							}
							MatDispDetailGrid.startEditing(row, GetColIndex(MatDispDetailGrid, "HVBarCode"));
						}
					}
				}
			}))
	}
];

var MatDispDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'MatDispDetailGrid',
		region: 'south',
		title: '材料信息',
		height: 200,
		split: true,
		layout: 'fit',
		collapsible: true,
		contentColumns: MatDispDetailCm,
		actionUrl: URL,
		queryAction: "QueryMatDispDetail",
		idProperty: "orditm",
		smType: "checkbox",
		singleSelect: false,
		checkOnly: true,
		showTBar: false
	});

function Query() {
	MatDispGrid.load();
}

function CheckBeforeDo() {
	var record = MatDispGrid.getSelectionModel().getSelected();
	if (record == null) {
		Msg.info("warning", "没有选中发材料列表信息!");
		return false;
	}
	var patname = record.get("patienname");
	var papmino = record.get("papmino");
	var disStr = "";
	var rowDataArr = MatDispDetailGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "请选择需要发放的明细!");
		return false;
	}
	for (i = 0; i < rowDataArr.length; i++) {
		var rowData = rowDataArr[i];
		var incidesc = rowData.get("incidesc");
		var DisFlag = rowData.get("dspstatus");
		var warnmsgtitle = "病人姓名:" + patname + "\t" + "登记号:" + papmino + "\n";
		if (DisFlag == "1") {
			Msg.info("warning", warnmsgtitle + "的材料\t" + incidesc + "\t已经发放!");
			return false;
		}
		var hvFlag = rowData.get("hvFlag");
		if (hvFlag == "Y") {
			var HVBarCode = rowData.get("HVBarCode");
			var barCode = rowData.get("barCode");
			if (HVBarCode == "" || HVBarCode == null) {
				Msg.info("warning", "请扫描高值条码!");
				MatDispDetailGrid.startEditing(i, GetColIndex(MatDispDetailGrid, "HVBarCode"));
				return false;
			} else if (HVBarCode != barCode) {
				Msg.info("warning", "高值条码不匹配!");
				MatDispDetailGrid.startEditing(i, GetColIndex(MatDispDetailGrid, "HVBarCode"));
				return false;
			}
		}
	}
	return true;
}

function Distribute() {
	if (CheckBeforeDo() == false) {
		return;
	}
	var record = MatDispGrid.getSelectionModel().getSelected();
	DispensingMonitor(record);
}

function Clear() {
	Ext.getCmp("startDateField").setValue(new Date());
	Ext.getCmp("endDateField").setValue(new Date());
	Ext.getCmp("PatNo").setValue("");
	Ext.getCmp("CardNo").setValue("");
	Ext.getCmp("DisFlag").setValue(false);
	MatDispGrid.removeAll();
	MatDispDetailGrid.removeAll();
	NeedMatDispGrid.removeAll();
	Common_ClearPaging(MatDispGrid.getBottomToolbar());
	Common_ClearPaging(MatDispDetailGrid.getBottomToolbar());
	Common_ClearPaging(NeedMatDispGrid.getBottomToolbar());
}

function DispensingMonitor(record) {
	var patname = record.get("patienname");
	var papmino = record.get("papmino");
	var warnmsgtitle = "病人姓名:" + patname + "\t" + "登记号:" + papmino + "\n";
	var disStr = "";
	var rowDataArr = MatDispDetailGrid.getSelectionModel().getSelections();
	for (i = 0; i < rowDataArr.length; i++) {
		var rowData = rowDataArr[i];
		var orditm = rowData.get("orditm");
		if (disStr == "") {
			disStr = orditm;
		} else {
			disStr = disStr + "^" + orditm;
		}
	}
	var url = URL + "?actiontype=MatDisp";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			LocId: gLocId,
			disStr: disStr,
			UserId: gUserId
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "发放成功!");
				NeedMatDispGrid.reload();
				Query();
			} else {
				if(jsonData.info="-31"){
					Msg.info("warning", warnmsgtitle + "的材料库存不足!")
				}
				else{
					Msg.info("warning", warnmsgtitle + "的材料发放失败!")
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
	var PatientNo="",CardNo="";
	var readRetArr = readRet.split("^");
	var readRtn = readRetArr[0];
	switch (readRtn) {
	case "0":
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1];
		if(!Ext.isEmpty(PatientNo) && !Ext.isEmpty(CardNo)){
			Ext.getCmp("PatNo").setValue(PatientNo);
			Ext.getCmp("CardNo").setValue(CardNo);
			Query();
		}
		break;
	case "-200":
		Msg.info("warning", "卡无效!");
		break;
	case "-201":
		PatientNo = readRetArr[5];
		CardNo = readRetArr[1];
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
			title: '材料发放',
			tbar: [FindBT, '-', DistributeBT, '-', ClearBT],
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
							items: [PatNo, DisFlag]
						}
					]
				}
			]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, MatDispGrid, NeedMatDispGrid, MatDispDetailGrid]
		});
});
//===========模块主页面===========================================
