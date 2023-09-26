// ����: �����˻�
// ��д��: tsr
// ��д����: 2017-02-22

var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var URL = 'dhcstm.matdispretaction.csp';

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		fieldLabel: '��ʼ����',
		anchor: '90%',
		value: new Date()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		fieldLabel: '��ֹ����',
		anchor: '90%',
		value: new Date()
	});

var InvNo = new Ext.form.TextField({
		id: 'InvNo',
		fieldLabel: '�վݺ�',
		allowBlank: true,
		emptyText: '�վݺ�...',
		anchor: '90%',
		selectOnFocus: true
	});

var PatNo = new Ext.form.TextField({
		id: 'PatNo',
		fieldLabel: '�ǼǺ�',
		allowBlank: true,
		emptyText: '�ǼǺ�...',
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
		fieldLabel: '������',
		width: 180,
		listWidth: 180,
		store: CardTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		emptyText: '������...',
		selectOnFocus: true,
		forceSelection: true
	});

var CardNo = new Ext.form.TextField({
		id: 'CardNo',
		fieldLabel: '����',
		allowBlank: true,
		emptyText: '����...',
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				var CardType = Ext.getCmp("CardType").getValue();
				if (CardType == "" || CardType == null) {
					Msg.info("warning", "����ѡ������!");
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
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			Query();
		}
	});

var MatReturnBT = new Ext.Toolbar.Button({
		text: '�˻�',
		tooltip: '�˻�',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			MatReturn();
		}
	});

var ClearBT = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			Clear();
		}
	});

var ReadCardBT = new Ext.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'page_readcard',
		handler: function () {
			ReadCardHandler();
		}
	});

function ReqReturnParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
		return false;
	}
	var endDate = Ext.getCmp("endDateField").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
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
		header: '����',
		dataIndex: 'patName',
		width: 80
	}, {
		header: '�ǼǺ�',
		dataIndex: 'papmino',
		width: 80
	}, {
		header: '�վ�ID',
		dataIndex: 'prt',
		width: 30,
		hidden: true
	}, {
		header: '�վݺ�',
		dataIndex: 'prtcode',
		width: 80
	}, {
		header: '�շ�����',
		dataIndex: 'prtdate',
		width: 80
	}, {
		header: '������',
		dataIndex: 'refUser',
		width: 80
	}, {
		header: '��������',
		dataIndex: 'refDate',
		width: 80
	}
];

var ReqReturnGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'ReqReturnGrid',
		region: 'west',
		title: '�˻������б�',
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
		Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
		return false;
	}
	var endDate = Ext.getCmp("endDateField").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
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
		header: "���ż�¼�ӱ�id",
		dataIndex: 'dispiRow',
		width: 80,
		hidden: true
	}, {
		header: "�����id",
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '���ʴ���',
		dataIndex: 'incCode',
		width: 100
	}, {
		header: '��������',
		dataIndex: 'incDesc',
		width: 100
	}, {
		header: '���',
		dataIndex: 'spec',
		width: 80
	}, {
		header: '��λ',
		dataIndex: 'dispUomDesc',
		width: 80
	}, {
		header: '����',
		dataIndex: 'sp',
		width: 80
	}, {
		header: '���˻�����',
		dataIndex: 'qty',
		width: 80
	}, {
		header: '�����˻�����',
		dataIndex: 'refundQtyReq',
		width: 100
	}, {
		header: '�����˻ؽ��',
		dataIndex: 'refundAmt',
		width: 100
	}, {
		header: '�˻�����',
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
							Msg.info("warning", "�˻���������Ϊ��!");
							return;
						}
						if (retqty <= 0) {
							Msg.info("warning", "�˻���������С�ڻ����0!");
							return;
						}
						var cell = MatDispReturnGrid.getSelectedCell();
						var record = MatDispReturnGrid.getAt(cell[0]);
						var qty = record.get("qty")
							if (retqty > qty) {
								Msg.info("warning", "�˻��������ڿ��˻�����!");
								return;
							}
							var retMoney = Number(record.get("sp")).mul(retqty);
						record.set("retAmt", retMoney);
					}
				}
			}
		})
	}, {
		header: '�˻ؽ��',
		dataIndex: 'retAmt',
		width: 80
	}, {
		header: '��������',
		dataIndex: 'batCode',
		width: 80
	}, {
		header: '�˻�����',
		dataIndex: 'batCode',
		width: 80
		/*	},{
		header : '��ֵ��־',
		dataIndex : 'hvFlag',
		width : 80
		},{
		header : '��ֵ����',
		dataIndex : 'barCode',
		width : 80*/
	}
];

var MatDispReturnGrid = new Ext.dhcstm.EditorGridPanel({
		id: 'MatDispReturnGrid',
		region: 'center',
		title: '�����б�',
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
		Msg.info("warning", "û��Ҫ�˻ص���ϸ����!");
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
			Msg.info("warning", "�˻��������ڷ�������!");
			return;
		}
		if (retqty > refundQtyReq) {
			Msg.info("warning", "�˻��������������˻�����!");
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
		Msg.info("warning", "����д�˻�����!");
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "�˻سɹ�!");
				MatDispReturnGrid.removeAll();
				ReqReturnGrid.removeAll();
				Query();
			} else {
				if (jsonData.info == "-4") {
					Msg.info("error", "û�п����˷����룬�����²�ѯ")
				} else {
					Msg.info("error", "�˻�����ʧ��!")
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
		Msg.info("warning", "�����ʹ���!");
		return;
	}
	var CardTypeArr = CardType.split("^");
	var CardTypeRowId = CardTypeArr[0];
	var readRet = DHCACC_GetAccInfo(CardTypeRowId, CardType);
	if (readRet == -200) {
		Msg.info("warning", "����Ч!");
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
		Msg.info("warning", "����Ч!");
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
		Msg.info("warning", "�������!");
		return;
	}
	for (var i = 1; i <= numLength - inputNumLen; i++) {
		inputNum = "0" + inputNum;
	}
	return inputNum;
}

//===========ģ����ҳ��===========================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var formPanel = new Ext.ux.FormPanel({
			title: '�����˻�',
			tbar: [FindBT, '-', MatReturnBT, '-', ClearBT],
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
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
//===========ģ����ҳ��===========================================
