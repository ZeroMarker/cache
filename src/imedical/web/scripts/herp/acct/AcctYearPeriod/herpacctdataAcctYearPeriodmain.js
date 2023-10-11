
var acctbookid = IsExistAcctBook();
var tmpUrl = '../csp/herp.acct.acctyearperiodexe.csp';
//��λ���������б��
var unitDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		},
			['rowid', 'name'])
	});

unitDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: tmpUrl + '?action=caldept&acctbookid=' + acctbookid, //&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue())});
			method: 'POST'
		});
});

// ����ڼ���������
var yearButton = new Ext.Toolbar.Button({
		text: '����ڼ���������',
		tooltip: '����ڼ���������',
		iconCls: 'adds',
		handler: function () {
			//alert("ssssssssssssssss");
			addwinFun(acctbookid);
		}
	});

//������
var acctYearField = new Ext.form.TextField({
		id: 'acctYearField',
		fieldLabel: '������',
		width: 150,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '������ݣ��磺2017��',
		name: 'acctYearField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialKey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (acctYearField.getValue() != "") {
						findButton.handler();
					}
				}
			}
		}
	});

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		width: 70,
		iconCls: 'find',
		handler: function () {

			var acctYear = acctYearField.getValue();
			//alert(acctYear);
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					acctYear: acctYear
				}
			});
		}
	});

var unitField = new Ext.form.ComboBox({
		id: 'unitField',
		fieldLabel: '��λ����ID',
		width: 200,
		listWidth: 200,
		allowBlank: false,
		store: unitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '��ѡ��λ����ID...',
		name: 'unitField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: true,
		editable: true
	});

var queryPanel = new Ext.form.FormPanel({
		title: '����ڼ�ά��',
		iconCls: 'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				items: [{
						xtype: 'displayfield',
						value: '������',
						width: 60
					}, acctYearField, {
						xtype: 'displayfield',
						value: '',
						style: 'padding-top:3px;',
						width: 50
					}, findButton]
			}
		]
	});

var itemGrid = new dhc.herp.Grid({
		//title: '����ڼ�ά��',
		width: 400,
		//edit:false,                   //�Ƿ�ɱ༭
		readerModel: 'remote',
		region: 'center',
		url: tmpUrl,

		atLoad: true, // �Ƿ��Զ�ˢ��
		loadmask: true,
		//tbar:['������:',acctYearField,'-',findButton],
		fields: [{
				id: 'AcctYearPeriodID',
				header: '����ڼ�ID',
				editable: true,
				allowBlank: true,
				width: 130,
				dataIndex: 'rowid',
				hidden: true
			},{
				id: 'BookName',
				header: '<div style="text-align:center">��λ��������</div>',
				calunit: true,
				allowBlank: false,
				width: 180,
				dataIndex: 'BookName',
				type: unitField
			}, {
				id: 'acctYear',
				header: '<div style="text-align:center">������</div>',
				editable: true,
				allowBlank: false,
				align: 'center',
				width: 80,
				dataIndex: 'acctYear'
			}, {
				id: 'acctMonth',
				header: '<div style="text-align:center">����·�</div>',
				editable: true,
				allowblank: false,
				align: 'center',
				width: 80,
				dataIndex: 'acctMonth'
			},  {
				id: 'beginDate',
				header: '<div style="text-align:center">��ʼ����</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 100,
				dataIndex: 'beginDate',
				type: "dateField"
				//dateFormat: 'Y-m-d'
			}, {
				id: 'endDate',
				header: '<div style="text-align:center">��������</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 100,
				dataIndex: 'endDate',
				type: "dateField"
				//dateFormat: 'Y-m-d'

			}, {
				id: 'periodStatus',
				header: '<div style="text-align:center">�ڼ�״̬</div>',
				allowBlank: true,
				align: 'center',
				width: 90,
				dataIndex: 'periodStatus',
				editable: false
			}, {
				id: 'startFlag',
				header: '<div style="text-align:center">��ʼ��ʶ</div>',
				editable: true,
				allowBlank: true,
				align: 'center',
				width: 70,
				dataIndex: 'startFlag',
				hidden: true
			}, {
				id: 'cashFlag',
				header: '<div style="text-align:center">���ж��˳�ʼ��</div>',
				editable: false,
				allowBlank: true,
				align: 'center',
				width: 90,
				hidden: true,
				dataIndex: 'cashFlag'
			}, {
				id: 'maxVouchNo',
				header: '<div style="text-align:center">���ƾ֤��</div>',
				editable: false,
				allowBlank: true,
				align: 'center',
				hidden: true,
				width: 180,
				dataIndex: 'maxVouchNo'
			}
		]
	});
//alert(acctbookid);
itemGrid.load({
	params: {
		sortField: '',
		sortDir: '',
		start: 0,
		limit: 25,
		acctbookid: acctbookid
	}
});

//itemGrid.addButton('-');
//itemGrid.addButton(findButton);
itemGrid.addButton('-');
itemGrid.addButton(yearButton);
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť
