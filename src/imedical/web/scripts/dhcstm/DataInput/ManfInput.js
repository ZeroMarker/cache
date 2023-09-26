// �������ݵ���
var ManfGrid = new Ext.grid.GridPanel({
		id: 'ManfGrid',
		tbar: [{
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = ManfGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "û��ѡ����");
						return;
					};
					if (selectedarr.length > 0) {
						ManfGrid.getStore().remove(selectedarr);
						ManfGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					ManfGrid.CheckDataBeforeSave();
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					ManfGrid.clearData();
				}
			}, '-', {
				text: "����",
				iconCls: 'page_add',
				handler: function () {
					if (ManfGrid.CheckDataBeforeSave() != 0) {
						Msg.info("warning", "���ڼ�ⲻͨ����������");
						return
					}
					ManfGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields: [
           {name:'Code'},
           {name:'Name'},
           {name:'Address'},
           {name:'Tel'},
           {name:'ParManfId'},

           {name:'DrugPermit'},
           {name:'DrugPermitExp'},
           {name:'MatPermit'},
           {name:'MatPermitExp'},
           {name:'ComLic'},

           {name:'ComLicExp'},
           {name:'BusinessRegNo'},
           {name:'BusinessRegExpDate'},
           {name:'OrgCode'},
           {name:'OrgCodeExpDate'},

           {name:'TaxRegNo'},
           {name:'MatManLic'},
           {name:'MatManLicDate'}
			]
		}),
        columns:[ new Ext.grid.RowNumberer(),
            {header:'����',dataIndex: 'Code'},
		    {header:'����',dataIndex: 'Name'},
		    {header:'��ַ',dataIndex:'Address'},
		    {header:'�绰',dataIndex:'Tel'},
		    {header:'�ϼ�����',dataIndex:'ParManfId'},

		    {header:'ҩ���������֤',dataIndex:'DrugPermit'},
		    {header:'ҩ���������֤Ч��',dataIndex:'DrugPermitExp'},
		    {header:'�����������֤',dataIndex:'MatPermit'},
		    {header:'�����������֤Ч��',dataIndex:'MatPermitExp'},
		    {header:'����ִ�����',dataIndex:'ComLic'},

		    {header:'����ִ�����Ч��',dataIndex:'ComLicExp'},
		    {header:'����ע���',dataIndex:'BusinessRegNo'},
		    {header:'����ע���Ч��',dataIndex:'BusinessRegExpDate'},
		    {header:'��֯��������',dataIndex:'OrgCode'},
		    {header:'��֯��������Ч��',dataIndex:'OrgCodeExpDate'},

		    {header:'˰��ǼǺ�',dataIndex:'TaxRegNo'},
		    {header:'��е��Ӫ���֤',dataIndex:'MatManLic'},
		    {header:'��е��Ӫ���֤Ч��',dataIndex:'MatManLicDate'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '�������ݵ���',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		save: function () {
			var listData = "";
			var grid = this
				var rowCount = grid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				var Address = rowData.get("Address");
				var Tel = rowData.get("Tel");
				var ParManfId = rowData.get("ParManfId");
				var DrugPermit = rowData.get("DrugPermit");
				var DrugPermitExp = rowData.get("DrugPermitExp");
				var MatPermit = rowData.get("MatPermit");
				var MatPermitExp = rowData.get("MatPermitExp");
				var ComLic = rowData.get("ComLic");
				var ComLicExp = rowData.get("ComLicExp");
				var BusinessRegNo = rowData.get("BusinessRegNo");
				var BusinessRegExpDate = rowData.get("BusinessRegExpDate");
				var OrgCode = rowData.get("OrgCode");
				var OrgCodeExpDate = rowData.get("OrgCodeExpDate");
				var TaxRegNo = rowData.get("TaxRegNo");
				var MatManLic = rowData.get("MatManLic");
				var MatManLicDate = rowData.get("MatManLicDate");
				var data = Code + "^" + Name + "^" + Address + "^" + Tel + "^" + ParManfId + "^"
					+DrugPermit + "^" + DrugPermitExp + "^" + MatPermit + "^" + MatPermitExp + "^" + ComLic + "^" +
					ComLicExp + "^" + BusinessRegNo + "^" + BusinessRegExpDate + "^" + OrgCode + "^" + OrgCodeExpDate + "^"
					 + TaxRegNo + "^" + MatManLic + "^" + MatManLicDate;
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
			var url = URL + "?actiontype=SaveManf";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					listData: listData
				},
				waitMsg: '������...',
				success: function (result, request) {
					mask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
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
		CheckDataBeforeSave: function () {
			var grid = this
				var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ�������ݼ�¼!");
				return;
			}
			for (var i = 0; i < rowCount; i++) {
				var ret = 0;
				var rowData = grid.getStore().getAt(i);
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				if (Ext.isEmpty(Name)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1
				}
				var Address = rowData.get("Address");
				var Tel = rowData.get("Tel");
				var ParManfId = rowData.get("ParManfId");
				var DrugPermit = rowData.get("DrugPermit");
				var DrugPermitExp = rowData.get("DrugPermitExp");
				var MatPermit = rowData.get("MatPermit");
				var MatPermitExp = rowData.get("MatPermitExp");
				var ComLic = rowData.get("ComLic");
				var ComLicExp = rowData.get("ComLicExp");
				var BusinessRegNo = rowData.get("BusinessRegNo");
				var BusinessRegExpDate = rowData.get("BusinessRegExpDate");
				var OrgCode = rowData.get("OrgCode");
				var OrgCodeExpDate = rowData.get("OrgCodeExpDate");
				var TaxRegNo = rowData.get("TaxRegNo");
				var MatManLic = rowData.get("MatManLic");
				var MatManLicDate = rowData.get("MatManLicDate");
			}
			return ret;
		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
