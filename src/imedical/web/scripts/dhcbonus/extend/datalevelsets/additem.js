AddLocFun = function(dataStore, grid, pagingTool) {
	// alert(repdr+","+leaf);
	Ext.QuickTips.init();
	if (leaf) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ�������,�������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}
	if (repdr == "") {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ�����!',
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
				pageSize : 10,
				minChars : 1,
				mode : 'local', // ����ģʽ
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
	var descField = new Ext.form.TextField({
		id:'descField',
		fieldLabel: '��ע',
		selectOnFocus:true,
		allowBlank: false,
		name:'descField',
		emptyText:'��ע...',
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
							Ext.getCmp('detailReport').getNodeById(repdr)
									.reload();
							// window.close();
						} else {
							var message = jsonData.info;
							if (message == "roo")
								message = "���ݲ�����Ӵ˽ڵ���!";
							else if (message == "RepOrder")
								message = "������Ѿ�����!";
							// Ext.getCmp('detailReport').getNodeById(message).reload();
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
	}

	// define window and show it in desktop
	var window = new Ext.Window({
				title : '������ݷֲ�',
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
						if (formPanel.form.isValid()) {
							var tmpDept = items.getValue();
							var dataType = itemType.getValue();
							if (tmpDept == "") {
								Ext.Msg.show({
											title : '����',
											msg : '��ѡ������!',
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
												addRqs();

											} else {
												var message = jsonData.info;
												Ext.MessageBox.confirm('',
														'�����Ѿ����ڣ��Ƿ������ӣ�',
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