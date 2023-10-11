var userid = session['LOGON.USERID'];

var acctbookid = GetAcctBookID();
// 定义当前科目编码录入的规则
var ParamCode = new Ext.form.TextField({
		fieldLabel: '当前编码规则:',
		id: 'ParamCode',
		width: 120,
		editable: false,
		columnWidth: .2,
		disabled: true,
		selectOnFocus: true
	});
	
		
PageSizePlugin = function() {
	PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				id:'PageSizePluginm',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
		
		
Ext.Ajax.request({
	url: 'herp.acct.acctbookparamexe.csp?action=list&acctbookid=' + acctbookid,
	waitMsg: '保存中...',
	failure: function (result, request) {
		Ext.Msg.show({
			title: '错误',
			msg: '请检查网络连接!',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	},
	success: function (result, request) {
		var resultstr = result.responseText;
		var strs = new Array();
		strs = resultstr.split("|");
		var paramcode = ParamCode.setValue(strs[2].split("^")[2]);
		//document.getElementById("paramcode").style.color="red";
		//document.getElementById("ParamCode").style.font="bold"

		/*
		ParamValue.setValue(strs[2].split("^")[2]);
		Control.setValue(strs[3].split("^")[2]);
		EditCheck.setValue(strs[4].split("^")[2]);
		ExtracteType.setValue(strs[5].split("^")[2]);
		ExtractePer.setValue(strs[6].split("^")[2]*100);
		IsGroup.setValue(strs[7].split("^")[2]);
		 */
	},
	scope: this
});

/* //获得当前系统登录用户的信息说明
var userID = session['LOGON.USERID'];
var userCode = session['LOGON.USERCODE'];
var userName = session['LOGON.USERNAME'];
 */
var itemGridUrl = '../csp/herp.acct.acctsubjserverexe.csp';
var projUrl = '../csp/herp.acct.acctsubjserverexe.csp';
//配件数据源
var itemGridProxy = new Ext.data.HttpProxy({
		url: itemGridUrl + '?action=list'
	});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'rowid',
				'BookID',
				'SubjCode',
				'SubjName',
				'Spell',
				'SubjNameAll',
				'DefineCode',
				'SuperSubjCode',
				'SubjLevel',
				'SubjTypeID',
				'SubjTypeName',
				'SubjNatureID',
				'SubjNatureName',
				'IsLast',
				'Direction',
				'IsCash',
				'IsNum',
				'NumUnit',
				'IsFc',
				'IsCheck',
				'IsStop',
				'subjGroup',
				'CashFlowID',
				'StartYear',
				'StartMonth',
				'StartYM',
				'EndYear',
				'EndtMonth',
				'EndYM',
				'IsCashFlow',
				'CashItemName'
			]),
		remoteSort: true
	});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad: true,
		plugins : new PageSizePlugin(),
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"
	});

//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');


//科目编码--查询输入框
var sjcodeField = new Ext.form.TextField({
		id: 'sjcodeField',
		fieldLabel: '科目编码',
		width: 180,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '编码模糊查询...',
		name: 'sjcodeField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					QueryButton.handler();
				}
			}
		}
	});

//科目名称--查询输入框
var sjnameField = new Ext.form.TextField({
		id: 'sjnameField ',
		fieldLabel: '科目名称',
		width: 180,
		listWidth: 245,
		triggerAction: 'all',
		emptyText: '名称模糊查询...',
		name: 'sjnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == e.ENTER) {
					QueryButton.handler();
				}
			}
		}
	});

var sjtypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

sjtypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjtypelist&str',
			method: 'POST'
		});
});

var sjtypeField = new Ext.form.ComboBox({
		id: 'sjtypeField',
		fieldLabel: '科目类别',
		width: 200,
		listWidth: 200,
		allowBlank: true,
		store: sjtypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择科目类型...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//科目性质--查询下拉框//
var sjnatureDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});

sjnatureDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjnaturelist&str',
			method: 'POST'
		});
});

var sjnatureField = new Ext.form.ComboBox({
		id: 'sjnatureField',
		fieldLabel: '科目性质',
		width: 200,
		listWidth: 200,
		allowBlank: true,
		store: sjnatureDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择科目性质...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//科目级别--查询下拉框//
var sjlevelDs = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'],
			['5', '5'], ['6', '6'], ['7', '7'], ['8', '8']
		]
	});

