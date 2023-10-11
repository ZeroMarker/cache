
// ************************************************
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var budgDataInitUrl = 'herp.budg.budgdatainitexe.csp';
/***
var SummarizeButton = new Ext.Toolbar.Button({
			text : '上级科目汇总',
			tooltip : '末级科目数据汇总到上级科目',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				var changeflag = ChangeFlagField.getValue();
				if (changeflag == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '请选择需要汇总的额度',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				function handler(id) {

					if (id == 'yes') {
						// 添加数据初始化进度条
						var progressBar = Ext.Msg.show({
									title : "上级科目汇总",
									msg : "'数据正在处理中...",
									width : 300,
									wait : true,
									closable : true
								});
						Ext.Ajax.request({
									timeout : 30000000,
									url : budgDataInitUrl
											+ '?action=Summarize&year='
											+ syear + '&changeflag=' + changeflag,
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
														msg : '数据操作成功!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要汇总计算吗?', handler);
			}
		})
var DSummarizeButton = new Ext.Toolbar.Button({
			text : '上级科室汇总',
			tooltip : '末级科室数据汇总到上级科室',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				var changeflag = ChangeFlagField.getValue();
				if (changeflag == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '请选择需要汇总的额度',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				function handler(id) {

					if (id == 'yes') {
						// 添加数据初始化进度条
						var progressBar = Ext.Msg.show({
									title : "上级科目汇总",
									msg : "'数据正在处理中...",
									width : 300,
									wait : true,
									closable : true
								});
						Ext.Ajax.request({
									timeout : 30000000,
									url : budgDataInitUrl
											+ '?action=DSummarize&year='
											+ syear + '&changeflag=' + changeflag,
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
														msg : '数据操作成功!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要汇总计算吗?', handler);
			}
		})
///////////////////科室汇总到全院////////////////////		
var AuSummarizeButton = new Ext.Toolbar.Button({
			text : '科室到全院汇总',
			tooltip : '把科室预算值汇总到全院',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				var changeflag = ChangeFlagField.getValue();
				if (changeflag == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '请选择需要汇总的额度',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				function handler(id) {

					if (id == 'yes') {
						// 添加数据初始化进度条
						var progressBar = Ext.Msg.show({
									title : "科室到全院汇总",
									msg : "'数据正在处理中...",
									width : 300,
									wait : true,
									closable : true
								});
						Ext.Ajax.request({
									timeout : 30000000,
									url : budgDataInitUrl
											+ '?action=AuSummarize&year='
											+ syear + '&changeflag=' + changeflag,
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
														msg : '数据操作成功!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要汇总计算吗?', handler);
			}
		})***/

