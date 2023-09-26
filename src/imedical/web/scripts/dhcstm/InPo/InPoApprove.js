// /����: ��������
// /����: ��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.08
var InPoParamObj = GetAppPropValue('DHCSTPOM');
var gGroupId = session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '����',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%',
		groupId: gGroupId
	});
// ��¼����Ĭ��ֵ
SetLogInDept(PhaLoc.getStore(), "PhaLoc");
var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '������',
		id: 'RequestPhaLoc',
		name: 'RequestPhaLoc',
		anchor: '90%',
		width: 120,
		emptyText: '������...',
		defaultLoc: {}
	});
// ��ʼ����
var StartDate = new Ext.ux.DateField({
		fieldLabel: '��ʼ����',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		value: new Date().add(Date.DAY,  - 7)
	});
// ��ֹ����
var EndDate = new Ext.ux.DateField({
		fieldLabel: '��ֹ����',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		value: new Date()
	});

var inpoNoField = new Ext.form.TextField({
		id: 'inpoNoField',
		fieldLabel: '������',
		allowBlank: true,
		emptyText: '������...',
		anchor: '90%',
		selectOnFocus: true
	});
// ��������
var InciDesc = new Ext.form.TextField({
		fieldLabel: '��������',
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
		fieldLabel: '��������',
		id: 'IncId',
		name: 'IncId',
		hidden: true
	});
/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "", getDrugList);
	}
}

/**
 * ���ط���
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
// ��Ӧ��
var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel: '��Ӧ��',
		id: 'apcVendorField',
		name: 'apcVendorField',
		anchor: '90%',
		emptyText: '��Ӧ��...'
	});

var approveStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['0', 'ȫ��'], ['1', '����ͨ��'], ['2', '���ղ�ͨ��'], ['3', 'δ����']]
	});

var approveflag = new Ext.form.ComboBox({
		fieldLabel: '����״̬',
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
		boxLabel: '����֧�����',
		anchor: '90%',
		width: 150,
		checked: true,
		allowBlank: true
	});
var includeCancelInPo = new Ext.form.Checkbox({
		id: 'includeCancelInPo',
		hideLabel: true,
		boxLabel: '������ȡ������',
		anchor: '90%',
		width: 150,
		checked: false,
		allowBlank: true
	});
// ����ȡ��ԭ��
var CauseField = new Ext.ux.ComboBox({
	id:'CauseField',
	fieldLabel:'ȡ��ԭ��',
	emptyText:'����ȡ��ԭ��...',
	anchor:'90%',
	allowBlank:true,
	store:ReasonForCancelInPoStore
});
// ��ҳ���� 
var NumAmount = new Ext.form.TextField({
	emptyText : '��ҳ����',
	id : 'NumAmount',
	name : 'NumAmount',
	anchor : '90%',
	disabled:true,
	width:200
});	
// ���ۺϼ�
var RpAmount = new Ext.form.TextField({
	emptyText : '���ۺϼ�',
	id : 'RpAmount',
	name : 'RpAmount',
	anchor : '90%',
	disabled:true,
	width : 200
});
//�ϼ�
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
	Count="��ǰ����:"+" "+Count;
	rpAmt="���ۺϼ�:"+" "+rpAmt+" "+"Ԫ";
	Ext.getCmp("NumAmount").setValue(Count);
	Ext.getCmp("RpAmount").setValue(rpAmt);

}
// ��ⵥ��
var SxNo = new Ext.form.TextField({
		fieldLabel: '��������',
		id: 'SxNo',
		name: 'SxNo',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var SxNo = Ext.getCmp("SxNo").getValue();
					//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
					var mianinfo = tkMakeServerCall("web.DHCSTM.SCI.Web.DHCSTMDataExchangeSCM", "GetPoMainInfo", SxNo);
					var arrinfo = mianinfo.split("^")
						inpoNoField.setValue(arrinfo[0])
						Query();
				}
			}
		}
	});
// ��ѯ������ť
var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '��ѯ',
		tooltip: '�����ѯ����',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function () {
			Query();
		}
	});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
		id: "ClearBT",
		text: '���',
		tooltip: '������',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			clearData();
		}
	});
// ��ӡ������ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ����',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "��ѡ����Ҫ��ӡ�Ķ���!");
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
		text: '���ղ�ͨ��',
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
		text: 'ȡ������',
		iconCls: 'page_delete',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			cancelInPo();
		}
	})
	// ����
	var ApproveBT = new Ext.Toolbar.Button({
		id: "ApproveBT",
		text: '����ͨ��',
		tooltip: '����ͨ��',
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
		Msg.info("warning", "��ѡ����Ķ���!");
		return
	};
	var poistr = "";
	for (i = 0; i < count; i++) {
		var rec = recarr[i];
		var poi = rec.get('PoId');
		var Approveed = rec.get('Approveed');
		if (Approveed != "") {
			Msg.info("warning", "�����Ѿ����յ��ݣ������ظ�����!");
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var ret = jsonData.info;
				Msg.info("success", "�ɹ�!");
				MasterStore.reload();
			} else {
			  if (jsonData.info == -1) {
			      Msg.info("error", "�˵���û����ɣ���������!");
				} else {
				     if(jsonData.info == -4){
				     Msg.info("error", "�˵�����ȡ��!");
					}else
					 Msg.info("error", jsonData.info);
				}

			}
		},
		scope: this
	});
}
/**
 * ����ȡ������
 * @param {} flag
 */
