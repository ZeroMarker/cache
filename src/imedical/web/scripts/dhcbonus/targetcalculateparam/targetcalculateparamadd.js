

// ��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function() {

		// ���𷽰�
		var SchemeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		SchemeDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl
										+ '?action=schemelist1&str='
										+ Ext.getCmp('SchField').getRawValue(),
								method : 'POST'
							})
				});

		var SchField = new Ext.form.ComboBox({
					id : 'SchField',
					fieldLabel : '���𷽰�',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : SchemeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'SchField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (SchField.getValue() != "") {
									UnField.focus();
								} else {
									Handler = function() {
										UnField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���𷽰�����Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// �������㵥Ԫ����
		SchField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					UnField.setValue("");
					UnField.setRawValue("");
					UnitDs.load({
								params : {
									start : 0,
									limit : StratagemTabPagingToolbar.pageSize
								}
							});

				});

		function searchFun(BonusSchemeID) {
			UnitDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/targetcalculateparamexe.csp?action=suunit&str='
								+ Ext.getCmp('UnField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchField').getValue()
								+ '&BonusUnitTypeID='
								+ Ext.getCmp('UnTypeField').getValue(),
						method : 'POST'
					});
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};

		// ���㵥Ԫ���

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
				url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=list&start=0&limit=10&sort=code&dir=ASC',

				method : 'POST'
			})
		});

		var UnTypeField = new Ext.form.ComboBox({
					id : 'UnTypeField',
					fieldLabel : '��Ԫ���',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnTypeField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (UnField.getValue() != "") {
									TarField.focus();
								} else {
									Handler = function() {
										TarField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���㵥Ԫ����Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// �������Ԫ����
		UnTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					UnField.setValue("");
					UnField.setRawValue("");
					UnitDs.load({
								params : {
									start : 0,
									limit : StratagemTabPagingToolbar.pageSize
								}
							});

				});


		// ���㵥Ԫ
		var UnitDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		UnitDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl + '?action=suunit&str='
										+ Ext.getCmp('UnField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchField').getValue()

										+ '&BonusUnitTypeID='
										+ Ext.getCmp('UnTypeField').getValue(),
								method : 'POST'
							})
				});

		var UnField = new Ext.form.ComboBox({
					id : 'UnField',
					fieldLabel : '���㵥Ԫ',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (UnField.getValue() != "") {
									TarField.focus();
								} else {
									Handler = function() {
										TarField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���㵥Ԫ����Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		// ����ָ��
		var TargetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		TargetDs.on('beforeload', function(ds, o) {

					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl + '?action=stunit&str='
										+ Ext.getCmp('TarField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchField').getValue(),
								method : 'POST'
							})
				});

		var TarField = new Ext.form.ComboBox({
					id : 'TarField',
					fieldLabel : '����ָ��',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : TargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'TarField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (TarField.getValue() != "") {
									TargetUnitField.focus();
								} else {
									Handler = function() {
										TargetUnitField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '����ָ�겻��Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		// ������ָ������
		SchField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			TarField.setValue("");
			TarField.setRawValue("");
			TargetDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
				// unitdeptDs.load({params:{start:0,
				// limit:StratagemTabPagingToolbar.pageSize}});
			});

		function searchFun(BonusSchemeID) {
			TargetDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/targetcalculateparamexe.csp?action=stunit&str='
								+ Ext.getCmp('TarField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchField').getValue(),
						method : 'POST'
					});
			TargetDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};

		// ������λ
		var CalDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		CalDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl
										+ '?action=calunit&str='
										+ Ext.getCmp('TargetUnitField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var TargetUnitField = new Ext.form.ComboBox({
					id : 'TargetUnitField',
					fieldLabel : '������λ',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : CalDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'TargetUnitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (TargetUnitField.getValue() != "") {
									AccountBaseField.focus();
								} else {
									Handler = function() {
										AccountBaseField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '������λ����Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// ���㷽��
		var DirectDs = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '����'], ['-1', '����']]
				});
		var TargetDirectionField = new Ext.form.ComboBox({
					id : 'TargetDirectionField',
					fieldLabel : '���㷽��',
					width : 180,
					listWidth : 180,
					selectOnFocus : true,
					allowBlank : false,
					store : DirectDs,
					// anchor: '90%',
					value : '', // Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : false,
					pageSize : 10,
					hidden:true,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// ����ϵ��
		var TargetRateField = new Ext.form.TextField({
					id : 'TargetRateField',
					fieldLabel : '����ϵ��',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
					// anchor: '90%',
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
					labelWidth : 100,
					items : [SchField, UnTypeField, UnField, TarField,
							TargetUnitField, //TargetDirectionField,
							TargetRateField]
				});

		// ��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// ������Ӱ�ť��Ӧ����
		addHandler = function() {
			var BonusSchemeID = Ext.getCmp('SchField').getValue();
			// alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UnField').getValue();
			var TargetID = Ext.getCmp('TarField').getValue();
			var TargetUnit = Ext.getCmp('TargetUnitField').getValue();
			var TargetDirection ='1' //Ext.getCmp('TargetDirectionField').getValue();
			var TargetRate = Ext.getCmp('TargetRateField').getValue();
			var UnitTypeID= Ext.getCmp('UnTypeField').getValue();
			
			
			if (BonusSchemeID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '���𷽰�Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (UnitID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '���㵥ԪΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (TargetID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����ָ��Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (TargetUnit == "") {
				Ext.Msg.show({
							title : '����',
							msg : '������λΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var data = UnitID.trim() + "^" + TargetID.trim() + "^"
					+ TargetUnit.trim() + "^" + TargetDirection.trim() + "^"
					+ TargetRate.trim() + "^" + BonusSchemeID.trim()
					+ "^" + UnitTypeID.trim();
					
			//prompt('',data);

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.targetcalculateparamexe.csp?action=add&data='
						+ data,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						TarField.focus();
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
				
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
										
					}
					else if(jsonData.info=='RepScheme')
						{
						Ext.Msg.show({title:'����',msg:'�÷������Ѵ��ڸõ�Ԫ��ָ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
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
					title : '��Ӳ���ָ��',
					width : 400,
					height : 400,
					minWidth : 400,
					minHeight : 400,
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
});