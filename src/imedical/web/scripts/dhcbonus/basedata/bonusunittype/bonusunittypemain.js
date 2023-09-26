/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var BonusUnitTypeTabUrl = '../csp/dhc.bonus.bonusunittypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

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

// 设置默认排序字段和排序方向
BonusUnitTypeTabDs.setDefaultSort('rowid', 'name');

// 数据库数据模型
var BonusUnitTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '单元类别编码',
			dataIndex : 'code',
			width : 100,
			sortable : true
		}, {
			header : '单元类别名称',
			dataIndex : 'name',
			width : 200,
			sortable : true
		}, {
			header : '科室应用',
			width : 100,
			dataIndex : 'IsDeptmentType',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}, {
			header : '医疗组应用',
			width : 100,
			dataIndex : 'IsMedicalGroup',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}, {
			header : '人员应用',
			width : 100,
			dataIndex : 'IsPersonType',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col' + (v == 1 ? '-on' : '')
						+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
			}
		}]);

// 初始化默认排序功能
BonusUnitTypeTabCm.defaultSortable = true;

// 初始化搜索字段
var BonusUnitTypeSearchField = 'name';

// 搜索过滤器
var BonusUnitTypeFilterItem = new Ext.Toolbar.MenuButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '编码',
									value : 'code',
									checked : false,
									group : 'BonusUnitTypeFilter',
									checkHandler : onBonusUnitTypeItemCheck
								}), new Ext.menu.CheckItem({
									text : '名称',
									value : 'name',
									checked : true,
									group : 'BonusUnitTypeFilter',
									checkHandler : onBonusUnitTypeItemCheck
								})]
			}
		});

// 定义搜索响应函数
function onBonusUnitTypeItemCheck(item, checked) {
	if (checked) {
		BonusUnitTypeSearchField = item.value;
		BonusUnitTypeFilterItem.setText(item.text + ':');
	}
};

// 查找按钮
var BonusUnitTypeSearchBox = new Ext.form.TwinTriggerField({
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

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '核算单元类别编码',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '核算单元类别编码...',
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
												msg : '核算单元类别编码不能为空!',
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
					fieldLabel : '核算单元类别名称',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '核算单元类别名称...',
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
												msg : '核算单元类别名称不能为空!',
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
					labelSeparator : '科室应用:',
					allowBlank : false
				});
		var MedicalGroup = new Ext.form.Checkbox({
					id : 'MedicalGroup',
					labelSeparator : '医疗组应用:',
					allowBlank : false
				});
		var PersonType = new Ext.form.Checkbox({
					id : 'PersonType',
					labelSeparator : '人员应用:',
					allowBlank : false
				});

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [cField, nField, DeptmentType, MedicalGroup,
							PersonType]
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

			var IsDeptmentType = (DeptmentType.getValue() == true) ? '1' : '0';
			var IsMedicalGroup = (MedicalGroup.getValue() == true) ? '1' : '0';
			var IsPersonType = (PersonType.getValue() == true) ? '1' : '0';

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
				url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=add&code='
						+ code + '&name=' + name + '&IsDeptmentType='
						+ IsDeptmentType + '&IsMedicalGroup=' + IsMedicalGroup
						+ '&IsPersonType=' + IsPersonType,
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
							message = '输入的编码已经存在!';
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
		var rowObj = BonusUnitTypeTab.getSelections();
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
					fieldLabel : '单元类别编码',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '单元类别编码...',
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
												msg : '核算单元类别编码不能为空!',
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
					fieldLabel : '单元类别名称',
					allowBlank : false,
					width : 150,
					listWidth : 150,
					emptyText : '单元类别名称...',
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
												msg : '核算单元类别名称不能为空!',
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
					labelSeparator : '科室应用:',
					// checked: (rowObj[0].data['IsDeptmentType'])=1?true:false,
					allowBlank : false
				});
		var MedicalGroup1 = new Ext.form.Checkbox({
					id : 'MedicalGroup1',
					labelSeparator : '医疗组应用:',
					// checked: (rowObj[0].data['IsMedicalGroup'])=1?true:false,
					allowBlank : false
				});
		var PersonType1 = new Ext.form.Checkbox({
					id : 'PersonType1',
					labelSeparator : '人员应用:',
					// checked: (rowObj[0].data['IsPersonType'])=1?true:false,
					allowBlank : false
				});


		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [c1Field, n1Field, DeptmentType1, MedicalGroup1,
							PersonType1

					]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));

					DeptmentType1.setValue(rowObj[0].get("IsDeptmentType"));
					MedicalGroup1.setValue(rowObj[0].get("IsMedicalGroup"));
					PersonType1.setValue(rowObj[0].get("IsPersonType"));

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
							message = '输入的代码已经存在!';
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
		var rowObj = BonusUnitTypeTab.getSelections();
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
					url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=del&rowid='
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
							BonusUnitTypeTabDs.load({
								params : {
									start : 0,
									limit : BonusUnitTypeTabPagingToolbar.pageSize
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
var BonusUnitTypeTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusUnitTypeTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录",
			buttons : ['-', BonusUnitTypeFilterItem, '-',
					BonusUnitTypeSearchBox]

		});

// 表格
var BonusUnitTypeTab = new Ext.grid.EditorGridPanel({
			title : '核算单元类别',
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
