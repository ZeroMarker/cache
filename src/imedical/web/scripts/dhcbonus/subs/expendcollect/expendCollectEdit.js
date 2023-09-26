expendCollectEdit = function() {
	// addFun = function(node) {
	// alert("zlg aaaa")

	var rowObj = IncomeCollectMain.getSelections();
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
	}

	var cField = new Ext.form.TextField({
				id : 'cField',
				fieldLabel : '����',
				allowBlank : false,
				width : 180,
				listWidth : 180,
				emptyText : '����...',
				anchor : '90%',
				selectOnFocus : 'true',

				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (cField.getValue() != "") {
								itemValue.focus();
							} else {
								Handler = function() {
									cField.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : '���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var itemValue = new Ext.form.NumberField({
				id : 'itemValue',
				fieldLabel : '��Ŀ��ֵ',
				allowBlank : false,
				width : 230,
				listWidth : 230,
				emptyText : '',
				anchor : '90%',
				decimalPrecision : 3,
				valueNotFoundText : rowObj[0].get("ExpenItemName"),
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (itemValue.getValue() != "") {
								unitField.focus();
							} else {
								Handler = function() {
									itemValue.focus();
								}
								Ext.Msg.show({
											title : '����',
											msg : '���Ʋ���Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	var UnitTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['1', '���˿���'], ['2', 'ִ�п���']]
			});
	var UnitTypeEdit = new Ext.form.ComboBox({
				id : 'UnitTypeEdit',
				fieldLabel : '��������',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : UnitTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("UnitType"),
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	unitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=unit&str='
							+ Ext.getCmp('unitField').getRawValue(),
					method : 'POST'
				})
	});

	var unitField = new Ext.form.ComboBox({
				id : 'unitField',
				fieldLabel : '�������',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : unitDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("BonusUnitCode") + '_'
						+ rowObj[0].get("BonusUnitName"),
				name : 'unitField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});

	var subItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['SubItemCode', 'SubItemName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type=3&start=0&limit=10
	subItemDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type=3&start=0&limit=10',

			method : 'POST'
		})
	});

	var subItemField = new Ext.form.ComboBox({
				id : 'subItemField',
				fieldLabel : '������Ŀ',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : subItemDs,
				valueField : 'SubItemCode',
				displayField : 'SubItemName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("ExpenItemName"),
				name : 'subItemField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});
	var calUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'CalUnitName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10
	calUnitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10&str='
					+ Ext.getCmp('calUnitField').getRawValue(),
			method : 'POST'
		})
	});

	var calUnitField = new Ext.form.ComboBox({
				id : 'calUnitField',
				fieldLabel : '���㵥λ',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : calUnitDs,
				valueField : 'CalUnitName',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("CalculateUnit"),
				name : 'calUnitField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});
	var interTpDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'CalUnitName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10
	interTpDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10&str='
					+ Ext.getCmp('calUnitField').getRawValue(),
			method : 'POST'
		})
	});

	var interTsField = new Ext.form.ComboBox({
				id : 'interTsField',
				fieldLabel : '�ӿ�����',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : interTpDs,
				valueField : 'CalUnitName',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("InterLocSetname"),
				name : 'interTsField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});

	cycleDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
					method : 'POST'
				})
	});

	var cycleEdit = new Ext.form.ComboBox({
				id : 'cycleEdit',
				fieldLabel : '��������',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : cycleDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'cycleEdit',
				valueNotFoundText : rowObj[0].get("BonusYear"),
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				//disabled : true,
				forceSelection : 'true',
				editable : false
			});

	var periodTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', '��'], ['Q', '��'], ['H', '����'], ['Y', '��']]
			});
	var periodTypeEdit = new Ext.form.ComboBox({
				id : 'periodTypeEdit',
				fieldLabel : '�ڼ�����',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : '�·�',
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

	periodTypeEdit.on("select", function(cmb, rec, id) {
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
					data = [['H01', '1~6�ϰ���'], ['H02', '7~12�°���']];
				}
				if (cmb.getValue() == "Y") {
					data = [['Y00', 'ȫ��']];
				}
				periodStore1.loadData(data);
			});
	periodStore1 = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var periodEdit = new Ext.form.ComboBox({
				id : 'periodEdit',
				fieldLabel : '�����ڼ�',
				selectOnFocus : true,
				allowBlank : false,
				width : 230,
				listWidth : 230,
				store : periodStore1,
				anchor : '90%',
				valueNotFoundText : rowObj[0].get("BonusPeriod"),
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

	
	var locSetDs1 = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name', 'shortcut'])
			});

	locSetDs1.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=3',
			method : 'POST'
		})
	});

	var interTypeEdit = new Ext.form.ComboBox({
				id : 'interTypeEdit',
				fieldLabel : '�ӿ�����',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : locSetDs1,
				valueField : 'rowid',
				displayField : 'shortcut',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("InterLocSetname"),
				name : 'interTypeEdit',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var interMedthodDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	interMedthodDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
					+ interTypeEdit.getValue() + '&start=0&limit=10',
			method : 'POST'
		})
	});
	interTypeEdit.on("select", function(cmb, rec, id) {

				interMedthodDs.load({
							params : {
								interLocSetDr : Ext.getCmp('interTypeEdit')
										.getValue(),
								start : 0,
								limit : 10
							}
						});
			});
			
	var interMethodEdit = new Ext.form.ComboBox({
				id : 'interMethodEdit',
				fieldLabel : '�ӿڷ���',
				width : 230,
				height : 230,
				listWidth : 230,
				allowBlank : false,
				store : interMedthodDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("methodDesc"),
				name : 'interMethodEdit',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [cycleEdit, periodTypeEdit, periodEdit, interTypeEdit,
						interMethodEdit, UnitTypeEdit, unitField, subItemField,
						calUnitField, itemValue]
			});
	// ������
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);

		cycleEdit.setValue(rowObj[0].get("BonusYear"));
		var periodType = rowObj[0].get("periodType")
		periodTypeEdit.setValue(periodType);

		// alert(periodType)
		interTsField.setValue(5);
		periodEdit.setValue(periodType + rowObj[0].get("BonusPeriod"));
		// var period = substring(rowObj[0].get("BonusPeriod"),1,1)
		// alert(period)

		interTypeEdit.setValue(rowObj[0].get("InterLocSetID"));
		
		interMethodEdit.setValue(rowObj[0].get("InterLocMethodID"));
		var unittype1 = rowObj[0].get("UnitType")
		var unitypeID = ''
		if (unittype1 == '���˿���') {
			unitypeID = 1
		}
		if (unittype1 == 'ִ�п���') {
			unitypeID = 2
		}
		UnitTypeEdit.setValue(unitypeID);

		unitField.setValue(rowObj[0].get("BonusUnitCode"));

		subItemField.setValue(rowObj[0].get("ExpendItemCode"));
		calUnitField.setValue(rowObj[0].get("CalculateUnit"));
		itemValue.setValue(rowObj[0].get("ItemValue"));
			/*
			 * 'rowid', 'ExpendItemCode', 'ExpenItemName', 'BonusYear',
			 * 'BonusPeriod', 'BonusUnitCode', 'BonusUnitName', 'UnitType',
			 * 'ExecuteDeptName', 'CalculateUnit', 'ItemValue', 'CollectDate',
			 * 'State', 'InterLocMethodID', 'methodDesc', 'InterLocSetname',
			 * 'UnitType'
			 */
		});
	// ��ʼ����Ӱ�ť
	addButton = new Ext.Toolbar.Button({
				text : '�� ��'
			});

	// ������Ӱ�ť��Ӧ����
	addHandler = function() {

		var sitemValue = itemValue.getValue();
		var scycleEdit = cycleEdit.getValue();
		var speriodTypeEdit = periodTypeEdit.getValue();
		var speriodEdit = periodEdit.getValue();
		var slocSetEdit = interTypeEdit.getValue();
		var sinterMethodEdit = interMethodEdit.getValue();

		var sUnitTypeEdit = UnitTypeEdit.getValue();
		var sunitField = unitField.getValue();
		var nunitField = Ext.get('unitField').dom.value;

		var ssubItemField = subItemField.getValue();
		var nsubItemField = Ext.get('subItemField').dom.value;

		var ncalUnitField = Ext.get('calUnitField').dom.value;
		var sitemValue = itemValue.getValue();

		var sparam1 = ssubItemField + '^' + (nsubItemField) + '^' + sunitField
				+ '^' + (nunitField) + '^' + scycleEdit + '^' + speriodEdit
				+ '^' + (ncalUnitField) + '^' + sitemValue + '^'
				+ sinterMethodEdit+ '^' + sUnitTypeEdit
		var rowid = rowObj[0].get("rowid")

		// alert(sparam1)
		// return;
		if (scycleEdit == "") {
			Ext.Msg.show({
						title : '����',
						msg : '������Ȳ���Ϊ�գ�',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (speriodEdit == "") {
			Ext.Msg.show({
						title : '����',
						msg : '�����ڼ䲻��Ϊ�գ�',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (sinterMethodEdit == "") {
			Ext.Msg.show({
						title : '����',
						msg : '���㷽������Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (ssubItemField == "") {
			Ext.Msg.show({
						title : '����',
						msg : '��Ŀ���벻��Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (nsubItemField == "") {
			Ext.Msg.show({
						title : '����',
						msg : '��Ŀ���Ʋ���Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (nunitField == "") {
			Ext.Msg.show({
						title : '����',
						msg : '���㵥λ����Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};

		// alert((name))
		// encodeURIComponent
		Ext.Ajax.request({
			url : '../csp/dhc.bonus.subexpendcollectexe.csp?action=edit&sParam='
					+ sparam1 + '&rowid=' + rowid,
			waitMsg : '������...',
			failure : function(result, request) {
				Handler = function() {
					unitField.focus();
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
				if (jsonData.success == '0') {
					Handler = function() {
						itemValue.focus();
					}
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ӳɹ�!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK,
								fn : Handler
							});

					IncomeCollect.load({
								params : {
									start : 0,
									limit : OutKPIDataPagingToolbar.pageSize
								}
							});
					// addwin.close();
				} else {
					var message = "";
					if (jsonData.info == 'RepCode')
						message = '����ı����Ѿ�����!';

					Ext.Msg.show({
								title : '����',
								msg : message,
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
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
				title : '��Ӽ�¼',
				width : 400,
				height : 350,
				minWidth : 400,
				minHeight : 300,
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
