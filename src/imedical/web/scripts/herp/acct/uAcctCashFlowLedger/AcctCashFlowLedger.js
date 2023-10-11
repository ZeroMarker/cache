var userdr = session['LOGON.USERID']; //��¼��ID

var acctbookid = IsExistAcctBook();

var itemGridUrl = 'herp.acct.acctcashflowledgerexe.csp';

//��ʼ��״̬��ʾ
var FinStyField = new Ext.form.DisplayField({ //ԭΪTextField
		id: 'FinStyField',
		name: 'FinStyField',
		style: 'text-align:left;color:red;', //�ı�����뷽ʽ
		triggerAction: 'all',
		disabled: false
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=Getflagsty&acctbookid=' + acctbookid,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			rtndata = jsonData.info;
			FinStyField.setValue(rtndata);
			//finishButton.disabled='true';
			//introButton.disabled='true';
			//uploadButton.disabled='true';
		}
	}

});

//���׽���ʱ����ʾ
var AcctYearMonthField = new Ext.form.DisplayField({ //ԭΪTextField
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		style: 'text-align:left;color:black;', //�ı�����뷽ʽ
		triggerAction: 'all',
		disabled: false
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=GetAcctCurYearMonth&acctbookid=' + acctbookid,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			rtndata = jsonData.info;
			AcctYearMonthField.setValue(rtndata);
		}
	}

});

//��ʾ�ʽ�����//
var CFDirectionFieldDS = new Ext.data.SimpleStore({ //�ʽ�����״̬
		fields: ['key', 'keyValue'],
		data: [['0', '����'], ['1', '����']]
	});
////����������--�ʽ�����״̬��ѯ----CFDirection-----////
var CFDirectionField = new Ext.form.ComboBox({
		id: 'CFDirectionField',
		fieldLabel: '�ʽ�����',
		style: 'overflow:hidden',
		width: 120,
		blankText: "��ѡ���ʽ�����",
		listWidth: 100,
		store: CFDirectionFieldDS,
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

var editCFDirectionField = new Ext.form.ComboBox({
		id: 'editCFDirectionField',
		fieldLabel: '�ʽ�����',
		blankText: "��ѡ���ʽ�����",
		style: 'overflow:hidden',
		width: 100,
		listWidth: 100,
		typeAhead: true,
		store: CFDirectionFieldDS,
		editable: false,
		minChars: 1,
		//valueNotFoundText : '',
		displayField: 'keyValue',
		valueField: 'key',
		typeAhead: true,
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});

//��ʾ����//
var CurrNameFieldDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['code', 'name'])
	});

CurrNameFieldDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: itemGridUrl + '?action=GetCurrName',
			method: 'POST'
		});
});

var CurrNameField = new Ext.form.ComboBox({
		id: 'CurrNameField',
		fieldLabel: '����',
		width: 120,
		//listWidth : 60,
		//allowBlank : false,
		store: CurrNameFieldDs,
		displayField: 'name',
		valueField: 'code',
		triggerAction: 'all',
		//emptyText : '��ѡ��...',
		minChars: 1,
		listWidth: 250,
		anchor: '95%',
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		resizable: true
	});
CurrNameField.on('select', function (combo, record, index) {
	tmpdeptdr = combo.getValue();
});

var CurrDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['code', 'name'])
	});

CurrDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: itemGridUrl + '?action=GetCurrName',
			method: 'POST'
		});
});

var editCurrNameField = new Ext.form.ComboBox({
		id: 'editCurrNameField',
		fieldLabel: '����',
		width: 100,
		listWidth: 220,
		store: CurrDs,
		editable: true,
		minChars: 1,
		pageSize: 10,
		displayField: 'name',
		valueField: 'code',
		//mode : 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText: '��ѡ��...',
		selectOnFocus: true,
		forceSelection: true
	});
editCurrNameField.on('select', function (combo, record, index) {
	tmpdeptdr = combo.getValue();
});

//��ѯ��ť

var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		iconCls: 'find',
		tooltip: '��ѯ',
		handler: function () {
			var cfdirection = CFDirectionField.getValue();
			var acctcurcode = CurrNameField.getValue();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					direction: cfdirection,
					acctcurcode: acctcurcode,
					acctbookid: acctbookid

				}
			});

		}
	});

