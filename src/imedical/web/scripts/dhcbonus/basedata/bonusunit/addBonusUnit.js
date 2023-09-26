// ���Ӻ���
addFun = function(node) {
	if (node != null) {
		var end = node.attributes.ls;
		if (end == 1) {
			Ext.Msg.show({
						title : '��ʾ',
						msg : 'ĩ�˲��������ӽڵ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// ��ĩ�˽ڵ�,��������

			var codeField = new Ext.form.TextField({
						id : 'codeField',
						fieldLabel : '��Ԫ����',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									nameField.focus();
								}
							}
						}
					});

			var nameField = new Ext.form.TextField({
						id : 'nameField',
						fieldLabel : '��Ԫ����',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (nameField.getValue() != "") {
										pyField.focus();
									} else {
										Handler = function() {
											nameField.focus();
										}
										Ext.Msg.show({
													title : '����',
													msg : '��Ԫ���Ʋ���Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});

			var pyField = new Ext.form.TextField({
						id : 'pyField',
						fieldLabel : 'Ա �� ��',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									unitFlagField.focus();
								}
							}
						}
					});
			// ---------------------
			var sumUnitDs = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			sumUnitDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusunitexe.csp?action=UnitList&unitFlag=1&LastStage=0&start=0&limit=10',
					method : 'POST'
				})
			});
			var sumUnitField = new Ext.form.ComboBox({
						id : 'sumUnitField',
						fieldLabel : '���ſ���',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : sumUnitDs,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						// valueNotFoundText : node.attributes.mn,
						name : 'sumUnitField',
						minChars : 1,
						pageSize : 10,
						selectOnFocus : true,
						forceSelection : 'true',
						editable : true

					});
			// ----------------
			var unitFlagStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['0', '��Ԫ����'], ['1', '�������'],
								['2', 'ҽ����'], ['3', '������Ա']]
					});
			var unitFlagField = new Ext.form.ComboBox({
						id : 'unitFlagField',
						fieldLabel : '��Ԫ����',
						width : 275,
						listWidth : 275,
						selectOnFocus : true,
						allowBlank : false,
						store : unitFlagStore,
						anchor : '90%',
						value : '1', // Ĭ��ֵ
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
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (unitFlagField.getValue() != "") {
										unitTypeField.focus();
									} else {
										Handler = function() {
											unitFlagField.focus();
										}
										Ext.Msg.show({
													title : '����',
													msg : '��Ԫ���Բ���Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});

			var startDate = new Ext.form.DateField({
						id : 'startDate',
						fieldLabel : '��ְ����',
						allowBlank : false,
						dateFormat : 'Y-m-d',
						emptyText : '',
						anchor : '90%',
						isteners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (startDate.getValue() == "") {

										Handler = function() {
											startDate.focus();
										}
										Ext.Msg.show({
													title : '����',
													msg : '��Ժ����Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
			// �����ͺ��㵥Ԫ����
			unitFlagField.on("select", function(cmb, rec, id) {
						searchFun(cmb.getValue());

						unitTypeDs.load({
									params : {
										start : 0,
										limit : 20
									}
								});

					});
			var searchFun=function searchFun(SetCfgDr) {
				unitTypeDs.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp?action=type&str='
									+ Ext.getCmp('unitTypeField').getRawValue()
									+ '&unitFlag='
									+ Ext.getCmp('unitFlagField').getRawValue(),
							method : 'POST'
						});
				unitTypeDs.load({
							params : {
								start : 0,
								limit : 20
							}

						});
			};

			var unitTypeDs = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			unitTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp?action=type&str='
									+ Ext.getCmp('unitTypeField').getRawValue()
									+ '&unitFlag='
									+ Ext.getCmp('unitFlagField').getRawValue(),
							method : 'POST'
						})
			});

			var unitTypeField = new Ext.form.ComboBox({
						id : 'unitTypeField',
						fieldLabel : '��Ԫ���',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : unitTypeDs,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						name : 'unitTypeField',
						minChars : 1,
						pageSize : 10,
						selectOnFocus : true,
						forceSelection : 'true',
						editable : true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (unitTypeField.getValue() != "") {
										isEndField.focus();
									} else {
										Handler = function() {
											unitTypeField.focus();
										}
										Ext.Msg.show({
													title : '����',
													msg : '�������������Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});

			var isEndField = new Ext.form.Checkbox({
						id : 'isEndField',
						labelSeparator : 'ĩ�˱�־:',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addButton.focus();
								}
							}
						}
					});

			formPanel = new Ext.form.FormPanel({
						baseCls : 'x-plain',
						labelWidth : 70,
						items : [

								codeField, nameField, sumUnitField,
								unitFlagField, unitTypeField,
								isEndField]
					});

			// �������Ӱ�ť
			var addButton = new Ext.Toolbar.Button({
						text : '����'
					});

			// ���Ӵ�������
			var addHandler = function() {
				var code = codeField.getValue();
				var name = nameField.getValue();

				var py = "" // pyField.getValue();
				var flag = unitFlagField.getValue();
				var typeDr = unitTypeField.getValue();
				var sumUnitDr = sumUnitField.getValue();
				var InHDate = "";
				if (startDate.getValue() != "") {
					var InHDate = startDate.getValue().format('Y-m-d');
				}

				var isEnd = (isEndField.getValue() == true) ? '1' : '0';

				var parent = 0;
				var level = 0;
				if (node.attributes.id != "roo") {
					parent = node.attributes.id;
					level = node.attributes.level;
				}

				name = trim(name);
				code = trim(code);
				py = trim(py);

				// alert(code+name+py+flag+typeDr+isEnd+parent+":"+level+":"+sumUnitDr);
				if (code == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '����Ԫ����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '����Ԫ����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};

				if (typeDr == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '�����������Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				// encodeURIComponent encodeURI
				var url = '../csp/dhc.bonus.bonusunitexe.csp?action=add&code='
						+ code + '&name=' + name + '&spell=' + py
						+ '&sumunit=' + sumUnitDr + '&unitFlag=' + flag
						+ '&unitType=' + typeDr + '&lastStage=' + isEnd
						+ '&parent=' + parent + '&level=' + level
						+ '&startDate=' + InHDate;

				// alert(url); startDate

				// code,name,spell,unitFlag,unitType,lastStage,parent, level
				Ext.Ajax.request({
							url : Ext.util.Format.htmlDecode(url),
							waitMsg : '������..',
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
												title : '��ʾ',
												msg : '���ӳɹ�!',
												icon : Ext.MessageBox.INFO,
												buttons : Ext.Msg.OK
											});
									Ext.getCmp('detailReport')
											.getNodeById(node.attributes.id)
											.reload();
									// win.close();
								} else {

									if (jsonData.info == 'RepCode') {
										Handler = function() {
											codeField.focus();
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
											nameField.focus();
										}
										Ext.Msg.show({
													title : '��ʾ',
													msg : '�����ظ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}

									if (jsonData.info == 'null') {
										Handler = function() {
											nameField.focus();
										}
										Ext.Msg.show({
													title : '��ʾ',
													msg : '����ǰ���ӹ���������,û���ϼ��ڵ�ID!',
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

			// ���Ӱ�ť����Ӧ�¼�
			addButton.addListener('click', addHandler, false);

			// ����ȡ����ť
			var cancelButton = new Ext.Toolbar.Button({
						text : 'ȡ��'
					});

			// ȡ����������
			var cancelHandler = function() {
				win.close();
			}

			// ȡ����ť����Ӧ�¼�
			cancelButton.addListener('click', cancelHandler, false);

			var win = new Ext.Window({
						title : '���ӽ���Ԫ��¼',
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
						buttons : [addButton, cancelButton]
					});
			win.show();
		}
	} else {
		Ext.Msg.show({
					title : '����',
					msg : '��ѡ��Ҫ�����ӽڵ�ļ�¼��',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
	}
};