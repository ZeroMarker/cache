// ����:��ⵥ���˻�����Ʊ������ǰ���
// ��д����:2014-09-09

//�������ֵ��object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

//=========================����ȫ�ֱ���=================================
function CreateFromRec(LocRowId, Fn) {
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
				invLockWindow.close();
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
		IngdDetailGridDs.removeAll();
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
				IngdDetailGridDs.removeAll();
				IngdDetailGrid.getView().refresh();
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
					Msg.info("warning", "��ϵ���ⵥ���˻�����ϸ�����ܶ�Ϊ��!");
					return;
				}
				var SpTotalAmt = 0;
				var count = IngdDetailGridDs.getCount();
				if (count == 0) {
					Msg.info("warning", "��ѡ����Ҫ��ϵ���ⵥ���˻���!");
					return;
				}
				var detailData = "";
				var handledRowCnt = 0;
				var rowCount = IngdDetailGridDs.getCount();
				var sm = IngdDetailGrid.getSelectionModel();
				for (var i = 0; i < rowCount; i++) {
					if (sm.isSelected(i) == true) {
						var rowData = IngdDetailGridDs.getAt(i);
						var Ingri = rowData.get("Ingri");
						var RpAmt = rowData.get("RpAmt");
						var SpAmt = rowData.get("SpAmt");
						var type = rowData.get("type");
						type = type == '���' ? 'G' : (type == '�˻�' ? 'R' : '');
						SpTotalAmt = accAdd(SpTotalAmt, SpAmt); //�ۼۺϼ�
						var tmp = Ingri + "^" + RpAmt + "^" + SpAmt + "^" + type;
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
					url: 'dhcstm.vendorinvaction.csp?actiontype=Save',
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
							invLockWindow.close();
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
					var InGr = IngdGridDs.getAt(rowIndex).get("IngrId");
					var Type = IngdGridDs.getAt(rowIndex).get("Type");
					IngdDetailGridDs.load({
						params: {
							start: 0,
							limit: 999,
							sort: 'Rowid',
							dir: 'Desc',
							Parref: InGr,
							Type: Type
						},
						add: true
					});
				},
				rowdeselect: function (sm, rowIndex, record) {
					var InGr = IngdGridDs.getAt(rowIndex).get("IngrId");
					var rowCount = IngdDetailGridDs.getCount();
					var IngrArr = [];
					for (var i = 0; i < rowCount; i++) {
						var rowData = IngdDetailGridDs.getAt(i);
						var ingr = rowData.get("Ingri").split("||")[0];
						if (ingr == InGr) {
							IngrArr.push(rowData);
						}
					}
					IngdDetailGridDs.remove(IngrArr);
					IngdDetailGrid.getView().refresh();
					IngdDetailTotalAmt();
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
					width: 120,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'Type',
					width: 70,
					align: 'left',
					sortable: true
				}, {
					header: "���۽��",
					dataIndex: 'RpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "�ۼ۽��",
					dataIndex: 'SpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "��Ӧ��",
					dataIndex: 'Vendor',
					width: 160,
					align: 'left',
					sortable: true
				}
			]);

	IngdGridCm.defaultSortable = true;

	var IngdPagingToolbar = new Ext.PagingToolbar({
			store: IngdGridDs,
			pageSize: PageSize,
			displayInfo: true,
			displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg: "û�м�¼"
		});

	var IngdGrid = new Ext.grid.EditorGridPanel({
			region: 'west',
			title: '��ⵥ���˻�����Ϣ',
			width: 400,
			split: true,
			collapsible: true,
			layout: 'fit',
			store: IngdGridDs,
			cm: IngdGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			bbar: [IngdPagingToolbar]
		});

	var sm1 = new Ext.grid.CheckboxSelectionModel({
			listeners: {
				rowselect: function (sm1, rowIndex, record) {
					IngdDetailTotalAmt();
				},
				rowdeselect: function (sm1, rowIndex, record) {
					var RpAmt = record.get('RpAmt');
					var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
					var TotalAmt = accSub(TotalAmt, RpAmt);
					Ext.getCmp('INVRpAmt').setValue(TotalAmt);
				}
			}
		});

	var IngdDetailGridProxy = new Ext.data.HttpProxy({
			url: 'dhcstm.vendorinvaction.csp?actiontype=QueryIngdDetail',
			method: 'GET'
		});
	var fields = ["Ingri", "IngrUom", "Inclb", "RecQty", "IncCode", "IncDesc", "Rp", "RpAmt",
		"Sp", "SpAmt", "Spec", "type"];
	var IngdDetailGridDs = new Ext.data.Store({
			proxy: IngdDetailGridProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows',
				id: "Ingri",
				fields: fields
			})
		});
	
	IngdDetailGridDs.addListener("load",function(){
		var rowCount = IngdDetailGridDs.getCount();
		var IngriArr = [];
		for (var i = 0; i < rowCount; i++) {
			var rowData = IngdDetailGridDs.getAt(i);
			IngriArr.push(rowData);
		}
		sm1.selectRecords(IngriArr, true);
	});

	var IngdDetailGridCm = new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(), sm1, {
					header: "Ingri",
					dataIndex: 'Ingri',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true,
					hideable: false
				}, {
					header: '���ʴ���',
					dataIndex: 'IncCode',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '��������',
					dataIndex: 'IncDesc',
					width: 160,
					align: 'left',
					sortable: true
				}, {
					header: '���',
					dataIndex: 'Spec',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "��λ",
					dataIndex: 'IngrUom',
					width: 50,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'RecQty',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'Rp',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "�ۼ�",
					dataIndex: 'Sp',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "���۽��",
					dataIndex: 'RpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "�ۼ۽��",
					dataIndex: 'SpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'type',
					width: 70,
					align: 'left',
					sortable: true,
					hidden: true
				}
			]);

	IngdDetailGridCm.defaultSortable = true;

	var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
			store: IngdDetailGridDs,
			pageSize: 20,
			displayInfo: true,
			displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg: "û�м�¼"
		});

	var IngdDetailGrid = new Ext.grid.EditorGridPanel({
			region: 'center',
			title: '��ⵥ���˻�����ϸ��Ϣ',
			layout: 'fit',
			store: IngdDetailGridDs,
			cm: IngdDetailGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm1,
			loadMask: true,
			clicksToEdit: 1,
			deferRowRender: false
		});
	
	function IngdDetailTotalAmt() {
		Ext.getCmp('INVRpAmt').setValue("");
		var rowCount = IngdDetailGridDs.getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = IngdDetailGridDs.getAt(i);
			if (sm1.isSelected(i) == true) {
				var RpAmt = rowData.get('RpAmt');
				var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
				var TotalAmt = accAdd(TotalAmt, RpAmt);
				Ext.getCmp('INVRpAmt').setValue(TotalAmt);
			}
		}
	}

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

	var invLockWindow = new Ext.Window({
			title: '��ⵥ���˻������',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [formPanel, IngdGrid, IngdDetailGrid]
		});
	invLockWindow.show();
}