function cancelInPo() {

	var recarr = MasterGrid.getSelectionModel().getSelections();
	var count = recarr.length;
	if (count == 0) {
		Msg.info("warning", "��ѡ����Ķ���!");
		return;
	};
	var cancelreason = Ext.getCmp('CauseField').getValue();
	if(Ext.isEmpty(cancelreason)){
		Msg.info("error","��ѡ��ȡ��ԭ��!");
		return false;
	}
	var poistr = "";
	for (i = 0; i < count; i++) {
		var rec = recarr[i];
		var poi = rec.get('PoId');
		var CancelReason = rec.get('CancelReason');
		if(!Ext.isEmpty(CancelReason)){
			var PoNo = rec.get('PoNo');
			Msg.info('warning', PoNo + '�Ѿ�ȡ��!');
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
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				var ret = jsonData.info;
				Msg.info("success", "�ɹ�!");
				MasterStore.reload();
			} else {
				if (jsonData.info == -1) {
					Msg.info("error", "�ö�������δ���״̬�����Ƚ�����ɲ���!");
				} else if (jsonData.info == -2) {
					Msg.info("error", "�˵����Ѿ���ⲻ��ȡ������!");
				} else if (jsonData.info == -10) {
					Msg.info("error", "�˵����Ѿ�ȡ��!�����ظ�ȡ��");
				} else {
					Msg.info("error", jsonData.info);
				}

			}
		},
		scope: this
	});
}

