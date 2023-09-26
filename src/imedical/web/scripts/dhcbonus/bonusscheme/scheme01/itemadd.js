itemAddFun = function() {

	var itemCodeField = new Ext.form.TextField({
				id : 'itemCodeField',
				name : 'SchemeItemCode',
				fieldLabel : '���������',
				allowBlank : false,
				emptyText : '',
				anchor : '100%'
			});

	var itemNameField = new Ext.form.TextField({
				id : 'itemNameField',
				name : 'SchemeItemName',
				fieldLabel : '����������',
				allowBlank : false,
				emptyText : '',
				anchor : '100%'
			});

	var bonusFormulaDescField = new Ext.form.TextField({
				id : 'bonusFormulaDescField',
				name : 'BonusFormulaDesc',
				fieldLabel : '��ʽ����',
				emptyText : '',
				anchor : '100%'
			});

	var bonusTypeCombo = new Ext.form.ComboBox({
				fieldLabel : '����������',
				name : 'type',
				store : bonusTypeSt,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				selectOnFocus : true,
				anchor : '100%'
			});

	var dataSourceCombo = new Ext.form.ComboBox({
				fieldLabel : '������Դ',
				name : 'type',
				store : dataSourceSt,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '',
				selectOnFocus : true,
				anchor : '100%'
			});
	var ItemTypeName = new Ext.form.ComboBox({
				id : 'ItemTypeName',
				name : 'name',
				fieldLabel : '��Ŀ���',
				anchor : '100%',
				allowBlank : false,
				store : bonusItemTypeDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				pageSize : 10,

				emptyText : '',
				selectOnFocus : true,
				minChars : 1
			});

	// BonusItemTypeName
	dataSourceCombo.on('select', function(combo, record, index) {
				var tmpDataSource = dataSourceCombo.getValue();
				if (tmpDataSource == 1) {
					formulaTrgg.hide();
					formu = '';
					formulaTrgg.setValue('');

				} else {
					formulaTrgg.show();
				}
			});

	var formulaTrgg = new Ext.form.TriggerField({
				fieldLabel : '��ʽ����',
				// disabled:true,
				editable : false,
				hidden : true,
				emptyText : '��ʽ����',
				anchor : '100%'
			});

	// var formu='';

	formulaTrgg.onTriggerClick = function() {
		formula(tmpSelectedScheme, 1, this);

	};

	itemCodeField.setValue('');
	itemNameField.setValue('');
	bonusTypeCombo.setValue('');
	dataSourceCombo.setValue('');
	bonusFormulaDescField.setValue('');

	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 70,
				items : [itemCodeField, itemNameField, ItemTypeName,
						bonusTypeCombo, dataSourceCombo, formulaTrgg// ,
				// bonusFormulaDescField
				]
			});

	var itemAddWin = new Ext.Window({
		title : '���',
		width : 300,
		height : 260,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '����',
			handler : function() {
				if (formPanel.form.isValid()) {

					if ((dataSourceCombo.getValue() == 2)
							&& (formulaTrgg.getValue() == '')) {
						Ext.Msg.show({
									title : 'ע��',
									msg : '��ʽ����Ϊ��!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.WARNING
								});
						return;
					}
					tmpData = tmpSelectedScheme
							+ "|"
							+ ItemTypeName.getValue()
							+ "|"
							+ itemCodeField.getValue().trim()
							+ "|"
							+ itemNameField.getValue().trim()
							+ "|"
							+ dataSourceCombo.getValue()
							+ "|"
							+ encodeURIComponent(formu)
							+ "|"
							+ decodeURI(encodeURIComponent(formulaTrgg
									.getValue())) + "|"
							+ bonusTypeCombo.getValue() + "|1|1|" + dt;
							
					Ext.Ajax.request({
						url : itemUrl + '?action=itemadd&data=' + tmpData,
						waitMsg : '������...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '����',
										msg : '������������!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : 'ע��',
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								itemDs.load({
											params : {
												start : 0,
												limit : itemPagingToolbar.pageSize
											}
										});
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '�����ظ�!';
								}
								if (jsonData.info == '2') {
									tmpmsg = 'ʵ��������ֻ����һ��!';
								}
								Ext.Msg.show({
											title : '����',
											msg : tmpmsg,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});

				} else {
					var tmpWrongName = checkAdd(formPanel);
					Ext.Msg.show({
								title : '����',
								msg : tmpWrongName + '����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : 'ȡ��',
			handler : function() {
				itemAddWin.close();
			}
		}]

	});

	itemAddWin.show();

};