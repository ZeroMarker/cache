﻿/**
 * name:tab of database author:liuyang Date:2011-1-17
 */

var CalculateTypeCurrRowID = '';
var CalculateTypeCurrName = '';
//var fileTypeCurrRowID = 11111

var BonusItemTypeTabUrl = '../csp/dhc.bonus.impfiletypeexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源
/*
var BonusItemTypeTabProxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.impfiletypeexe.csp?action=excelPos&onloadFileID='
					+ CalcTypeGroupCurrRowID + '&modelType=' + modelType
		});
		*/
var fileConfigDs = new Ext.data.Store({
			proxy : '',  //BonusItemTypeTabProxy
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'loadFileID', 'loadFileName', 'CalGroupID',
							'CalGroupName', 'ColNum']),
			// turn on remote sorting
			remoteSort : true
		});
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
// 设置默认排序字段和排序方向
fileConfigDs.setDefaultSort('rowid');

// 数据库数据模型
var BonusItemTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '文件类型',
			dataIndex : 'loadFileName',
			width : 130,
			sortable : true
		}, {
			header : '文件列名称',
			dataIndex : 'CalGroupName',
			width : 140,
			sortable : true
		}, {
			header : '列位置',
			dataIndex : 'ColNum',
			width : 80,
			align : 'right',
			sortable : true
		}

]);
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
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
		if (fileTypeCurrRowID == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '请先选择核算类别组！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var numcolField = new Ext.form.NumberField({
					id : 'numcolField',
					fieldLabel : 'Excel列位置',
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
					fieldLabel : '文件类型',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					disabled : true,
					store : typeGroupDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : fileTypeCurrName,
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
		var impConfigDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		impConfigDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.impfiletypeexe.csp?action=FileConfig&fileTypeID='
						+ fileTypeID+'&Target='+ Target+ '&start=0&limit=10',
				method : 'POST'
			})
		});

		var impConfigField = new Ext.form.ComboBox({
					id : 'impConfigField',
					fieldLabel : 'Excel列名',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : impConfigDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					// valueNotFoundText : fileTypeCurrName,
					name : 'impConfigField',
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
		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [AtypeGroupField, impConfigField, numcolField]
				});
		// , targetField, AsValueField
		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		//		
		AtypeGroupField.setValue(fileTypeCurrRowID);

		// 定义添加按钮响应函数
		addHandler = function() {

			var ColNum = numcolField.getValue();
			var CalGroupID = impConfigField.getValue();
			var CalGroupName=impConfigField.getRawValue();
			
			var fileTypeID = AtypeGroupField.getValue();

			if (fileTypeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '文件类型为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (CalGroupID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : 'Excel列为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (ColNum == "") {
				Ext.Msg.show({
							title : '错误',
							msg : 'Excel列位置为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			// 
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.impfiletypeexe.csp?action=addFileConfig&fileTypeID='
						+ fileTypeID
						+ '&ColNum='
						+ ColNum
						+ '&CalGroupID='
						+ CalGroupID + '&ItemName='+ CalGroupName+ '&filetype=' + modelType),
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						numcolField.focus();
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
							numcolField.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						fileConfigDs.load({
									params : {
										//modelType : modelType,
										//onloadFileID : fileTypeCurrRowID,
										start : 0,
										limit : 25
									}
								});

						// addwin.close();
					} else {
						var message = "";
						if (jsonData.info=='RepCol')
						message='列位置重复！';
						if (jsonData.info == 'RepCode')
						message = '列名重复!';
						if (jsonData.info == 'RepColNum')
						message = '列名不能为小数!';
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
		var rowid = 0
		var CalGroupName = ''
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
			rowid = rowObj[0].get("rowid");
			CalGroupName = rowObj[0].get("CalGroupName");
		}

		var typeGroup1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		typeGroup1Ds.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.CalculateTypeGroupexe.csp?action=list&start=0&limit=10',
				method : 'POST'
			})
		});

		var EtypeGroupField = new Ext.form.ComboBox({
					id : 'EtypeGroupField',
					fieldLabel : '文件类型',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					disabled : true,
					store : typeGroup1Ds,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : fileTypeCurrName,
					name : 'EtypeGroupField',
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
		var impConfig1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		impConfig1Ds.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.impfiletypeexe.csp?action=FileConfig&fileTypeID='
						+ fileTypeID+'&Target='+ Target+ '&start=0&limit=10',
				method : 'POST'
			})
		});

		var EimpConfigField = new Ext.form.ComboBox({
					id : 'EimpConfigField',
					fieldLabel : 'Excel列名',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : impConfig1Ds,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : CalGroupName,
					name : 'EimpConfigField',
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
		var EnumcolField = new Ext.form.NumberField({
					id : 'EnumcolField',
					fieldLabel : 'Excel列位置',
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
		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [EtypeGroupField, EimpConfigField, EnumcolField]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);
					EtypeGroupField.setValue(rowObj[0].get("loadFileID"));
					EimpConfigField.setValue(rowObj[0].get("CalGroupID"));
					EnumcolField.setValue(rowObj[0].get("ColNum"));

				});
		// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {

			var loafFileID = EtypeGroupField.getValue();
			var fileTypeID = EimpConfigField.getValue();
			var conNum = EnumcolField.getValue();
			var ItemName=EimpConfigField.getRawValue();
			

			if (fileTypeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '导入文件为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (fileTypeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : 'Excel文件列为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			if (conNum == "") {
				Ext.Msg.show({
							title : '错误',
							msg : 'Excel文件列位置为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.impfiletypeexe.csp?action=updateFileConfig&fileTypeID='
						+ loafFileID
						+ '&ColNum='
						+ conNum
						+ '&CalGroupID='
						+ fileTypeID + '&rowid=' + rowid+'&ItemName=' + ItemName+ '&filetype=' + modelType),
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
						fileConfigDs.load({
									params : {
										//modelType : modelType,
										//onloadFileID : fileTypeCurrRowID,
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
		// 定义并初始化行对象 CalculateTypePanel
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
					url : '../csp/dhc.bonus.impfiletypeexe.csp?action=deleteFileConfig&rowid='
							+ rowid+ '&filetype=' + modelType,
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

							fileConfigDs.load({
										params : {
											//modelType : modelType,
											//onloadFileID : fileTypeCurrRowID,
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
var BonusItemTypeTabPagingToolbar = new Ext.PagingToolbar({
	store : fileConfigDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg : "没有记录" // ,
		// buttons : ['-', BonusItemTypeFilterItem, '-', BonusItemTypeSearchBox]

	});

// 表格
var CalculateTypePanel = new Ext.grid.EditorGridPanel({
			title : 'Excel导入配置',
			region : 'center',
			store : fileConfigDs,
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
fileConfigDs.load({
			params : {
				start : 0,
				limit : BonusItemTypeTabPagingToolbar.pageSize
			}
		});
