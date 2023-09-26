/**
 * name:tab of interlocset author:limingzhong Date:2010-11-10
 */

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源
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

// 设置默认排序字段和排序方向
InterLocSetTabDs.setDefaultSort('rowid', 'asc');

// 数据库数据模型
var InterLocSetTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : "序号",
			dataIndex : 'order',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : '接口套代码',
			dataIndex : 'code',
			width : 110,
			sortable : true
		}, {
			header : "接口套名称",
			dataIndex : 'name',
			width : 110,
			align : 'left',
			sortable : true
		}, {
			header : "接口套类别",
			dataIndex : 'typeName',
			width : 110,
			align : 'left',
			sortable : true
		}, {
			header : "接口套描述",
			dataIndex : 'desc',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : '有效标志',
			width : 110,
			dataIndex : 'active',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}
		}]);

// 初始化默认排序功能
InterLocSetTabCm.defaultSortable = true;

// 添加按钮
var addInterLocSet = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加维度类别',
	iconCls : 'add',
	handler : function() {
		var orderField = new Ext.form.NumberField({
					id : 'orderField',
					fieldLabel : '顺序',
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
												title : '提示',
												msg : '顺序不能为空!',
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
					fieldLabel : '代码',
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
												title : '提示',
												msg : '代码不能为空!',
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
					fieldLabel : '名称',
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
												title : '提示',
												msg : '名称不能为空!',
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
					fieldLabel : '描述',
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
					data : [['1', '奖金数据接口'], ['2', '收入数据接口'], ['3', '支出工作量']]
				});

		var locSetTypeField = new Ext.form.ComboBox({
					id : 'locSetTypeField',
					fieldLabel : '类别',
					width : 80,
					listWidth : 230,
					selectOnFocus : true,
					allowBlank : false,
					store : locSetType,
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
					labelWidth : 60,
					items : [orderField, codeField, nameField, locSetTypeField,
							descField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
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
							title : '错误',
							msg : '接口套代码为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (name == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '接口套名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (typeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '接口套类别为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
						
			//
			//alert('dhc.bonus.interlocsetexe.csp?action=add&code=' + code+ '&name=' + name + '&order=' + order + '&desc=' + desc+ '&type=' + typeID);
			Ext.Ajax.request({
				url : 'dhc.bonus.interlocsetexe.csp?action=add&code=' + code+ '&name=' + name + '&order=' + order + '&desc=' + desc+ '&type=' + typeID,
						
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						codeField.focus();
					}
					Ext.Msg.show({title :'错误',msg :'请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({title : '注意',msg : '添加成功!',icon : Ext.MessageBox.INFO,buttons : Ext.Msg.OK});
						InterLocSetTabDs.load({params : {start : 0,limit : InterLocSetTabPagingToolbar.pageSize}});
					} else if(jsonData.info == 'RepCode'){
							Ext.Msg.show({
										title : '错误',
										msg : '此接口套代码已经存在!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR});
					}else if (jsonData.info == 'RepName'){
							Ext.Msg.show({
										title : '错误',
										msg : '此接口套名称已经存在!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR});
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
					title : '添加接口套记录',
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

		// 窗口显示
		addwin.show();
	}
});

edit = function() {
	// 定义并初始化行对象
	var rowObj = InterLocSetTab.getSelections();
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

	var orderField = new Ext.form.NumberField({
				id : 'orderField',
				fieldLabel : '顺序',
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
											title : '提示',
											msg : '顺序不能为空!',
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
				fieldLabel : '代码',
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
											title : '提示',
											msg : '代码不能为空!',
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
				fieldLabel : '名称',
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
											title : '提示',
											msg : '名称不能为空!',
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
				fieldLabel : '描述',
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
				labelSeparator : '有效标志:',
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
				data : [['1', '奖金数据接口'], ['2', '收入数据接口'], ['3', '支出工作量']]
			});

	var locSetTypeEdit = new Ext.form.ComboBox({
				id : 'locSetTypeEdit',
				fieldLabel : '类别',
				width : 80,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : locSetType,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // 本地模式
				editable : false,
				valueNotFoundText:rowObj[0].get("typeName"),
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	// 定义并初始化面板
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 60,
				items : [codeField, nameField, orderField, locSetTypeEdit,descField,
						 activeField]
			});

	// 面板加载
	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);
				locSetTypeEdit.setValue(rowObj[0].get("typeID"));
					
			});

	// 定义并初始化保存修改按钮
	var editButton = new Ext.Toolbar.Button({
				text : '保存修改'
			});

	// 定义修改按钮响应函数
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
						title : '错误',
						msg : '接口套代码为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (name == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '接口套名称为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		Ext.Ajax.request({
			url : 'dhc.bonus.interlocsetexe.csp?action=edit&rowid=' + rowid
					+ '&code=' + code + '&name=' + name + '&order=' + order
					+ '&desc=' + desc + '&active=' + active+ '&type=' + type,
					
			waitMsg : '保存中...',
			failure : function(result, request) {
				Handler = function() {
					codeField.focus();
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
								title : '提示',
								msg : '修改成功!',
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
									title : '错误',
									msg : '接口套代码已经存在!',
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
									title : '错误',
									msg : '接口套名称已经存在!',
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
				title : '修改接口套记录',
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

	// 窗口显示
	editwin.show();
}

// 修改按钮
var editInterLocSet = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '修改维度类别',
			iconCls : 'add',
			handler : function() {
				edit();
			}
		});

// 删除按钮
var delInterLocSet = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除维度类别',
	iconCls : 'add',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = InterLocSetTab.getSelections();
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
				var active = rowObj[0].get("active");
				// 判断是否是内置数据,如果是则不允许删除,否则可以被删除
				if (active == "Y" || active == "Yes" || active == "y"
						|| active == "yes") {
					Ext.Msg.show({
								title : '注意',
								msg : '有效数据,不允许被删除!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
				} else {
					Ext.Ajax.request({
						url : 'dhc.bonus.interlocsetexe.csp?action=del&rowid='
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
								InterLocSetTabDs.load({
									params : {
										start : 0,
										limit : InterLocSetTabPagingToolbar.pageSize
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
				}
			} else {
				return;
			}
		}
		Ext.MessageBox.confirm('提示', '确实要删除该条记录吗?', handler);
	}
});

// 初始化搜索字段
var InterLocSetSearchField = 'name';

// 搜索过滤器
var InterLocSetFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '接口套代码',
									value : 'code',
									checked : false,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								}), new Ext.menu.CheckItem({
									text : '接口套名称',
									value : 'name',
									checked : true,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								}), new Ext.menu.CheckItem({
									text : '接口套描述',
									value : 'desc',
									checked : false,
									group : 'InterLocSetFilter',
									checkHandler : onInterLocSetItemCheck
								})]
			}
		});

// 定义搜索响应函数
function onInterLocSetItemCheck(item, checked) {
	if (checked) {
		InterLocSetSearchField = item.value;
		InterLocSetFilterItem.setText(item.text + ':');
	}
};

// 查找按钮
var InterLocSetSearchBox = new Ext.form.TwinTriggerField({
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

// 分页工具栏
var InterLocSetTabPagingToolbar = new Ext.PagingToolbar({
			store : InterLocSetTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录",
			buttons : ['-', InterLocSetFilterItem, '-', InterLocSetSearchBox]
		});

// 表格
var InterLocSetTab = new Ext.grid.EditorGridPanel({
			title : '接口套维护',
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

// 加载
InterLocSetTabDs.load({
			params : {
				start : 0,
				limit : InterLocSetTabPagingToolbar.pageSize
			}
		});
