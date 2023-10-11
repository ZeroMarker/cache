var userid = session['LOGON.USERID'];
var projUrl = '../csp/herp.acct.acctsubjserverexe.csp';
//���ӷ���
addFun = function () {
	//��Ŀ����
	var usjcodeField = new Ext.form.TextField({
			fieldLabel: '��Ŀ����',
			width: 180,
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (usjcodeField.getValue() !== "") {
							Ext.Ajax.request({
								url: '../csp/herp.acct.acctsubjserverexe.csp?action=getcoderule&acctbookid=' + acctbookid,
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										var data = jsonData.info;
										var arr = data.split("-");
										var j = usjcodeField.getValue().length;
										var i = 0;
										var k = 0;
										var count = 0;
										for (i = 0; i < arr.length; i++) //�ж�����ı��볤���Ƿ����Ҫ��
										{
											arr[i] = parseInt(arr[i]);
											count = count + arr[i];
											if (count == j) {
												k = 1;
												break;
											}
										}
										if (k == 1) //�������Ҫ��ó���Ӧ�Ŀ�Ŀ����
										{
											usjlevelField.setValue(i + 1);
											usjnameAllField.focus();
											if (i == 0)
												usupercodeField.disable();
											else
												usupercodeField.enable();
										} else {
											usjcodeField.focus();
											usjlevelField.setValue("");
											usjcodeField.setValue("");
										}
									}
								},
								scope: this
							});

						} else {
							Handler = function () {
								usjcodeField.focus();
							};
							Ext.Msg.show({
								title: '����',
								msg: '���벻��Ϊ��!',
								buttons:

								Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}
		});

	//��Ŀ����
	var usjnameField = new Ext.form.TextField({
			fieldLabel: '��Ŀ����',
			width: 180,
			allowBlank: false,
			//anchor: '95%',
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (usjnameField.getValue() != "") {
							udirectionField.focus();
						} else {
							Handler = function () {
								usjnameField.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '�������Ʋ���Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}
		});

	//���ױ���--ȥ��ǰ���洫���ֵ��(δ��)
	var ubookidField = new Ext.form.TextField({
			fieldLabel: '��ǰ����',
			width: 180,
			selectOnFocus: 'true'
		});
	ubookidField.setValue(acctbookid);
	ubookidField.disable();

	//��Ŀȫ��(δ��)--��������ƴ��
	var usjnameAllField = new Ext.form.TextField({
			fieldLabel: '��Ŀȫ��',
			width: 180,
			emptyText: 'ϵͳ�������Ƹ�ʽ�Զ�����',
			disabled: true,
			selectOnFocus: 'true'
		});

	//�����ɿ�Ŀ��������ĸƴ��
	var uspellField = new Ext.form.TextField({
			fieldLabel: 'ƴ����',
			width: 180,
			disabled: true,
			selectOnFocus: 'true'
		});

	var udefinecodeField = new Ext.form.TextField({
			fieldLabel: '�Զ�����',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});

	//�ϼ�����--�Զ����ɣ����ɱ༭��(δ��)
	var usupercodeField = new Ext.form.TextField({
			fieldLabel: '�ϼ�����',
			width: 180,
			editable: false,
			emptyText: 'ϵͳ���ݱ�������Զ�����',
			tooltip: 'ϵͳ���ݱ�������Զ�����',
			selectOnFocus: 'true'
		});
	usupercodeField.disable();

	//��Ŀ���
	var usjtypeDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	usjtypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjtypelist&str',
				method: 'POST'
			});
	});
	var usjtypeField = new Ext.form.ComboBox({
			id: 'usjtypeField',
			fieldLabel: '��Ŀ���',
			width: 180,
			listWidth: 250,
			store: usjtypeDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '��ѡ���Ŀ����...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//��Ŀ����
	var usjnatureDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	usjnatureDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjnaturelist&str',
				method: 'POST'
			});
	});
	var usjnatureField = new Ext.form.ComboBox({
			id: 'usjnatureField',
			fieldLabel: '��Ŀ����',
			width: 180,
			listWidth: 250,
			allowBlank: true,
			store: usjnatureDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '��ѡ���Ŀ����...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//��Ŀ����
	var usjlevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				["1", '1'], ["2", '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var usjlevelField = new Ext.form.ComboBox({
			id: 'usjlevelField',
			fieldLabel: '��Ŀ����',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: usjlevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			emptyText: '��ѡ��¼���Ŀ����',
			selectOnFocus: true,
			forceSelection: true
		});

	//�Ƿ�ͣ��
	var uIsStopField = new Ext.form.Checkbox({
			id: 'uIsStopField',
			//fieldLabel: '�Ƿ�ͣ��',
			//labelSeparator : '�Ƿ�ͣ��:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
			//width: 30
		});

	//��Һ���
	var uIsFcField = new Ext.form.Checkbox({
			id: 'uIsFcField',
			//fieldLabel: '��Һ���',
			//labelSeparator : '��Һ���:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});

	//��������
	var uIsNumField = new Ext.form.Checkbox({
			id: 'uIsNumField',
			//fieldLabel: '��������',
			//labelSeparator : '��������:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			listeners: {
				check: function (obj, uIsNum) {
					if (uIsNum) {
						uNumUnitField.enable();
					} else {
						uNumUnitField.disable();
						uNumUnitField.setValue("");
					}
				}
			}
		});

	//��������
	var uIsCheckField = new Ext.form.Checkbox({
			id: 'uIsCheckField',
			//fieldLabel: '��������',
			//labelSeparator : '��������:',
			hideLabel:true,
			height:20,
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true,
			listeners: {
				check: function (obj, uIsCheck) {
					if (uIsCheck) {
						CheckFieldSet.enable();
					} else {
						CheckFieldSet.disable();
					}
				}
			}
		});

	//�������
	var udirectionStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['-1', '��']]
		});
	var udirectionField = new Ext.form.ComboBox({
			id: 'udirectionField',
			fieldLabel: '�������',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: udirectionStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: 1,
			selectOnFocus: true,
			forceSelection: true
		});

	//�Ƿ�ĩ��
	var uIsLastFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['0', '��']]
		});
	var uIsLastField = new Ext.form.ComboBox({
			id: 'uIsLastField',
			fieldLabel: '�Ƿ�ĩ��',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsLastFieldStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: '1',
			selectOnFocus: true,
			forceSelection: true
		});

	//������λ
	var uNumUnitDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'desc'])
		});
	uNumUnitDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=numunitlist',
				method: 'POST'
			});
	});
	var uNumUnitField = new Ext.form.ComboBox({
			id: 'uNumUnitField',
			fieldLabel: '������λ',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: uNumUnitDs,
			valueField: 'rowid',
			displayField: 'desc',
			triggerAction: 'all',
			emptyText: '��ѡ�������λ',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true

		});
	uNumUnitField.disable();

	//�ֽ����б�ʶ
	var uIsCashFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '�ֽ�'], ['2', '����'], ['0', '����']]
		});
	var uIsCashField = new Ext.form.ComboBox({
			id: 'uIsCashField',
			fieldLabel: '�ֽ����б�ʶ',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsCashFieldStore,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: 0,
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (uIsCashField.getValue() == "1" || uIsCashField.getValue() == "2") { //������ֽ�����,
							uIsCashFlow.enable(); //�Ƿ��ֽ���������
							//����ֽ�������
							if (uIsCashFlow.getRawValue() == "��") {
								uCashFlowField.enable();
							} else {
								uCashFlowField.disable();
								
								uCashFlowField.setValue(0);
								uCashFlowField.setRawValue("");
							}

						} else {
							uIsCashFlow.disable();
							uCashFlowField.disable();
							uIsCashFlow.setValue(0);
							uIsCashFlow.setRawValue("��");
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	//��Ŀ����
	var usubjGroupStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', 'ҽ��'], ['02', 'ҩ��'], ['03', '����'], ['09', '����']]
		});
	var usubjGroup = new Ext.form.ComboBox({
			id: 'usubjGroup',
			fieldLabel: '��Ŀ����',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: usubjGroupStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: '09',
			selectOnFocus: true,
			forceSelection: true
		});

	//�ֽ�������ʶ
	var uIsCashFlowStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['0', '��']]
		});
	var uIsCashFlow = new Ext.form.ComboBox({
			id: 'uIsCashFlow',
			fieldLabel: '�ֽ�������Ŀ',
			//hideLabel :true,
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: uIsCashFlowStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: 0,
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (uIsCashFlow.getValue() == "1") { //������ֽ�����,�ֽ�������Ŀ����
							uCashFlowField.enable();
						} else {
							uCashFlowField.disable();
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	var uStartDateField = new Ext.form.DateField({
			id: 'uStartDateField',
			fieldLabel: '��������',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			value: new Date(),
			plugins: 'monthPickerPlugin'
		});

	var uEndDateField = new Ext.form.DateField({
			id: 'uEndDateField',
			fieldLabel: 'ͣ������',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//�ֽ�������
	var uCashFlowDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	uCashFlowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=cashflowlist&acctbookid=' + acctbookid,
				method: 'POST'
			});
	});
	var uCashFlowField = new Ext.form.ComboBox({
			id: 'uCashFlowField',
			fieldLabel: '�ֽ�������',
			width: 180,
			listWidth: 280,
			hidden:true,
			hideLabel :true,
			allowBlank: true,
			store: uCashFlowDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '��ѡ���ֽ�������',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	var SJFieldSet = new Ext.form.FieldSet({
			//title : '����¿�Ŀ',
			height: 320,
			columnWidth: 1,
			layout: 'column',
			//labelSeparator: ':',
			items: [{
					columnWidth: .4,
					layout: 'form',
					labelWidth: 80,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						usjlevelField,
						usjcodeField,
						usjnameField,
						usjtypeField,
						usjnatureField,
						//usupercodeField,
						uNumUnitField,
						udefinecodeField
					]
				}, {
					columnWidth: .43,
					layout: 'form',
					labelWidth: 110,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						udirectionField,
						uIsLastField,
						usubjGroup,
						uIsCashField,
						uIsCashFlow,
						uCashFlowField,
						uStartDateField
						//uEndDateField
					]
				}, {
					columnWidth: .07,
					layout: 'form',
					hideLabel:true,
					style:'text-align:right',
					labelWidth: 0.005,
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						uIsStopField,
						uIsFcField,
						uIsNumField,
						uIsCheckField
					]
				},{
					columnWidth: .1,
					layout: 'form',
					labelWidth: 0.05,
					hideLabel:true,
					//style:'padding-left:5px',
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},{
							xtype: 'displayfield',
							value: '�Ƿ�ͣ��'
						},{
							xtype: 'displayfield',
							value: '��Һ���'
						},{
							xtype: 'displayfield',
							value: '��������'
						},{
							xtype: 'displayfield',
							value: '��������'
						}	]
				}
			]
		});

	//***����ṹ***//
	var colItems = [{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '1.0',
				bodyStyle: 'padding:5px',
				border: false
			},
			items: [{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						SJFieldSet
					]
				}
			]
		}
	];

	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
			//labelWidth: 90,
			labelAlign: 'right',
			frame: true,
			items: colItems
	});
		
		
	//�������
	formPanel.on('afterlayout', function (panel, layout) {
		Ext.Ajax.request({
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=lastrec&acctbookid=' + acctbookid,
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var lastrec = jsonData.info; //�ϴ���󱣴����Ϣ
					//��ȡ���һ�εı�����Ϣ,����������
					/*
					AcctSubjID 0
					AcctBookID 1
					AcctSubjCode 2
					AcctSubjName 3
					Spell 4
					AcctSubjNameAll 5
					DefineCode 6
					SuperSubjCode 7
					SubjLevel 8
					AcctSubjTypeID 9
					SysSubjNatureID 10
					IsLast 11
					Direction 12
					IsCash 13
					IsNum 14
					NumUnit 15
					IsFc 16
					IsCheck 17
					IsStop 18
					subjGroup 19
					CashFlowID 20
					StartYear 21
					StartMonth 22
					EndYear 23
					EndMonth 24
					IsCashFlow 25
					SubjTypeName 26
					SubjNatureName 27
					CashItemName 28
					 */

					var arr = lastrec.split("^");
					lastAcctSubjID = arr[0]; //��ƿ�ĿID
					lastAcctBookID = arr[1]; //����id
					lastAcctSubjCode = arr[2]; //��Ŀ����
					lastAcctSubjName = arr[3]; //��Ŀ����
					lastSpell = arr[4]; // ƴ����
					lastAcctSubjNameAll = arr[5]; //��Ŀȫ��
					lastDefineCode = arr[6]; //�Զ�����
					lastSuperSubjCode = arr[7]; //�ϼ�����
					lastSubjLevel = arr[8]; //��Ŀ����
					lastAcctSubjTypeID = arr[9]; //��Ŀ����
					lastSysSubjNatureID = arr[10]; //��Ŀ����

					var lastDirection = arr[12]; //���
					var lastIsCash = arr[13]; //�Ƿ��ֽ�
					var lastIsNum = arr[14]; //������
					var lastIsFc = arr[16]; //���
					var lastIsCheck = arr[17]; //��������
					var lastIsStop = arr[18]; //�Ƿ�ͣ��
					var lastCashFlowID = arr[20]; //�ֽ�������ID
					var lastIsCashFlow = arr[25]; //�Ƿ��ֽ�����
					var lastSubjTypeName = arr[26]; //��Ŀ����
					var lastSubjNatureName = arr[27]; //��Ŀ����
					var lastCashItemName = arr[28]; //�ֽ�����������
					usjcodeField.setValue(lastAcctSubjCode);
					usjnameField.setValue(lastAcctSubjName);
					udefinecodeField.setValue(lastDefineCode);
					usupercodeField.setValue(lastSuperSubjCode);
					usjlevelField.setValue(lastSubjLevel);

					uIsStopField.setValue(lastIsStop);
					uIsFcField.setValue(lastIsFc);
					uIsNumField.setValue(lastIsNum);
					uIsCheckField.setValue(lastIsCheck);

					usjtypeField.setValue(lastAcctSubjTypeID);
					usjtypeField.setRawValue(lastSubjTypeName);
					//usjtypeField.name=lastSubjTypeName;

					usjnatureField.setValue(lastSysSubjNatureID);
					usjnatureField.setRawValue(lastSubjNatureName);
					//usjnatureField.name=lastSubjNatureName;

					if (lastDirection == 1) {
						udirectionField.setValue(lastDirection);
						udirectionField.setRawValue("��");
					} else {
						udirectionField.setValue(lastDirection);
						udirectionField.setRawValue("��");
					}
					//������ֽ����п�Ŀ
					if (lastIsCash == 1 || lastIsCash == 2) {
						//���ֽ�������ʶΪ��
						if (lastIsCashFlow == 1) {
							uIsCashFlow.setValue(lastIsCashFlow);
							uIsCashFlow.setRawValue("��");
							uCashFlowField.setValue(lastCashFlowID);
							uCashFlowField.setRawValue(lastCashItemName);
						} else {
							uIsCashFlow.setValue(0);
							uIsCashFlow.setRawValue("��");
							uCashFlowField.disable();
							uCashFlowField.setValue(0);
							uCashFlowField.setRawValue("");
						}

					} else {
						uIsCashFlow.disable();
						uIsCashFlow.setValue(0);
						uIsCashFlow.setRawValue("��");
						uCashFlowField.disable();
						uCashFlowField.setValue(0);
						uCashFlowField.setRawValue("");
					}

					/*
					var lastIsLast=arr[11];				//�Ƿ�ĩ��
					var lastDirection=arr[12];


					var lastNumUnit=arr[15];			//������λ

					var lastsubjGroup=arr[19];			//��Ŀ����

					var lastStartYear=arr[21];			//��ʼ���
					var lastStartMonth=arr[22];			//��ʼ�·�
					var lastEndYear=arr[23];			//������
					var lastEndMonth=arr[24];			//������

					 */
					//itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
				}
			},
			scope: this
		});

		/*
		usupercodeField.setValue();
		usjlevelField.setValue();
		usjtypeField.setRawValue();
		usjnatureField.setRawValue(rowObj[0].get("SubjNatureName"));
		var eIsLast=rowObj[0].get("IsLast");
		if(eIsLast=="��"){
		eIsLastField.setValue(1);
		}else{
		eIsLastField.setValue(0);
		};
		var edirection=rowObj[0].get("Direction");
		if(edirection=="��"){
		edirectionField.setValue(1);
		}else{
		edirectionField.setValue(-1);
		};
		eIsCashField.setValue(rowObj[0].get("IsCash"));
		eNumUnitField.setRawValue(rowObj[0].get("NumUnit"));
		var eIsNum=rowObj[0].get("IsNum");
		if(eIsNum=="��"){
		eIsNumField.setValue(true);
		eNumUnitField.enable();
		}else{
		eIsNumField.setValue(false);
		eNumUnitField.disable();
		};
		var eIsFc= rowObj[0].get("IsFc");
		if(eIsFc=="��"){
		eIsFcField.setValue(true);
		}else{
		eIsFcField.setValue(false);
		};
		var eIsCheck=rowObj[0].get("IsCheck");
		if(eIsCheck=="��"){
		eIsCheckField.setValue(true);
		}else{
		eIsCheckField.setValue(false);
		};
		var eIsStop=rowObj[0].get("IsStop");
		if(eIsStop=="��"){
		eIsStopField.setValue(true);
		}else{
		eIsStopField.setValue(false);
		};
		esubjGroup.setValue(rowObj[0].get("subjGroup"));
		eCashFlowField.setValue(rowObj[0].get("CashFlowID"));
		eStartDateField.setValue(rowObj[0].get("StartYM"));
		eEndDateField.setValue(rowObj[0].get("EndYM"));
		eIsCashFlow.setValue(rowObj[0].get("IsCashFlow"));
		 */

	});

	//***ȷ����ť***//
	addButton = new Ext.Toolbar.Button({
			text: 'ȷ��',
			iconCls:'submit'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {
		var usjcode = usjcodeField.getValue();
		var usjname = usjnameField.getValue();
		var usjnameAll = usjnameAllField.getValue();
		var uspell = uspellField.getValue();
		var udefinecode = udefinecodeField.getValue();
		var usupercode = usupercodeField.getValue();
		var usjlevel = usjlevelField.getValue();
		var usjtype = usjtypeField.getValue();
		var usjnature = usjnatureField.getValue();
		var uIsLast = uIsLastField.getValue();
		var udirection = udirectionField.getValue();
		var uIsCash = uIsCashField.getValue();
		var uNumUnit = uNumUnitField.getValue();
		var uIsNum = (uIsNumField.getValue() == true) ? '1' : '0';
		var uIsFc = (uIsFcField.getValue() == true) ? '1' : '0';
		var uIsCheck = (uIsCheckField.getValue() == true) ? '1' : '0';
		var uIsStop = (uIsStopField.getValue() == true) ? '1' : '0';
		var usjGroup = usubjGroup.getValue();
		var uCashFlow = uCashFlowField.getValue();
		var uICFlow = uIsCashFlow.getValue();
		var uStartDate = uStartDateField.getValue();
		if (uStartDate !== "") {
			uStartDate = uStartDate.format('Y-m');
		};

		var uEndDate = uEndDateField.getValue();
		if (uEndDate !== "") {
			uEndDate = uEndDate.format('Y-m');
		};

		// if(uStartDate>uEndDate){
		// Ext.Msg.show({title:'����',msg:'�������²��ܴ���ͣ������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		// return;
		// };
		if ((usjname == "") || (usjcode == "")) {
			Ext.Msg.show({
				title: '����',
				msg: '��������Ʋ���Ϊ��',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		}

		var len2 = 0;
		var flag = 1;
		Ext.Ajax.request({
			async: false,
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=GetLength&acctbookid=' + acctbookid + '&usjlevel=' + usjlevel,
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					len2 = jsonData.info;
					var len = usjcode.length;
					if (len != len2) {
						Ext.Msg.show({
							title: '����',
							msg: '��Ŀ���벻�淶! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
						flag = 2;
						return;
					}else{
						var data = usjcode + "|" + usjname + "|" + udefinecode + "|" + usupercode + "|" + usjlevel + "|" + usjtype + "|" + usjnature + "|" +
							uIsLast + "|" + udirection + "|" + uIsCash + "|" + uIsNum + "|" + uNumUnit + "|" + uIsFc + "|" + uIsCheck + "|" + uIsStop + "|" +
							usjGroup + "|" + uCashFlow + "|" + uStartDate + "|" + uEndDate + "|" + uICFlow

						if (flag != 2) {
							Ext.Ajax.request({
								url: '../csp/herp.acct.acctsubjserverexe.csp?action=addsj&data=' + encodeURIComponent(data) + '&acctbookid=' + acctbookid,
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
										//addwin.close(); //��ӳɹ��رմ���
										Ext.Msg.show({
											title: 'ע��',
											msg: '������ӳɹ�!',
											icon: Ext.MessageBox.INFO,
											buttons: Ext.Msg.OK
										});
										// itemGridDs.load(({params:{start:0,limit:25}}));
										itemGridDs.load({
											params: {
												start: 0,
												limit: itemGridPagingToolbar.pageSize
											}
										});

									} else {
										var message = "";
										if (jsonData.info == 'RepCode')
											message = '����ı����Ѵ���,����������!';
										if (jsonData.info == 'mistake1')
											message = '����¼��ÿ�Ŀ���ϼ����룡��';
										if (jsonData.info == 'mistake0')
											message = '���볤���뼶��ƥ��,����յ�ǰ�������!';
										Ext.Msg.show({
											title: '����',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									}
								},
								scope: this
							});
						}
						
						
					}
				}
			}
		});

		
		// addwin.close();

	}
	//***��Ӽ����¼�***//
	addButton.addListener('click', addHandler, false);

	cancelButton = new Ext.Toolbar.Button({
			text: 'ȡ��',
			iconCls:'back'
		});

	cancelHandler = function () {
		addwin.close();
	}

	cancelButton.addListener('click', cancelHandler, false);

	//***����һ������***//
	addwin = new Ext.Window({
			title: '��ӿ�Ŀ',
			width: 800,
			height: 350,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	addwin.show();

}
