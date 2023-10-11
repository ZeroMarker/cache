var userdr = session['LOGON.USERID']; //��¼��ID
var acctbookid = GetAcctBookID();

//��õ�ǰϵͳ��¼�û�����Ϣ˵��
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];

var projUrl = 'herp.acct.acctbankcheckexe.csp';

// ������ʼʱ��ؼ�
var startDate = new Ext.form.DateField({
		id: 'startDate',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

var endDate = new Ext.form.DateField({
		id: 'endDate',
		//format : 'Y-m-d',
		width: 120,
		emptyText: ''
	});

/*  		var OccurDate = new Ext.form.DateField({
id : 'OccurDate',
fieldLabel: 'ҵ��ʱ��',
format : 'Y-m-d',
width : 120,
emptyText : ''
});
 */

//��ʾ���п�Ŀ//
var SubjNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['SubjCode', 'SubjName', 'SubjCodeName'])
	});

SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=GetBankName&acctbookid=' + acctbookid + '&str=' + encodeURIComponent(Ext.getCmp('SubjName').getRawValue()),
		method: 'POST'
	});
});
//Grid���
var SubjName = new Ext.form.ComboBox({
		id: 'SubjName',
		fieldLabel: '���п�Ŀ',
		width: 220,
		listWidth: 220,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'SubjCode',
		displayField: 'SubjCodeName',
		triggerAction: 'all',
		emptyText:'��Ŀ�ֵ���ĩ�����п�Ŀ',
		name: 'SubjName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//���п�Ŀ--��ѯ����
SubjNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url: projUrl + '?action=GetBankName&acctbookid=' + acctbookid + '&str=' + encodeURIComponent(Ext.getCmp('SubjName3').getRawValue()),
		method: 'POST'
	});
});

var SubjName3 = new Ext.form.ComboBox({
		id: 'SubjName3',
		fieldLabel: '���п�Ŀ',
		width: 260,
		listWidth: 280,
		allowBlank: true,
		store: SubjNameDs,
		valueField: 'SubjCode',
		displayField: 'SubjCodeName',
		triggerAction: 'all',
		emptyText: '��Ŀ�ֵ���ĩ�����п�Ŀ',
		name: 'SubjName3',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			select: function (combo, record, index) {

				Ext.Ajax.request({
					url: '../csp/herp.acct.acctbankcheckexe.csp?action=getAmtBal&&bankcode=' + combo.value + '&acctbookid=' + acctbookid + '&userdr=' + userdr,
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							var data = jsonData.info;
							var bcodes = jsonData.info;
							AmtBalField.setRawValue(Ext.util.Format.number(bcodes, '0,000.00'));
							// AmtBalField.setValue(data);

						};
					},
					scope: this
				});

			}

		}

	});

//���״̬
var IfConfirmField = new Ext.form.RadioGroup({
		fieldLabel: '���״̬',
		xtype: 'radiogroup',
		width: 220,
		defaults: {
			style: "vertical-align:middle;margin:0px;border:0;"
			//style:"margin:0;padding:0 0.25em;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'ifall',
				boxLabel: 'ȫ��',
				inputValue: '',
				name: 'ConfirmState',
				checked: true
			}, {
				id: 'ifchecked',
				boxLabel: '�����',
				inputValue: '1',
				name: 'ConfirmState'
			}, {
				id: 'ifunchecked',
				boxLabel: 'δ���',
				inputValue: '0',
				name: 'ConfirmState'
			}
		]
	});
//<input type="checkbox" style="border:0;">
/*input.form-submit {
height: 27px;//�����и���Ϊ�˽��Safari��Chrome�µĸ߶�����
line-height: 19px;//�����־�����ʾ
margin: 0;
overflow: visible;//ֻ�������������IE��padding������Ч
width: auto;//�ִ��������ʶ��
 *width: 1;//IE7��IE6ʶ������ֵΪ1,��Ҳ��֪���к����ã�����Щ�˴˴�����ֵΪ0
} */
//***********************************************************//


