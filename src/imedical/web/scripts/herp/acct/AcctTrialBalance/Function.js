var userID = session['LOGON.USERID'];
var TabUrl = '../csp/herp.acct.AcctTrialBalanceexe.csp';
///试算平衡


function trial() {
	//年初合计
	var TotalDebtField = new Ext.form.TextField({
			id: 'TotalDebtField',
			fieldLabel: '年初借方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalCreditField = new Ext.form.TextField({
			id: 'TotalCreditField',
			fieldLabel: '年初贷方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var DiffField = new Ext.form.TextField({
			id: 'DiffField',
			fieldLabel: '年初差额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	//累计合计
	var TotalBeginDebtField = new Ext.form.TextField({
			id: 'TotalBeginDebtField',
			fieldLabel: '累计借方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalBeginCreditField = new Ext.form.TextField({
			id: 'TotalBeginCreditField',
			fieldLabel: '累计贷方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var BeginDiffField = new Ext.form.TextField({
			id: 'BeginDiffField',
			fieldLabel: '累计差额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	//期初合计

	var TotalEndDebtField = new Ext.form.TextField({
			id: 'TotalEndDebtField',
			fieldLabel: '期初借方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalEndCreditField = new Ext.form.TextField({
			id: 'TotalEndCreditField',
			fieldLabel: '期初贷方金额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var EndDiffField = new Ext.form.TextField({
			id: 'EndDiffField',
			fieldLabel: '期初差额',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});

	Ext.Ajax.request({
		url: TabUrl + '?action=TrialBalance' + '&bookID=' + bookID,
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var resultstr = jsonData.info;
			var strvalue = resultstr.split('^');

			TotalDebtField.setValue(Ext.util.Format.number(strvalue[1], '0,000.00'));
			TotalCreditField.setValue(Ext.util.Format.number(strvalue[2], '0,000.00'));
			DiffField.setValue(Ext.util.Format.number(strvalue[1] - strvalue[2], '0,000.00'));

			TotalBeginDebtField.setValue(Ext.util.Format.number(strvalue[3], '0,000.00'));
			TotalBeginCreditField.setValue(Ext.util.Format.number(strvalue[4], '0,000.00'));
			BeginDiffField.setValue(Ext.util.Format.number(strvalue[3] - strvalue[4], '0,000.00'));

			TotalEndDebtField.setValue(Ext.util.Format.number(strvalue[5], '0,000.00'));
			TotalEndCreditField.setValue(Ext.util.Format.number(strvalue[6], '0,000.00'));
			EndDiffField.setValue(Ext.util.Format.number(strvalue[5] - strvalue[6], '0,000.00'));
			// alert(Ext.util.Format.number(strvalue[3],'0,000.00'));

			var resultpanel = new Ext.form.FormPanel({
					baseCls: 'x-plain',
					// region:'north',
					labelWidth: 130,
					labelAlign: 'right',
					// lineHeight:25,
					items: [{
							xtype: 'tbtext',
							text: "---------------------年初合计--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalDebtField,
						TotalCreditField,
						DiffField, {
							xtype: 'tbtext',
							text: "---------------------累计合计--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalBeginDebtField,
						TotalBeginCreditField,
						BeginDiffField, {
							xtype: 'tbtext',
							text: "---------------------期初合计--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalEndDebtField,
						TotalEndCreditField,
						EndDiffField

					]
				});

			var resultwin = new Ext.Window({
					title: '试算平衡显示',
					width: 400,
					height: 430,
					minWidth: 340,
					minHeight: 240,
					layout: 'fit',
					plain: true,
					modal: true,
					bodyStyle: 'padding:10px;',
					buttonAlign: 'center',
					items: [resultpanel],
					buttons: [{
							text: '确定',
							handler: function () {
								resultwin.close();
								if (jsonData.success == 'true') {

									if (strvalue[0] == 1) {
										document.getElementById("balanceField").style.color = "black";
										balanceField.setValue("平衡");
										trialButton.disable();
										Ext.Msg.show({
											title: '注意',
											msg: '平衡！ ',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.INFO
										});

									} else {
										balanceField.setValue('不平衡');
										document.getElementById("balanceField").style.color = "red" //不平衡变红
										acctstartButton.disable();
										Ext.Msg.show({
											title: '注意',
											msg: '不平衡！ ',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									}

									/* itemGrid.load({
									params:{
									start:0,
									limit:25
									}
									}); */
								} else {
									Ext.Msg.show({
										title: '错误',
										msg: jsonData.info,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
									return;
								}
							}
						}, {
							text: '取消',
							handler: function () {
								resultwin.close();

							}
						}
					]

				});
			resultwin.show();

		},
		failure: function (result, request) {
			Ext.Msg.show({
				title: '错误',
				msg: '请检查网络连接! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		scope: this
	});

}

///启用账套

function acctstart() {
	// 取是否平衡标志
	var balanceFlag = balanceField.getValue();
	
	if (!balanceFlag) {
		Ext.Msg.show({
			title: '警告',
			msg: '请先进行试算平衡! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else {
		//不平衡时，启用账套按钮不可用，所以只要账套平衡标志不为空就是平衡
		Ext.MessageBox.confirm('提示', '确实要启用账套吗? ', handler);
		function handler(id) {
			if (id == 'yes') {
				// 添加进度条
				var progressBar = Ext.Msg.show({
						title: "启用账套",
						msg: "'启用账套中... ",
						width: 300,
						wait: true,
						closable: true
					});

				Ext.Ajax.request({
					url: TabUrl + '?action=Acctstart' + '&bookID=' + bookID + '&UserID=' + userID,
					// timeout: 10000, //10s
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						// alert(jsonData.info)
						if (jsonData.success == 'true') {

							acctstartButton.disable();
							Ext.Msg.show({
								title: '注意',
								msg: '启用账套完成！ ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});

						} else {
							if (jsonData.info == -1) {
								Ext.Msg.show({
									title: '错误',
									msg: '操作记录插入发生错误！启用账套失败。 ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
								return;
							} else if(jsonData.info == -2){
								Ext.Msg.show({
									title: '错误',
									msg: '账套表更新出错！启用账套失败。 ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
								return;
							}else{
								Ext.Msg.show({
									title: '错误',
									msg: jsonData.info + '</br >未完成初始化，不能启用账套！ ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
								return;
							}

						}

						itemGrid.load({
							params: {
								start: 0,
								limit: 25

							}
						});
					},
					failure: function (result, request) {
						Ext.Msg.show({
							title: '错误',
							msg: '请检查网络连接! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
					},
					scope: this
				});
			}

		}
	}
}
