// ����: סԺ����ҽ���ۿ��
// ��д��: lihui
// ��д����: 20180630
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];

var URL = 'dhcstm.dhcipmatdispaction.csp';

var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '����',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '����...',
	groupId:gGroupId
});
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
						Ext.Ajax.request({
							url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
							params : {regno : newPatNo},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									var value = jsonData.info;
									var arr = value.split("^");
									//������Ϣ
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
		fieldLabel : '�ǼǺ���Ϣ',
		id : 'RegnoDetail',
		disabled:true,
		anchor : '90%'
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
		text: 'ȷ��',
		tooltip: 'ȷ��',
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

function MatDispParamsFn() {
	var startDate = Ext.getCmp("startDateField").getValue();
	var endDate = Ext.getCmp("endDateField").getValue();
	var PatNo = Ext.getCmp("PatNo").getValue();
	if ((Ext.isEmpty(PatNo))&&(Ext.isEmpty(startDate))) {
		Msg.info('warning', '�ǼǺ�Ϊ��ʱ����ʼ���ڲ���Ϊ��!');
		return false;
	}
	if ((Ext.isEmpty(PatNo))&&(Ext.isEmpty(endDate))) {
		Msg.info('warning', '�ǼǺ�Ϊ��ʱ���ֹ���ڲ���Ϊ��!');
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
		header: 'ִ�м�¼id',
		dataIndex: 'DSPRowId',
		width: 80,
		hidden: true 
	},{
		header: 'ҽ����ϸid',
		dataIndex: 'orditm',
		width: 80,
		hidden: true
	},{
		header: 'Ҫ��ִ��ʱ��',
		dataIndex: 'exestdatetime',
		width: 120
	}, {
		header: '�����id',
		dataIndex: 'inci',
		width: 80,
		hidden: true
	}, {
		header: '���˵ǼǺ�',
		dataIndex: 'regno',
		width: 100
	}, {
		header: '��������',
		dataIndex: 'patname',
		width: 100
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
		region: 'center',
		title: '������Ϣ',
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
		Msg.info("warning", "��ѡ����Ҫ���ŵ���ϸ!");
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
		Msg.info("warning", "��ѡ����Ҫ����Ĳ��ϼ�¼!");
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "�ۿ��ɹ�!");
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
		Msg.info("warning", "�ǼǺ��������!");
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
			title: '�����쳣�ۿ�洦��',
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
//===========ģ����ҳ��===========================================
