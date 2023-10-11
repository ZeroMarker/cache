var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
projUrl = 'herp.acct.acctbatchprocessexe.csp';

///////////////����ڼ�
var AcctYearMonthField = new Ext.form.DateField({
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		fieldLabel: '����ڼ�',
		emptyMsg: "",
		format: 'Y-m',
		width: 120,
		triggerAction: 'all',
		allowBlank: true,
		plugins: 'monthPickerPlugin'
	});
/////////////ƾ֤����
var VouchTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});

VouchTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchType&str=' + encodeURIComponent(Ext.getCmp('VouchTypeCombo').getRawValue()),
			method: 'POST'
		});
});
var VouchTypeCombo = new Ext.form.ComboBox({
		id: 'VouchTypeCombo',
		fieldLabel: 'ƾ֤����',
		store: VouchTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		typeAhead: true,
		triggerAction: 'all',
		emptyText: '��ѡ������',
		width: 120,
		listWidth: 240,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: 'true'
	});

//////ƾ֤����ʱ�䷶Χ
var VouchDateStartField = new Ext.form.DateField({
		fieldLabel: 'ƾ֤���ڿ�ʼʱ��',
		id: 'VouchDateStartField',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

var VouchDateEndField = new Ext.form.DateField({
		fieldLabel: 'ƾ֤���ڽ���ʱ��',
		id: 'VouchDateEndField',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

/////////////////////ƾ֤�ŷ�Χ/////////////////////////
VouchNoMax = new Ext.form.TextField({
		fieldLabel: 'ƾ֤���',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});
VouchNoMin = new Ext.form.TextField({
		fieldLabel: 'ƾ֤���',
		width: 120,
		//columnWidth : .142,
		selectOnFocus: true
	});

////////////////ƾ֤����״̬
var StateStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['0', '����'], ['05', '��˲�ͨ��'], ['11', '�ύ'], ['12', '����'],
			['21', '���ͨ��'], ['31', '����'], ['41', '����']]
	});
var StateField = new Ext.form.ComboBox({
		id: 'State',
		fieldLabel: 'ƾ֤״̬',
		width: 120,
		//columnWidth : .15,
		listWidth: 240,
		selectOnFocus: true,
		allowBlank: true,
		store: StateStore,
		anchor: '90%',
		value: 0, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local',
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});

/////////////////////��ʾ��ʽ
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', 'ƾ֤��ʾ'], ['2', 'ƾ֤��¼��ʾ']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '��ʾ��ʽ',
		width: 120,
		listWidth: 150,
		selectOnFocus: true,
		allowBlank: true,
		store: typeStore,
		anchor: '90%',
		value: 1, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', // ����ģʽ
		editable: false
	});

//////��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		width: 80,
		handler: function () {
			var vouchtype = VouchTypeCombo.getValue();
			var vouchdatestart = VouchDateStartField.getValue();
			if (vouchdatestart !== "") {
				vouchdatestart = vouchdatestart.format('Y-m-d');
			}
			var vouchdateend = VouchDateEndField.getValue();
			if (vouchdateend !== "") {
				vouchdateend = vouchdateend.format('Y-m-d');
			}
			var vouchnomax = VouchNoMax.getValue();
			var vouchnomin = VouchNoMin.getValue();
			var state = StateField.getValue();
			var AcctYearMonth = AcctYearMonthField.getRawValue();
			if (AcctYearMonth != "") {
				AcctYear = AcctYearMonth.split("-")[0];
				AcctMonth = AcctYearMonth.split("-")[1];
				//AcctYear = AcctYearMonth.format('Y');
				//AcctMonth =parseInt(AcctYearMonth.format('M'));
				//alert(AcctYearMonth+"^"+AcctYear+"^"+AcctMonth);
			} else {
				var AcctYear = "";
				var AcctMonth = "";
			}
			var data = vouchtype + "^" + vouchdatestart + "^" + vouchdateend + "^" + vouchnomax + "^" + vouchnomin + "^" + state + "^" + AcctYear + "^" + AcctMonth;
			var typename = typenameCombo.getValue();

			var tmpDataMapping = [];
			var tmpUrl = ""

				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("ƾ֤��ʾ");
					type = 1;
					for (var i = 1; i < cmItems.length; i++) {
						//alert(cmItems[i].dataIndex);
						tmpDataMapping.push(cmItems[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=list' + '&data=' + data + '&userid=' + userid;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
				} else {
					itemGrid.setTitle("ƾ֤��¼��ʾ");
					type = 2;
					for (var i = 1; i < cmItems2.length; i++) {
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=ListEntry' + '&data=' + data + '&userid=' + userid;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
				}
				MoidLogDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})

				MoidLogDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);

			itemGrid.reconfigure(MoidLogDs, tmpColumnModel);
			var limits=Ext.getCmp("PageSizePlugin").getValue();
			 //alert(limits);
	         if(!limits){limits=25};
			itemGrid.store.load({
				params: {
					start: 0,
					limit: limits,
					data: data,
					userid: userid
				}
			});
		}
	});

