
//var userid="";
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
// var acctbookid=GetAcctBookID();

//=================================查询条件 FormPanel==========================//
//会计期间
/*	var periodDate = new Ext.form.DateField({
fieldLabel: '会计期间',
name: 'periodDate',
id: 'dtMonth',
width:130,
plugins: 'monthPickerPlugin',
format: 'Y-m',
editable : false,
allowBlank : false,
emptyText:'请选择年月...',
maxValue : new Date(),
plugins: 'monthPickerPlugin',
listeners : {
scope : this,
'select' : function(dft){
}
}
});*/

//----------------- 查询按钮-----------------//
/* var buttQuery = new Ext.Button({
text:"&nbsp;查&nbsp;&nbsp;询&nbsp;",
handler:function(){ Query();}

});*/
var periodDate = new Ext.form.DisplayField({
		fieldLabel: '会计期间',
		// inputType:'text',
		style: 'padding-top:3px;'
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.finalbillexe.csp?action=GetAcctCurYearMonth&acctbookid=' + acctbookid,
	failure: function (result, request) {
		//Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK});
	},
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		var year = jsonData.info;

		periodDate.setValue(year.replace("^", "-"));
	}
});

//------------期末结账--按钮---------//
var settleAccountsBtn = new Ext.Button({
		text: "&nbsp;期末结账&nbsp;",
		iconCls: 'finalbill',
		handler: function () {
			var period = periodDate.getValue();
			//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
			var year = period.split("-")[0];
			var month = period.split("-")[1];
			//alert(period);
			if (period == "-") {
				Ext.Msg.show({
					title: '注意',
					msg: ' 请先登录账套 ',
					icon: Ext.MessageBox.INFO,
					buttons: Ext.Msg.OK
				});
			} else {
				//=====================等待窗体==========================//
				var myMask = new Ext.LoadMask(Ext.getBody(), {
						msg: '结账处理中，请稍后！',
						removeMask: true //完成后移除
					});

				Ext.MessageBox.confirm('提示', '是否要进行期末结账? ', function (btn) {
					if (btn == "yes") {

						myMask.show();
						Ext.Ajax.request({
							url: '../csp/herp.acct.finalbillexe.csp?action=settleAccounts&period=' + period + "&btn=&userid=" + userid,
							failure: function (result, request) {
								myMask.hide();
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
									myMask.hide();

									Ext.Msg.show({
										title: '注意',
										msg: '结账成功！ ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.INFO,
										fn: function (btn, text) {
											if (btn == 'ok') {
												document.execCommand('Refresh');
											}

										}
									});
									// document.execCommand('Refresh');
								} else {
									if (jsonData.info == 'isSelfAcct') {
										var message = year + "年" + month + "月已经结账，不能再次结账！  ";
										myMask.hide();
										Ext.Msg.show({
											title: '错误',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									} else if (jsonData.info == 'isNotAcct') {
										var message = "本期有未记账凭证,不能结账！ ";
										myMask.hide();
										Ext.Msg.show({
											title: '错误',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									} else if (jsonData.info == 'haveNextYearAcct') {
										myMask.hide();
										Ext.MessageBox.confirm('提示', '下年账已经存在，是否覆盖下年数据？ ', function (btn) {
											if (btn == "yes") {
												myMask.show();
												Ext.Ajax.request({
													url: '../csp/herp.acct.finalbillexe.csp?action=isHasNextYearAcct&period=' + period + "&userid=" + userid + "&btn=" + btn,
													failure: function (result, request) {
														myMask.hide();
														Ext.Msg.show({
															title: '错误',
															msg: '请检查网络连接! ',
															buttons: Ext.Msg.OK
														});
													},
													success: function (result, request) {
														var jsonData = Ext.util.JSON.decode(result.responseText);
														if (jsonData.success == 'true') {
															myMask.hide();
															Ext.Msg.show({
																title: '注意',
																msg: '下年账生成成功！',
																icon: Ext.MessageBox.INFO,
																buttons: Ext.Msg.OK
															});
														} else {
															var message = "下年账生成失败！ "
																myMask.hide();
															Ext.Msg.show({
																title: '错误',
																msg: message,
																buttons: Ext.Msg.OK,
																icon: Ext.MessageBox.ERROR
															});
														}

													},
													scope: this
												});
											}
										});
									} else if (jsonData.info == 'error') {
										myMask.hide();
										Ext.Msg.show({
											title: '错误',
											msg: '财务报表生成失败，请确保报表公式的准确性！  ',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									} else {
										var info = jsonData.info;

										var infoSta = info.indexOf('isAgoAcct');
										var isNotZero = info.indexOf("isNotZero");
										if (infoSta != -1) {
											var infoArry = info.split("^");
											var message = ""
												for (var i = 1; i < infoArry.length; i++) {
													var infoYear = infoArry[i].split("*")[0];
													var infoMonth = infoArry[i].split("*")[1];

													message = message + infoYear + "年" + infoMonth + "月未结账,"
												}
												message = message + "本期不能结账! "

												myMask.hide();
											Ext.Msg.show({
												title: '错误',
												msg: message,
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
										} else if (isNotZero != -1) {
											var infoArry = info.split("^");
											var message = " 收支科目:"
												for (var i = 1; i < infoArry.length; i++) {

													message = message + infoArry[i] + ","
												}
												message = message + "余额不为0,是否继续？ "
												myMask.hide();
											Ext.MessageBox.confirm('提示', message, function (btn) {

												if (btn == "yes") {
													myMask.show();
													Ext.Ajax.request({
														url: '../csp/herp.acct.finalbillexe.csp?action=buildBill&period=' + period + "&userid=" + userid + "&acctbookid=" + acctbookid,
														waitMsg: '结账中...',
														failure: function (result, request) {
															myMask.hide();
															Ext.Msg.show({
																title: '错误',
																msg: '请检查网络连接! ',
																buttons: Ext.Msg.OK
															});
														},
														success: function (result, request) {
															var jsonData = Ext.util.JSON.decode(result.responseText);

															if (jsonData.success == 'true') {
																myMask.hide();
																Ext.Msg.show({
																	title: '注意',
																	msg: '结账成功！ ',
																	icon: Ext.MessageBox.INFO,
																	buttons: Ext.Msg.OK,
																	fn: function (btn, text) {
																		if (btn == 'ok') {
																			document.execCommand('Refresh');

																		}
																	}
																});
															} else {
																if (jsonData.info == 'haveNextYearAcct') {
																	myMask.hide();
																	Ext.MessageBox.confirm('提示', '下年账已经存在,是否覆盖下年数据？ ', function (btn) {
																		if (btn = "yes") {
																			myMask.show();
																			Ext.Ajax.request({
																				url: '../csp/herp.acct.finalbillexe.csp?action=isHasNextYearAcct&period=' + period + '&btn=' + btn + "&userid=" + userid,
																				failure: function (result, request) {
																					myMask.hide();
																					Ext.Msg.show({
																						title: '错误',
																						msg: '请检查网络连接! ',
																						buttons: Ext.Msg.OK
																					});
																				},
																				success: function (result, request) {
																					var jsonData = Ext.util.JSON.decode(result.responseText);

																					if (jsonData.success == 'true') {
																						myMask.hide();
																						Ext.Msg.show({
																							title: '注意',
																							msg: '下年账生成成功！ ',
																							icon: Ext.MessageBox.INFO,
																							buttons: Ext.Msg.OK,
																							fn: function (btn, text) {
																								if (btn == 'ok') {
																									document.execCommand('Refresh');

																								}
																							}
																						});
																					} else {
																						var message = "下年账生成失败！ "
																							myMask.hide();
																						Ext.Msg.show({
																							title: '错误',
																							msg: message,
																							buttons: Ext.Msg.OK,
																							icon: Ext.MessageBox.ERROR
																						});
																					}

																				},
																				scope: this
																			});
																		}
																	});
																} else {
																	myMask.hide();
																	Ext.Msg.show({
																		title: '错误',
																		msg: '结账失败  ',
																		icon: Ext.MessageBox.INFO,
																		buttons: Ext.Msg.OK
																	});
																}
															}
														},
														scope: this
													});
												}
											});
										} else {
											myMask.hide();
											Ext.Msg.show({
												title: '错误',
												msg: '结账失败  ',
												icon: Ext.MessageBox.INFO,
												buttons: Ext.Msg.OK
											});
										}
									}
								}

							},
							scope: this
						});
					}
				});
			}

		}
	});

//--------------- 反结账--按钮---------//
var counterSettlingAccountsBtn = new Ext.Button({
		text: "&nbsp;反结账&nbsp;",
		iconCls: 'return_finalbill',
		handler: function () {
			var period = periodDate.getValue();
			//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
			var year = period.split("-")[0];
			var month = period.split("-")[1];

			if (period == "-") {
				Ext.Msg.show({
					title: '注意',
					msg: '请先登录账套！ ',
					icon: Ext.MessageBox.INFO,
					buttons: Ext.Msg.OK
				});
			} else {
				//=====================等待窗体==========================//
				var myMask = new Ext.LoadMask(Ext.getBody(), {
						msg: '反结账处理中，请稍后！ ',
						removeMask: true //完成后移除
					});

				Ext.MessageBox.confirm('提示', '本功能将反结帐，是否继续  ', function (btn) {
					if (btn == "yes") {
						myMask.show();
						//当确认进行结转时
						Ext.Ajax.request({
							url: '../csp/herp.acct.finalbillexe.csp?action=counterSettlingAccounts&period=' + period + "&userid=" + userid,
							waitMsg: '反结账中...',
							failure: function (result, request) {
								myMask.hide();
								Ext.Msg.show({
									title: '错误',
									msg: '请检查网络连接!  ',
									buttons: Ext.Msg.OK
								});
							},
							success: function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);

								if (jsonData.success == 'true') {

									Ext.Msg.show({
										title: '注意',
										msg: '反结帐完毕！ ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK,
										fn: function (btn, text) {
											if (btn == 'ok') {
												document.execCommand('Refresh');

											}
										}
									});
									// Ext.MessageBox.confirm('提示', '反结帐完毕！ ', function(btn){
									// document.execCommand('Refresh');
									// });
								} else if (jsonData.info == 'ishasVouch') {

									Ext.Msg.show({
										title: '注意',
										msg: year + '年' + month + '月有记账的凭证，请先反记账，然后再反结账！ ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
								} else if (jsonData.info == 'noFan') {

									Ext.Msg.show({
										title: '注意',
										msg: ' 当前年月与账套开始年月相同，不能进行反结账！  ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
								} else {

									var message = "反结账失败！没有本年月账簿！  ";
									Ext.Msg.show({
										title: '错误',
										msg: message,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR,
										fn: function (btn, text) {
											if (btn == 'ok') {
												document.execCommand('Refresh');

											}
										}
									});
								}
								myMask.hide();
								//document.execCommand('Refresh')
							},
							scope: this
						});

					}
				});
			}

		}
	});
