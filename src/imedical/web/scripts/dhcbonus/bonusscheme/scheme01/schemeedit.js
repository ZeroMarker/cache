schemeEditFun = function() {
	var rowObj = schemeMain.getSelectionModel().getSelections();
	var len = rowObj.length;
	var tmpRowid = "";

	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的数据!',
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
				fieldLabel : '方案代码',
				allowBlank : false,
				emptyText : '必填',
				anchor : '100%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				name : 'name',
				fieldLabel : '方案名称',
				allowBlank : false,
				emptyText : '必填',
				anchor : '100%'
			});

	var descField = new Ext.form.TextField({
				id : 'descField',
				name : 'desc',
				fieldLabel : '方案描述',
				emptyText : '',
				anchor : '100%'
			});
	var priorityEdit = new Ext.form.TextField({
				id : 'priorityEdit',
				name : 'desc',
				fieldLabel : '优先级',
				emptyText : '',
				anchor : '100%'
			});

	var schemeTypeCombo = new Ext.form.ComboBox({
				fieldLabel : '方案类别',
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
				emptyText : '必选',
				selectOnFocus : true,
				anchor : '100%'
			});
	
	var calStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [[1,'独立核算'],[2,'混合核算']]
		});
		var calField = new Ext.form.ComboBox({
			id: 'calField',
			fieldLabel: '核算标识',

			selectOnFocus: true,
			//allowBlank: false,
			store: calStore,
			anchor: '100%',

			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择标志...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});
	

	// if(rowObj[0].get("schemeState")==1)
	// {
	// Ext.Msg.show({title:'注意',msg:'已审核,不能修改!',buttons:
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
		title : '修改',
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
			text : '保存',
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
						waitMsg : '保存中...',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '注意',
											msg : '操作成功!',
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
									tmpmsg = '编码重复!';
								}
								Ext.Msg.show({
											title : '错误',
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
								title : '错误',
								msg : '请修正页面提示的错误!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				editWin.close();
			}
		}]
	});

	editWin.show();
};