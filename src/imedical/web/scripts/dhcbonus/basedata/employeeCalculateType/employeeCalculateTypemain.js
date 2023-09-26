/**
 * name:tab of database author:zhaoliguo Date:2011-2-14
 */

var BonusEmployeeTabUrl = '../csp/dhc.bonus.employeecalculatetypeexe.csp';
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
					}, ['rowid', 'BonusUnitID', 'BonusUnitName',
							'CalculateTypeID', 'CalculateTypeName',
							'CalculateTypeGroupID', 'CalculateGroupName',
							'SuperiorUnitID', 'superName']),

			// 'rowid','BonusUnitID','BonusUnitName','CalculateTypeID','CalculateTypeName','CalculateTypeGroupID','CalculateGroupName','SuperiorUnitID','superName'
			remoteSort : true
		});
// "rowid^EmployeeName^CalculateTypeName^CalculateGroupName^BonusTargetName"

// 设置默认排序字段和排序方向
BonusEmployeeTabDs.setDefaultSort('rowid', 'EmployeeName');

// 数据库数据模型
var BonusEmployeeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '所属科室',
			dataIndex : 'superName',
			width : 200,
			sortable : true
		}, {
			header : '核算人员',
			dataIndex : 'BonusUnitName',
			width : 200,
			sortable : true
		}, {
			header : '核算属性',
			dataIndex : 'CalculateGroupName',
			width : 200,
			sortable : true
		}, {
			header : '属性名称',
			dataIndex : 'CalculateTypeName',
			width : 200,
			sortable : true
		}/*
			 * , { header : '奖金指标', dataIndex : 'BonusTargetName', width : 200,
			 * sortable : true }
			 */

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

// 修改按钮
var editButton = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '修改',
			iconCls : 'option',
			handler : function() {
				employeeCalTypeEditFun();

			}
		});

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		// ----------核算单元------------------------------
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
					fieldLabel : '所属科室',
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
					fieldLabel : '核算人员',
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

		// 核算单元上级和核算单元联动
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
					fieldLabel : '核算属性',
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
					fieldLabel : '核算类型组',
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
		// 方案和核算单元联动
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

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [supUnitField, empField, CalculateTypeGroupComb,
							CalculateTypeField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			var EmployeeID = empField.getValue();
			var CalculateTypeID = CalculateTypeField.getValue();

			if (EmployeeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '人员为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (CalculateTypeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金指标',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=add&BonusUnitID='
						+ EmployeeID + '&CalculateTypeID=' + CalculateTypeID,
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
		var rowid = 0
		var BonusUnitID = 0

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
			rowid = rowObj[0].get("rowid");
			BonusUnitID = rowObj[0].get("BonusUnitID");
		}
		function handler(id) {
			if (id == "yes") {

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=del&rowid='
							+ rowid + '&BonusUnitID=' + BonusUnitID,
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
 * buttons : ['-', BonusEmployeeFilterItem, '-', BonusEmployeeSearchBox]
 */
// 表格
// ----------核算单元------------------------------
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
			fieldLabel : '所属科室',
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
			fieldLabel : '核算单元',
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

// 核算单元上级和核算单元联动
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
			fieldLabel : '核算类别',
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
			fieldLabel : '核算类型组',
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
// 方案和核算单元联动
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
			text : '查询',
			tooltip : '查询',
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
	text : '修改院龄',
	tooltip : '修改院龄',
	iconCls : 'add',
	handler : function() {

		Ext.MessageBox.confirm('提示', '您确信要修改职工的院龄吗?', handler);

		function handler(id) {
			if (id == "yes") {

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=editInH',
					waitMsg : '修改中...',
					failure : function(result, request) {
						Handler = function() {
							
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
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '注意',
										msg : '修改成功!',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});

						} else {
							var message = "修改失败!";
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
		}
	}
});

// 导入人事部门的人员职称信息
var uploadButton = new Ext.Toolbar.Button({
			text : '导入职称信息',
			tooltip : '更新导入人员职称信息！',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});
// ----------------------------------
var BonusEmployeeTab = new Ext.grid.EditorGridPanel({
			title : '奖金指标权限设置',
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
			tbar : [addButton, "-", editButton, "-", delButton, "-", "所属科室：",
					supUnitField1, "-", empField1, "-", "核算类型：",
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
