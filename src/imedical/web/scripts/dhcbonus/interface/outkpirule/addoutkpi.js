function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
addFun = function(locSetDr, outKpiDs, LocSetGrid, outKpiPagingToolbar) {
var rowObj = LocSetGrid.getSelections();
var schemeID= rowObj[0].get('rowid')
//alert(schemeID)

	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : 'ָ�����',
				allowBlank : false,
				width : 150,
				listWidth : 150,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (codeField.getValue() != "") {
								nameField.focus();
							} else {
								Handler = function() {
									codeField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '���벻��Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : 'ָ������',
				allowBlank : true,
				width : 180,
				listWidth : 180,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (nameField.getValue() != "") {
								addButton.focus();
							} else {
								Handler = function() {
									nameField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '���Ʋ���Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});
	var orderField = new Ext.form.NumberField({
				id : 'orderField',
				fieldLabel : 'ȡֵλ��',
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
							url : 'dhc.bonus.intermethodexe.csp?action=InterMethod&interLocSetDr='+schemeID,
							method : 'POST'
						})
			});

	var interMethodField = new Ext.form.ComboBox({
				id : 'interMethodField',
				fieldLabel : '�ӿڷ���',
				allowBlank : false,
				store : interMethodDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'interMethodField',
				minChars : 1,
				// mode : 'local', // ����ģʽ
				pageSize : 10,
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [codeField, nameField,interMethodField,orderField]
			});

	var addButton = new Ext.Toolbar.Button({
				text : '���'
			});

	// ��Ӵ�����
	var addHandler = function() {
		var code = Ext.getCmp('codeField').getValue();
		var name = Ext.getCmp('nameField').getValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();
		var order = Ext.getCmp('orderField').getValue();
		
		code = trim(code);
		name = trim(name);
		if (code == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '����Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		};
		if (name == "") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '����Ϊ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		};

		Ext.Ajax.request({
					url : 'dhc.bonus.outkpiruleexe.csp?action=add&locSetDr='
							+ locSetDr + '&code=' + code + '&name=' + (name)
							+ '&interMethodDr=' + interMethodDr+ '&order=' + order,
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
							outKpiDs.load({
										params : {
											start : 0,
											limit : outKpiPagingToolbar.pageSize,
											locSetDr : locSetDr,
											dir : 'asc',
											sort : 'rowid'
										}
									});
						} else {
							if (jsonData.info == 'RepRecode') {
								Handler = function() {
									codeField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '���ݼ�¼�ظ�!',
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
				title : '��ӽ���ָ��',
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
				buttons : [addButton, cancelButton]
			});
	win.show();
}