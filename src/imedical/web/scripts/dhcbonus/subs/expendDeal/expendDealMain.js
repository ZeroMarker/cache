var expenddealUrl = 'dhc.bonus.subexpenddealexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : expenddealUrl + '?action=list'
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

cycleDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
				method : 'POST'
			})
});

var cycleField = new Ext.form.ComboBox({
			id : 'cycleField',
			fieldLabel : '考核周期',
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : cycleDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '年度',
			name : 'cycleField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月'], ['Q', '季'], ['H', '半年'], ['Y', '年']]
		});
var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			selectOnFocus : true,
			width : 70,
			listWidth : 150,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '期间类型',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
				['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
				['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['01', '01季度'], ['02', '02季度'], ['03', '03季度'], ['04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['01', '1~6上半年'], ['02', '7~12下半年']];
	}
	if (cmb.getValue() == "Y") {
		data = [['00', '全年']];
	}
	periodStore.loadData(data);
});
periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '',
			selectOnFocus : true,
			allowBlank : false,
			width : 70,
			listWidth : 150,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '期间',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var locSetDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name', 'shortcut'])
		});

locSetDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=3',
		method : 'POST'
	})
});

var locSetField = new Ext.form.ComboBox({
			id : 'locSetField',
			fieldLabel : '接口套:',
			width : 150,
			listWidth : 150,
			allowBlank : false,
			store : locSetDs,
			valueField : 'rowid',
			displayField : 'shortcut',
			triggerAction : 'all',
			emptyText : '',
			name : 'locSetField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var interMedthodDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

interMedthodDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
						+ locSetField.getValue() + '&start=0&limit=10',
				method : 'POST'
			})
});
locSetField.on("select", function(cmb, rec, id) {

			interMedthodDs.load({
						params : {
							interLocSetDr : Ext.getCmp('locSetField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var interMethodField = new Ext.form.ComboBox({
			id : 'interMethodField',
			fieldLabel : '接口方法',
			width : 150,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : interMedthodDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'interMethodField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var ExpendDealStore = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowID', 'BonusUnitName', 'BonusTargetName',
							'BonusYear', 'BonusPeriod', 'ExcuteUnitName',
							'CalculateUnit', 'ItemValue','ItemRate', 'ItemResult',
							'State', 'InterLocSet', 'InterLocMethod','UpdateDate'

					]),
			// turn on remote sorting
			remoteSort : true
		});
// 初始化按钮
var uploadButton = new Ext.Toolbar.Button({
			text : 'Excel数据导入',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel('ExpendDealStore');

				return;

			}

		});

ExpendDealStore.setDefaultSort('rowid', 'DESC');

var DealDataButton = new Ext.Toolbar.Button({
	text : '数据计提',
	tooltip : '数据计提',
	iconCls : 'add',
	handler : function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择年度!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var periodType = Ext.getCmp('periodTypeField').getValue();
		if (periodType == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择区间类别!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var period = Ext.getCmp('periodField').getValue();
		if (period == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择区间!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var locSetDr = Ext.getCmp('locSetField').getValue();
		var locSetName = Ext.getCmp('locSetField').getRawValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();

		if (locSetDr == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择接口套!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		var ss = IncomeCollectMain.getStore().getCount()

		var stext = ""
		// var status=
		// IncomeCollectMain.getStore().getById(1).get('status').toString()
		var status = IncomeCollectMain.getStore().find('State', '计提成功')
		var status2 = IncomeCollectMain.getStore().find('State', '导入成功')
		if (status >= 0) {
			stext = "数据已经计提，确定要重新计提该条件下的数据吗?"
		} else if (status2 >= 0) {
			stext = "数据已经导入，确定要重新采集该条件下的数据吗?"
		} else {
			stext = "确定要计提该条件的指标数据吗?"
		}
		Ext.MessageBox.confirm('提示', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expenddealUrl + '?action=deal&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr,
							waitMsg : '导入中...',
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
								if (jsonData.success == '0') {
									Ext.Msg.show({
												title : '提示',
												msg : locSetName + '下指标数据计提成功！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									findData()
									// 更新程序
								} else {
									Ext.Msg.show({
												title : '提示',
												msg : '指标数据计提失败！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								}
							},
							scope : this
						});
			}
		});

	}
});

var delButton = new Ext.Toolbar.Button({
	text : '数据删除',
	tooltip : '数据删除',
	iconCls : 'add',
	handler : function() {
		var cycleDr = Ext.getCmp('cycleField').getValue();
		if (cycleDr == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择年度!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var periodType = Ext.getCmp('periodTypeField').getValue();
		if (periodType == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择区间类别!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var period = Ext.getCmp('periodField').getValue();
		if (period == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择区间!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}
		var locSetDr = Ext.getCmp('locSetField').getValue();
		var locSetName = Ext.getCmp('locSetField').getRawValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();

		if (locSetDr == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择接口套!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		Ext.MessageBox.confirm('提示', '确定要删除该条件下的指标数据吗?', function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expenddealUrl + '?action=del&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr,
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
								if (jsonData.success == '0') {
									Ext.Msg.show({
												title : '提示',
												msg : locSetName + '下指标数据删除成功！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									findData()
									// 更新程序
								} else {
									Ext.Msg.show({
												title : '提示',
												msg : '指标数据删除失败！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
								}
							},
							scope : this
						});
			}
		});
	}
});
/*
Ext.grid.CheckColumn = function(config) {
	Ext.apply(this, config);
	if (!this.id) {
		this.id = Ext.id();
	}
	this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
	init : function(grid) {
		this.grid = grid;
		this.grid.on('render', function() {
					var view = this.grid.getView();
					view.mainBody.on('mousedown', this.onMouseDown, this);
				}, this);
	},

	onMouseDown : function(e, t) {
		if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
			e.stopEvent();
			var index = this.grid.getView().findRowIndex(t);
			var cindex = this.grid.getView().findCellIndex(t);
			var record = this.grid.store.getAt(index);
			var field = this.grid.colModel.getDataIndex(cindex);
			var e = {
				grid : this.grid,
				record : record,
				field : field,
				originalValue : record.data[this.dataIndex],
				value : !record.data[this.dataIndex],
				row : index,
				column : cindex,
				cancel : false
			};
			if (this.grid.fireEvent("validateedit", e) !== false && !e.cancel) {
				delete e.cancel;
				record.set(this.dataIndex, !record.data[this.dataIndex]);
				this.grid.fireEvent("afteredit", e);
			}
		}
	},

	renderer : function(v, p, record) {
		p.css += ' x-grid3-check-col-td';
		return '<div class="x-grid3-check-col' + (v ? '-on' : '')
				+ ' x-grid3-cc-' + this.id + '">&#160;</div>';
	}
};
*/
var ExpendDealCM = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),

{
			header : " 接口套",
			dataIndex : 'InterLocSet',
			width : 120,
			align : 'center',
			sortable : true
		}, {
			header : " 接口方法",
			dataIndex : 'InterLocMethod',
			width : 120,
			align : 'center',
			sortable : true
		}, {
			header : " 核算年度",
			dataIndex : 'BonusYear',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : " 核算期间",
			dataIndex : 'BonusPeriod',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : '核算单元',
			dataIndex : 'BonusUnitName',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '奖金指标',
			dataIndex : 'BonusTargetName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '执行科室',
			dataIndex : 'ExcuteUnitName',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '采集数值',
			dataIndex : 'ItemValue',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '计提系数',
			dataIndex : 'ItemRate',
			width : 70,
			align : 'left',
			sortable : true

		}, {
			header : '计提结果',
			dataIndex : 'ItemResult',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '计提时间',
			dataIndex : 'UpdateDate',
			width : 120,
			align : 'right',
			sortable : true

		}, {
			header : '数据状态',
			dataIndex : 'State',
			width : 70,
			align : 'right',
			sortable : true

		}]);

var OutKPIDataSearchField = 'outUnitName';

ExpendDealStore.each(function(record) {
			alert(record.get('tieOff'));

		});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : ExpendDealStore,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据"
});

