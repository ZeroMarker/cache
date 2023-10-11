var userid = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.accruedriskfundexe.csp"

	//显示会计当前
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

//------------计提医疗风险基金--按钮---------//
var accruedriskfund = new Ext.Button({
		text: "&nbsp;计提医疗风险基金&nbsp;",
		width: 150,
		iconCls: 'dataabstract',
		handler: function () {
			var period = periodDate.getValue();
			Ext.Ajax.request({
				url: projUrl + '?action=IFHaveData&period=' + period + '&bookID=' + bookID,
				method: 'GET',
				failure: function (result, request) {
					Ext.Msg.show({
						title: '错误',
						msg: '请检查网络连接! ',
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
								title: '提示',
								msg: '没有可计提的数据 ',
								icon: Ext.MessageBox.INFO,
								buttons: Ext.Msg.OK
							});
							accruedriskfund.disable();
							VouchButton.disable();
						} else {
							Ext.Msg.show({
								title: '错误',
								msg: '数据出错',
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
	   title:'计提医疗风险基金',
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
						value: '当前会计期间：',
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

//--------------- 生成凭证--按钮---------//
var VouchButton = new Ext.Button({
		text: '&nbsp;生成凭证',
		width: 80,
		tooltip: '生成凭证',
		iconCls: 'createvouch',
		handler: function () {
			var period = periodDate.getValue();
			//var count=riskfundGrid.getStore().getTotalCount();  // 获得记录总数
			//if (count==0){
			//Ext.Msg.show({title:'提示',msg:'无计提数据',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			//return;
			//}
			//var vouchno=riskfundGrid.getStore().getAt(0).get("RiskFundNo");
			//alert(vouchno);
			//if(vouchno!="")	{
			//Ext.Msg.show({title:'提示',msg:'此凭证已生成',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			//return;
			//}
			Ext.MessageBox.confirm('提示', '是否要生成凭证? ', function (btn) {

				if (btn == "yes") {
					//当确认进行结转时
					Ext.Ajax.request({
						url: projUrl + '?action=CreateVouch&period=' + period + '&bookID=' + bookID + '&userid=' + userid,
						waitMsg: '凭证生成中...',
						failure: function (result, request) {

							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接! ',
								buttons: Ext.Msg.OK
							});

						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);

							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '生成凭证成功 ',
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
									title: '错误',
									msg: '数据出错',
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

////////////医疗风险基金计提凭证预查看///////

var riskfundGrid = new dhc.herp.GridMain({
		//width: 600,
		//height:380,
		region: 'center',
		url: projUrl,
		atLoad: true, // 是否自动刷新
		tbar: [VouchButton],
		fields: [{
				header: '<div style="text-align:center">凭证号</div>',
				width: 130,
				dataIndex: 'RiskFundNo',
				sortable: true,
				editable: false,
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				align: 'center'
			}, {
				header: '<div style="text-align:center">科目编码</div>',
				width: 120,
				dataIndex: 'AcctSubjCode',
				sortable: true,
				editable: false,
				align: 'left'
			}, {
				header: '<div style="text-align:center">科目名称</div>',
				dataIndex: 'AcctSubjName',
				width: 180,
				editable: false,
				align: 'left'
			}, {
				header: '<div style="text-align:center">摘要</div>',
				dataIndex: 'Summary',
				editable: false,
				width: 240
			}, {
				header: '<div style="text-align:center">借方金额</div>',
				dataIndex: 'AmtDebit',
				width: 200,
				align: 'right',
				editable: false,
				renderer: function (value) {
					return Ext.util.Format.number(value, '0,000.00');
				}
			}, {
				header: '<div style="text-align:center">贷方金额</div>',
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

//凭证链接
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
	};
});
VouchButton.disable();
