// var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
var projUrl = 'herp.acct.acctbusisupplierexe.csp';

/**********�������*********/
var AcctBookStore = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['AcctBookID', 'AcctBookName'])
	});
AcctBookStore.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			mothed: 'POST',
			url: projUrl + '?action=AcctBook&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctBookFieldt').getRawValue())
		})
});
var AcctBookFieldt = new Ext.form.ComboBox({
		id: 'AcctBookFieldt',
		fieldLabel: '�������',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		//typeAhead : true,
		editable: true,
		listeners: {
			select: function () {
				var BookID = AcctBookFieldt.getValue();
				SupplierStore.removeAll();
				AcctSupplierField.setValue();
				SupplierStore.on('beforeload', function (ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
							method: 'POST',
							url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookID=' + BookID
						})
				});
				SupplierStore.load();
			}
		}
	});

//����������������
var rows;
var AcctBook = new Ext.form.ComboBox({
		id: 'AcctBook',
		fieldLabel: '�������',
		width: 178,
		listWidth: 220,
		lazyRender: true, //ѡ��ʱ����
		minChars: 1,
		pageSize: 10,
		store: AcctBookStore,
		displayField: 'AcctBookName',
		valueField: 'AcctBookID',
		triggerAction: 'all',
		//typeAhead : true,
		forceSelection: true,
		listeners: {
			select: function (comb, records, index) {
				var currow = gridpanel.getSelectionModel().getSelections();
				rows = currow[0].data["AcctBusiSupplierMapID"];
				var BookID = AcctBook.getValue(); //currow[0].data["BookName"];
				//alert(currow+"&"+BookID)
				if (BookID != "") {
					AcctSupplierStore.removeAll();
					// AcctDepart.setValue();
					currow[0].data["AcctDeptName"] = ""; //ѡ�����׺󣬿������������ÿ�
					AcctSupplierStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookID=' + BookID
							})
					});
					AcctSupplierStore.load();
				}
			}
			/*,
			scope:this  */

		}

	});
/**********��ƹ�Ӧ��*********/
var SupplierStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemCodeName'])
	});
var AcctSupplierField = new Ext.form.ComboBox({
		id: 'AcctSupplierField',
		fieldLabel: '��ƹ�Ӧ��',
		width: 180,
		listWidth: 230,
		queryModel: 'local',
		lazyRender: true, //ѡ��ʱ����
		minChars: 1,
		pageSize: 10,
		store: SupplierStore,
		displayField: 'CheckItemCodeName',
		valueField: 'CheckItemCode',
		triggerAction: 'all',
		selectOnFocus: true,
		//typeAhead : true,
		forceSelection: true,
		editable: true,
		listeners: {
			focus: function () {
				var BookID = AcctBookFieldt.getRawValue();
				if (BookID == "") {
					SupplierStore.removeAll();
					AcctSupplierField.setValue();
					Ext.Msg.show({
						title: 'ע��',
						msg: '����ѡ��λ���ף�',
						icon: Ext.Msg.INFO,
						buttons: Ext.Msg.OK
					});
					return;
				}
			}
		}
	});
//��ƹ�Ӧ��������
var AcctSupplierStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCodeName', 'CodeName'])
	});
var AcctSupplier = new Ext.form.ComboBox({
		id: 'AcctSupplier',
		fieldLabel: '��ƹ�Ӧ��',
		width: 180,
		listWidth: 230,
		// lazyRender : true, //ѡ��ʱ����
		minChars: 1,
		pageSize: 10,
		// queryModel : 'local',
		store: AcctSupplierStore,
		displayField: 'CheckItemCodeName',
		valueField: 'CodeName',
		triggerAction: 'all',
		//typeAhead : true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			focus: function () {
				//alert(Ext.getCmp('AcctBook').getRawValue())
				var records = gridpanel.getSelectionModel().getSelections();
				var BookName = records[0].data["BookName"];
				// var AcctBookID=records[0].data["AcctBookID"];
				// alert(BookName)
				if (BookName == "") {
					Ext.Msg.show({
						title: 'ע��',
						msg: '����ѡ��λ���ף� ',
						icon: Ext.Msg.INFO,
						buttons: Ext.Msg.OK
					});
					return;
				}
				//alert(rows+"&"+records[0].data["AcctBusiDeptMapID"])
				if (rows != records[0].data["AcctBusiSupplierMapID"]) { //�ж�ѡ�����ǲ��ǵ�λ���׸ı���
					AcctSupplierStore.removeAll();
					AcctSupplier.setValue();
					AcctSupplierStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: projUrl + '?action=GetAcctSupplier&start=0&limit=25&AcctBookName=' + encodeURIComponent(BookName)
							})
					});
					AcctSupplierStore.load();
				}
			}
		}
	});

/**********ҵ��Ӧ��*********/
var BusiSupplierField = new Ext.form.TextField({
		id: 'BusiSupplierField',
		fieldLabel: 'ҵ��Ӧ��',
		width: 150
	});

/**********ҵ��ϵͳ*********/
var BusiSysStore = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['SysBusinessID', 'SystemName'])
	});
