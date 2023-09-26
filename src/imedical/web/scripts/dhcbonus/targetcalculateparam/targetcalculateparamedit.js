// �޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text : '�޸�',
	tooltip : '�޸�',
	iconCls : 'add',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = StratagemTab.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
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
		} else if (len > 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ��һ����¼!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			// alert(state);
			if (state == "������") {
				Ext.Msg.show({
							title : 'ע��',
							msg : '�������ݷ����Ѿ������,���������޸�!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
			if (state == "confirm") {
				Ext.Msg.show({
							title : 'ע��',
							msg : '��ս�����´�,�������ٱ༭!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
		}
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
										+ Ext.getCmp('SchmeField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var SchmeField = new Ext.form.ComboBox({
					id : 'SchmeField',
					fieldLabel : '���𷽰�',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : SchemeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '��ѡ�񽱽𷽰�...',
					valueNotFoundText : rowObj[0].get("BonusSchemeName"),
					name : 'SchmeField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					// readOnly:false,
					disabled : true,
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (SchmeField.getValue() != "") {
									SchField.focus();
								} else {
									Handler = function() {
										workField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : 'Ŀ����벻��Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		SchmeField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			UField.setValue("");
			UField.setRawValue("");
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
				// unitdeptDs.load({params:{start:0,
				// limit:StratagemTabPagingToolbar.pageSize}});
			});

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

		var editUnTypeField = new Ext.form.ComboBox({
					id : 'editUnTypeField',
					fieldLabel : '��Ԫ���',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'editUnTypeField',
					valueNotFoundText : rowObj[0].get("UnitTypeName"),
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
		editUnTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());

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
								+ Ext.getCmp('UField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchmeField').getValue(),
						method : 'POST'
					});
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};
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
										+ Ext.getCmp('UField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchmeField').getValue()
										+ '&BonusUnitTypeID='
										+ Ext.getCmp('editUnTypeField').getValue(),
								method : 'POST'
							})
				});

		var UField = new Ext.form.ComboBox({
					id : 'UField',
					fieldLabel : '���㵥Ԫ',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '��ѡ����㵥Ԫ...',
					valueNotFoundText : rowObj[0].get("UnitName"),
					name : 'UField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
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
										+ Ext.getCmp('TargField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchmeField').getValue(),
								method : 'POST'
							})
				});

		var TargField = new Ext.form.ComboBox({
					id : 'TargField',
					fieldLabel : '����ָ��',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : TargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : rowObj[0].get("TargetName"),
					name : 'TargField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
				});
		// ������ָ������
		SchmeField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			TargField.setValue("");
			TargField.setRawValue("");
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
								+ Ext.getCmp('TargField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchmeField').getValue(),
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
										+ Ext.getCmp('TargetUField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var TargetUField = new Ext.form.ComboBox({
					id : 'TargetUField',
					fieldLabel : '������λ',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : CalDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : rowObj[0].get("TargetUnitName"),
					name : 'TargetUField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
				});

		// ���㷽��
		var DirectDs = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '����'], ['-1', '����']]
				});
		var DirectionField = new Ext.form.ComboBox({
					id : 'DirectionField',
					fieldLabel : '���㷽��',
					width : 180,
					listWidth : 180,
					selectOnFocus : true,
					allowBlank : false,
					store : DirectDs,
					value : '1', // Ĭ��ֵ
					valueNotFoundText : '����',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '.',
					name : 'TargetDirection',
					mode : 'local', // ����ģʽ
					editable : false,
					pageSize : 10,
					minChars : 1,
					hidden:true,
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
		var RateField = new Ext.form.TextField({
					id : 'RateField',
					fieldLabel : '����ϵ��',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '����ϵ��...',
					// anchor: '90%',
					selectOnFocus : 'true',
					name : 'TargetRate',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [SchmeField, editUnTypeField, UField, TargField,
							TargetUField, RateField]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {

					var sTargetDirection = rowObj[0].get("TargetDirection")
					this.getForm().loadRecord(rowObj[0]);
					SchmeField.setValue(rowObj[0].get("BonusSchemeID"));
					UField.setValue(rowObj[0].get("UnitID"));
					TargField.setValue(rowObj[0].get("TargetID"));
					TargetUField.setValue(rowObj[0].get("TargetUnit"));
					editUnTypeField.setValue(rowObj[0].get("UnitTypeID"));

					// alert(rowObj[0].get("UnitTypeID"))

					var a = rowObj[0].get("ParameterTarget");
					DirectionField.setValue("1");
					
//					if (sTargetDirection == "����") {
//						DirectionField.setValue("1");
//					} else {
//						DirectionField.setValue("-1");
//					}

				});

		// ���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
					text : '�����޸�'
				});

		// �����޸İ�ť��Ӧ����
		editHandler = function() {
			var BonusSchemeID = Ext.getCmp('SchmeField').getValue();
			// alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UField').getValue();
			var TargetID = Ext.getCmp('TargField').getValue();
			var TargetUnit = Ext.getCmp('TargetUField').getValue();
			
			var TargetDirection = '1' //Ext.getCmp('DirectionField').getValue();
			var TargetRate = Ext.getCmp('RateField').getValue();
			var TargetRate = Ext.getCmp('RateField').getValue();
			var editUnType = Ext.getCmp('editUnTypeField').getValue(); 
			
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
					+ TargetRate.trim() + "^" + BonusSchemeID.trim()+ "^" + editUnType.trim();
					
			//prompt('',rowid + '&data=' + data)		
			// alert(data);
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.targetcalculateparamexe.csp?action=edit&rowid='
						+ rowid + '&data=' + data,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						codeField.focus();
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
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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

		// ��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click', editHandler, false);

		// ���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ���޸�'
				});

		// ����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function() {
			editwin.close();
		}

		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ���岢��ʼ������
		var editwin = new Ext.Window({
					title : '�޸Ĳ���ָ��',
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
					buttons : [editButton, cancelButton]
				});

		// ������ʾ
		editwin.show();
	}
});
