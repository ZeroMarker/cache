
//var userid="";
var acctbookid = IsExistAcctBook();
var userid = session['LOGON.USERID'];
// var acctbookid=GetAcctBookID();

//=================================��ѯ���� FormPanel==========================//
//����ڼ�
/*	var periodDate = new Ext.form.DateField({
fieldLabel: '����ڼ�',
name: 'periodDate',
id: 'dtMonth',
width:130,
plugins: 'monthPickerPlugin',
format: 'Y-m',
editable : false,
allowBlank : false,
emptyText:'��ѡ������...',
maxValue : new Date(),
plugins: 'monthPickerPlugin',
listeners : {
scope : this,
'select' : function(dft){
}
}
});*/

//----------------- ��ѯ��ť-----------------//
/* var buttQuery = new Ext.Button({
text:"&nbsp;��&nbsp;&nbsp;ѯ&nbsp;",
handler:function(){ Query();}

});*/
var periodDate = new Ext.form.DisplayField({
		fieldLabel: '����ڼ�',
		// inputType:'text',
		style: 'padding-top:3px;'
	});
Ext.Ajax.request({
	url: '../csp/herp.acct.finalbillexe.csp?action=GetAcctCurYearMonth&acctbookid=' + acctbookid,
	failure: function (result, request) {
		//Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK});
	},
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		var year = jsonData.info;

		periodDate.setValue(year.replace("^", "-"));
	}
});

