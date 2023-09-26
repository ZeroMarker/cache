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
					title : '注意',
					msg : '请选择需要修改的数据!',
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
				data : [['1', '奖金指标'], ['2', '奖金项目'], ['3', '辅助收入'],
						['4', '辅助支出'], ['5', '辅助工作量']]
			});

	var itemType = new Ext.form.ComboBox({
				id : 'itemType',
				fieldLabel : '数据类别',
				anchor : '90%',
				listWidth : 260,
				allowBlank : false,
				store : itemTypeDs,
				valueField : 'rowid',
				displayField : 'shortcut',
				triggerAction : 'all',
				emptyText : '选择数据类别...',
				mode : 'local', // 本地模式
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
						});// 刷新
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
				fieldLabel : '数据',
				anchor : '90%',
				listWidth : 260,
				allowBlank : false,
				store : itemsDs,
				valueField : 'rowid',
				displayField : 'itemName',
				triggerAction : 'all',
				emptyText : '选择数据...',
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
				fieldLabel : '顺序',
				selectOnFocus : true,
				allowBlank : false,
				name : 'order',
				emptyText : '顺序...',
				anchor : '90%'
			});
	var remarkField = new Ext.form.TextField({
				id : 'remarkField',
				fieldLabel : '备注',
				selectOnFocus : true,
				allowBlank : false,
				name : 'remarkField',
				emptyText : '备注...',
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
		title : '修改数据',
		width : 400,
		height : 200,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			id : "saveButton",
			handler : function() {
				// check form value
				if (formPanel.form.isValid()) {
					var tmpDept = items.getValue();
					if (tmpDept == "") {
						Ext.Msg.show({
									title : '错误',
									msg : '请选择数据!',
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
													msg : '修改成功!',
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
											message = "数据不能添加此节点下!"
										else
											message = "数据顺序号重复!";
										Ext.Msg.show({
													title : '错误',
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
								title : '错误',
								msg : '请修正页面提示的错误后提交。',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				window.close();
			}
		}]
	});
	window.show();
	itemType.setValue(itemTypeName);
	items.setValue(itemName);

};