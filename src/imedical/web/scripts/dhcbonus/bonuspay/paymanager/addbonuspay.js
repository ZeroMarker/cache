function addBotton() {

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
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : cycleDs,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
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
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
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
				allowBlank : false,
				store : addperiodStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
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

	var unitDatas = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var bonusUnitAdd = new Ext.form.ComboBox({
				id : 'bonusUnitAdd',
				fieldLabel : '���㵥Ԫ',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDatas,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
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
	unitDatas.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0', //&start=0&limit=5
							method : 'POST'
						})
			});

	var Proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.paymanagerexe.csp?action=unitemp'
			});
	var empDs = new Ext.data.Store({
				proxy : Proxy,
				reader : new Ext.data.JsonReader({
							root : 'rows',
							totalProperty : 'results'
						}, ['rowid', 'name']),
				remoteSort : true
			});

	bonusUnitAdd.on("select", function(cmb, rec, id) {
				if (Ext.getCmp('bonusUnitAdd').getValue() != '') {
					empDs.load({
								params : {
									UnitID : Ext.getCmp('bonusUnitAdd')
											.getValue()
								}
							});
				}

			});

	var bonusEmpField = new Ext.form.ComboBox({
				id : 'bonusEmpField',
				fieldLabel : '��ȡ��Ա',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : empDs,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				// valueNotFoundText : rowObj[0].get("appSysName"),
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

	// ��ʼ�����
	var addformPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [bonusYearField, dateTypeField, bonusPeriodField,
						bonusUnitAdd, bonusEmpField, BonusValueField]
			});
	// ��ʼ����Ӱ�ť
	addButton = new Ext.Toolbar.Button({
				text : '�� ��'
			});

	// ������Ӱ�ť��Ӧ����
	addHandler = function() {

		var empid = bonusEmpField.getValue();
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
		var inserts = empid + '^' + BonusYear + '^' + BonusPeriod + '^'
				+ BonusValue

		Ext.Ajax.request({
			url : '../csp/dhc.bonus.paymanagerexe.csp?action=add&inserts='
					+ inserts,
			waitMsg : '������...',
			failure : function(result, request) {
				Handler = function() {
					BonusValue.focus();
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
					Handler = function() {
						BonusValueField.focus();
					}
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ӳɹ�!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK,
								fn : Handler
							});
					// ���¼���ҳ��
					BonusPayTabDs.load({
						params : {
							bonusYear : Ext.getCmp('periodYear').getValue(),
							bonusPeriod : Ext.getCmp('periodField').getValue(),
							bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
							start : 0,
							limit : BonusPayTabPagingToolbar.pageSize
						}
					});

				} else {
					if (jsonData.info == 'exist') {
						Handler = function() {
							BonusValueField.focus();
						}
						Ext.Msg.show({
									title : '����',
									msg : '�����Ѿ����!',
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

	// ��ӱ��水ť�ļ����¼�
	addButton.addListener('click', addHandler, false);

	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : 'ȡ��'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		addwin.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	// ��ʼ������
	addwin = new Ext.Window({
				title : '���ά�ȷ����¼',
				width : 380,
				height : 300,
				minWidth : 380,
				minHeight : 250,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : addformPanel,
				buttons : [addButton, cancelButton]
			});

	// ������ʾ
	addwin.show();
}
