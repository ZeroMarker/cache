/**
 * name:tab of database author:zhaoliguo Date:2011-2-14
 */

var BonusEmployeeTabUrl = '../csp/dhc.bonus.employeecalculatetypeexe.csp';
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
					}, ['rowid', 'BonusUnitID', 'BonusUnitName',
							'CalculateTypeID', 'CalculateTypeName',
							'CalculateTypeGroupID', 'CalculateGroupName',
							'SuperiorUnitID', 'superName']),

			// 'rowid','BonusUnitID','BonusUnitName','CalculateTypeID','CalculateTypeName','CalculateTypeGroupID','CalculateGroupName','SuperiorUnitID','superName'
			remoteSort : true
		});
// "rowid^EmployeeName^CalculateTypeName^CalculateGroupName^BonusTargetName"

// ����Ĭ�������ֶκ�������
BonusEmployeeTabDs.setDefaultSort('rowid', 'EmployeeName');

// ���ݿ�����ģ��
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '��������',
			dataIndex : 'superName',
			width : 200,
			sortable : true
		}, {
			header : '������Ա',
			dataIndex : 'BonusUnitName',
			width : 200,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'CalculateGroupName',
			width : 200,
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'CalculateTypeName',
			width : 200,
			sortable : true
		}/*
			 * , { header : '����ָ��', dataIndex : 'BonusTargetName', width : 200,
			 * sortable : true }
			 */

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
									text : '�û�',
									value : 'EmployeeName',
									checked : false,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								}), new Ext.menu.CheckItem({
									text : 'ָ��',
									value : 'BonusTargetName',
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
				var sParam = ""
				var calcTypeGroupID = CalculateTypeGroupComb1.getValue()
				var calcTypeID = CalculateTypeField1.getValue()
				var supUnitID = supUnitField1.getValue()
				var bonusUnitID = empField1.getValue()

				sParam = supUnitID + "^" + bonusUnitID + "^" + calcTypeGroupID
						+ "^" + calcTypeID
				if (this.getValue()) {
					this.setValue('');

					BonusEmployeeTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusEmployeeTabUrl + '?action=list'
							});
					BonusEmployeeTabDs.load({
								params : {
									start : 0,
									limit : BonusEmployeeTabPagingToolbar.pageSize,
									QParam : sParam
								}
							});
				}
			},
			onTrigger2Click : function() {
				var sParam = ""
				var calcTypeGroupID = CalculateTypeGroupComb1.getValue()
				var calcTypeID = CalculateTypeField1.getValue()
				var supUnitID = supUnitField1.getValue()
				var bonusUnitID = empField1.getValue()

				sParam = supUnitID + "^" + bonusUnitID + "^" + calcTypeGroupID
						+ "^" + calcTypeID
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
									limit : BonusEmployeeTabPagingToolbar.pageSize,
									QParam : sParam
								}
							});
				}
			}
		});

// �޸İ�ť
var editButton = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�޸�',
			iconCls : 'option',
			handler : function() {
				employeeCalTypeEditFun();

			}
		});

// ���Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '����',
	tooltip : '����',
	iconCls : 'add',
	handler : function() {

		// ----------���㵥Ԫ------------------------------
		var supUnitDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		supUnitDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=getUnit&start=0&limit=25',
				method : 'POST'
			})
		});

		var supUnitField = new Ext.form.ComboBox({
					id : 'supUnitField',
					fieldLabel : '��������',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : supUnitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'supUnitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true,
					// anchor : '100%',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		var empDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		empDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
								+ '&start=0&limit=25'
								+ '&parent='
								+ Ext.getCmp('supUnitField').getValue(),
						method : 'POST'
					})
		});

		var empField = new Ext.form.ComboBox({
					id : 'empField',
					fieldLabel : '������Ա',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : empDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'empField',
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

		// ���㵥Ԫ�ϼ��ͺ��㵥Ԫ����
		supUnitField.on("select", function(cmb, rec, id) {

			empDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
								+ '&start=0&limit=25'
								+ '&parent='
								+ Ext.getCmp('supUnitField').getValue(),
						method : 'POST'
					});
			empDs.load({
						params : {
							start : 0,
							limit : 10,
							parent : Ext.getCmp('supUnitField').getValue()
						}
					});
		});

		// ----------------------------------

		var CalculateTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		CalculateTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
						+ Ext.getCmp('CalculateTypeField').getRawValue()
						+ '&start=0&limit=10'
						+ '&CalTypeGroupID='
						+ CalculateTypeGroupComb.getValue(),
				method : 'POST'
			})
		});

		var CalculateTypeField = new Ext.form.ComboBox({
					id : 'CalculateTypeField',
					fieldLabel : '��������',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : CalculateTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'CalculateTypeField',
					minChars : 1,
					pageSize : 5,
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
		var CalculateTypeGroupDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		CalculateTypeGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.calculatetypegroupexe.csp?action=list',
						method : 'POST'
					})
		});
		var CalculateTypeGroupComb = new Ext.form.ComboBox({
					fieldLabel : '����������',
					width : 230,
					allowBlank : true,
					store : CalculateTypeGroupDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		// �����ͺ��㵥Ԫ����
		CalculateTypeGroupComb.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());

					CalculateTypeDs.load({
								params : {
									start : 0,
									limit : 10
								}
							});
				});
		function searchFun(SetCfgDr) {

			CalculateTypeDs.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
						+ Ext.getCmp('CalculateTypeField').getRawValue()
						+ '&CalTypeGroupID='
						+ SetCfgDr.toString()
						+ '&start=0&limit=10',
				method : 'POST'
			});
			CalculateTypeDs.load({
						params : {
							start : 0,
							limit : 10
						}
					});
		};

		// ��ʼ�����
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [supUnitField, empField, CalculateTypeGroupComb,
							CalculateTypeField]
				});

		// ��ʼ�����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// �������Ӱ�ť��Ӧ����
		addHandler = function() {

			var EmployeeID = empField.getValue();
			var CalculateTypeID = CalculateTypeField.getValue();

			if (EmployeeID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��ԱΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (CalculateTypeID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����ָ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=add&BonusUnitID='
						+ EmployeeID + '&CalculateTypeID=' + CalculateTypeID,
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
							empField.focus();
						}
						Ext.Msg.show({
									title : 'ע��',
									msg : '���ӳɹ�!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});
						var sParam = "6^1^3^20"
						var calcTypeGroupID = CalculateTypeGroupComb1
								.getValue()
						var calcTypeID = CalculateTypeField1.getValue()
						var supUnitID = supUnitField1.getValue()
						var bonusUnitID = empField1.getValue()
						sParam = supUnitID + "^" + bonusUnitID + "^"
								+ calcTypeGroupID + "^" + calcTypeID

						BonusEmployeeTabDs.load({
									params : {
										start : 0,
										limit : BonusEmployeeTabPagingToolbar.pageSize,
										QParam : sParam
									}
								});
						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '��¼�Ѿ�����!';

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
					height : 200,
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
		var rowid = 0
		var BonusUnitID = 0

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
			rowid = rowObj[0].get("rowid");
			BonusUnitID = rowObj[0].get("BonusUnitID");
		}
		function handler(id) {
			if (id == "yes") {

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=del&rowid='
							+ rowid + '&BonusUnitID=' + BonusUnitID,
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

							var sParam = "6^1^3^20"
							var calcTypeGroupID = CalculateTypeGroupComb1
									.getValue()
							var calcTypeID = CalculateTypeField1.getValue()
							var supUnitID = supUnitField1.getValue()
							var bonusUnitID = empField1.getValue()
							sParam = supUnitID + "^" + bonusUnitID + "^"
									+ calcTypeGroupID + "^" + calcTypeID

							BonusEmployeeTabDs.load({
								params : {
									start : 0,
									limit : BonusEmployeeTabPagingToolbar.pageSize,
									QParam : sParam
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
			emptyMsg : "û�м�¼"

		});
/*
 * buttons : ['-', BonusEmployeeFilterItem, '-', BonusEmployeeSearchBox]
 */
// ����
// ----------���㵥Ԫ------------------------------
var supUnitDs1 = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

supUnitDs1.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=getUnit&start=0&limit=25',
		method : 'POST'
	})
});

var supUnitField1 = new Ext.form.ComboBox({
			id : 'supUnitField1',
			fieldLabel : '��������',
			width : 100,
			listWidth : 200,
			allowBlank : false,
			store : supUnitDs1,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'supUnitField1',
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

var empDs1 = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

empDs1.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
								+ '&start=0&limit=25'
								+ '&parent='
								+ Ext.getCmp('supUnitField1').getValue(),
						method : 'POST'
					})
		});

var empField1 = new Ext.form.ComboBox({
			id : 'empField1',
			fieldLabel : '���㵥Ԫ',
			width : 100,
			listWidth : 200,
			allowBlank : false,
			store : empDs1,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'empField1',
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

// ���㵥Ԫ�ϼ��ͺ��㵥Ԫ����
supUnitField1.on("select", function(cmb, rec, id) {

			empDs1.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
								+ '&start=0&limit=25'
								+ '&parent='
								+ Ext.getCmp('supUnitField1').getValue(),
						method : 'POST'
					});
			empDs1.load({
						params : {
							start : 0,
							limit : 10,
							parent : Ext.getCmp('supUnitField1').getValue()
						}
					});
		});
var CalculateTypeDs1 = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

CalculateTypeDs1.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
				+ Ext.getCmp('CalculateTypeField1').getRawValue()
				+ '&start=0&limit=10'
				+ '&CalTypeGroupID='
				+ CalculateTypeGroupComb1.getValue(),
		method : 'POST'
	})
});

