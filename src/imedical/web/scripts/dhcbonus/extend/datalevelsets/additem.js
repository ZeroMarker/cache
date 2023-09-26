AddLocFun = function(dataStore, grid, pagingTool) {
	// alert(repdr+","+leaf);
	Ext.QuickTips.init();
	if (leaf) {
		Ext.Msg.show({
					title : '注意',
					msg : '您选择的数据,不能添加!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	if (repdr == "") {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择分类!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}

	var itemTypeDs2 = new Ext.data.Store({
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, ['rowid', 'code', 'name', 'shortcut', 'remark',
								'order', 'active'])
			});

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
				pageSize : 10,
				minChars : 1,
				mode : 'local', // 本地模式
				editable : false,
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
	var descField = new Ext.form.TextField({
		id:'descField',
		fieldLabel: '备注',
		selectOnFocus:true,
		allowBlank: false,
		name:'descField',
		emptyText:'备注...',
		anchor: '90%'
	});
	
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [itemType, items, orderField,remarkField]
			});

	function addRqs() {
		Ext.Ajax.request({
					url : deptLevelSetsUrl + '?action=addloc&itemDr='
							+ items.getValue() + '&itemTypeDr='
							+ itemType.getValue() + '&id=' + repdr + '&order='
							+ orderField.getValue() +'&remark='+ remarkField.getValue(),
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
										msg : '添加成功!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
							dataStore.load({
										params : {
											start : 0,
											limit : pagingTool.pageSize
										}
									});
							Ext.getCmp('detailReport').getNodeById(repdr)
									.reload();
							// window.close();
						} else {
							var message = jsonData.info;
							if (message == "roo")
								message = "数据不能添加此节点下!";
							else if (message == "RepOrder")
								message = "该序号已经存在!";
							// Ext.getCmp('detailReport').getNodeById(message).reload();
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
	}

	// define window and show it in desktop
	var window = new Ext.Window({
				title : '添加数据分层',
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
						if (formPanel.form.isValid()) {
							var tmpDept = items.getValue();
							var dataType = itemType.getValue();
							if (tmpDept == "") {
								Ext.Msg.show({
											title : '错误',
											msg : '请选择数据!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
								return;
							}
							Ext.Ajax.request({
										url : deptLevelSetsUrl
												+ '?action=checkexist&itemDr='
												+ items.getValue() + '&id='
												+ repdr+'&dataType='+dataType,
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
												addRqs();

											} else {
												var message = jsonData.info;
												Ext.MessageBox.confirm('',
														'数据已经存在，是否继续添加？',
														function(btn) {
															if (btn == "yes") {
																addRqs();

															}
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

};