//�������AmtBal
var AmtBalField = new Ext.form.NumberField({
		width: 120,
		name: 'AmtBalField',
		// region: 'east',
		align: 'right',
		xtype: 'numberfield',
		selectOnFocus: true

		//xtype:'numberfield', //ֻ����������ֵ
		//maskRe:'/\d/',
		//regex: /^\d+(\.\d{1,2})?$/,
		// regexText: '��������ȷ����������',
	});
var SaveAmtBal = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'save',
		width: 100,
		handler: function () {
			//���岢��ʼ���ж���
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var bankcode = SubjName3.getValue();
			if (bankcode == "") {
				// alert("��ѡ�����п�Ŀ");
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ�����п�Ŀ! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;

			}
			var AmtBal = AmtBalField.getValue();
			if (AmtBal == "") {
				// alert("������ϸ�Ľ��ֵ");
				Ext.Msg.show({
					title: 'ע��',
					msg: '������ϸ�Ľ��ֵ! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;

			}
			function handler(id) {
				if (id == "yes") {
					Ext.Ajax.request({
						url: projUrl + '?action=saveamtbal&AmtBal=' + AmtBal + '&bankcode=' + bankcode + '&userdr=' + userdr + '&acctbookid=' + acctbookid,
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
									msg: '����ɹ�!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
								AmtBalField.setRawValue(Ext.util.Format.number(AmtBal, '0,000.00'));

							} else {
								Ext.Msg.show({
									title: '����',
									msg: jsonData.info,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}
						},
						scope: this
					});
				} else {
					return;
				}
			}
			Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ�������������?', handler);
		}
	});

//******************************************************************************//


var CheqTypeNameDs = new Ext.data.Store({
		autoLoad: true,
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'name'])
	});

CheqTypeNameDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=GetSysChequeType',
			method: 'POST'
		});
});

var CheqTypeName = new Ext.form.ComboBox({
		id: 'CheqTypeName',
		fieldLabel: '���㷽ʽ',
		width: 150,
		listWidth: 220,
		allowBlank: true,
		store: CheqTypeNameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '���㷽ʽ',
		name: 'CheqTypeName',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

///////////////����״̬///////////////////////

//����״̬--��ѯ
var IsChecked1 = new Ext.form.RadioGroup({
		fieldLabel: '����״̬',
		xtype: 'radiogroup',
		width: 220,
		defaults: {
			style: "vertical-align:middle;margin-top:0px;"
			//style:"margin:0;padding:0 0.25em 10 0;width:auto;overflow:visible;border:0;background:none;"
		},
		items: [{
				id: 'all',
				boxLabel: 'ȫ��',
				inputValue: '',
				name: 'IsChecked1',
				checked: true
			}, {
				id: 'checked',
				boxLabel: '�Ѷ�',
				inputValue: '1',
				name: 'IsChecked1'
			}, {
				id: 'unchecked',
				boxLabel: 'δ��',
				inputValue: '0',
				name: 'IsChecked1'
			}
		]
	});

var IsCheckedDs = new Ext.data.SimpleStore({ //����״̬
		fields: ['key', 'keyValue'],
		data: [['0', 'δ��'], ['1', '�Ѷ�'], ['', 'ȫ��']]
	});

////����������--����״̬----IsChecked2-----////
var IsChecked2 = new Ext.form.ComboBox({
		id: 'IsChecked2',
		fieldLabel: '����״̬',
		width: 100,
		listWidth: 100,
		store: IsCheckedDs,
		valueNotFoundText: '',
		displayField: 'keyValue',
		valueField: 'key',
		mode: 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText: 'ȫ��',
		selectOnFocus: true,
		forceSelection: true
	});
//queryPanel
// tbar:['����ڼ�:',startDate,'��',endDate,'-','���п�Ŀ:',SubjName3,'-','�������:',AmtBalField,'-',SaveAmtBal,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','-',QueryButton,'-'],

//****��ѯ���--��ѯ����*****//


/////////////////��ѯ��ť��Ӧ����//////////////
var QueryButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
		iconCls: 'find',
		// height:25,
		scale: 'small',
		width: 70,
		handler: function () {
			var startTime = startDate.getValue();
			if (startTime !== "") {
				startTime = startTime.format('Y-m-d');
			}
			var endTime = endDate.getValue();
			if (endTime !== "") {
				endTime = endTime.format('Y-m-d');
			}
			var BankCode = SubjName3.getValue();
			var IsChecked = IsChecked1.getValue().inputValue;
			var IfConfirm = IfConfirmField.getValue().inputValue;
         
			//var data = SubjName+"|"+IsChecked    //���ݺ�̨������ʾ��ѯ������
			//var data = startTime+"|"+endTime+"|"+SubjName+"|"+IsChecked

			itemGrid.load({
				params: {
					sortField: '',
					sortDir: '',
					start: 0,
					limit: 25,
					BankCode: BankCode,
					IsChecked: IsChecked,
					StartDate: startTime,
					EndDate: endTime,
					acctbookid: acctbookid,
					userdr: userdr,
					IfConfirm: IfConfirm
				}
			});

			//δ�м�¼����������ʾ
			Ext.Ajax.request({
				url: '../csp/herp.acct.acctbankcheckexe.csp?action=getAmtBal&&bankcode=' + BankCode + '&acctbookid=' + acctbookid + '&userdr=' + userdr,
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var data = jsonData.info;
						var bcodes = jsonData.info;
						AmtBalField.setRawValue(Ext.util.Format.number(bcodes, '0,000.00'));
						// AmtBalField.setRawValue(bcodes);
					};
				},
				scope: this
			});

		}
	});

