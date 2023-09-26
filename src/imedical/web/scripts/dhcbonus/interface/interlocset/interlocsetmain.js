/**
 * name:tab of interlocset author:limingzhong Date:2010-11-10
 */

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// �������Դ
var InterLocSetTabUrl = 'dhc.bonus.interlocsetexe.csp';
var InterLocSetTabProxy = new Ext.data.HttpProxy({
			url : InterLocSetTabUrl + '?action=list'
		});
var InterLocSetTabDs = new Ext.data.Store({
	proxy : InterLocSetTabProxy,
	reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, ['rowid', 'order', 'code', 'name', 'shortcut', 'desc', 'active', 'typeID', 'typeName']),
	// turn on remote sorting
	remoteSort : true
});

// ����Ĭ�������ֶκ�������
InterLocSetTabDs.setDefaultSort('rowid', 'asc');

// ���ݿ�����ģ��
var InterLocSetTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : "���",
			dataIndex : 'order',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : '�ӿ��״���',
			dataIndex : 'code',
			width : 110,
			sortable : true
		}, {
			header : "�ӿ�������",
			dataIndex : 'name',
			width : 110,
			align : 'left',
			sortable : true
		}, {
			header : "�ӿ������",
			dataIndex : 'typeName',
			width : 110,
			align : 'left',
			sortable : true
		}, {
			header : "�ӿ�������",
			dataIndex : 'desc',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : '��Ч��־',
			width : 110,
			dataIndex : 'active',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}
		}]);

// ��ʼ��Ĭ��������
InterLocSetTabCm.defaultSortable = true;

