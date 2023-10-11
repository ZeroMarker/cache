var userdr = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.acctsubjledgerexe.csp";

var InitState = "";

Ext.Ajax.request({

	url: projUrl + '?action=getBookInitState&bookID=' + bookID,
	method: 'POST',
	////async:false��Ĭ��Ϊtrue��  ��ʾͬ�����أ�����ajax��successִ�����֮����ִ��������

	////async:true  ��ʾ�첽���أ����ܻ���ajaxִ�����֮�󣬾�ִ������ķ������Ӷ�����data��û��ֵ��

	//async:false,
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {

			InitState = jsonData.info;
			//alert(InitState);
			if (InitState == "1") {
				itemGrid.edit = false;
				ledgerButton.disable();
				importButton.disable();
			}
		}
	}
});


var StartMonth = "";
Ext.Ajax.request({
	url: '../csp/herp.acct.acctsubjledgerexe.csp?action=GetStartMonth&bookID=' + bookID,
	method: 'GET',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			StartMonth = jsonData.info;
			if (StartMonth == 1) {
				itemGrid.getColumnModel().setHidden(7, true);
				itemGrid.getColumnModel().setHidden(8, true);

			}

		}
	}
});

///////////////��Ŀ����
var subjcodeField = new Ext.form.TextField({
		id: 'subjcodeField',
		fieldLabel: '��Ŀ����',
		width: 130,
		allowBlank: true,
		//style: 'padding:5px;',
		selectOnFocus: 'true',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					findButton.handler();
				}
			}
		}
	});

/////////////////////��Ŀ���

var AcctTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: "results",
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

AcctTypeDs.on('beforeload', function (ds, o) {

	ds.proxy = new Ext.data.HttpProxy({

			url: projUrl + '?action=GetAcctType',
			method: 'POST'
		});
});
var AcctTypeCombo = new Ext.form.ComboBox({
		fieldLabel: '��Ŀ���',
		store: AcctTypeDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead: true,
		//forceSelection : true,
		triggerAction: 'all',
		emptyText: '��ѡ���Ŀ���',
		width: 150,
		listWidth: 220,
		pageSize: 10,
		minChars: 1,
		allowBlank: true
		//selectOnFocus : true
	});

///////////////��Ŀ����///////////////////////

var subjLevelDs = new Ext.data.SimpleStore({ //����״̬
		fields: ['key', 'keyValue'],
		data: [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
			['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']]
	});
////����������--����״̬��ѯ----IsChecked1-----////
var subjLevelField = new Ext.form.ComboBox({
		id: 'subjLevelField',
		fieldLabel: '��Ŀ����',
		width: 120,
		listWidth: 120,
		store: subjLevelDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText: 'ȫ��',
		selectOnFocus: true,
		forceSelection: true
	});

var tmpDataMapping = [];
var tmpUrl = "";
var tmpColumnModel = "";

/////////////////////������ҿ�Ŀ

var subjnumfcStore = new Ext.data.SimpleStore({
		fields: ['rowid', 'method'],
		data: [['1', '����'], ['2', '����'], ['3', '���']]
	});