//ɾ����ť
var delButton = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: 'ɾ��',
		iconCls: 'remove',
		handler: function () {
			// ��������ݲ���ɾ��
			var rowObj=itemGrid.getSelectionModel().getSelections();
			// console.log(rowObj)
			var isImportState=[];
			Ext.each(rowObj,function(row){
				isImportState.push(row.data["IsImport"]);
			});
			if(isImportState.indexOf("����")!==-1){
				Ext.MessageBox.show({
					title:"ע��",
					msg:"����ɾ����������ݣ� ",
					icon:Ext.Msg.INFO,
					buttons:Ext.Msg.OK
				});
				return;
			}else{
				itemGrid.del();
			}

		}
	});

//���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '����', //��ͣ��ʾ
		iconCls: 'add',
		handler: function () {
			itemGrid.add();
		}

	});

//���밴ť
var importButton = new Ext.Toolbar.Button({
		text: '����Excel�ļ�',
		tooltip: '����', //��ͣ��ʾ
		iconCls: 'in',
		handler: function () {
			doimport();
		}

	});

//���水ť
var saveButton = new Ext.Toolbar.Button({
		text: '����',
		tooltip: '�������',
		iconCls: 'save',
		handler: function () {
			//���ñ��溯��
			itemGrid.save();

		}
	});

