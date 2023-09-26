var schemUrl = '../csp/dhc.bonus.deptbonuscalcexe.csp';
var schemProxy = new Ext.data.HttpProxy({
			url : schemUrl + '?action=schemlist'
		});
var userCode = session['LOGON.USERCODE'];
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
			width : 80,
			listWidth : 80,
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
			width : 80,
			listWidth : 80,
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
			width : 80,
			listWidth : 200,
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
								userCode : session['LOGON.USERCODE'],
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
							'AuditingFlag', 'AuditingDate', 'person', 'IsDate',
							'IsPay']),
			remoteSort : true
		});

schemDs.setDefaultSort('rowid', 'desc');

var schemeTypeSt = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'code', 'name'])
		});
schemeTypeSt.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.bonusschemtypeexe.csp?action=list&start=0&limit=10',
				//method : 'GET'
				 method:'POST'
			});
});

// 奖金方案类别
var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '方案类型',
			//name : 'type',
			id: 'schemeTypeCombo',
			name : 'schemeTypeCombo',
			width : 150,
			listWidth : 200,
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			// mode : 'local',
			forceSelection : true,
			pageSize : 10,
			triggerAction : 'all',
			emptyText : '',
			selectOnFocus : true,
			anchor : '100%'
		});

schemeTypeCombo.on('select', function() {
	p_SchemeType = schemeTypeCombo.value
	if (Ext.getCmp('periodField').getValue() != '')
		tmpStore.removeAll();

	schemDs.load({
				params : {
					bonusYear : Ext.getCmp('periodYear').getValue(),
					bonusPeriod : Ext.getCmp('periodField').getValue(),
					userCode : session['LOGON.USERCODE'],
					schemeType : p_SchemeType,
					start : 0,
					limit : schemPagingToolbar.pageSize
				}
			});
		// alert(p_SchemeType)
	})

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
			width : 100,
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
			width : 70,
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
		}, {
			header : "下发标志",
			dataIndex : 'IsPay',
			width : 50,
			align : 'center',
			sortable : true,
			renderer : function(v, p, record) {
				if (v == 1) {
					return "下发成功";
				} else {
					return "";
				}
			}
		}, {
			header : "下发人",
			dataIndex : 'person',
			width : 40,
			align : 'center',
			sortable : true
		}, {
			header : "下发时间",
			dataIndex : 'IsDate',
			width : 80,
			align : 'center',
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
// 导入人员下发奖金
var uploadButton = new Ext.Toolbar.Button({
			text : '导入人员奖金',
			tooltip : '导入数据(Excel格式)',
			iconCls : 'add',
			handler : function() {

				importExcel();

				return;

			}

		});

// ==============2012-3-30===limingzhong====奖金下发===============================================
var DownButton = new Ext.Toolbar.Button({
	text : '奖金下发',
	tooltip : '发送给科室进行奖金二次分配！',
	iconCls : 'add',
	handler : function() {
		var rowObj = SchemGrid.getSelections();
		var len = rowObj.length;
		if (len < 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择奖金方案!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return false;
		} else {

			function datadown(rowObj) {

				var schemCode = rowObj[0].get("BonusSchemeCode");
				var year = Ext.getCmp('periodYear').getValue();
				var period = Ext.getCmp('periodField').getValue();
				var isCalc = rowObj[0].get("rowid")
				if(year==""){
				         Ext.Msg.show({
							title : '注意',
							msg : '核算年度不能为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				       return false;
			}
			if(isCalc==''){
				         Ext.Msg.show({
							title : '注意',
							msg : '该月奖金未核算，不能下发!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				       return false;
			}
				
				// alert('../csp/dhc.bonus.deptbonuscalcexe.csp?action=down&schemCode='+schemCode+'&year='+year+'&period='+period+'&userCode='+session['LOGON.USERCODE'])
				Ext.Ajax.request({
					url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=down&schemCode='
							+ schemCode
							+ '&year='
							+ year
							+ '&period='
							+ period
							+ '&userCode=' + session['LOGON.USERCODE'],
					waitMsg : '正在下发中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '提示',
									msg : '请检查网络连接...',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						// alert(jsonData)
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '提示',
										msg : '数据下发成功!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});
							schemDs.load({
										params : {
											bonusYear : year,
											bonusPeriod : period,
											schemeType : p_SchemeType,
											userCode : session['LOGON.USERCODE'],
											start : 0,
											limit : schemPagingToolbar.pageSize
										}
									});
						} else {
							Ext.Msg.show({
										title : '错误',
										msg : '数据下发失败',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				});
			}

			// 1.判断该方案是否已经被审核
			var auditFlag = rowObj[0].get("AuditingFlag");
			if (auditFlag == "已审核") {

				// 2.根据条件进行奖金下发到科室
				if (rowObj[0].get("IsPay") == "1") {

					Ext.MessageBox.confirm('提示', '数据已经下发，是否要重新下发?', handler1);
					function handler1(id) {
						if (id == "yes") {
							datadown(rowObj)
						}
					}
	
				} else {
					datadown(rowObj)

				}
			} else if (auditFlag == "未审核"){
				Ext.Msg.show({
							title : '注意',
							msg : '该方案未审核，请先审核!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
		}
	}
});
// ==============2012-3-30===limingzhong====奖金下发===============================================

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
						params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
					});
		}
	}
});

var SchemGrid = new Ext.grid.GridPanel({// 表格
	title : '单元奖金方案核算',
	region : 'north',
	height : 210,
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
	tbar : ['方案类型:', schemeTypeCombo, '核算年度:', periodYear, '-', '期间类型:',
			periodTypeField, '-', '核算期间:', periodField, '-', BonusCalcButton,
			'-', BonusAuditingButton, '-', DownButton],
	bbar : schemPagingToolbar
});
// ,'-',uploadButton
// ------组件事件加载-----begin-----------------

// 核算期间 选择期间
periodField.on("select", function(cmb, rec, id) {
			if (Ext.getCmp('periodField').getValue() != '') {
				tmpStore.removeAll();

				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								schemeType : p_SchemeType,
								userCode : session['LOGON.USERCODE'],
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

var tmpStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
						url : ''
					}),
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}),
			remoteSort : true
		});

// ----------------函数处理------------------------------------
// 显示奖金核算明细
function showBonusDetail(grid, rowIndex, e) {

	var selectedRow = schemDs.data.items[rowIndex];

	schemRowId = selectedRow.data["rowid"];
	schemName = selectedRow.data["BonusSchemeName"];
	schemCode = selectedRow.data["BonusSchemeCode"];
	// var str=schemRowId+":"+schemCode+":"+schemName

	sbonusYear = Ext.getCmp('periodYear').getValue(), sbonusPeriod = Ext
			.getCmp('periodField').getValue(),

	bonusitemgrid.setTitle(schemName + "-所对应奖金核算项");
	Ext.Ajax.request({
		url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=getTitleInfo&sMainSchemeCode='
				+ schemCode,
		waitMsg : '正在核算中...',
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
				if (i<3) { 
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
				} else
				{
				cmConfig = {
					header : jsonHeadList[i].title,
					dataIndex : jsonHeadList[i].IndexName,
					width : 95,
					sortable : true,
					align : 'right',
					editor : new Ext.form.TextField({
								allowBlank : true
							})

					}}

				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 提取奖金项数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping

			tmpStore.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.deptbonuscalcexe.csp?action=getBonusDetail&sMainSchemeCode='
						+ schemCode
						+ '&bonusPeriod='
						+ sbonusPeriod
						+ '&bonusYear=' + sbonusYear,
				method : 'POST'
			})

			tmpStore.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);

			bonusitemgrid.reconfigure(tmpStore, tmpColumnModel);
			tmpStore.load({
						params : {
							start : 0,
							limit : jxUnitPagingToolbar.pageSize
						}
					});
			jxUnitPagingToolbar.bind(tmpStore);
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


   var Year= periodYear.getValue();                  //核算年度
   var periodType = periodTypeField.getValue();     //期间类型
   var period = periodField.getValue();            //核算期间
	
	
	
	if (Year == "") {
		Ext.Msg.show({
					title : '错误',
					msg : '核算年度不能为空',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
	
	if (periodType == "") {
		Ext.Msg.show({
					title : '错误',
					msg : '期间类型不能为空',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
			
			
	if (period == "") {
		Ext.Msg.show({
					title : '错误',
					msg : '核算期间不能为空',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
				return;
			};
			
			
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

			// 添加奖金核算进度条
			var progressBar = Ext.Msg.show({
						title : "奖金核算",
						msg : "'正在核算中...",
						width : 300,
						wait : true,
						closable : true
					});
	//------------------------------------------			
			var year = rowObj[0].get("BonusYear")	
			var month = Ext.getCmp('periodField').getValue()
					
			 var flag ="";
		     Ext.Ajax.request({
					url:  schemUrl + '?action=statejudgement&year=' + year + '&month='+ month ,
							waitMsg : '处理中...',
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
									flag = jsonData.info;
									if (flag==0) {
										Ext.Msg.show({
											title : '注意',
											msg : '奖金数据采集中，不能进行核算!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										}
										
										else if(flag ==-1) {
										Ext.Msg.show({
											title : '注意',
											msg : '请先设置会计期间!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										return;
										}
										
									else if(flag==2) {
										Ext.Msg.show({
											title : '注意',
											msg : '奖金数据已经结账，不能进行核算!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
										}
									else{
										var surl = schemUrl + '?action=bonuscalc&BonusSchemeCode='
						                           + BonusSchemeCode + '&sBonusPeriod=' + sBonusPeriod;
										Account(surl)
											}
									} else {
										Ext.Msg.show({
											title : '错误',
											msg : '错误',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
										}
								},
								scope : this
								});
//----------------------------------------------------------
//			Ext.Ajax.request({
//				url : schemUrl + '?action=bonuscalc&BonusSchemeCode='
//						+ BonusSchemeCode + '&sBonusPeriod=' + sBonusPeriod,
//				waitMsg : '正在核算中...',
//				timeout: 100000000,
//				failure : function(result, request) {
//					Ext.Msg.show({
//								title : '提示：',
//								msg : '数据正在核算,请您稍后......',
//								buttons : Ext.Msg.OK,
//								icon : Ext.MessageBox.ERROR
//							});
//				},
//				success : function(result, request) {
//					var rtn = result.responseText;
//					// prompt("result",rtn)
//
//					var jsonData = Ext.util.JSON.decode(result.responseText);
//
//					if (jsonData.success == 'true') {
//						Ext.Msg.show({
//									title : '注意',
//									msg : '数据核算成功!',
//									buttons : Ext.Msg.OK,
//									icon : Ext.MessageBox.INFO
//								});
//
//						schemDs.load({
//							params : {
//								bonusYear : Ext.getCmp('periodYear').getValue(),
//								bonusPeriod : Ext.getCmp('periodField')
//										.getValue(),
//								userCode : session['LOGON.USERCODE'],
//								schemeType : p_SchemeType,
//								start : 0,
//								limit : schemPagingToolbar.pageSize
//							}
//						});
//
//						// showBonusDetail(SchemGrid, 1)
//
//						window.close();
//					} else {
//						var message = "";
//						message = "奖金方案核算失败！";
//						Ext.Msg.show({
//									title : '错误',
//									msg : jsonData.info,
//									buttons : Ext.Msg.OK,
//									icon : Ext.MessageBox.ERROR
//								});
//					}
//				},
//				scope : this
//			});

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
								userCode : session['LOGON.USERCODE'],
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

function Account(surl){
         Ext.Ajax.request({
				url : surl,
				waitMsg : '正在核算中...',
				timeout: 100000000,
				failure : function(result, request) {
					Ext.Msg.show({
								title : '提示：',
								msg : '数据正在核算,请您稍后......',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var rtn = result.responseText;
					// prompt("result",rtn)

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
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});

						// showBonusDetail(SchemGrid, 1)

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