var sjlevelField = new Ext.form.ComboBox({
		id: 'sjlevelField',
		fieldLabel: '科目级别',
		width: 140,
		listWidth: 140,
		allowBlank: true,
		store: sjlevelDs,
		valueField: 'key',
		displayField: 'keyValue',
		triggerAction: 'all',
		emptyText: '请选择科目级别...',
		// minChars: 1,
		// pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		mode: 'local', // 本地模式
		editable: true
	});

var IsStopField = new Ext.form.Checkbox({
		id: 'IsStopField',
		labelSeparator: '是否停用:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsFcField = new Ext.form.Checkbox({
		id: 'IsFcField',
		labelSeparator: '外币核算:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsNumField = new Ext.form.Checkbox({
		id: 'IsNumField',
		labelSeparator: '数量核算:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var IsCheckField = new Ext.form.Checkbox({
		id: 'IsCheckField',
		labelSeparator: '科室应用:',
		style: 'border:0;background:none;margin-top:0px;',
		allowBlank: false
	});

var startDate = new Ext.form.DateField({
		id: 'startDate',
		format: 'Y-m',
		width: 140,
		emptyText: '',
		plugins: 'monthPickerPlugin'
	});

//查询按钮
var QueryButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 55,
		handler: function () {
			var sjcode = sjcodeField.getValue();
			var sjname = sjnameField.getValue();
			var sjlevel = sjlevelField.getValue();
			var sjnature = sjnatureField.getValue();
			var sjtype = sjtypeField.getValue();
			var IsStop = (IsStopField.getValue() == true) ? '1' : '0';
			var IsCheck = (IsCheckField.getValue() == true) ? '1' : '0';
			var IsFc = (IsFcField.getValue() == true) ? '1' : '0';
			var IsNum = (IsNumField.getValue() == true) ? '1' : '0';
			var startTime = startDate.getValue();
			if (startTime !== "") {
				startTime = startTime.format('Y-m');
			}

			itemGridDs.proxy = new Ext.data.HttpProxy({
					url: itemGridUrl + '?action=list&sjcode=' + sjcode + '&sjname=' + encodeURIComponent(sjname) + '&acctbookid=' + acctbookid
					 + '&sjlevel=' + sjlevel + '&sjnature=' + sjnature + '&sjtype=' + sjtype + '&IsStop=' + IsStop + '&IsCheck=' + IsCheck + '&IsFc=' + IsFc + '&IsNum=' + IsNum + '&startDate=' + startTime
				});
				
			var limits=Ext.getCmp("PageSizePluginm").getValue();
			 //alert(limits);
	         if(!limits){limits=25};	
			itemGridDs.load(({
					params: {
						start: 0,
						limit: limits
					}
				}));
		}
	});

var addButton = new Ext.Toolbar.Button({
		text: '添加',
		tooltip: '添加',
		iconCls: 'add',
		handler: function () {
			addFun();
		}
	});

var exportExcel = new Ext.Toolbar.Button({
		text: '导出',
		tooltip: '导出',
		iconCls: 'down',
		handler: function () {
			ExportAllToExcel(itemGrid,"D:\\会计科目.xls");
		}
	});
	
var editButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改',
		iconCls: 'edit ',
		handler: function () {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len < 1) {
				Ext.Msg.show({
					title: '注意',
					msg: '请选择需要修改的数据!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			} else if (len == 1) {
				for (var i = 0; i < len; i++) {
					editFun();
				}

			} else {
				Ext.Msg.show({
					title: '注意',
					msg: '选择需要修改的数据过多!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
				return;
			}
		}
	});

var delButton = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			delFun();
		}
	});

var importButton = new Ext.Toolbar.Button({
		text: '导入Excel模板',
		tooltip: '导入',
		iconCls: 'in',
		handler: function () {
			doimport();
		}
	});

var reloadButton = new Ext.Toolbar.Button({
		text: '同步科目属性<span style="color:green;cursor:hand">(编辑或导入科目后请单击)</span>',
		tooltip: '用于编辑或导入功能后,同步科目相关属性',
		iconCls: 'reload ',
		handler: function () {
			reloadFun();
		}
	});

