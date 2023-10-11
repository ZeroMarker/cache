var projUrl = "../csp/herp.acct.acctbatchauditexe.csp"

	// �������ڼ�ʱ��ؼ�
	var AcctYearMonthField = new Ext.form.DateField({
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		fieldLabel: '����ڼ�',
		emptyMsg: "",
		format: 'Y-m',
		width: 150,
		triggerAction: 'all',
		allowBlank: true,
		plugins: 'monthPickerPlugin'

	});

/////////////////////ƾ֤���

var VouchTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});
VouchTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchType',
			method: 'POST'
		});
});
var VouchTypeCombo = new Ext.form.ComboBox({
		fieldLabel: 'ƾ֤���',
		store: VouchTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '��ѡ��ƾ֤���',
		width: 192,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

//-------ƾ֤��Դ
var VouchSourceDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});
VouchSourceDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetVouchSource',
			method: 'POST'
		});
});
var VouchSourceCombo = new Ext.form.ComboBox({
		fieldLabel: 'ƾ֤��Դ',
		store: VouchSourceDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '��ѡ��ƾ֤��Դ',
		width: 190,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////�Ƶ���
var OperatorDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'name'])
	});

OperatorDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=CalUsername&userdr=' + userdr,
			method: 'POST'
		});
});
var OperatorCombo = new Ext.form.ComboBox({
		fieldLabel: '�Ƶ���',
		store: OperatorDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '��ѡ���Ƶ���',
		width: 150,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////ƾ֤��
var miniVouchNoField = new Ext.form.TextField({
		id: 'miniVouchNo',
		fieldLabel: '��Сƾ֤��',
		width: 90,
		allowBlank: true,
		selectOnFocus: 'true'
	});

var maxVouchNoField = new Ext.form.TextField({
		id: 'maxVouchNo',
		fieldLabel: '���ƾ֤��',
		width: 90,
		allowBlank: true,
		selectOnFocus: 'true'
	});

/////////////////////���״̬
var VouchStateGroup = new Ext.form.RadioGroup({
		//fieldLabel:'״̬',
		xtype: 'radiogroup',
		width: 190,
		defaults: {
			style: "margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: 'ȫ��',
				inputValue: '',
				name: 'sevType'
			}, {
				id: 'checked',
				boxLabel: '�����',
				inputValue: '21',
				name: 'sevType'
			}, {
				id: 'unchecked',
				boxLabel: 'δ���',
				inputValue: '11', //δ���Ϊʲô��11������
				name: 'sevType',
				checked: true
			}
		]

	});
/*
var checkstate=Ext.form.RadioGroup({


fieldLabel: 'Auto Layout',
items: [{boxLabel: 'Item 1', name: 'rb-auto', inputValue: 1,checked: true},{boxLabel: 'Item 2', name: 'rb-auto', inputValue: 2},{boxLabel: 'Item 3', name: 'rb-auto', inputValue: 3}
]

});
 */

//////////////////////�Ƶ�����
var startDateField = new Ext.form.DateField({
		id: 'startDateField',
		// fieldLabel: '��ʼ����',
		fieldLabel: '�Ƶ�����',
		width: 90,
		allowBlank: true,
		emptyText: '��ʼ����',
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

var endDateField = new Ext.form.DateField({
		id: 'endDateField',
		// fieldLabel: '��ֹ����',
		width: 90,
		allowBlank: true,
		emptyText: '��ֹ����',
		//format:'Y-m-d',
		selectOnFocus: 'true'
	});

//////////////////////����״̬
var IsDes = new Ext.form.Checkbox({
		id: 'IsDestroy',
		fieldLabel: '����ƾ֤',
		style: 'border:0;background:none;margin-top:2px;'
		/* ,
		inputValue : 1,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					applyNofield.focus();
				}
			}
		} */

	});

var IsCanc = new Ext.form.Checkbox({
		id: 'IsCancel',
		fieldLabel: '����ƾ֤',
		style: 'border:0;background:none;margin-top:2px;'
		/* ,
		inputValue : 1,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					applyNofield.focus();
				}
			}
		} */

	});

/* IsCanc.on('check', function( c , checked ){
if(checked){
alert(IsCanc.getValue());
}else{
}
}); */

/////////////////////��ʾ��ʽ
var typeStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', 'ƾ֤��ʾ'], ['2', 'ƾ֤��¼��ʾ']]
	});
var typenameCombo = new Ext.form.ComboBox({
		id: 'typenameCombo',
		fieldLabel: '��ʾ��ʽ',
		width: 150,
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

var findButton = new Ext.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		width: 80,
		iconCls: 'find',
		handler: function () {
			//var AcctYearMonth = AcctYearMonthField.getValue()
			var AcctYearMonth = AcctYearMonthField.getRawValue();
			if (AcctYearMonth != "") {
				AcctYear = AcctYearMonth.split("-")[0];
				AcctMonth = AcctYearMonth.split("-")[1];
				//AcctYear = AcctYearMonth.format('Y');
				//AcctMonth =AcctYearMonth.format('M');
			} else {
				var AcctYear = "";
				var AcctMonth = "";
			}
			var VouchType = VouchTypeCombo.getValue();
			var VouchSource = VouchSourceCombo.getValue();
			var Operator = OperatorCombo.getValue();
			var miniVouchNo = miniVouchNoField.getValue();
			var maxVouchNo = maxVouchNoField.getValue();
			//var typename = typenameCombo.getValue();
			var VouchState = VouchStateGroup.getValue().inputValue;
			// alert(VouchState)
			var startDate = startDateField.getValue();
			if (startDate !== "") {
				startDate = startDate.format('Y-m-d');
			}
			var endDate = endDateField.getValue();
			if (endDate !== "") {
				endDate = endDate.format('Y-m-d');
			}
			var IsDestroy = IsDes.getValue();
			var IsCancel = IsCanc.getValue();
			// alert(IsDestroy+"^"+IsCancel)
			var typename = typenameCombo.getValue();

			var tmpDataMapping = [];
			var tmpUrl = ""
				if (typenameCombo.getValue() == 1) {
					itemGrid.setTitle("ƾ֤��ʾ");
					type = 1;
					for (var i = 1; i < cmItems.length; i++) {
						tmpDataMapping.push(cmItems[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=Vouchlist' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth + '&VouchType=' + VouchType + '&VouchSource=' + VouchSource
						 + '&Operator=' + Operator + '&miniVouchNo=' + miniVouchNo + '&maxVouchNo=' + maxVouchNo + '&VouchState=' + VouchState
						 + '&startDate=' + startDate + '&endDate=' + endDate + '&IsDestroy=' + IsDestroy + '&IsCancel=' + IsCancel + '&bookID=' + bookID + '&userdr=' + userdr;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
				} else {
					itemGrid.setTitle("ƾ֤��¼��ʾ");
					type = 2;
					for (var i = 1; i < cmItems2.length; i++) {
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = projUrl + '?action=list' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth + '&VouchType=' + VouchType + '&VouchSource=' + VouchSource
						 + '&Operator=' + Operator + '&miniVouchNo=' + miniVouchNo + '&maxVouchNo=' + maxVouchNo + '&VouchState=' + VouchState
						 + '&startDate=' + startDate + '&endDate=' + endDate + '&IsDestroy=' + IsDestroy + '&IsCancel=' + IsCancel + '&bookID=' + bookID + '&userdr=' + userdr;
					itemGrid.url = tmpUrl;
					var tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
				}
				/*
				var tmpStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
				url : ''
				}),
				reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
				}),
				remoteSort : true
				});*/
				MoidLogDs.proxy = new Ext.data.HttpProxy({
					url: tmpUrl,
					method: 'POST'
				})
				MoidLogDs.reader = new Ext.data.JsonReader({
					totalProperty: "results",
					root: 'rows'
				}, tmpDataMapping);
			itemGrid.reconfigure(MoidLogDs, tmpColumnModel);
			//itemGrid.bbar.bind(tmpStore);
			//itemGrid.bbar.bindStore(tmpStore);itemGrid.bbar.destroy();
			//for(var x in itemGrid.bbar.store){alert(x);};
			//alert(itemGrid.bbar.pageSize);

			itemGrid.store.load({
				params: {
					start: 0,
					limit: 25
				}
			});
		}
	});

var queryPanel = new Ext.FormPanel({
		height: 105,
		region: 'north',
		frame: true,
		items: [{
				defaults: {
					labelAlign: 'right', //��ǩ���뷽ʽ
					labelSeparator: ':', //�ָ���
					labelWidth: 80,
					border: false,
					bodyStyle: 'padding:5 0 0 0 ;'
				},
				width: 1200,
				layout: 'column',
				items: [{
						xtype: 'fieldset',
						// columnWidth:.2,
						width: 280,
						items: [AcctYearMonthField, typenameCombo, OperatorCombo]
					}, {
						xtype: 'fieldset',
						// columnWidth:.2,
						width: 320,
						items: [
							VouchTypeCombo, {
								layout: 'column',
								bodyStyle: 'padding:2 0 2 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 35
									}, {
										xtype: 'tbtext',
										width: 50,
										text: 'ƾ֤��:'
									}, miniVouchNoField, {
										xtype: 'tbtext',
										text: "--"
									}, maxVouchNoField
								]
							}, {
								layout: 'column',
								bodyStyle: 'padding:3 0 3 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '�Ƶ�����:'
									}, startDateField, {
										xtype: 'tbtext',
										text: "--"
									}, endDateField
								]
							}

						]

					}, {
						xtype: 'fieldset',
						// columnWidth:.25,
						width: 320,
						items: [
							VouchSourceCombo, {
								layout: 'column',
								bodyStyle: 'padding:2 0 2 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '���״̬:'
									}, VouchStateGroup]
							}, {
								layout: 'column',
								bodyStyle: 'padding:3 0 3 0 ;',
								items: [{
										xtype: 'displayfield',
										width: 20
									}, {
										xtype: 'tbtext',
										width: 65,
										text: '����״̬:'
									}, IsDes, {
										xtype: 'tbtext',
										text: "����ƾ֤"
									}, {
										xtype: 'displayfield',
										width: 20
									}, IsCanc, {
										xtype: 'tbtext',
										text: "����ƾ֤"
									}
								]
							}
						]
					}, {
						xtype: 'fieldset',
						items: [/* {
							xtype: 'displayfield',
							width: 20
							},  */
							findButton]
					}

				]
			}
		]

	});

