// ��Ӻ���
addFun = function(node) {
	if (node != null) {
		var end = node.attributes.IsLast;
		if (end == 1) {
			Ext.Msg.show({
						title : '��ʾ',
						msg : 'ĩ�˲�������ӽڵ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// ��ĩ�˽ڵ�,�������

			var codeField = new Ext.form.TextField({
						id : 'codeField',
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
									nameField.focus();
								}
							}
						}
					});

			var nameField = new Ext.form.TextField({
						id : 'nameField',
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
									if (nameField.getValue() != "") {
										CMI.focus();
									} else {
										Handler = function() {
											nameField.focus();
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

		var CMI = new Ext.form.TextField({
						id : 'CMI',
						fieldLabel : 'CMIֵ',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (CMI.getValue() != "") {
										CostRate.focus();
									} else {
										Handler = function() {
											CMI.focus();
										}
										Ext.Msg.show({
													title : '����',
													msg : 'CMIֵ����Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
		   //����ϵ��
			var CostRate = new Ext.form.TextField({
						id : 'CostRate',
						fieldLabel : '����ϵ��',
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
													msg : '����ϵ������Ϊ��!',
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
						items : [codeField, nameField,CMI,CostRate,isEndField]
					});

			// ������Ӱ�ť
			var addButton = new Ext.Toolbar.Button({
						text : '���'
					});

			// ��Ӵ�����
			var addHandler = function() {
				var code = codeField.getValue();
				var name = nameField.getValue();
                var cmi  = CMI.getValue();
				var rate = CostRate.getValue();
				var isEnd = (isEndField.getValue() == true) ? '1' : '0';
				var parent = 0;
				if (node.attributes.id != "roo") {
					parent = node.attributes.id;
				}
				name = trim(name);
				code = trim(code);
				if (code == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '��Ŀ��Ϊ��!',
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

				if (cmi == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : 'cmiΪ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (rate == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '����ϵ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				var data = code+"^"+name+"^"+cmi+"^"+rate+"^"+isEnd+"^"+parent;
				var url = '../csp/dhc.bonus.drgsitemexe.csp?action=add&data='+ data;

				Ext.Ajax.request({
							url : Ext.util.Format.htmlDecode(url),
							waitMsg : '�����..',
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
												msg : '��ӳɹ�!',
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
													msg : '����ǰ��ӹ���������,û���ϼ��ڵ�ID!',
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

			// ��Ӱ�ť����Ӧ�¼�
			addButton.addListener('click', addHandler, false);

			// ����ȡ����ť
			var cancelButton = new Ext.Toolbar.Button({
						text : 'ȡ��'
					});

			// ȡ��������
			var cancelHandler = function() {
				win.close();
			}

			// ȡ����ť����Ӧ�¼�
			cancelButton.addListener('click', cancelHandler, false);

			var win = new Ext.Window({
						title : '��ӽ���Ԫ��¼',
						width : 395,
						height : 255,
						minWidth : 395,
						minHeight : 255,
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
					msg : '��ѡ��Ҫ����ӽڵ�ļ�¼��',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
	}
};