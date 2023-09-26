
// /����: ����Ƶ�
// /��д�ߣ�gwj
// /��д����: 2012.09.24

var gPayRowId = "";
var gVendorRowId = "";
var payLocRowId = "";
var payRatio = 1;
var ManuOp = false;
var saveOK = true;

function CreateFromRec(payLocRowId, Fn, payRowId) {
	var URL = "dhcstm.payaction.csp";

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

	// ȷ����ť
	var saveBT = new Ext.Toolbar.Button({
			text: '���渶�',
			tooltip: '�������',
			width: 70,
			height: 30,
			iconCls: 'page_save',
			handler: function () {
				Save();
			}
		});

	// ȡ����ť
	var CancelBT = new Ext.Toolbar.Button({
			text: '�ر�',
			tooltip: '����رձ�����',
			width: 70,
			height: 30,
			iconCls: 'page_close',
			handler: function () {
				payItmWindow.close();
			}
		});

	/**
	 * ����
	 */
	function Save() {
		saveOK = true;
		var selectedCount = ItmToPayGrid.getSelectionModel().getCount();
		if (selectedCount == 0) {
			saveOK = false;
			return;
		}

		var vendor = gVendorRowId;
		var paymode = Ext.getCmp("PayMode").getValue();
		var payUrl = URL + "?actiontype=UpdPay&loc=" + payLocRowId + "&vendor=" + vendor + "&paymode=" + paymode + "&pay=" + payRowId;
		var payResult = ExecuteDBSynAccess(payUrl);
		var payJsonData = Ext.util.JSON.decode(payResult);
		if (payJsonData.success == 'true') {
			var pay = payJsonData.info;
			if (pay > 0) {
				var rowCnt = 0;
				var handledRowCnt = 0;
				var rowCount = ItmToPayGrid.getStore().getCount();
				var sm = ItmToPayGrid.getSelectionModel();
				for (var i = 0; i < rowCount; i++) {
					if (sm.isSelected(i) == true) {
						var rowData = ItmToPayGrid.store.getAt(i);
						var pointer = rowData.get("ingri");
						var inci = rowData.get("inci");
						var recAmt = rowData.get("rpAmt");
						var payAmt = rowData.get("amt");
						var payi = "";
						var disc = "";
						var type = rowData.get("type");
						type = type == '���' ? 'G' : (type == '�˻�' ? 'R' : '');

						var restAmt = rowData.get("restAmt");
						if ((type == 'G') && (payAmt > restAmt)) {
							Msg.info('warning', 'ҳ���е�' + (i + 1) + '����ⵥ��������ڴ������!');
							return;
						}
						if ((type == 'R') && (payAmt < restAmt)) {
							Msg.info('warning', '��' + (i + 1) + '���˻�����������ڴ������!');
							return;
						}
						var detailData = pointer + "^" + inci + "^" + recAmt + "^" + payAmt + "^" + disc + "^" + type;
						//SavePayItm(payi,pay,detailData)  //������ϸ
						var payiUrl = URL + '?actiontype=UpdPayItm&payi=' + payi + '&pay=' + pay + '&detailData=' + detailData;
						var payiResult = ExecuteDBSynAccess(payiUrl);
						var payiJsonData = Ext.util.JSON.decode(payiResult);
						if (payiJsonData.success == 'true') {
							var payiItm = payiJsonData.info;
							if (payiItm != "") {
								saveOK = true;
								handledRowCnt++;
								if (handledRowCnt == selectedCount) {
									//���Ѿ���������ִ��ˢ��
									Msg.info("success", "����ɹ�!")
									ItmToPayGrid.load();
								}
							} else {
								saveOK = false;
							}
						} else {
							saveOK = false;
						}
					}
				}
			} else {
				saveOK = false;
				Msg.info('error', '�������ʧ��!');

			}
		} else {
			var ret = payJsonData.info;
			saveOK = false;
			if (ret == '-1') {
				Msg.info('warning', 'Ҫ������ϸ�Ĺ�Ӧ�̺�ԭ�����Ӧ�̲�ͬ��')
			} else if (ret == '-2') {
				Msg.info('warning', 'Ҫ���������ԭ����Ŀ��Ҳ�ͬ!')
			} else if (ret == '-3') {
				Msg.info('warning', '����Ѿ���ɲ�������Ӹ�����ϸ!')
			} else {
				Msg.info('error', '�������ʧ��!');
			}
		}

		if (saveOK) {
			payItmWindow.close();
			Fn(pay);
		}
	}

	/**
	 * ��ѯ����
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			//Msg.info("warning", "��ѡ��������!");
			return;
		}
		vendorListGrid.load();
	}

	/**
	 * ��շ���
	 */
	function clearData() {
		vendorListGrid.removeAll();
		gVendorRowId = "";
		ItmToPayGrid.removeAll();
		Ext.getCmp('payVendor').setValue('');
		Ext.getCmp('InvNoField').setValue('');
		Ext.getCmp('payNo').setValue('');
		payTotalAmt.setValue('');
		gPayRowId = "";
	}

	// ��Ӧ��
	var payVendor = new Ext.ux.VendorComboBox({
			fieldLabel: '��Ӧ��',
			id: 'payVendor',
			name: 'payVendor',
			anchor: '90%',
			emptyText: '��Ӧ��...',
			valueParams: {
				LocId: payLocRowId
			}
		});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '��ʼ����',
			id: 'StartDate',
			name: 'StartDate',
			anchor: '90%',

			width: 120,
			value: new Date().add(Date.DAY,  - 30)
		});

	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
			fieldLabel: '��ֹ����',
			id: 'EndDate',
			name: 'EndDate',
			anchor: '90%',

			width: 120,
			value: new Date()
		});

	var prePay = new Ext.form.TextField({
			fieldLabel: 'Ԥ����',
			id: 'prePay',
			name: 'prePay',
			anchor: '90%',
			width: 120,
			emptyText: "����Ҫ�������߱���",
			listeners: {
				specialkey: function (textfield, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var preAmt = textfield.getValue();
						var endnum = -1;
						var m = ItmToPayGrid.getSelectionModel();
						var store = ItmToPayGrid.getStore();
						var cnt = store.getTotalCount();
						if (preAmt > 1) { //�������1ʱ
							var sumAmt = 0;
							for (var i = 0; i < cnt; i++) {
								var rec = store.getAt(i);
								var amt = rec.get('restAmt');
								sumAmt = accAdd(sumAmt, amt);
								if(preAmt<sumAmt) break;
								endnum = i
							}
							if (endnum >= 0) {
								m.selectRange(0, endnum);
							}
						} else if (0 < preAmt <= 1) { //����С��1ʱ ���ձ���������
							payRatio = preAmt;
							m.selectRange(0, cnt);
						}
						payRatio = 1; //�ָ�Ĭ��ֵ
					}
				}
			}
		});

	//���θ�����
	var payTotalAmt = new Ext.form.TextField({
			id: 'payTotalAmt',
			fieldLabel: '�����ܶ�',
			anchor: '90%',
			disabled: true
		});
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
	var PayMode = new Ext.ux.ComboBox({
			fieldLabel: '֧����ʽ',
			id: 'PayMode',
			name: 'PayMode',
			anchor: '90%',
			store: GetPaymodeStore,
			valueField: 'RowId',
			displayField: 'Description',
			emptyText: '֧����ʽ...'
		});

	var InvNoField = new Ext.form.TextField({
			id: "InvNoField",
			fieldLabel: "��Ʊ��",
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var vendorListColumns = [{
			header: 'RowId',
			dataIndex: 'vendor',
			hidden: true
		}, {
			header: '��Ӧ������',
			width: 190,
			dataIndex: 'vendorName'
		}
	];

	function vendorRowSelFn(sm, rowIndex, r) {
		gVendorRowId = r.get("vendor");
		ItmToPayGrid.load();
	}

	function vendorParamsFn() {
		var userId = session['LOGON.USERID'];
		var groupId = session['LOGON.GROUPID'];
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if (sd != "") {
			sd = sd.format(ARG_DATEFORMAT);
		}
		if (ed != "") {
			ed = ed.format(ARG_DATEFORMAT);
		}
		var vendor = Ext.getCmp('payVendor').getValue();
		var invNo = Ext.getCmp('InvNoField').getValue();
		var StrParam = sd + "^" + ed + "^" + payLocRowId + "^" + vendor + "^" + groupId + "^" + userId + "^" + invNo;
		return {
			strParam: StrParam
		};
	}

	var vendorListGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'vendorListGrid',
			editable: false,
			contentColumns: vendorListColumns,
			smType: "row",
			smRowSelFn: vendorRowSelFn,
			autoLoadStore: true,
			actionUrl: URL,
			queryAction: "queryVendor",
			idProperty: "vendor",
			paramsFn: vendorParamsFn,
			showTBar: false,
			childGrid: 'ItmToPayGrid',
			isCheck: false
		});

	var ItmToPayColumns = [{
			header: "RowId",
			dataIndex: 'RowId',
			sortable: true,
			hidden: true
		}, {
			header: "����",
			dataIndex: 'No'
		}, {
			header: '����',
			dataIndex: 'type',
			width: 50
		}, {
			header: '������',
			align: 'right',
			dataIndex: 'amt',
			editable: true,
			editor: new Ext.form.NumberField({})
		}, {
			header: "����", //�������
			dataIndex: 'gdDate'
		}, {
			header: "ʱ��", //���ʱ��
			dataIndex: 'gdTime',
			width: 50
		}, {
			header: "�����",
			dataIndex: 'gdAuditUserName'
		}, {
			header: "��ϸrowid",
			dataIndex: 'ingri',
			hidden: true
		}, {
			header: "inclb",
			dataIndex: 'inclb',
			hidden: true
		}, {
			header: "inci",
			dataIndex: 'inci',
			hidden: true,
			editable: false
		}, {
			header: "����",
			dataIndex: 'inciCode'
		}, {
			header: "����",
			dataIndex: 'inciDesc',
			width: 200
		}, {
			header: '���',
			dataIndex: 'spec',
			width: 80,
			editable: false
		}, {
			header: '����',
			dataIndex: 'manf'
		}, {
			header: '��λ',
			dataIndex: 'uomDesc'
		}, {
			header: '����',
			dataIndex: 'qty',
			align: 'right'
		}, {
			header: '����',
			dataIndex: 'rp',
			align: 'right'
		}, {
			header: '���۽��',
			dataIndex: 'rpAmt',
			align: 'right'
		}, {
			header: '�ۼ�',
			dataIndex: 'sp',
			align: 'right'
		}, {
			header: '�ۼ۽��',
			dataIndex: 'spAmt',
			align: 'right'
		}, {
			header: '�Ѹ����',
			align: 'right',
			dataIndex: 'payedAmt',
			xtype: 'numbercolumn'
		}, {
			header: '�������',
			align: 'right',
			dataIndex: 'restAmt',
			xtype: 'numbercolumn'
		}, {
			header: '��Ʊ��',
			dataIndex: 'invNo'
		}, {
			header: '��Ʊ���',
			dataIndex: 'invAmt',
			align: 'right'
		}, {
			header: '��Ʊ����',
			dataIndex: 'invDate',
			align: 'center'
		}, {
			header: '���е�',
			dataIndex: 'sxNo'
		}, {
			header: '����',
			dataIndex: 'batNo'
		}, {
			header: '��Ч��',
			dataIndex: 'expDate'
		},{
			header: '������������',
			align: 'right',
			dataIndex: 'DifDays'
		}
	];

	function ItmToPayParamsFn() {
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if (sd != "") {
			sd = sd.format(ARG_DATEFORMAT);
		}
		if (ed != "") {
			ed = ed.format(ARG_DATEFORMAT);
		}
		var userId = session['LOGON.USERID'];
		var groupId = session['LOGON.GROUPID'];
		var strParam = payLocRowId + "^" + gVendorRowId + "^" + sd + "^" + ed + "^" + groupId + "^" + userId;
		return {
			strParam: strParam
		};
	}

	var ItmToPayGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'ItmToPayGrid',
			editable: true,
			contentColumns: ItmToPayColumns,
			smType: "checkbox",
			singleSelect: false,
			smRowSelFn: function () {},
			selectFirst: false,
			autoLoadStore: false,
			actionUrl: URL,
			queryAction: "queryItmToPay",
			idProperty: "ingri",
			checkProperty: "",
			paramsFn: ItmToPayParamsFn,
			remoteSort: false,
			showTBar: false,
			paging: false,
			isCheck: false,
			listeners: {
				'afteredit': function (e) {
					if (e.field == 'amt') {
						ManuOp = true;
						e.record.commit();
						e.grid.getSelectionModel().selectRow(e.row, true);
						TotalAmt();
					}
				}
			},
			viewConfig:{
				getRowClass : function(record,rowIndex,rowParams,store){ 
					var DifDays=record.get("DifDays");
					if(DifDays>0){
						return 'classRed';
					}
				}
			}
		});

	ItmToPayGrid.getSelectionModel().on('rowselect', function (t, ind, rec) {
		var toBePayAmt = rec.get('restAmt');
		rec.set('amt', toBePayAmt * payRatio); //ʹ��<��������>���
		rec.commit();
		TotalAmt();
	});
	ItmToPayGrid.getSelectionModel().on('rowdeselect', function (t, ind, rec) {
		var toBePayAmt = rec.get('restAmt');
		rec.set('amt', ''); //ȡ��ʹ��<��������>���
		rec.commit();
		TotalAmt();
	});

	/*�����ܽ��*/
	function TotalAmt() {
		var store = ItmToPayGrid.getStore();
		var cnt = store.getTotalCount();
		var sumAmt = 0;
		for (var i = 0; i < cnt; i++) {
			var rec = store.getAt(i);
			var amt = rec.get('amt');
			sumAmt = accAdd(sumAmt, amt);
		}
		Ext.getCmp('payTotalAmt').setValue(sumAmt);
	}

	var payHisListTab = new Ext.form.FormPanel({
			labelWidth: 80,
			labelAlign: 'right',
			frame: true,
			bodyStyle: 'padding:5px;',
			tbar: [SearchBT, '-', ClearBT, '-', saveBT, '-', CancelBT],
			layout: 'column',
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
					autoHeight: true,
					columnWidth: 0.7,
					layout: 'column',
					items: [{
							columnWidth: 0.33,
							layout: 'form',
							items: [StartDate, EndDate]
						}, {
							columnWidth: 0.4,
							layout: 'form',
							items: [payVendor, PayMode]
						}, {
							columnWidth: 0.27,
							layout: 'form',
							items: [InvNoField]
						}
					]
				}, {
					columnWidth: 0.01
				}, {
					xtype: 'fieldset',
					title: '�����Ϣ',
					autoHeight: true,
					columnWidth: 0.29,
					layout: 'form',
					items: [prePay, payTotalAmt]
				}
			]
		});

	var payItmWindow = new Ext.Window({
			title: 'Ӧ�����ݲ�ѯ',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [{
					region: 'north',
					height: 130,
					layout: 'fit',
					items: payHisListTab
				}, {
					region: 'west',
					title: 'Ӧ����Ӧ���б�',
					layout: 'fit',
					width: 240,
					split: true,
					collapsible: true,
					items: vendorListGrid
				}, {
					region: 'center',
					title: 'Ӧ������',
					layout: 'fit',
					items: ItmToPayGrid
				}
			]
		});
	payItmWindow.show();
}

