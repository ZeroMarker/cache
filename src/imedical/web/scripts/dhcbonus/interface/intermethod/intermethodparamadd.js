addMethodParamFun = function(dataStore, grid, pagingTool) {


	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ��ӵĽӿڷ���!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}

	if (interLocSetField.getValue() == "") {
		Ext.Msg.show({
					title : '��ʾ',
					msg : '��ѡ��ӿ���',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
		return false;
	}
	var methodParamDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['code', 'name'])
			});

	methodParamDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : InterLocUrl + '?action=InterParam',
							method : 'POST'
						})
			});

	var methodParamField = new Ext.form.ComboBox({
				id : 'methodParamField',
				fieldLabel : '��������',
				allowBlank : false,
				store : methodParamDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'methodParamField',
				minChars : 1,
				// mode : 'local', // ����ģʽ
				pageSize : 10,
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var paramOrderField = new Ext.form.TextField({
				id : 'paramOrderField',
				fieldLabel : '˳���',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var defalutValueField = new Ext.form.TextField({
				id : 'defalutValueField',
				fieldLabel : 'Ĭ��ֵ',
				allowBlank : true,
				emptyText : '',
				disableKeyFilter :true, 
				anchor : '90%'
			});
	var paramDescField = new Ext.form.TextField({
				id : 'paramDescField',
				fieldLabel : '��ʽ˵��',
				allowBlank : true,
				disabled : true,
				emptyText : '',
				anchor : '90%'
			});

	var paramDesc = new Ext.form.Label({
				id : 'paramDesc',
				name : 'paramDesc',
				text : '��ʽ˵����'
			})
	methodParamField.on('select', function(combo, record, index) {
				// ���
				if (combo.getValue() == '101') {
					paramDescField.setValue('�� 2011')
					return;
				}
				// �����ڼ�
				if (combo.getValue() == '102') {
					paramDescField.setValue('�£�M01�����ȣ�Q01�����꣺H01����ȣ�Y01')
					return;
				}
				// ��ʼʱ��
				if (combo.getValue() == '103') {
					paramDescField.setValue('xxxx��xx��xx��')
					return;
				}
				// ����ʱ��
				if (combo.getValue() == '104') {
					paramDescField.setValue('xxxx��xx��xx��')
					return;
				}
				// �̶�����
				if (combo.getValue() == '105') {
					paramDescField.setValue('���ұ���1^���ұ���2^���ұ���3...')
					return;
				}
				// ��������
				if (combo.getValue() == '106') {
					paramDescField.setValue('��������1^��������2^��������3...')
					return;
				}// �̶���Ա
				if (combo.getValue() == '107') {
					paramDescField.setValue('��Ա����1^��Ա����2^��Ա����3...')
					return;
				}// ������Ա
				if (combo.getValue() == '108') {
					paramDescField.setValue('��������1^��������2^��������3...')
					return;
				}// �̶�ָ��
				if (combo.getValue() == '109') {
					paramDescField.setValue('ָ�����1^ָ�����2^ָ�����3...')
					return;
				}// ����ָ��
				if (combo.getValue() == '110') {
					paramDescField.setValue('��������1^��������2^��������3...')
					return;
				}
			})
	// create form panel
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [paramOrderField, methodParamField, defalutValueField,
						paramDescField]
			});

	// define window and show it in desktop
	var window = new Ext.Window({
		title : '��ӽӿڷ�������',
		width : 380,
		height : 220,
		minWidth : 380,
		minHeight : 320,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '����',
			handler : function() {

				var methodParam = methodParamField.getValue();
				var paramOrder = paramOrderField.getValue();
				var defalutValue = defalutValueField.getValue();
				var interMethodDr = rowObj[0].get("rowid")

				defalutValue = defalutValue.trim();
				methodParam = methodParam.trim();
				paramOrder = paramOrder.trim();
				var data = interMethodDr + '~' + methodParam + '~'
						+ defalutValue + '~' + paramOrder;
				if (paramOrder == "") {
					Ext.Msg.show({
								title : '����',
								msg : '˳��Ų���Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (methodParam > 104) {

					if (defalutValue == "") {
						Ext.Msg.show({
									title : '����',
									msg : 'Ĭ��ֵ����Ϊ�գ�',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						return;
					};
				}

				if (methodParam == "") {
					Ext.Msg.show({
								title : '����',
								msg : '����ֵ����Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
								url : InterLocUrl + '?action=addParam&data='
										+ data,
								failure : function(result, request) {
									Ext.Msg.show({
												title : '��ʾ',
												msg : '����',
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
													msg : '��ӳɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dataStore.load({
													params : {
														start : 0,
														limit : pagingTool.pageSize
													}
												});
										// window.close();
									} else {
										var message = "";
										message = "SQLErr: " + jsonData.info;
										if (jsonData.info == 'EmptyRecData')
											message = '����Ϊ��!';
										if (jsonData.info == 'RepCode')
											message = '���벻���ظ�!';
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
				} else {
					Ext.Msg.show({
								title : '����',
								msg : '������ҳ����ʾ�Ĵ�����ύ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : 'ȡ��',
			handler : function() {
				window.close();
			}
		}]
	});

	window.show();
};