///���������밴ť
var introButton = new Ext.Toolbar.Button({
		text: '����������',
		tooltip: '����������',
		iconCls: 'leadinto',
		handler: function () {
			var acctcurcode = CurrNameField.getValue();
			var rowObj = itemGrid.getSelectionModel().getSelections();

			if (acctcurcode == "") {

				Ext.Msg.show({
					title: 'ע��',
					msg: '����ѡ����� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				//var rowid = rowObj[0].get("rowid");
				return;
			}
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=GetAcctDirection&acctbookid=' + acctbookid + '&acctcurcode=' + acctcurcode,
						waitMsg: '�����...',
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: 'ע��',
									msg: '��������������ɹ�! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								itemGrid.load();
							} else {
								Ext.Msg.show({
									title: '��ʾ',
									msg: 'û�п������µ�����! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
							}
						},
						scope: this
					});

				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ�����������������? ', handler);
		}
	});

//���밴ť
var uploadButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'in',
		handler: function () {
			doimport();

		}
	});

//���ܼ��㰴ť
var sumButton = new Ext.Toolbar.Button({
		text: '���ܼ���',
		tooltip: '���ܼ���',
		iconCls: 'calculate',
		handler: function () {

			var myData = [];
			var Title = "";
			var JName = "";
			Ext.Ajax.request({
				url: itemGridUrl + '?action=Sumlacation&acctbookid=' + acctbookid,
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var money = jsonData.info;
						//alert(money);
						var arr = money.split("^");
						Title = arr[0];
						JName = arr[1];
						//alert(Title+'^'+JName);
						var a = ["����", Title];
						var b = ["����", JName];
						myData.push(a);
						myData.push(b);

						var store = new Ext.data.ArrayStore({
								fields: [{
										name: 'direction'
									}, {
										name: 'flowtotalsum'
									}
								]
							});
						store.loadData(myData);
						var grid = new Ext.grid.GridPanel({
								store: store,
								columns: [{

										header: '�ʽ�����',
										width: 120,
										align: 'center',
										sortable: true,
										dataIndex: 'direction'
									}, {
										header: '���',
										width: 150,
										align: 'center',
										sortable: true,
										renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
											return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
										},
										dataIndex: 'flowtotalsum'
									}
								]

							});
						var window = new Ext.Window({
								title: '���ܼ�����ʾ��',
								width: 300,
								height: 180,
								layout: 'fit',
								plain: true,
								modal: true,
								bodyStyle: 'padding:5px;',
								buttonAlign: 'center',
								//sumButton:'center',
								//style:"text-align:center",
								//buttonAlign : "sorth",
								items: grid,
								buttons: [{
										text: 'ȡ��',
										handler: function () {
											window.close();
										}
									}
								]
							});
						window.show();

					} else {
						var message = "";
						Ext.Msg.show({
							title: '����',
							msg: message,
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					}
				}

			});

		}
	});

///��ʼ����ɰ�ť
var finishButton = new Ext.Toolbar.Button({
		text: '��ʼ�����',
		tooltip: '��ʼ�����',
		iconCls: 'datainit',
		//iconCls:'finish',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var date = AcctYearMonthField.getValue();
			var year = date.substr(0, 4);
			var month = date.substr(6, 7);
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: '../csp/herp.acct.acctcashflowledgerexe.csp?action=Compinit&acctbookid=' + acctbookid + '&userdr=' + userdr,
						waitMsg: '�����...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '����',
								msg: '������������! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '��ʾ',
									msg: year + "�������" + "��ʼ�����! ",
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});

								var rtndata = jsonData.info;
								if (rtndata !== 0) {
									FinStyField.setValue(rtndata);

									//introButton.disabled='true';
									//uploadButton.disabled='true';
									//SaveButton.disabled='true';
									//finishButton.disabled='true';
									introButton.setEnabled
								}
								itemGrid.load()
							} else {
								Ext.Msg.show({
									title: '��ʾ',
									msg: '��ʼ������ʧ��! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
							}
						},
						scope: this
					});

				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ���г�ʼ��������? ', handler);
		}
	});

//�������Դ

var itemGridProxy = new Ext.data.HttpProxy({
		url: itemGridUrl + '?action=list'
	});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [

				'rowid',
				'flowitemid',
				'acctbookid',
				'Cilevel',
				'acctyear',
				'acctmonth',
				'itemcode',
				'itemname',
				'direction',
				'acctcurcode',
				'flowsum',
				'flowtotalsum',
				'islast',
				'isInit'

			]),
		remoteSort: true
	});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad: true,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������" //,

	});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

var sysStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', 'Ԥ�����'], ['1', '��Ŀ֧��']]
	});