// ��Ӱ�ť
var addInterLocSet = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���ά�����',
	iconCls : 'add',
	handler : function() {
		var orderField = new Ext.form.NumberField({
					id : 'orderField',
					fieldLabel : '˳��',
					allowBlank : false,
					emptyText : '',
					anchor : '90%',
					width : 220,
					listWidth : 220,
					selectOnFocus : true,
					allowNegative : false,
					allowDecimals : false,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (orderField.getValue() != "") {
									codeField.focus();
								} else {
									Handler = function() {
										orderField.focus();
									}
									Ext.Msg.show({
												title : '��ʾ',
												msg : '˳����Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var codeField = new Ext.form.TextField({
					id : 'codeField',
					fieldLabel : '����',
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
					fieldLabel : '����',
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
									descField.focus();
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

		var descField = new Ext.form.TextField({
					id : 'descField',
					fieldLabel : '����',
					allowBlank : true,
					width : 180,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		var locSetType = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '�������ݽӿ�'], ['2', '�������ݽӿ�'], ['3', '֧��������']]
				});

		var locSetTypeField = new Ext.form.ComboBox({
					id : 'locSetTypeField',
					fieldLabel : '���',
					width : 80,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : locSetType,
					anchor : '90%',
					value : '', // Ĭ��ֵ
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // ����ģʽ
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 60,
					items : [orderField, codeField, nameField, locSetTypeField,
							descField]
				});

		// ��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// ������Ӱ�ť��Ӧ����
		addHandler = function() {
			var order = orderField.getValue();
			var code = codeField.getValue();
			var name = nameField.getValue();
			var desc = descField.getValue();
			var typeID = locSetTypeField.getValue();
			
			code = trim(code);
			name = trim(name);
			if (code == "") {
				Ext.Msg.show({
							title : '����',
							msg : '�ӿ��״���Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '����',
							msg : '�ӿ�������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (typeID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '�ӿ������Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
						
			//
			//alert('dhc.bonus.interlocsetexe.csp?action=add&code=' + code+ '&name=' + name + '&order=' + order + '&desc=' + desc+ '&type=' + typeID);
			Ext.Ajax.request({
				url : 'dhc.bonus.interlocsetexe.csp?action=add&code=' + code+ '&name=' + name + '&order=' + order + '&desc=' + desc+ '&type=' + typeID,
						
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						codeField.focus();
					}
					Ext.Msg.show({title :'����',msg :'������������!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({title : 'ע��',msg : '��ӳɹ�!',icon : Ext.MessageBox.INFO,buttons : Ext.Msg.OK});
						InterLocSetTabDs.load({params : {start : 0,limit : InterLocSetTabPagingToolbar.pageSize}});
					} else if(jsonData.info == 'RepCode'){
							Ext.Msg.show({
										title : '����',
										msg : '�˽ӿ��״����Ѿ�����!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR});
					}else if (jsonData.info == 'RepName'){
							Ext.Msg.show({
										title : '����',
										msg : '�˽ӿ��������Ѿ�����!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR});
						}
				},
				scope : this
			});
		}

		// ��ӱ��水ť�ļ����¼�
		addButton.addListener('click', addHandler, false);

		// ��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ����ȡ����ť����Ӧ����
		cancelHandler = function() {
			addwin.close();
		}

		// ���ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ��ʼ������
		addwin = new Ext.Window({
					title : '��ӽӿ��׼�¼',
					width : 380,
					height : 220,
					minWidth : 380,
					minHeight : 220,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [addButton, cancelButton]
				});

		// ������ʾ
		addwin.show();
	}
});

edit = function() {
	// ���岢��ʼ���ж���
	var rowObj = InterLocSetTab.getSelections();
	// ���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if (len < 1) {
		Ext.Msg.show({
					title : 'ע��',
					msg : '��ѡ����Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		var rowid = rowObj[0].get("rowid");
	}

	var orderField = new Ext.form.NumberField({
				id : 'orderField',
				fieldLabel : '˳��',
				allowBlank : false,
				emptyText : '',
				anchor : '90%',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
				allowNegative : false,
				allowDecimals : false,
				name : 'order',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (orderField.getValue() != "") {
								codeField.focus();
							} else {
								Handler = function() {
									orderField.focus();
								}
								Ext.Msg.show({
											title : '��ʾ',
											msg : '˳����Ϊ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : '����',
				allowBlank : false,
				width : 150,
				listWidth : 150,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				name : 'code',
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
				fieldLabel : '����',
				allowBlank : false,
				width : 180,
				listWidth : 180,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				name : 'name',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (nameField.getValue() != "") {
								orderField.focus();
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

	var descField = new Ext.form.TextField({
				id : 'descField',
				fieldLabel : '����',
				allowBlank : true,
				width : 180,
				listWidth : 180,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				name : 'desc',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							activeField.focus();
						}
					}
				}
			});

	var activeField = new Ext.form.Checkbox({
				id : 'activeField',
				labelSeparator : '��Ч��־:',
				allowBlank : false,
				checked : (rowObj[0].data['active']) == 'Y' ? true : false,
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							editButton.focus();
						}
					}
				}
			});

	var locSetType = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['1', '�������ݽӿ�'], ['2', '�������ݽӿ�'], ['3', '֧��������']]
			});

	var locSetTypeEdit = new Ext.form.ComboBox({
				id : 'locSetTypeEdit',
				fieldLabel : '���',
				width : 80,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : locSetType,
				anchor : '90%',
				value : '', // Ĭ��ֵ
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				valueNotFoundText:rowObj[0].get("typeName"),
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	// ���岢��ʼ�����
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 60,
				items : [codeField, nameField, orderField, locSetTypeEdit,descField,
						 activeField]
			});

	// ������
	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				locSetTypeEdit.setValue(rowObj[0].get("typeID"));
					
			});

	// ���岢��ʼ�������޸İ�ť
	var editButton = new Ext.Toolbar.Button({
				text : '�����޸�'
			});

	// �����޸İ�ť��Ӧ����
	editHandler = function() {
		var order = orderField.getValue();
		var code = codeField.getValue();
		var name = nameField.getValue();
		var desc = descField.getValue();
		var type = locSetTypeEdit.getValue();
		var active = (activeField.getValue() == true) ? 'Y' : 'N';
		code = trim(code);
		name = trim(name);
		if (code == "") {
			Ext.Msg.show({
						title : '����',
						msg : '�ӿ��״���Ϊ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (name == "") {
			Ext.Msg.show({
						title : '����',
						msg : '�ӿ�������Ϊ��',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		Ext.Ajax.request({
			url : 'dhc.bonus.interlocsetexe.csp?action=edit&rowid=' + rowid
					+ '&code=' + code + '&name=' + name + '&order=' + order
					+ '&desc=' + desc + '&active=' + active+ '&type=' + type,
					
			waitMsg : '������...',
			failure : function(result, request) {
				Handler = function() {
					codeField.focus();
				}
				Ext.Msg.show({
							title : '����',
							msg : '������������!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR,
							fn : Handler
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '�޸ĳɹ�!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK
							});
					InterLocSetTabDs.load({
								params : {
									start : 0,
									limit : InterLocSetTabPagingToolbar.pageSize
								}
							});
					editwin.close();
				} else {
					if (jsonData.info == 'RepCode') {
						Handler = function() {
							codeField.focus();
						}
						Ext.Msg.show({
									title : '����',
									msg : '�ӿ��״����Ѿ�����!',
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
									title : '����',
									msg : '�ӿ��������Ѿ�����!',
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

	// ��ӱ����޸İ�ť�ļ����¼�
	editButton.addListener('click', editHandler, false);

	// ���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
				text : 'ȡ���޸�'
			});

	// ����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function() {
		editwin.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);

	// ���岢��ʼ������
	var editwin = new Ext.Window({
				title : '�޸Ľӿ��׼�¼',
				width : 380,
				height : 250,
				minWidth : 380,
				minHeight : 250,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [editButton, cancelButton]
			});

	// ������ʾ
	editwin.show();
}

// �޸İ�ť
var editInterLocSet = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸�ά�����',
			iconCls : 'add',
			handler : function() {
				edit();
			}
		});

// ɾ����ť
var delInterLocSet = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��ά�����',
	iconCls : 'add',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = InterLocSetTab.getSelections();
		// ���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		// �ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id) {
			if (id == "yes") {
				var active = rowObj[0].get("active");
				// �ж��Ƿ�����������,�����������ɾ��,������Ա�ɾ��
				if (active == "Y" || active == "Yes" || active == "y"
						|| active == "yes") {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��Ч����,������ɾ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
				} else {
					Ext.Ajax.request({
						url : 'dhc.bonus.interlocsetexe.csp?action=del&rowid='
								+ rowid,
						waitMsg : 'ɾ����...',
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
											msg : 'ɾ���ɹ�!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								InterLocSetTabDs.load({
									params : {
										start : 0,
										limit : InterLocSetTabPagingToolbar.pageSize
									}
								});
							} else {
								Ext.Msg.show({
											title : '����',
											msg : 'ɾ��ʧ��!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
						},
						scope : this
					});
				}
			} else {
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ��������¼��?', handler);
	}
});

// ��ʼ�������ֶ�
var InterLocSetSearchField = 'name';

// ����������
var InterLocSetFilterItem = new Ext.Toolbar.MenuButton({
			text : '������',
			tooltip : '�ؼ����������',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '�ӿ��״���',
									value : 'code',
									checked : false,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ӿ�������',
									value : 'name',
									checked : true,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								}), new Ext.menu.CheckItem({
									text : '�ӿ�������',
									value : 'desc',
									checked : false,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								})]
			}
		});

// ����������Ӧ����
function onInterLocSetItemCheck(item, checked) {
	if (checked) {
		InterLocSetSearchField = item.value;
		InterLocSetFilterItem.setText(item.text + ':');
	}
};

// ���Ұ�ť
var InterLocSetSearchBox = new Ext.form.TwinTriggerField({
			width : 180,
			trigger1Class : 'x-form-clear-trigger',
			trigger2Class : 'x-form-search-trigger',
			emptyText : '����...',
			listeners : {
				specialkey : {
					fn : function(field, e) {
						var key = e.getKey();
						if (e.ENTER === key) {
							this.onTrigger2Click();
						}
					}
				}
			},
			grid : this,
			onTrigger1Click : function() {
				if (this.getValue()) {
					this.setValue('');
					InterLocSetTabDs.proxy = new Ext.data.HttpProxy({
								url : InterLocSetTabUrl + '?action=list'
							});
					InterLocSetTabDs.load({
								params : {
									start : 0,
									limit : InterLocSetTabPagingToolbar.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					InterLocSetTabDs.proxy = new Ext.data.HttpProxy({
								url : InterLocSetTabUrl
										+ '?action=list&searchField='
										+ InterLocSetSearchField
										+ '&searchValue=' + this.getValue()
							});
					InterLocSetTabDs.load({
								params : {
									start : 0,
									limit : InterLocSetTabPagingToolbar.pageSize
								}
							});
				}
			}
		});

// ��ҳ������
var InterLocSetTabPagingToolbar = new Ext.PagingToolbar({
			store : InterLocSetTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼",
			buttons : ['-', InterLocSetFilterItem, '-', InterLocSetSearchBox]
		});

// ���
var InterLocSetTab = new Ext.grid.EditorGridPanel({
			title : '�ӿ���ά��',
			store : InterLocSetTabDs,
			cm : InterLocSetTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addInterLocSet, '-', editInterLocSet, '-', delInterLocSet],
			bbar : InterLocSetTabPagingToolbar
		});

// ����
InterLocSetTabDs.load({
			params : {
				start : 0,
				limit : InterLocSetTabPagingToolbar.pageSize
			}
		});