//////�ύ
var submitButton = new Ext.Toolbar.Button({
		text: '�ύƾ֤',
		tooltip: '�ύ',
		iconCls: 'submit',
		handler: function () {
			submitFun();
		}
	});

//////����
var copyButton = new Ext.Toolbar.Button({
		text: '����ƾ֤',
		tooltip: '����',
		iconCls: 'copy',
		handler: function () {
			copyFun();
		}
	});

//////����1
var destroyButton = new Ext.Toolbar.Button({
		text: '����ƾ֤',
		tooltip: '����',
		iconCls: 'destroy',
		handler: function () {
			destroyFun();
		}
	});

//////����
var cacelButton = new Ext.Toolbar.Button({
		text: '����ƾ֤',
		tooltip: '����',
		iconCls: 'cancel',
		handler: function () {
			cacelFun();
		}
	});

//��ʾ���
var MoidLogProxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=list&userid=' + userid,
		method: 'POST'
	});
var MoidLogDs = new Ext.data.Store({
		proxy: MoidLogProxy,
		//autoLoad:true,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['VouchID', 'AcctYear', 'AcctMonth', 'VouchDate', 'VouchNo', 'typename',
				'Operator', 'MakeBillDate', 'Auditor', 'Poster',
				'VouchState', 'VouchProgress', 'IsDestroy', 'IsCancel', 'VouchState1', 'upload', 'download']),
		// turn on remote sorting
		remoteSort: true
	});
var MoidLogCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel(), {
				id: 'VouchID',
				header: 'ƾ֤��ID',
				editable: false,
				width: 130,
				dataIndex: 'VouchID',
				hidden: true
			}, {
				id: 'AcctYear',
				header: '��',
				align: 'center',
				width: 50,
				editable: false,
				dataIndex: 'AcctYear'

			}, {
				id: 'AcctMonth',
				header: '��',
				align: 'center',
				width: 40,
				editable: false,
				dataIndex: 'AcctMonth'

			}, {
				id: 'VouchDate',
				header: 'ƾ֤����',
				align: 'center',
				width: 90,
				editable: false,
				dataIndex: 'VouchDate'

			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
				//align: 'center',
				editable: false,
				width: 120,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "��") {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
							 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
						}
				},
				dataIndex: 'VouchNo'

			}, {
				id: 'typename',
				header: 'ƾ֤����',
				align: 'center',
				width: 90,
				editable: false,
				dataIndex: 'typename'
			}, {
				id: 'Operator',
				header: '�Ƶ���',
				align: 'center',
				width: 120,
				editable: false,
				dataIndex: 'Operator'

			}, {
				id: 'MakeBillDate',
				header: '�Ƶ�����',
				align: 'center',
				width: 90,
				editable: false,
				dataIndex: 'MakeBillDate'

			}, {
				id: 'Auditor',
				header: '�����',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Auditor'

			}, {
				id: 'Poster',
				header: '������',
				align: 'center',
				width: 100,
				editable: false,
				dataIndex: 'Poster'
			}, {
				id: 'VouchState',
				header: 'ƾ֤״̬',
				align: 'center',
				width: 90,
				editable: false,
				dataIndex: 'VouchState'
			}, {
				id: 'VouchProgress',
				header: 'ƾ֤�������',
				align: 'center',
				width: 110,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
				},
				dataIndex: 'VouchProgress'
			}, {
				id: 'IsDestroy',
				header: '����',
				align: 'center',
				width: 70,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsDestroy']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsDestroy'
			}, {
				id: 'IsCancel',
				header: '����',
				align: 'center',
				width: 70,
				editable: false,
				//hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					var sf = record.data['IsCancel']
						if (sf == "��") {
							//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:red;backgroundColor:white">' + value + '</span>';
						}
				},
				dataIndex: 'IsCancel'
			}, {
				id: 'VouchState1',
				header: 'ƾ֤״̬',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'VouchState1'
			}, {
				id: 'upload',
				header: '����',
				hidden: true,
				allowBlank: false,
				width: 40,
				editable: false,
				dataIndex: 'upload',

				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>�ϴ�</u></span>';
				}
			}, {
				id: 'download',
				header: '����',
				allowBlank: false,
				width: 40,
				editable: false,
				hidden: true,
				dataIndex: 'download',
				renderer: function (v, p, r) {
					return '<span style="color:blue"><u>����</u></span>';
				}
			}
		]);