var subjnumfcCombo = new Ext.form.ComboBox({
		fieldLabel: '������ҿ�Ŀ',
		width: 120,
		listWidth: 120,
		selectOnFocus: true,
		allowBlank: true,
		store: subjnumfcStore,
		anchor: '90%',
		value: 1, //Ĭ��ֵ
		valueNotFoundText: '',
		displayField: 'method',
		valueField: 'rowid',
		triggerAction: 'all',
		emptyText: '',
		mode: 'local', //����ģʽ

		listeners: {
			//scope : this,
			'select': function () {
				if (subjnumfcCombo.getValue() == 1) {
					itemGrid.setTitle("�����ʾ");
					for (var i = 1; i < cmItems.length; i++) {
						//alert(cmItems[i].dataIndex);
						tmpDataMapping.push(cmItems[i].dataIndex);
					};
					//����ID �õ�������
					/* 			    var cl = itemGrid.getColumnModel().getIndexById("BeginSum");
					//alert(cl);
					//���ø�lieΪ���ɱ༭��
					itemGrid.getColumnModel().setEditable(cl, true);   */
					tmpUrl = "../csp/herp.acct.acctsubjledgerexe.csp";
					itemGrid.url = tmpUrl;
					itemGrid.fields = cmItems;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
					itemGrid.createColumns();
					//alert(StartMonth)

				}
				if (subjnumfcCombo.getValue() == 2) {
					itemGrid.setTitle("������ʾ");
					for (var i = 1; i < cmItems2.length; i++) {
						//alert(cmItems2[i].dataIndex);
						tmpDataMapping.push(cmItems2[i].dataIndex);
					}
					tmpUrl = "../csp/herp.acct.acctsubjledgernumexe.csp";
					itemGrid.url = tmpUrl;
					itemGrid.fields = cmItems2;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems2);
					itemGrid.createColumns();

				}

				if (subjnumfcCombo.getValue() == 3) {
					itemGrid.setTitle("�����ʾ");
					for (var i = 1; i < cmItems3.length; i++) {
						tmpDataMapping.push(cmItems3[i].dataIndex);
					}

					tmpUrl = "../csp/herp.acct.acctsubjledgerfcexe.csp";
					itemGrid.url = tmpUrl;

					itemGrid.fields = cmItems3;
					tmpColumnModel = new Ext.grid.ColumnModel(cmItems3);
					itemGrid.createColumns();
				}

				itemGrid.store.proxy = new Ext.data.HttpProxy({
						url: tmpUrl + '?action=list&bookID=' + bookID,
						method: 'POST'
					});

				itemGrid.store.reader = new Ext.data.JsonReader({
						totalProperty: "results",
						root: 'rows'
					}, tmpDataMapping);

				itemGrid.reconfigure(itemGrid.store, tmpColumnModel);

				if (StartMonth == 1) {
					if (subjnumfcCombo.getValue() == 1) {
						itemGrid.getColumnModel().setHidden(7, true);
						itemGrid.getColumnModel().setHidden(8, true);
					} else if (subjnumfcCombo.getValue() == 2) {
						itemGrid.getColumnModel().setHidden(8, true);
						itemGrid.getColumnModel().setHidden(9, true);
						itemGrid.getColumnModel().setHidden(10, true);
						itemGrid.getColumnModel().setHidden(11, true);
					} else if (subjnumfcCombo.getValue() == 3) {
						itemGrid.getColumnModel().setHidden(10, true);
						itemGrid.getColumnModel().setHidden(11, true);
						itemGrid.getColumnModel().setHidden(12, true);
						itemGrid.getColumnModel().setHidden(13, true);
					}
					//itemGrid.view.refresh();
				}
				var limits=Ext.getCmp('PageSizePlugin').getValue();
				if (!limits){limits=25;}
				var subjcode = subjcodeField.getValue();
				var AcctType = AcctTypeCombo.getValue();
				var subjLevel = subjLevelField.getValue();
				
				itemGrid.store.load({
					params: {
						start: 0,
							limit: limits,
							subjcode:subjcode,
							subjLevel:subjLevel,
							AcctType:AcctType
					}
				});

			}

		}

	});

///////////////��������ѡ��///////////////////////

var importDs = new Ext.data.SimpleStore({ //����״̬
		fields: ['key', 'keyValue'],
		data: [['1', '��������ڳ�����'], ['2', '��ҽ���ڳ����ݵ���']]
	});
var importField = new Ext.form.ComboBox({
		id: 'importField',
		fieldLabel: '��������ѡ��',
		width: 150,
		listWidth: 150,
		store: importDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText: 'ȫ��',
		selectOnFocus: true,
		forceSelection: true
	});

var importButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����Excel�ļ�',
		iconCls: 'in',
		width: 55,
		handler: function () {
			//���ñ��溯��
			var importFields = importField.getValue();
			if (importFields == "") {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ��������! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
			} else {
				//alert(importFields);
				doimport(importFields);
			}

		}
	});

var ledgerButton = new Ext.Toolbar.Button({
		text: '�˲�����',
		iconCls: 'submit',
		handler: function () {
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: projUrl + '?action=Ledgersave&bookID=' + bookID + '&userdr=' + userdr,
						waitMsg: '������...',
						failure: function (result, request) {
							Ext.Msg.show({
								title: '����',
								msg: '������������!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},

						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: 'ע��',
									msg: '�˲����ɳɹ�!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								itemGrid.load({
									params: {
										start: 0,
										limit: 25,
										bookID: bookID
									}
								});

							} else {
								if (jsonData.info = "100") {

									message = "�˲����ɳɹ�";
								}
								Ext.Msg.show({
									title: '��ʾ',
									msg: message,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
							}
						},
						scope: this
					});
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ�����˲���?', handler);
		}
	});

var findButton = new Ext.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		width: 55,
		iconCls: 'find',
		handler: function () {
			var subjcode = subjcodeField.getValue();
			var AcctType = AcctTypeCombo.getValue();
			var subjLevel = subjLevelField.getValue();
			//var bookID= GetAcctBookID();
			//alert(bookID);
			itemGrid.load({
				params: {
					start: 0,
					limit: 25,
					subjcode: subjcode,
					AcctType: AcctType,
					subjLevel: subjLevel,
					bookID: bookID
				}

			});

		}
	});
//ɾ����ť
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		width: 55,
		iconCls: 'remove',
		handler: function () {
			itemGrid.del();

		}
	});

