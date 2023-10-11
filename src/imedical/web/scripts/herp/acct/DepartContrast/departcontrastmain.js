// var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
var departcontrasturl = 'herp.acct.departcontrastexe.csp';

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
			url: departcontrasturl + '?action=AcctBook&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctBookFieldt').getRawValue())
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
				DepartStore.removeAll();
				AcctDepartField.setValue();
				DepartStore.on('beforeload', function (ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
							method: 'POST',
							url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookID=' + BookID
						})
				});
				DepartStore.load();

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
				rows = currow[0].data["AcctBusiDeptMapID"];
				var BookID = AcctBook.getValue(); //currow[0].data["BookName"];
				//alert(currow+"&"+BookID)
				if (BookID != "") {
					colDepartStore.removeAll();
					// AcctDepart.setValue();
					currow[0].data["AcctDeptName"] = ""; //ѡ�����׺󣬿������������ÿ�
					colDepartStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookID=' + BookID
							})
					});
					colDepartStore.load();
				}
			}
			/*,
			scope:this  */

		}

	});
/**********��ƿ���*********/
var DepartStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemName'])
	});

var AcctDepartField = new Ext.form.ComboBox({
		id: 'AcctDepartField',
		fieldLabel: '��ƿ���',
		width: 150,
		listWidth: 225,
		queryModel: 'local',
		lazyRender: true, //ѡ��ʱ����
		minChars: 1,
		pageSize: 10,
		store: DepartStore,
		displayField: 'CheckItemName',
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
					DepartStore.removeAll();
					AcctDepartField.setValue();
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
//��ƿ���������
var colDepartStore = new Ext.data.Store({
		autoLoad: false,
		proxy: '',
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['CheckItemCode', 'CheckItemName'])
	});

var AcctDepart = new Ext.form.ComboBox({
		id: 'AcctDepart',
		fieldLabel: '��ƿ���',
		width: 150,
		listWidth: 225,
		// lazyRender : true, //ѡ��ʱ����
		minChars: 1,
		pageSize: 10,
		// queryModel : 'local',
		store: colDepartStore,
		displayField: 'CheckItemName',
		valueField: 'CheckItemCode',
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
				if (rows != records[0].data["AcctBusiDeptMapID"]) { //�ж�ѡ�����ǲ��ǵ�λ���׸ı���
					colDepartStore.removeAll();
					AcctDepart.setValue();
					colDepartStore.on('beforeload', function (ds, o) {
						ds.proxy = new Ext.data.HttpProxy({
								method: 'POST',
								url: departcontrasturl + '?action=GetDepart&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('AcctDepartField').getRawValue()) + '&AcctBookName=' + encodeURIComponent(BookName)
							})
					});
					colDepartStore.load();
				}
			}
			/*      ,
			blur:function(){
			colDepartStore.removeAll();
			} */
		}

	});
/**********ҵ�����*********/
var BusiDepartField = new Ext.form.TextField({
		id: 'BusiDepartField',
		fieldLabel: 'ҵ�����',
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
			url: departcontrasturl + '?action=GetBusiSys&start=0&limit=25&str=' + encodeURIComponent(Ext.getCmp('BusiSystemField').getRawValue())
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

/**********�������*********/
var DeptType = new Ext.form.ComboBox({
		id: 'DeptType',
		fieldLabel: '�������',
		width: 150,
		mode: 'local',
		store: new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', '�ٴ�����'], ['02', '�������'], ['90', 'ͨ�ÿ���']]
		}),
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all'
		//typeAhead : true
	});

/**********��ѯ��ť*********/
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		handler: function () {
			var acctbookid = AcctBookFieldt.getValue(),
			acctdepart = AcctDepartField.getValue(),
			busisystem = BusiSystemField.getValue(),
			busidepart = BusiDepartField.getValue();
			var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
			gridpanel.store.load({
				params: {
					start: 0,
					limit: limits,
					AcctBookID: acctbookid,
					AcctDeptCode: acctdepart,
					BusiDeptCode: busidepart,
					SystemName: busisystem

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
/*********������Դ***********/
/* var gridStore = new Ext.data.Store({
proxy : new Ext.data.HttpProxy({
mothed : 'POST',
url : departcontrasturl + '?action=list'
}),
reader : new Ext.data.JsonReader({
totalProperty : 'results',
root : 'rows'
}, ['AcctBusiDeptMapID', 'BookName', 'SystemName', 'AcctDeptCode', 'AcctDeptName', 'BusiDeptCode', 'BusiDeptName', 'DeptType'])
}); */

//['������ף�', AcctBookFieldt, '-', '��ƿ��ң�', AcctDepartField, '-',
// 'ҵ����ң�', BusiDepartField, '-', 'ҵ��ϵͳ��', BusiSystemField, '-', findButton],

var queryPanel = new Ext.FormPanel({
		region: 'north',
		height: 45,
		frame: true,
		defaults: {
			labelAlign: 'right', //��ǩ���뷽ʽ
			labelSeparator: ' ', //�ָ���
			labelWidth: 60,
			width: 250,
			border: false,
			bodyStyle: 'padding:5px;'
		},
		width: 1200,
		layout: 'column',
		items: [{
				xtype: 'fieldset',
				items: AcctBookFieldt
			}, {
				xtype: 'fieldset',
				items: AcctDepartField
			},{
				xtype: 'fieldset',
				items: BusiDepartField
			},{
				xtype: 'fieldset',
				items: BusiSystemField
			}, {
				xtype: 'fieldset',
				width:100,
				items: findButton
			}
		]

	});

// var buttons = new Ext.Toolbar();
var gridpanel = new dhc.herp.Grid({
		// atLoad : true,
		region: 'center',
		trackMouseOver: true,
		stripeRows: true,
		url: departcontrasturl,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		tbar: [addButton, '-', saveButton, '-', delButton, '-', importButton],
		fields: [new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'AcctBusiDeptMapID',
				header: '<div style="text-align:center">���Ҷ��ձ�ID</div>',
				dataIndex: 'AcctBusiDeptMapID',
				width: 60,
				align: 'center',
				hidden: true
			}, {
				id: 'AcctBookID',
				header: '<div style="text-align:center">�������ID</div>',
				dataIndex: 'AcctBookID',
				width: 180,
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
				id: 'AcctDeptCode',
				header: '<div style="text-align:center">��ƿ��ұ���</div>',
				dataIndex: 'AcctDeptCode',
				width: 180,
				align: 'left',
				hidden: true
			}, {
				id: 'AcctDeptName',
				header: '<div style="text-align:center">��ƿ�������</div>',
				dataIndex: 'AcctDeptName',
				type: AcctDepart,
				allowBlank: false,
				width: 125,
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
				id: 'DeptType',
				header: '<div style="text-align:center">�������</div>',
				dataIndex: 'DeptType',
				type: DeptType,
				allowBlank: false,
				width: 100,
				align: 'center'
			}, {
				id: 'BusiDeptID',
				header: '<div style="text-align:center">ҵ�����ID</div>',
				dataIndex: 'AcctBusiDeptMapID',
				allowBlank: false,
				width: 150,
				align: 'center',
				hidden: true
			}, {
				id: 'BusiDeptCode',
				header: '<div style="text-align:center">ҵ����ұ���</div>',
				dataIndex: 'BusiDeptCode',
				allowBlank: false,
				width: 150,
				align: 'left'
			}, {
				id: 'BusiDeptName',
				header: '<div style="text-align:center">ҵ���������</div>',
				dataIndex: 'BusiDeptName',
				allowBlank: false,
				width: 180,
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
