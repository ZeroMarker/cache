/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var BonusSchemeTypeTabUrl = '../csp/dhc.bonus.bonusschemtypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// �������Դ

var BonusSchemeTypeTabProxy = new Ext.data.HttpProxy({
			url : BonusSchemeTypeTabUrl + '?action=list'
		});
var BonusSchemeTypeTabDs = new Ext.data.Store({
			proxy : BonusSchemeTypeTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name']),
			// turn on remote sorting IsDeptmentType,IsMedicalGroup,IsPersonType
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
BonusSchemeTypeTabDs.setDefaultSort('rowid', 'name');

// ���ݿ�����ģ��
var BonusSchemeTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '����������',
			dataIndex : 'code',
			width : 100,
			sortable : true
		}, {
			header : '�����������',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}
        ]);

// ��ʼ��Ĭ��������
BonusSchemeTypeTabCm.defaultSortable = true;

// ��ʼ�������ֶ�
var BonusSchemeTypeSearchField = 'name';

// ����������
var BonusSchemeTypeFilterItem = new Ext.Toolbar.MenuButton({
			text : '������',
			tooltip : '�ؼ����������',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '����',
									value : 'code',
									checked : false,
									group : 'BonusSchemeTypeFilter',
									checkHandler : onBonusSchemeTypeItemCheck
								}), new Ext.menu.CheckItem({
									text : '����',
									value : 'name',
									checked : true,
									group : 'BonusSchemeTypeFilter',
									checkHandler : onBonusSchemeTypeItemCheck
								})]
			}
		});

// ����������Ӧ����
function onBonusSchemeTypeItemCheck(item, checked) {
	if (checked) {
		BonusSchemeTypeSearchField = item.value;
		BonusSchemeTypeFilterItem.setText(item.text + ':');
	}
};

// ���Ұ�ť
var BonusSchemeTypeSearchBox = new Ext.form.TwinTriggerField({
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
					BonusSchemeTypeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusSchemeTypeTabUrl + '?action=list'
							});
					BonusSchemeTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusSchemeTypeTabPagingToolbar.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					BonusSchemeTypeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusSchemeTypeTabUrl
										+ '?action=list&searchField='
										+ BonusSchemeTypeSearchField
										+ '&searchValue=' + this.getValue()
							});
					BonusSchemeTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusSchemeTypeTabPagingToolbar.pageSize
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
					fieldLabel : '����������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '����������...',
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
												msg : '���������벻��Ϊ��!',
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
					fieldLabel : '�����������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '�����������...',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (nField.getValue() != "") {
									DeptmentType.focus();
								} else {
									Handler = function() {
										nField.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '����������Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField]
				});

		// ��ʼ�����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// �������Ӱ�ť��Ӧ����
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			code = trim(code);
			name = trim(name);


			// alert("code "+code+"name "+name+"IsDeptmentType
			// "+IsDeptmentType+"IsMedicalGroup "+IsMedicalGroup+"IsPersonType
			// "+IsPersonType+"isIncome "+isIncome+"isExpend "+isExpend);

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

			Ext.Ajax.request({
				url : BonusSchemeTypeTabUrl+'?action=add&code='+ code + '&name=' + name,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						nField.focus();
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

						BonusSchemeTypeTabDs.load({
									params : {
										start : 0,
										limit : BonusSchemeTypeTabPagingToolbar.pageSize
									}
								});
						// addwin.close();
					} else {
						var message="";
								if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
								if(jsonData.info=='RepName') message='����������Ѿ�����!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
					width : 300,
					height : 150,
					minWidth : 300,
					minHeight : 150,
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
		var rowObj = BonusSchemeTypeTab.getSelections();
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
					fieldLabel : '����������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '����������...',
					valueNotFoundText : rowObj[0].get("code"),
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
												msg : '���������벻��Ϊ��!',
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
					fieldLabel : '�����������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '�����������...',
					valueNotFoundText : rowObj[0].get("name"),
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (n1Field.getValue() != "") {
									DeptmentType1.focus();
								} else {
									Handler = function() {
										n1Field.focus();
									}
									Ext.Msg.show({
												title : '����',
												msg : '����������Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});


		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));

					

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


			 //alert(BonusSchemeTypeTabUrl+'?action=edit&rowid='+ rowid+ '&code='+ code+ '&name='+ name);
			
			Ext.Ajax.request({
				url : BonusSchemeTypeTabUrl+'?action=edit&rowid='+ rowid+ '&code='+ code+ '&name='+ name,
				waitMsg : '������...',
				failure : function(result, request) {
					Handler = function() {
						Expend1.focus();
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
						BonusSchemeTypeTabDs.load({
									params : {
										start : 0,
										limit : BonusSchemeTypeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message="";
								if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
								if(jsonData.info=='RepName') message='����������Ѿ�����!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
					width : 300,
					height : 150,
					minWidth : 300,
					minHeight : 150,
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
		var rowObj = BonusSchemeTypeTab.getSelections();
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
					url :BonusSchemeTypeTabUrl+ '?action=del&rowid='
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
							BonusSchemeTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusSchemeTypeTabPagingToolbar.pageSize
								}
							});

						} else if(jsonData.info=='RepSchemeType'){
						        Ext.Msg.show({
									title : 'ע��',
									msg : '��ɾ���ļ�¼�Ѿ������𷽰�����!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
									
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
var BonusSchemeTypeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusSchemeTypeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼",
			buttons : ['-', BonusSchemeTypeFilterItem, '-',
					BonusSchemeTypeSearchBox]

		});

// ����
var BonusSchemeTypeTab = new Ext.grid.EditorGridPanel({
			title : '���𷽰����',
			store : BonusSchemeTypeTabDs,
			cm : BonusSchemeTypeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, '-', editButton, '-', delButton],
			bbar : BonusSchemeTypeTabPagingToolbar
		});
BonusSchemeTypeTabDs.load({
			params : {
				start : 0,
				limit : BonusSchemeTypeTabPagingToolbar.pageSize
			}
		});