var syscomb = new Ext.form.ComboBox({
		id: 'sysno',
		fieldLabel: 'Ӧ��ϵͳ',
		width: 180,
		listWidth: 180,
		selectOnFocus: true,
		allowBlank: false,
		store: sysStore,
		anchor: '90%',
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: 'ѡ���ڼ�����...',
		mode: 'local', //����ģʽ
		editable: false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

var SaveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����',
		iconCls: 'save',
		handler: function () {
			itemGrid.save();

			var cfdirection = CFDirectionField.getValue();
			var acctcurcode = CurrNameField.getValue();
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					direction: cfdirection,
					acctcurcode: acctcurcode,
					acctbookid: acctbookid

				}
			});

		}
	});

var query = new Ext.FormPanel({
		title: '�ֽ��������ݳ�ʼ��',
		iconCls: 'datainit',
		region: 'north',
		height: 70,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��ʼ��״̬:',
						style: 'line-height: 15px;padding-Right:5px;',
						width: 80
					}, FinStyField, {
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '���׽���ʱ��:',
						width: 90
					}, AcctYearMonthField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '�ʽ�����',
						style: 'line-height: 15px;',
						width: 70
					}, CFDirectionField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '����',
						style: 'line-height: 15px;',
						width: 40
					}, CurrNameField, {
						xtype: 'displayfield',
						value: '',
						width: 15
					}, findButton
				]
			}
		]

	});
//tbar:["��ʼ��״̬:",FinStyField,"-","���׽���ʱ��:",AcctYearMonthField,"-","�ʽ�����:",CFDirectionField,"-","����:",CurrNameField,"-",findButton]
//���ݿ�����ģ��

var tbar1 = new Ext.Toolbar([SaveButton, "-", introButton, "-", uploadButton, "-", sumButton, "-", finishButton]);

//���

var itemGrid = new dhc.herp.Grid({
		//title: '�ֽ��������ݳ�ʼ��',
		width: 400, //�Ƿ�ɱ༭
		readerModel: 'remote',
		region: 'center',
		url: 'herp.acct.acctcashflowledgerexe.csp',
		atLoad: true, // �Ƿ��Զ�ˢ��
		loadmask: true,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		fields: [{
				id: 'rowid',
				header: 'id',
				dataIndex: 'rowid',
				width: 150,
				hidden: true,
				editable: true,
				sortable: true

			}, {
				id: 'ItemName',
				header: '<div style="text-align:center">��Ŀ����</div>',
				allowBlank: true,
				dataIndex: 'itemname',
				width: 350,
				align: 'left',
				editable: false,
				hidden: false,
				sortable: true
			}, {
				id: 'direction',
				header: '<div style="text-align:center">��������</div>',
				allowBlank: true,
				dataIndex: 'direction',
				width: 120,
				align: 'center',
				hidden: false,
				editable: true,
				type: editCFDirectionField

			}, {
				id: 'acctcurcode',
				header: '<div style="text-align:center">����</div>',
				dataIndex: 'acctcurcode',
				width: 120,
				align: 'center',
				editable: true,
				hidden: false,
				sortable: true,
				type: editCurrNameField
			}, {
				id: 'flowsum',
				header: '<div style="text-align:center">�����������</div>',
				allowBlank: true,
				width: 150,
				align: 'right',
				hidden: true,
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}, //����ʽ��
				dataIndex: 'flowsum'
			}, {
				id: 'flowtotalsum',
				header: '<div style="text-align:center">�ۼ��������</div>',
				allowBlank: true,
				width: 150,
				align: 'right',
				hidden: false,
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				}, //����ʽ��
				dataIndex: 'flowtotalsum'
			}, {
				id: 'isInit',
				header: '<div style="text-align:center">�Ƿ���ɳ�ʼ��</div>',
				editable: false,
				hidden: true,
				width: 120,
				align: 'center',
				dataIndex: 'isInit',
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var Init = record.data['isInit']
						if (Init == "1") {
							introButton.disable();
							uploadButton.disable();
							SaveButton.disable();
							finishButton.disable();
							return
						}
				}

			}, {
				id: 'islast',
				header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
				editable: false,
				hidden: true,
				width: 120,
				align: 'center',
				dataIndex: 'islast',
				editable: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['islast']
						if (sf == "��") {
							return '<span style="cursor:hand">' + value + '</span>';
						}
						if (sf == "��") {
							return '<span style="color:blue;cursor:hand">' + value + '</span>';
						}

				}
			}
		],

		listeners: {
			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				//alert(record.get('islast'));
				//alert(InitState);
				if ((record.get('islast') == "��") || (record.get('isInit') == "1")) {
					return false;

				} else {
					return true;
				}

			},
			'render': function () {
				tbar1.render(itemGrid.tbar);
			}

		}

	});

itemGrid.btnAddHide(); //�������Ӱ�ť
itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť
itemGrid.btnSaveHide();
