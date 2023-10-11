var UserId = session['LOGON.USERID'];
var AcctBookID = IsExistAcctBook();

var VouchBatchUrl = '../csp/herp.acct.acctvouchbatchaccountexe.csp';

//时间控件
var AcctYearMonthField = new Ext.form.DateField({
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		fieldLabel: '会计期间',
		emptyMsg: "",
		format: 'Y-m',
		plugins: 'monthPickerPlugin', //调用年月控件，避免结账日是31日时，没有31日的月份不能查询
		width: 120,
		triggerAction: 'all',
		allowBlank: true
		//listeners:{
		//"afterrender":function(combo){
		//accty=combo.value.substring(0,4);
		//acctm=combo.value.substring(5,7);
		//	}
		//}
	});

//取当前账套会计期间
Ext.Ajax.request({
	url: VouchBatchUrl + '?action=CurYearMonth&AcctBookID=' + AcctBookID,
	method: 'GET',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		var YearMonth = respText.info;
		//alert(YearMonth);
		AcctYearMonthField.setValue(YearMonth.replace('^', '-') + "-01");
		/*
		VouchBatchDs.load({
		params: {
		start: 0,
		limit: VouchBatchGrid.pageSize,
		AcctYear: strs[0],
		AcctMonth: strs[1],
		AcctBookID: AcctBookID
		}
		});
		 */
	},
	failure: function (result, request) {
		return;
	}
});


//查询条件
var CondQuery = new Ext.form.Checkbox({
		id: "CondQuery",
		fieldLabel:'符合条件',
		//width: 15,
		inputValue: 1,
		style: 'border:0;background:none;margin-top:0px;',
		checked: false,
		listeners: {
			'check': function () {
				FindButton.handler() //加入监听事件，改变状态时调查询方法
			}
		}
	});

