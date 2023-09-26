// /����: �������
// /��д�ߣ�gwj
// /��д����: 2012.09.24
var win;
var payRowId = "";
var URL = "dhcstm.payaction.csp";
var gGroupId = session['LOGON.GROUPID'];

//�������ֵ��object
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

// ������
var Paymod = new Ext.ux.ComboBox({
		fieldLabel: '֧����ʽ',
		id: 'Paymod',
		name: 'Paymod',
		anchor: '90%',
		store: GetPaymodeStore,
		valueField: 'RowId',
		displayField: 'Description',
		emptyText: '֧����ʽ...'
	});

// ������
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '�ɹ�����',
		id: 'PhaLoc',
		name: 'PhaLoc',
		emptyText: '�ɹ�����...',
		groupId: gGroupId,
		childCombo: 'Vendor'
	});

// ��������
var Vendor = new Ext.ux.VendorComboBox({
		fieldLabel: '��Ӧ��',
		id: 'Vendor',
		name: 'Vendor',
		anchor: '90%',
		emptyText: '��Ӧ��...',
		params: {
			LocId: 'PhaLoc'
		}
	});

// ��ʼ����
var StartDate = new Ext.ux.DateField({
		fieldLabel: '��ʼ����',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		value: new Date().add(Date.DAY,  - 30)
	});
// ��ֹ����
var EndDate = new Ext.ux.DateField({
		fieldLabel: '��ֹ����',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		value: new Date()
	});

var AccAckFlag = new Ext.form.Checkbox({
		fieldLabel: '�ѻ��ȷ��',
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
		fieldLabel: 'δ���ȷ��',
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

//�Ƿ�ɹ�ȷ��
var PurAckFlag = new Ext.form.Checkbox({
		fieldLabel: '�Ѳɹ�ȷ��',
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
		fieldLabel: 'δ�ɹ�ȷ��',
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
		fieldLabel: '�Ѳ���ȷ��',
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
		fieldLabel: 'δ����ȷ��',
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

//ҵ�񵥺�
var GRNo = new Ext.form.TextField({
		fieldLabel: 'ҵ�񵥺�',
		id: 'GRNo',
		name: 'GRNo',
		anchor: '90%',
		width: 120,
		disabled: false
	});

// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '�����ѯ',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			Query();
		}
	});
/**
 * ��ѯ����
 */
function Query() {
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ��ɹ�����!");
		return;
	}
	var vendor = Ext.getCmp("Vendor").getValue();
	var startDate = Ext.getCmp("StartDate").getValue();
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '��ʼ���ڲ���Ϊ��');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("EndDate").getValue();
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '��ֹ���ڲ���Ϊ��');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	//20161128��ȡ�Ƿ���ȷ��  YN�ѻ��ȷ��  NYδ���ȷ��  NN������
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
	//20161128��ȡ�Ƿ�ɹ�ȷ��  YN�Ѳɹ�ȷ��  NYδ�ɹ�ȷ��  NN������
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
	//��ʼ����^��ֹ����^����id^��Ӧ��id
	var ListParam = startDate + '^' + endDate + '^' + phaLoc + '^' + vendor + '^' + "" + '^' + "" + '^' + accackflag + '^' + purackflag + '^' + grno + '^' + Ack3Flag;
	var Page = GridPagingToolbar.pageSize;
	MasterStore.load();

}
// ��ӡ�����ť
var PrintBT = new Ext.Toolbar.Button({
		id: "PrintBT",
		text: '��ӡ',
		tooltip: '�����ӡ���',
		width: 70,
		height: 30,
		iconCls: 'page_print',
		handler: function () {
			var rowData = MasterGrid.getSelectionModel().getSelected()
				if (rowData == "") {
					Msg.info("warning", "��ѡ����Ҫ��ӡ�ĸ����");
					return;
				}
				var RowId = rowData.get("RowId")
				PrintPay(RowId);
		}
	});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '������',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			clearData();
		}
	});

