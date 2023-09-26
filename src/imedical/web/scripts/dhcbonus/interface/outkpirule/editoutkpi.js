editFun = function(outKpiDs, outKpiGrid, outKpiPagingToolbar) {
	var rowObj = outKpiGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的奖金指标记录!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	} else {
		var CodeField = new Ext.form.TextField({
					id : 'CodeField',
					fieldLabel : '奖金指标代码',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					name : 'code',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (CodeField.getValue() != "") {
									NameField.focus();
								} else {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '代码不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var NameField = new Ext.form.TextField({
					id : 'NameField',
					fieldLabel : '奖金指标名称',
					allowBlank : true,
					width : 180,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					name : 'name',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (NameField.getValue() != "") {
									activeField.focus();
								} else {
									Handler = function() {
										NameField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '名称不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var activeField = new Ext.form.Checkbox({
					id : 'activeField',
					labelSeparator : '有效标志:',
					allowBlank : false,
					checked : (rowObj[0].data['active']) == 'Y' ? true : false,
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								editButton.focus();
							}
						}
					}
				});
		var orderField = new Ext.form.NumberField({
					id : 'orderField',
					fieldLabel : '取值位置',
					allowBlank : true,
					width : 150,
					listWidth : 150,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'

				});
		var interMethodDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		interMethodDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.intermethodexe.csp?action=InterMethod',
						method : 'POST'
					})
		});

		var interMethodField = new Ext.form.ComboBox({
					id : 'interMethodField',
					fieldLabel : '接口方法',
					allowBlank : false,
					store : interMethodDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'interMethodField',
					minChars : 1,
					// mode : 'local', // 本地模式
					valueNotFoundText : rowObj[0].get('methodDesc'),
					pageSize : 10,
					anchor : '90%',
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 80,
					items : [CodeField, NameField, interMethodField,
							orderField, activeField]
				});

		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					
					interMethodField.setValue(rowObj[0].get("interMethodDr"))
					orderField.setValue(rowObj[0].get("location"))
					
				});

		var editButton = new Ext.Toolbar.Button({
					text : '修改'
				});

		// 添加处理函数
		var editHandler = function() {
			var code = Ext.getCmp('CodeField').getValue();
			var name = Ext.getCmp('NameField').getValue();
			var medthodDr = Ext.getCmp('interMethodField').getValue();
			var order = Ext.getCmp('orderField').getValue();
			
			var active = (activeField.getValue() == true) ? 'Y' : 'N';

			code = trim(code);
			if (name == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '奖金指标代码为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			name = trim(name);

			if (name == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '奖金指标名称为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};

			var locSetDr = rowObj[0].get("inLocSetDr");

			var rowid = rowObj[0].get("rowid");
			Ext.Ajax.request({
				url : 'dhc.bonus.outkpiruleexe.csp?action=edit&locSetDr='
						+ locSetDr + '&code=' + code + '&name=' + (name)
						+ '&active=' + active + '&rowid=' + rowid
						+ '&interMethodDr=' + medthodDr+ '&order=' + order,
				waitMsg : '添加中..',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : '提示',
									msg : '修改成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK
								});
						outKpiDs.load({
									params : {
										start : 0,
										limit : outKpiPagingToolbar.pageSize,
										locSetDr : LocSetGrid.getSelections()[0]
												.get("rowid"),
										dir : 'asc',
										sort : 'rowid'
									}
								});
						win.close();
					} else {
						if (jsonData.info == 'RepRecode') {
							Handler = function() {
								CodeField.focus();
							}
							Ext.Msg.show({
										title : '提示',
										msg : '数据记录重复!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO,
										fn : Handler
									});
						}
						if (jsonData.info == 'rowidEmpt') {
							Handler = function() {
								CodeField.focus();
							}
							Ext.Msg.show({
										title : '提示',
										msg : '错误数据!',
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

		// 添加按钮的响应事件
		editButton.addListener('click', editHandler, false);

		// 定义取消按钮
		var cancelButton = new Ext.Toolbar.Button({
					text : '取消'
				});

		// 取消处理函数
		var cancelHandler = function() {
			win.close();
		}

		// 取消按钮的响应事件
		cancelButton.addListener('click', cancelHandler, false);

		var win = new Ext.Window({
					title : '修改奖金指标',
					width : 380,
					height : 200,
					minWidth : 380,
					minHeight : 200,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [editButton, cancelButton]
				});
		win.show();
	}
}