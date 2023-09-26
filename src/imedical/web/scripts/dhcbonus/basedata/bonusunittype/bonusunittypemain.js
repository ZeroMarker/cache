/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var BonusUnitTypeTabUrl = '../csp/dhc.bonus.bonusunittypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// �������Դ

var BonusUnitTypeTabProxy = new Ext.data.HttpProxy({
			url : BonusUnitTypeTabUrl + '?action=list'
		});
var BonusUnitTypeTabDs = new Ext.data.Store({
			proxy : BonusUnitTypeTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name', 'IsDeptmentType',
							'IsMedicalGroup', 'IsPersonType', 'valid']),
			// turn on remote sorting IsDeptmentType,IsMedicalGroup,IsPersonType
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
BonusUnitTypeTabDs.setDefaultSort('rowid', 'name');

// ���ݿ�����ģ��
var BonusUnitTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '��Ԫ������',
			dataIndex : 'code',
			width : 100,
			sortable : true
		}, {
			header : '��Ԫ�������',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}, {
			header : '����Ӧ��',
			width : 100,
			dataIndex : 'IsDeptmentType',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}, {
			header : 'ҽ����Ӧ��',
			width : 100,
			dataIndex : 'IsMedicalGroup',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}, {
			header : '��ԱӦ��',
			width : 100,
			dataIndex : 'IsPersonType',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}]);

// ��ʼ��Ĭ��������
BonusUnitTypeTabCm.defaultSortable = true;

// ��ʼ�������ֶ�
var BonusUnitTypeSearchField = 'name';

// ����������
var BonusUnitTypeFilterItem = new Ext.Toolbar.MenuButton({
			text : '������',
			tooltip : '�ؼ����������',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '����',
									value : 'code',
									checked : false,
									group : 'BonusUnitTypeFilter',
									checkHandler : onBonusUnitTypeItemCheck
								}), new Ext.menu.CheckItem({
									text : '����',
									value : 'name',
									checked : true,
									group : 'BonusUnitTypeFilter',
									checkHandler : onBonusUnitTypeItemCheck
								})]
			}
		});

// ����������Ӧ����
function onBonusUnitTypeItemCheck(item, checked) {
	if (checked) {
		BonusUnitTypeSearchField = item.value;
		BonusUnitTypeFilterItem.setText(item.text + ':');
	}
};

// ���Ұ�ť
var BonusUnitTypeSearchBox = new Ext.form.TwinTriggerField({
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
					BonusUnitTypeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusUnitTypeTabUrl + '?action=list'
							});
					BonusUnitTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusUnitTypeTabPagingToolbar.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					BonusUnitTypeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusUnitTypeTabUrl
										+ '?action=list&searchField='
										+ BonusUnitTypeSearchField
										+ '&searchValue=' + this.getValue()
							});
					BonusUnitTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusUnitTypeTabPagingToolbar.pageSize
								}
							});
				}
			}
		});

// ��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function() {

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '���㵥Ԫ������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '���㵥Ԫ������...',
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
												msg : '���㵥Ԫ�����벻��Ϊ��!',
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
					fieldLabel : '���㵥Ԫ�������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '���㵥Ԫ�������...',
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
												msg : '���㵥Ԫ������Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		// IsDeptmentType,IsMedicalGroup,IsPersonType
		var DeptmentType = new Ext.form.Checkbox({
					id : 'DeptmentType',
					labelSeparator : '����Ӧ��:',
					allowBlank : false
				});
		var MedicalGroup = new Ext.form.Checkbox({
					id : 'MedicalGroup',
					labelSeparator : 'ҽ����Ӧ��:',
					allowBlank : false
				});
		var PersonType = new Ext.form.Checkbox({
					id : 'PersonType',
					labelSeparator : '��ԱӦ��:',
					allowBlank : false
				});

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField, DeptmentType, MedicalGroup,
							PersonType]
				});

		// ��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// ������Ӱ�ť��Ӧ����
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			code = trim(code);
			name = trim(name);

			var IsDeptmentType = (DeptmentType.getValue() == true) ? '1' : '0';
			var IsMedicalGroup = (MedicalGroup.getValue() == true) ? '1' : '0';
			var IsPersonType = (PersonType.getValue() == true) ? '1' : '0';

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
				url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=add&code='
						+ code + '&name=' + name + '&IsDeptmentType='
						+ IsDeptmentType + '&IsMedicalGroup=' + IsMedicalGroup
						+ '&IsPersonType=' + IsPersonType,
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
									msg : '��ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						BonusUnitTypeTabDs.load({
									params : {
										start : 0,
										limit : BonusUnitTypeTabPagingToolbar.pageSize
									}
								});
						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����ı����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
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
					title : '��Ӽ�¼',
					width : 400,
					height : 350,
					minWidth : 400,
					minHeight : 350,
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
		var rowObj = BonusUnitTypeTab.getSelections();
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
					fieldLabel : '��Ԫ������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '��Ԫ������...',
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
												msg : '���㵥Ԫ�����벻��Ϊ��!',
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
					fieldLabel : '��Ԫ�������',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '��Ԫ�������...',
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
												msg : '���㵥Ԫ������Ʋ���Ϊ��!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var DeptmentType1 = new Ext.form.Checkbox({
					id : 'DeptmentType1',
					labelSeparator : '����Ӧ��:',
					// checked: (rowObj[0].data['IsDeptmentType'])=1?true:false,
					allowBlank : false
				});
		var MedicalGroup1 = new Ext.form.Checkbox({
					id : 'MedicalGroup1',
					labelSeparator : 'ҽ����Ӧ��:',
					// checked: (rowObj[0].data['IsMedicalGroup'])=1?true:false,
					allowBlank : false
				});
		var PersonType1 = new Ext.form.Checkbox({
					id : 'PersonType1',
					labelSeparator : '��ԱӦ��:',
					// checked: (rowObj[0].data['IsPersonType'])=1?true:false,
					allowBlank : false
				});


		// ���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, DeptmentType1, MedicalGroup1,
							PersonType1

					]
				});

		// ������
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));

					DeptmentType1.setValue(rowObj[0].get("IsDeptmentType"));
					MedicalGroup1.setValue(rowObj[0].get("IsMedicalGroup"));
					PersonType1.setValue(rowObj[0].get("IsPersonType"));

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

			var IsDeptmentType = (DeptmentType1.getValue() == true) ? '1' : '0';
			var IsMedicalGroup = (MedicalGroup1.getValue() == true) ? '1' : '0';
			var IsPersonType = (PersonType1.getValue() == true) ? '1' : '0';

			// alert("code "+code+"name "+name+"IsDeptmentType
			// "+IsDeptmentType+"IsMedicalGroup "+IsMedicalGroup+"IsPersonType
			// "+IsPersonType+"isIncome "+isIncome+"isExpend "+isExpend);
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=edit&rowid='
						+ rowid
						+ '&code='
						+ code
						+ '&name='
						+ name
						+ '&IsDeptmentType='
						+ IsDeptmentType
						+ '&IsMedicalGroup='
						+ IsMedicalGroup
						+ '&IsPersonType=' + IsPersonType,
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
						BonusUnitTypeTabDs.load({
									params : {
										start : 0,
										limit : BonusUnitTypeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '����Ĵ����Ѿ�����!';
						if (jsonData.info == 'RepName')
							message = '����������Ѿ�����!';
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
					title : '�޸ļ�¼',
					width : 400,
					height : 350,
					minWidth : 400,
					minHeight : 350,
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
		var rowObj = BonusUnitTypeTab.getSelections();
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
					url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=del&rowid='
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
							BonusUnitTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusUnitTypeTabPagingToolbar.pageSize
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
var BonusUnitTypeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusUnitTypeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '�� {0} ���� {1}�� ��һ�� {2} ��',
			emptyMsg : "û�м�¼",
			buttons : ['-', BonusUnitTypeFilterItem, '-',
					BonusUnitTypeSearchBox]

		});

// ���
var BonusUnitTypeTab = new Ext.grid.EditorGridPanel({
			title : '���㵥Ԫ���',
			store : BonusUnitTypeTabDs,
			cm : BonusUnitTypeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, '-', editButton, '-', delButton],
			bbar : BonusUnitTypeTabPagingToolbar
		});
BonusUnitTypeTabDs.load({
			params : {
				start : 0,
				limit : BonusUnitTypeTabPagingToolbar.pageSize
			}
		});
