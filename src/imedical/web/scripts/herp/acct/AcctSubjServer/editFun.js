var userid = session['LOGON.USERID'];
editFun = function () {

	var rowObj = itemGrid.getSelectionModel().getSelections();

	var rowid = rowObj[0].get("rowid");
	var esjcodeField = new Ext.form.TextField({
			fieldLabel: '��Ŀ����',
			width: 180,
			//anchor: '100%',
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (esjcodeField.getValue() != "") {
							esjnameField.focus();
						} else {
							Handler = function () {
								esjcodeField.focus();
							}
							Ext.Msg.show({
								title: '����',
								msg: '��Ŀ���벻��Ϊ��!',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: Handler
							});
						}
					}
				}
			}

		});

	//��Ŀ����
	var esjnameField = new Ext.form.TextField({
			fieldLabel: '��Ŀ����',
			width: 180,
			allowBlank: false,
			selectOnFocus: 'true',
			listeners: {
				specialKey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if (esjnameField.getValue() != "") {
							edirectionField.focus();
						} else {
							Handler = function () {
								esjnameField.focus();
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
	var ebookidField = new Ext.form.TextField({
			fieldLabel: '��ǰ����',
			width: 180,
			selectOnFocus: 'true'
		});
	ebookidField.setValue(acctbookid);
	ebookidField.disable();

	//��Ŀȫ��(δ��)--��������ƴ��
	var esjnameAllField = new Ext.form.TextField({
			fieldLabel: '��Ŀȫ��',
			width: 180,
			emptyText: 'ϵͳ���ݱ�������Զ�����',
			disabled: true,
			selectOnFocus: 'true'
		});

	//�����ɿ�Ŀ��������ĸƴ��
	var espellField = new Ext.form.TextField({
			fieldLabel: 'ƴ����',
			width: 180,
			disabled: true,
			selectOnFocus: 'true'
		});

	var edefinecodeField = new Ext.form.TextField({
			fieldLabel: '�Զ�����',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});

	//�ϼ�����--�Զ����ɣ����ɱ༭��(δ��)
	var esupercodeField = new Ext.form.TextField({
			fieldLabel: '�ϼ�����',
			width: 180,
			//disabled:true,
			selectOnFocus: 'true'
		});
	ebookidField.disable();

	//��Ŀ���
	var esjtypeDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	esjtypeDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjtypelist&str',
				method: 'POST'
			});
	});
	var esjtypeField = new Ext.form.ComboBox({
			id: 'esjtypeField',
			fieldLabel: '��Ŀ���',
			width: 180,
			listWidth: 265,
			store: esjtypeDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText: '��ѡ���Ŀ����...',
			name:'SubjTypeName',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			editable: true
		});

	//��Ŀ����
	var esjnatureDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	esjnatureDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=sjnaturelist&str',
				method: 'POST'
			});
	});
	var esjnatureField = new Ext.form.ComboBox({
			id: 'esjnatureField',
			fieldLabel: '��Ŀ����',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: esjnatureDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			name:'SubjNatureName',
			emptyText: '��ѡ���Ŀ����...',
			minChars: 1,
			pageSize: 10,
			selectOnFocus: true,
			forceSelection: 'true',
			typeAhead : true,
			editable: true
		});

	//��Ŀ����
	var esjlevelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [
				['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
				['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
			]
		});
	var esjlevelField = new Ext.form.ComboBox({
			id: 'esjlevelField',
			fieldLabel: '��Ŀ����',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: esjlevelDs,
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			selectOnFocus: true,
			forceSelection: true
		});

	//�Ƿ�ͣ��
	var eIsStopField = new Ext.form.Checkbox({
			id: 'eIsStopField',
			//fieldLabel: '�Ƿ�ͣ��',
			hideLabel:true,
			labelAlign :'left',
			height:20,
			//labelSeparator : '�Ƿ�ͣ��:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});
	//��Һ���
	var eIsFcField = new Ext.form.Checkbox({
			id: 'eIsFcField',
			hideLabel:true,
			height:20,
			//fieldLabel: '��Һ���',
			//labelSeparator : '��Һ���:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false
		});
	//��������
	var eIsNumField = new Ext.form.Checkbox({
			id: 'eIsNumField',
			hideLabel:true,
			height:20,
			//fieldLabel: '��������',
			//labelSeparator : '��������:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			listeners: {
				check: function (obj, eIsNum) {
					if (eIsNum) {
						eNumUnitField.enable();
					} else {
						eNumUnitField.disable();
					}
				}
			}
		});
	//��������
	var eIsCheckField = new Ext.form.Checkbox({
			id: 'eIsCheckField',
			hideLabel:true,
			height:20,
			//fieldLabel: '��������',
			//labelSeparator : '��������:',
			style: 'border:0;background:none;margin-top:0px;',
			allowBlank: false,
			selectOnFocus: true,
			triggerAction: 'all',
			forceSelection: true,
			listeners: {
				check: function (obj, eIsCheck) {
					if (eIsCheck) {
						// eCheckFieldSet.enable();
					} else {
						// eCheckFieldSet.disable();
					}
				}
			}
		});

	//�������
	var edirectionStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['-1', '��']]
		});
	var edirectionField = new Ext.form.ComboBox({
			id: 'edirectionField',
			fieldLabel: '�������',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: edirectionStore,
			//anchor : '95%',
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
	var eIsLastFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['0', '��']]
		});
	var eIsLastField = new Ext.form.ComboBox({
			id: 'eIsLastField',
			fieldLabel: '�Ƿ�ĩ��',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: eIsLastFieldStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: 1,
			selectOnFocus: true,
			forceSelection: true
		});

	//������λ
	var eNumUnitDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'desc'])
		});
	eNumUnitDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=numunitlist',
				method: 'POST'
			});
	});
	var eNumUnitField = new Ext.form.ComboBox({
			id: 'eNumUnitField',
			fieldLabel: '������λ',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			store: eNumUnitDs,
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
	eNumUnitField.disable();
	//�ֽ����б�ʶ
	var eIsCashFieldStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '�ֽ�'], ['2', '����'], ['0', '����']]
		});
	var eIsCashField = new Ext.form.ComboBox({
			id: 'eIsCashField',
			fieldLabel: '�ֽ����б�ʶ',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: eIsCashFieldStore,
			//anchor : '95%',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			mode: 'local', // ����ģʽ
			editable: false,
			value: '0',
			selectOnFocus: true,
			forceSelection: true,
			listeners: {
				select: {
					fn: function (combo, record, index) {
						if (eIsCashField.getValue() == "1" || eIsCashField.getValue() == "2") { //����ֽ����еĿ�Ŀ
							eIsCashFlow.enable(); //�Ƿ��ֽ���������
							//����ֽ�������
							if (eIsCashFlow.getRawValue() == "��") {
								eCashFlowField.enable();
							} else {
								eCashFlowField.disable();
								eCashFlowField.setValue(0);
								eCashFlowField.setRawValue("");
							}

						} else { //����������ÿ�
							eIsCashFlow.disable();
							eCashFlowField.disable();
							eIsCashFlow.setValue(0);
							eIsCashFlow.setRawValue("��");
							eCashFlowField.setValue(0);
							eCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	//��Ŀ����
	var esubjGroupStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['01', 'ҽ��'], ['02', 'ҩ��'], ['03', '����'], ['09', '����']]
		});
	var esubjGroup = new Ext.form.ComboBox({
			id: 'esubjGroup',
			fieldLabel: '��Ŀ����',
			width: 180,
			selectOnFocus: true,
			allowBlank: false,
			store: esubjGroupStore,
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

	//�ֽ����б�ʶ
	var eIsCashFlowStore = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '��'], ['0', '��']]
		});
	var eIsCashFlow = new Ext.form.ComboBox({
			id: 'eIsCashFlow',
			fieldLabel: '�ֽ�������Ŀ',
			width: 180,
			selectOnFocus: true,
			//allowBlank : false,
			store: eIsCashFlowStore,
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
						if (eIsCashFlow.getValue() == "1") { //������ֽ�,�ֽ�������Ŀ����
							eCashFlowField.enable();
						} else {
							eCashFlowField.disable();
							eCashFlowField.setValue(0);
							eCashFlowField.setRawValue("");
						}
					}
				}
			}
		});

	var eStartDateField = new Ext.form.DateField({
			id: 'eStartDateField',
			fieldLabel: '��������',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	var eEndDateField = new Ext.form.DateField({
			id: 'eEndDateField',
			fieldLabel: 'ͣ������',
			format: 'Y-m',
			width: 180,
			emptyText: '',
			plugins: 'monthPickerPlugin'
		});

	//�ֽ�������
	var eCashFlowDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({
				totalProperty: 'results',
				root: 'rows'
			}, ['rowid', 'code', 'name'])
		});
	eCashFlowDs.on('beforeload', function (ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
				url: projUrl + '?action=cashflowlist&acctbookid=' + acctbookid,
				method: 'POST'
			});
	});
	var eCashFlowField = new Ext.form.ComboBox({
			id: 'eCashFlowField',
			fieldLabel: '�ֽ�������',
			width: 180,
			listWidth: 265,
			allowBlank: true,
			hidden:true,
			hideLabel :true,
			store: eCashFlowDs,
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

	var eSJFieldSet = new Ext.form.FieldSet({
			//title : '�޸Ļ�ƿ�Ŀ',
			height: 320,
			columnWidth: 1,
			layout: 'column',
			//labelSeparator: '��',
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
						esjlevelField,
						esjcodeField,
						esjnameField,
						esjtypeField,
						esjnatureField,
						esupercodeField,
						edefinecodeField,
						eNumUnitField
					]
				}, {
					columnWidth: .44,
					layout: 'form',
					labelWidth: 110,
					labelSeparator: " ",
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						edirectionField,
						eIsLastField,
						esubjGroup,
						eIsCashField,
						eIsCashFlow,
						eCashFlowField,
						eStartDateField,
						eEndDateField
					]
				},{
					columnWidth: .06,
					layout: 'form',
					hideLabel:true,
					style:'text-align:right',
					labelWidth: 0.005,
					items: [{
							xtype: 'displayfield',
							value: '',
							columnWidth: .3
						},
						eIsStopField,
						eIsFcField,
						eIsNumField,
						eIsCheckField
					]},{
					columnWidth: .1,
					layout: 'form',
					labelWidth: 0.5,
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
						eSJFieldSet
					]
				}
			]
		}
	];

	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
			//labelWidth: 100,
			labelAlign: 'right',
			frame: true,
			items: colItems
		});
	formPanel.on('afterlayout', function (panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		esjcodeField.setValue(rowObj[0].get("SubjCode")); //�༭ʱ,��Ŀ����
		var SubjNames = rowObj[0].get("SubjName"); //��Ŀ����--��ʱ��ҳ����ֵ(���пո�)
		var SubjNames = SubjNames.split(";");
		SubjName = SubjNames[SubjNames.length - 1]; //��Ŀ����ȥ���ո�
		esjnameField.setRawValue(SubjName);
		//
		edefinecodeField.setValue(rowObj[0].get("DefineCode")); //�Զ������
		esupercodeField.setValue(rowObj[0].get("SuperSubjCode")); //�ϼ�����
		esupercodeField.disable();

		var esjlevel = rowObj[0].get("SubjLevel"); //��Ŀ����
		esjlevelField.setValue(esjlevel);
		
		//esjtypeField.setValue(rowObj[0].get("SubjTypeID")); //��ȡ��Ŀ����ID
		//esjtypeField.setRawValue(rowObj[0].get("SubjTypeName")); //��ʾ��Ŀ��������

        //esjnatureField.setValue(rowObj[0].get("SubjNatureID")); //��ȡ��Ŀ����ID
		//esjnatureField.setRawValue(rowObj[0].get("SubjNatureName")); //��ʾ��Ŀ��������
		
		//�Ƿ�ĩ����Ŀ
		var eIsLast = rowObj[0].get("IsLast"); //�Ƿ�ĩ����Ŀ
		if (eIsLast == "��") {
			eIsLastField.setValue(1);
		} else {
			eIsLastField.setValue(0);
		};
		//�������
		var edirection = rowObj[0].get("Direction");
		if (edirection == "��") {
			edirectionField.setValue(1);
		} else {
			edirectionField.setValue(-1);
		};

		//�ֽ�������Ŀ
		var iscashflow = rowObj[0].get("IsCashFlow")
			if (iscashflow == "��") {
				eIsCashFlow.setValue(1);
				eIsCashFlow.setRawValue("��");
			} else {
				eIsCashFlow.setValue(0);
				eIsCashFlow.setRawValue("��");
				eCashFlowField.disable();
				eCashFlowField.setValue(0);
				eCashFlowField.setRawValue("");
			}

			//�ֽ���������(�ֽ����б�־)
			var eiscash = rowObj[0].get("IsCash");
		if (eiscash == "�ֽ�") {
			eIsCashField.setValue(1);
		} else if (eiscash == "����") {
			eIsCashField.setValue(2);
		} else {
			eIsCashField.setValue(0); //�ֽ����б�־����

			eIsCashFlow.disable();
			eIsCashFlow.setValue(0); //�Ƿ��ֽ�������Ŀ
			eIsCashFlow.setRawValue("��"); //��
			eCashFlowField.disable(); //
			eCashFlowField.setValue(0); //�ֽ��������ÿ�
			eCashFlowField.setRawValue("");

		}
		//������λ
		eNumUnitField.setRawValue(rowObj[0].get("NumUnit"));
		//��������
		var eIsNum = rowObj[0].get("IsNum");
		if (eIsNum == "��") {
			eIsNumField.setValue(true);
			eNumUnitField.enable();
		} else {
			eIsNumField.setValue(false);
			eNumUnitField.disable();
		};
		//��Һ���
		var eIsFc = rowObj[0].get("IsFc");
		if (eIsFc == "��") {
			eIsFcField.setValue(true);
		} else {
			eIsFcField.setValue(false);
		};
		//��������
		var eIsCheck = rowObj[0].get("IsCheck");
		if (eIsCheck == "��") {
			eIsCheckField.setValue(true);
		} else {
			eIsCheckField.setValue(false);
		};
		//�Ƿ�ͣ��
		var eIsStop = rowObj[0].get("IsStop");
		if (eIsStop == "��") {
			eIsStopField.setValue(true);
		} else {
			eIsStopField.setValue(false);
		};

		//��Ŀ����
		var esubjgroup = rowObj[0].get("subjGroup");
		if (esubjgroup == "ҽ��") {
			esubjGroup.setValue("01");
		} else if (esubjgroup == "ҩ��") {
			esubjGroup.setValue("02");
		} else if (esubjgroup == "����") {
			esubjGroup.setValue("02");
		} else {
			esubjGroup.setValue("09");
		}

		//�ֽ�������
		eCashFlowField.setValue(rowObj[0].get("CashFlowID"));
		eCashFlowField.setRawValue(rowObj[0].get("CashItemName"));

		eStartDateField.setValue(rowObj[0].get("StartYM"));
		eEndDateField.setValue(rowObj[0].get("EndYM"));

	});

	//***ȷ����ť***//
	addButton = new Ext.Toolbar.Button({
			text: '�����޸�',
			iconCls:'save'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {

		var esjcode = esjcodeField.getValue();
		var esjname = esjnameField.getValue();
		var esjnameAll = esjnameAllField.getValue();
		var espell = espellField.getValue();

		var edefinecode = edefinecodeField.getValue();
		var esupercode = esupercodeField.getValue();
		var esjlevel = esjlevelField.getValue();
		var esjtype = esjtypeField.getValue();
		if(esjtype==rowObj[0].get("SubjTypeName")){esjtype=""};
		var esjnature = esjnatureField.getValue();
		//alert(esjnature);
		if(esjnature==rowObj[0].get("SubjNatureName")){esjnature=""};
		var eIsLast = eIsLastField.getValue();
		var edirection = edirectionField.getValue();
		var eNumUnit = eNumUnitField.getValue();

		var eIsCash = eIsCashField.getValue();
		var eIsNum = (eIsNumField.getValue() == true) ? '1' : '0';
		var eIsFc = (eIsFcField.getValue() == true) ? '1' : '0';
		var eIsCheck = (eIsCheckField.getValue() == true) ? '1' : '0';
		var eIsStop = (eIsStopField.getValue() == true) ? '1' : '0';
		var esjGroup = esubjGroup.getValue();
		var eCashFlow = eCashFlowField.getValue();
		var eStartDate = eStartDateField.getValue();
		if (eStartDate !== "") {
			eStartDate = eStartDate.format('Y-m');
		}

		var eEndDate = eEndDateField.getValue();
		if (eEndDate !== "") {
			eEndDate = eEndDate.format('Y-m');
		}

		var eICFlow = eIsCashFlow.getValue();

		if ((esjname == "") || (esjcode == "")) {
			Ext.Msg.show({
				title: '����',
				msg: '��������Ʋ���Ϊ��',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		};

		var len3 = 0;
		var flag = 1;
		Ext.Ajax.request({
			async: false,
			url: '../csp/herp.acct.acctsubjserverexe.csp?action=editLength&acctbookid=' +
			acctbookid + '&esjlevel=' + esjlevel,
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					len3 = jsonData.info;
					var len4 = esjcode.length;
					if (len4 != len3) {
						Ext.Msg.show({
							title: '����',
							msg: '��Ŀ���벻�淶! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
						flag = 2;
						return;
					} else {
						var edata = esjcode + "|" + esjname + "|" + edefinecode + "|" + esupercode + "|" +
							esjlevel + "|" + esjtype + "|" + esjnature + "|" +
							eIsLast + "|" + edirection + "|" + eIsCash + "|" + eIsNum + "|" + eNumUnit + "|" +
							eIsFc + "|" + eIsCheck + "|" + eIsStop + "|" +
							esjGroup + "|" + eCashFlow + "|" + eStartDate + "|" + eEndDate + "|" + eICFlow
							
						Ext.Ajax.request({
							url: '../csp/herp.acct.acctsubjserverexe.csp?action=updatesj&edata=' +
							encodeURIComponent(edata) + '&acctbookid=' + acctbookid + '&rowid=' + rowid,
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
									addwin.close(); //��ӳɹ��رմ���
									Ext.Msg.show({
										title: 'ע��',
										msg: '�����޸ĳɹ�!',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
									itemGridDs.load(({
											params: {
												start: 0,
												limit: 25
											}
										}));
									CheckitemGrid.load({
										params: {
											start: 0,
											limit: 25
										}
									});
									//����ɹ���ͣ���ڵ�ǰҳ
									var tbarnum = itemGrid.getBottomToolbar();
									tbarnum.doLoad(tbarnum.cursor);
								} else {
									var message = "";
									if (jsonData.info == 'RepCode')
										message = '¼��ı����Ѵ���,�����˶Ժ���������! ';
									if (jsonData.info == 'err1')
										message = '��Ŀ�������Ŀ�������ƥ��! ';
									if (jsonData.info == 'err2')
										message = 'δ�ҵ��ϼ���Ŀ����,����¼���ϼ���Ŀ! ';
									if (jsonData.info == 'NotExist')
										message = '����ֱ���޸ķ�ͬ�����룡 ';
									if (jsonData.info == 'NotStop')
										message = '��Ŀ����ʹ�ã�����ͣ�ã� ';
									Ext.Msg.show({
										title: '����',
										msg: message,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
									return;
								}
							},
							scope: this
						});
					}
				}
			}
		});

		//addwin.close();

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
			title: '�޸Ŀ�Ŀ',
			width: 800,
			height: 380,
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