//查询面板
var queryPanel = new Ext.FormPanel({
		height: 85,
		region: 'north',
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '科目编码',
						style: 'line-height: 20px;',
						width: 60
					},
					sjcodeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '科目类型',
						style: 'line-height: 20px;',
						width: 60
					},
					sjtypeField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: ' 科目级别',
						style: 'line-height: 20px;',
						width: 60
					},sjlevelField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},IsStopField, {
						xtype: 'displayfield',
						value: '科目停用 ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},IsCheckField, {
						xtype: 'displayfield',
						value: '辅助核算 ',
						//style: 'padding-top:5px;',
						width: 60
					},{
						xtype: 'displayfield',
						value: '',
						width: 30
					}
				]
			}, {
				columnWidth: 1,
				xtype: 'panel',
				layout: "column",
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '科目名称',
						style: 'line-heigth:22px',
						width: 60
					},
					sjnameField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '科目性质',
						style: 'line-heigth:22px',
						width: 60
					},
					sjnatureField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, {
						xtype: 'displayfield',
						value: '设立时间',
						style: 'line-height: 20px;',
						width: 60
					},startDate,
					 {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					IsFcField, {
						xtype: 'displayfield',
						value: '外币核算 ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					},
					IsNumField, {
						xtype: 'displayfield',
						value: '数量核算 ',
						//style: 'padding-top:5px;',
						width: 60
					}, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, QueryButton
				]
			}
		]
	});

//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				id: 'rowid',
				header: 'id',
				dataIndex: 'rowid',
				width: 50,
				hidden: true,
				align: 'center',
				sortable: true
			}, {
				id: 'BookID',
				header: '<div style="text-align:center">账套编码</div>',
				dataIndex: 'BookID',
				width: 60,
				hidden: true,
				sortable: true
			}, {
				id: 'SubjCode',
				header: '科目编码',
				dataIndex: 'SubjCode',
				width: 160,
				sortable: true
			}, {
				id: 'SubjName',
				header: '科目名称',
				dataIndex: 'SubjName',
				width: 280,
				align: 'left',
				sortable: true
			}, {
				id: 'SubjNameAll',
				header: '科目全称',
				dataIndex: 'SubjNameAll',
				hidden: true,
				width: 200,
				sortable: true
			}, {
				id: 'SubjLevel',
				header: '科目级别',
				dataIndex: 'SubjLevel',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'SuperSubjCode',
				header: '上级编码',
				dataIndex: 'SuperSubjCode',
				width: 70,
				hidden: true,
				align: 'left',
				sortable: true
			}, {
				id: 'IsLast',
				header: '是否末级',
				dataIndex: 'IsLast',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'Direction',
				header: '借贷方向',
				dataIndex: 'Direction',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				id: 'SubjTypeID',
				header: '类别ID',
				dataIndex: 'SubjTypeID',
				width: 70,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'SubjTypeName',
				header: '科目类别',
				dataIndex: 'SubjTypeName',
				align: 'center',
				width: 90,
				sortable: true
			}, {
				id: 'SubjNatureID',
				header: '性质ID',
				dataIndex: 'SubjNatureID',
				width: 70,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'SubjNatureName',
				header: '科目性质',
				dataIndex: 'SubjNatureName',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				id: 'IsStop',
				header: '是否停用',
				width: 70,
				align: 'center',
				dataIndex: 'IsStop'
			}, {
				id: 'IsCheck',
				header: '辅助账',
				width: 60,
				align: 'center',
				//hidden: true,
				dataIndex: 'IsCheck'
			}, {
				id: 'IsFc',
				header: '外币账',
				width: 60,
				align: 'center',
				dataIndex: 'IsFc'
			}, {
				id: 'IsNum',
				header: '数量账',
				width: 60,
				align: 'center',
				dataIndex: 'IsNum'
			}, {
				id: 'StartYM',
				header: '启用年月',
				width: 80,
				align: 'center',
				//hidden: true,
				dataIndex: 'StartYM'
			}, {
				id: 'EndYM',
				header: '停用年月',
				width: 80,
				align: 'center',
				dataIndex: 'EndYM'
			}, {
				id: 'Spell',
				header: '拼音码',
				dataIndex: 'Spell',
				width: 60,
				hidden: true,
				sortable: true
			}, {
				id: 'DefineCode',
				header: '自定义...',
				dataIndex: 'DefineCode',
				width: 60,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'IsCash',
				header: '现金银行标志',
				dataIndex: 'IsCash',
				width: 80,
				align: 'center',
				hidden: true,
				sortable: true
			}, {
				id: 'NumUnit',
				header: '计量单位',
				width: 60,
				align: 'center',
				hidden: true,
				dataIndex: 'NumUnit'
			}, {
				id: 'subjGroup',
				header: '科目分组',
				width: 100,
				align: 'center',
				hidden: true,
				dataIndex: 'subjGroup'
			}, {
				id: 'CashFlowID',
				header: '现金流量项ID',
				width: 100,
				align: 'center',
				hidden: true,
				dataIndex: 'CashFlowID'
			}, {
				id: 'IsCashFlow',
				header: '是否现金流量',
				width: 80,
				align: 'center',
				hidden: true,
				dataIndex: 'IsCashFlow'
			}, {
				id: 'CashItemName',
				header: '现金流量项内容',
				width: 150,
				align: 'center',
				hidden: true,
				dataIndex: 'CashItemName'
			}

		]);

