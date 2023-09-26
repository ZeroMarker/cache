var OutKPIDataUrl = 'dhc.bonus.outkpidataexe.csp';
var OutKPIDataProxy = new Ext.data.HttpProxy({
			url : OutKPIDataUrl + '?action=list'
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
		url : 'dhc.bonus.outkpiruleexe.csp?action=locsetlist&searchField=type&searchValue=1',
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

var OutKPIDataDs = new Ext.data.Store({
			proxy : OutKPIDataProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'outUnitCode', 'outUnitName',
							'outUnitLocCode', 'outUnitLocName', 'unitType',
							'outKpiCode', 'outKpiName', 'period', 'periodType',
							'actValue', 'methodDesc', 'handFlag', 'status'

					]),
			// turn on remote sorting
			remoteSort : true
		});

OutKPIDataDs.setDefaultSort('rowid', 'DESC');
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

		var status2 = OutKPIDataMain.getStore().find('status', '导入成功')
		var stext = ""
		if (status2 >= 0) {
			stext = "数据已经导入，确定要重新导入该条件下的数据吗?"
		} else {
			stext = "确定要导入该条件的指标数据吗?"
		}
		var spr = OutKPIDataUrl + '?action=import&CycleDr=' + cycleDr
				+ '&interMethodDr=' + interMethodDr + '&period=' + periodType
				+ period + '&locSetDr=' + locSetDr
		// alert(spr);

		Ext.MessageBox.confirm('提示', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Ajax.request({
							url : OutKPIDataUrl + '?action=import&CycleDr='
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

		var ss = OutKPIDataMain.getStore().getCount()

		var stext = ""
		// var status=
		// OutKPIDataMain.getStore().getById(1).get('status').toString()
		var status = OutKPIDataMain.getStore().find('status', '采集成功')
		var status2 = OutKPIDataMain.getStore().find('status', '导入成功')
		if (status >= 0) {
			stext = "数据已经采集，确定要重新采集该条件下的数据吗?"
		} else if (status2 >= 0) {
			stext = "数据已经导入，确定要重新采集该条件下的数据吗?"
		} else {
			stext = "确定要采集该条件的指标数据吗?"
		}
		Ext.MessageBox.confirm('提示', stext, function(btn) {
			if (btn == 'yes') {
				Ext.Msg.show({
							title : '注意',
							msg : '数据开始采集数据，请您稍后......',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				Ext.Ajax.request({
							url : OutKPIDataUrl + '?action=collect&CycleDr='
									+ cycleDr + '&interMethodDr='
									+ interMethodDr + '&period=' + periodType
									+ period + '&locSetDr=' + locSetDr,
							waitMsg : '导入中...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '提示',
											msg : '数据采集中，请您稍后......',
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
							url : OutKPIDataUrl + '?action=del&CycleDr='
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
// 导入按钮
var excelButton = new Ext.Toolbar.Button({
			text : '导入Excel数据',
			tooltip : '导入Excel数据',
			iconCls : 'add',
			handler : function() {
				importExcel()
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
			header : " 接口方法",
			dataIndex : 'methodDesc',
			width : 100,
			align : 'center',
			sortable : true
		}, {
			header : '接口单位代码',
			dataIndex : 'outUnitCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '接口单位名称',
			dataIndex : 'outUnitName',
			width : 120,
			align : 'left',
			sortable : true

		}, {
			header : '核算单元代码',
			dataIndex : 'outUnitLocCode',
			width : 80,
			align : 'left',
			sortable : true

		}, {
			header : '核算单元名称',
			dataIndex : 'outUnitLocName',
			width : 120,
			align : 'left',
			sortable : true

		}, {
			header : '单位类别',
			dataIndex : 'unitType',
			width : 70,
			align : 'left',
			sortable : true

		}, {
			header : '指标代码',
			dataIndex : 'outKpiCode',
			width : 70,
			align : 'left',
			sortable : true

		}, {
			header : '指标名称',
			dataIndex : 'outKpiName',
			width : 120,
			align : 'left',
			sortable : true

		}, {
			header : '指标实际值',
			dataIndex : 'actValue',
			width : 90,
			align : 'right',
			sortable : true

		}, {
			header : '导入状态',
			dataIndex : 'status',
			width : 90,
			align : 'right',
			sortable : true

		}]);

var OutKPIDataSearchField = 'outUnitName';

var OutKPIDataFilterItem = new Ext.SplitButton({
			text : '过滤器',
			tooltip : '关键字所属类别',
			menu : {
				items : [new Ext.menu.CheckItem({
									text : '接口单位代码',
									value : 'outUnitCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '接口单位名称',
									value : 'outUnitName',
									checked : true,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '核算单元代码',
									value : 'outUnitLocCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '核算单元名称',
									value : 'outUnitLocName',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '指标代码',
									value : 'outKpiCode',
									checked : false,
									group : 'OutKPIDataFilter',
									checkHandler : onOutKPIDataItemCheck
								}), new Ext.menu.CheckItem({
									text : '指标名称',
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
									text : '导入状态',
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
			OutKPIDataDs.proxy = new Ext.data.HttpProxy({
						url : OutKPIDataUrl + '?action=list&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			OutKPIDataDs.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	},
	onTrigger2Click : function() {
		if (this.getValue()) {
			OutKPIDataDs.proxy = new Ext.data.HttpProxy({
						url : OutKPIDataUrl + '?action=list&searchField='
								+ OutKPIDataSearchField + '&searchValue='
								+ this.getValue() + '&CycleDr='
								+ cycleField.getValue() + '&frequency='
								+ periodTypeField.getValue() + '&period='
								+ periodField.getValue()
					});
			OutKPIDataDs.load({
						params : {
							start : 0,
							limit : OutKPIDataPagingToolbar.pageSize
						}
					});
		}
	}
});
OutKPIDataDs.each(function(record) {
			alert(record.get('tieOff'));

		});
var OutKPIDataPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : OutKPIDataDs,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据",
	buttons : ['-', OutKPIDataFilterItem, '-', OutKPIDataSearchBox]
});

var OutKPIDataMain = new Ext.grid.GridPanel({// 表格
	title : '指标数据采集维护',
	store : OutKPIDataDs,
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
			'接口套:', locSetField, '-', '接口方法:', interMethodField, '-',
			collectDataButton, '-', importButton, '-', delButton],
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
		surl = OutKPIDataUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
	} else {
		surl = OutKPIDataUrl + '?action=list&CycleDr=' + cycleField.getValue()
				+ '&frequency=' + periodTypeField.getValue() + '&period='
				+ periodField.getValue() + '&locSetDr=' + locSetDr
				+ '&interMethodDr=' + interMethodDr
	}
	// prompt('surl',surl)

	OutKPIDataDs.proxy = new Ext.data.HttpProxy({
		url : surl
			// ,method : 'POST'
		});
	OutKPIDataDs.load({
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
				url : OutKPIDataUrl + '?action=ImportStatus&CycleDr=' + cycleDr
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
OutKPIDataDs.load({
			params : {
				start : 0,
				limit : OutKPIDataPagingToolbar.pageSize
			}
		});
