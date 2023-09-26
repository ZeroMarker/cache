// 名称: 住院材料医嘱扣库存
// 编写者: lihui
// 编写日期: 20180630
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];

var URL = 'dhcstm.dhcipmatdispaction.csp';

var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '病区',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '病区...',
	groupId:gGroupId
});
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
						Ext.Ajax.request({
							url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
							params : {regno : newPatNo},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									var value = jsonData.info;
									var arr = value.split("^");
									//基础信息
									field.setValue(arr[0]);
									Ext.getCmp('RegnoDetail').setValue(arr.slice(1));
								}
							},
							scope: this
						});
					}
				}
			}
		}
	});
var RegnoDetail = new Ext.form.TextField({
		fieldLabel : '登记号信息',
		id : 'RegnoDetail',
		disabled:true,
		anchor : '90%'
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
		text: '确认',
		tooltip: '确认',
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

function MatDispParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	var endDate = Ext.getCmp("endDateField").getValue();
	var PatNo = Ext.getCmp("PatNo").getValue();
	if ((Ext.isEmpty(PatNo))&&(Ext.isEmpty(startDate))) {
		Msg.info('warning', '登记号为空时候起始日期不可为空!');
		return false;
	}
	if ((Ext.isEmpty(PatNo))&&(Ext.isEmpty(endDate))) {
		Msg.info('warning', '登记号为空时候截止日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	endDate = endDate.format(ARG_DATEFORMAT);
	var Locid = Ext.getCmp("LocField").getValue();
	if (Ext.isEmpty(Locid)){Locid =gLocId;}

	var params = Locid + "^" + startDate + "^" + endDate + "^" +PatNo;
	return {
		"params": params
	};
}

var MatDispDetailCm = [{
		header: '执行记录id',
		dataIndex: 'DSPRowId',
		width: 80,
		hidden: true 
	},{
		header: '医嘱明细id',
		dataIndex: 'orditm',
		width: 80,
		hidden: true
	},{
		header: '要求执行时间',
		dataIndex: 'exestdatetime',
		width: 120
	}, {
		header: '库存项id',
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '病人登记号',
		dataIndex: 'regno',
		width: 100
	}, {
		header: '病人姓名',
		dataIndex: 'patname',
		width: 100
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
		region: 'center',
		title: '材料信息',
		height: 200,
		split: true,
		layout: 'fit',
		collapsible: true,
		contentColumns: MatDispDetailCm,
		actionUrl: URL,
		queryAction: "QueryMatDispDetail",
		idProperty: "DSPRowId",
		smType: "checkbox",
		paramsFn: MatDispParamsFn,
		singleSelect: false,
		checkOnly: true,
		showTBar: false
	});
function Query() {
	MatDispDetailGrid.load();
}
function CheckBeforeDo() {
	var disStr = "";
	var rowDataArr = MatDispDetailGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "请选择需要发放的明细!");
		return false;
	}
	for (i = 0; i < rowDataArr.length; i++) {
		var rowData = rowDataArr[i];
		var incidesc = rowData.get("incidesc");
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
	DispensingMonitor();
}

function Clear() {
	Ext.getCmp("startDateField").setValue(new Date());
	Ext.getCmp("endDateField").setValue(new Date());
	Ext.getCmp("PatNo").setValue("");
	Ext.getCmp("RegnoDetail").setValue("");
	SetLogInDept(LocField.getStore(),'LocField');
	MatDispDetailGrid.removeAll();
	Common_ClearPaging(MatDispDetailGrid.getBottomToolbar());
}

function DispensingMonitor() {
	var disStr = "";
	var rowDataArr = MatDispDetailGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "请选择需要处理的材料记录!");
		return false;
	}
	for (i = 0; i < rowDataArr.length; i++) {
		var rowData = rowDataArr[i];
		var DSPRowId = rowData.get("DSPRowId");
		if (disStr == "") {
			disStr = DSPRowId;
		} else {
			disStr = disStr + "^" + DSPRowId;
		}
	}
	var Locid = Ext.getCmp("LocField").getValue();
	if (Ext.isEmpty(Locid)){Locid =gLocId;}
	var url = URL + "?actiontype=IPMatDisp";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			LocId: Locid,
			disStr: disStr,
			UserId: gUserId
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "扣库存成功!");
				Query();
			} else {
				var retinfo=jsonData.info;
				Msg.info("warning",retinfo);
			}
		},
		scope: this
	});
}
function NumZeroPadding(inputNum, numLength) {
	if (inputNum == "") {
		return inputNum;
	}
	var inputNumLen = inputNum.length;
	if (inputNumLen > numLength) {
		Msg.info("warning", "登记号输入错误!");
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
			title: '物资异常扣库存处理',
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
					items: [
						{
							columnWidth: .33,
							items: [LocField]
						},{
							columnWidth: .33,
							items: [startDateField, endDateField]
						},{
							columnWidth: .33,
							items: [PatNo, RegnoDetail]
						}
					]
				}
			]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, MatDispDetailGrid]
		});
});
//===========模块主页面===========================================
