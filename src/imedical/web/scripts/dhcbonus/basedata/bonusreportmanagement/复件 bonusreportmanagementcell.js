/**
 * name:tab of database author:houbo Date:2013-3-29
 */

var BonusReportMainRowId = '';
//var CalculateTypeCurrName = '';
//var BonusReportMainRowId = 11111

FormPlugin = function(msg) {
	// 构造函数中完成
	this.init = function(cmp) {
		// 控件渲染时触发
		cmp.on("render", function() {
					cmp.el.insertHtml("afterEnd",
							"<font color='red'>*</font><font color='blue'>"
									+ msg + "</font>");
				});
	}
}

var BonusReportCellTabUrl = '../csp/dhc.bonus.bonusreportmanagementexe.csp';
function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
//---------------------------------------------------------------------------------------
var smObj = new Ext.grid.RowSelectionModel({
	moveEditorOnEnter : true,

	onEditorKey : function(field, e) {
		var k = e.getKey(), newCell, g = this.grid, last = g.lastEdit, ed = g.activeEditor, ae, last, r, c;
		var shift = e.shiftKey;

		if (k === TAB) {
			e.stopEvent();
			ed.completeEdit();

			if (shift) {
				newCell = g.walkCells(ed.row, ed.col - 1, -1, this.acceptsNav,
						this);
			} else {

				newCell = g.walkCells(ed.row + 1, ed.col, 1, this.acceptsNav,
						this);
			}
			if (newCell) {
				r = newCell[0];
				c = newCell[1];
				tmpRow = r;
				tmpColumn = c;

				if (g.isEditor && g.editing) { // *** handle tabbing while
					// editorgrid is in edit mode
					ae = g.activeEditor;
					if (ae && ae.field.triggerBlur) {

						ae.field.triggerBlur();
					}
				}
				g.startEditing(r, c);
			}

		}

	}
		// ------------------------------
});
var value = "http: //www.baidu.com";

function DomUrl() {

	return "<a href=>" + value + "</a>";
}
//--------------------------------------------------------------------------------------------
// 配件数据源

var BonusReportCellTabProxy = new Ext.data.HttpProxy({
			url : BonusReportCellTabUrl + '?action=listcell&rowID='
					+ BonusReportMainRowId
		});
var reportCellDs = new Ext.data.Store({
			proxy : BonusReportCellTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'name', 'celltype', 'rpindex']),
			// turn on remote sorting
			remoteSort : true
		});
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
// 设置默认排序字段和排序方向
reportCellDs.setDefaultSort('rowid');

// 数据库数据模型
var BonusReportCellTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
		{
			header : '项目名称',
			dataIndex : 'name',
			width : 150,
			sortable : true
		}, {
			header : '数据类型',
			dataIndex : 'celltype',
			width : 120,
			sortable : true
		}, {
			header : '列顺序',
			dataIndex : 'rpindex',
			width : 130,
			align : 'right',
			css : 'background:#d0def0;color:#000000',
			sortable : true,
			editor : new Ext.form.TextField({
						allowBlank : true,
						plugins : new FormPlugin("列位置为字符")

					})
		}

]);
// rowid^loadFileID^loadFileName^CalGroupID^CalGroupName^ColNum
// 初始化默认排序功能
BonusReportCellTabCm.defaultSortable = true;

// 初始化搜索字段
var BonusReportCellSearchField = 'name';