var MoidLogPagTba = new Ext.PagingToolbar({
		store: MoidLogDs,
		pageSize: 25,
		displayInfo: true,
		plugins: new dhc.herp.PageSizePlugin(),
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û�м�¼"
	});

var queryPanel = new Ext.FormPanel({
		height : 80,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px;',
			labelWidth: 80
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '����ڼ�',
						//style: 'padding-top:3px;',
						width: 65
					},
					AcctYearMonthField, {
						xtype: 'displayfield',
						value: '',
						width: 50
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤��ʾ��ʽ',
						//style: 'padding-top:3px;',
						width: 95
					},
					typenameCombo, {
						xtype: 'displayfield',
						value: '',
						width: 65
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤��',
						//style: 'padding-top:3px;',
						width: 50
					},
					VouchNoMax, {
						xtype: 'displayfield',
						value: '--'
					},
					VouchNoMin
				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: 'ƾ֤����',
						//style: 'padding-top:3px;',
						width: 65
					},
					VouchTypeCombo, {
						xtype: 'displayfield',
						value: '',
						width: 50
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤����״̬',
						//style: 'padding-top:3px;',
						width: 95
					},
					StateField, {
						xtype: 'displayfield',
						value: '',
						width: 50
					}, {
						xtype: 'displayfield',
						value: 'ƾ֤����',
						//style: 'padding-top:3px;',
						width: 65
					},
					VouchDateStartField, {
						xtype: 'displayfield',
						value: '--'
					},
					VouchDateEndField, {
						xtype: 'displayfield',
						value: '',
						width: 50
					},
					findButton
				]
			}
		]
	});
/* var button1= new Ext.FormPanel({frame : true,
[submitButton,'-',copyButton,'-',destroyButton,'-',cacelButton]
}); */


/*   itemGrid.store.load({params:{start :  0,
limit : 25}}); */
//ƾ֤��ʾ
var cmItems = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel(), {
		id: 'VouchID',
		header: 'ƾ֤��ID',
		editable: false,
		width: 130,
		dataIndex: 'VouchID',
		hidden: true
	}, {
		id: 'AcctYear',
		header: '��',
		align: 'center',
		width: 50,
		editable: false,
		dataIndex: 'AcctYear'

	}, {
		id: 'AcctMonth',
		header: '��',
		align: 'center',
		width: 40,
		editable: false,
		dataIndex: 'AcctMonth'

	}, {
		id: 'VouchDate',
		header: 'ƾ֤����',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">ƾ֤��</div>',
		//align: 'center',
		editable: false,
		width: 120,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'

	}, {
		id: 'typename',
		header: 'ƾ֤����',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'typename'
	}, {
		id: 'Operator',
		header: '�Ƶ���',
		align: 'center',
		width: 110,
		editable: false,
		dataIndex: 'Operator'

	}, {
		id: 'MakeBillDate',
		header: '�Ƶ�����',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'MakeBillDate'

	}, {
		id: 'Auditor',
		header: '�����',
		align: 'center',
		width: 110,
		editable: false,
		dataIndex: 'Auditor'

	}, {
		id: 'Poster',
		header: '������',
		align: 'center',
		width: 110,
		editable: false,
		dataIndex: 'Poster'
	}, {
		id: 'VouchState',
		header: 'ƾ֤״̬',
		align: 'center',
		width: 90,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: 'ƾ֤�������',
		align: 'center',
		width: 110,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>';
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'IsDestroy',
		header: '����',
		align: 'center',
		width: 70,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '����',
		align: 'center',
		width: 70,
		editable: false,
		//hidden: true,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: 'ƾ֤״̬',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'upload',
		header: '����',
		hidden: true,
		allowBlank: false,
		width: 40,
		editable: false,
		dataIndex: 'upload',

		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>�ϴ�</u></span>';
		}
	}, {
		id: 'download',
		header: '����',
		allowBlank: false,
		width: 40,
		editable: false,
		hidden: true,
		dataIndex: 'download',
		renderer: function (v, p, r) {
			return '<span style="color:blue"><u>����</u></span>';
		}
	}
];
/////ƾ֤��¼��ʾ
var cmItems2 = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel(), {
		id: 'VouchID',
		header: '<div style="text-align:center">id</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'VouchID'
	}, {
		id: 'AcctYear',
		header: '<div style="text-align:center">��</div>',
		width: 50,
		editable: false,
		align: 'center',
		dataIndex: 'AcctYear'
	}, {
		id: 'AcctMonth',
		header: '<div style="text-align:center">��</div>',
		width: 40,
		editable: false,
		align: 'center',
		dataIndex: 'AcctMonth'
	}, {
		id: 'VouchDate',
		header: '<div style="text-align:center">ƾ֤����</div>',
		width: 90,
		editable: false,
		align: 'center',
		dataIndex: 'VouchDate'

	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">ƾ֤��</div>',
		width: 120,
		editable: false,
		//align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>' + '<b> </b>'
					 + '<span style="color:red;cursor:hand;backgroundColor:white">��</span>';
				} else {
					return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>' + value + '</u></span>';
				}
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'VouchRow',
		header: '<div style="text-align:center">���</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'VouchRow'
	}, {
		id: 'Summary',
		header: '<div style="text-align:center">ժҪ</div>',
		width: 170,
		editable: false,
		dataIndex: 'Summary'
	}, {
		id: 'AcctSubjCode',
		header: '<div style="text-align:center">��Ŀ����</div>',
		width: 80,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjCode'
	}, {
		id: 'AcctSubjName',
		header: '<div style="text-align:center">��Ŀ����</div>',
		width: 180,
		editable: false,
		//align: 'center',
		dataIndex: 'AcctSubjName'
	}, {
		id: 'AmtDebit',
		header: '<div style="text-align:center">�跽���</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtDebit'
	}, {
		id: 'AmtCredit',
		header: '<div style="text-align:center">�������</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'AmtCredit'
	}, {
		id: 'VouchState',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		width: 80,
		align: 'center',
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '<div style="text-align:center">ƾ֤�������</div>',
		width: 100,
		align: 'center',
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchProgress'
	}, {
		id: 'Operator',
		header: '<div style="text-align:center">�Ƶ���</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Operator'
	}, {
		id: 'Auditor',
		header: '<div style="text-align:center">�����</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Auditor'
	}, {
		id: 'Poster',
		header: '<div style="text-align:center">������</div>',
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'Poster'
	}, {
		id: 'IsDestroy',
		header: '<div style="text-align:center">����ƾ֤</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsDestroy']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">����ƾ֤</div>',
		width: 80,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			var sf = record.data['IsCancel']
				if (sf == "��") {
					//cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
					return '<span style="color:red;backgroundColor:white">' + value + '</span>';
				}
		},
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		width: 80,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'Operator1',
		header: '<div style="text-align:center">������</div>',
		width: 110,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">�����</div>',
		width: 110,
		editable: false,
		hidden: true,
		dataIndex: 'Auditor1'
	}
]

