editLocFun = function(dataStore, grid, pagingTool) {
	Ext.QuickTips.init();
	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowid = "";
	var itemName = '';
	var itemTypeName = '';
	var itemDr = '';
	var itemTypeDr = '';

	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	rowid = rowObj[0].get("rowid");

	itemName = rowObj[0].get("itemName");
	itemTypeName = rowObj[0].get("itemTypeName");
	itemDr = rowObj[0].get("itemDr");
	itemTypeDr = rowObj[0].get("itemTypeDr");

	var itemTypeDs = new Ext.data.SimpleStore({
				fields : ['rowid', 'shortcut'],
				data : [['1', '����ָ��'], ['2', '������Ŀ'], ['3', '��������'],
						['4', '����֧��'], ['5', '����������']]
			});

	var itemType = new Ext.form.ComboBox({
				id : 'itemType',
				fieldLabel : '�������',
				anchor : '90%',
				listWidth : 260,
				allowBlank : false,
				store : itemTypeDs,
				valueField : 'rowid',
				displayField : 'shortcut',
				triggerAction : 'all',
				emptyText : 'ѡ���������...',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	itemTypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.datalevelsetsexe.csp?action=listitemtype&searchfield=shortcut&searchvalue='
					+ Ext.getCmp('itemType').getRawValue(),
			method : 'GET'
		});
	});

	itemType.on("select", function(cmb, rec, id) {
				items.setRawValue("");
				items.setValue("");
				itemTypeDr = cmb.getValue();
				itemsDs.load({
							params : {
								start : 0,
								limit : cmb.pageSize
							}
						});// ˢ��
			});

	var itemsDs = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'itemName'])
			});
	var items = new Ext.form.ComboBox({
				id : 'items',
				fieldLabel : '����',
				anchor : '90%',
				listWidth : 260,
				allowBlank : false,
				store : itemsDs,
				valueField : 'rowid',
				displayField : 'itemName',
				triggerAction : 'all',
				emptyText : 'ѡ������...',
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	items.on("select", function(cmb, rec, id) {
				itemDr = cmb.getValue();

			});

	itemsDs.on('beforeload', function(ds, o) {
							
		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.datalevelsetsexe.csp?action=listloc&dataType='
							+ itemType.getValue() + '&str=' + items.getValue(),
			method : 'GET'
		});
	});

	var orderField = new Ext.form.NumberField({
				id : 'orderField',
				fieldLabel : '˳��',
				selectOnFocus : true,
				allowBlank : false,
				name : 'order',
				emptyText : '˳��...',
				anchor : '90%'
			});
	var remarkField = new Ext.form.TextField({
				id : 'remarkField',
				fieldLabel : '��ע',
				selectOnFocus : true,
				allowBlank : false,
				name : 'remarkField',
				emptyText : '��ע...',
				anchor : '90%'
			});
	// create form panel
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [itemType, items, orderField,remarkField]
			});

	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				itemType.setValue(rowObj[0].get("hospDr"));
				items.setValue(rowObj[0].get("locDr"));
				remarkField.setValue(rowObj[0].get("remark"))
			});

	var window = new Ext.Window({
		title : '�޸�����',
		width : 400,
		height : 200,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '����',
			id : "saveButton",
			handler : function() {
				// check form value
				if (formPanel.form.isValid()) {
					var tmpDept = items.getValue();
					if (tmpDept == "") {
						Ext.Msg.show({
									title : '����',
									msg : '��ѡ������!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						return;
					}//remarkField
					Ext.Ajax.request({
								url : deptLevelSetsUrl
										+ '?action=editloc&itemTypeDr='
										+ itemTypeDr + '&itemDr=' + itemDr
										+ '&id=' + rowid + "&parRef=" + repdr
										+ '&order=' + orderField.getValue()
										+ '&remark=' + remarkField.getValue(),
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
										Ext.getCmp('detailReport')
												.getNodeById(repdr).reload();
										window.close();
									} else {
										var message = jsonData.info;
										if (message == "roo")
											message = "���ݲ�����Ӵ˽ڵ���!"
										else
											message = "����˳����ظ�!";
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
	itemType.setValue(itemTypeName);
	items.setValue(itemName);

};