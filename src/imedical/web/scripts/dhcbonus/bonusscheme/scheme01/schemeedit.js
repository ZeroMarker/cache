schemeEditFun = function() {
	var rowObj = schemeMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";

	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		tmpRowid = rowObj[0].get("rowid");
	}
	var codeField = new Ext.form.TextField({
				id : 'codeField',
				name : 'code',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '����',
				anchor : '100%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				name : 'name',
				fieldLabel : '��������',
				allowBlank : false,
				emptyText : '����',
				anchor : '100%'
			});

	var descField = new Ext.form.TextField({
				id : 'descField',
				name : 'desc',
				fieldLabel : '��������',
				emptyText : '',
				anchor : '100%'
			});
	var priorityEdit = new Ext.form.TextField({
				id : 'priorityEdit',
				name : 'desc',
				fieldLabel : '���ȼ�',
				emptyText : '',
				anchor : '100%'
			});

	var schemeTypeCombo = new Ext.form.ComboBox({
				fieldLabel : '�������',
				name : 'typeName',
				store : schemeTypeSt,
				displayField : 'name',
				allowBlank : false,
				valueField : 'rowid',
				valueNotFoundText : rowObj[0].get('SchemeTypeName'),
				// typeAhead: true,
				// mode: 'local',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '��ѡ',
				selectOnFocus : true,
				anchor : '100%'
			});
	
	var calStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [[1,'��������'],[2,'��Ϻ���']]
		});
		var calField = new Ext.form.ComboBox({
			id: 'calField',
			fieldLabel: '�����ʶ',

			selectOnFocus: true,
			//allowBlank: false,
			store: calStore,
			anchor: '100%',

			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ���־...',
			mode: 'local', //����ģʽ
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});
	

	// if(rowObj[0].get("schemeState")==1)
	// {
	// Ext.Msg.show({title:'ע��',msg:'�����,�����޸�!',buttons:
	// Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	// return;
	// }

	var formPanel = new Ext.form.FormPanel({
		baseCls : 'x-plain',
		labelWidth : 70,
		items : [codeField, nameField, descField, priorityEdit, schemeTypeCombo]
	});

	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				schemeTypeCombo.setValue(rowObj[0].get('SchemeTypeID'));
				priorityEdit.setValue(rowObj[0].get('Priority'));
				//calField.setValue(1);
				calField.setValue(rowObj[0].get('CalculateFlag'));
			});

	var editWin = new Ext.Window({
		title : '�޸�',
		width : 300,
		height : 250,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			id : 'saveButton',
			text : '����',
			handler : function() {
				if (formPanel.form.isValid()) {
					var tmpCreatePerson = session['LOGON.USERCODE'];

					tmpData = codeField.getValue().trim() + "^"
							+ nameField.getValue().trim() + "^"
							+ descField.getValue().trim() + "^"
							+ schemeTypeCombo.getValue() + "^"
							+ tmpCreatePerson + "^"
							+ rowObj[0].get("adjustPerson") + "^"
							+ rowObj[0].get("schemeState") + "^"
							+ rowObj[0].get("adjustDate") + "^"
							+ rowObj[0].get("auditingPerson") + "^"
							+ rowObj[0].get("auditingDate") + "^"
							+ rowObj[0].get("isValid")+ "^"
							+ priorityEdit.getValue()+"^"
							+ calField.getValue();    
							
							//
					Ext.Ajax.request({
						url : schemeUrl + '?action=schemeedit&data=' + tmpData
								+ '&rowid=' + tmpRowid,
						waitMsg : '������...',
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
											msg : '�����ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								schemeDs.load({
											params : {
												start : 0,
												limit : schemePagingToolbar.pageSize
											}
										});
								editWin.close();
							} else {
								var tmpmsg = '';
								if (jsonData.info == '1') {
									tmpmsg = '�����ظ�!';
								}
								Ext.Msg.show({
											title : '����',
											msg : tmpmsg,
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
								msg : '������ҳ����ʾ�Ĵ���!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : 'ȡ��',
			handler : function() {
				editWin.close();
			}
		}]
	});

	editWin.show();
};