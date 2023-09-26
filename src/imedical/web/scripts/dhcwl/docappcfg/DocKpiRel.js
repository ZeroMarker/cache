(function() {
	Ext.ns("dhcwl.docappcfg.DocKpiRel");
})();
// dhcwl.msgcfg.MaintainMsgTasks=function(){
Ext.onReady(function() {

	var inputRule = "";
	var storeType = "proxy";
	objRoot = new Object();
	objRoot.child = [];
	objRoot.split = ",";
	var treeDeep = "";
	// ///////////////////////////////
	// ///////////////////////////////
	// ///////////////////////////////
	// --kpiList --start dockpirel.csp
	var serviceUrl = "dhcwl/docappcfg/dockpirel.csp";
	var getTaskInfoUrl = 'dhcwl/kpi/taskserver.csp'
	var outThis = this;
	var outputList = [];
	var choiceKpiCode = "", kpiSectionName;

	var columnModelKpi = new Ext.grid.ColumnModel({
				defaults : {
					sortable : true,
					menuDisabled : true,
					forceFit : true
				},
				// columns: [new Ext.grid.RowNumberer(),sm,{
				columns : [new Ext.grid.RowNumberer(), {
							header : 'id',
							dataIndex : 'id',
							width : 30
						}, {
							header : '指标编码',
							dataIndex : 'kpiCode',
							width : 130,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '指标名称',
							dataIndex : 'kpiName',
							width : 140,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '区间',
							dataIndex : 'section',
							width : 40,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '维度',
							dataIndex : 'dimType',
							width : 200,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '类别',
							dataIndex : 'category',
							width : 76,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}]
			});

	// 定义指标的存储模型 dhcwl/kpi/getkpidata.csp
	var storeKpi = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : 'dhcwl/docappcfg/getdockpidata.csp?action=singleSearche&mark=TASK&date='
					+ dhcwl.mkpi.Util.nowDateTime()
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'totalNum',
					root : 'root',
					fields : [{
								name : 'id'
							}, {
								name : 'kpiCode'
							}, {
								name : 'kpiName'
							}, {
								name : 'dimType'
							}, {
								name : 'category'
							}, {
								name : 'section'
							}]
				})
	});

	// 定义指标的显示表格。
	var choicedSearcheCond = "", searcheValue = "";
	var kpiList = new Ext.grid.GridPanel({
		// var kpiList = new Ext.grid.EditorGridPanel({
		title : '系统指标',
		id : "kpiTables",
		width : 600,
		height : 507, // 760,

		resizeAble : true,
		// autoHeight:true,
		enableColumnResize : true,
		store : storeKpi,
		cm : columnModelKpi,
		sm : sm,
		autoScroll : true,

		bbar : new Ext.PagingToolbar({
			pageSize : 50,
			store : storeKpi,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1} 条，一共 {2} 条',
			emptyMsg : "没有记录",
			listeners : {
				'beforechange' : function(pt, page) {

					storeKpi.proxy
							.setUrl(encodeURI("dhcwl/docappcfg/getdockpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="
									+ choicedSearcheCond
									+ "&searcheValue="
									+ searcheValue)); // +"&start=0&limit=50"));

				},
				'change' : function(pt, page) {
					var code = "";
					for (var i = storeKpi.getCount() - 1; i > -1; i--) {
						code = storeKpi.getAt(i).get("kpiCode");
						if (outThis.check(code)) {
							sm.selectRow(i, true, false);
						}
					}
				}
			}
		}),
		tbar : new Ext.Toolbar({
			layout:'hbox',
			items:[{
			text : '<span style="line-Height:1">保存选中指标</span>',
			icon   : '../images/uiimages/filesave.png',
			handler : function() {
				var record = kpiList.getSelectionModel().getSelected();
				var docRec = grid.getSelectionModel().getSelected();
				var docCat = docRec.get("MDocKPIDefCategory");
				if ((!record) && (docCat == "普通指标")) {
					Ext.Msg.alert('消息', '请选择系统指标');
					return;
				}
				if (docCat == "计算类指标") {
					Ext.Msg.alert('消息', '计算类指标请直接维护');
					return;
				}
				addChoicedKpi();
				outputList = [];
				var record = grid.getSelectionModel().getSelected();
				var docKpiId = record.get("ID");
				if (!docKpiId) {
					return;
				} 
				storeKpiOut2.proxy
						.setUrl(encodeURI(serviceUrl4
								+ '?action=singleSearche&searcheCond=Code&searcheValue='
								+ docKpiId));
				kpiPanelList2.getStore().reload();
								
			}
		}, '按条件快速搜索：', {
			//xtype : 'compositefield',
			//anchor : '-20',
			//msgTarget : 'side',
			//{
						id : 'searchCond',
						width : 100,
						xtype : 'combo',
						mode : 'local',
						emptyText : '请选择搜索类型',
						triggerAction : 'all',
						forceSelection : true,
						editable : false,
						displayField : 'value',
						valueField : 'name',
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : 'Code',
												value : '指标代码'
											}, {
												name : 'Name',
												value : '指标名称'
											}, {
												name : 'Sec',
												value : '指标区间'
											}, /*{
												name : 'Dim',
												value : '指标维度'
											}, */{
												name : 'FL',
												value : '指标类型'
											}, {
												name : 'ACTIVE',
												value : '是否激活'
											}]
								}),
						listeners : {
							'select' : function(combo) {
								choicedSearcheCond = combo.getValue();// ele.getValue();
							}
						}
					}, {
						xtype : 'textfield',
						//width : 300,
						flex : 1,
						id : 'taskSearcheContValue',
						enableKeyEvents : true,
						allowBlank : true,
						listeners : {
							'keypress' : function(ele, event) {
								searcheValue = Ext.get("taskSearcheContValue")
										.getValue();// ele.getValue();
								if (choicedSearcheCond == "ACTIVE") {
									searcheValue = ((searcheValue == "Y")
											|| (searcheValue == "y")
											|| (searcheValue == "是")
											? "Y"
											: ((searcheValue == null || searcheValue == "")
													? ""
													: "N"));
								}
								if ((event.getKey() == event.ENTER)) {
									storeKpi.proxy
											.setUrl(encodeURI("dhcwl/docappcfg/getdockpidata.csp?action=singleSearche&mark=OUTPUT&searcheCond="
													+ choicedSearcheCond
													+ "&searcheValue="
													+ searcheValue
													+ "&start=0&limit=50"));
									storeKpi.load();
									kpiList.show();
								}
							}
						}
		}]
	})
	});

	storeKpi.on('beforeload', function() {
				// storeKpi.baseParams = {searcheCond:choicedSearcheCond,
				// searcheValue:searcheValue};
			});
	storeKpi.load({
				params : {
					start : 0,
					limit : 50,
					mark : 'TASK'
				}
			});

	var activeFlagCombo = new Ext.form.ComboBox({
				width : 150,
				editable : false,
				xtype : 'combo',
				mode : 'local',
				triggerAction : 'all',
				value : '否',
				name : 'globalFlagCombo',
				displayField : 'isGlobal',
				valueField : 'isGlobalV',
				store : new Ext.data.JsonStore({
							fields : ['isGlobal', 'isGlobalV'],
							data : [{
										isGlobal : '否',
										isGlobalV : 'N'
									}, {
										isGlobal : '是',
										isGlobalV : 'Y'
									}]
						}),
				listeners : {
					'select' : function(combox) {
						activeFlagCombo.setValue(combox.getValue());
					}
				}
			});
	// 是否默认激活指标任务,从服务器端取数据
	var recordActiveFlag = Ext.data.Record.create([{
				name : 'disValue'
			}, {
				name : 'realValue'
			}]);
	var globalActiveFlagCombo = new Ext.form.ComboBox({
		width : 150,
		editable : false,
		xtype : 'combo',
		mode : 'remote',
		triggerAction : 'all',
		displayField : 'disValue',
		valueField : 'realValue',
		store : new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : 'dhcwl/kpi/sysvarcfg.csp?action=getGlobalTaskActiveFlag'
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : 'totalNums',
						root : 'root',
						fields : recordActiveFlag
					})
		}),
		listeners : {
			'select' : function(combox) {
				globalActiveFlagCombo.setValue(combox.getValue());
			}
		}
	});

	var sm = new Ext.grid.RowSelectionModel({
				singleSelect : true
			});
	var executeCodeField = new Ext.form.TextField({
				name : 'executeCodeField',
				listeners : {
					'focus' : function(field, eve) {
						if (null == dhcwl_mkpi_executeCodeWin) {
							dhcwl_mkpi_executeCodeWin = new dhcwl.mkpi.TaskExectCode();
							dhcwl_mkpi_executeCodeWin.setParentWin(outThis);
						}
						var record = sm.getSelected();
						execCodeSubType = record.get('SecCode');
						dhcwl_mkpi_executeCodeWin.setExecCodeType('TAS',
								execCodeSubType);
						dhcwl_mkpi_executeCodeWin.showWin();
					}
				}
			});
	var columnModelTask = new Ext.grid.ColumnModel({
				defaults : {
					sortable : true,
					width : 80,
					menuDisabled : true
				},
				columns : [new Ext.grid.RowNumberer(), {
							header : '任务区间编码',
							dataIndex : 'SecCode',
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '任务区间名称',
							dataIndex : 'SecName',
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '任务区间执行代码',
							dataIndex : 'DTaskExcuteCode',
							width : 160,
							editor : new Ext.grid.GridEditor(executeCodeField)
						}, {
							header : '运行时任务区间执行代码语句',
							dataIndex : 'DTaskExcuteCodeTip',
							width : 180,
							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
									{
										disabled : true
									}))
						}, {
							header : '是否激活?',
							dataIndex : 'DTaskActiveFlag',
							editor : new Ext.grid.GridEditor(activeFlagCombo)
						}]
			});
	var storeTask = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : 'dhcwl/kpi/taskserver.csp?action=list-kpiTaskExc'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'SecCode'
									}, {
										name : 'SecName'
									}, {
										name : 'DTaskExcuteCode'
									}, {
										name : 'DTaskExcuteCodeTip'
									}, {
										name : 'DTaskActiveFlag'
									}]
						})
			});
	var RecordTask = Ext.data.Record.create([{
				name : 'SecCode'
			}, {
				name : 'SecName'
			}, {
				name : 'DTaskExcuteCode'
			}, {
				name : 'DTaskExcuteCodeTip'
			}, {
				name : 'DTaskActiveFlag'
			}]);
	var taskSectionExcListGrid = new Ext.grid.EditorGridPanel({
				id : 'dhcwl.msgcfg.MaintainMsgTasks.GridPanel',
				title : '任务区间代码列表',
				frame : true,
				clicksToEdit : 1,
				store : storeTask,
				cm : columnModelTask,
				sm : sm,
				width : 600,
				height : 800,
				tbar : []
			});

	this.add = function(kpiCode) {
		if (!kpiCode || kpiCode == "")
			return;
		for (var i = outputList.length - 1; i > -1; i--) {
			if (outputList[i] == kpiCode)
				return;
		}
		outputList.push(kpiCode);

	}
	this.remove = function(kpiCode) {
		if (!kpiCode || kpiCode == "")
			return;
		for (var i = outputList.length - 1; i > -1; i--) {
			if (outputList[i] == kpiCode) {
				delete outputList[i]
				return;
			}

		}

	}
	// ///////////////////////////////
	// ///////////////////////////////
	// ///////////////////////////////
	// --kpiList -end

	// ///////////////////////////////////
	// //////////////////////////////////
	// --kpiList2 -start
	// -------------------------
	var outThis = this;
	var choicedSearcheCond2 = "", kpiSectionName;
	var sm1 = new Ext.grid.CheckboxSelectionModel({
				listeners : {
					'rowdeselect' : function(csm, rowIndex, recorde) {
						var kpiCode = recorde.get('kpiCode');
						outThis.remove(kpiCode);
					},
					'rowselect' : function(csm, rowIndex, recorde) {
						var kpiCode = recorde.get('kpiCode');
						outThis.add(kpiCode);
					}
				}
			});
	// 医生指标对应系统指标
	var columnModelMsgKpi = new Ext.grid.ColumnModel({
				defaults : {
					sortable : true,
					width : 80
				},
				columns : [new Ext.grid.RowNumberer(), {
							header : 'ID',
							dataIndex : 'ID',
							width : 30
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '医生指标ID',
							dataIndex : 'MDocKPIDr',
							hidden : true
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '医生指标代码',
							dataIndex : 'MDocKPIDefCode'

//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '医生指标描述',
							dataIndex : 'MDocKPIDefDesc'
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '系统指标ID',
							dataIndex : 'MKPIdr',
							hidden : true
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '系统指标代码',
							dataIndex : 'MKPICode',
							width : 70
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, /*
							 * { header : '系统指标名称', dataIndex : 'MKPIName',
							 * editor : new Ext.grid.GridEditor(new
							 * Ext.form.TextField( { disabled : true })) },
							 */{
							header : '指标维度',
							dataIndex : 'MKPIDim'
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '维度属性',
							dataIndex : 'MDimProp',
							width : 70
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}, {
							header : '其它过滤规则',
							dataIndex : 'OtherFilterRule',
							width : 90
//							editor : new Ext.grid.GridEditor(new Ext.form.TextField(
//									{
//										disabled : true
//									}))
						}]
			});
	var storeKpiOut2 = new Ext.data.Store({ // 
		proxy : new Ext.data.HttpProxy({
			url : 'dhcwl/docappcfg/getrelservice.csp?action=singleSearche&mark=OUTPUT'
		}),

		reader : new Ext.data.JsonReader({
					totalProperty : 'totalNum',
					root : 'root',
					fields : [{
								name : 'ID'
							}, {
								name : 'MDocKPIDr'
							}, {
								name : 'MDocKPIDefCode'
							}, {
								name : 'MDocKPIDefDesc'
							}, {
								name : 'MKPIdr'
							}, {
								name : 'MKPICode'
							}, /*
								 * { name : 'MKPIName' },
								 */{
								name : 'MKPIDim'
							}, {
								name : 'MDimProp'
							}, {
								name : 'OtherFilterRule'
							}]
				})
	});
	var kpiPanelList2 = new Ext.grid.EditorGridPanel({
		id : 'dhcwl.leadermsg.MaintainRightKpi.GridPanel',
		title : '医生指标对应系统指标',
		width : 557,
		height : 150,
		frame : true,
		enableColumnResize : true,
		store : storeKpiOut2,
		cm : columnModelMsgKpi,
		sm : sm1,
		tbar : new Ext.Toolbar([{
					text : '<span style="line-Height:1">删除</span>',
					icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						delDocKpiRel();
						outputList = [];
					}
				}, {
					text : '<span style="line-Height:1">配置过滤规则</span>',
					icon   : '../images/uiimages/config.png',
					handler : function() {
						var bingo = kpiPanelList2.getSelectionModel()
								.getSelected();
						if (!bingo) {
							Ext.MessageBox.alert("提示", "请选择需要配置的指标");
							return;
						}
						var sysKpiCode = bingo.get('MKPICode');
						var sysKpiDr = bingo.get('MKPIdr');
						var docKpi = bingo.get('MDocKPIDr');
						var othFilter = bingo.get('OtherFilterRule');
						if (sysKpiCode != '') {
							if (itemComWin == null) {
								var itemComWin = new dhcwl.docappcfg.DockpiComWindow(
										sysKpiCode, docKpi, othFilter);
							}
							// itemComWin.setSubWinParam(sysKpiDr,docKpi);
							itemComWin.show();
						} else {
							Ext.MessageBox.alert("提示", "计算类指标请在医生应用指标中维护");
							return;
						}
					}
				}])
	});
	var rightmenu = new Ext.menu.Menu({
				boxMinWidth : 150,
				ignoreParentClicks : true,
				items : [{
					text : '配置过滤规则',
					handler : function() {
						var bingo = kpiPanelList2.getSelectionModel()
								.getSelected();
						if (!bingo) {
							Ext.MessageBox.alert("提示", "请选择需要配置的指标");
							return;
						}
						var sysKpiCode = bingo.get('MKPICode');
						var sysKpiDr = bingo.get('MKPIdr');
						var docKpi = bingo.get('MDocKPIDr');
						var othFilter = bingo.get('OtherFilterRule');
						if (sysKpiCode != '') {
							if (itemComWin == null) {
								var itemComWin = new dhcwl.docappcfg.DockpiComWindow(
										sysKpiCode, docKpi, othFilter);
							}
							// itemComWin.setSubWinParam(sysKpiDr,docKpi);
							itemComWin.show();
						} else {
							Ext.MessageBox.alert("提示", "计算类指标请在医生应用指标中维护");
							return;
						}
					}
				}]
			});
	kpiPanelList2.on('contextmenu', function(e) {
		e.preventDefault();
		rightmenu.showAt(e.getXY());
		});
	storeKpiOut2.load({
				params : {
					start : 0,
					limit : 50,
					mark : 'OUTPUT'
				}
			});
	function getSelects() {
		var rds = sm1.getSelections();
		for (var i = rds.length - 1; i > -1; i--) {
			outputList.push(rds[i].get("kpiCode"));
		}
	}

	// --------------------------------------------
	// --kpiList2 end

	// --201506 --医生指标维护
	var serviceUrl2 = "dhcwl/docappcfg/getdockpidef.csp";
	var serviceUrls2 = "dhcwl/docappcfg/savedockpidef.csp"; // getrelservice.csp
	var serviceUrl4 = "dhcwl/docappcfg/getrelservice.csp"
	var kpiObj = null;
	// 复选框
	var selectedKpiIds = [];
	var csmdoc = new Ext.grid.CheckboxSelectionModel({
		listeners : {
			rowselect : function(sm, row, rec) {
				if (!rec)
					return;
				var rd = rec; // sm.getSelected();
				var docKpiId = rec.get("ID");
				if (!docKpiId) {
					return;
				} // action=singleSearche&mark=OUTPUT' &docKpiId='+docKpiId
				storeKpiOut2.proxy
						.setUrl(encodeURI(serviceUrl4
								+ '?action=singleSearche&searcheCond=Code&searcheValue='
								+ docKpiId));
				storeKpiOut2.load();
				kpiPanelList2.show();
				// consForm.getForm().loadRecord(rec);
			},
			'rowdeselect' : function(sm, row, rec) {
				var consId = rec.get("consId"), len = selectedKpiIds.length;
				for (var i = 0; i < len; i++) {
					if (selectedKpiIds[i] == consId) {
						for (var j = i; j < len; j++) {
							selectedKpiIds[j] = selectedKpiIds[j + 1]
						}
						selectedKpiIds.length = len - 1;
						break;
					}
				}
			}
		}
	});

	// 定义列
	var columnModel = new Ext.grid.ColumnModel([
			// new Ext.grid.RowNumberer(),csm,
			{
		header : 'ID',
		dataIndex : 'ID',
		sortable : true,
		width : 40,
		sortable : true
	}, {
		header : '医生指标代码',
		dataIndex : 'MDocKPIDefCode',
		width : 85,
		sortable : true
	}, {
		header : '医生指标描述',
		dataIndex : 'MDocKPIDefDesc',
		width : 115,
		sortable : true
	}, {
		header : '创建日期',
		dataIndex : 'MDocKPIUpdateDate',
		width : 80,
		sortable : true
	}, {
		header : '医生指标分类',
		dataIndex : 'MDocKPIDefClass',
		width : 65,
		sortable : true
	}, {
		header : '医生指标类别',
		dataIndex : 'MDocKPIDefCategory',
		width : 73,
		sortable : true
	}, {
		header : '医生指标归类',
		dataIndex : 'MDocKPIDefType',
		width : 73,
		sortable : true
	}]);
	// 定义指标的存储模型
	var store = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl2 + '?action=mulSearch'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNum',
							root : 'root',
							fields : [{
										name : 'ID'
									}, {
										name : 'MDocKPIDefCode'
									}, {
										name : 'MDocKPIDefDesc'
									}, {
										name : 'MDocKPIUpdateDate'
									}, {
										name : 'MDocKPIDefClass'
									}, {
										name : 'MDocKPIDefCategory'
									}, {
										name : 'MDocKPIDefType'
									}]
						})
			});
	// start

	// end
	// 分页控件
	var pageTool = new Ext.PagingToolbar({
		pageSize : 23,
		store : store,
		displayInfo : true,
		displayMsg : '第 {0} 到 {1} 条，一共 {2} 条',
		emptyMsg : "没有记录",
		listeners : {
			'change' : function(pt, page) {
				var id = "", j = 0, found = false, storeLen = selectedKpiIds.length;
				for (var i = store.getCount() - 1; i > -1; i--) {
					id = store.getAt(i).get("ID");
					found = false;
					for (j = storeLen - 1; j > -1; j--) {
						if (selectedKpiIds[j] == id)
							found = true;
					}
					if (found) {
						// csm.selectRow(i,true,false);
					}
				}
			}
		}
	});
	var itemKPIWin = null;
	var itemCalWin = null;
	var contextmenu = new Ext.menu.Menu({
				boxMinWidth : 140,
				ignoreParentClicks : true,
				items : [{
					text : '<span style="line-Height:1">配置计算类指标</span>',
					icon   : '../images/uiimages/config.png',
					handler : function() {

						var isSel = grid.getSelectionModel().getSelected();
						if (!isSel) {
							Ext.MessageBox.alert("提示", "请选择需要配置的指标");
							return;
						}
						var docKpiId = isSel.get('ID');
						var docCode = isSel.get('MDocKPIDefCode');
						var docCategory = isSel.get('MDocKPIDefCategory');
						var docClass = isSel.get('MDocKPIDefClass');
						var docType = isSel.get('MDocKPIDefType');
						if (isSel.get('MDocKPIDefCategory') == '计算类指标') {
							if (itemCalWin == null) {

								itemCalWin = new dhcwl.docappcfg.DockpiCalWindow(
										docClass, docType);
							}
							itemCalWin.setSubWinParam(docKpiId, docCode,
									docClass, docType);
							itemCalWin.showWin();
						} else {
							Ext.MessageBox.alert("提示", "普通指标请在医生指标对应系统指标中维护");
							return;
						}
					}
				}]
			});
	// 列表
	var grid = new Ext.grid.GridPanel({
		stripeRows : true,
		loadMask : true,
		height : 330,
		width : 557,
		store : store,
		id : "consTables",
		sm : csmdoc,
		resizeAble : true,
		enableColumnResize : true,
		bbar : pageTool, // 底部工具栏
		cm : columnModel,
		tbar : new Ext.Toolbar({
		layout:'hbox',
		items : ['查找:',{
						id : 'research',
						width : 100,
						xtype : 'combo',
						mode : 'local',
						emptyText : '请选择搜索类型',
						triggerAction : 'all',
						forceSelection : true,
						editable : false,
						displayField : 'value',
						valueField : 'name',
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : 'MDocKPIDefCode',
												value : '医生指标代码'
											}, {
												name : 'MDocKPIDefDesc',
												value : '医生指标描述'
											}, {
												name : 'MDocKPIDefCategory',
												value : '医生指标类别'
											}, {
												name : 'MDocKPIDefClass',
												value : '医生指标分类'
											}, {
												name : 'MDocKPIDefType',
												value : '医生指标归类'
											}]
								}),
						listeners : {
							'select' : function(combo) {
								choiceSearcheCond = combo.getValue();

							}
						}
		}
					, {
						xtype : 'textfield',
						// width : 300,
						flex : 1,
						id : 'docSearcheContValue',
						enableKeyEvents : true,
						allowBlank : true,
						listeners : {
							'keypress' : function(ele, event) {
								searcheValue = Ext.get("docSearcheContValue")
										.getValue();

								if ((event.getKey() == event.ENTER)) {
									store.proxy
											.setUrl(encodeURI("dhcwl/docappcfg/getdocsingledef.csp?action=singleSearche&choiceSearcheCond="
													+ choiceSearcheCond
													+ "&searcheValue="
													+ searcheValue));
									store.load({
												params : {
													start : 0,
													limit : 23
												}
											});
									grid.show();
								}
							}
						}
					}, '-', {
			text : '<span style="line-Height:1">配置计算类指标</span>',
			icon   : '../images/uiimages/config.png',
			handler : function() {
				var isSel = grid.getSelectionModel().getSelected();
				if (!isSel) {
					Ext.MessageBox.alert("提示", "请选择需要配置的指标");
					return;
				}
				var docKpiId = isSel.get('ID');
				var docCode = isSel.get('MDocKPIDefCode');
				var docCategory = isSel.get('MDocKPIDefCategory');
				var docClass = isSel.get('MDocKPIDefClass');
				var docType = isSel.get('MDocKPIDefType');
				if (isSel.get('MDocKPIDefCategory') == '计算类指标') {
					if (itemCalWin == null) {
						itemCalWin = new dhcwl.docappcfg.DockpiCalWindow(
								docClass, docType);
					}
					itemCalWin.setSubWinParam(docKpiId, docCode, docClass,
							docType);
					itemCalWin.showWin();
				} else {
					Ext.MessageBox.alert("提示", "普通指标请在医生指标对应系统指标中维护");
					return;
				}
			}
		}]
	})
	});

	grid.on("contextmenu", function(e) {
				e.preventDefault();
				contextmenu.showAt(e.getXY());

			});
	grid.on("click", function(e) {

			});

	this.check = function(kpiCode) {
		if (!kpiCode || kpiCode == "")
			return false;
		for (var i = outputList.length - 1; i > -1; i--) {
			if (outputList[i] == kpiCode) {
				return true;
			}

		}
		return false;
	}

	// 2- 其他过滤表达式 - start
	// 其他过滤表达式表单
	var otherFilterForm = new Ext.FormPanel({
				// id: 'kpi-list',
				title : '其它过滤表达式',
				frame : true,
				width : 650,
				height : 150,
				// autoScroll:true,
				labelAlign : 'left',
				bodyStyle : 'padding:5px',
				style : {

					"margin-right" : Ext.isIE6 ? (Ext.isStrict
							? "-10px"
							: "-13px") : "0"
				},
				layout : 'table',
				defaultConfig : {
					width : 750
				},
				layoutConfig : {
					columns : 1
				},
				items : [{
					name : 'OtherFilter',
					id : 'OtherFilter',
					xtype : 'textarea', // 'textfield',
					width : 620,
					height : 70,
					flex : 1
						// readOnly:true
					}]

			});
	// 2- 其他过滤表达式 - end

	// 保存医生指标和系统指标
	function addChoicedKpi() {
		var sm = kpiList.getSelectionModel();
		var record = sm.getSelected();
		if (!sm || !record) {
			var kpis = "";
		} else {
			var kpis = record.get("kpiCode");
			var skpiId = record.get("id");
		}

		var docSm = grid.getSelectionModel();
		var records = docSm.getSelected();
		if (!docSm || !records) {
			alert("请选择要维护的医生指标行！");
			return;
		}
		var docKpiDefID = records.get("ID"); // 医生应用指标ID
		var docKpiDefClass = records.get("MDocKPIDefClass");
		paraValues = 'MDocKPIDr=' + docKpiDefID + '&MKPIdr=' + kpis
				+ '&SkpiId=' + skpiId + '&DocKpiDefClass=' + docKpiDefClass;
		dhcwl.mkpi.Util.ajaxExc(serviceUrl + '?action=addDocAppRel&'
				+ paraValues);
	}

	// 删除医生指标、系统指标对应关系
	function delDocKpiRel() {
		var sm = kpiPanelList2.getSelectionModel();
		var record = sm.getSelected();
		if (!sm || !record) {
			alert("请选择要删除的医生指标所关联的系统指标");
			return;
		}
		Ext.Msg.confirm('信息', '确定要删除?', function(btn) {
			if (btn == 'yes') {
				var ID = record.get("ID");
				dhcwl.mkpi.Util.ajaxExc(serviceUrl + '?action=delete&ID=' + ID);
				storeKpiOut2.remove(record);
			}
		});
	}

	this.getArrayStr = function(deli) {
		var result = "";
		deli = deli || ',';
		for (var i = outputList.length - 1; i > -1; i--) {
			if ((!outputList[i]) || (outputList[i] == "")) {
				continue;
			}
			if (result == "")
				result = outputList[i]
			else
				result = result + deli + outputList[i]
		}
		return result;
	}

	this.add = function(kpiCode) {
		if (!kpiCode || kpiCode == "")
			return;
		for (var i = outputList.length - 1; i > -1; i--) {
			// alert("tt="+ outputList[i]+"^"+kpiCode)
			if (outputList[i] == kpiCode)
				return;
		}
		// alert("add_kpiCode="+kpiCode)
		outputList.push(kpiCode);

	}
	this.remove = function(kpiCode) {
		if (!kpiCode || kpiCode == "")
			return;
		for (var i = outputList.length - 1; i > -1; i--) {
			if (outputList[i] == kpiCode) {
				delete outputList[i]
				return;
			}

		}

	}

	// 2- 指标树 --end

	// 3- 医生指标对照关系grid -- start\\
	var serviceUrl = "dhcwl/docappcfg/dockpirel.csp";
	var serviceUrls3 = "dhcwl/docappcfg/savedockpidef.csp";

	// 复选框
	var selectedKpiIds = [];

	// 定义列
	var columnModelRel = new Ext.grid.ColumnModel([{
				header : 'ID',
				dataIndex : 'ID',
				sortable : true,
				width : 30,
				sortable : true
			}, {
				header : '医生指标ID',
				dataIndex : 'MDocKPIDr',
				width : 70,
				sortable : true
			}, {
				header : '系统指标ID',
				dataIndex : 'MKPIdr',
				width : 70,
				sortable : true
			}, {
				header : '指标维度',
				dataIndex : 'MKPIDim',
				width : 70,
				sortable : true
			}, {
				header : '维度属性',
				dataIndex : 'MDimProp',
				width : 70,
				sortable : true
			}, {
				header : '其它过滤规则',
				dataIndex : 'OtherFilterRule',
				width : 60
			}]);
	// 定义指标的存储模型
	var storeRel = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=mulSearch'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNum',
							root : 'root1',
							fields : [{
										name : 'ID'
									}, {
										name : 'MDocKPIDr'
									}, {
										name : 'MKPIdr'
									}, {
										name : 'MKPIDim'
									}, {
										name : 'MDimProp'
									}, {
										name : 'OtherFilterRule'
									}]
						})
			});
	// start

	// 列表
	var gridRel = new Ext.grid.GridPanel({
				stripeRows : true,
				loadMask : true,
				height : 120,
				store : storeRel,
				id : "consTables2",
				resizeAble : true,
				enableColumnResize : true,
				cm : columnModelRel,
				listeners : {
					'contextmenu' : function(event) {
						event.preventDefault();
						var sm = this.getSelectionModel();
						var record = sm.getSelected();
						if (record) {
							var record = sm.getSelected();
						}
					}
				}
			});

	// 3- 医生指标对照关系grid -- end

	// mcShowWin
	var docKpiForm = new Ext.Panel({
				title : '医生应用指标',
				layout : 'form',
				height : 507,
				width : 559,
				items : [grid, kpiPanelList2]
			});

	var newPanel = new Ext.Panel({
				layout : 'form',
				height : 700,
				width : 600,
				items : kpiList
			})
	// otherFilterForm
	var taskPanel = new Ext.Panel({
				id : 'dhcwl.msgcfg.MaintainMsgTasks.taskPanel',
				/*
				
				layout : 'table',
				layoutConfig : {
					columns : 2
				},
				items : [{
							autoScroll : true,
							height : 640,
							items : docKpiForm
						}, {
							height : 640,
							items : newPanel
						}]
						
						*/
				layout:'hbox',
				layoutConfig: {
					align : 'stretch',
					pack  : 'start'
				},
				items: [
					{
						layout:'vbox',
						layoutConfig: {
							align : 'stretch',
							pack  : 'start'
						},						
						items:[{
							flex:2,
							layout:'fit',
							items:grid 
						},{
							flex:1,
							layout:'fit',
							items:kpiPanelList2
						}], 
						flex:1
					},{
						layout:'fit',
						items:kpiList, 
						flex:1
					}
				]
						
						
						
			});

	store.load({
				params : {
					start : 0,
					limit : 23,
					onePage : 1
				}
			});

	this.getStore = function() {
		return store;
	}
	this.getColumnModel = function() {
		return columnModel;
	}
	this.getMcShowWin = function() {
		return mcShowWin;
	}
	this.getConsForm = function() {
		return consForm;
	}
	this.getMcGrid = function() {
		return grid;
	}
	this.getRecord = function() {
		return record;
	}

	this.mainWin = new Ext.Viewport({
				id : 'maintainMsgsMain',
				autoShow : true,
				expandOnShow : true,
				resizable : true,
				layout : 'fit',
				items : [taskPanel]
			});

	this.getDocKpiDefPanel = function() {
		return mcShowWin;
	}
		// //////////////////////////////////////////////////////////////////////////////
		// /////////////////////////////////////////////////////////////////////////////
		// /////////////////////////////////////////////////////////////////////////////
		// --201506--
}

)
// dhcwl.msgcfg.MaintainMsgTasks.prototype