//查询按钮
var FindButton = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'find',
		width: 80,
		cls: 'x-btn-text-icon',
		handler: function () {

			var AcctYearMonth = AcctYearMonthField.getRawValue();
			// alert(AcctYearMonth);
			if (AcctYearMonth != "") {
				// var acctyear = AcctYearMonth.format('Y');
				// var acctmonth= AcctYearMonth.format('M');
				var acctyear = AcctYearMonth.split("-")[0];
				var acctmonth = AcctYearMonth.split("-")[1];
			} else {
				//当会计期间为空时，清空store
				VouchBatchDs.removeAll();
				Ext.Msg.show({
					title: '错误',
					msg: '请输入会计期间! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			}
			var CondFlag = CondQuery.getValue();
			if (CondFlag != "")
				CondFlag = 1;
			else
				CondFlag = 0;
			VouchBatchDs.load({
				params: {
					start: 0,
					limit: VouchBatchGrid.pageSize,
					CondFlag: CondFlag,
					AcctYear: acctyear,
					AcctMonth: acctmonth,
					AcctBookID: AcctBookID
				}
			})
		}
	});

//记账按钮
var AcctRecButton = new Ext.Toolbar.Button({
		text: '记账',
		iconCls: 'account',
		width: 55,
		cls: 'x-btn-text-icon details',
		// disabled:true,
		handler: function () {
			var AcctRecButtonFlag = CondQuery.getValue();
			if (AcctRecButtonFlag != 1) {
				AcctRecButton.disabled = 0;
				Ext.Msg.show({
					title: '错误',
					msg: '请筛选符合条件的凭证! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				return;
			} else {
				FindButton.handler();
				var CondCount = CondCountField.getValue(); //VouchBatchGrid.getStore().getTotalCount();
				// alert(CondCount);
				if (CondCount == 0) {
					Ext.Msg.show({
						title: '错误',
						msg: '没有符合记账的数据! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
					return;
				} else if (VouchBatchGrid.getStore().getAt(0) != undefined) {
					Ext.MessageBox.confirm('提示', '确实要进行记账操作吗? ', function handler(id) {
						if (id == 'yes') {

							/*for(i=0;i<CondCount;i++){
							var AcctVouchID = VouchBatchGrid.getStore().getAt(i).data.rowid;
							var AcctYear = VouchBatchGrid.getStore().getAt(i).data.AcctYear;
							var AcctMonth = VouchBatchGrid.getStore().getAt(i).data.AcctMonth;
							 */
							var AcctYearMonth = AcctYearMonthField.getRawValue();
							var AcctYear = AcctYearMonth.split("-")[0];
							var AcctMonth = AcctYearMonth.split("-")[1];
							// alert(AcctYearMonth+"^"+AcctYear+"^"+AcctMonth);

							Ext.Ajax.request({
								url: VouchBatchUrl + '?action=update' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth
								 + '&UserId=' + UserId + '&AcctBookID=' + AcctBookID,
								// timeout : i*10000,
								async: false,
								failure: function (result, request) {
									Ext.Msg.show({
										title: '错误',
										msg: '请检查网络连接! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								},
								success: function (result, request) {

									var jsonData = Ext.util.JSON.decode(result.responseText);
									// alert("123");
									if (jsonData.success == 'true') {
										// 添加进度条
										var progressBar = Ext.MessageBox.show({
												title: "记账",
												msg: "正在记账中...",
												width: 300,
												progress: true,
												wait: true,
												waitConfig: {
													fn: function () {
														var ProgressTime = function (t) {
															return function () {
																if (t == CondCount) {
																	Ext.MessageBox.hide();
																} else {
																	Ext.MessageBox.updateProgress(t / CondCount, '正在更新第' + t + '条，一共' + CondCount + '条。');
																}
															};
														};
														for (var j = 1; j <= CondCount + 1; j++) {
															setTimeout(ProgressTime(j), 2000);
														};
													}
												},
												closable: true
											});
										Ext.Msg.show({
											title: '注意',
											msg: '记账完成! ',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.INFO
										});
										VouchBatchDs.load({
											params: {
												// start : 0,
												// limit : 25,
												AcctYear: AcctYear,
												AcctMonth: AcctMonth
											}
										});
										/* VouchBatchGrid.load({
										params:{
										start : 0,
										limit : 25
										}
										}); */

									} else {
										Ext.Msg.show({
											title: '错误',
											msg: jsonData.info,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									}

								},
								scope: this

							});
						};

						// VouchBatchDs.load();

					});
				}
				/* else{

				Ext.Msg.show({
				title : '错误',
				msg : '没有符合记账条件的凭证!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
				});
				} */
			}
		}

	});

//反记账按钮
var anti_AcctRecButton = new Ext.Toolbar.Button({
		text: '反记账',
		iconCls: 'return_account',
		width: 65,
		cls: 'x-btn-text-icon details',
		handler: function () {

			var AcctYearMonth = AcctYearMonthField.getRawValue();
			var AcctYear = AcctYearMonth.split("-")[0];
			var AcctMonth = AcctYearMonth.split("-")[1];
			/* VouchBatchDs.load({
			params:{
			// start : 0,
			// limit : 25,
			AcctYear:AcctYear,
			AcctMonth:AcctMonth
			}
			}); */
			Ext.MessageBox.confirm('提示', '您确实要将' + AcctYear + '年' + AcctMonth + '月的凭证进行反记账操作吗? ', function handler(id) {
				if (id == 'yes') {
					Ext.Ajax.request({
						url: VouchBatchUrl + '?action=antiAcctRec' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth
						 + '&UserId=' + UserId + '&AcctBookID=' + AcctBookID,

						failure: function (result, request) {
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
						},
						success: function (result, request) {

							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {

								// timeout:5000,	//5s延时
								/* // 添加进度条
								var progressBar = Ext.MessageBox.show({
										title: "反记账",
										msg: "正在进行反记账中...",
										width: 300,
										progress: true,
										wait: true,
										waitConfig: {
											fn: function () {
												var ProgressTime = function (t) {
													return function () {
														if (t == CondCount) {
															Ext.MessageBox.hide();
														} else {
															Ext.MessageBox.updateProgress(t / CondCount, '正在更新第' + t + '条，一共' + CondCount + '条。');
														}
													};
												};
												for (var j = 1; j <= CondCount + 1; j++) {
													setTimeout(ProgressTime(j), 2000);
												};
											}
										},
										closable: true
									});
								*/
								setTimeout(function () {
									Ext.Msg.show({
										title: '注意',
										msg: '反记账完成! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.INFO
									});
								}, 5000);

							} else {
								Ext.Msg.show({
									title: '错误',
									msg: jsonData.info,
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							}

						},
						scope: this

					});
					VouchBatchDs.load({
						params: {
							// start : 0,
							// limit : 25,
							AcctYear: AcctYear,
							AcctMonth: AcctMonth
						}
					});

				}

			})
		}
	});

//符合条件记录数据：
var CondCountField = new Ext.form.DisplayField({
		width: 70,
		style: 'padding-top:0px;text-align:left;color:red',
		triggerAction: 'all'
	});

//不符合条件记录数据：
var DisCondCountField = new Ext.form.DisplayField({
		width: 70,
		style: 'padding-top:0px;text-align:left;color:red',
		triggerAction: 'all'
	});
	
	
var queryPanel = new Ext.FormPanel({
		//autoHeight : true,
		region: 'north',
		frame: true,
		iconCls : 'find',
		height:50,
		defaults: {
			bodyStyle: 'padding:5px;'
		},
		items: [{
			xtype: 'panel',
			layout: 'column',
			columnWidth: 1,
			items: [{
				xtype: 'displayfield',
				value: '会计期间',
				width: 65
			},AcctYearMonthField,{
				xtype: 'displayfield',
				text: '',
				width: 30
			},CondQuery,{
				xtype: 'tbtext',
				text: '符合条件',
				style: 'padding-top:2px',
				width: 65
			},{
				xtype: 'displayfield',
				text: '',
				width: 30
			},
			FindButton]
		}]
})	


// 主数据源
var VouchBatchProxy = new Ext.data.HttpProxy({
		method: 'POST',
		url: VouchBatchUrl + '?action=BatchList' + '&AcctBookID=' + AcctBookID

	});

var VouchBatchDs = new Ext.data.Store({
		proxy: VouchBatchProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['rowid', 'AcctYear', 'AcctMonth', 'VouchDate', 'VouchNo', 'VouchBillNum', 'TotalAmount', 'Operator', 'IsCheck',
				'Auditor', 'Poster', 'VouchState', 'VouchProgress', 'VouchState1', 'TypeCode','CondCount', 'DisCondCount']),
		remoteSort: true
	});

//翻页是传年月
VouchBatchDs.on('beforeload', function (ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
			method: 'POST',
			url: VouchBatchUrl + '?action=BatchList' + '&AcctBookID=' + AcctBookID
			 + '&AcctYear=' + AcctYearMonthField.getRawValue().substring(0, 4)
			 + '&AcctMonth=' + AcctYearMonthField.getRawValue().substring(5, 7)
			 + '&CondFlag=' + (CondQuery.getValue()?1:0)
		});
});
/* var buttons = new Ext.Toolbar([AcctRecButton, '-', anti_AcctRecButton, {
				xtype: 'tbtext',
				text: '',
				width: 30
			},
			"符合条件记录数据：", CondCountField, "不符合条件记录数据：", DisCondCountField]); */

var VouchBatchGrid = new Ext.grid.GridPanel({
		atLoad: true,
		store: VouchBatchDs,
		pageSize: 25,
		region: 'center',
		trackMouseOver: true, //高亮鼠标所在行
		stripeRows: true, //隔行换色
		// autoHeight:true,
		viewConfig: { //表格视图配置
			// forceFit : true,		//强制调整表格列宽以适用表格的整体宽度，防止出现水平滚动条
			getRowClass: function (record) {
				if (parseInt(record.data.VouchState1)<21) {
					return "grid-discond-row-color";
				}
				if(parseInt(record.data.VouchState1)==21&&
				(record.data.TypeCode=="01"||record.data.TypeCode=="02")&&
				(record.data.IsCheck=="未复核")){
					return "grid-discond-row-color";
				}
			}
		},
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		loadMask: true,
		columns: [
			new Ext.grid.RowNumberer(), {
				id: 'AcctVouchID',
				header: 'AcctVouchID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				header: '<div style="text-align:center">年</div>',
				dataIndex: 'AcctYear',
				width: 60,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">月</div>',
				dataIndex: 'AcctMonth',
				width: 50,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">凭证日期</div>',
				dataIndex: 'VouchDate',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">凭证号</div>',
				dataIndex: 'VouchNo',
				width: 100,
				// sortable:true,	//列排序
				// align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				sortable: true
			}, {
				header: '<div style="text-align:center">附件张数</div>',
				dataIndex: 'VouchBillNum',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">总金额</div>',
				dataIndex: 'TotalAmount',
				align: 'right',
				width: 150,
				sortable: true
			}, {
				header: '<div style="text-align:center">制单人</div>',
				dataIndex: 'Operator',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">出纳签字</div>',
				dataIndex: 'IsCheck',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">审核人</div>',
				dataIndex: 'Auditor',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">记账人</div>',
				dataIndex: 'Poster',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">凭证状态</div>',
				dataIndex: 'VouchState',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				id: 'VouchProgress',
				header: '<div style="text-align:center">凭证处理过程</div>',
				dataIndex: 'VouchProgress',
				width: 120,
				align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				sortable: true
			}, {
				header: '<div style="text-align:center">凭证状态代码</div>',
				dataIndex: 'VouchState1',
				width: 70,
				align: 'center',
				sortable: true,
				hidden: true,
				renderer: function (value, cellmeta) {
					if (value !== "21")
						cellmeta.css = "background:red;";
					return value;
				}

			}, {
				header: '<div style="text-align:center">凭证类型</div>',
				dataIndex: 'TypeCode',
				width: 70,
				align: 'center',
				sortable: true,
				hidden: true
			}
		],
		tbar:[AcctRecButton, '-', anti_AcctRecButton, {
				xtype: 'tbtext',
				text: '',
				width: 30
			},
			"符合条件记录数据：", CondCountField, "不符合条件记录数据：", DisCondCountField],
/* 		listeners: {
			//换行放置按钮
			'render': function () {
				buttons.render(VouchBatchGrid.tbar)
			}
		}, */
		bbar: new Ext.PagingToolbar({
			store: VouchBatchDs,
			pageSize: 25,
			atLoad: true,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}条。',
			emptyMsg: "没有数据"
		})
	});

//凭证链接
VouchBatchGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '5') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = VouchBatchGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		var VouchState = records[0].get("VouchState1");
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + UserId + '&acctstate=' + VouchState + '&bookID=' + AcctBookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: '凭证查看',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // 表示为渲染window body的背景为透明的背景
				//bodyStyle : 'padding:5px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '关闭',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	}
	if (columnIndex == '13') {

		var selectedRow = VouchBatchDs.data.items[rowIndex];
		var AcctVouchID = selectedRow.data['rowid'];
		VouchProgressFun(AcctVouchID);
	}

});

//查询符合记账和不符合记账的数据数量
VouchBatchGrid.store.on('load',function(){
	var CurYearMonth=AcctYearMonthField.getRawValue();
	Ext.Ajax.request({
		url: VouchBatchUrl + '?action=Count&AcctBookID=' + AcctBookID+'&AcctMonth='+CurYearMonth,
		method: 'GET',
		success: function (result, request) {
			var objData = Ext.util.JSON.decode(result.responseText);
			CondCountField.setValue(objData.info.split("^")[0]);
			DisCondCountField.setValue(objData.info.split("^")[1]);
		},
		failure: function (result, request) {
			return;
		}
	});
});

