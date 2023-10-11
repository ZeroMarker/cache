var userID = session['LOGON.USERID'];
var TabUrl = '../csp/herp.acct.AcctTrialBalanceexe.csp';
///����ƽ��


function trial() {
	//����ϼ�
	var TotalDebtField = new Ext.form.TextField({
			id: 'TotalDebtField',
			fieldLabel: '����跽���',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalCreditField = new Ext.form.TextField({
			id: 'TotalCreditField',
			fieldLabel: '����������',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var DiffField = new Ext.form.TextField({
			id: 'DiffField',
			fieldLabel: '������',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	//�ۼƺϼ�
	var TotalBeginDebtField = new Ext.form.TextField({
			id: 'TotalBeginDebtField',
			fieldLabel: '�ۼƽ跽���',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalBeginCreditField = new Ext.form.TextField({
			id: 'TotalBeginCreditField',
			fieldLabel: '�ۼƴ������',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var BeginDiffField = new Ext.form.TextField({
			id: 'BeginDiffField',
			fieldLabel: '�ۼƲ��',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	//�ڳ��ϼ�

	var TotalEndDebtField = new Ext.form.TextField({
			id: 'TotalEndDebtField',
			fieldLabel: '�ڳ��跽���',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var TotalEndCreditField = new Ext.form.TextField({
			id: 'TotalEndCreditField',
			fieldLabel: '�ڳ��������',
			width: 150,
			style: 'text-align:right;',
			readOnly: true
		});
	var EndDiffField = new Ext.form.TextField({
			id: 'EndDiffField',
			fieldLabel: '�ڳ����',
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
							text: "---------------------����ϼ�--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalDebtField,
						TotalCreditField,
						DiffField, {
							xtype: 'tbtext',
							text: "---------------------�ۼƺϼ�--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalBeginDebtField,
						TotalBeginCreditField,
						BeginDiffField, {
							xtype: 'tbtext',
							text: "---------------------�ڳ��ϼ�--------------------",
							style: 'padding-left:30px;line-height:20px;font-size:12px;',
							width: 300
						},
						TotalEndDebtField,
						TotalEndCreditField,
						EndDiffField

					]
				});

			var resultwin = new Ext.Window({
					title: '����ƽ����ʾ',
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
							text: 'ȷ��',
							handler: function () {
								resultwin.close();
								if (jsonData.success == 'true') {

									if (strvalue[0] == 1) {
										document.getElementById("balanceField").style.color = "black";
										balanceField.setValue("ƽ��");
										trialButton.disable();
										Ext.Msg.show({
											title: 'ע��',
											msg: 'ƽ�⣡ ',
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.INFO
										});

									} else {
										balanceField.setValue('��ƽ��');
										document.getElementById("balanceField").style.color = "red" //��ƽ����
										acctstartButton.disable();
										Ext.Msg.show({
											title: 'ע��',
											msg: '��ƽ�⣡ ',
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
										title: '����',
										msg: jsonData.info,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
									return;
								}
							}
						}, {
							text: 'ȡ��',
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
				title: '����',
				msg: '������������! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
		},
		scope: this
	});

}

///��������

function acctstart() {
	// ȡ�Ƿ�ƽ���־
	var balanceFlag = balanceField.getValue();
	
	if (!balanceFlag) {
		Ext.Msg.show({
			title: '����',
			msg: '���Ƚ�������ƽ��! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.WARNING
		});
		return;
	} else {
		//��ƽ��ʱ���������װ�ť�����ã�����ֻҪ����ƽ���־��Ϊ�վ���ƽ��
		Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ����������? ', handler);
		function handler(id) {
			if (id == 'yes') {
				// ��ӽ�����
				var progressBar = Ext.Msg.show({
						title: "��������",
						msg: "'����������... ",
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
								title: 'ע��',
								msg: '����������ɣ� ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});

						} else {
							if (jsonData.info == -1) {
								Ext.Msg.show({
									title: '����',
									msg: '������¼���뷢��������������ʧ�ܡ� ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
								return;
							} else if(jsonData.info == -2){
								Ext.Msg.show({
									title: '����',
									msg: '���ױ���³�����������ʧ�ܡ� ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});
								return;
							}else{
								Ext.Msg.show({
									title: '����',
									msg: jsonData.info + '</br >δ��ɳ�ʼ���������������ף� ',
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
							title: '����',
							msg: '������������! ',
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