var estimateDataButton = new Ext.Toolbar.Button({
	text : '预估数据计算',
	tooltip : '预估数据计算',
	// iconCls:'add',
	handler : function() {
		var syear = yearCombo.getValue();
		if (syear == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '预算年度不能为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};

		var bMonth = beginDateField.getValue();
		if (bMonth == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '历史开始年份不能为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		var eMonth = endDateField.getValue();
		if (eMonth == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '历史结束年份不能为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};

		function handler(id) {
			if (id == 'yes') {
				var progressBar = Ext.Msg.show({
							title : "预估数据计算",
							msg : "'数据正在处理中...",
							width : 300,
							wait : true,
							closable : true
						});
				Ext.Ajax.request({
					timeout : 30000000,
					url : budgDataInitUrl + '?action=estimateData&bgyear='
							+ syear + '&bMonth=' + bMonth + '&eMonth=' + eMonth,
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
										msg : '数据操作成功!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.INFO
									});

						} else {
							Ext.Msg.show({
										title : '错误',
										msg : jsonData.info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				})
			}
		}
		Ext.MessageBox.confirm('提示', '确实要预估数据计算吗?', handler);
	}
})
var referDataButton = new Ext.Toolbar.Button({
			text : '参考数据计算',
			tooltip : '参考数据计算',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				var bYear = yearCombo2.getValue();
				if (bYear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '历史开始年份不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				var eYear = yearCombo3.getValue();
				if (eYear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '历史结束年份不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				function handler(id) {

					if (id == 'yes') {
						// 添加数据初始化进度条
						var progressBar = Ext.Msg.show({
									title : "参考数据计算",
									msg : "'数据正在处理中...",
									width : 300,
									wait : true,
									closable : true
								});
						Ext.Ajax.request({
									timeout : 30000000,
									url : budgDataInitUrl
											+ '?action=referData&bgyear='
											+ syear + '&bYear=' + bYear
											+ '&eYear=' + eYear,
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
														msg : '数据操作成功!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要参考数据计算吗?', handler);
			}
		})

var dataInitButton = new Ext.Toolbar.Button({
			text : '数据初始化',
			tooltip : '数据初始化',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				var scheme = -1 // schemTypeCombo.getValue();
				if (scheme == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算方案不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				function handler(id) {
					if (id == 'yes') {

						// 添加奖金核算进度条
						var progressBar = Ext.Msg.show({
									title : "数据初始化",
									msg : "数据正在初始化中...",
									width : 300,
									wait : true,
									closable : true
								});

						Ext.Ajax.request({
									timeout : 30000000,									
									url : budgDataInitUrl
											+ '?action=datainit&bgyear='
											+ syear + '&bgscheme=' + scheme,
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
														msg : '初始化完成!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要进行数据初始化吗?', handler);
			}
		})
/***
/////////////////年度数据平均分解到月////////////////
var AverageButton = new Ext.Toolbar.Button({
			text : '平均分解到月',
			tooltip : '把年度数据平均分解到各个月',
			// iconCls:'add',
			handler : function() {
				var syear = yearCombo.getValue();
				if (syear == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '预算年度不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				function handler(id) {
					if (id == 'yes') {

						// 添加奖金核算进度条
						var progressBar = Ext.Msg.show({
									title : "数据分解",
									msg : "数据处理中...",
									width : 300,
									wait : true,
									closable : true
								});

						Ext.Ajax.request({
									timeout : 30000000,									
									url : budgDataInitUrl
											+ '?action=UpAverage&year='
											+ syear,
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
														msg : '平均分解完成!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										} else {
											Ext.Msg.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								})
					}
				}
				Ext.MessageBox.confirm('提示', '确实要平均分解数据吗?', handler);
			}
		})
	**/	
var beginDateField = new Ext.form.ComboBox({
			fieldLabel : '开始月份',
			width : 104,
			listWidth : 104,
			store :  new Ext.data.ArrayStore({
			fields : ['key', 'keyValue'],
			data : [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
					['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
					['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
			}),
			//anchor : '90%',
			// value:'key', //默认值
			displayField : 'keyValue',
			valueField : 'key',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			selectOnFocus : true,
			forceSelection : true
		});


var endDateField = new Ext.form.ComboBox({
			fieldLabel : '结束月份',
			width : 103,
			listWidth : 103,
			store :  new Ext.data.ArrayStore({
			fields : ['key', 'keyValue'],
			data : [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
					['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
					['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']]
		}),
			//anchor : '90%',
			// value:'key', //默认值
			displayField : 'keyValue',
			valueField : 'key',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			selectOnFocus : true,
			forceSelection : true
		});

/***
var ChangeFlagField = new Ext.form.ComboBox({
			fieldLabel : '预算额度',
			width : 100,
			listWidth : 100,
			store  : new Ext.data.ArrayStore({
			fields : ['key', 'keyValue'],
			data : [['1', '期初预算'], ['2', '调整后预算']]
		}),
			anchor : '90%',
			// value:'key', //默认值
			displayField : 'keyValue',
			valueField : 'key',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			selectOnFocus : true,
			forceSelection : true
		});


**/




// ////////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 80,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .095,
			selectOnFocus : true
		});
var yearCombo2 = new Ext.form.ComboBox({
			fieldLabel : '年度2',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 70,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .095,
			selectOnFocus : true
		});
var yearCombo3 = new Ext.form.ComboBox({
			fieldLabel : '年度3',
			store : smYearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 70,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .095,
			selectOnFocus : true
		});

var schemeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

schemeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({

						url : 'herp.budg.budgfactyeardeptexe.csp?action=bsmnamelist',
						method : 'POST'
					})
		});

var schemTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算方案',
			store : schemeDs,
			// data:[['0','全院'],['1','科室']]
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 70,
			listWidth : 150,
			pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			hidden : true,
			// mode : 'local', // 本地模式
			selectOnFocus : true
		});
var schemNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});

var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'center',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">预算数据初始化</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '预算编制年度:',
					columnWidth : .08
				}, yearCombo,
				 {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, dataInitButton/*,
				 {
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, AverageButton***/

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '历史数据年度:',
					columnWidth : .081
				}, yearCombo2,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '至:',
					columnWidth : .03
				}, yearCombo3, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, referDataButton

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '预估数据月份:',
					columnWidth : .099
				}, beginDateField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .025
				}, {
					xtype : 'displayfield',
					value : '至:',
					columnWidth : .035
				}, endDateField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, estimateDataButton

		]
	},/**{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '预算额度:',
					columnWidth : .099
				}, ChangeFlagField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				}, SummarizeButton,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				}, DSummarizeButton, 
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .03
				}, AuSummarizeButton,PurgeIndicesButton
		]
	},**/{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">说明：将参考历史数据年度内的平均数做为预算编制年度的预算编制依据。</p>',
			columnWidth : 1,
			height : '30'
		}]
	}]
});

var itemDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

itemDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmainexe.csp'
								+ '?action=BudgItem&str='
								+ encodeURIComponent(Ext.getCmp('budgItem')
										.getRawValue()) + '&byear='
								+ yearCombo.getValue(),
						method : 'POST'
					})
		});

var itemcbbox = new Ext.form.ComboBox({
			id : 'budgItem',
			fieldLabel : '预算项目',
			width : 100,
			listWidth : 100,
			allowBlank : false,
			store : itemDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'budgItem',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});

// 主页面查询
var findButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			// iconCls:'add',
			handler : function() {
				// var billMakerTimeEnd
				// =((billMakerTimeTo.getValue()=='')?'':billMakerTimeTo.getValue().format('Y-m-d'));
				var syear = yearCombo.getValue();
				var sSchemType = -1// schemTypeCombo.getValue();
				var sSchemeName = schemNo.getValue();

			},
			iconCls : 'add'
		})

// 给主页面添加查询按钮

// itemGrid.hiddenButton(3);
// itemGrid.hiddenButton(4);