///������֮ǰ�õ��ķ���,�����ݱ��浽��ʱglobal,��ͨ��^TMP���渶�
/*
 * �ݴ�����(���ݴ洢��)
 * StoreId - �洢��
 * */
function StoreItmData(StoreId) {
	var RowDataBlock = 50; //����
	//var StoreId=GetStoreId();
	//alert(StoreId);
	if (StoreId != "") {
		var ListDetail = "";
		var rowCnt = 0;
		var rowCount = ItmToPayGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var sm = ItmToPayGrid.getSelectionModel();
			if (sm.isSelected(i) == true) {
				var rowData = ItmToPayGrid.store.getAt(i);
				var pointer = rowData.get("ingri");
				var inci = rowData.get("inci");
				var recAmt = rowData.get("rpAmt");
				var payAmt = rowData.get("amt");
				//var disc=rowData.get("disc");
				var disc = "";
				var type = rowData.get("type");

				var str = "" + "^" + pointer + "^" + inci + "^" + recAmt + "^" + payAmt + "^" + disc + "^" + type;

				if (ListDetail == "") {
					ListDetail = str;
				} else {
					ListDetail = ListDetail + xRowDelim() + str;
				}

				rowCnt = rowCnt++;
				if (rowCnt == RowDataBlock) {
					SendToStoreData(StoreId, ListDetail);
					//alert(ListDetail);
					rowCnt = 0; //����
					ListDetail = "";
				}
			}
		}
		//alert(ListDetail);
		if (ListDetail != "") //����һ��
		{
			SendToStoreData(StoreId, ListDetail);
		}
	}
}

