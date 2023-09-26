// ��浼��
var GroupId = session['LOGON.GROUPID'];
var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		name: 'Vendor',
		width: 150,
		anchor: '90%',
		params: {
			LocId: 'StockPhaLoc',
			ScgId: 'StkGrpType'
		}
	});

// ��������
var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		name: 'StkGrpType',
		StkType: App_StkTypeCode, //��ʶ��������
		LocId: gLocId,
		UserId: gUserId,
		width: 150,
		anchor: '90%'
	});

// �������
var OperateInType = new Ext.form.ComboBox({
		fieldLabel: '�������',
		id: 'OperateInType',
		name: 'OperateInType',
		width: 100,
		anchor: '90%',
		store: OperateInTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: true,
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		valueNotFoundText: '',
		emptyText: '�������...'
	});
// Ĭ��ѡ�е�һ������
OperateInTypeStore.load({
	callback: function (r, options, success) {
		if (success && r.length > 0) {
			OperateInType.setValue(r[0].get(OperateInType.valueField));
		}
	}
});
var StockPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '��ⲿ��',
		id: 'StockPhaLoc',
		name: 'StockPhaLoc',
		width: 150,
		anchor: '90%'
	});
// �ɹ���Ա
var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel: '�ɹ���Ա',
		id: 'PurchaseUser',
		width: 100,
		anchor: '90%',
		store: PurchaseUserStore,
		valueField: 'RowId',
		displayField: 'Description',
		emptyText: '�ɹ���Ա...'
	});
var StockRecGrid = new Ext.grid.GridPanel({
		id: "StockRecGrid",
		tbar: [StockPhaLoc, '-', Vendor, '-', StkGrpType, '-', OperateInType, '-', PurchaseUser, '-', {
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					StockRecGrid.deleteDetail();
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					StockRecGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					StockRecGrid.clearData();
				}

			}, "-", {
				text: "����",
				iconCls: 'page_add',
				handler: function () {
					if (StockRecGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "���ڼ�ⲻͨ����������");
						return
					}
					StockRecGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields : [
            {name:'InciCode'},
            {name:'InciDesc'},
			{name:'Qty'},
			{name:'Puom'},
			{name:'Rp'},
			{name:'Sp'},
			{name:'Batch'},
			{name:'ExpDate'},
			{name:'Manf'}
			]
		}),
		columns: [
            new Ext.grid.RowNumberer(),
            {header: '���ʴ���', width: 120,dataIndex: 'InciCode'},
            {header: '��������', width: 150,dataIndex: 'InciDesc'},
            {header: '����', width: 120,dataIndex: 'Qty'},
            {header: '��ⵥλ', width: 120,dataIndex: 'Puom'},
            {header: '����', width: 120,dataIndex: 'Rp'},
            {header: '�ۼ�', width: 120,dataIndex: 'Sp'},
            {header: '����', width: 120,dataIndex: 'Batch'},
            {header: 'Ч��', width: 120,dataIndex: 'ExpDate'},
            {header: '����', width: 120,dataIndex: 'Manf'}

		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '��浼��',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		CheckDataBeforeSave: function () {
			var ret = 0
				var rowCount = this.getStore().getCount();
			var emp = 0
				if (rowCount == 0) {
					Msg.info("warning", "û����Ҫ�����¼!");
					return;
				}
				for (var i = 0; i < rowCount; i++) {

					var rowData = this.getStore().getAt(i);
					emp = emp + 1;
					var InciCode = rowData.get("InciCode");
					if (Ext.isEmpty(InciCode)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
					var InciDesc = rowData.get("InciDesc");
					var Qty = rowData.get("Qty");
					if (isNaN(Qty)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
					var Puom = rowData.get("Puom");
					if (Ext.isEmpty(Puom)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
					var Rp = rowData.get("Rp");
					if (isNaN(Rp)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
					var Batch = rowData.get("Batch");
					var ExpDate = rowData.get("ExpDate");

				}
				for (var j = emp + 1; j <= rowCount; j++) {
					this.ChangeBgColor(j, "yellow");
					ret = ret + 1
				}
				return ret;
		},
		save: function () {
			var grid = this;
			var listData = "";
			var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ�ϴ������ݣ�");
				return;
			};
			var StockPhaLoc = Ext.getCmp('StockPhaLoc').getValue();
			if (StockPhaLoc == "") {
				Msg.info("warning", "��ѡ�������!");
				return;
			}
			var Vendor = Ext.getCmp('Vendor').getValue();
			if (Vendor == "") {
				Msg.info("warning", "��ѡ��Ӧ��!");
				return;
			}
			var StkGrpType = Ext.getCmp('StkGrpType').getValue();
			var OperateInType = Ext.getCmp('OperateInType').getValue();
			var PurchaseUser = Ext.getCmp('PurchaseUser').getValue();
			var mainData = StockPhaLoc + "^" + Vendor + "^" + StkGrpType + "^" + OperateInType + "^" + PurchaseUser + "^" + gUserId + "^" + GroupId
				for (var i = 0; i < rowCount; i++) {
					var rowData = grid.getStore().getAt(i);
					var incicode = rowData.get("InciCode");
					var incidesc = rowData.get("InciDesc");
					var qty = rowData.get("Qty");
					var puom = rowData.get("Puom");
					var rp = rowData.get("Rp");
					var sp = rowData.get("Sp");
					var batch = rowData.get("Batch");
					var expdate = rowData.get("ExpDate");
					var manf = rowData.get("Manf");
					var data = incicode + "^" + incidesc + "^" + qty + "^" + puom
						 + "^" + rp + "^" + batch + "^" + expdate + "^" + manf+"^"+sp;
						if (listData == "") {
							listData = data;
						} else {
							listData = listData + xRowDelim() + data;
						}
				};
			if (listData == "") {
				Msg.info("warning", "û����Ҫ�ϴ�������");
				return;
			}
			var mask = ShowLoadMask(Ext.getBody(), "�ϴ���")
				var url = URL + "?actiontype=SaveStock";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					mainData: mainData,
					listData: listData
				},
				waitMsg: '������...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {

						Msg.info("success", "����ɹ�!");
						} else {
						var ret=jsonData.info;
						Msg.info("warning","����ʧ��:"+ret);
					}

				},
				scope: this
			});
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		},
		deleteDetail: function () {
			var selectedarr = StockRecGrid.getSelectionModel().getSelections();
			if (Ext.isEmpty(selectedarr)) {
				Msg.info("warning", "û��ѡ����");
				return;
			};
			if (selectedarr.length > 0) {
				StockRecGrid.getStore().remove(selectedarr);
				StockRecGrid.getView().refresh();
			};
		}
	});
