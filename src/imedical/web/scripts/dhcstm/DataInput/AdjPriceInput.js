// �������ݵ���
var AdjSpReason = new Ext.ux.ComboBox({
		fieldLabel: '����ԭ��',
		id: 'AdjSpReason',
		name: 'AdjSpReason',
		width: 150,
		anchor: '90%',
		store: ReasonForAdjSpStore,
		valueField: 'RowId',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '����ԭ��...',
		selectOnFocus: true,
		forceSelection: true
	});

var AdjPricePhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '���۲���',
		id: 'AdjPricePhaLoc',
		name: 'AdjPricePhaLoc',
		width: 150,
		anchor: '90%',
		emptyText: '���۲���...'
	});

var AdjPriceGrid = new Ext.grid.GridPanel({
		id: 'AdjPriceGrid',
		tbar: [AdjSpReason, '-', AdjPricePhaLoc, '-', {
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = AdjPriceGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "û��ѡ����");
						return;
					};
					if (selectedarr.length > 0) {
						AdjPriceGrid.getStore().remove(selectedarr);
						AdjPriceGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					AdjPriceGrid.CheckDataBeforeSave()

				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					AdjPriceGrid.clearData();
				}
			}, '-', {
				text: "����",
				iconCls: 'page_add',
				handler: function () {

					if (AdjPriceGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "���ڼ�ⲻͨ����������");
						return
					}
					AdjPriceGrid.Save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
			fields: [
				'InciCode',
				'InciDesc',
				'Uom',
				{name:'Rp',type: 'float'},
				{name:'Sp',type: 'float'},
				{name:'PreExeDate'},
				{name:'WarrentNo'},
				{name:'WarrentDate'}
			]
		}),
		columns:[new Ext.grid.RowNumberer(),
			{header: '���ʴ���', width: 120,dataIndex: 'InciCode'},
			{header: '��������', width: 150, dataIndex: 'InciDesc'},
			{header: '���۵�λ', width: 80, dataIndex: 'Uom'},
			{header: '�������', width: 80,xtype: 'numbercolumn', dataIndex: 'Rp'},
			{header: '�����ۼ�', width: 80,xtype: 'numbercolumn', dataIndex: 'Sp'},
			{header: '�ƻ���Ч����', width: 100, dataIndex: 'PreExeDate'},
			{header: '����ļ���', width: 150, dataIndex: 'WarrentNo'},
			{header: '����ļ�����', width: 100, dataIndex: 'WarrentDate'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '�������ݵ���',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},

		GetMaxSp: function (code) {
			var url = 'dhcstm.datainputaction.csp?actiontype=GetMaxSp&InciCode=' + code;
			var response = ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(response);
			if (jsonData.success == 'true') {
				var info = jsonData.info;
				return info;
			}

		},

		CheckDataBeforeSave: function () {
			var ret = 0
				var emp = 0
				var rowCount = this.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ������ۼ�¼!");
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
				var Uom = rowData.get("Uom");
				if (Ext.isEmpty(Uom)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Rp = rowData.get("Rp");
				if (isNaN(Rp)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Sp = rowData.get("Sp");
				if (isNaN(Sp)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}

				if (!(Ext.isEmpty(InciCode))) {
					var maxsp = this.GetMaxSp(InciCode);
					if (!(Ext.isEmpty(maxsp)) && (maxsp < Sp)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1
					}
				}

				var PreExeDate = rowData.get("PreExeDate");
				var WarrentNo = rowData.get("WarrentNo");
				var WarrentDate = rowData.get("WarrentDate");

			}

			for (var j = emp + 1; j <= rowCount; j++) {
				this.ChangeBgColor(j, "yellow");
				ret = ret + 1
			}
			return ret;
		},

		Save: function () {
			var listData = "";
			var AdjSpReasonId = Ext.getCmp('AdjSpReason').getValue();
			if (AdjSpReasonId == "") {
				Msg.info("warning", "��ѡ�����ԭ��!");
				return;
			}
			var AdjPricePhaLoc = Ext.getCmp('AdjPricePhaLoc').getValue();
			if (AdjPricePhaLoc == "") {
				Msg.info("warning", "��ѡ����ۿ���!");
				return;
			}
			//������ϸ
			var rowCount = this.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = this.getStore().getAt(i);
				var InciCode = rowData.get("InciCode");
				var InciDesc = rowData.get("InciDesc");
				var Uom = rowData.get("Uom");
				var Rp = rowData.get("Rp");
				var Sp = rowData.get("Sp");
				var PreExeDate = rowData.get("PreExeDate");
				var WarrentNo = rowData.get("WarrentNo");
				var WarrentDate = rowData.get("WarrentDate");
				var data = InciCode + "^" + InciDesc + "^" + Uom + "^" + Rp + "^" + Sp + "^" +
					PreExeDate + "^" + WarrentNo + "^" + WarrentDate + "^" + AdjSpReasonId
					if (listData == "") {
						listData = data;
					} else {
						listData = listData + xRowDelim() + data;
					}
			}

			if (listData == "") {
				Msg.info("warning", "û����Ҫ�ϴ�������");
				return;
			}
			var mask = ShowLoadMask(Ext.getBody(), "�ϴ������Ժ�...");
			var url = URL + "?actiontype=SaveAdjPrice";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData,
					Loc: AdjPricePhaLoc,
					User: gUserId
				},
				waitMsg: '������...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						var ret = jsonData.info;

						var arr = ret.split("^");
						var commitno = parseInt(arr[0]);
						var successno = parseInt(arr[1]);

						var defaultno = commitno - successno;
						if (commitno == successno) {
							Msg.info("success", "����ɹ�!");
						} else {
							Msg.info("warning", "��" + commitno + "������  " + "����ɹ�" + successno + "����  " + "����ʧ��" + defaultno + "����");
						}
					}
				},
				scope: this
			});
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
