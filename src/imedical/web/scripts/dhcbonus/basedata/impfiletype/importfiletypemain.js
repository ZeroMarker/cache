/**
 * name:tab of database author:liuyang Date:2011-1-24
 */

var impFileTypeUrl = '../csp/dhc.bonus.impfiletypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

var BonusEmployeeTabProxy = new Ext.data.HttpProxy({
			url : impFileTypeUrl + '?action=list'
		});
var BonusEmployeeTabDs = new Ext.data.Store({
			proxy : BonusEmployeeTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name', 'configName', 'fileTypeID',
							'fileTypeName','TargetTableName','TargetTable']),
			remoteSort : true
		});

// 设置默认排序字段和排序方向
BonusEmployeeTabDs.setDefaultSort('rowid', 'name');

// 数据库数据模型
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '文件编码',
			dataIndex : 'code',
			width : 60,
			sortable : true
		}, {
			header : '文件名称',
			dataIndex : 'name',
			width : 150,
			sortable : true
		}, {
			header : '模板名称',
			dataIndex : 'configName',
			width : 150,
			sortable : true
		}, {
			header : '模板类型',
			dataIndex : 'fileTypeName',
			width : 90,
			sortable : true
		},{
			header : '目标表',
			dataIndex :'TargetTableName',
			width : 110,
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
									text : '编码',
									value : 'code',
									checked : false,
									group : 'BonusEmployeeFilter',
									checkHandler : onBonusEmployeeItemCheck
								}), new Ext.menu.CheckItem({
									text : '名称',
									value : 'name',
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
								url : impFileTypeUrl + '?action=list'
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
								url : impFileTypeUrl
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

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '文件编码',
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
					fieldLabel : '文件名称',
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

		var tField = new Ext.form.TextField({
					id : 'tField',
					fieldLabel : '模板文件',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '模板配置文件名称...',
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

		var fileTypeStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '指标横向扩张'], ['2', '指标纵向扩张'], ['3', '科室横向扩张']]
				});
		var fileTypeField = new Ext.form.ComboBox({
					id : 'fileTypeField',
					fieldLabel : '模板类型',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : fileTypeStore,
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
						url : '../csp/dhc.bonus.impfiletypeexe.csp?action=unit&str='
								+ Ext.getCmp('unitField').getRawValue(),
						method : 'POST'
					})
		});

		var unitField = new Ext.form.ComboBox({
					id : 'unitField',
					fieldLabel : '所属核算单元',
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
		var TargetTableStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['dhc_bonus_data.BonusTargetCollect', '奖金指标表'], 
					['dhc_bonus_module.BonusExpendCollect', '支出项目表'], 
					['dhc_bonus_module.BonusIncomeCollect', '收入项目表'], 
					['dhc_bonus_module.WorkItemCollect', '工作量表'], 
					['dhc_bonus_module.DrgsItemCollect', 'Drgs表'],
					['dhc_bonus_data.EmpBonusPay', '奖金发放表']
					]
				});
		var TargetTableField = new Ext.form.ComboBox({
					id : 'TargetTableField',
					fieldLabel : '目标表',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : TargetTableStore,
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
					items : [cField, nField, tField, fileTypeField,TargetTableField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var unitdr = unitField.getValue();

			var tField1 = tField.getValue();
			var fileTypeField1 = fileTypeField.getValue();
			var TargetField= TargetTableField.getValue();

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
			if (tField1 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '模板文件为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (fileTypeField1 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '模板文件类型为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
           if (TargetField == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '目标表不能为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.impfiletypeexe.csp?action=add&code='
						+ code + '&name=' + name + '&configname=' + tField1
						+ '&filetype=' + fileTypeField1+ '&Target=' + TargetField,
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
							message = '输入的编码已经存在!';

						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';

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
		var rowObj = importFileTypeTab.getSelections();
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

		var tField2 = new Ext.form.TextField({
					id : 'tField2',
					fieldLabel : '模板文件',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '模板配置文件名称...',
					anchor : '90%',
					valueNotFoundText : rowObj[0].get("configName"),
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (tField2.getValue() != "") {
									fileTypeStore2.focus();
								} else {
									Handler = function() {
										tField2.focus();
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

		var fileTypeStore2 = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '指标横向扩张'], ['2', '指标纵向扩展'], ['3', '科室横向扩张']]
				});
		var fileTypeField2 = new Ext.form.ComboBox({
					id : 'fileTypeField2',
					fieldLabel : '模板类型',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : fileTypeStore2,
					anchor : '90%',
					value : '', // 默认值
					valueNotFoundText : rowObj[0].get("fileTypeName"),
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
						url : '../csp/dhc.bonus.impfiletypeexe.csp?action=unit&str='
								+ Ext.getCmp('unit1Field').getRawValue(),
						method : 'POST'
					})
		});

		var unit1Field = new Ext.form.ComboBox({
					id : 'unit1Field',
					fieldLabel : '所属核算单元',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : unit1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get("unitName"),
					triggerAction : 'all',
					emptyText : '请选所属核算单元...',
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
     var TargetTableStore = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['dhc_bonus_data.BonusTargetCollect', '奖金指标表'], 
					['dhc_bonus_module.BonusExpendCollect', '支出项目表'], 
					['dhc_bonus_module.BonusIncomeCollect', '收入项目表'], 
					['dhc_bonus_module.WorkItemCollect', '工作量表'], 
					['dhc_bonus_module.DrgsItemCollect', 'Drgs表'],
					['dhc_bonus_data.EmpBonusPay', '奖金发放表']
					]

				});
		var TargetTableField1 = new Ext.form.ComboBox({
					id : 'TargetTableField1',
					fieldLabel : '目标表',
					width : 250,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : TargetTableStore,
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
		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, tField2, fileTypeField2,TargetTableField1]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			c1Field.setValue(rowObj[0].get("code"));
			n1Field.setValue(rowObj[0].get("name"));
			tField2.setValue(rowObj[0].get("configName"));
			fileTypeField2.setValue(rowObj[0].get("fileTypeID"));
			TargetTableField1.setValue(rowObj[0].get("TargetTable"));
			
			 
			

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

			var tField21 = tField2.getValue();
			var fileTypeField21 = fileTypeField2.getValue();
			var Target=TargetTableField1.getValue();      

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

			if (tField21 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '模板文件为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (fileTypeField21 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '模板文件类型为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
				if (Target == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '目标文件不能为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			var unitdr = unit1Field.getValue();

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.impfiletypeexe.csp?action=edit&rowid='
						+ rowid + '&code=' + code + '&name=' + name
						+ '&configname=' + tField21 + '&filetype='
						+ fileTypeField21+'&Target='+Target,
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
							message = '输入的代码已经存在!';

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
		var rowObj = importFileTypeTab.getSelections();
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
					url : '../csp/dhc.bonus.impfiletypeexe.csp?action=del&rowid='
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
			//,buttons : ['-', BonusEmployeeFilterItem, '-',	BonusEmployeeSearchBox]

		});

// 表格
var importFileTypeTab = new Ext.grid.EditorGridPanel({
			title : '导入数据模板维护',
			region : 'west',
			width : 590,
			height : 450,
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
// ---------------------------------------------
var CalcTypeGroupCurrRowID = '';
var fileTypeCurrRowID = '';
var fileTypeCurrName = '';
var fileTypeID=0;
var onloadFileID='';
var modelType=''
importFileTypeTab.on('rowclick', function(grid, rowIndex, e) {
			var selectedRow = BonusEmployeeTabDs.data.items[rowIndex];

			// 单击接口核算部门后刷新接口核算部门单元
			fileTypeCurrRowID = selectedRow.data['rowid'];
			onloadFileID= selectedRow.data['rowid'];
			fileTypeCurrName = selectedRow.data['name'];
			fileTypeID= selectedRow.data['fileTypeID'];
			modelType= selectedRow.data['fileTypeID'];
			Target=selectedRow.data['TargetTable'];
		
		//var BonusItemTypeTabProxy = new Ext.data.HttpProxy({
		fileConfigDs.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.impfiletypeexe.csp?action=excelPos&onloadFileID='
					+ fileTypeCurrRowID + '&modelType=' + modelType
		});
		
			fileConfigDs.load({
						params : {
							//modelType : modelType,
							//onloadFileID:fileTypeCurrRowID,
							start : 0,
							limit : 25
						}
					});

		});