/**
 * ��շ���
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

// ��ʾ��������
function Query() {
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == '' || phaLoc.length <= 0) {
		Msg.info("warning", "��ѡ�񶩹�����!");
		return;
	}
	var startDate = Ext.getCmp("StartDate").getValue();
	/*if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '��ʼ���ڲ���Ϊ��');
		return false;
	}*/
	if (startDate!=""){startDate = startDate.format(ARG_DATEFORMAT);}
	var endDate = Ext.getCmp("EndDate").getValue();
	/*if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '��ֹ���ڲ���Ϊ��');
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
	var includeDefLoc = (Ext.getCmp('includeDefLoc').getValue() == true ? 1 : 0); //�Ƿ����֧�����
	var includeCancelInPo = (Ext.getCmp('includeCancelInPo').getValue() == true ? 'Y' : 'N');
	var RequestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
	//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)^����id
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
// ��ʾ������ϸ����
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
		PoStatus = '����ͨ��';
	} else if (value == "N") {
		PoStatus = '���ղ�ͨ��';
	} else {
		PoStatus = 'δ����';
	}
	return PoStatus;
}
// ����·��
var MasterUrl = DictUrl + 'inpoaction.csp?actiontype=Query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
		url: MasterUrl,
		method: "POST"
	});
// ָ���в���
var fields = ["PoId", "PoNo", "PoLoc", "Vendor", "PoStatus", "PoDate", "PurUserId", "StkGrpId", "VenId", "CmpFlag", "Approveed", "ApproveedUser", "ApproveedDate", "ReqLocDesc","CancelReasonId","CancelReason"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "PoId",
		fields: fields
	});
// ���ݼ�
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
				header: "������",
				dataIndex: 'PoNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'PoLoc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "�������",
				dataIndex: 'ReqLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "��Ӧ��",
				dataIndex: 'Vendor',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "����״̬",
				dataIndex: 'Approveed',
				width: 90,
				align: 'left',
				sortable: true,
				renderer: renderPoStatus
			}, {
				header: "��������",
				dataIndex: 'PoDate',
				width: 80,
				align: 'right',
				sortable: true
			}, {

				header: "������",
				dataIndex: 'ApproveedUser',
				width: 80,
				align: 'right',
				sortable: true
			}, {

				header: "��������",
				dataIndex: 'ApproveedDate',
				width: 80,
				align: 'right',
				sortable: true
			},	{
				header: "ȡ��ԭ��",
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
		title: '����',
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
// ������ϸ
// ����·��
var DetailUrl = DictUrl +
	'inpoaction.csp?actiontype=QueryDetail';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
		url: DetailUrl,
		method: "POST"
	});
// ָ���в���
//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
var fields = ["PoItmId", "IncId", "IncCode", "IncDesc", "PurUomId", "PurUom", "NotImpQty", "Rp", "PurQty", "ImpQty", "CerNo", "CerExpDate", "Cancleflag"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
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
		displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg: "û�м�¼"
	});

var nm = new Ext.grid.RowNumberer();
var DetailCm = new Ext.grid.ColumnModel([nm, {
				header: "������ϸid",
				dataIndex: 'PoItmId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "����RowId",
				dataIndex: 'IncId',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '���ʴ���',
				dataIndex: 'IncCode',
				width: 80,
				align: 'left',
				renderer: Ext.util.Format.InciPicRenderer('IncId'),
				sortable: true
			}, {
				header: '��������',
				dataIndex: 'IncDesc',
				width: 230,
				align: 'left',
				sortable: true
			}, {
				header: "ע��֤��",
				dataIndex: 'CerNo',
				width: 240,
				align: 'left',
				sortable: true
			}, {
				header: "ע��֤Ч��",
				dataIndex: 'CerExpDate',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "��λ",
				dataIndex: 'PurUom',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "����",
				dataIndex: 'Rp',
				width: 60,
				align: 'right',

				sortable: true
			}, {
				header: "��������",
				dataIndex: 'PurQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "��������",
				dataIndex: 'ImpQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "δ��������",
				dataIndex: 'NotImpQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "�Ƿ���",
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
				text: '����ϸ'
			}, {
				id: 'Approve',
				handler: DenyDetail,
				text: '����'
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
		Msg.info("warning", "��ѡ����ϸ!");
		return;
	}
	var inppi = rowData.get('PoItmId');
	var url = DictUrl + "inpoaction.csp?actiontype=DenyDetail";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '��ѯ��...',
		params: {
			RowIdStr: inppi
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				var Ret = jsonData.info;
				if (Ret == 0) {
					Msg.info("success", "�ɹ�!");
					DetailGrid.getStore().reload();
				}
				if (Ret == -1) {
					Msg.info("error", "�����Ѿ���� ���ܴ���!");
				} else if (Ret == -2) {
					Msg.info("error", "�Ѵ���,�����ظ�����!");
				}
			}
		},
		scope: this
	});
}

var DetailGrid = new Ext.ux.GridPanel({
		id: 'DetailGrid',
		//region: 'center',
		title: '������ϸ',
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
// ����·��
var DetailUrl =DictUrl+
	'sciaction.csp?actiontype=getOrderDetail';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
		});
// ָ���в���
var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
		 "ManfId", "Manf", "Sp","BatNo",{name:'ExpDate',type:'date',dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
		 "BatchReq","ExpReq","Spec","BarcodeQty","AvaBarcodeQty","SpecDesc","CerNo","CerExpDate","HighValueFlag","BarCode","OrderDetailSubId"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			fields : fields
		});
// ���ݼ�
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
			header : "������ϸid",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "����RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'SpecDesc',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '��ֵ��־',
			dataIndex : 'HighValueFlag',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'AvaBarcodeQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "�ۼ�",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			
			sortable : true
		},{
			header : "��������",
			dataIndex : 'PurQty',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "���������",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����������",
			dataIndex : 'BarcodeQty',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ע��֤����",
			dataIndex : 'CerNo',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "ע��֤Ч��",
			dataIndex : 'CerExpDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'BarCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'BatNo',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "Ч��",
			dataIndex : 'ExpDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
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
/// �ܾ��ջ�
var RefuseInPoiBT = new Ext.Toolbar.Button({
		id : "RefuseInPoiBT",
		text : '�ܾ��ջ�',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			    var rowDataArr=SciPoDetailGrid.getSelectionModel().getSelections();
			    var rowcount=rowDataArr.length;
				if (Ext.isEmpty(rowDataArr)) {
					Msg.info("warning", "��ѡ����Ҫ�ܾ�����ϸ!");
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
					Msg.info("warning", "����д�ܾ�ԭ��!");
					return false;
				}
				if (OrderDetailSubIdStr=="") {
					Msg.info("warning", "��ѡ����Ҫ�ܾ�����ϸ!");
					return false;
				}
				Refuseinpoi("N",OrderDetailSubIdStr);
			
		}
});
function Refuseinpoi(type,OrderDetailSubIdStr){
 	var Refuseurl = DictUrl
                + "inpoaction.csp?actiontype=Refuseinpoi";
        var loadMask=ShowLoadMask(Ext.getBody(),"������...");
        Ext.Ajax.request({
                    url : Refuseurl,
                    method : 'GET',
                    params:{Type:type,OrderDetailSubIdStr:OrderDetailSubIdStr},
                    waitMsg : '������...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON
                                .decode(result.responseText);
                        if (jsonData.success == 'true') {
                            Msg.info("success","��Ϣ���ͳɹ���");
                        }else{
                            var retinfo=jsonData.info;
                            Msg.info("success","��Ϣ����ʧ��:"+retinfo);
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
		var mask = ShowLoadMask(Ext.getBody(), "���������Ժ�...");
		Ext.Ajax.request({
			url: 'dhcstm.sciaction.csp?actiontype=getOrderDetail',
			params: {SxNo : SxNo, HVFlag : HVFlag},
			waitMsg: '������...',
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
							Msg.info('warning', 'δ�ҵ����ϵĵ�����ϸ!');
						}
					}else{
						Msg.info('warning', '�õ����Ѵ���!');
					}
				}else{
					Msg.info("warning", "δ�ҵ����ϵĵ���!");
				}
			},
			scope: this
		});
	}
// ���е���
var SxNo = new Ext.form.TextField({
		fieldLabel: '��������',
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
		title: '��������',
		tbar: [SearchBT, '-', ClearBT, '-', ApproveBT, '-', cancelBt, '-', cancelInPoBt,'-',PrintBT],
		items: [{
				xtype: 'fieldset',
				title: '��ѯ��Ϣ',
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
			title:"���е���ϸ",
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
