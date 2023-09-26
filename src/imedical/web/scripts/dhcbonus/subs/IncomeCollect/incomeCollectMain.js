var incomecollectUrl = 'dhc.bonus.subincomecollectexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : incomecollectUrl + '?action=list'
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
		// url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
		url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=2',
		method : 'POST'
	})
});

var locSetField = new Ext.form.ComboBox({
			id : 'locSetField',
			fieldLabel : '接口类别:',
			width : 100,
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
			width : 100,
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

var IncomeCollect = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['IncomeItemCode', 'IncomeItemName', 'BonusYear',
							'BonusPeriod', 'MakeBillDeptCode',
							'MakeBillDeptName', 'ExecuteDeptCode',
							'ExecuteDeptName', 'SickDeptCode', 'SickDeptName',
							'ChiefDoctorCode', 'ChiefDoctorName',
							'MakeBillDoctorCode', 'MakeBillDoctorName',
							'ExecuteDoctorCode', 'ExecuteDoctorName',
							'SickType', 'ExpensesType', 'IncomeMoney', 'State',
							'InterLocMethodID', 'UpdateDate','methodDesc','InterLocSetname'

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

				importExcel('incomeCollect');

				return;

			}

		});
		
IncomeCollect.setDefaultSort('rowid', 'DESC');

var collectDataButton = new Ext.Toolbar.Button({
	text : '数据采集',
	tooltip : '数据采集',
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
		var status = IncomeCollectMain.getStore().find('status', '采集成功')
		var status2 = IncomeCollectMain.getStore().find('status', '导入成功')
		if (status >= 0) {
			stext = "数据已经采集，确定要重新采集该条件下的数据吗?"
		} else if (status2 >= 0) {
			stext = "数据已经导入，确定要重新采集该条件下的数据吗?"
		} else {
			stext = "确定要采集该条件的指标数据吗?"
		}
		Ext.MessageBox.confirm('提示', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : incomecollectUrl + '?action=collect&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr+ '&DataType=2',
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
												msg : locSetName + '下指标数据采集完成！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									findData()
									// 更新程序
								} else {
									
									Ext.Msg.show({
												title : '提示',
												msg : '指标数据导入失败！',
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
							url : incomecollectUrl + '?action=del&CycleDr='
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
var queryButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls : 'add',
			handler : function() {
				// alert(btnField.getValue().trim());
				findData()
		
			}
		});

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


var OutKPIDataCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),

{
			header : " 接口套",
			dataIndex : 'InterLocSetname',
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : " 接口方法",
			dataIndex : 'methodDesc',
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : '项目编码',
			dataIndex : 'IncomeItemCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '项目名称',
			dataIndex : 'IncomeItemName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : " 核算年度",
			dataIndex : 'BonusYear',
			width : 80,
			align : 'center',
			sortable : true
		}, {
			header : " 核算期间",
			dataIndex : 'BonusPeriod',
			width : 70,
			align : 'center',
			sortable : true
		}, {
			header : '开单科室编码',
			dataIndex : 'MakeBillDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '开单科室名称',
			dataIndex : 'MakeBillDeptName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '执行科室编码',
			dataIndex : 'ExecuteDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '执行科室名称',
			dataIndex : 'ExecuteDeptName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '病人科室编码',
			dataIndex : 'SickDeptCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '病人科室名称',
			dataIndex : 'SickDeptName',
			width : 100,
			align : 'right',
			sortable : true

		}, {
			header : '主治医生编码',
			dataIndex : 'ChiefDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '主治医生姓名',
			dataIndex : 'ChiefDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '开单医生编码',
			dataIndex : 'MakeBillDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '开单医生姓名',
			dataIndex : 'MakeBillDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '执行医生编码',
			dataIndex : 'ExecuteDoctorCode',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '执行医生名称',
			dataIndex : 'ExecuteDoctorName',
			width : 80,
			align : 'right',
			sortable : true

		}, {
			header : '患者类别',
			dataIndex : 'SickType',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '费用类别',
			dataIndex : 'ExpensesType',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '收入金额',
			dataIndex : 'IncomeMoney',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '数据状态',
			dataIndex : 'status',
			width : 70,
			align : 'right',
			sortable : true

		}, {
			header : '采集时间',
			dataIndex : 'UpdateDate',
			width : 80,
			align : 'right',
			sortable : true

		}]);


