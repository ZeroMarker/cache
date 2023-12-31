/**
 * name:tab of database author:liuyang Date:2011-1-24
 */
var BonusReportMainRowId = '';
var BonusReportUrl = '../csp/dhc.bonus.bonusreportmanagementexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

var ReportMainTabProxy = new Ext.data.HttpProxy({
			url : BonusReportUrl + '?action=list'
		});
var ReportMainTabDs = new Ext.data.Store({
			proxy : ReportMainTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name', 'rpTypeID', 'rpType','IsPub']),
			remoteSort : true
		});

// 设置默认排序字段和排序方向
ReportMainTabDs.setDefaultSort('rowid', 'name');

// 数据库数据模型
var ReportMainTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '报表编码',
			dataIndex : 'code',
			width : 60,
			sortable : true
		}, {
			header : '报表名称',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}, {
			header : '报表类型',
			dataIndex : 'rpType',
			width : 90,
			sortable : true
		}, {
			header : '是否发布',
			dataIndex : 'IsPub',
			width : 90,
			sortable : true
		}

]);

// 初始化默认排序功能
ReportMainTabCm.defaultSortable = true;

// 初始化搜索字段
var ReportMainSearchField = 'name';

// 搜索过滤器
var ReportMainFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '编码',
									value : 'code',
									checked : false,
									group : 'ReportMainFilter',
									checkHandler : onReportMainItemCheck
								}), new Ext.menu.CheckItem({
									text : '名称',
									value : 'name',
									checked : true,
									group : 'ReportMainFilter',
									checkHandler : onReportMainItemCheck
								})]
			}
		});

// 定义搜索响应函数
function onReportMainItemCheck(item, checked) {
	if (checked) {
		ReportMainSearchField = item.value;
		ReportMainFilterItem.setText(item.text + ':');
	}
};

