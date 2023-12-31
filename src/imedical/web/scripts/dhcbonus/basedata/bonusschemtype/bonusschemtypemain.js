/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var BonusSchemeTypeTabUrl = '../csp/dhc.bonus.bonusschemtypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

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

// 设置默认排序字段和排序方向
BonusSchemeTypeTabDs.setDefaultSort('rowid', 'name');

// 数据库数据模型
var BonusSchemeTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '方案类别编码',
			dataIndex : 'code',
			width : 100,
			sortable : true
		}, {
			header : '方案类别名称',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}
        ]);

// 初始化默认排序功能
BonusSchemeTypeTabCm.defaultSortable = true;

// 初始化搜索字段
var BonusSchemeTypeSearchField = 'name';

// 搜索过滤器
var BonusSchemeTypeFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '编码',
									value : 'code',
									checked : false,
									group : 'BonusSchemeTypeFilter',
									checkHandler : onBonusSchemeTypeItemCheck
								}), new Ext.menu.CheckItem({
									text : '名称',
									value : 'name',
									checked : true,
									group : 'BonusSchemeTypeFilter',
									checkHandler : onBonusSchemeTypeItemCheck
								})]
			}
		});

// 定义搜索响应函数
function onBonusSchemeTypeItemCheck(item, checked) {
	if (checked) {
		BonusSchemeTypeSearchField = item.value;
		BonusSchemeTypeFilterItem.setText(item.text + ':');
	}
};

// 查找按钮
var BonusSchemeTypeSearchBox = new Ext.form.TwinTriggerField({
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

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '方案类别编码',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '方案类别编码...',
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
												msg : '方案类别编码不能为空!',
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
					fieldLabel : '方案类别名称',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '方案类别名称...',
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
												title : '错误',
												msg : '方案类别名称不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
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

			Ext.Ajax.request({
				url : BonusSchemeTypeTabUrl+'?action=add&code='+ code + '&name=' + name,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						nField.focus();
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
							nField.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
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
								if(jsonData.info=='RepCode') message='输入的编码已经存在!';
								if(jsonData.info=='RepName') message='输入的名称已经存在!';
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		var rowObj = BonusSchemeTypeTab.getSelections();
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
					fieldLabel : '方案类别编码',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '方案类别编码...',
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
												title : '错误',
												msg : '方案类别编码不能为空!',
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
					fieldLabel : '方案类别名称',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '方案类别名称...',
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
												title : '错误',
												msg : '方案类别名称不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});


		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));

					

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


			 //alert(BonusSchemeTypeTabUrl+'?action=edit&rowid='+ rowid+ '&code='+ code+ '&name='+ name);
			
			Ext.Ajax.request({
				url : BonusSchemeTypeTabUrl+'?action=edit&rowid='+ rowid+ '&code='+ code+ '&name='+ name,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						Expend1.focus();
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
						BonusSchemeTypeTabDs.load({
									params : {
										start : 0,
										limit : BonusSchemeTypeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message="";
								if(jsonData.info=='RepCode') message='输入的编码已经存在!';
								if(jsonData.info=='RepName') message='输入的名称已经存在!';
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		var rowObj = BonusSchemeTypeTab.getSelections();
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
					url :BonusSchemeTypeTabUrl+ '?action=del&rowid='
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
							BonusSchemeTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusSchemeTypeTabPagingToolbar.pageSize
								}
							});

						} else if(jsonData.info=='RepSchemeType'){
						        Ext.Msg.show({
									title : '注意',
									msg : '你删除的记录已经被奖金方案引用!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
									
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
var BonusSchemeTypeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusSchemeTypeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录",
			buttons : ['-', BonusSchemeTypeFilterItem, '-',
					BonusSchemeTypeSearchBox]

		});

// 表格
var BonusSchemeTypeTab = new Ext.grid.EditorGridPanel({
			title : '奖金方案类别',
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