//------------��ĩ����--��ť---------//
var settleAccountsBtn = new Ext.Button({
		text: "&nbsp;��ĩ����&nbsp;",
		iconCls: 'finalbill',
		handler: function () {
			var period = periodDate.getValue();
			//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
			var year = period.split("-")[0];
			var month = period.split("-")[1];
			//alert(period);
			if (period == "-") {
				Ext.Msg.show({
					title: 'ע��',
					msg: ' ���ȵ�¼���� ',
					icon: Ext.MessageBox.INFO,
					buttons: Ext.Msg.OK
				});
			} else {
				//=====================�ȴ�����==========================//
				var myMask = new Ext.LoadMask(Ext.getBody(), {
						msg: '���˴����У����Ժ�',
						removeMask: true //��ɺ��Ƴ�
					});

				Ext.MessageBox.confirm('��ʾ', '�Ƿ�Ҫ������ĩ����? ', function (btn) {
					if (btn == "yes") {

						myMask.show();
						Ext.Ajax.request({
							url: '../csp/herp.acct.finalbillexe.csp?action=settleAccounts&period=' + period + "&btn=&userid=" + userid,
							failure: function (result, request) {
								myMask.hide();
								Ext.Msg.show({
									title: '����',
									msg: '������������! ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
							},
							success: function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									myMask.hide();

									Ext.Msg.show({
										title: 'ע��',
										msg: '���˳ɹ��� ',
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
										var message = year + "��" + month + "���Ѿ����ˣ������ٴν��ˣ�  ";
										myMask.hide();
										Ext.Msg.show({
											title: '����',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									} else if (jsonData.info == 'isNotAcct') {
										var message = "������δ����ƾ֤,���ܽ��ˣ� ";
										myMask.hide();
										Ext.Msg.show({
											title: '����',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									} else if (jsonData.info == 'haveNextYearAcct') {
										myMask.hide();
										Ext.MessageBox.confirm('��ʾ', '�������Ѿ����ڣ��Ƿ񸲸��������ݣ� ', function (btn) {
											if (btn == "yes") {
												myMask.show();
												Ext.Ajax.request({
													url: '../csp/herp.acct.finalbillexe.csp?action=isHasNextYearAcct&period=' + period + "&userid=" + userid + "&btn=" + btn,
													failure: function (result, request) {
														myMask.hide();
														Ext.Msg.show({
															title: '����',
															msg: '������������! ',
															buttons: Ext.Msg.OK
														});
													},
													success: function (result, request) {
														var jsonData = Ext.util.JSON.decode(result.responseText);
														if (jsonData.success == 'true') {
															myMask.hide();
															Ext.Msg.show({
																title: 'ע��',
																msg: '���������ɳɹ���',
																icon: Ext.MessageBox.INFO,
																buttons: Ext.Msg.OK
															});
														} else {
															var message = "����������ʧ�ܣ� "
																myMask.hide();
															Ext.Msg.show({
																title: '����',
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
											title: '����',
											msg: '���񱨱�����ʧ�ܣ���ȷ������ʽ��׼ȷ�ԣ�  ',
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

													message = message + infoYear + "��" + infoMonth + "��δ����,"
												}
												message = message + "���ڲ��ܽ���! "

												myMask.hide();
											Ext.Msg.show({
												title: '����',
												msg: message,
												buttons: Ext.Msg.OK,
												icon: Ext.MessageBox.ERROR
											});
										} else if (isNotZero != -1) {
											var infoArry = info.split("^");
											var message = " ��֧��Ŀ:"
												for (var i = 1; i < infoArry.length; i++) {

													message = message + infoArry[i] + ","
												}
												message = message + "��Ϊ0,�Ƿ������ "
												myMask.hide();
											Ext.MessageBox.confirm('��ʾ', message, function (btn) {

												if (btn == "yes") {
													myMask.show();
													Ext.Ajax.request({
														url: '../csp/herp.acct.finalbillexe.csp?action=buildBill&period=' + period + "&userid=" + userid + "&acctbookid=" + acctbookid,
														waitMsg: '������...',
														failure: function (result, request) {
															myMask.hide();
															Ext.Msg.show({
																title: '����',
																msg: '������������! ',
																buttons: Ext.Msg.OK
															});
														},
														success: function (result, request) {
															var jsonData = Ext.util.JSON.decode(result.responseText);

															if (jsonData.success == 'true') {
																myMask.hide();
																Ext.Msg.show({
																	title: 'ע��',
																	msg: '���˳ɹ��� ',
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
																	Ext.MessageBox.confirm('��ʾ', '�������Ѿ�����,�Ƿ񸲸��������ݣ� ', function (btn) {
																		if (btn = "yes") {
																			myMask.show();
																			Ext.Ajax.request({
																				url: '../csp/herp.acct.finalbillexe.csp?action=isHasNextYearAcct&period=' + period + '&btn=' + btn + "&userid=" + userid,
																				failure: function (result, request) {
																					myMask.hide();
																					Ext.Msg.show({
																						title: '����',
																						msg: '������������! ',
																						buttons: Ext.Msg.OK
																					});
																				},
																				success: function (result, request) {
																					var jsonData = Ext.util.JSON.decode(result.responseText);

																					if (jsonData.success == 'true') {
																						myMask.hide();
																						Ext.Msg.show({
																							title: 'ע��',
																							msg: '���������ɳɹ��� ',
																							icon: Ext.MessageBox.INFO,
																							buttons: Ext.Msg.OK,
																							fn: function (btn, text) {
																								if (btn == 'ok') {
																									document.execCommand('Refresh');

																								}
																							}
																						});
																					} else {
																						var message = "����������ʧ�ܣ� "
																							myMask.hide();
																						Ext.Msg.show({
																							title: '����',
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
																		title: '����',
																		msg: '����ʧ��  ',
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
												title: '����',
												msg: '����ʧ��  ',
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

//--------------- ������--��ť---------//
var counterSettlingAccountsBtn = new Ext.Button({
		text: "&nbsp;������&nbsp;",
		iconCls: 'return_finalbill',
		handler: function () {
			var period = periodDate.getValue();
			//var period = Ext.util.Format.date(periodDate.getValue(),'Y-m');
			var year = period.split("-")[0];
			var month = period.split("-")[1];

			if (period == "-") {
				Ext.Msg.show({
					title: 'ע��',
					msg: '���ȵ�¼���ף� ',
					icon: Ext.MessageBox.INFO,
					buttons: Ext.Msg.OK
				});
			} else {
				//=====================�ȴ�����==========================//
				var myMask = new Ext.LoadMask(Ext.getBody(), {
						msg: '�����˴����У����Ժ� ',
						removeMask: true //��ɺ��Ƴ�
					});

				Ext.MessageBox.confirm('��ʾ', '�����ܽ������ʣ��Ƿ����  ', function (btn) {
					if (btn == "yes") {
						myMask.show();
						//��ȷ�Ͻ��н�תʱ
						Ext.Ajax.request({
							url: '../csp/herp.acct.finalbillexe.csp?action=counterSettlingAccounts&period=' + period + "&userid=" + userid,
							waitMsg: '��������...',
							failure: function (result, request) {
								myMask.hide();
								Ext.Msg.show({
									title: '����',
									msg: '������������!  ',
									buttons: Ext.Msg.OK
								});
							},
							success: function (result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);

								if (jsonData.success == 'true') {

									Ext.Msg.show({
										title: 'ע��',
										msg: '��������ϣ� ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK,
										fn: function (btn, text) {
											if (btn == 'ok') {
												document.execCommand('Refresh');

											}
										}
									});
									// Ext.MessageBox.confirm('��ʾ', '��������ϣ� ', function(btn){
									// document.execCommand('Refresh');
									// });
								} else if (jsonData.info == 'ishasVouch') {

									Ext.Msg.show({
										title: 'ע��',
										msg: year + '��' + month + '���м��˵�ƾ֤�����ȷ����ˣ�Ȼ���ٷ����ˣ� ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
								} else if (jsonData.info == 'noFan') {

									Ext.Msg.show({
										title: 'ע��',
										msg: ' ��ǰ���������׿�ʼ������ͬ�����ܽ��з����ˣ�  ',
										icon: Ext.MessageBox.INFO,
										buttons: Ext.Msg.OK
									});
								} else {

									var message = "������ʧ�ܣ�û�б������˲���  ";
									Ext.Msg.show({
										title: '����',
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
