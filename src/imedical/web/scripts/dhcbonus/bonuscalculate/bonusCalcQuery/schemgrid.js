var schemUrl = '../csp/dhc.bonus.deptbonuscalcqueryexe.csp';
var schemProxy = new Ext.data.HttpProxy({
			url : schemUrl + '?action=schemlist'
		});

var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var StratagemTabUrl = '../csp/dhc.bonus.deptbonuscalcqueryexe.csp';

var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月份'], ['Q', '季度'], ['H', '半年'], ['Y', '年份']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '选择期间类型...',
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
			width : 90,
			listWidth : 90,
			selectOnFocus : true,
			allowBlank : false,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '请选择...',
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
			width : 100,
			listWidth : 100,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '选择核算年度...',
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

// 奖金核算主表数据源
var schemDs = new Ext.data.Store({
			proxy : schemProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'BonusSchemeCode', 'BonusSchemeName',
							'BonusYear', 'BonusPeriod', 'CalcFlag', 'CalcDate',
							'AuditingFlag', 'AuditingDate']),
			remoteSort : true
		});

schemDs.setDefaultSort('rowid', 'desc');

var schemCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : '奖金核算ID',
			dataIndex : 'rowid',
			width : 40,
			hidden : true,
			sortable : true
		}, {
			header : '方案代码',
			dataIndex : 'BonusSchemeCode',
			width : 40,
			sortable : true
		}, {
			header : "方案名称",
			dataIndex : 'BonusSchemeName',
			width : 140,
			align : 'left',
			sortable : true
		}, {
			header : "核算年度",
			dataIndex : 'BonusYear',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "核算期间",
			dataIndex : 'BonusPeriod',
			width : 40,
			align : 'left',
			sortable : true
		}, {
			header : "是否核算",
			dataIndex : 'CalcFlag',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "核算时间",
			dataIndex : 'CalcDate',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : "是否审核",
			dataIndex : 'AuditingFlag',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : "审核时间",
			dataIndex : 'AuditingDate',
			width : 60,
			align : 'left',
			sortable : true
		}]);

// 奖金方案核算
var BonusCalcButton = new Ext.Toolbar.Button({
			text : '奖金核算',
			tooltip : '奖金核算',
			iconCls : 'add',
			handler : function() {
				schemeCalc(SchemGrid, schemDs);
			}
		});

// 奖金方案审核
var BonusAuditingButton = new Ext.Toolbar.Button({
			text : '数据审核',
			tooltip : '数据审核',
			iconCls : 'add',
			handler : function() {
				schemeAuditing(SchemGrid, schemDs);
			}
		});

// 奖金方案发放
var BonusPayButton = new Ext.Toolbar.Button({
			text : '奖金发放',
			tooltip : '奖金发放',
			iconCls : 'add',
			handler : function() {
				// editJXUnitFun(SchemGrid, bonusItemDs,
				// bonusitemgrid,jxUnitPagingToolbar);
				schemePay(SchemGrid, schemDs);
			}
		});

var schemPagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 25,
	store : schemDs,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据",
	doLoad : function(C) {
		var B = {}, A = this.paramNames;
		B[A.start] = C;
		B[A.limit] = this.pageSize;
		B['period'] = Ext.getCmp('periodTypeField').getValue();
		B['dir'] = "asc";
		B['sort'] = "rowid";
		if (this.fireEvent("beforechange", this, B) !== false) {
			this.store.load({
						params : B
					});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({// 表格
	title : '单元奖金方案核算',
	region : 'north',
	height : 300,
	minSize : 350,
	maxSize : 450,
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	store : schemDs,
	cm : schemCm,
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	tbar : ['核算年度:', periodYear, '-', '期间类型:', periodTypeField, '-', '核算期间:',
			periodField],
	bbar : schemPagingToolbar
});

//, '-', BonusCalcButton, '-', BonusAuditingButton
// ------组件事件加载-----begin-----------------

// 核算期间 选择期间
periodField.on("select", function(cmb, rec, id) {
			if (Ext.getCmp('periodField').getValue() != '') {
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
			}
			// 显示奖金核算明细
			schemDs.on('load', function(ds, o) {
						showBonusDetail(SchemGrid, 0, '');
					});

		});

var schemRowId = "";
var schemName = "";

// 单击奖金核算方案后刷新 核算单元奖金项
SchemGrid.on('rowclick', function(grid, rowIndex, e) {
			showBonusDetail(grid, rowIndex, e)
		});
// 奖金方案主表
schemDs.on("beforeload", function(ds) {
			bonusItemDs.removeAll();
			schemRowId = "";
			bonusitemgrid.setTitle("奖金方案核算项明细");
		});
// -----------------组件事件加载-----end-----------------------

// ----------------函数处理------------------------------------
// 显示奖金核算明细
function showBonusDetail(grid, rowIndex, e) {

	var selectedRow = schemDs.data.items[rowIndex];
	// alert('aa')
	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["BonusSchemeName"];
	schemCode = selectedRow.data["BonusSchemeCode"];
	// alert('bb')

	sbonusYear = Ext.getCmp('periodYear').getValue(), sbonusPeriod = Ext
			.getCmp('periodField').getValue(),

	bonusitemgrid.setTitle(schemName + "-所对应奖金核算项");
	Ext.Ajax.request({
		url : '../csp/dhc.bonus.deptbonuscalcqueryexe.csp?action=getTitleInfo&sMainSchemeCode='
				+ schemCode,
		waitMsg : '...',
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

			var cmItems = [];
			var cmConfig = {};
			// cmItems.push(sm);
			cmItems.push(new Ext.grid.RowNumberer());

			var cmConfig = {};
			var jsonHeadNum = jsonData.results;
			var jsonHeadList = jsonData.rows;
			var tmpDataMapping = [];

			for (var i = 0; i < jsonHeadList.length; i++) {

				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 95,
					sortable : true,
					align : 'left',
					editor : new Ext.form.TextField({
								allowBlank : true
							})
				};

				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 提取奖金项数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping

			var tmpStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.deptbonuscalcqueryexe.csp?action=getBonusDetail&sMainSchemeCode='
							+ schemCode
							+ '&bonusPeriod='
							+ sbonusPeriod
							+ '&bonusYear=' + sbonusYear
				}),
				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, tmpDataMapping),
				remoteSort : true
			});

			bonusitemgrid.reconfigure(tmpStore, tmpColumnModel);
			tmpStore.load();
		},
		scope : this
	});

}

// 奖金方案核算
function schemeCalc(SchemGrid, schemDs) {
	var rowObj = SchemGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要核算的奖金方案!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var isCalc = rowObj[0].get("rowid")
	var BonusSchemeCode = rowObj[0].get("BonusSchemeCode")
	var sBonusPeriod = rowObj[0].get("BonusYear") + "^"
			+ Ext.getCmp('periodField').getValue()

	if (isCalc != '') {
		Ext.MessageBox.confirm('提示', '该奖金方案已经核算，确实要重新核算吗?', handler);
		return false;
	}

	Ext.MessageBox.confirm('提示', '确实要核算该奖金方案吗?', handler);

	function handler(id) {

		if (id == 'yes') {
			Ext.Ajax.request({
				url : schemUrl + '?action=bonuscalc&BonusSchemeCode='
						+ BonusSchemeCode + '&sBonusPeriod=' + sBonusPeriod,
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					//prompt("result",rtn)

					var jsonData = Ext.util.JSON.decode(result.responseText);

					if (jsonData.success == 'true') {
						Ext.Msg.show({
									title : '注意',
									msg : '数据核算成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
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

						showBonusDetail(SchemGrid, 1)

						window.close();
					} else {
						var message = "";
						message = "奖金方案核算失败！";
						Ext.Msg.show({
									title : '错误',
									msg : jsonData.info,
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
// 奖金方案审核
function schemeAuditing(SchemGrid, schemDs) {

	var rowObj = SchemGrid.getSelections();
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要审核的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	var rowid = rowObj[0].get("rowid")
	var isCalc = rowObj[0].get("rowid")
	var IsAuditing = rowObj[0].get("AuditingFlag")

	if (isCalc == '') {
		Ext.Msg.show({
					title : '注意',
					msg : '该方案未进行奖金核算，请先进行奖金核算!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}
	if (IsAuditing == '已审核') {
		Ext.Msg.show({
					title : '注意',
					msg : '该奖金方案已经审核!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	}

	Ext.MessageBox.confirm('提示', '确实要审核该方案吗?', Auditing);

	function Auditing(id) {

		if (id == 'yes') {

			Ext.Ajax.request({
				url : schemUrl + '?action=auditing&rowid=' + rowid
						+ '&IsAuditing=1',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '错误',
								msg : '请检查网络连接!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					if (rtn == 0) {
						Ext.Msg.show({
									title : '注意',
									msg : '数据审核成功!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
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

						window.close();
					} else {
						var message = "";
						message = "奖金方案审核失败！";
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