//���水ť
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		width: 55,
		handler: function () {
			itemGrid.save();
			//ChangeColum();
		}

	});



  var query = new Ext.FormPanel({
	    title: '��Ŀ��ʼ���ά��',
		iconCls:'maintain',
		region: 'north',
		height: 110,
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
						value: '��Ŀ����',
						style: 'padding:0px 5px 0px 34px;'
						//width: 60
					}, subjcodeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '��Ŀ���',
						style: 'padding:0px 5px;'
						//width: 80
					}, AcctTypeCombo,{
						xtype: 'displayfield',
						value: '',
						width: 30
					},{
						xtype: 'displayfield',
						value: '��Ŀ����',
						style: 'padding:0px 5px;'
						//width: 70
					}, subjLevelField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '������ҿ�Ŀ',
						style: 'padding:0px 5px;'
						//width: 40
					}, subjnumfcCombo, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},findButton
				]
			}, {
				xtype: 'panel',
				layout: 'column',
				columnWidth: 1,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '��������ѡ��',
						style: 'padding:0px 5px;'
						//width: 65
					},
					importField, {
						xtype: 'displayfield',
						value: '',
						width: 20
					},importButton, {
						xtype: 'displayfield',
						value: '',
						width: 20
					},ledgerButton
				]
			}]
	   
   }); 
   
   
   //var tbar1 = new Ext.Toolbar(['��������ѡ��:', importField, '-', importButton, '-', ledgerButton]);
var tbar2 = new Ext.Toolbar([saveButton, '-', delButton]);
//tbar: ['��Ŀ����:', subjcodeField, '-', '��Ŀ���:', AcctTypeCombo, '-', '��Ŀ����:', subjLevelField, '-', '������ҿ�Ŀ:', subjnumfcCombo, '-', findButton],


var itemGrid = new dhc.herp.Grid({
		region: 'center',
		url: "../csp/herp.acct.acctsubjledgerexe.csp",
		atLoad: 'true', // �Ƿ��Զ�ˢ��
		layout: 'fit',
		viewConfig: {
			forceFit: true, //����ҳ��ȫ�ֱ�����ʹҳ��ÿ�а��ն�Ӧ�ı�����������
			//scrollOffset: 20,//��ʾ����Ҳ�Ϊ������Ԥ���Ŀ��
			/*���������ı�Ҫ���еı���ɫ��
			��Ҫ����ҳ���½�һ��css���磺
			<style type="text/css">
			.my_row_style table{ background:Yellow}
			</style>
			Ȼ��������ķ��������ʵ���ˣ�
			 */
			getRowClass: function (record, rowIndex, rowParams, store) {
				if (record.data.IsLast == "0") {
					return "my_row_style";
				}

				if (record.data.IsCheck == "1") {
					return "my_row_styleblue";
				}
			}
		},
		
		listeners: {
			'render': function () {
				//tbar1.render(itemGrid.tbar);
				tbar2.render(itemGrid.tbar);
			},

			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				//alert(columnIndex);
				//alert(record.get('IsLast'));
				//alert(InitState);
				if ((InitState == "1") || (record.get('IsLast') == "0") && ((columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9) || (columnIndex == 10) || (columnIndex == 11) ||
						(columnIndex == 13) || (columnIndex == 14) || (columnIndex == 15) || (columnIndex == 16))) {
					return false;

				} else {
					return true;
				}

			}

		},
		fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
				id: 'rowid',
				header: '<div style="text-align:center">ID</div>',
				allowBlank: true,
				width: 60,
				editable: false,
				hidden: true,
				dataIndex: 'rowid'
			}, {
				id: 'AcctSubjID',
				header: '<div style="text-align:center">AcctSubjID</div>',
				allowBlank: true,
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'AcctSubjID'
			}, {
				id: 'AcctSubjCode',
				header: '<div style="text-align:center">��Ŀ����</div>',
				width: 160,
				editable: false,
				align: 'left',
				dataIndex: 'AcctSubjCode'
			}, {
				id: 'AcctSubjName',
				header: '<div style="text-align:center">��Ŀ����</div>',
				width: 320,
				editable: false,
				align: 'left',
				dataIndex: 'AcctSubjName'
			}, {
				id: 'BeginSum',
				header: '<div style="text-align:center">������</div>',
				width: 180,
				//editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'BeginSum'

			}, {
				id: 'DirectionList',
				header: '<div style="text-align:center">�������</div>',
				width: 80,
				editable: false,
				align: 'center',
				dataIndex: 'DirectionList'
			}, {
				id: 'TotalDebitSum',
				header: '<div style="text-align:center">�ۼƽ跽���</div>',
				width: 180,
				//editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalDebitSum'
			}, {
				id: 'TotalCreditSum',
				header: '<div style="text-align:center">�ۼƴ������</div>',
				width: 180,
				//editable:false,
				//align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'TotalCreditSum'
			}, {
				id: 'EndSum',
				header: '<div style="text-align:center">�ڳ����</div>',
				width: 180,
				editable:false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'EndSum'

			}, {
				id: 'IsLast',
				header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
				width: 100,
				hidden: true,
				dataIndex: 'IsLast'
			}, {
				id: 'IsCheck',
				header: '<div style="text-align:center">�Ƿ�������</div>',
				width: 100,
				editable: false,
				hidden: true,
				dataIndex: 'IsCheck'
			}
		]

	});

itemGrid.btnAddHide(); //�������Ӱ�ť
itemGrid.btnSaveHide(); //���ر��水ť
itemGrid.btnDeleteHide(); //����ɾ����ť
itemGrid.btnResetHide(); //�������ð�ť
itemGrid.btnPrintHide(); //���ش�ӡ��ť

itemGrid.on('rowclick', function () {

	if (InitState == "1") {
		itemGrid.edit = false;
		//delButton.disabled();
	}
});
