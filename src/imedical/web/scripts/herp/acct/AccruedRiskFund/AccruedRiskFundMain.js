var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.accruedriskfundexe.csp"

	//��ʾ��Ƶ�ǰ
	var periodDate = new Ext.form.DisplayField({
		id: 'periodDate',
		style: 'line-height: 20px;',
		columnWidth: 0.07
	});

Ext.Ajax.request({
	url: projUrl + '?action=GetYearMonth&bookID=' + bookID,
	method: 'POST',
	success: function (result, request) {
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			YearMonth = jsonData.info;
			periodDate.setValue(YearMonth);
		}
	}
});

//------------����ҽ�Ʒ��ջ���--��ť---------//
var accruedriskfund = new Ext.Button({
		text: "&nbsp;����ҽ�Ʒ��ջ���&nbsp;",
		width: 150,
		iconCls: 'dataabstract',
		handler: function () {
			var period = periodDate.getValue();
			Ext.Ajax.request({
				url: projUrl + '?action=IFHaveData&period=' + period + '&bookID=' + bookID,
				method: 'GET',
				failure: function (result, request) {
					Ext.Msg.show({
						title: '����',
						msg: '������������! ',
						buttons: Ext.Msg.OK
					});
				},
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var infomsg = jsonData.info;
						VouchButton.enable();
						//alert(infomsg);
						riskfundGrid.load({
							params: {
								period: period,
								bookID: bookID
							}
						});
						if (infomsg == "RFNo") {
							VouchButton.disable();
						}

					} else {
						var infomsg = jsonData.info;
						if (infomsg == "NoData") {
							Ext.Msg.show({
								title: '��ʾ',
								msg: 'û�пɼ�������� ',
								icon: Ext.MessageBox.INFO,
								buttons: Ext.Msg.OK
							});
							accruedriskfund.disable();
							VouchButton.disable();
						} else {
							Ext.Msg.show({
								title: '����',
								msg: '���ݳ���',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});

						}
					}
				}

			})
		}

	});

var queryPanel = new Ext.FormPanel({
	   title:'����ҽ�Ʒ��ջ���',
	   iconCls:'dataabstract',
		height: 70,
		region: 'north',
		frame: true,
		//iconCls: 'add',
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				items: [{
						xtype: 'displayfield',
						value: '��ǰ����ڼ䣺',
						style: 'line-height: 20px;',
						width: 100
					},
					periodDate, {
						xtype: 'displayfield',
						value: ' &nbsp;&nbsp;&nbsp;&nbsp; '
					},
					accruedriskfund
				]
			}
		]
	});

//--------------- ����ƾ֤--��ť---------//
var VouchButton = new Ext.Button({
		text: '&nbsp;����ƾ֤',
		width: 80,
		tooltip: '����ƾ֤',
		iconCls: 'createvouch',
		handler: function () {
			var period = periodDate.getValue();
			//var count=riskfundGrid.getStore().getTotalCount();  // ��ü�¼����
			//if (count==0){
			//Ext.Msg.show({title:'��ʾ',msg:'�޼�������',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			//return;
			//}
			//var vouchno=riskfundGrid.getStore().getAt(0).get("RiskFundNo");
			//alert(vouchno);
			//if(vouchno!="")	{
			//Ext.Msg.show({title:'��ʾ',msg:'��ƾ֤������',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			//return;
			//}
			Ext.MessageBox.confirm('��ʾ', '�Ƿ�Ҫ����ƾ֤? ', function (btn) {

				if (btn == "yes") {
					//��ȷ�Ͻ��н�תʱ
					Ext.Ajax.request({
						url: projUrl + '?action=CreateVouch&period=' + period + '&bookID=' + bookID + '&userid=' + userid,
						waitMsg: 'ƾ֤������...',
						failure: function (result, request) {

							Ext.Msg.show({
								title: '����',
								msg: '������������! ',
								buttons: Ext.Msg.OK
							});

						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);

							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: 'ע��',
									msg: '����ƾ֤�ɹ� ',
									icon: Ext.MessageBox.INFO,
									buttons: Ext.Msg.OK
								});
								VouchButton.disable();
								riskfundGrid.load({
									params: {
										period: period,
										bookID: bookID
									}
								});
							} else {
								Ext.Msg.show({
									title: '����',
									msg: '���ݳ���',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.ERROR
								});

							}
						},
						scope: this
					});
				}
			});			
		}
	});

////////////ҽ�Ʒ��ջ������ƾ֤Ԥ�鿴///////

var riskfundGrid = new dhc.herp.GridMain({
		//width: 600,
		//height:380,
		region: 'center',
		url: projUrl,
		atLoad: true, // �Ƿ��Զ�ˢ��
		tbar: [VouchButton],
		fields: [{
				header: '<div style="text-align:center">ƾ֤��</div>',
				width: 130,
				dataIndex: 'RiskFundNo',
				sortable: true,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				align: 'center'
			}, {
				header: '<div style="text-align:center">��Ŀ����</div>',
				width: 120,
				dataIndex: 'AcctSubjCode',
				sortable: true,
				editable: false,
				align: 'left'
			}, {
				header: '<div style="text-align:center">��Ŀ����</div>',
				dataIndex: 'AcctSubjName',
				width: 180,
				editable: false,
				align: 'left'
			}, {
				header: '<div style="text-align:center">ժҪ</div>',
				dataIndex: 'Summary',
				editable: false,
				width: 240
			}, {
				header: '<div style="text-align:center">�跽���</div>',
				dataIndex: 'AmtDebit',
				width: 200,
				align: 'right',
				editable: false,
				renderer: function (value) {
					return Ext.util.Format.number(value, '0,000.00');
				}
			}, {
				header: '<div style="text-align:center">�������</div>',
				dataIndex: 'AmtCredit',
				width: 200,
				align: 'right',
				editable: false,
				renderer: function (value) {
					return Ext.util.Format.number(value, '0,000.00');
				}
			}
		]
	});

//ƾ֤����
riskfundGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {

	if (columnIndex == '1') {
		var records = riskfundGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("RiskFundNo");
		if(!VouchNo) return;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + userid + '&acctstate=' + 11 + '&bookID=' + bookID + '&SearchFlag=' + '1' + '" /></iframe>'
				// frame : true
			});

		var win = new Ext.Window({
				title: 'ƾ֤�鿴',
				width: 1093,
				height: 620,
				resizable: false,
				closable: true,
				draggable: true,
				resizable: false,
				layout: 'fit',
				modal: false,
				plain: true, // ��ʾΪ��Ⱦwindow body�ı���Ϊ͸���ı���
				//bodyStyle : 'padding:5px;',
				items: [myPanel],
				buttonAlign: 'center',
				buttons: [{
						text: '�ر�',
						type: 'button',
						handler: function () {
							win.close();
						}
					}
				]
			});
		win.show();
	};
});
VouchButton.disable();
