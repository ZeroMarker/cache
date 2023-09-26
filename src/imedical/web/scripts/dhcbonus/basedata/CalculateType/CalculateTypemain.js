/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var CalculateTypeCurrRowID = '';
var CalculateTypeCurrName = '';

var BonusItemTypeTabUrl = '../csp/dhc.bonus.CalculateTypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

var BonusItemTypeTabProxy = new Ext.data.HttpProxy({
			url : BonusItemTypeTabUrl + '?action=list&typegroupID='+CalcTypeGroupCurrRowID
		});
var CalcTypeTabDs = new Ext.data.Store({
			proxy : BonusItemTypeTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'code', 'name', 'svalue', 'targetID',
							'targetName', 'ctypeGroupID', 'cTypeGroupName']),
			// turn on remote sorting
			remoteSort : true
		});

// 设置默认排序字段和排序方向
CalcTypeTabDs.setDefaultSort('rowid', 'name');

// 数据库数据模型
var BonusItemTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '核算类型组',
			dataIndex : 'cTypeGroupName',
			width : 130,
			sortable : true
		},{
			header : '编码',
			dataIndex : 'code',
			width : 80,
			sortable : true
		}, {
			header : '名称',
			dataIndex : 'name',
			width : 130,
			sortable : true
		} /*
			 * , { header : '关联指标', dataIndex : 'targetName', width : 100,
			 * sortable : true }, { header : '类型标准值', dataIndex : 'svalue',
			 * width : 100, sortable : true }
			 */

]);

// 初始化默认排序功能
BonusItemTypeTabCm.defaultSortable = true;

// 初始化搜索字段
var BonusItemTypeSearchField = 'name';

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {
		if (CalcTypeGroupCurrRowID == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '请先选择核算类别组！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var cField = new Ext.form.TextField({
					id : 'cField',
					fieldLabel : '类型编码',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
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
					fieldLabel : '类型名称',
					allowBlank : false,
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
		var AsValueField = new Ext.form.TextField({
					id : 'AsValueField',
					fieldLabel : '类型标准',
					allowBlank : false,
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
				url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=BonusTarget&start=0&limit=10',
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
		var typeGroupDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		typeGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.CalculateTypeGroupexe.csp?action=list&start=0&limit=10',
				method : 'POST'
			})
		});

		var AtypeGroupField = new Ext.form.ComboBox({
					id : 'AtypeGroupField',
					fieldLabel : '类别分组',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					disabled:true,
					store : typeGroupDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : CalcTypeGroupCurrName,
					name : 'AtypeGroupField',
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

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [AtypeGroupField, cField, nField]
				});
		// , targetField, AsValueField
		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		//		
		AtypeGroupField.setValue(CalcTypeGroupCurrRowID);

		// 定义添加按钮响应函数
		addHandler = function() {

			var code = cField.getValue();
			var name = nField.getValue();
			var sValue = AsValueField.getValue();
			var targetID = targetField.getValue();
			var typegroupID = AtypeGroupField.getValue();

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
			// encodeURI
			// var ss ='action=add&code='+code + '&name=' + name + '&sValue=' +
			// sValue + '&typegroupID=' + typegroupID
			// alert( ss)

			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.CalculateTypeexe.csp?action=add&code='
						+ code + '&name=' + name + '&typegroupID=' + typegroupID),
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

						CalcTypeTabDs.load({
									params : {
										typegroupID:CalcTypeGroupCurrRowID,
										start : 0,
										limit : BonusItemTypeTabPagingToolbar.pageSize
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
					height : 250,
					minWidth : 400,
					minHeight : 250,
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
		var rowObj = CalculateTypePanel.getSelections();
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
								editButton.focus();
							}
						}
					}
				});
		// ------------------------------
		var EsValueField = new Ext.form.TextField({
					id : 'EsValueField',
					fieldLabel : '类型标准',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					valueNotFoundText : rowObj[0].get("svalue"),
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

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
				url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=BonusTarget&start=0&limit=10',
				method : 'POST'
			})
		});

		var EtargetField = new Ext.form.ComboBox({
					id : 'EtargetField',
					fieldLabel : '奖金指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : targetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'EtargetField',
					minChars : 1,
					pageSize : 5,
					selectOnFocus : true,
					valueNotFoundText : rowObj[0].get("targetName"),
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
		var typeGroupDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		typeGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.CalculateTypeGroupexe.csp?action=list&start=0&limit=10',
				method : 'POST'
			})
		});

		var EtypeGroupField = new Ext.form.ComboBox({
					id : 'EtypeGroupField',
					fieldLabel : '类别分组',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					disabled:true,
					store : typeGroupDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'EtypeGroupField',
					minChars : 1,
					pageSize : 5,
					selectOnFocus : true,
					valueNotFoundText : rowObj[0].get("cTypeGroupName"),
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

		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [EtypeGroupField, c1Field, n1Field]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					c1Field.setValue(rowObj[0].get("code"));
					n1Field.setValue(rowObj[0].get("name"));
					EsValueField.setValue(rowObj[0].get("svalue"));
					EtargetField.setValue(rowObj[0].get("targetID"));
					EtypeGroupField.setValue(rowObj[0].get("ctypeGroupID"));

				});

		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			var sValue = EsValueField.getValue();
			var targetID = EtargetField.getValue();
			var typegroupID = EtypeGroupField.getValue();

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

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=edit&rowid='
						+ rowid
						+ '&code='
						+ code
						+ '&name='
						+ name
						+ '&typegroupID=' + typegroupID,
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
						CalcTypeTabDs.load({
									params : {
										typegroupID:CalcTypeGroupCurrRowID,
										start : 0,
										limit : BonusItemTypeTabPagingToolbar.pageSize
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的j记录已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的记录已经已经存在!';
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
					height : 250,
					minWidth : 400,
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
});

// 删除按钮
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = CalculateTypePanel.getSelections();
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
					url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=del&rowid='
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
							CalcTypeTabDs.load({
								params : {
									typegroupID:CalcTypeGroupCurrRowID,
									start : 0,
									limit : BonusItemTypeTabPagingToolbar.pageSize
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
var BonusItemTypeTabPagingToolbar = new Ext.PagingToolbar({
	store : CalcTypeTabDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg : "没有记录" // ,
		// buttons : ['-', BonusItemTypeFilterItem, '-', BonusItemTypeSearchBox]

	});

// 表格
var CalculateTypePanel = new Ext.grid.EditorGridPanel({
			title : '单元核算类型',
			region : 'center',
			store : CalcTypeTabDs,
			cm : BonusItemTypeTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButton, '-', editButton, '-', delButton],
			bbar : BonusItemTypeTabPagingToolbar
		});
CalcTypeTabDs.load({
			params : {
				start : 0,
				limit : BonusItemTypeTabPagingToolbar.pageSize
			}
		});

CalculateTypePanel.on('rowclick', function(grid, rowIndex, e) {
			var selectedRow = CalcTypeTabDs.data.items[rowIndex];

			// 单击核算类别 刷新 相关指标
			CalculateTypeCurrRowID = selectedRow.data['rowid'];
			CalculateTypeCurrName = selectedRow.data['name'];
			//alert(CalculateTypeCurrRowID)
			
			CalcTypeTargetDs.load({
						params : {
							CalcTypeID : CalculateTypeCurrRowID,
							start : 0,
							limit : 25
						}
					});

		});