// 添加奖金按钮
var addschemeButton = new Ext.Toolbar.Button({
	text : '添加奖金',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {
		if (BonusReportMainRowId == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '请先选择报表类别组！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var rpindex1Field = new Ext.form.TextField({
					id : 'rpindexlField',
					fieldLabel : '列位置',
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


		var schemeTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=schemetype&start=0&limit=10',
				method : 'POST'
			})
		});

		var schemeTypeField = new Ext.form.ComboBox({
					id : 'schemeTypeField',
					fieldLabel : '奖金方案',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
//					valueNotFoundText : fileTypeCurrName,
					name : 'schemeTypeField',
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
		var schemeNameDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=schemename&schemetype='
						+ schemeTypeField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
		});

		var schemeNameField = new Ext.form.ComboBox({
					id : 'schemeNameField',
					fieldLabel : '奖金项目',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : schemeNameDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					// valueNotFoundText : fileTypeCurrName,
					name : 'schemeNameField',
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
		
		// 方案和项目联动
		schemeTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					// tmpStr=cmb.getValue();
					schemeNameField.setValue("");
					schemeNameField.setRawValue("");
					schemeNameDs.load({
								params : {
									start : 0,
									limit : BonusReportCellTabPagingToolbar.pageSize
								}
							});

				});
		
		function searchFun(SetCfgDr) {
			schemeNameDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/bonusreportmanagementexe.csp?action=schemename&schemetype='
								+ Ext.getCmp('schemeTypeField').getValue(),
						method : 'POST'
					});
			schemeNameDs.load({
						params : {
							start : 0,
							limit : BonusReportCellTabPagingToolbar.pageSize
						}
					});
		};
		
		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [schemeTypeField, schemeNameField, rpindex1Field]
				});
		// , targetField, AsValueField
		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		//		
