itemAddFun = function() {

	var itemCodeField = new Ext.form.TextField({
				id : 'itemCodeField',
				name : 'SchemeItemCode',
				fieldLabel : '奖金项代码',
				allowBlank : false,
				emptyText : '',
				anchor : '100%'
			});

	var itemNameField = new Ext.form.TextField({
				id : 'itemNameField',
				name : 'SchemeItemName',
				fieldLabel : '奖金项名称',
				allowBlank : false,
				emptyText : '',
				anchor : '100%'
			});

	var bonusFormulaDescField = new Ext.form.TextField({
				id : 'bonusFormulaDescField',
				name : 'BonusFormulaDesc',
				fieldLabel : '公式描述',
				emptyText : '',
				anchor : '100%'
			});

	var bonusTypeCombo = new Ext.form.ComboBox({
				fieldLabel : '奖金项属性',
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
				fieldLabel : '数据来源',
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
				fieldLabel : '项目类别',
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
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				hidden : true,
				emptyText : '公式设置',
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
		title : '添加',
		width : 300,
		height : 260,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			handler : function() {
				if (formPanel.form.isValid()) {

					if ((dataSourceCombo.getValue() == 2)
							&& (formulaTrgg.getValue() == '')) {
						Ext.Msg.show({
									title : '注意',
									msg : '公式不能为空!',
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
						waitMsg : '保存中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
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
									tmpmsg = '编码重复!';
								}
								if (jsonData.info == '2') {
									tmpmsg = '实发奖金项只能有一个!';
								}
								Ext.Msg.show({
											title : '错误',
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
								title : '错误',
								msg : tmpWrongName + '不能为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				itemAddWin.close();
			}
		}]

	});

	itemAddWin.show();

};