//uploadMainFun(itemGrid,'VouchID','P007',16);
//downloadMainFun(itemGrid,'VouchID','P007',17);

var itemGrid = new Ext.grid.EditorGridPanel({
		//title : 'ƾ֤��ʾ',
		region: 'center',
		pageSize: 25,
		store: MoidLogDs,
		cm: MoidLogCm,
		//atLoad : true,
		clicksToEdit: 1,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		tbar: [submitButton, '-', copyButton, '-', destroyButton, '-', cacelButton],
		bbar: MoidLogPagTba,
		loadMask: true
	});

itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	var a = typenameCombo.getValue()
		if (a == 2) {
			var b = 14
		} else {
			var b = 13
		}
		//ƾ֤�ŵ�����
		if (columnIndex == '6') {
			//p_URL = 'acct.html?acctno=2';
			//document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
					layout: 'fit',
					//scrolling="auto"
					html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + VouchState + '&bookID=' + bookID + '&searchFlag=' + 1 + '" /></iframe>'
					//frame : true
				});

			var win = new Ext.Window({
					title: 'ƾ֤�鿴',
					width: 1093,
					height: 620,
					resizable: false,
					closable: true,
					draggable: true,
					resizable: false,
					layout: 'fit',
					modal: false,
					plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
					//bodyStyle : 'padding:5px;',
					items: [myPanel],
					buttonAlign: 'center',
					buttons: [{
							text: '�ر�',
							type: 'button',
							handler: function () {
								win.close();
							}
						}
					]
				});
			win.show();
		}
		//ƾ֤������̵�����
		if (columnIndex == b) {
			var records = itemGrid.getSelectionModel().getSelections();
			var VouchID = records[0].get("VouchID");
			VouchProgressFun(VouchID);
		}
});

function GetYearMonth() {
	Ext.Ajax.request({
		url: projUrl + '?action=GetCurYearMonth&userid=' + userid,
		method: 'POST',
		failure: function (result, request) {
			Ext.Msg.show({
				title: '����',
				msg: '������������!',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			//alert(jsonData.success );
			if (jsonData.success == 'true') {
				//alert("dddd="+jsonData.info)
				AcctYearMonthField.setValue(jsonData.info + "-01");
			}
		},
		scope: this
	});
}
GetYearMonth();

// itemGrid.btnAddHide();  //�������Ӱ�ť
//itemGrid.btnSaveHide();  //���ر��水ť
//itemGrid.btnResetHide();  //�������ð�ť
// itemGrid.btnDeleteHide(); //����ɾ����ť
// itemGrid.btnPrintHide();  //���ش�ӡ��ť
