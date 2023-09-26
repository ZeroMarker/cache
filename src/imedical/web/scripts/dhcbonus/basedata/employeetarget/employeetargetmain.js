/**
 * name:tab of database author:zhaoliguo Date:2011-2-14
 */

var BonusEmployeeTabUrl = '../csp/dhc.bonus.employeetargetexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

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

// 设置默认排序字段和排序方向
BonusEmployeeTabDs.setDefaultSort('rowid', 'EmployeeName');

// 数据库数据模型
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '管理人员',
			dataIndex : 'EmployeeName',
			width : 200,
			sortable : true
		}, {
			header : '指标类别',
			dataIndex : 'TargetTypeName',
			width : 200,
			sortable : true
		}, {
			header : '奖金指标',
			dataIndex : 'TargetName',
			width : 200,
			sortable : true
		}

]);

// 初始化默认排序功能
BonusEmployeeTabCm.defaultSortable = true;

// 初始化搜索字段
var BonusEmployeeSearchField = 'name';

// 搜索过滤器
var BonusEmployeeFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '用户',
									value : 'EmployeeName',
									checked : false,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								}), new Ext.menu.CheckItem({
									text : '指标',
									value : 'BonusTargetName',
									checked : true,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								})]
			}
		});

// 定义搜索响应函数
function onBonusEmployeeItemCheck(item, checked) {
	if (checked) {
		BonusEmployeeSearchField = item.value;
		BonusEmployeeFilterItem.setText(item.text + ':');
	}
};

// 查找按钮
var BonusEmployeeSearchBox = new Ext.form.TwinTriggerField({
			width : 180,
			trigger1Class : 'x-form-clear-trigger',
			trigger2Class : 'x-form-search-trigger',
			emptyText : '搜索...',
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

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		// ----------用户------------------------------

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
					fieldLabel : '管理人员',
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
					fieldLabel : '奖金指标',
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
					fieldLabel : '指标类别',
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
		// 方案和核算单元联动
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

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [empField,bonusTargetTypeComb ,targetField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			var EmployeeID = empField.getValue();
			var targetID = targetField.getValue();

			if (EmployeeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '人员为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (targetID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金指标',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.employeetargetexe.csp?action=add&EmployeeID='
						+ EmployeeID + '&TargetID=' + targetID,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						unitField.focus();
					}
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
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
									title : '注意',
									msg : '添加成功!',
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
							message = '记录已经存在!';

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

		// 添加保存按钮的监听事件
		addButton.addListener('click', addHandler, false);

		// 初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
					text : '取消'
				});

		// 定义取消按钮的响应函数
		cancelHandler = function() {
			addwin.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 初始化窗口
		addwin = new Ext.Window({
					title : '添加记录',
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

		// 窗口显示
		addwin.show();
	}
});

// 删除按钮
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = BonusEmployeeTab.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要删除的数据!',
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
					waitMsg : '删除中...',
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
										msg : '删除成功!',
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
										title : '错误',
										msg : '删除失败!',
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
		Ext.MessageBox.confirm('提示', '确实要删除该条记录吗?', handler);
	}
});

// 分页工具栏
var BonusEmployeeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusEmployeeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录"

		});
/*
			buttons : ['-', BonusEmployeeFilterItem, '-',
					BonusEmployeeSearchBox]
					*/
// 表格
var BonusEmployeeTab = new Ext.grid.EditorGridPanel({
			title : '奖金指标权限设置',
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
