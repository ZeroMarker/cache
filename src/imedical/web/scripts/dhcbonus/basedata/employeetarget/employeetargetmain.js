/**
 * name:tab of database author:zhaoliguo Date:2011-2-14
 */

var BonusEmployeeTabUrl = '../csp/dhc.bonus.employeetargetexe.csp';
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
					}, ['rowid', 'BonusEmployeeID', 'EmployeeName',
							'BonusTargetID', 'TargetName', 'TargetTypeName']),
			// turn on remote sorting
			remoteSort : true
		});

// ����Ĭ�������ֶκ�������
BonusEmployeeTabDs.setDefaultSort('rowid', 'EmployeeName');

// ���ݿ�����ģ��
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '������Ա',
			dataIndex : 'EmployeeName',
			width : 200,
			sortable : true
		}, {
			header : 'ָ�����',
			dataIndex : 'TargetTypeName',
			width : 200,
			sortable : true
		}, {
			header : '����ָ��',
			dataIndex : 'TargetName',
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

// ��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function() {

		// ----------�û�------------------------------

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
				url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=list&searchField=code&searchValue='
						+ Ext.getCmp('empField').getRawValue()
						+ '&sort=&dir=&start=0&limit=25',
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

		// ----------------------------------

		var targetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		targetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.employeetargetexe.csp?action=BonusTarget&TargetName='
						+ Ext.getCmp('targetField').getRawValue()
						+ '&start=0&limit=5'+'&TargetTypeID='+ bonusTargetTypeComb.getValue(),
				method : 'POST'
			})
		});

		var targetField = new Ext.form.ComboBox({
					id : 'targetField',
					fieldLabel : '����ָ��',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : targetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'targetField',
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
		var bonusTargetTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'cname'])
				});

		bonusTargetTypeDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
								method : 'POST'
							})
				});
		var bonusTargetTypeComb = new Ext.form.ComboBox({
					fieldLabel : 'ָ�����',
					width : 230,
					allowBlank : true,
					store : bonusTargetTypeDs,
					valueField : 'rowid',
					displayField : 'cname',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		// �����ͺ��㵥Ԫ����
		bonusTargetTypeComb.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
		
					targetDs.load({
								params : {
									start : 0,
									limit : 10
								}
							});
				});
		function searchFun(SetCfgDr) {
	
			targetDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.employeetargetexe.csp?action=BonusTarget&TargetName='
						+ Ext.getCmp('targetField').getRawValue()
						+'&TargetTypeID='+ SetCfgDr.toString()
						+ '&start=0&limit=5',
						method : 'POST'
					});
			targetDs.load({
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
					items : [empField,bonusTargetTypeComb ,targetField]
				});

		// ��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
					text : '�� ��'
				});

		// ������Ӱ�ť��Ӧ����
		addHandler = function() {

			var EmployeeID = empField.getValue();
			var targetID = targetField.getValue();

			if (EmployeeID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '��ԱΪ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (targetID == "") {
				Ext.Msg.show({
							title : '����',
							msg : '����ָ��',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.employeetargetexe.csp?action=add&EmployeeID='
						+ EmployeeID + '&TargetID=' + targetID,
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
									msg : '��ӳɹ�!',
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
					url : '../csp/dhc.bonus.employeetargetexe.csp?action=del&rowid='
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
			emptyMsg : "û�м�¼"

		});
/*
			buttons : ['-', BonusEmployeeFilterItem, '-',
					BonusEmployeeSearchBox]
					*/
// ���
var BonusEmployeeTab = new Ext.grid.EditorGridPanel({
			title : '����ָ��Ȩ������',
			store : BonusEmployeeTabDs,
			cm : BonusEmployeeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, "-", delButton],
			bbar : BonusEmployeeTabPagingToolbar
		});
BonusEmployeeTabDs.load({
			params : {
				start : 0,
				limit : BonusEmployeeTabPagingToolbar.pageSize
			}
		});
