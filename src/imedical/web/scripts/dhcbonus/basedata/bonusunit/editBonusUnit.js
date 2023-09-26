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
									NameField.focus();
								}
							}
						}
					});

			var NameField = new Ext.form.TextField({
						id : 'NameField',
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
									if (NameField.getValue() != "") {
										PYField.focus();
									} else {
										Handler = function() {
											NameField.focus();
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

			var PYField = new Ext.form.TextField({
						id : 'PYField',
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
									UnitFlagField.focus();
								}
							}
						}
					});

			var UnitFlagStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['0', '��Ԫ����'], ['1', '�������'],
								['2', 'ҽ����'], ['3', '������Ա']]
					});
			var UnitFlagField = new Ext.form.ComboBox({
						id : 'UnitFlagField',
						fieldLabel : '��Ԫ����',
						width : 275,
						listWidth : 275,
						selectOnFocus : true,
						allowBlank : false,
						store : UnitFlagStore,
						anchor : '90%',
						value : '1', // Ĭ��ֵ
						valueNotFoundText : node.attributes.ufn,
						displayField : 'keyValue',
						valueField : 'key',
						triggerAction : 'all',
						emptyText : 'ѡ���־...',
						mode : 'local', // ����ģʽ
						editable : false,
						pageSize : 10,
						minChars : 1,
						selectOnFocus : true,
						forceSelection : true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (UnitFlagField.getValue() != "") {
										UnitTypeField.focus();
									} else {
										Handler = function() {
											UnitFlagField.focus();
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

			var UnitTypeDs = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			UnitTypeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp?action=type&str='
									+ (Ext.getCmp('UnitTypeField')
											.getRawValue()) + '&unitFlag='+(Ext.getCmp('UnitFlagField')
											.getRawValue()),
							method : 'POST'
						})
			});

			var SurperUnitDs = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			SurperUnitDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusunitexe.csp?action=lastunit&unitFlag=1&LastStage=0&start=0&limit=10',
					method : 'POST'
				})
			});
			var SurperUnitField = new Ext.form.ComboBox({
						id : 'SurperUnitField',
						fieldLabel : '�ϼ���Ԫ',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : SurperUnitDs,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.sn,
						name : 'SurperUnitField',
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
			var UnitTypeField = new Ext.form.ComboBox({
						id : 'UnitTypeField',
						fieldLabel : '�������',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : UnitTypeDs,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.btn,
						name : 'UnitTypeField',
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

			// ��Ԫ���ԺͿ����������
		UnitFlagField.on("select", function(cmb, rec, id) {
					
					UnitTypeField.setValue("");
					Ext.getCmp('UnitTypeField').setRawValue("");
					a(cmb.getValue());

					UnitTypeDs.load({
								params : {
									start : 0,
									limit : 10
								}
							});
				});		
			var a=function searchFun(SetCfgDr){

			UnitTypeDs.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp?action=type&str='
									+ (Ext.getCmp('UnitTypeField')
											.getRawValue()) + '&unitFlag='+(Ext.getCmp('UnitFlagField')
											.getRawValue()),
							method : 'POST'
						});
			UnitTypeDs.load({
						params : {
							start : 0,
							limit : 10
						}
					});
			};
			// ---------------------
			var sumUnit1Ds = new Ext.data.Store({
						autoLoad : true,
						proxy : "",
						reader : new Ext.data.JsonReader({
									totalProperty : 'results',
									root : 'rows'
								}, ['rowid', 'name'])
					});

			sumUnit1Ds.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusunitexe.csp?action=lastunit&unitFlag=1&LastStage=0&start=0&limit=10',
					method : 'POST'
				})
			});
			var sumUnit1Field = new Ext.form.ComboBox({
						id : 'sumUnit1Field',
						fieldLabel : '���ſ���',
						width : 275,
						listWidth : 275,
						allowBlank : false,
						store : sumUnit1Ds,
						valueField : 'rowid',
						displayField : 'name',
						triggerAction : 'all',
						emptyText : '',
						valueNotFoundText : node.attributes.mn,
						name : 'sumUnit1Field',
						minChars : 1,
						pageSize : 10,
						selectOnFocus : true,
						forceSelection : 'true',
						editable : true

					});
			// ----------------
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

								CodeField, NameField, sumUnit1Field,
								SurperUnitField, UnitFlagField, UnitTypeField,
								IsEndField]
					});

			formPanel.on('afterlayout', function(panel, layout) {
						this.getForm().loadRecord(node);
						NameField.setValue(node.attributes.nm);
						CodeField.setValue(node.attributes.cd);
						// PYField.setValue(node.attributes.no);
						UnitFlagField.setValue(node.attributes.UnitFlagDr);
						UnitTypeField.setValue(node.attributes.btr);
						sumUnit1Field.setValue(node.attributes.mid);
						
						startDate.setValue(node.attributes.sd);
						IsEndField.setValue(node.attributes.ls);
						SurperUnitField.setValue(node.attributes.parent)

					});

			editButton = new Ext.Toolbar.Button({
						text : '�޸�'
					});

			editHandler = function() {

				var code = CodeField.getValue();
				var name = NameField.getValue();
				var py = "" // PYField.getValue();
				//var sumdr = sumUnit1Field.getValue();
				var sumdr1 = Ext.getCmp('sumUnit1Field').getRawValue();
				if(sumdr1==""){var sumdr="";}
				else{var sumdr = sumUnit1Field.getValue();}
				var parent = SurperUnitField.getValue()
				var level = node.attributes.lv;
				var flag = Ext.getCmp('UnitFlagField').getValue();
				var typeDr = Ext.getCmp('UnitTypeField').getValue();
				var isEnd = (IsEndField.getValue() == true) ? '1' : '0';
				var InHDate = "";
				if (startDate.getValue() != "") {
					var InHDate = startDate.getValue().format('Y-m-d');
				}

				name = (trim(name));
				code = trim(code);
				py = trim(py);

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

				var data = code + "^" + name + "^" + py + "^" + flag + "^"
						+ typeDr + "^" + isEnd + "^" + parent + "^" + level
						+ "^" + sumdr+ "^" + InHDate;
				// alert(data) InHDate

				Ext.Ajax.request({
							url : '../csp/dhc.bonus.bonusunitexe.csp?action=edit&data='
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
									var message = "";
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
						title : '�޸Ľ���Ԫ��¼',
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