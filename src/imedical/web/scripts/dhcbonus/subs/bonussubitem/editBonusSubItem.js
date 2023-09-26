// 修改函数
updateFun = function(node) {
	
	
	if (node == null) {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		if (node.attributes.id == "roo") {
			Ext.Msg.show({
						title : '提示',
						msg : '根节点不允许被修改!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// 取该条记录的rowid
			var rowid = node.attributes.id;

			var CodeField = new Ext.form.TextField({
						id : 'CodeField',
						fieldLabel : '项目代码',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									NameField.focus();
								}
							}
						}
					});

			var NameField = new Ext.form.TextField({
						id : 'NameField',
						fieldLabel : '项目名称',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (NameField.getValue() != "") {
										PYField.focus();
									} else {
										Handler = function() {
											NameField.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : '项目名称不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
			

		var itemTypeStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['1', '收入项目'], ['2', '工作量项目'], ['3', '支出项目']]
					});
		var itemTypeField = new Ext.form.ComboBox({
						id : 'itemTypeField',
						fieldLabel : '项目属性',
						width : 275,
						listWidth : 275,
						selectOnFocus : true,
						allowBlank : false,
						store : itemTypeStore,
						anchor : '90%',
						value : '1', // 默认值
						displayField : 'keyValue',
						valueField : 'key',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.ItemTypeName,
						mode : 'local', // 本地模式
						editable : false,
						pageSize : 10,
						minChars : 1,
						selectOnFocus : true,
						forceSelection : true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (itemTypeField.getValue() != "") {
										unitTypeField.focus();
									} else {
										Handler = function() {
											itemTypeField.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : '项目属性不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});

			
				var SurperItemDs = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			SurperItemDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					//url : '../csp/dhc.bonus.bonussubitemexe.csp?action=lastunit&unitFlag=1&LastStage=0&start=0&limit=10',
					url : '../csp/dhc.bonus.bonussubitemexe.csp?action=lastunit&LastStage=0&start=0&limit=10',
					method : 'POST'
				})
			});
			var SurperItemField = new Ext.form.ComboBox({
						id : 'SurperItemField',
						fieldLabel : '上级单元',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : SurperItemDs,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.SuperiorItemName,
						name : 'SurperItemField',
						minChars : 1,
						pageSize : 10,
						selectOnFocus : true,
						forceSelection : 'true',
						editable : true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (UnitTypeField.getValue() != "") {
										IsEndField.focus();
									} else {
										Handler = function() {
											UnitTypeField.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : '所属项目类别不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
					
			var IsEndField = new Ext.form.Checkbox({
						id : 'IsEndField',
						labelSeparator : '末端标志:',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									updateButton.focus();
								}
							}
						}
					});

			formPanel = new Ext.form.FormPanel({
						baseCls : 'x-plain',
						labelWidth : 70,
						items : [

								CodeField, NameField, itemTypeField,SurperItemField,IsEndField]
					});

			formPanel.on('afterlayout', function(panel, layout) {
						this.getForm().loadRecord(node);
						NameField.setValue(node.attributes.name);
						CodeField.setValue(node.attributes.code);
						
						//PYField.setValue(node.attributes.EmployeeNo);
						itemTypeField.setValue(node.attributes.type);
						//UnitTypeField.setValue(node.attributes.BonusUnitTypeDr);
						
						
						IsEndField.setValue(node.attributes.lastStage);
						SurperItemField.setValue(node.attributes.parent)
					
					});

			editButton = new Ext.Toolbar.Button({
						text : '修改'
					});

			editHandler = function() {

				var code = CodeField.getValue();
				var name = NameField.getValue();
				var parent=SurperItemField.getValue()
				var type = itemTypeField.getValue();
				var isEnd = (IsEndField.getValue() == true) ? '1' : '0';

				name = (trim(name));
				code = trim(code);
				

				if (code == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '项目代码为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '项目名称为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				

				//alert(type);
			    //4445^5556^3^23^1^
				var data = code + "^" + name + "^" + type + "^" + parent + "^" + isEnd + "^" ;
				Ext.Ajax.request({
							url : '../csp/dhc.bonus.bonussubitemexe.csp?action=edit&data='
									+ data + '&rowid=' + rowid,
							waitMsg : '修改中...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接?',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									if (node.attributes.parent == 0) {
										node.attributes.parent = "roo";
									}
									Ext
											.getCmp('detailReport')
											.getNodeById(node.attributes.parent)
											.reload();
									window.close();
								} else {
									// var message = "";
									if (jsonData.info == 'RepCode') {
										Handler = function() {
											CodeField.focus();
										}
										Ext.Msg.show({
													title : '提示',
													msg : '代码重复!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
									if (jsonData.info == 'RepName') {
										Handler = function() {
											NameField.focus();
										}
										Ext.Msg.show({
													title : '提示',
													msg : '名称重复!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
									Ext.Msg.show({
												title : '错误',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
			};

			editButton.addListener('click', editHandler, false);

			cancel = new Ext.Toolbar.Button({
						text : '退出'
					});

			cancelHandler1 = function() {
				window.close();
			}

			cancel.addListener('click', cancelHandler1, false);

			var window = new Ext.Window({
						title : '修改项目记录',
						width : 415,
						height : 335,
						minWidth : 415,
						minHeight : 335,
						layout : 'fit',
						plain : true,
						modal : true,
						bodyStyle : 'padding:5px;',
						buttonAlign : 'center',
						items : formPanel,
						buttons : [editButton, cancel]
					});
			window.show();
		}
	}
};