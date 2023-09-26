addFun = function(locSetField, grid, ds, pagingToolbar) {
	var locsetName = Ext.getCmp('locSetField').getRawValue();
	var locsetDr = Ext.getCmp('locSetField').getValue();
	var periodStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var data = "";
	var data1 = [['01', '01��'], ['02', '02��'], ['03', '03��'], ['04', '04��'],
			['05', '05��'], ['06', '06��'], ['07', '07��'], ['08', '08��'],
			['09', '09��'], ['10', '10��'], ['11', '11��'], ['12', '12��']];
	var data2 = [['01', '01����'], ['02', '02����'], ['03', '03����'], ['04', '04����']];
	var data3 = [['01', '1~6�ϰ���'], ['02', '7~12�°���']];
	var data4 = [['00', '00']];

	var yearField = new Ext.form.NumberField({
				id : 'yearField',
				fieldLabel : '�������',
				allowBlank : false,
				emptyText : '',
				anchor : '90%',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
				allowNegative : false,
				allowDecimals : false,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (yearField.getValue() != "") {
								periodTypeField.focus();
							} else {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '������Ȳ���Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var periodTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', 'M-��'], ['Q', 'Q-��'], ['H', 'H-����'], ['Y', 'Y-��']]
			});
	var periodTypeField = new Ext.form.ComboBox({
				id : 'periodTypeField',
				fieldLabel : '�ڼ�����',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	periodTypeField.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data = data1;
				}
				if (cmb.getValue() == "Q") {
					data = data2;
				}
				if (cmb.getValue() == "H") {
					data = data3;
				}
				if (cmb.getValue() == "Y") {
					data = data4;
				}
				periodStore.loadData(data);

			});

	var periodField = new Ext.form.ComboBox({
				id : 'periodField',
				fieldLabel : '�����ڼ�',
				width : 180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : periodStore,
				anchor : '90%',
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				isteners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (periodField.getValue() != "") {
								startDate.focus();
							} else {
								Handler = function() {
									periodField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : '�ڼ䲻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var monthCombo = new Ext.ux.form.LovCombo({
		id : 'monthCombo',
		fieldLabel : '�����ڼ�',
		hideOnSelect : false,
		store : new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
						url : 'dhc.pa.interperiodexe.csp?action=quotelist&locSetDr='
								+ locsetDr
					}),
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results',
						id : 'rowid'
					}, ['rowid', 'name'])
		}, ['rowid', 'name']),
		valueField : 'rowid',
		displayField : 'name',
		typeAhead : false,
		triggerAction : 'all',
		pageSize : 18,
		width : 220,
		listWidth : 220,
		allowBlank : false,
		disabled : false,
		emptyText : '',
		editable : false,
		anchor : '90%'
	});

	// ������ʼʱ��ؼ�
	var startDate = new Ext.form.DateField({
				id : 'startDate',
				format : 'Y-m-d',
				fieldLabel : '��ʼʱ��',
				width : 220,
				disabled : false,
				emptyText : '',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (startDate.getValue() != "") {
								endDate.focus();
							} else {
								Handler = function() {
									startDate.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '��ʼʱ�䲻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	// �������ʱ��ؼ�
	var endDate = new Ext.form.DateField({
				id : 'endDate',
				format : 'Y-m-d',
				fieldLabel : '����ʱ��',
				width : 220,
				disabled : false,
				emptyText : '',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (endDate.getValue() != "") {
								remarkField.focus();
							} else {
								Handler = function() {
									endDate.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '����ʱ�䲻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var remarkField = new Ext.form.TextField({
				id : 'remarkField',
				fieldLabel : '��ע',
				allowBlank : true,
				width : 220,
				listWidth : 220,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});


		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 60,
					items : [yearField, periodTypeField, periodField,
							startDate, endDate, remarkField]
				});


	// ��ʼ����Ӱ�ť
	addButton = new Ext.Toolbar.Button({
				text : '�� ��'
			});

	// ������Ӱ�ť��Ӧ����
	addHandler = function() {
		var syear = yearField.getRawValue();
	

						  
		var periodType = periodTypeField.getValue();
		var period = periodField.getValue();

		var remark = remarkField.getValue();

		var data = "";
 
			var startDate = Ext.getCmp('startDate').getValue();
			if (startDate != "") {
				startDate = startDate.format('Y-m-d');
			} else {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ʼ����Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if (endDate != "") {
				endDate = endDate.format('Y-m-d');
			} else {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��������Ϊ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
			if (checkDate(startDate, endDate)) {
				var corrType = "I";
				data = locsetDr + "^" + period  + "^" + periodType + "^" + remark
						+ "^" + startDate + "^" + endDate + "^" + corrType+ "^" + syear;
			//prompt("data",data)
			} else {
				Ext.Msg.show({
							title : '��ʾ',
							msg : '��ʼ���ڴ��ڽ�������',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
		

		Ext.Ajax.request({
					url : 'dhc.bonus.interperiodexe.csp?action=add&data=' + data,
					waitMsg : '������...',
					failure : function(result, request) {
						Handler = function() {
							codeField.focus();
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
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '��ʾ',
										msg : '��ӳɹ�!',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});
							ds.load({
										params : {
											start : 0,
											limit : pagingToolbar.pageSize,
											locSetDr : locsetDr
										}
									});
						} else {
							if (jsonData.info == 'RepRecord') {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '�˼�¼�Ѿ�����!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
							if (jsonData.info == 'dataEmpt') {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '��¼Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
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
				title : '��ӽӿ��ڼ��¼',
				width : 343,
				height : 270,
				minWidth : 343,
				minHeight : 220,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton, cancelButton]
			});

	// ������ʾ
	addwin.show();

}