// 查找按钮
var ReportMainSearchBox = new Ext.form.TwinTriggerField({
			width : 150,
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
					ReportMainTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusReportUrl + '?action=list'
							});
					ReportMainTabDs.load({
								params : {
									start : 0,
									limit : ReportMainTabPagingToolbar.pageSize
								}
							});
				}
			},
			onTrigger2Click : function() {
				if (this.getValue()) {
					ReportMainTabDs.proxy = new Ext.data.HttpProxy({
								url : BonusReportUrl
										+ '?action=list&searchField='
										+ ReportMainSearchField
										+ '&searchValue=' + this.getValue()
							});
					ReportMainTabDs.load({
								params : {
									start : 0,
									limit : ReportMainTabPagingToolbar.pageSize
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

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '报表编码',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '编码...',
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
												title : '错误',
												msg : '编码不能为空!',
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
					fieldLabel : '报表名称',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '名称...',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (nField.getValue() != "") {
									tField.focus();
								} else {
									Handler = function() {
										nField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '名称不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var rpType1Store = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['11', '横向扩展无图'], ['21', '纵向扩展无图'], ['22', '纵向扩展饼图'], ['23', '纵向扩展柱图']]
				});
		var rpType1Field = new Ext.form.ComboBox({
					id : 'rpType1Field',
					fieldLabel : '报表类型',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : rpType1Store,
					anchor : '90%',
					value : '', // 默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var IsPubStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '不发布'], ['1', '发布']]
				});
		var IsPubField = new Ext.form.ComboBox({
					id : 'IsPubField',
					fieldLabel : '是否发布',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : true,
					store : IsPubStore,
					anchor : '90%',
					value : '', // 默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField, rpType1Field,IsPubField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var rpType1 = rpType1Field.getValue();
			var IsPub= IsPubField.getValue();

			code = trim(code);
			name = trim(name);

			if (code == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '编码为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpType1 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '报表类型为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=add&code='
						+ code + '&name=' + name+ '&rpType=' + rpType1+ '&IsPub=' + IsPub,
				waitMsg : '保存中...',
				failure : function(result, request) {
					/*
					 * Handler = function() { unitField.focus(); }
					 */

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
							nField.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						ReportMainTabDs.load({
									params : {
										start : 0,
										limit : ReportMainTabPagingToolbar.pageSize
									}
								});
						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的报表名称已经存在!';
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

		// 窗口显示
		addwin.show();
	}
});

// 修改按钮
var editButton = new Ext.Toolbar.Button({
	text : '修改',
	tooltip : '修改',
	iconCls : 'option',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = BonusReportManagementTab.getSelections();
		// 定义并初始化行对象长度变量
		var len = rowObj.length;
		// 判断是否选择了要修改的数据
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择需要修改的数据!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
		}

		var c1Field = new Ext.form.TextField({
					id : 'c1Field',
					fieldLabel : '编码',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("code"),
					emptyText : '编码...',
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
												title : '错误',
												msg : '编码不能为空!',
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
					fieldLabel : '名称',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					valueNotFoundText : rowObj[0].get("name"),
					emptyText : '名称...',
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
												title : '错误',
												msg : '名称不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		var rpTypeStore2 = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['11', '横向扩展无图'], ['21', '纵向扩展无图'], ['22', '纵向扩展饼图'], ['23', '纵向扩展柱图']]
				});
		var rpTypeField2 = new Ext.form.ComboBox({
					id : 'rpTypeField2',
					fieldLabel : '报表类型',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : rpTypeStore2,
					anchor : '90%',
					value : '', // 默认值
					valueNotFoundText : rowObj[0].get("rpType"),
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
var IsPubStore2 = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['0', '不发布'], ['1', '发布']]
				});
		var IsPubField2 = new Ext.form.ComboBox({
					id : 'IsPubField2',
					fieldLabel : '是否发布',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : IsPubStore2,
					anchor : '90%',
					value : '', // 默认值
					valueNotFoundText : rowObj[0].get("IsPub"),
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true
				});
		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field,rpTypeField2,IsPubField2]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			c1Field.setValue(rowObj[0].get("code"));
			n1Field.setValue(rowObj[0].get("name"));
			rpTypeField2.setValue(rowObj[0].get("rpTypeID"));
			IsPubField2.setValue(rowObj[0].get("IsPub"));
				// unit1Field.setValue(rowObj[0].get("unitDr"));

			});

		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = trim(name);
			
			var rpTypeField21 = rpTypeField2.getValue();
			var IsPub = IsPubField2.getValue();

			if (code == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '编码为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpTypeField21 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '报表类型为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=edit&rowid='
						+ rowid + '&code=' + code + '&name=' + name
						+ '&rpType='+ rpTypeField21 	+ '&IsPub='+IsPub,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
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
						Ext.Msg.show({
									title : '注意',
									msg : '修改成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK
								});
						ReportMainTabDs.load({
									params : {
										start : 0,
										limit : ReportMainTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的代码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的报表名称已经存在!';
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

		// 添加保存修改按钮的监听事件
		editButton.addListener('click', editHandler, false);

		// 定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
					text : '取消修改'
				});

		// 定义取消修改按钮的响应函数
		cancelHandler = function() {
			editwin.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 定义并初始化窗口
		var editwin = new Ext.Window({
					title : '修改记录',
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

		// 窗口显示
		editwin.show();
	}
});

// 删除按钮
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = BonusReportManagementTab.getSelections();
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
					url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=del&rowid='
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
							
							reportCellDs.load({
								params : {
					 	            rowID : BonusReportMainRowId,
									start : 0,
									limit : BonusReportCellTabPagingToolbar.pageSize
								}
							});

							
							ReportMainTabDs.load({
								params : {
									start : 0,
									limit : ReportMainTabPagingToolbar.pageSize
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
var ReportMainTabPagingToolbar = new Ext.PagingToolbar({
			store : ReportMainTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录",
			buttons : ['-', ReportMainFilterItem,'-',ReportMainSearchBox]

		});

// 表格
var BonusReportManagementTab = new Ext.grid.EditorGridPanel({
			title : '报表标题维护',
			region : 'west',
			width : 580,
			height : 450,
			store : ReportMainTabDs,
			cm : ReportMainTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, "-", editButton, "-", delButton],
			bbar : ReportMainTabPagingToolbar
		});
ReportMainTabDs.load({
			params : {
				start : 0,
				limit : ReportMainTabPagingToolbar.pageSize
			}
		});
// ---------------------------------------------

var rowID='';
BonusReportManagementTab.on('rowclick', function(grid, rowIndex, e) {
			var selectedRow = ReportMainTabDs.data.items[rowIndex];

			// 单击接口核算部门后刷新接口核算部门单元
			BonusReportMainRowId = selectedRow.data['rowid'];
			rowID= selectedRow.data['rowid'];
	        //scheme02Ds.proxy = new Ext.data.HttpProxy({url: scheme02Url + '?action=scheme02list&scheme='+tmpSelectedScheme});

		    reportCellDs.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=listcell&rowID='+ rowID	});
			
			reportCellDs.load({
						params : {
				            //rowID:BonusReportMainRowId,
							start : 0,
							limit : 25
						}
					});

		});
