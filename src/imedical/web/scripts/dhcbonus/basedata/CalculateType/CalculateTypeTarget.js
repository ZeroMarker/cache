/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var CalcTypeTargetUrl = '../csp/dhc.bonus.CalculateTypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源

var CalcTypeTargetProxy = new Ext.data.HttpProxy({
			url : CalcTypeTargetUrl + '?action=listBt&CalcTypeID='
					+ CalculateTypeCurrRowID
		});
var CalcTypeTargetDs = new Ext.data.Store({
			proxy : CalcTypeTargetProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'svalue', 'targetID', 'targetName', 'ctypeID','SchemeName','BonusSchemeID',
							'cTypeName']),
			// "rowid^svalue^targetID^targetName^ctypeID^cTypeName"
			remoteSort : true
		});

// 设置默认排序字段和排序方向
CalcTypeTargetDs.setDefaultSort('rowid', 'targetName');

// 数据库数据模型
var CalcTypeTargetCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '核算类型',
			dataIndex : 'cTypeName',
			width : 120,
			sortable : true
		}, {
			header : '关联指标',
			dataIndex : 'targetName',
			width : 120,
			sortable : true
		}, {
			header : '指标标准',
			dataIndex : 'svalue',
			width : 80,
			sortable : true
		}, {
			header : '奖金方案',
			dataIndex : 'SchemeName',
			width : 120,
			sortable : true
		}

]);

// 初始化默认排序功能 
CalcTypeTargetCm.defaultSortable = true;

// 初始化搜索字段
var BonusItemTypeSearchField = 'cTypeName';

// 添加按钮
var addButtonT = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		if (CalculateTypeCurrRowID == "") {

			Ext.Msg.show({
						title : '提示',
						msg : '请先选择单元核算类型!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}

		var calcTypeTargetField = new Ext.form.TextField({
					id : 'calcTypeTargetField',
					fieldLabel : '类型名称',
					allowBlank : false,
					width : 180,
					disabled:true,
					listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButtonT.focus();
							}
						}
					}
				});

		var AsValueField = new Ext.form.NumberField({
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
								addButtonT.focus();
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
								addButtonT.focus();
							}
						}
					}
				});
// 奖金方案
var StratagemTabUrl = '../csp/dhc.bonus.bonustargetcollectexe.csp';				
var SchemeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchemeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=schemelist&str='
								+ Ext.getCmp('SchemeField').getRawValue(),
						method : 'POST'
					})
		});

var SchemeField = new Ext.form.ComboBox({
			id : 'SchemeField',
			fieldLabel : '奖金方案',
			width : 230,
			listWidth : 230,
			allowBlank : false,
			store : SchemeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'SchemeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});

		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [calcTypeTargetField,SchemeField, targetField, AsValueField]
				});

		calcTypeTargetField.setValue(CalculateTypeCurrName);
		// 初始化添加按钮
		addButtonT = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {

			// var code = cField.getValue();
			// var targetID = calcTypeTargetField.getValue();
			var sValue = AsValueField.getValue();
			var targetID = targetField.getValue();
			var typeTargetID = CalculateTypeCurrRowID // 全局变量
			var schemeID = SchemeField.getValue();
			//alert(schemeID)
			if (schemeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金核算方案不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
		if (targetID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '指标不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			
			if (sValue == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '指标值不能为空！',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
					
			// encodeURI 
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.CalculateTypeexe.csp?action=addBT&'
						+ '&sValue=' + sValue + '&targetID=' + targetID
						+ '&CalcTypeID=' + typeTargetID+'&schemeID='+schemeID),
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						calcTypeTargetField.focus();
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
							calcTypeTargetField.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						CalcTypeTargetDs.load({
									params : {
										CalcTypeID : CalculateTypeCurrRowID,
										start : 0,
										limit : 25
									}
								});
						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的记录已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的记录已经存在!';
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
		addButtonT.addListener('click', addHandler, false);

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
					buttons : [addButtonT, cancelButton]
				});

		// 窗口显示
		addwin.show();
	}
});