//���
var AuditButton = new Ext.Toolbar.Button({
		text: '���',
		iconCls: 'audit',
		handler: function () {
			//���岢��ʼ���ж���
			var rowObj = itemGrid.getSelectionModel().getSelections();
			//���岢��ʼ���ж��󳤶ȱ���
			var len = rowObj.length;
			var checker = session['LOGON.USERID'];
			if (len < 1) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��ѡ����Ҫ��˵�����! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
			var count = 0;
			for (var j = 0; j < len; j++) {

				if (rowObj[j].get("ConfirmState") == "�����") {

					count = parseInt(count, 10) + 1;
					//alert(count+"^"+len);
					continue;
				}
				
				var rowid=rowObj[j].get("rowid");
				if(rowid==""){
					Ext.Msg.show({
					title: 'ע��',
					msg: '��δ���������,���ȱ���! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
					
				}
			}

			if (count == len) {
				Ext.Msg.show({
					title: 'ע��',
					msg: '��������� ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}

			function handler(id) {
				if (id == "yes") {
					for (var i = 0; i < len; i++) {
						if (rowObj[i].get("ConfirmState") == "�����") {
							// Ext.Msg.show({title:'ע��',msg:'���������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							continue;
						}
                        
						Ext.Ajax.request({
							url: projUrl + '?action=audit&&rowid=' + rowObj[i].get("rowid") + '&checker=' + checker,
							waitMsg: '�����...',
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
										msg: '��˳ɹ�! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.INFO
									});
									itemGrid.load({
										params: {
											start: 0,
											limit: 25,
											userdr: userdr
										}
									});

								} else {
									Ext.Msg.show({
										title: '����',
										msg: jsonData.info,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								}
							},
							scope: this
						});
					}
				} else {
					return;
				}
			}

			Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ��˸�����¼��? ', handler);
		}
	});

var queryPanel = new Ext.FormPanel({
	    title:'���ж��˵�ά��',
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
						value: '����ڼ�',
						style: 'padding:0 5px;'
						//width: 60
					}, startDate, {
						xtype: 'displayfield',
						value: '--',
						style: 'padding:0 5px;'
						//width: 12
					}, endDate, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '����״̬',
						style: 'padding:0 5px;'
						//width: 60
					}, IsChecked1,{
						xtype: 'displayfield',
						value: '',
						width: 20
					}, {
						xtype: 'displayfield',
						value: '�������',
						style: 'padding:0 5px;'
						//width: 60
					}, AmtBalField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					SaveAmtBal
				]
			}, {
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '���п�Ŀ',
						style: 'padding:0 5px;'
						//width: 60
					}, SubjName3, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '���״̬',
						style: 'padding:0 5px;'
						//width: 60
					}, IfConfirmField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, QueryButton
				]
			}

		]

	});


