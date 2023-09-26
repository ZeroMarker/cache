// ����: ���Ϸ���
// ��д��: tsr
// ��д����: 2016-09-09
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];

var URL = 'dhcstm.matdispaction.csp';

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
					Msg.info("warning","����ѡ������!");
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
		boxLabel: '�ѷ���',
		anchor: '90%',
		allowBlank: true
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

var DistributeBT = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			Distribute();
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

function NeedMatDispParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
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
	var DisFlag = Ext.getCmp("DisFlag").getValue() == true ? "Y" : "N";
	var params = startDate + "^" + endDate + "^" + gLocId + "^" + regno + "^" + DisFlag;
	MatDispGrid.load({
		params: {
			params: params
		}
	});
}

var NeedMatDispCm = [{
		header: '����id',
		dataIndex: 'patMasDR',
		width: 80,
		hidden: true
	}, {
		header: '����',
		dataIndex: 'patname',
		width: 80
	}, {
		header: '�ǼǺ�',
		dataIndex: 'regno',
		width: 80
	}
];

var NeedMatDispGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'east',
		title: '���������б�',
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
		header: '����',
		dataIndex: 'patienname',
		width: 100
	}, {
		header: '�ǼǺ�',
		dataIndex: 'papmino',
		width: 100
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
		width: 100
	}, {
		header: '�շ�ʱ��',
		dataIndex: 'prttime',
		width: 100
	}, {
		header: '�Ա�',
		dataIndex: 'papsex',
		width: 50
	}, {
		header: '����',
		dataIndex: 'perold',
		width: 60
	}, {
		header: '�绰',
		dataIndex: 'tel',
		width: 120
	}, {
		header: '��������',
		dataIndex: 'dspdate',
		width: 100
	}, {
		header: '����',
		dataIndex: 'patlocdesc',
		width: 100
	}, {
		header: '����id',
		dataIndex: 'dspid',
		width: 80,
		hidden: true
	}
];

var MatDispGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		title: '�������б�',
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
		header: 'ҽ����ϸid',
		dataIndex: 'orditm',
		width: 80,
		hidden: true
	}, {
		header: '�����id',
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '���ʴ���',
		dataIndex: 'incicode',
		width: 100
	}, {
		header: '��������',
		dataIndex: 'incidesc',
		width: 100
	}, {
		header: '����',
		dataIndex: 'qty',
		width: 80,
		align: 'right'
	}, {
		header: '��λ',
		dataIndex: 'dispUomDesc',
		width: 40
	}, {
		header: '����',
		dataIndex: 'Sp',
		width: 40
	}, {
		header: '���',
		dataIndex: 'SpAmt',
		width: 80
	}, {
		header: 'ҽ��״̬',
		dataIndex: 'oeflag',
		width: 80
	}, {
		header: 'ҽʦ',
		dataIndex: 'orduserName',
		width: 60
	}, {
		header: '��λ',
		dataIndex: 'stkbin',
		width: 80
	}, {
		header: '����',
		dataIndex: 'manf',
		width: 80
	}, {
		header: '�����',
		dataIndex: 'logQty',
		width: 80,
		align: 'right'
	}, {
		header: '��;���',
		dataIndex: 'reservedQty',
		width: 80,
		align: 'right'
	}, {
		header: '����״̬',
		dataIndex: 'dspstatus',
		width: 80,
		hidden: true
	}, {
		header: '��ֵ��־',
		dataIndex: 'hvFlag',
		width: 80
	}, {
		header: '��ֵ����',
		dataIndex: 'barCode',
		width: 80
	}, {
		header: 'ɨ������',
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
									Msg.info("warning", "��ɨ���ֵ����!");
									field.focus();
									return;
								} else {
									var barCode = record.get("barCode");
									if (HVBarCode != barCode) {
										Msg.info("warning", "ɨ��ĸ�ֵ���벻ƥ��!");
										field.setValue("");
										field.focus();
										return;
									} else {
										Msg.info("success", "ƥ��ɹ�!");
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
		title: '������Ϣ',
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
		Msg.info("warning", "û��ѡ�з������б���Ϣ!");
		return false;
	}
	var patname = record.get("patienname");
	var papmino = record.get("papmino");
	var disStr = "";
	var rowDataArr = MatDispDetailGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "��ѡ����Ҫ���ŵ���ϸ!");
		return false;
	}
	for (i = 0; i < rowDataArr.length; i++) {
		var rowData = rowDataArr[i];
		var incidesc = rowData.get("incidesc");
		var DisFlag = rowData.get("dspstatus");
		var warnmsgtitle = "��������:" + patname + "\t" + "�ǼǺ�:" + papmino + "\n";
		if (DisFlag == "1") {
			Msg.info("warning", warnmsgtitle + "�Ĳ���\t" + incidesc + "\t�Ѿ�����!");
			return false;
		}
		var hvFlag = rowData.get("hvFlag");
		if (hvFlag == "Y") {
			var HVBarCode = rowData.get("HVBarCode");
			var barCode = rowData.get("barCode");
			if (HVBarCode == "" || HVBarCode == null) {
				Msg.info("warning", "��ɨ���ֵ����!");
				MatDispDetailGrid.startEditing(i, GetColIndex(MatDispDetailGrid, "HVBarCode"));
				return false;
			} else if (HVBarCode != barCode) {
				Msg.info("warning", "��ֵ���벻ƥ��!");
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
	var warnmsgtitle = "��������:" + patname + "\t" + "�ǼǺ�:" + papmino + "\n";
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "���ųɹ�!");
				NeedMatDispGrid.reload();
				Query();
			} else {
				if(jsonData.info="-31"){
					Msg.info("warning", warnmsgtitle + "�Ĳ��Ͽ�治��!")
				}
				else{
					Msg.info("warning", warnmsgtitle + "�Ĳ��Ϸ���ʧ��!")
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
		Msg.info("warning", "����Ч!");
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
			title: '���Ϸ���',
			tbar: [FindBT, '-', DistributeBT, '-', ClearBT],
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
//===========ģ����ҳ��===========================================