var CalculateTypeField1 = new Ext.form.ComboBox({
			id : 'CalculateTypeField1',
			fieldLabel : '�������',
			width : 100,
			listWidth : 200,
			allowBlank : false,
			store : CalculateTypeDs1,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'CalculateTypeField1',
			minChars : 1,
			pageSize : 5,
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
var CalculateTypeGroupDs1 = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'code', 'name'])
		});

CalculateTypeGroupDs1.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.calculatetypegroupexe.csp?action=list',
						method : 'POST'
					})
		});
var CalculateTypeGroupComb1 = new Ext.form.ComboBox({
			fieldLabel : '����������',
			width : 100,
			listWidth : 200,
			allowBlank : true,
			store : CalculateTypeGroupDs1,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
// �����ͺ��㵥Ԫ����
CalculateTypeGroupComb1.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());

			CalculateTypeDs1.load({
						params : {
							start : 0,
							limit : 10
						}
					});
		});
function searchFun(SetCfgDr) {

	CalculateTypeDs1.proxy = new Ext.data.HttpProxy({
		url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
				+ Ext.getCmp('CalculateTypeField1').getRawValue()
				+ '&CalTypeGroupID='
				+ SetCfgDr.toString()
				+ '&start=0&limit=10',
		method : 'POST'
	});
	CalculateTypeDs1.load({
				params : {
					start : 0,
					limit : 10
				}
			});
};
function queryData() {

	var sParam = ""
	var calcTypeGroupID = CalculateTypeGroupComb1.getValue()
	var calcTypeID = CalculateTypeField1.getValue()
	var supUnitID = supUnitField1.getValue()
	var bonusUnitID = empField1.getValue()

	sParam = supUnitID + "^" + bonusUnitID + "^" + calcTypeGroupID + "^"
			+ calcTypeID
	// alert(sParam)

	BonusEmployeeTabDs.proxy = new Ext.data.HttpProxy({
				url : BonusEmployeeTabUrl + '?action=list'
			});
	BonusEmployeeTabDs.load({
				params : {
					start : 0,
					limit : BonusEmployeeTabPagingToolbar.pageSize,
					QParam : sParam
				}
			});

}
var checkButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls : 'add',
			handler : function() {

				var sParam = ""
				var calcTypeGroupID = CalculateTypeGroupComb1.getValue()
				var calcTypeID = CalculateTypeField1.getValue()
				var supUnitID = supUnitField1.getValue()
				var bonusUnitID = empField1.getValue()

				sParam = supUnitID + "^" + bonusUnitID + "^" + calcTypeGroupID
						+ "^" + calcTypeID
				// alert(sParam)

				BonusEmployeeTabDs.proxy = new Ext.data.HttpProxy({
							url : BonusEmployeeTabUrl + '?action=list&QParam='
									+ sParam
						});
				BonusEmployeeTabDs.load({
							params : {
								start : 0,
								limit : BonusEmployeeTabPagingToolbar.pageSize
								// QParam : sParam
							}
						});

			}
		});

var updateYLButton = new Ext.Toolbar.Button({
	text : '�޸�Ժ��',
	tooltip : '�޸�Ժ��',
	iconCls : 'add',
	handler : function() {

		Ext.MessageBox.confirm('��ʾ', '��ȷ��Ҫ�޸�ְ����Ժ����?', handler);

		function handler(id) {
			if (id == "yes") {

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=editInH',
					waitMsg : '�޸���...',
					failure : function(result, request) {
						Handler = function() {
							
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
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : 'ע��',
										msg : '�޸ĳɹ�!',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});

						} else {
							var message = "�޸�ʧ��!";
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
		}
	}
});

// �������²��ŵ���Աְ����Ϣ
var uploadButton = new Ext.Toolbar.Button({
			text : '����ְ����Ϣ',
			tooltip : '���µ�����Աְ����Ϣ��',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});
// ----------------------------------
var BonusEmployeeTab = new Ext.grid.EditorGridPanel({
			title : '����ָ��Ȩ������',
			region : 'west',
			width : 300,
			height : 450,
			store : BonusEmployeeTabDs,
			cm : BonusEmployeeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, "-", editButton, "-", delButton, "-", "�������ң�",
					supUnitField1, "-", empField1, "-", "�������ͣ�",
					CalculateTypeGroupComb1, "-", CalculateTypeField1, "-",
					checkButton, "-", updateYLButton],
			bbar : BonusEmployeeTabPagingToolbar
		});
var sParam = ""
var calcTypeGroupID = CalculateTypeGroupComb1.getValue()
var calcTypeID = CalculateTypeField1.getValue()
var supUnitID = supUnitField1.getValue()
var bonusUnitID = empField1.getValue()

sParam = supUnitID + "^" + bonusUnitID + "^" + calcTypeGroupID + "^"
		+ calcTypeID
BonusEmployeeTabDs.load({
			params : {
				start : 0,
				limit : BonusEmployeeTabPagingToolbar.pageSize,
				QParam : sParam
			}
		});
// celldblclick
BonusEmployeeTab.on('rowdblclick', function(grid, rowIndex, e) {
			showCalcTypeTargetFun();

		})