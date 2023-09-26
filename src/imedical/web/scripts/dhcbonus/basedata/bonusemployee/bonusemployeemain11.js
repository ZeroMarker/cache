/**
 * name:tab of database author:liuyang Date:2011-1-24
 */

var BonusEmployeeTabUrl = '../csp/dhc.bonus.bonusemployeeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// �������Դ

var BonusEmployeeTabProxy = new Ext.data.HttpProxy({
			url : BonusEmployeeTabUrl + '?action=list'
		});
var BonusEmployeeTabDs = new Ext.data.Store({
			proxy : BonusEmployeeTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name', 'unitDr', 'unitName', 'valid']),
			// turn on remote sorting
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
BonusEmployeeTabDs.setDefaultSort('rowid', 'name');

// ���ݿ�����ģ��
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : 'Ա������',
			dataIndex : 'code',
			width : 100,
			sortable : true
		}, {
			header : 'Ա������',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}, {
			header : '�������㵥Ԫ',
			dataIndex : 'unitName',
			width : 200,
			sortable : true
		}

]);

// ��ʼ��Ĭ��������
BonusEmployeeTabCm.defaultSortable = true;

// ��ʼ�������ֶ�
var BonusEmployeeSearchField = 'name';

// ����������
var BonusEmployeeFilterItem = new Ext.Toolbar.MenuButton({
			text : '������',
			tooltip : '�ؼ����������',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '����',
									value : 'code',
									checked : false,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								}), new Ext.menu.CheckItem({
									text : '����',
									value : 'name',
									checked : true,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								})]
			}
		});

// ����������Ӧ����
function onBonusEmployeeItemCheck(item, checked) {
	if (checked) {
		BonusEmployeeSearchField = item.value;
		BonusEmployeeFilterItem.setText(item.text + ':');
	}
};

// ���Ұ�ť
var BonusEmployeeSearchBox = new Ext.form.TwinTriggerField({
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
					BonusEmployeeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusEmployeeTabUrl + '?action=list'
							});
					BonusEmployeeTabDs.load({
								params : {
									start : 0,
									limit : BonusEmployeeTabPagingToolbar.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					BonusEmployeeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusEmployeeTabUrl
										+ '?action=list&searchField='
										+ BonusEmployeeSearchField
										+ '&searchValue=' + this.getValue()
							});
					BonusEmployeeTabDs.load({
								params : {
									start : 0,
									limit : BonusEmployeeTabPagingToolbar.pageSize
								}
							});
				}
			}
		});

// ���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '����',
	tooltip : '����',
	iconCls : 'add',
	handler : function() {

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (cField.getValue() != "") {
									nField.focus();
								} else {
									Handler = function() {
										cField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���벻��Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var nField = new Ext.form.TextField({
					id : 'nField',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (nField.getValue() != "") {
									unitField.focus();
								} else {
									Handler = function() {
										nField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var unitDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		unitDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=unit&str='
								+ Ext.getCmp('unitField').getRawValue(),
						method : 'POST'
					})
		});

		var unitField = new Ext.form.ComboBox({
					id : 'unitField',
					fieldLabel : '�������㵥Ԫ',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'unitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField, unitField]
				});

		// ��ʼ�����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// �������Ӱ�ť��Ӧ����
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var unitdr = unitField.getValue();

			code = trim(code);
			name = trim(name);

			if (code == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (unitdr == "") {
				Ext.Msg.show({
							title : '����',
							msg : '���㵥ԪΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			
			//alert((name))
			//encodeURIComponent
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=add&code='
						+ code + '&name=' + (name) + '&unitdr=' + unitdr,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						unitField.focus();
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
						Handler = function() {
							nField.focus();
						}
						Ext.Msg.show({
									title : 'ע��',
									msg : '���ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						BonusEmployeeTabDs.load({
									params : {
										start : 0,
										limit : BonusEmployeeTabPagingToolbar.pageSize
									}
								});
						//addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';

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

		// ���ӱ��水ť�ļ����¼�
		addButton.addListener('click', addHandler, false);

		// ��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

		// ����ȡ����ť����Ӧ����
		cancelHandler = function() {
			addwin.close();
		}

		// ����ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ��ʼ������
		addwin = new Ext.Window({
					title : '���Ӽ�¼',
					width : 400,
					height : 300,
					minWidth : 400,
					minHeight : 300,
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

// �޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text : '�޸�',
	tooltip : '�޸�',
	iconCls : 'option',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = BonusEmployeeTab.getSelections();
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

		var c1Field = new Ext.form.TextField({
					id : 'c1Field',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("code"),
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (c1Field.getValue() != "") {
									n1Field.focus();
								} else {
									Handler = function() {
										c1Field.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���벻��Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var n1Field = new Ext.form.TextField({
					id : 'n1Field',
					fieldLabel : '����',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("name"),
					emptyText : '����...',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (n1Field.getValue() != "") {
									unit1Field.focus();
								} else {
									Handler = function() {
										n1Field.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '���Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var unit1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		unit1Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=unit&str='
								+ Ext.getCmp('unit1Field').getRawValue(),
						method : 'POST'
					})
		});

		var unit1Field = new Ext.form.ComboBox({
					id : 'unit1Field',
					fieldLabel : '�������㵥Ԫ',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unit1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get("unitName"),
					triggerAction : 'all',
					emptyText : '��ѡ�������㵥Ԫ...',
					name : 'unit1Field',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',

					editable : true,

					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								editButton.focus();
							}
						}
					}
				});

		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, unit1Field]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));
					unit1Field.setValue(rowObj[0].get("unitDr"));
				});

		// ���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
					text : '�����޸�'
				});

		// �����޸İ�ť��Ӧ����
		editHandler = function() {

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = trim(name);

			if (code == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����Ϊ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var unitdr = unit1Field.getValue();
		alert('../csp/dhc.bonus.bonusemployeeexe.csp?action=edit&rowid='
						+ rowid
						+ '&code='
						+ code
						+ '&name='
						+ (name)
						+ '&unitdr=' + unitdr)
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=edit&rowid='
						+ rowid
						+ '&code='
						+ code
						+ '&name='
						+ name
						+ '&unitdr=' + unitdr,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
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
									title : 'ע��',
									msg : '�޸ĳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK
								});
						BonusEmployeeTabDs.load({
									params : {
										start : 0,
										limit : BonusEmployeeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����Ĵ����Ѿ�����!';

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

		// ���ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click', editHandler, false);

		// ���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ���޸�'
				});

		// ����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function() {
			editwin.close();
		}

		// ����ȡ����ť�ļ����¼�
		cancelButton.addListener('click', cancelHandler, false);

		// ���岢��ʼ������
		var editwin = new Ext.Window({
					title : '�޸ļ�¼',
					width : 400,
					height : 300,
					minWidth : 400,
					minHeight : 300,
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
});

// ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		// ���岢��ʼ���ж���
		var rowObj = BonusEmployeeTab.getSelections();
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

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=del&rowid='
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
							BonusEmployeeTabDs.load({
								params : {
									start : 0,
									limit : BonusEmployeeTabPagingToolbar.pageSize
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

			} else {
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ��������¼��?', handler);
	}
});

// ��ҳ������
var BonusEmployeeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusEmployeeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼",
			buttons : ['-', BonusEmployeeFilterItem, '-',
					BonusEmployeeSearchBox]

		});

// ����
var BonusEmployeeTab = new Ext.grid.EditorGridPanel({
			title : '������Ա����',
			store : BonusEmployeeTabDs,
			cm : BonusEmployeeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, "-", editButton, "-", delButton],
			bbar : BonusEmployeeTabPagingToolbar
		});
BonusEmployeeTabDs.load({
			params : {
				start : 0,
				limit : BonusEmployeeTabPagingToolbar.pageSize
			}
		});