/*���Ͳ���������*/
function SendToStoreData(StoreId, detailData) {
	Ext.Ajax.request({
		url: URL + '?actiontype=StorePayItm',
		method: "POST",
		params: {
			storeId: StoreId,
			detailData: detailData
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Execute(StoreId) //ִ�б���
			}
		}
	});
}

/*ִ�б���*/
function Execute(StoreId) {
	var VenId = gVendorRowId; //��Ӧ��rowid
	var LocId = payLocRowId; //�������rowid
	var CreateUser = session['LOGON.USERID'];

	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + "";
	//alert(MainInfo);
	var url = URL + "?actiontype=save&MainInfo=" + MainInfo + "&StoreId=" + StoreId;

	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ��ɵ���
				Msg.info("success", "���渶��ɹ�!");
				ItmToPayGrid.store.reload();
			} else {
				var ret = jsonData.info;
				if (ret == -99) {
					Msg.info("error", "����ʧ��,���ܱ���!");
				} else if (ret == -4) {
					Msg.info("error", "���渶�������Ϣʧ��!");
				} else if (ret == -5) {
					Msg.info("error", "���渶���ϸʧ��!");
				} else {
					Msg.info("error", "������ϸ���治�ɹ���" + ret);
				}
			}
		},
		scope: this
	});
}
