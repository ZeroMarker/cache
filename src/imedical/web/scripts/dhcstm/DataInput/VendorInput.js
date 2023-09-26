// ��Ӧ�����ݵ���
var VendorGrid = new Ext.grid.GridPanel({
		id: 'VendorGrid',
		tbar: [{
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					var selectedarr = VendorGrid.getSelectionModel().getSelections();
					if (Ext.isEmpty(selectedarr)) {
						Msg.info("warning", "û��ѡ����");
						return;
					};
					if (selectedarr.length > 0) {
						VendorGrid.getStore().remove(selectedarr);
						VendorGrid.getView().refresh();
					}
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_gear',
				handler: function () {
					VendorGrid.CheckDataBeforeSave()
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					VendorGrid.clearData();
				}
			}, '-', {
				text: "����",
				iconCls: 'page_add',
				handler: function () {
					VendorGrid.save();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields: [
           	{name: 'Code'},
		    {name: 'Name'},
		    {name:'Tel'},
		    {name:'ConPerson'},
		    {name:'CtrlAcct'},

		    {name:'CrLimit'},  //�ɹ��޶�
		    {name:'CategoryId'},
		    {name:'LstPoDate'},
		    {name:'Fax'},
		    {name:'President'},

			//{name:'PresidentId'},
			//{name:'Status'},
			//{name:'CrAvail'},

		    {name:'Address'},
			//{name:'RCFlag'},

		    {name:'ComLic'},  //����ִ��
		    {name:'ComLicDate'},
		    {name:'RevReg'}, //˰��Ǽ�
			{name:'RevRegDate'},
			{name:'MatManLic'}, //ҽ����е��Ӫ���֤

			{name:'MatManLicDate'},
			{name:'MatEnrol'},   //ҽ����еע��֤
			{name:'MatEnrolDate'},
			{name:'Sanitation'},// �������֤
			{name:'SanitationDate'},

			{name:'OrgCode'},  //��֯��������
			{name:'OrgCodeDate'},
		    {name:'Gsp'},
		    {name:'GspDate'},
		    {name:'MatPro'},  //��е�������֤

			{name:'MatProDate'},
			{name:'ProPermit'}, //���������Ͽɱ�
			{name:'ProPermitDate'},
			{name:'ImportEnrol'}, //����ҽ����еע��֤
		    {name:'ImportEnrolDate'},

		    {name:'ImportLic'}, //����ע��ǼǱ�
			{name:'ImportLicDate'},
		    {name:'AgentLic'},
		    {name:'AgentLicDate'},
			{name:'Promises'},




			{name:'TrustDeed'},
			{name:'Quality'},
			{name:'QualityDate'},
			{name:'SalesName'},
			{name:'SalesNameDate'},



			{name:'SalesTel'}
			]
		}),
        columns:[ new Ext.grid.RowNumberer(),
            {header:'����',dataIndex:'Code'},
			{header:'����',dataIndex:'Name'},
			{header:'�绰',dataIndex:'Tel'},
			{header:'��������',dataIndex:'ConPerson'},
			{header:'�����˺�',dataIndex:'CtrlAcct'},

			{header:'�ɹ��޶�',dataIndex:'CrLimit'},
			{header:'��Ӧ�̷���',dataIndex:'CategoryId'},
			{header:'��ͬ��ֹ����', width: 100,dataIndex:'LstPoDate'},
			{header:'����',dataIndex:'Fax'},
			{header:'���˴���',dataIndex:'President'},

			//{header:'���˴���Id',dataIndex:'PresidentId',hidden:true},
			//{header:'��Ӧ��״̬',dataIndex:'Status',hidden:true},
			//{header:'ע���ʽ�',dataIndex:'CrAvail',hidden:true},
			{header:'��ַ',dataIndex:'Address'},
			//{header:'RCFlag',dataIndex:'RCFlag',hidden:true},

			{header:'����ִ��',dataIndex:'ComLic'},
			{header:'����ִ��-��Ч��', width: 100,dataIndex:'ComLicDate'},
			{header:'˰��Ǽ�',dataIndex:'RevReg'},
			{header:'˰��Ǽ�-Ч��', width: 100,dataIndex:'RevRegDate'},
			{header:'ҽ����е��Ӫ���֤',dataIndex:'MatManLic'},

			{header:'ҽ����е��Ӫ���֤-Ч��', width: 100,dataIndex:'MatManLicDate'},
			{header:'ҽ����еע��֤',dataIndex:'MatEnrol'},
			{header:'ҽ����еע��֤-Ч��', width: 100,dataIndex:'MatEnrolDate'},
			{header:'�������֤',dataIndex:'Sanitation'},
			{header:'�������֤-Ч��', width: 100,dataIndex:'SanitationDate'},

			{header:'��֯��������',dataIndex:'OrgCode'},
			{header:'��֯��������-Ч��', width: 100,dataIndex:'OrgCodeDate'},
			{header:'Gsp',dataIndex:'Gsp'},
			{header:'GspЧ��', width: 100,dataIndex:'GspDate'},
			{header:'��е�������֤',dataIndex:'MatPro'},

			{header:'��е�������֤-Ч��', width: 100,dataIndex:'MatProDate'},
			{header:'���������Ͽɱ�',dataIndex:'ProPermit'},
			{header:'���������Ͽɱ�-Ч��', width: 100,dataIndex:'ProPermitDate'},
			{header:'����ҽ����еע��֤',dataIndex:'ImportEnrol'},
			{header:'����ҽ����еע��֤-Ч��', width: 100,dataIndex:'ImportEnrolDate'},

			{header:'����ע��ǼǱ�',dataIndex:'ImportLic'},
			{header:'����ע��ǼǱ�-Ч��', width: 100,dataIndex:'ImportLicDate'},
			{header:'����������Ȩ��',dataIndex:'AgentLic'},
			{header:'����������Ȩ��-Ч��', width: 100,dataIndex:'AgentLicDate'},
			{header:'�ۺ�����ŵ��',dataIndex:'Promises'},

			{header:'����ί����',dataIndex:'TrustDeed'},
			{header:'������ŵ��',dataIndex:'Quality'},
			{header:'������ŵ��-��Ч��', width: 100,dataIndex:'QualityDate'},
			{header:'ҵ��Ա����',dataIndex:'SalesName'},
			{header:'ҵ��Ա��Ȩ��-��Ч��', width: 100,dataIndex:'SalesNameDate'},

			{header:'ҵ��Ա�绰',dataIndex:'SalesTel'}
		],
		//plugins: [Ext.ux.grid.DataDrop],
		title: '��Ӧ�����ݵ���',
		frame: true,
		ChangeBgColor: function (row, color) {
			this.getView().getRow(row).style.backgroundColor = color;
		},
		save: function () {
			var grid = this;
			var listData = "";
			var rowCount = grid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);
				var data = "";
				var Code = rowData.get("Code");
				var Name = rowData.get("Name");
				var Tel = rowData.get("Tel");
				var ConPerson = rowData.get("ConPerson");
				var CtrlAcct = rowData.get("CtrlAcct");
				data = Code + "^" + Name + "^" + Tel + "^" + ConPerson + "^" + CtrlAcct
					var CrLimit = rowData.get("CrLimit");
				var CategoryId = rowData.get("CategoryId");
				var LstPoDate = rowData.get("LstPoDate");
				var Fax = rowData.get("Fax");
				var President = rowData.get("President");
				data = data + "^" + CrLimit + "^" + CategoryId + "^" + LstPoDate + "^" + Fax + "^" + President
					var Address = rowData.get("Address");
				var ComLic = rowData.get("ComLic");
				var ComLicDate = rowData.get("ComLicDate");
				var RevReg = rowData.get("RevReg");
				var RevRegDate = rowData.get("RevRegDate");
				var MatManLic = rowData.get("MatManLic");
				data = data + "^" + Address + "^" + ComLic + "^" + ComLicDate + "^" + RevReg + "^" + RevRegDate + "^" + MatManLic
					var MatManLicDate = rowData.get("MatManLicDate");
				var MatEnrol = rowData.get("MatEnrol");
				var MatEnrolDate = rowData.get("MatEnrolDate");
				var Sanitation = rowData.get("Sanitation");
				var SanitationDate = rowData.get("SanitationDate");
				data = data + "^" + MatManLicDate + "^" + MatEnrol + "^" + MatEnrolDate + "^" + Sanitation + "^" + SanitationDate
					var OrgCode = rowData.get("OrgCode");
				var OrgCodeDate = rowData.get("OrgCodeDate");
				var Gsp = rowData.get("Gsp");
				var GspDate = rowData.get("GspDate");
				var MatPro = rowData.get("MatPro");
				data = data + "^" + OrgCode + "^" + OrgCodeDate + "^" + Gsp + "^" + GspDate + "^" + MatPro
					var MatProDate = rowData.get("MatProDate");
				var ProPermit = rowData.get("ProPermit");
				var ProPermitDate = rowData.get("ProPermitDate");
				var ImportEnrol = rowData.get("ImportEnrol");
				var ImportEnrolDate = rowData.get("ImportEnrolDate");
				data = data + "^" + MatProDate + "^" + ProPermit + "^" + ProPermitDate + "^" + ImportEnrol + "^" + ImportEnrolDate
					var ImportLic = rowData.get("ImportLic");
				var ImportLicDate = rowData.get("ImportLicDate");
				var AgentLic = rowData.get("AgentLic");
				var AgentLicDate = rowData.get("AgentLicDate");
				var Promises = rowData.get("Promises");
				data = data + "^" + ImportLic + "^" + ImportLicDate + "^" + AgentLic + "^" + AgentLicDate + "^" + Promises
					var TrustDeed = rowData.get("TrustDeed");
				var Quality = rowData.get("Quality");
				var QualityDate = rowData.get("QualityDate");
				var SalesName = rowData.get("SalesName");
				var SalesNameDate = rowData.get("SalesNameDate");
				data = data + "^" + TrustDeed + "^" + Quality + "^" + QualityDate + "^" + SalesName + "^" + SalesNameDate

					var SalesTel = rowData.get("SalesTel");
				data = data + "^" + SalesTel
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
			var url = URL + "?actiontype=SaveVendor";
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
				failure: function (resp, opts) {
					alert("�����������쳣!!");
				}
			});
		}, //save end
		CheckDataBeforeSave: function () {

			var grid = this
				var rowCount = grid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ��������!");
				return;
			}
			var ret = 0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = grid.getStore().getAt(i);

				var Name = rowData.get("Name");
				if (Ext.isEmpty(Name)) {
					this.ChangeBgColor(i, "yellow");
					ret = ret + 1;
				}
				var codetmp = rowData.get("Code")
					for (var j = 0; j < i; j++) {
						var tmpdata = grid.getStore().getAt(j);
						var repeatcode = tmpdata.get("Code");
						if (repeatcode == codetmp) {
							this.ChangeBgColor(i, "yellow");
							this.ChangeBgColor(j, "yellow");
							ret = ret + 1;
						}
					}
					var findindex = grid.getStore().findExact('Code', codetmp)
					if ((findindex != -1) && (findindex != i)) {
						this.ChangeBgColor(i, "yellow");
						ret = ret + 1;
					}
			}

			return ret;

		},
		clearData: function () {
			this.getStore().removeAll();
			this.getView().refresh();
		}
	});
