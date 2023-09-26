// ����:��ⵥ���˻�����Ʊ������ǰ���
// ��д����:2014-09-09

//�������ֵ��object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

//=========================����ȫ�ֱ���=================================
function createFromRecRet(LocRowId, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var UserId = session['LOGON.USERID'];
	var GroupId = session['LOGON.GROUPID'];
	var ParamStr = "";

	//��Ӧ��
	var VendorInv = new Ext.ux.VendorComboBox({
			id: 'VendorInv',
			name: 'VendorInv',
			valueParams: {
				LocId: LocRowId
			}
		});

	var startDateField = new Ext.ux.DateField({
			id: 'startDateField',
			width: 150,
			listWidth: 150,
			allowBlank: true,
			fieldLabel: '��ʼ����',
			anchor: '90%',
			value: new Date().add(Date.DAY,  - 30)
		});

	var endDateField = new Ext.ux.DateField({
			id: 'endDateField',
			width: 150,
			listWidth: 150,
			allowBlank: true,
			fieldLabel: '��ֹ����',
			anchor: '90%',
			value: new Date()
		});

	var INVAssemNo = new Ext.form.TextField({
			fieldLabel: '��Ʊ��ϵ���',
			id: 'INVAssemNo',
			name: 'INVAssemNo',
			anchor: '90%',
			disabled: true,
			width: 120
		});

	var INVRpAmt = new Ext.form.TextField({
			id: 'INVRpAmt',
			fieldLabel: '��Ͻ����ܶ�',
			anchor: '90%',
			disabled: true
		});

	var INVSpAmt = new Ext.form.TextField({
			id: 'INVSpAmt',
			fieldLabel: '����ۼ��ܶ�',
			anchor: '90%',
			disabled: true
		});

	// ����
	var StkGrpTypeInv = new Ext.ux.StkGrpComboBox({
			id: 'StkGrpTypeInv',
			name: 'StkGrpTypeInv',
			anchor: '90%',
			StkType: App_StkTypeCode,
			LocId: LocRowId,
			UserId: UserId
		});

	var CancelBT = new Ext.Toolbar.Button({
			text: '�ر�',
			tooltip: '����˳�������',
			width: 70,
			height: 30,
			iconCls: 'page_close',
			handler: function () {
				invMastLockWindow.close();
			}
		});

	var find = new Ext.Toolbar.Button({
			text: '��ѯ',
			tooltip: '��ѯ',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				Query();
			}
		});

	function Query() {
		Ext.getCmp('INVRpAmt').setValue("");
		var VendorInv = Ext.getCmp("VendorInv").getValue();
		var StkGrpTypeInv = Ext.getCmp("StkGrpTypeInv").getValue();
		var PhaLoc = LocRowId;
		var startDate = Ext.getCmp('startDateField').getValue();
		if ((startDate != "") && (startDate != null)) {
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if ((endDate != "") && (endDate != null)) {
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		if (VendorInv == "") {
			Msg.info("warning", "��ѡ��Ӧ��!");
			return;
		}
		if (StkGrpTypeInv == "") {
			//Msg.info("warning", "��ѡ������!");
			//return;
			Msg.info('warning','δѡ�����飬�������ʵ����!');
		}
		if (startDate == "" || endDate == "") {
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		//ParamStr:��ʼ����^��ֹ����^��ⵥ���˻�����^��Ӧ��^������
		ParamStr = startDate + '^' + endDate + '^' + VendorInv + '^' + PhaLoc + '^' + StkGrpTypeInv;
		IngdGridDs.setBaseParam('ParamStr', ParamStr);
		IngdGridDs.removeAll();
		IngdGridDs.load({
			params: {
				start: 0,
				limit: IngdPagingToolbar.pageSize
			}
		});
	}

	var clear = new Ext.Toolbar.Button({
			text: '���',
			tooltip: '���',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				Ext.getCmp('VendorInv').setValue("");
				Ext.getCmp('StkGrpTypeInv').setValue("");
				Ext.getCmp('INVAssemNo').setValue("");
				Ext.getCmp('INVRpAmt').setValue("");
				Ext.getCmp('startDateField').setValue(new Date().add(Date.DAY,  - 30));
				Ext.getCmp('endDateField').setValue(new Date());
				IngdGridDs.removeAll();
				IngdGrid.getView().refresh();
				IngdPagingToolbar.getComponent(4).setValue(1); //���õ�ǰҳ��
				IngdPagingToolbar.getComponent(5).setText("ҳ,�� 1 ҳ"); //���ù���ҳ
				IngdPagingToolbar.getComponent(12).setText("û�м�¼"); //���ü�¼����
			}
		});

	var edit = new Ext.Toolbar.Button({
			text: '���',
			tooltip: '���',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var Vendor = Ext.getCmp('VendorInv').getValue();
				var stkGrpId = Ext.getCmp('StkGrpTypeInv').getValue();
				var RpTotalAmt = Ext.getCmp('INVRpAmt').getValue();
				if (RpTotalAmt == 0) {
					Msg.info("warning", "��ϵ���ⵥ���˻��������ܶ�Ϊ��!");
					return;
				}
				var SpTotalAmt = 0;
				var count = IngdGridDs.getCount();
				if (count == 0) {
					Msg.info("warning", "��ѡ����Ҫ��ϵ���ⵥ���˻���!");
					return;
				}
				var detailData = "";
				var rowCount = IngdGridDs.getCount();
				var sm = IngdGrid.getSelectionModel();
				for (var i = 0; i < rowCount; i++) {
					if (sm.isSelected(i) == true) {
						var rowData = IngdGridDs.getAt(i);
						var Ingr = rowData.get("IngrId");
						var SpAmt = rowData.get("SpAmt");
						var type = rowData.get("Type");
						type = type == '���' ? 'G' : (type == '�˻�' ? 'R' : '');
						SpTotalAmt = accAdd(SpTotalAmt, SpAmt); //�ۼۺϼ�
						var tmp = Ingr + "^" + type;
						if (detailData == "") {
							detailData = tmp;
						} else {
							detailData = detailData + xRowDelim() + tmp;
						}
					}
				}
				if (detailData == "") {
					Msg.info("warning", "��ѡ����Ҫ��ϵ���ⵥ���˻�����ϸ!");
					return;
				}
				var loadMask=ShowLoadMask(Ext.getBody(),"������...");
				Ext.Ajax.request({
					url: 'dhcstm.vendorinvaction.csp?actiontype=SaveMast',
					params: {
						userId: UserId,
						vendor: Vendor,
						stkGrpId: stkGrpId,
						LocRowId: LocRowId,
						RpAmt: RpTotalAmt,
						SpAmt: SpTotalAmt,
						detailData: detailData
					},
					method: 'POST',
					waitMsg: '�����...',
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "����ɹ�!");
							var inv = jsonData.info;
							invMastLockWindow.close();
							Fn(inv);
						} else {
							if (jsonData.info == -1) {
								Msg.info("error", "��Ϣ��ȫ,����ʧ��!");
							} else if (jsonData.info == -2) {
								Msg.info("error", "��ϸ����ʧ��!");
							} else {
								Msg.info("error", "����ʧ��!");
							}
						}
					},
					scope: this
				});
				loadMask.hide();
			}
		});

	var sm = new Ext.grid.CheckboxSelectionModel({
			checkOnly: true,
			listeners: {
				rowselect: function (sm, rowIndex, record) {
					var RpAmt = record.get("RpAmt");
					var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
					var TotalAmt = accAdd(TotalAmt, RpAmt);
					Ext.getCmp('INVRpAmt').setValue(TotalAmt);
				},
				rowdeselect: function (sm, rowIndex, record) {
					var RpAmt = record.get("RpAmt");
					var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
					var TotalAmt = accSub(TotalAmt, RpAmt);
					Ext.getCmp('INVRpAmt').setValue(TotalAmt);
				}
			}
		});
	
	var IngdGridProxy = new Ext.data.HttpProxy({
			url: 'dhcstm.vendorinvaction.csp?actiontype=QueryIngd',
			method: 'GET'
		});
	var fields = ["IngrId", "IngrNo", "Vendor", "RpAmt", "SpAmt", "Type"];
	var IngdGridDs = new Ext.data.Store({
			proxy: IngdGridProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows',
				id: "IngrId",
				fields: fields
			})
		});

	var IngdGridCm = new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(), sm, {
					header: "RowId",
					dataIndex: 'IngrId',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true,
					hideable: false
				}, {
					header: "����",
					dataIndex: 'IngrNo',
					width: 150,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'Type',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "���۽��",
					dataIndex: 'RpAmt',
					width: 130,
					align: 'left',
					sortable: true
				}, {
					header: "�ۼ۽��",
					dataIndex: 'SpAmt',
					width: 130,
					align: 'left',
					sortable: true
				}, {
					header: "��Ӧ��",
					dataIndex: 'Vendor',
					width: 200,
					align: 'left',
					sortable: true
				}
			]);

	IngdGridCm.defaultSortable = true;

	var IngdPagingToolbar = new Ext.PagingToolbar({
			store: IngdGridDs,
			pageSize: 999,
			displayInfo: true,
			displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg: "û�м�¼"
		});

	var IngdGrid = new Ext.grid.EditorGridPanel({
			region: 'center',
			title: '��ⵥ���˻�����Ϣ',
			width: 400,
			split: true,
			layout: 'fit',
			store: IngdGridDs,
			cm: IngdGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			bbar: [IngdPagingToolbar]
		});

	var formPanel = new Ext.ux.FormPanel({
			tbar: [find, '-', clear, '-', edit, '-', CancelBT],
			layout: 'column',
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
					columnWidth: 0.65,
					layout: 'column',
					style: 'padding:5px 0px 0px 5px;',
					items: [{
							columnWidth: 0.45,
							layout: 'form',
							items: [startDateField, endDateField]
						}, {
							columnWidth: 0.55,
							layout: 'form',
							items: [VendorInv, StkGrpTypeInv]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '��Ʊ�����Ϣ',
					columnWidth: 0.3,
					labelWidth: 90,
					style: 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
					items: [INVRpAmt]
				}
			]
		});

	var invMastLockWindow = new Ext.Window({
			title: '�������',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [formPanel, IngdGrid]
		});
	invMastLockWindow.show();
}
