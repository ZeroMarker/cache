itemEditFun = function() {
    	var rowObj = itemMain.getSelectionModel().getSelections();
    
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
	var ItemTypeName = new Ext.form.ComboBox({
				id : 'ItemTypeName',
				name : 'ItemTypeName',
				fieldLabel : '项目类别',
				anchor : '100%',
				allowBlank : false,
				store : bonusItemTypeDs,
				valueField : 'rowid',
				displayField : 'name',
				valueNotFoundText : rowObj[0].get("BonusItemTypeName"),
				triggerAction : 'all',
				pageSize : 10,

				emptyText : '',
				selectOnFocus : true,
				minChars : 1
			});
			
			//alert(ItemTypeName.getValue())
			
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
				name : 'BonusFormulaDesc',
				editable : false,
				hidden : true,
				emptyText : '公式设置',
				anchor : '100%'
			});

	// var formu='';

	formulaTrgg.onTriggerClick = function() {
		formula(tmpSelectedScheme, 1, this);

	};

	var rowObj = itemMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";

	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		tmpRowid = rowObj[0].get("rowid");
	}

	bonusTypeCombo.name = 'BonusType';
	dataSourceCombo.name = 'DataSource';

	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 70,
				items : [itemCodeField, itemNameField, ItemTypeName,
						bonusTypeCombo, dataSourceCombo, formulaTrgg
				// bonusFormulaDescField
				]
			});
	//面板加载后自动加载修改数据
	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				
				//BonusItemTypeID
				ItemTypeName.setValue(rowObj[0].get("BonusItemTypeID"));
			});

	var itemEditWin = new Ext.Window({
		title : '修改',
		width : 300,
		height : 250,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			id : 'saveButton',
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
							+ItemTypeName.getValue()
							+"|"
							+ itemCodeField.getValue().trim()
							+ "|"
							+ itemNameField.getValue().trim()
							+ "|"
							+ dataSourceCombo.getValue()
							+ "|"
							+ decodeURI(formu)
							+ "|"
							+ decodeURI(formulaTrgg
									.getValue()) + "|"
							+ bonusTypeCombo.getValue() + "|1|1|" + dt;
							
					Ext.Ajax.request({
						url : itemUrl + '?action=itemedit&data=' + tmpData
								+ '&rowid=' + tmpRowid,
						//url : itemUrl + '?action=itemedit&rowid=' + tmpRowid,
						waitMsg : '保存中...',
						//method : 'POST',
						 params : {
                            data : tmpData
                           },
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
								itemEditWin.close();
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
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				itemEditWin.close();
			}
		}]
	});

	if (rowObj[0].get("DataSource") == 2) {
		formulaTrgg.show();
	}

	itemEditWin.show();

};