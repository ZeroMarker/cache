// �޸ĺ���
updateFun = function(node) {
	
	
	if (node == null) {
		Ext.Msg.show({
					title : '��ʾ',
					msg : '��ѡ��Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		if (node.attributes.id == "roo") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '���ڵ㲻�����޸�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// ȡ������¼��rowid
			var rowid = node.attributes.id;

			var CodeField = new Ext.form.TextField({
						id : 'CodeField',
						fieldLabel : '��Ŀ����',
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
						fieldLabel : '��Ŀ����',
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
													title : '����',
													msg : '��Ŀ���Ʋ���Ϊ��!',
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
						data : [['1', '������Ŀ'], ['2', '��������Ŀ'], ['3', '֧����Ŀ']]
					});
		var itemTypeField = new Ext.form.ComboBox({
						id : 'itemTypeField',
						fieldLabel : '��Ŀ����',
						width : 275,
						listWidth : 275,
						selectOnFocus : true,
						allowBlank : false,
						store : itemTypeStore,
						anchor : '90%',
						value : '1', // Ĭ��ֵ
						displayField : 'keyValue',
						valueField : 'key',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.ItemTypeName,
						mode : 'local', // ����ģʽ
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
													title : '����',
													msg : '��Ŀ���Բ���Ϊ��!',
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
						fieldLabel : '�ϼ���Ԫ',
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
													title : '����',
													msg : '������Ŀ�����Ϊ��!',
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
						labelSeparator : 'ĩ�˱�־:',
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
						text : '�޸�'
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
								title : '��ʾ',
								msg : '��Ŀ����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '��Ŀ����Ϊ��!',
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
							waitMsg : '�޸���...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������?',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
												title : '��ʾ',
												msg : '�޸ĳɹ�!',
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
													title : '��ʾ',
													msg : '�����ظ�!',
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
													title : '��ʾ',
													msg : '�����ظ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
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
			};

			editButton.addListener('click', editHandler, false);

			cancel = new Ext.Toolbar.Button({
						text : '�˳�'
					});

			cancelHandler1 = function() {
				window.close();
			}

			cancel.addListener('click', cancelHandler1, false);

			var window = new Ext.Window({
						title : '�޸���Ŀ��¼',
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