//ƾ֤��ʾ
var cmItems = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel({
		editable: false
	}), {
		id: 'AcctVouchID',
		header: '<div style="text-align:center">ID</div>',
		allowBlank: false,
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'AcctVouchID'
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
		width: 110,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchNo'
	}, {
		id: 'VouchBillNum',
		header: '<div style="text-align:center">������</div>',
		width: 60,
		editable: false,
		align: 'center',
		dataIndex: 'VouchBillNum'
	}, {
		id: 'TotalAmtDebit',
		header: '<div style="text-align:center">�ܽ��</div>',
		width: 130,
		editable: false,
		align: 'right',
		dataIndex: 'TotalAmtDebit'
	}, {
		id: 'Operator',
		header: '<div style="text-align:center">�Ƶ���</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Operator'
	}, {
		id: 'Auditor',
		header: '<div style="text-align:center">�����</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Auditor'
	}, {
		id: 'Poster',
		header: '<div style="text-align:center">������</div>',
		align: 'center',
		width: 100,
		editable: false,
		dataIndex: 'Poster'
	}, {
		id: 'VouchState',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'VouchState'
	}, {
		id: 'VouchProgress',
		header: '<div style="text-align:center">ƾ֤�������</div>',
		align: 'center',
		width: 100,
		editable: false,
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
		},
		dataIndex: 'VouchProgress'

	}, {
		id: 'IsDestroy',
		header: '<div style="text-align:center">����ƾ֤</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">����ƾ֤</div>',
		align: 'center',
		width: 80,
		editable: false,
		dataIndex: 'IsCancel'
	}, {
		id: 'VouchState1',
		header: '<div style="text-align:center">ƾ֤״̬</div>',
		align: 'center',
		width: 80,
		editable: false,
		hidden: true,
		dataIndex: 'VouchState1'
	}, {
		id: 'Operator1',
		header: '<div style="text-align:center">������</div>',
		align: 'center',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">�����</div>',
		align: 'center',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Auditor1'
	}
];