var OutKPIDataSearchField = 'outUnitName';

var OutKPIDataFilterItem = new Ext.SplitButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '外部单位代码',
									value : 'outUnitCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '外部单位名称',
									value : 'outUnitName',
									checked : true,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '外部单位所属科室代码',
									value : 'outUnitLocCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '外部单位所属科室名称',
									value : 'outUnitLocName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '外部指标代码',
									value : 'outKpiCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '外部指标名称',
									value : 'outKpiName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '指标实际值',
									value : 'actValue',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '处理标志',
									value : 'handFlag',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								})]
			}
		});

function onOutKPIDataItemCheck(item, checked) {
	if (checked) {
		OutKPIDataSearchField = item.value;
		OutKPIDataFilterItem.setText(item.text + ':');
	}
};

var OutKPIDataSearchBox = new Ext.form.TwinTriggerField({// 查找按钮
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
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			IncomeCollect.proxy = new Ext.data.HttpProxy({
						url : incomecollectUrl + '?action=list&searchField='
								+ OutKPIDataSearchField + '&searchValue='
								+ this.getValue() + '&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			IncomeCollect.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	}
});
IncomeCollect.each(function(record) {
			alert(record.get('tieOff'));

		});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : IncomeCollect,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据"
	//buttons : ['-', OutKPIDataFilterItem, '-', OutKPIDataSearchBox]
});

var IncomeCollectMain = new Ext.grid.GridPanel({// 表格
	title : '收入数据采集',
	store : IncomeCollect,
	cm : OutKPIDataCm,
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
	tbar : ['采集期间:', cycleField, '-', periodTypeField, '-', periodField, '-',
			'接口类别:', locSetField, '-', '接口方法:', interMethodField, '-',
			queryButton,'-',collectDataButton, '-', uploadButton, '-', delButton],
	bbar : OutKPIDataPagingToolbar

});

interMethodField.on('select', function(cmb, rec, id) {

			//findData()
		});
periodField.on('select', function(cmb, rec, id) {

			//findData()
		});
locSetField.on('select', function(cmb, rec, id) {
			//findData()
		});

function findData() {
	var locSetDr = Ext.getCmp('locSetField').getValue();
	var interMethodDr = Ext.getCmp('interMethodField').getValue();

	var surl = ''
	if (interMethodDr == '') {
		surl = incomecollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
	} else {
		surl = incomecollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
				+ '&interMethodDr=' + interMethodDr
	}
	// prompt('surl',surl)

	IncomeCollect.proxy = new Ext.data.HttpProxy({
		url : surl
			// ,method : 'POST'
		});
	IncomeCollect.load({
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

function getImportStatus() {
	var locSetDr = Ext.getCmp('locSetField').getValue();
	var locSetName = Ext.getCmp('locSetField').getRawValue();
	var cycleDr = Ext.getCmp('cycleField').getValue();
	var interMethodDr = Ext.getCmp('interMethodField').getValue();
	var periodType = Ext.getCmp('periodTypeField').getValue();
	var period = Ext.getCmp('periodField').getValue();

	var rtnStatus = '-1'

	Ext.Ajax.request({
				url : incomecollectUrl + '?action=ImportStatus&CycleDr=' + cycleDr
						+ '&interMethodDr=' + interMethodDr + '&period='
						+ periodType + period + '&locSetDr=' + locSetDr,
				waitMsg : '进行中...',
				failure : function(result, request) {
					rtnStatus = "-2"
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					rtnStatus = jsonData.success
					prompt('aaa', rtnStatus)
					// return rtnStatus;
				},
				scope : this
			});
	prompt('bbb', rtnStatus)
	return rtnStatus;
}
IncomeCollect.load({
			params : {
				start : 0,
				limit : OutKPIDataPagingToolbar.pageSize
			}
		});
