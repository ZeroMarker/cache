var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// ************************************************
/*
var budgDataInitUrl = 'herp.budg.budgdatainitexe.csp';
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
		})
*/



var ChangeFlagStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '期初预算'], ['2', '调整后预算']]  
		});
var ChangeFlagField = new Ext.form.ComboBox({
			id : 'ChangeFlagField',
			fieldLabel : '预算额度',
			width : 100,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : false,
			store : ChangeFlagStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			selectOnFocus : true,
			forceSelection : true
		});

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
			width : 70,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .11,
			selectOnFocus : true
		});
var date = new Date();
	yearCombo.setValue(date.getFullYear()+1);

//////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=dept&userdr='+userdr,
						method : 'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

/////////////////年度数据平均分解到月////////////////
var AverageButton = new Ext.Toolbar.Button({
			text : '平均分解到月',
			tooltip : '把科室年度数据平均分解到各个月',
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
				var deptdr = deptCombo.getValue();
				if (deptdr == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '科室不能为空',
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
									url : 'herp.budg.budgdatadeptoperexe.csp'
											+ '?action=UpAverage&year='
											+ syear+'&deptdr='+deptdr,
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
			value : '<center><p style="font-weight:bold;font-size:150%">科室年度预算值平均分解到月</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '预算年度:',
					columnWidth : .07
				}, yearCombo,
				 {
					xtype : 'displayfield',
					value : '',
					columnWidth : .04
				},{
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .07
				}, deptCombo,
				 {
					xtype : 'displayfield',
					value : '',
					columnWidth : .04
				}, AverageButton

		]
	}/*,{
		columnWidth : 1.2,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '预算额度:',
					columnWidth : .076
				}, ChangeFlagField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .13
				}, SummarizeButton, 
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .01
				}, AuSummarizeButton
		]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">说明：将参考历史数据年度内的平均数做为预算编制年度的预算编制依据。</p>',
			columnWidth : 1,
			height : '30'
		}]
	}*/]
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
