editInterLocFun = function(dataStore, grid, pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵ���!',
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
	} else {
		myRowid = rowObj[0].get("rowid");
	}
	/*
	 * var jxUnitDs = new Ext.data.Store({ autoLoad:true, proxy:"", reader:new
	 * Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut'])
	 * });
	 * 
	 * jxUnitDs.on('beforeload', function(ds, o){ ds.proxy=new
	 * Ext.data.HttpProxy({ url:InterLocUrl+'?action=getjxunit',method:'POST'})
	 * });
	 */
	var returnStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['201', '��׼Global'], ['202', '��չGlobal'], ['203', '����Global'], ['204', '֧��������Global']]
			});
	var ReturnTypeEdit = new Ext.form.ComboBox({
				id : 'ReturnTypeEdit',
				fieldLabel : '��������',
				allowBlank : false,
				store : returnStore,
				valueField : 'key',
				displayField : 'keyValue',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get('ReturnTypeName'),
				// name: 'ReturnTypeEdit',
				minChars : 1,
				pageSize : 10,
				mode : 'local', // ����ģʽ
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var orderField = new Ext.form.TextField({
				id : 'orderField',
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
				name : 'code',
				anchor : '90%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '',
				name : 'name',
				anchor : '90%'
			});

	var returnEdit = new Ext.form.TextField({
				id : 'returnEdit',
				fieldLabel : '��ע˵��',
				emptyText : '',
				name : 'desc',
				anchor : '90%'
			});

	var tieOffField = new Ext.form.Checkbox({
				id : 'tieOffField',
				fieldLabel : '��Ч��־',
				disabled : false,
				allowBlank : false,
				checked : (rowObj[0].data['active']) == 'Y' ? true : false

			});
	var descField = new Ext.form.TextArea({
		id : 'descField',
		fieldLabel : '�ӿڸ�ʽ',
		allowBlank : false,
		height:200,
		emptyText : 'class(M������).�෽��(��ʼ���ڣ��������ڣ��ӿڷ���ID); //���ڸ�ʽ=YYYY-MM-DD',
		disabled : true,
		anchor : '90%'
	})
	/*
	ReturnTypeEdit.on('select', function(cmb, rd, index) {
				if (cmb.getValue() == "201") {
					descField.setValue('��Ԫ����^��Ԫ����^ָ�����^ָ������^ָ��ֵ')
					return;

				}
				if (cmb.getValue() == "202") {
					descField.setValue('��Ԫ����^��Ԫ����^ָ��ֵ1^ָ��ֵ2^ָ��ֵ3...^ָ��ֵn')
					return;

				}
				if (cmb.getValue() == "203") {
					descField.setValue('^dhcbsSubIncomeDactaTemp��"�Զ���ڵ�"��num�� =��Ŀ����^��Ŀ����^�������^�����ڼ�^�������ұ���^������������^ִ�п��ұ���^ִ�п�������^���˿��ұ���^���˿�������^����ҽ����^����ҽ����^����ҽʦ����^����ҽʦ����^ִ��ҽʦ����^ִ��ҽʦ����^�������^�������^��Ŀ���')
					return;

				}
				if (cmb.getValue() == "204") {
					descField.setValue('��Ԫ����^��Ԫ����^ָ��ֵ1^ָ��ֵ2^ָ��ֵ3...^ָ��ֵn')
					return;

				}
			}) */
	var flagPanel = new Ext.Panel({
				layout : 'column',
				border : false,
				// labelWidth: 80,
				baseCls : 'x-plain',
				defaults : {
					border : false,
					layout : 'form',
					baseCls : 'x-plain',
					// labelSeparator: ':',
					columnWidth : .3
				},
				items : [

				{
							items : tieOffField
						}]
			});

	// create form panel  ReturnTypeEdit,
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [

						orderField, codeField, nameField,
						returnEdit, tieOffField,descField

				]
			});
	formPanel.on('afterlayout', function(panel, layout) {

				codeField.setValue(rowObj[0].get("methodDesc"))
				nameField.setValue(rowObj[0].get("methodName"))
				ReturnTypeEdit.setValue(rowObj[0].get("ReturnType"));
	
				orderField.setValue(rowObj[0].get("Order"));
				returnEdit.setValue(rowObj[0].get("ReturnName"));
				//if(ReturnTypeEdit.getValue()==201){descField.setValue('��Ԫ����^��Ԫ����^ָ�����^ָ������^ָ��ֵ')}
				//if(ReturnTypeEdit.getValue()==202){descField.setValue('��Ԫ����^��Ԫ����^ָ��ֵ1^ָ��ֵ2^ָ��ֵ3...^ָ��ֵn')}
				//if(ReturnTypeEdit.getValue()==203){descField.setValue('^dhcbsSubIncomeDactaTemp��"�Զ���ڵ�"��num�� =��Ŀ����^��Ŀ����^�������^�����ڼ�^�������ұ���^������������^ִ�п��ұ���^ִ�п�������^���˿��ұ���^���˿�������^����ҽ����^����ҽ����^����ҽʦ����^����ҽʦ����^ִ��ҽʦ����^ִ��ҽʦ����^�������^�������^��Ŀ���')}
				//if(ReturnTypeEdit.getValue()==204){descField.setValue('��Ԫ����^��Ԫ����^ָ��ֵ1^ָ��ֵ2^ָ��ֵ3...^ָ��ֵn')}
			});


	var window = new Ext.Window({
		title : '�޸Ľӿ��׷���',
		width : 450,
		height : 320,
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
				// check form value
			
				var order = orderField.getValue();
				var code = codeField.getValue();
				var name = nameField.getValue();
				var ReturnType = Ext.getCmp('ReturnTypeEdit').getValue();
				var returnValue = returnEdit.getValue();
	
				var tieOff = (tieOffField.getValue() == true) ? 'Y' : 'N';

				code = code.trim();
				name = name.trim();
				returnValue = returnValue.trim();
				ReturnType = ReturnType.trim();
				order = order.trim();

				var data = (code) + '~' + (name) + '~' + order + '~' + ReturnType
						+ '~' + interLocSetField.getValue() + '~' + returnValue
						+ '~' + tieOff;
				//prompt('',data);
				if (order == "") {
					Ext.Msg.show({
								title : '����',
								msg : '˳��Ų���Ϊ��',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};		
				if (code == "") {
					Ext.Msg.show({
								title : '����',
								msg : '�������벻�ܿ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '����',
								msg : '�������Ʋ��ܿ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				/*if (ReturnType == "") {
					Ext.Msg.show({
								title : '����',
								msg : '�������Ͳ��ܿ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (returnValue == "") {
					Ext.Msg.show({
								title : '����',
								msg : '����ֵ���ܿ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				*/

				if (formPanel.form.isValid()) {
					
					Ext.Ajax.request({
								url : InterLocUrl + '?action=edit&data=' + data
										+ '&rowid=' + myRowid,
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
													title : 'ע��',
													msg : '�޸ĳɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dataStore.load({
													params : {
														start : pagingTool.cursor,
														limit : pagingTool.pageSize
													}
												});
										window.close();
									} else {
										var message = "";
										message = "SQLErr: " + jsonData.info;
										if (jsonData.info == 'RepOrder')
											message = '˳��Ų����ظ�!';
										if (jsonData.info == 'RepDesc')
											message = '�������Ʋ����ظ�!';
										if (jsonData.info == 'RepName')
											message = '�������������ظ�!';
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