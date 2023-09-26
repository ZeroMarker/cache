/**
 * name:tab of database author:zhaoliguo Date:2011-01-18
 */

function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}

// 配件数据源
var BonusPayTabUrl = '../csp/dhc.bonus.paymanagerexe.csp';
var BonusPayTabProxy = new Ext.data.HttpProxy({
			url : BonusPayTabUrl + '?action=list'
		});


var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月份'], ['Q', '季度'], ['H', '半年'], ['Y', '年份']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : periodTypeStore,
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
periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
				['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
				['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
				['Q04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '上半年'], ['H02', '下半年']];
	}
	if (cmb.getValue() == "Y") {
		data = [['Y00', '00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '核算期间',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : periodStore,
			anchor : '90%',
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

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : StratagemTabUrl
								+ '?action=yearlist&topCount=5&orderby=Desc',
						method : 'POST'
					})
		});

var periodYear = new Ext.form.ComboBox({
			id : 'periodYear',
			fieldLabel : '核算年度',
			width : 70,
			listWidth : 50,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodYear.on("select", function(cmb, rec, id) {

			if (Ext.getCmp('periodField').getValue() != '')
				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),

								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
		});
		
	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var bonusUnitField = new Ext.form.ComboBox({
				id : 'bonusUnitField',
				fieldLabel : '核算单元',
				width : 100,
				listWidth : 100,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDs,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	unitDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
						url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0',
							method : 'POST'
						})
			});

var BonusPayTabDs = new Ext.data.Store({
			proxy : BonusPayTabProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowID', 'BonusEmployeeID', 'EmployeeName',
							'BonusUnitID', 'BonusUnitName', 'BonusValue',
							'BonusYear', 'BonusPeriod','PeriodCode', 'UpdateDate']),

			remoteSort : true
		});

// 设置默认排序字段和排序方向

   BonusPayTabDs.setDefaultSort('rowID', 'desc');

// 数据库数据模型

var BonusPayTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : 'rowID',
			dataIndex : 'rowID',
			width : 100,
			 hidden : true,
			sortable : true
		}, {
			header : '人员ID',
			dataIndex : 'BonusEmployeeID',
			width : 100,
			hidden : true,
			sortable : true
		}, {
			header : '领取人员',
			dataIndex : 'EmployeeName',
			width : 100,
			sortable : true
		}, {
			header : "核算单元ID",
			dataIndex : 'BonusUnitID',
			width : 120,
			align : 'left',
			hidden : true,
			sortable : true
		}, {
			header : "所属核算单元",
			dataIndex : 'BonusUnitName',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "所得奖金",
			dataIndex : 'BonusValue',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "所属年度",
			dataIndex : 'BonusYear',
			width : 80,
			align : 'left',
			sortable : true
	}	, {
			header : "所属期间",
			dataIndex : 'BonusPeriod',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "所属期间Code",
			dataIndex : 'PeriodCode',
			width : 100,
			hidden : true,
			align : 'left',
			sortable : true
		}, {
			header : '发放时间',
			width : 150,
			dataIndex : 'UpdateDate'

		}]);

// 初始化默认排序功能
BonusPayTabCm.defaultSortable = true;

// 查询按钮
var findDimensType = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '数据查询',
			iconCls : 'add',
			handler : function() {

				var sbonusPeriod = Ext.getCmp('periodField').getValue();
				var sbonusYear = Ext.getCmp('periodYear').getValue();
				var sbonusUnit = Ext.getCmp('bonusUnitField').getValue();
				if (sbonusYear == "") {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择核算年度!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}
				if (sbonusPeriod == "") {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择核算期间!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				}

				BonusPayTabDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
								start : 0,
								limit : BonusPayTabPagingToolbar.pageSize
							}
						});

			}
		})

// 修改按钮
var editDimensType = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '修改奖金',
			iconCls : 'add',
			handler : function() {
				editBonus()
			}

		});
// 添加按钮
var addBonusBotton = new Ext.Toolbar.Button({
			text : '添加',
			tooltip : '添加奖金',
			iconCls : 'add',
			handler : function() {
				addBotton()
			}
		})
// 删除按钮
var delDimensType = new Ext.Toolbar.Button({
	text : '删除',
	tooltip : '删除奖金',
	iconCls : 'remove',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = BonusPay.getSelections();
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
			var rowid = rowObj[0].get("rowID");
		}
		function handler(id) {
			if (id == "yes") {
				var isInner = rowObj[0].get("isInner");
				// 判断是否是内置数据,如果是则不允许删除,否则可以被删除

				Ext.Ajax.request({
					url : '../csp/dhc.bonus.paymanagerexe.csp?action=del&rowid='
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

							// 重新加载页面
						BonusPayTabDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
								start : 0,
								limit : BonusPayTabPagingToolbar.pageSize
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

		}
		Ext.MessageBox.confirm('提示', '确实要删除该条记录吗?', handler);
	}
});


// 分页工具栏
var BonusPayTabPagingToolbar = new Ext.PagingToolbar({
			store : BonusPayTabDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录"
			// ,buttons : ['-', DimensTypeFilterItem, '-', DimensTypeSearchBox]
		});

// 表格
var BonusPay = new Ext.grid.EditorGridPanel({
			title : '人员奖金分配管理',
			store : BonusPayTabDs,
			cm : BonusPayTabCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			loadMask : true,
			tbar : ['核算年度:', periodYear, '-', '期间类型:', periodTypeField, '-',
					'核算期间:', periodField, '核算单元：','-',bonusUnitField,'-', findDimensType, '-',
					addBonusBotton, '-', editDimensType, '-', delDimensType],
			bbar : BonusPayTabPagingToolbar
		});

// 加载
BonusPayTabDs.load({
			params : {
				start : 0,
				limit : BonusPayTabPagingToolbar.pageSize
			}
		});