/**
 * ��շ���
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

// �ɹ�ȷ�ϰ�ť
var Ack1BT = new Ext.Toolbar.Button({
		id: "Ack1BT",
		text: '�ɹ�ȷ��',
		tooltip: '���ȷ��',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck1();
		}
	});
// ���ȷ�ϰ�ť
var Ack2BT = new Ext.Toolbar.Button({
		id: "Ack2BT",
		text: '���ȷ��',
		tooltip: '���ȷ��',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck2();
		}
	});
	
// ����ȷ�ϰ�ť	
var Ack3BT = new Ext.Toolbar.Button({
		id: "Ack3BT",
		text: '����ȷ��',
		tooltip: '���ȷ��',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			SetAck3();
		}
	});
/**
 * �ɹ�ȷ�ϸ��
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ȷ�ϵ���
				Msg.info("success", "ȷ�ϳɹ�!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "�˸��δ���!");
				} else if (Ret == -3) {
					Msg.info("error", "�˸���Ѿ�ȷ��!");
				} else if (Ret == -1) {
					Msg.info("error", "δ�ҵ��˸��!");
				} else {
					Msg.info("error", "ȷ��ʧ��:"+Ret);
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ȷ�ϵ���
				Msg.info("success", "ȷ�ϳɹ�!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "�˸��δ���!");
				} else if (Ret == -3) {
					Msg.info("error", "�˸���Ѿ�ȷ��!");
				} else if (Ret == -1) {
					Msg.info("error", "δ�ҵ��˸��!");
				} else {
					Msg.info("error", "ȷ��ʧ��:" + Ret);
				}
			}
		},
		scope: this
	});

}

/**
 * ���ȷ�ϸ��
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
		Msg.info("warning","�˸���Ѿ����ȷ��!");
		return;
	}
	if (payRowId != "") {
		var vendorName = rowData.get("vendorName");
		var payNo = rowData.get("payNo");
		var payAmt = rowData.get("payAmt");
		var PayNoinfo = payNo + "^" + vendorName + "^" + payAmt;
		SetInfo(PayNoinfo); //ȷ�ϸ�����Ϣ
	}
}

/**
 * ������˸��
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "ȷ�ϳɹ�!");
				Query();
			} else {
				var Ret = jsonData.info;
				if (Ret == -2) {
					Msg.info("error", "�˸��δ���!");
				} else if (Ret == -3) {
					Msg.info("error", "�˸���Ѿ�ȷ��!");
				} else if (Ret == -1) {
					Msg.info("error", "δ�ҵ��˸��!");
				} else {
					Msg.info("error", "ȷ��ʧ��:"+Ret);
				}
			}
		},
		scope: this
	});
}

// ����·��
var MasterUrl = URL + '?actiontype=query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
		url: MasterUrl,
		method: "POST"
	});
// ָ���в���
var fields = [{name: "RowId",mapping: 'pay'}, "PurNo", "payNo", "locDesc", "vendorName", "payDate", "payTime", "payUserName", "payAmt",
		{name: "ack1Flag",mapping: 'ack1'}, "ack1UserName", "ack1Date", {name: "ack2Flag",mapping: 'ack2'}, "ack2UserName", "ack2Date",
		"payMode", "checkNo", "checkDate", "checkAmt", {name: "completed",mapping: 'payComp'}, "ack3", "ack3UserName", "ack3Date"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var mReader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "RowId",
		fields: fields
	});
// ���ݼ�
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
				var completed = "Y"; //��ɱ�־="Y"
				var paymode = Ext.getCmp("Paymod").getValue();
				//20161128��ȡ�Ƿ���ȷ��  YN�ѻ��ȷ��  NYδ���ȷ��  NN������
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
				//20161128��ȡ�Ƿ�ɹ�ȷ��  YN�Ѳɹ�ȷ��  NYδ�ɹ�ȷ��  NN������
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
				header: "�����",
				dataIndex: 'payNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "�ɹ�����",
				dataIndex: 'locDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��Ӧ��",
				dataIndex: 'vendorName',
				width: 190,
				align: 'center',
				sortable: true,
				align: 'left'
			}, {
				header: "�Ƶ�����",
				dataIndex: 'payDate',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "�Ƶ�ʱ��",
				dataIndex: 'payTime',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "�Ƶ���",
				dataIndex: 'payUserName',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "������",
				dataIndex: 'payAmt',
				width: 90,
				sortable: true,
				align: 'right'
			}, {
				header: "��ɱ�־",
				dataIndex: 'completed',
				width: 50,
				align: 'center'
			}, {
				header: "�Ƿ����ȷ��",
				dataIndex: 'ack3',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: "����ȷ����",
				dataIndex: 'ack3UserName',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����ȷ������",
				dataIndex: 'ack3Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�Ƿ�ɹ�ȷ��",
				dataIndex: 'ack1Flag',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: "�ɹ�ȷ����",
				dataIndex: 'ack1UserName',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�ɹ�ȷ������",
				dataIndex: 'ack1Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "�Ƿ���ȷ��",
				dataIndex: 'ack2Flag',
				width: 100,
				align: 'center',
				sortable: true

			}, {
				header: "���ȷ����",
				dataIndex: 'ack2UserName',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "���ȷ������",
				dataIndex: 'ack2Date',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "֧����ʽ",
				dataIndex: 'payMode',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "֧��Ʊ�ݺ�",
				dataIndex: 'checkNo',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "֧��Ʊ������",
				dataIndex: 'checkDate',
				width: 100,
				align: 'left',
				sortable: true

			}, {
				header: "֧��Ʊ�ݽ��",
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
		title: '���',
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
				text: '�鿴�����Ϣ'
			}
		]
	});

//�Ҽ��˵�����ؼ�����
function rightClickFn(grid, rowindex, e) {
	e.preventDefault();
	grid.getSelectionModel().selectRow(rowindex);
	rightClick.showAt(e.getXY());
}
function ShowRecinfo() {
	var record = MasterGrid.getSelectionModel().getSelected();
	if (record == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	var payid = record.get("RowId");
	if (payid == "") {
		Msg.info("warning", "��Ч���");
		return;
	} else {
		payRowId = payid;
		CreateRecinfowin();
	}
}

// ��ӱ�񵥻����¼�
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

// ת����ϸ
// ����·��
var DetailUrl = URL
	 + '?actiontype=queryItem'; ; ;
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	});
// ָ���в���
var fields = ["payi", "pointer", "TransType", "INCI", "inciCode", "inciDesc", "spec", "manf", "qty",
	"uomDesc", "rp", "sp", "rpAmt", "spAmt", "OverFlag", "invNo", "invDate", "invAmt", "batNo", "ExpDate", "payAmt", "grNo"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "RowId",
		fields: fields
	});
// ���ݼ�
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
				header: "����˻�Id",
				dataIndex: 'pointer',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "����Id",
				dataIndex: 'INCI',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '���ʴ���',
				dataIndex: 'inciCode',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: '��������',
				dataIndex: 'inciDesc',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "���",
				dataIndex: 'spec',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'manf',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'qty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "��λ",
				dataIndex: 'uomDesc',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'rp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "�ۼ�",
				dataIndex: 'sp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "���۽��",
				dataIndex: 'rpAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "������",
				dataIndex: 'payAmt',
				width: 100,
				align: 'right',
				editor: new Ext.form.NumberField({
					selectOnFocus: true
				}),
				sortable: true
			}, {
				header: "�ۼ۽��",
				dataIndex: 'spAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "�����־",
				dataIndex: 'OverFlag',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				header: "��Ʊ��",
				dataIndex: 'invNo',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��Ʊ����",
				dataIndex: 'invDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "��Ʊ���",
				dataIndex: 'invAmt',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'batNo',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "Ч��",
				dataIndex: 'ExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "����(���/�˻�)",
				dataIndex: "grNo",
				width: 120,
				align: "left"
			}, {
				header: "����",
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
		title: '�����ϸ',
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
		title: '�������',
		tbar: [SearchBT, '-', ClearBT, '-', Ack3BT, '-', Ack1BT, '-', Ack2BT, '-', PrintBT],
		items: [{
				xtype: 'fieldset',
				title: '��ѯ����',
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

//===========ģ����ҳ��=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [HisListTab, MasterGrid, DetailGrid],
			renderTo: 'mainPanel'
		});
});
//===========ģ����ҳ��=============================================