var IncomeCollectMain = new Ext.grid.GridPanel({// 表格
	title : '工作量及支出数据计提处理',
	store : ExpendDealStore,
	cm : ExpendDealCM,
	trackMouseOver : true,
	region : 'center',
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	frame : true,
	// plugins:checkColumn,
	clicksToEdit : 2,
	stripeRows : true,
	tbar : ['核算期间:', cycleField, '-', periodTypeField, '-', periodField, '-',
			'接口套:', locSetField, '-', '接口方法:', interMethodField, '-',
			DealDataButton, '-', delButton],
	bbar : OutKPIDataPagingToolbar

});

interMethodField.on('select', function(cmb, rec, id) {

			findData()
		});
periodField.on('select', function(cmb, rec, id) {

			findData()
		});
locSetField.on('select', function(cmb, rec, id) {
			findData()
		});

function findData() {
	var locSetDr = Ext.getCmp('locSetField').getValue();
	var interMethodDr = Ext.getCmp('interMethodField').getValue();

	var surl = ''
	if (interMethodDr == '') {
		surl = expenddealUrl + '?action=list&CycleDr='
				+ cycleField.getValue() 
				 + '&period='+ periodTypeField.getValue()
				+ periodField.getValue() + '&locSetDr=' + locSetDr
	} else {
		surl = expenddealUrl + '?action=list&CycleDr='
				+ cycleField.getValue() + '&period='
				+ periodTypeField.getValue() + periodField.getValue()
				+ '&locSetDr=' + locSetDr + '&interMethodDr=' + interMethodDr
	}

	ExpendDealStore.proxy = new Ext.data.HttpProxy({
				url : surl

			});
	ExpendDealStore.load({
				params : {
					start : 0,
					limit : OutKPIDataPagingToolbar.pageSize
				}
			});

}
function isEdit(value, record) {
	// 向后台提交请求
	return value;
}
ExpendDealStore.load({
			params : {
				start : 0,
				limit : OutKPIDataPagingToolbar.pageSize
			}
		});