var itemGrid = new dhc.herp.Grid({
		//width: 400,
		//title:'���ж��˵���ѯ�б�',
		iconCls:'list',
		region: 'center',
		url: projUrl,
		tbar: [addButton, '-', saveButton, '-', delButton, '-', AuditButton, '-', importButton],
		// tbar:['����ڼ�:',startDate,'��',endDate,'-','���п�Ŀ:',SubjName3,'-','�������:',AmtBalField,'-',SaveAmtBal,'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','-',QueryButton,'-'],
		listeners: {
			// 'render': function(){//button0.render(itemGrid.tbar);
			// button1.render(itemGrid.tbar);
			// },
			'cellclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				var IsChecked = record.get("IsChecked");
				var ConfirmState = record.get("ConfirmState");
				var IsImport = record.get("IsImport");
				if (((record.get('IsChecked') == "1") || (record.get('ConfirmState') == "�����") || (record.get('IsImport') == "����")) && ((columnIndex == 2) || (columnIndex == 3) || (columnIndex == 4) || (columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9))) {
					return false;
				} else {
					return true;
				}
			},
			'celldblclick': function (grid, rowIndex, columnIndex, e) {
				var record = grid.getStore().getAt(rowIndex);
				var IsChecked = record.get("IsChecked")
					var ConfirmState = record.get("ConfirmState")
					var IsImport = record.get("IsImport")
					if (((record.get('IsChecked') == "1") || (record.get('ConfirmState') == "�����") || (record.get('IsImport') == "����")) && ((columnIndex == 2) || (columnIndex == 3) || (columnIndex == 4) || (columnIndex == 5) || (columnIndex == 6) || (columnIndex == 7) || (columnIndex == 8) || (columnIndex == 9))) {
						return false;
					} else {
						return true;
					}
			}
		},

		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				header: 'ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'SubjName',
				header: '<div style="text-align:center">���п�Ŀ</div>',
				//header : '���п�Ŀ',
				width: 265,
				editable: true,
				type: SubjName,
				align: 'left',
				allowBlank: false,
				dataIndex: 'SubjName'
			}, {
				id: 'OccurDate',
				header: 'ҵ��ʱ��',
				align: 'center',
				width: 90,
				dataIndex: 'OccurDate',
				sortable: true,
				type: "dateField"
				//renderer : Ext.Date.Format.dateRenderer('Y-m-d'),
			}, {
				id: 'CheqTypeName',
				header: '���㷽ʽ',
				width: 80,
				align: 'center',
				type: CheqTypeName,
				editable: true,
				//allowBlank : false,
				dataIndex: 'CheqTypeName'
			}, {
				id: 'CheqNo',
				header: '<div style="text-align:center">Ʊ�ݺ�</div>',
				width: 130,
				editable: true,
				//allowBlank : false,
				//vtype:'number',
				dataIndex: 'CheqNo'
			}, {
				id: 'summary',
				//header : 'ժ    Ҫ',
				header: '<div style="text-align:center">ժ    Ҫ</div>',
				width: 250,
				editable: true,
				align: 'left',
				dataIndex: 'summary'
			}, {
				id: 'AmtDebit',
				header: '<div style="text-align:center">�跽���</div>',
				editable: true,
				allowBlank: false,
				width: 150,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				type: 'numberField',
				dataIndex: 'AmtDebit'
			}, {
				id: 'AmtCredit',
				//header : '�������',
				header: '<div style="text-align:center">�������</div>',
				editable: true,
				allowBlank: false,
				width: 150,
				align: 'right',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				type: 'numberField',
				dataIndex: 'AmtCredit'
			}, {
				id: 'IsChecked',
				header: '����״̬',
				editable: false,
				width: 80,
				type: IsChecked2,
				align: 'center',
				dataIndex: 'IsChecked',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					if (sf == "1") {
						return '<span style="cursor:hand">' + value + '</span>';
					}
					if ((sf == '0') || (sf == "δ��")) {
						return '<span style="color:blue;cursor:hand">' + value + '</span>';
					}
				}
			}, {
				id: 'IsImport',
				header: '¼�뷽ʽ',
				editable: false,
				width: 80,
				align: 'center',
				dataIndex: 'IsImport'
			}, {
				id: 'EnterID',
				header: '¼����',
				editable: false,
				hidden: false,
				width: 100,
				align: 'center',
				dataIndex: 'EnterID'
			}, {
				id: 'EnterDate',
				header: '¼��ʱ��',
				editable: false,
				hidden: false,
				width: 90,
				align: 'center',
				dataIndex: 'EnterDate'
			}, {
				id: 'ConfirmState',
				header: '���״̬',
				editable: false,
				width: 100,
				align: 'center',
				dataIndex: 'ConfirmState',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {

					var sf = record.data['ConfirmState']
						if (sf == "δ���") {
							return '<span>' + value + '</span>';
						}
						if (sf == "�����") {
							return '<span style="color:blue;">' + value + '</span>';
						}
						//if (sf == "��˲�ͨ��"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
				}

			}, {
				id: 'ConfirmerID',
				header: '�����',
				editable: false,
				hidden: false,
				width: 100,
				align: 'center',
				dataIndex: 'ConfirmerID'
			}, {
				id: 'ConfirmDate',
				header: '���ʱ��',
				editable: false,
				hidden: false,
				width: 150,
				align: 'center',
				dataIndex: 'ConfirmDate'
			}, {
				id: 'Amtbal',
				header: '���',
				editable: false,
				width: 150,
				align: 'right',
				hidden: true,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="float:right;">' + Ext.util.Format.number(value, '0,000.00') + '</span>';
				},
				dataIndex: 'Amtbal'
			}
		]

	});

//itemGrid.load({params:{start:0,limit:25,userdr:userdr,acctbookid:acctbookid}});

itemGrid.on('afterEdit', onEdit, this);

function onEdit(e) {
	if (e.field == "AmtDebit") {
		if (e.value != 0) {
			e.record.set("AmtCredit", 0);
		}
	} else if (e.field == "AmtCredit") {

		if (e.value != 0) {
			e.record.set("AmtDebit", 0);
		}
	};

};

itemGrid.store.on("load", function () {
	if (itemGrid.getStore().getAt(0) == undefined) {

		AmtBalField.setValue('');
	} else {
		AmtBalField.setValue(itemGrid.getStore().getAt(0).data.Amtbal);
	}

	return;
});
var acctbookid = IsExistAcctBook();