/////ƾ֤��¼��ʾ
var cmItems2 = [new Ext.grid.RowNumberer(),
	new Ext.grid.CheckboxSelectionModel({
		editable: false
	}), {
		id: 'rowid',
		header: '<div style="text-align:center">id</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'AcctVouchID'
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
		width: 100,
		editable: false,
		align: 'center',
		dataIndex: 'VouchDate'
	}, {
		id: 'VouchNo',
		header: '<div style="text-align:center">ƾ֤��</div>',
		width: 110,
		editable: false,
		align: 'center',
		renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
			return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">' + value + '</span>'
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
		width: 150,
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
		width: 130,
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
		dataIndex: 'IsDestroy'
	}, {
		id: 'IsCancel',
		header: '<div style="text-align:center">����ƾ֤</div>',
		width: 80,
		editable: false,
		align: 'center',
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
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Operator1'
	}, {
		id: 'Auditor1',
		header: '<div style="text-align:center">�����</div>',
		width: 100,
		editable: false,
		hidden: true,
		dataIndex: 'Auditor1'
	}
]

function GetYearMonth() {
	Ext.Ajax.request({
		url: projUrl + '?action=GetYearMonth' + '&bookID=' + bookID,
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
			if (jsonData.success == 'false') {
				// alert(jsonData.info);
				var date = jsonData.info + "-01"
					AcctYearMonthField.setValue(date);
			}
		},
		scope: this
	});
}
GetYearMonth();