//初始化默认排序功能
itemGridCm.defaultSortable = true;

//表格
var itemGrid = new Ext.grid.GridPanel({
		title: '会计科目列表',
		iconCls: 'list',
		region: 'center',
		layout: 'fit',
		width: 750,
		readerModel: 'local',
		url: 'herp.acct.acctsubjserverexe.csp',
		//atLoad : true, // 是否自动刷新
		store: itemGridDs,
		cm: itemGridCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel({
			singleSelect: false
		}),
		loadMask: true,
		tbar: [addButton, '-', editButton, '-', delButton, '-', importButton, '-', '<span style="color:red;cursor:hand">' + "当前编码规则:" + '&nbsp;' + '</span>', ParamCode, '-', reloadButton, ""],
		bbar: itemGridPagingToolbar
	});
itemGridDs.load({
	params: {
		start: 0,
		limit: itemGridPagingToolbar.pageSize
	},
	callback: function (record, options, success) {
		//itemGrid.fireEvent('rowclick',this,0);
	}
});

//--------------------------------辅助核算相关------------------------------------------//

//核算类别
var vCheckTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'
		}, ['rowid', 'code', 'name'])
	});
vCheckTypeDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=sjchecktypelist&str',
			method: 'POST'
		});
});
var CheckTypeName = new Ext.form.ComboBox({
		id: 'CheckTypeName',
		fieldLabel: '辅助核算类别',
		width: 180,
		listWidth: 265,
		allowBlank: true,
		store: vCheckTypeDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText: '请选择...',
		minChars: 1,
		pageSize: 10,
		selectOnFocus: true,
		forceSelection: 'true',
		editable: true
	});

//启用年月
var CheckSYear = new Ext.form.TextField({
		fieldLabel: '辅助项启用年',
		width: 180,
		value: new Date().format('Y'),
		selectOnFocus: 'true'
	});
//new Date().format('Y');

//
//启用月份
var StartMonthStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			["01", '1月'], ["02", '2月'], ['03', '3月'], ['04', '4月'],
			['05', '5月'], ['06', '6月'], ['07', '7月'], ['08', '8月'],
			['09', '9月'], ['10', '10月'], ['11', '11月'], ['12', '12月']
		]
	});
var CheckSMonth = new Ext.form.ComboBox({
		id: 'CheckSMonth',
		fieldLabel: '辅助项启用月',
		width: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: StartMonthStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		editable: true,
		selectOnFocus: true,
		forceSelection: true
	});
/*
//是否停用
var CheckIsStop = new Ext.form.Checkbox({
id : 'CheckIsStop',
fieldLabel: '辅助是否停用',
allowBlank : false,
listeners : {
check: function (obj, vIsStop) {
if (vIsStop) {
CheckFieldSet.disable();
} else {
CheckFieldSet.enable();
}
}
}
});
 */
var IsStopStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [['1', '是'], ['0', '否']]
	});
var CheckIsStop = new Ext.form.ComboBox({
		id: 'CheckIsStop',
		fieldLabel: '辅助账是否停用',
		width: 180,
		selectOnFocus: true,
		allowBlank: true,
		store: IsStopStore,
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		editable: false,
		value: 0,
		selectOnFocus: true,
		forceSelection: true
	});

var CheckEYear = new Ext.form.TextField({
		fieldLabel: '辅助项停用年',
		width: 180,
		selectOnFocus: true
	});

