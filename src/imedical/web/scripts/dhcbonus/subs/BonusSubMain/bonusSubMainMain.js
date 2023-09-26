var expendcollectUrl = 'dhc.bonus.subimportdataexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : expendcollectUrl + '?action=list'
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

var targetTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '收入指标'], ['2', '工作量指标'], ['3', '支出指标']]
		});

var targetTypeField = new Ext.form.ComboBox({
			id : 'targetTypeField',
			fieldLabel : '指标类别:',
			width : 150,
			listWidth : 150,
			allowBlank : false,
			// store : locSetDs,
			store : targetTypeStore,
			valueField : 'key',
			displayField : 'keyValue',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			name : 'targetTypeField',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

var targeListDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

targeListDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : expendcollectUrl
								+ '?action=targetList&subItemType='
								+ targetTypeField.getValue()
								+ '&start=0&limit=10',
						method : 'POST'
					})
		});
targetTypeField.on("select", function(cmb, rec, id) {

			targeListDs.load({
						params : {
							subItemType : Ext.getCmp('targetTypeField')
									.getValue(),
							start : 0,
							limit : 10
						}
					});
		});
var bonusTargetField = new Ext.form.ComboBox({
			id : 'bonusTargetField',
			fieldLabel : '奖金指标',
			width : 150,
			height : 200,
			listWidth : 200,
			allowBlank : false,
			store : targeListDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'bonusTargetField',
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
					}, ['rowid', 'BonusUnitID', 'BonusUnitName',
							'BonusTargetID', 'BonusTargetName', 'BonusYear',
							'BonusPeriod', 'BonusValue', 'DataType',
							'UpadeDate'

					]),

			remoteSort : true
		});

IncomeCollect.setDefaultSort('rowid', 'DESC');
// 导入按钮
var excelButton = new Ext.Toolbar.Button({
			text : '导入Excel数据',
			tooltip : '导入Excel数据',
			iconCls : 'add',
			handler : function() {
				importExcel('expendCollect')
			}

		});

var importButton = new Ext.Toolbar.Button({
	text : '数据导入',
	tooltip : '数据导入',
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
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '请选择接口套!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		}

		var status2 = IncomeCollectMain.getStore().find('status', '导入成功')
		var stext = ""
		if (status2 >= 0) {
			stext = "数据已经导入，确定要重新导入该条件下的数据吗?"
		} else {
			stext = "确定要导入该条件的指标数据吗?"
		}
		var spr = expendcollectUrl + '?action=import&CycleDr=' + cycleDr
				+ '&bonusTarget=' + bonusTarget + '&period=' + periodType
				+ period + '&targetType=' + targetType
		// alert(spr);
		// TargetType,TargetID
		Ext.MessageBox.confirm('提示', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : expendcollectUrl + '?action=import&CycleDr='
									+ cycleDr + '&period=' + periodType
									+ period + '&TargetType=' + targetType
									+ '&TargetID=' + bonusTarget,
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

									findData();
									Ext.Msg.show({
												title : '提示',
												msg : locSetName + '下指标数据导入成功！',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});

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
//
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
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
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
							url : expendcollectUrl + '?action=collect&CycleDr='
									+ cycleDr + '&bonusTarget=' + bonusTarget
									+ '&period=' + periodType + period
									+ '&targetType=' + targetType
									+ '&DataType=3',
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
												msg : locSetName + '下指标数据导入成功！',
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
		var targetType = Ext.getCmp('targetTypeField').getValue();
		var locSetName = Ext.getCmp('targetTypeField').getRawValue();
		var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

		if (targetType == "") {
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
							url : expendcollectUrl + '?action=del&CycleDr='
									+ cycleDr + '&period=' + periodType
									+ period + '&TargetType=' + targetType,
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
// "rowid^BonusUnitID^BonusUnitName^BonusTargetID^BonusTargetName^BonusYear^BonusPeriod^BonusValue^DataType^UpadeDate"

var subMainCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
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
			header : '核算单元',
			dataIndex : 'BonusUnitName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '奖金指标',
			dataIndex : 'BonusTargetName',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '指标值',
			dataIndex : 'BonusValue',
			width : 100,
			align : 'left',
			sortable : true

		}, {//
			header : '数据类型',
			dataIndex : 'DataType',
			width : 100,
			align : 'left',
			sortable : true

		}, {
			header : '导入时间',
			dataIndex : 'UpadeDate',
			width : 150,
			align : 'left',
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
						url : expendcollectUrl + '?action=list&CycleDr='
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
						url : expendcollectUrl + '?action=list&searchField='
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
		// buttons : ['-', OutKPIDataFilterItem, '-', OutKPIDataSearchBox]
});

var IncomeCollectMain = new Ext.grid.GridPanel({// 表格
	title : '核算数据导入',
	store : IncomeCollect,
	cm : subMainCm,
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
			'指标类别:', targetTypeField, '-', importButton, '-', delButton],
	bbar : OutKPIDataPagingToolbar

});
// , '奖金指标:', bonusTargetField, '-'

bonusTargetField.on('select', function(cmb, rec, id) {

			findData()
		});
periodField.on('select', function(cmb, rec, id) {

			findData()
		});
targetTypeField.on('select', function(cmb, rec, id) {
			findData()
		});

function findData() {
	var targetType = Ext.getCmp('targetTypeField').getValue();
	var bonusTarget = Ext.getCmp('bonusTargetField').getValue();

	var surl = ''
	surl = expendcollectUrl + '?action=list&CycleDr=' + cycleField.getValue()
			+ '&frequency=' + periodTypeField.getValue() + '&period='
			+ periodField.getValue() + '&TargetType=' + targetType

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
	var targetType = Ext.getCmp('targetTypeField').getValue();
	var locSetName = Ext.getCmp('targetTypeField').getRawValue();
	var cycleDr = Ext.getCmp('cycleField').getValue();
	var bonusTarget = Ext.getCmp('bonusTargetField').getValue();
	var periodType = Ext.getCmp('periodTypeField').getValue();
	var period = Ext.getCmp('periodField').getValue();

	var rtnStatus = '-1'

	Ext.Ajax.request({
				url : expendcollectUrl + '?action=ImportStatus&CycleDr='
						+ cycleDr + '&bonusTarget=' + bonusTarget + '&period='
						+ periodType + period + '&targetType=' + targetType,
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