// 修改按钮
var editButtonT = new Ext.Toolbar.Button({
	text : '修改',
	tooltip : '修改',
	iconCls : 'option',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = CalcTypeTargetPanel.getSelections();
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

		var EcalcTypeID = new Ext.form.TextField({
					id : 'EcalcTypeID',
					fieldLabel : '核算类型',
					allowBlank : false,
					width : 180,
					disabled :true,
					listWidth : 180,
					valueNotFoundText : CalculateTypeCurrName,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'

									});


		// ------------------------------
		var EsValueField = new Ext.form.NumberField({
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
								addButtonT.focus();
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
								addButtonT.focus();
							}
						}
					}
				});
// 奖金方案
var StratagemTabUrl = '../csp/dhc.bonus.bonustargetcollectexe.csp';				
var SchemeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchemeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl + '?action=schemelist&str='
								+ Ext.getCmp('ESchemeField').getRawValue(),
						method : 'POST'
					})
		});

var ESchemeField = new Ext.form.ComboBox({
			id : 'ESchemeField',
			fieldLabel : '奖金方案',
			width : 230,
			listWidth : 230,
			allowBlank : false,
			valueNotFoundText : rowObj[0].get("SchemeName"),
			store : SchemeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'ESchemeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : false,
			forceSelection : 'true',
			editable : true
		});


		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [EcalcTypeID,ESchemeField, EtargetField,
							EsValueField]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					EcalcTypeID.setValue(CalculateTypeCurrName);
					EsValueField.setValue(rowObj[0].get("svalue"));
					EtargetField.setValue(rowObj[0].get("targetID"));
					ESchemeField.setValue(rowObj[0].get("BonusSchemeID"));

				});

		// 定义并初始化保存修改按钮
		var editButtonT = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {

			var sValue = EsValueField.getValue();
			var targetID = EtargetField.getValue();
			CalcTypeID = CalculateTypeCurrRowID;
			var schemeID = ESchemeField.getValue();
			
			if (schemeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金方案不能为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};			
			if (CalculateTypeCurrRowID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算类型不能为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (targetID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金指标不能为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (sValue == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算标准为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=editBT&rowid='
						+ rowid
						+ '&sValue='
						+ sValue
						+ '&targetID='
						+ targetID
						+'&CalcTypeID='+CalculateTypeCurrRowID+'&schemeID='+schemeID,
						
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
						CalcTypeTargetDs.load({
									params : {
										CalcTypeID : CalculateTypeCurrRowID,
										start : 0,
										limit : 25
									}
								});
						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的记录已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的记录已经存在!';
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
		editButtonT.addListener('click', editHandler, false);

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
					buttons : [editButtonT, cancelButton]
				});

		// 窗口显示
		editwin.show();
	}
});

// 删除按钮
var delButtonT = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = CalcTypeTargetPanel.getSelections();
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
					url : '../csp/dhc.bonus.CalculateTypeexe.csp?action=delBT&rowid='
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
						CalcTypeTargetDs.load({
									params : {
										CalcTypeID : CalculateTypeCurrRowID,
										start : 0,
										limit : 25
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
var CalcTypeTargetPagingToobar = new Ext.PagingToolbar({
	store : CalcTypeTargetDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg : "没有记录" // ,
		// buttons : ['-', BonusItemTypeFilterItem, '-', BonusItemTypeSearchBox]

	});

// 表格
var CalcTypeTargetPanel = new Ext.grid.EditorGridPanel({
			title : '核算类型涉及指标',
			region : 'east',
			width : 450,
			store : CalcTypeTargetDs,
			cm : CalcTypeTargetCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addButtonT, '-', editButtonT, '-', delButtonT],
			bbar : CalcTypeTargetPagingToobar
		});
CalcTypeTargetDs.load({
			params : {
				start : 0,
				limit : CalcTypeTargetPagingToobar.pageSize
			}
		});