//停用月份
var vEndMonthStore = new Ext.data.SimpleStore({
		fields: ['key', 'keyValue'],
		data: [
			['01', '1月'], ['02', '2月'], ['03', '3月'], ['04', '4月'],
			['05', '5月'], ['06', '6月'], ['07', '7月'], ['08', '8月'],
			['09', '9月'], ['10', '10月'], ['11', '11月'], ['12', '12月']
		]
	});
var CheckEMonth = new Ext.form.ComboBox({
		id: 'CheckEMonth',
		fieldLabel: '辅助项停止月',
		width: 180,
		listWidth: 80,
		selectOnFocus: true,
		allowBlank: true,
		store: vEndMonthStore,
		//anchor : '95%',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		mode: 'local', // 本地模式
		editable: true,
		//value:01,
		selectOnFocus: true,
		forceSelection: true
	});

//删除按钮
var delButton1 = new Ext.Toolbar.Button({
		text: '删除',
		tooltip: '删除',
		iconCls: 'remove',
		handler: function () {
			CheckitemGrid.del();
		}
	});

//增加按钮
var addButton1 = new Ext.Toolbar.Button({
		text: '增加',
		tooltip: '增加', //悬停提示
		iconCls: 'add',
		handler: function () {
			CheckitemGrid.add();
		}
	});

//保存按钮
var saveButton1 = new Ext.Toolbar.Button({
		text: '保存',
		tooltip: '保存更改',
		iconCls: 'save',
		handler: function () {
			//调用保存函数
			CheckitemGrid.save();
		}
	});

//单击事件
itemGrid.on('rowclick', function (grid, rowIndex, e) {
	var selectedRow = itemGridDs.data.items[rowIndex];
	var rowid = selectedRow.data['rowid'];
	var IsCheck = selectedRow.data['IsCheck'];
	if (IsCheck == "否") {
		CheckitemGrid.disable();
	} else {
		CheckitemGrid.enable();
	};
	CheckitemGrid.store.proxy = new Ext.data.HttpProxy({
			url: projUrl + '?action=listcheck&rowid=' + rowid
		});
	CheckitemGrid.load({
		params: {
			start: 0,
			limit: 25
		}
	});

});

var CheckitemGrid = new dhc.herp.Grid({
		title: '相应辅助账列表',
		iconCls: 'list',
		width: 425,
		split: true,
		region: 'east',
		tbar: [addButton1, '-', saveButton1, '-', delButton1, '-'],
		url: projUrl,
		atLoad: true,
		collapsible: true,
		fields: [
			new Ext.grid.CheckboxSelectionModel({
				editable: false
			}), {
				header: 'ID',
				dataIndex: 'CheckMaprowid',
				hidden: true
			}, {
				id: 'CheckTypeID',
				header: '<div style="text-align:center">辅助类型ID</div>',
				align: 'center',
				dataIndex: 'CheckTypeID',
				hidden: true
			}, {
				id: 'CheckTypeName',
				header: '<div style="text-align:center">辅助类型</div>',
				width: 100,
				align: 'center',
				type: CheckTypeName,
				dataIndex: 'CheckTypeName'
			}, {
				id: 'CheckSYear',
				header: '<div style="text-align:center">启用年</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckSYear'
			}, {
				id: 'CheckSMonth',
				header: '<div style="text-align:center">启用月</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				type: CheckSMonth,
				dataIndex: 'CheckSMonth'
			}, {
				id: 'CheckIsStop',
				header: '<div style="text-align:center">是否停用</div>',
				width: 70,
				align: 'center',
				allowBlank: true,
				type: CheckIsStop,
				dataIndex: 'CheckIsStop'
			}, {
				id: 'CheckEYear',
				header: '<div style="text-align:center">停用年</div>',
				width: 50,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckEYear'
			}, {
				id: 'CheckEMonth',
				header: '<div style="text-align:center">停用月</div>',
				width: 50,
				type: CheckEMonth,
				align: 'center',
				allowBlank: true,
				dataIndex: 'CheckEMonth'
			}
		]
	});

CheckitemGrid.btnResetHide(); //隐藏重置按钮
CheckitemGrid.btnPrintHide(); //隐藏打印按钮
CheckitemGrid.btnAddHide(); //隐藏按钮
CheckitemGrid.btnSaveHide(); //隐藏按钮
CheckitemGrid.btnDeleteHide();
var acctbookid = IsExistAcctBook(); //判断当前账套是否存在

//var   acctbookid=IsExistAcctBook(); //判断当前账套是否存在
