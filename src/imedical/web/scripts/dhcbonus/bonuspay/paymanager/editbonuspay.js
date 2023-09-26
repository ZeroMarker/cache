function editBonus() {

	// ���岢��ʼ���ж���
	var rowObj = BonusPay.getSelections();
	// ���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		var rowid = rowObj[0].get("rowID");
	}

	var cycleDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['RowID', 'BonusYear'])
			});
	var bonusYearField = new Ext.form.ComboBox({
				id : 'bonusYearField',
				fieldLabel : '�������',
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : cycleDs,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : rowObj[0].get("BonusYear"),
				displayField : 'BonusYear',
				valueField : 'BonusYear',
				triggerAction : 'all',
				emptyText : 'ѡ��������...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.deptbonuscalcexe.csp'
									+ '?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

	var dateTypeField = new Ext.form.ComboBox({
				id : 'dateTypeField',
				fieldLabel : '�ڼ�����',
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("dateTypeField"),
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : 'ѡ���ڼ�����...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var addperiodStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	dateTypeField.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data = [['M01', '01��'], ['M02', '02��'], ['M03', '03��'],
							['M04', '04��'], ['M05', '05��'], ['M06', '06��'],
							['M07', '07��'], ['M08', '08��'], ['M09', '09��'],
							['M10', '10��'], ['M11', '11��'], ['M12', '12��']];
				}
				if (cmb.getValue() == "Q") {
					data = [['Q01', '01����'], ['Q02', '02����'], ['Q03', '03����'],
							['Q04', '04����']];
				}
				if (cmb.getValue() == "H") {
					data = [['H01', '�ϰ���'], ['H02', '�°���']];
				}
				if (cmb.getValue() == "Y") {
					data = [['Y00', '00']];
				}
				addperiodStore.loadData(data);

			});

	var bonusPeriodField = new Ext.form.ComboBox({
				id : 'bonusPeriodField',
				fieldLabel : '�����ڼ�',
				listWidth : 230,
				selectOnFocus : true,
				disabled : true,
				allowBlank : false,
				store : addperiodStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : rowObj[0].get("BonusPeriod"),
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : 'ѡ������ڼ�...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				name : 'order',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var editUnitField = new Ext.form.ComboBox({
				id : 'editUnitField',
				fieldLabel : '���㵥Ԫ',
				listWidth : 230,
				disabled : true,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDs,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : rowObj[0].get("BonusUnitName"),
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : 'ѡ����㵥Ԫ...',
				//mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	unitDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0',
							method : 'POST'
						})
			});

	var editProxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.paymanagerexe.csp?action=unitemp'
		
			});
	var editEmpDS = new Ext.data.Store({
				proxy : editProxy,
				reader : new Ext.data.JsonReader({
							root : 'rows',
							totalProperty : 'results'
						}, ['rowid', 'name']),
				remoteSort : true
			});

	editUnitField.on("select", function(cmb, rec, id) {
				if (Ext.getCmp('editUnitField').getValue() != '') {
					editEmpDS.load({
								params : {
									UnitID : Ext.getCmp('editUnitField')
											.getValue()
								}
							});
				}

			});

	var editEmpField = new Ext.form.ComboBox({
				id : 'editEmpField',
				fieldLabel : '��ȡ��Ա',
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : editEmpDS,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : rowObj[0].get("EmployeeName"),

				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : 'ѡ����ȡ��Ա...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'Ӧ��ϵͳ���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var BonusValueField = new Ext.form.NumberField({
				id : 'BonusValueField',
				fieldLabel : '���ý���',
				allowBlank : false,
				emptyText : '���ý���...',
				anchor : '90%',
				width : 220,
				listWidth : 220,
				value : '',
				valueNotFoundText : rowObj[0].get("BonusValue"),
				selectOnFocus : true,
				allowNegative : false,
				allowDecimals : false,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (orderField.getValue() != "") {
								appSysField.focus();
							} else {
								Handler = function() {
									orderField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : 'ά�ȷ���˳����Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	// ���岢��ʼ�����
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [bonusYearField, dateTypeField, bonusPeriodField,
						editUnitField, editEmpField, BonusValueField]
			});

	// ������
	formPanel.on('afterlayout', function(panel, layout) {

				var sBonusPeriod = rowObj[0].get("PeriodCode")
				var periodType = sBonusPeriod.substring(0, 1)

				bonusYearField.setValue(rowObj[0].get("BonusYear"))

				dateTypeField.setValue(periodType)
				bonusPeriodField.setValue(sBonusPeriod)

				editUnitField.setValue(rowObj[0].get("BonusUnitID"))
				editEmpField.setValue(rowObj[0].get("BonusEmployeeID"))
				BonusValueField.setValue(rowObj[0].get("BonusValue"))
			});

	// ���岢��ʼ�������޸İ�ť
	var editButton = new Ext.Toolbar.Button({
				text : '�����޸�'
			});

	// �����޸İ�ť��Ӧ����
	editHandler = function() {

		var empid = editEmpField.getValue();
		var BonusYear = bonusYearField.getValue();
		var BonusPeriod = bonusPeriodField.getValue();
		var BonusValue = Ext.getCmp('BonusValueField').getValue();

		if (empid == "") {
			Ext.Msg.show({
						title : '����',
						msg : '��ȡ��ԱΪ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusPeriod == "") {
			Ext.Msg.show({
						title : '����',
						msg : '�����ڼ�Ϊ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusYear == "") {
			Ext.Msg.show({
						title : '����',
						msg : '�������Ϊ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusValue == "") {
			Ext.Msg.show({
						title : '����',
						msg : '��ȡ���Ϊ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		var edits = rowid + '^' + empid + '^' + BonusYear + '^' + BonusPeriod
				+ '^' + BonusValue

		Ext.Ajax.request({
			url : '../csp/dhc.bonus.paymanagerexe.csp?action=edit&edits='
					+ edits,
			waitMsg : '������...',
			failure : function(result, request) {
				Handler = function() {
					BonusValueField.focus();
				}
				Ext.Msg.show({
							title : '����',
							msg : '������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR,
							fn : Handler
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({
								title : 'ע��',
								msg : '�޸ĳɹ�!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK
							});
					// ���¼���ҳ��
					BonusPayTabDs.load({
						params : {
							bonusYear : Ext.getCmp('periodYear').getValue(),
							bonusPeriod : Ext.getCmp('periodField').getValue(),
							bonusUnit : Ext.getCmp('editUnitField').getValue(),
							start : 0,
							limit : BonusPayTabPagingToolbar.pageSize
						}
					});

					editwin.close();
				} else {
					if (jsonData.info == 'RepCode') {
						Handler = function() {
							BonusValueField.focus();
						}
						Ext.Msg.show({
									title : '����',
									msg : 'ά�ȷ�������Ѿ�����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR,
									fn : Handler
								});
					}
				}
			},
			scope : this
		});
	}

	// ��ӱ����޸İ�ť�ļ����¼�
	editButton.addListener('click', editHandler, false);

	// ���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
				text : 'ȡ���޸�'
			});

	// ����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function() {
		editwin.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	// ���岢��ʼ������
	var editwin = new Ext.Window({
				title : '�޸���Ա���𷢷�',
				width : 380,
				height : 260,
				minWidth : 380,
				minHeight : 260,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [editButton, cancelButton]
			});

	// ������ʾ
	editwin.show();
}