//		AtypeGroupField.setValue(fileTypeCurrRowID);

		// 定义添加按钮响应函数
		addHandler = function() {

			var schemeid = schemeNameField.getValue();
			var rpindex1 = rpindex1Field.getValue();

			if (schemeid == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金项目为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpindex1 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '列位置为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			// 
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addscheme&schemeid='
						+ schemeid
						+ '&rpindex='
						+ rpindex1
						+ '&rowId='
						+ BonusReportMainRowId),
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						rpindex1Field.focus();
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
							rpindex1Field.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						reportCellDs.load({
									params : {
										rowID : BonusReportMainRowId,
										start : 0,
										limit : 20
									}
								});

						// addwin.close();
					} else {
//						var message = "";
//						if (jsonData.info == 'RepCode')
//							message = '输入的编码已经存在!';
//						if (jsonData.info == 'RepName')
//							message = '输入的名称已经存在!';
						Ext.Msg.show({
									title : '错误',
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
					title : '添加奖金记录',
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

//添加指标按钮
var addtargetButton = new Ext.Toolbar.Button({
	text : '添加指标',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {
		if (BonusReportMainRowId == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '请先选择报表类别组！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		}
		var rpindex2Field = new Ext.form.TextField({
					id : 'rpindex2Field',
					fieldLabel : '列位置',
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


		var targetTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		targetTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=targettype&start=0&limit=10',
				method : 'POST'
			})
		});

		var targetTypeField = new Ext.form.ComboBox({
					id : 'targetTypeField',
					fieldLabel : '指标类别',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : targetTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
//					valueNotFoundText : fileTypeCurrName,
					name : 'targetTypeField',
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
		var targetNameDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		targetNameDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=targetname&targettype='
						+ targetTypeField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
		});

		var targetNameField = new Ext.form.ComboBox({
					id : 'targetNameField',
					fieldLabel : '指标名称',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					// disabled:true,
					store : targetNameDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					// valueNotFoundText : fileTypeCurrName,
					name : 'targetNameField',
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
		
		// 类别和名称联动
		targetTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					// tmpStr=cmb.getValue();
					targetNameField.setValue("");
					targetNameField.setRawValue("");
					targetNameDs.load({
								params : {
									start : 0,
									limit : BonusReportCellTabPagingToolbar.pageSize
								}
							});

				});
		
		function searchFun(SetCfgDr) {
			targetNameDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/bonusreportmanagementexe.csp?action=targetname&targettype='
								+ Ext.getCmp('targetTypeField').getValue(),
						method : 'POST'
					});
			targetNameDs.load({
						params : {
							start : 0,
							limit : BonusReportCellTabPagingToolbar.pageSize
						}
					});
		};
		
		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [targetTypeField, targetNameField, rpindex2Field]
				});
		// , targetField, AsValueField
		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		//		
//		AtypeGroupField.setValue(fileTypeCurrRowID);

		// 定义添加按钮响应函数
		addHandler = function() {

			var targetid = targetNameField.getValue();
			var rpindex2 = rpindex2Field.getValue();

			if (targetid == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '指标名称为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (rpindex2 == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '列位置为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			// 
			Ext.Ajax.request({
				url : ('../csp/dhc.bonus.bonusreportmanagementexe.csp?action=addtarget&targetid='
						+ targetid
						+ '&rpindex='
						+ rpindex2
						+ '&rowId='
						+ BonusReportMainRowId),
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						rpindex2Field.focus();
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
							rpindex2Field.focus();
						}
						Ext.Msg.show({
									title : '注意',
									msg : '添加成功!',
									icon : Ext.MessageBox.INFO,
									buttons : Ext.Msg.OK,
									fn : Handler
								});

						reportCellDs.load({
									params : {
										rowID : BonusReportMainRowId,
										start : 0,
										limit : 20
									}
								});

						// addwin.close();
					} else {
//						var message = "";
//						if (jsonData.info == 'RepCode')
//							message = '输入的编码已经存在!';
//						if (jsonData.info == 'RepName')
//							message = '输入的名称已经存在!';
						Ext.Msg.show({
									title : '错误',
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
			addwin1.close();
		}

		// 添加取消按钮的监听事件
		cancelButton.addListener('click', cancelHandler, false);

		// 初始化窗口
		addwin1 = new Ext.Window({
					title : '添加指标记录',
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
		addwin1.show();
	}
});

// 删除按钮
var delButton = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象 BonusReportManagementCellPanel
		var rowObj = BonusReportManagementCellPanel.getSelections();
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
					url : '../csp/dhc.bonus.bonusreportmanagementexe.csp?action=delcell&rowId='
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
											limit : 20
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
var BonusReportCellTabPagingToolbar = new Ext.PagingToolbar({
	store : reportCellDs,
	pageSize : 25,
	displayInfo : true,
	displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg : "没有记录" // ,
		// buttons : ['-', BonusReportCellFilterItem, '-', BonusReportCellSearchBox]

	});

// 表格
var BonusReportManagementCellPanel = new Ext.grid.EditorGridPanel({
			title : '报表内容维护',
			region : 'center',
			store : reportCellDs,
			cm : BonusReportCellTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : [addschemeButton, '-', addtargetButton, '-', delButton],
			bbar : BonusReportCellTabPagingToolbar
		});

function afterEdit(rowObj) {

	// 定义并初始化行对象长度变量
	var len = rowObj.length;
	
	// 判断是否选择了要修改的数据
	 var rowid = rowObj.record.get("rowid");
	//var name = rowObj.record.get("name");
	//var celltype = rowObj.record.get("celltype");
	var rpindex = rowObj.record.get("rpindex");
	/*var data = name.trim() + "^" + celltype.trim() + "^"
			+ rpindex.trim();*/
	 var data = rowid.trim() + "^" + rpindex.trim();
	
	Ext.Ajax.request({
		url : BonusReportCellTabUrl + '?action=editcell&rowId=' + rowid
				+ '&rpindex=' + rpindex ,	
		failure : function(result, request) {
			Ext.Msg.show({
						title : '错误',
						msg : '请检查网络连接!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// Ext.Msg.show({title:'注意',msg:'添加成功!',buttons:
				// Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				reportCellDs.load({
					params : {
						rowID : BonusReportMainRowId,
						start : 0,
						limit : 20
					}
				});
				this.store.commitChanges(); // 还原数据修改提

				var view = BonusReportManagementCellPanel.getView();
				// view.focusCell(tmpRow, tmpColumn);

			} else {
				Ext.Msg.show({
							title : '错误',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			}
		},
		scope : this
	});
}

BonusReportManagementCellPanel.on("afteredit", afterEdit, BonusReportManagementCellPanel);