BusiSysStore.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			method: 'POST',
			url: projUrl + '?action=GetBusiSys&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('BusiSystemField').getRawValue())
		})
});
var BusiSystemField = new Ext.form.ComboBox({
		id: 'BusiSystemField',
		fieldLabel: 'ҵ��ϵͳ',
		width: 150,
		listWidth: 220,
		minChars: 1,
		pageSize: 10,
		lazyRender: true, //ѡ��ʱ����
		// emptyText:"��ѡ�񡭡�",
		store: BusiSysStore,
		displayField: 'SystemName',
		valueField: 'SysBusinessID',
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		//typeAhead : true,
		editable: true
	});
//������
var BusiSystem = new Ext.form.ComboBox({
		id: 'BusiSystem',
		fieldLabel: 'ҵ��ϵͳ',
		width: 150,
		listWidth: 220,
		lazyRender: true, //ѡ��ʱ����
		store: BusiSysStore,
		displayField: 'SystemName',
		valueField: 'SysBusinessID',
		pageSize: 10,
		triggerAction: 'all',
		forceSelection: true,
		//typeAhead : true,
		selectOnFocus: true,
		editable: true
	});

/**********��ѯ��ť*********/
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		handler: function () {
			var acctbookid = AcctBookFieldt.getValue(),
			acctsupplier = AcctSupplierField.getValue(),
			busisystem = BusiSystemField.getValue(),
			busisupplier = BusiSupplierField.getValue();
			gridpanel.store.load({
				params: {
					start: 0,
					limit: 25,
					AcctBookID: acctbookid,
					AcctSupplier: acctsupplier,
					BusiSupplier: busisupplier,
					SysBusinessID: busisystem

				}
			})
		}
	});

/**********���Ӱ�ť*********/
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'add',
		handler: function () {
			gridpanel.add()
		}
	});
/**********���水ť*********/
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'save',
		handler: function () {
			gridpanel.save()
		}
	});
/**********ɾ����ť*********/
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			gridpanel.del()
		}
	});

var importButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����Excel�ļ�',
		iconCls: 'in',
		handler: function () {
			doimport();
		}
	});

//['������ף�', AcctBookFieldt, '-', '��ƹ�Ӧ�̣�', AcctSupplierField, 
// '-', 'ҵ��Ӧ�̣�', BusiSupplierField, '-', 'ҵ��ϵͳ��', BusiSystemField, '-', findButton],
var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //��ǩ���뷽ʽ
			labelSeparator: ' ', //�ָ���
			labelWidth: 80,
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1500,
		layout: 'column',
		items: [{
				xtype: 'fieldset',
				labelWidth: 60,
				width: 250,
				items: AcctBookFieldt
			}, {
				xtype: 'fieldset',
				width: 300,
				items: AcctSupplierField
			},{
				xtype: 'fieldset',
				width: 270,
				items: BusiSupplierField
			},{
				xtype: 'fieldset',
				labelWidth: 60,
				width: 250,
				items: BusiSystemField
			}, {
				xtype: 'fieldset',
				// width:100,
				items: findButton
			}
		]

	});

var gridpanel = new dhc.herp.Grid({
		// atLoad : true,
		region: 'center',
		trackMouseOver: true,
		stripeRows: true,
		url: projUrl,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		tbar: [addButton, '-', saveButton, '-', delButton, '-', importButton],
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'AcctBusiSupplierMapID',
				header: '<div style="text-align:center">��Ӧ�̶��ձ�ID</div>',
				dataIndex: 'AcctBusiSupplierMapID',
				width: 100,
				align: 'center',
				hidden: true
			}, {
				id: 'AcctBookID',
				header: '<div style="text-align:center">�������ID</div>',
				dataIndex: 'AcctBookID',
				width: 100,
				hidden: true
			}, {
				id: 'BookName',
				header: '<div style="text-align:center">�������</div>',
				dataIndex: 'BookName',
				type: AcctBook,
				width: 180,
				allowBlank: false,
				align: 'left'
			}, {
				id: 'AcctSupplierCode',
				header: '<div style="text-align:center">��ƹ�Ӧ�̱���</div>',
				dataIndex: 'AcctSupplierCode',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				id: 'AcctSupplierName',
				header: '<div style="text-align:center">��ƹ�Ӧ��</div>',
				dataIndex: 'AcctSupplierName',
				type: AcctSupplier,
				//allowBlank : false,
				width: 200,
				align: 'left'
			}, {
				id: 'SystemName',
				header: '<div style="text-align:center">ҵ��ϵͳ</div>',
				dataIndex: 'SystemName',
				type: BusiSystem,
				width: 180,
				allowBlank: false,
				align: 'left'
			}, {
				id: 'BusiSupplierCode',
				header: '<div style="text-align:center">ҵ��Ӧ�̱���</div>',
				dataIndex: 'BusiSupplierCode',
				allowBlank: false,
				width: 150,
				align: 'left'
			}, {
				id: 'BusiSupplierName',
				header: '<div style="text-align:center">ҵ��Ӧ������</div>',
				dataIndex: 'BusiSupplierName',
				allowBlank: false,
				width: 300,
				align: 'left'
			}
		],
		bbar: new Ext.PagingToolbar({
			store: this.store,
			pageSize: 25,
			atLoad: true,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}����',
			emptyMsg: "û������"
		})
	});

gridpanel.btnAddHide() //�������Ӱ�ť
gridpanel.btnSaveHide() //���ر��水ť
gridpanel.btnDeleteHide() //����ɾ����ť
gridpanel.btnResetHide() //�������ð�ť
gridpanel.btnPrintHide() //���ش�ӡ��ť
