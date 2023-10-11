
/// Creator: yangyuying
/// CreatDate:  2016-8-2
/// Description:期末调汇

//取当前用户ID
var UserId = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.AcctFinalTransferexe.csp"

	/////////////////////////////当前会计期间/////////////////////////
	var CurYearMonth = new Ext.form.DisplayField({
		id: 'CurYearMonth',
		style: 'text-align:left',
		columnWidth: 0.06
	});
Ext.Ajax.request({
	url: projUrl + '?action=GetYearMonth&bookID=' + bookID,
	method: 'GET',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		YearMonth = respText.info;
		CurYearMonth.setRawValue(YearMonth);
		strs = YearMonth.split('-');
		year = strs[0];
		month = strs[1];
		summaryField.setValue(year + '年' + month + '月结转汇兑损益');
	},
	failure: function (result, request) {
		return;
	}
});

var queryPanelmain = new Ext.FormPanel({
	    title:'期末调汇',
		iconCls:'find',
		height: 60,
		region: 'north',
		frame: true,
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true, //columnWidth : 1,
				items: [{
						xtype: 'displayfield',
						value: '当前会计期间：',
						style: 'line-height: 15px;',
						width: 100
					},
					CurYearMonth
				]
			}
		]
	});

//////////////////汇率保存按钮//////////////////////////
var rateSaveButton = new Ext.Toolbar.Button({
		text: '汇率保存',
		tooltip: '保存更改',
		iconCls: 'save',
		handler: function () {
			var rowObj = AcctCurRateGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len > 0) {
				Ext.Msg.confirm('提示', '您确定要修改当前汇率吗？ ', callback);
				function callback(id) {
					if (id == 'yes') {
						//调用保存函数
						AcctCurRateGrid.save();
					}
				}
			} else {
				Ext.Msg.show({
					title: '提示',
					msg: '没有修改的汇率! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
			}
		}
	});

//////////////////汇率维护表格///////////////////////////
var AcctCurRateGrid = new dhc.herp.Grid({
		title: '汇率维护',
		iconCls:'maintain',
		width: 500,
		height:100,
		region: 'west',
		url: projUrl,
		//atLoad : true, // 是否自动刷新
		tbar: [rateSaveButton],
		fields: [{
				id: 'rowid',
				header: '汇率表ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'AcctYearMonth',
				header: '<div style="text-align:center">年月</div>',
				width: 100,
				allowBlank: true,
				editable: false,
				align: 'center',
				dataIndex: 'AcctYearMonth'
			}, {
				id: 'CurrName',
				header: '<div style="text-align:center">币种</div>',
				width: 120,
				allowBlank: true,
				dataIndex: 'CurrName',
				align: 'center',
				editable: false
			}, {
				id: 'EndRate',
				header: '<div style="text-align:center">当前汇率</div>',
				width: 100,
				align: 'right',
				allowBlank: true,
				dataIndex: 'EndRate'
			}
		]
	});
AcctCurRateGrid.load({
	params: {
		start: 0,
		limit: 12,
		bookID: bookID
	}
});

AcctCurRateGrid.btnAddHide() //隐藏增加按钮
AcctCurRateGrid.btnSaveHide() //隐藏保存按钮
AcctCurRateGrid.btnDeleteHide() //隐藏删除按钮
AcctCurRateGrid.btnResetHide() //隐藏重置按钮
AcctCurRateGrid.btnPrintHide() //隐藏打印按钮
//year=2017;month="04";
/* function IfRepVouch(){
	//alert(month)
	oplogstr = year + "年" + month + "月期末调汇";
	Ext.Ajax.request({	
		url: projUrl + '?action=IfRepVouch&UserID=' + UserId + '&oplogstr=' + encodeURI(oplogstr),
		method: 'GET',
		success: function (result, request) {
			var respText = Ext.util.JSON.decode(result.responseText);
			str = respText.info;
			if (str == 1) {
				Ext.Msg.show({
					title: '提示',
					msg: year + '年' + month + '月期末调汇凭证已存在！ ',
					icon: Ext.Msg.INFO,
					buttons: Ext.MessageBox.OK
				});
				VouchButton.disable();
				findButton.disable();
				return;
			}
		}
	});
}
IfRepVouch(); */
//////////////////////////////期末调汇按钮/////////////////////////////
var findButton = new Ext.Toolbar.Button({
		text: '期末调汇',
		tooltip: '期末调汇',
		iconCls: 'find', //给按钮加图标
		width: 100,
		handler: function () {
			var AcctSubj = AcctSubjCombo.getValue();
			//alert(AcctSubj)
			var mode = modeCombo.getValue();
			var summary = summaryField.getRawValue();
			if (AcctSubj == "") {
				Ext.Msg.show({
					title: '提示',
					msg: '请选择汇兑损益科目！ ',
					icon: Ext.Msg.INFO,
					buttons: Ext.MessageBox.OK
				});
			} else {
				oplogstr = year + "年" + month + "月期末调汇";
				Ext.Ajax.request({	
					url: projUrl + '?action=IfRepVouch&UserID=' + UserId + '&oplogstr=' + encodeURI(oplogstr),
					method: 'GET',
					success: function (result, request) {
						var respText = Ext.util.JSON.decode(result.responseText);
						str = respText.info;
						if (str == 1) {
							transferGrid.load({
								params: {
									Summary: summary,
									AcctSubj: AcctSubj,
									mode: mode,
									bookID: bookID
								}
							});
							transferGrid.getColumnModel().setHidden(2, false);
							VouchButton.disable();
							findButton.disable();
							return;
						}else{
							Ext.Ajax.request({
								url: projUrl + '?action=GetVouchState&bookID=' + bookID,
								method: 'GET',
								success: function (result, request) {
									var respText = Ext.util.JSON.decode(result.responseText);
									str = respText.info;
									if (str != 0) {
										Ext.Msg.show({
											title: '提示',
											msg: '本月有未记账凭证，请全部记账后再调汇！ ',
											icon: Ext.Msg.INFO,
											buttons: Ext.MessageBox.OK
										});
										return;
									} else {
										Ext.Msg.confirm('提示', '您确定要对' + year + '年' + month + '月进行期末调汇吗？ ', callback);
										function callback(id) {
											if (id == 'yes') {
												Ext.Ajax.request({
													url: projUrl + '?action=GetNumF&bookID=' + bookID,
													method: 'POST',
													success: function (result, request) {
														var numText = Ext.util.JSON.decode(result.responseText);
														NumF = numText.info;
														if (NumF == 0) {
															Ext.Msg.show({
																title: '提示',
																msg: '本月没有可调汇数据！ ',
																icon: Ext.Msg.INFO,
																buttons: Ext.MessageBox.OK
															});
															return;
														} else {
															transferGrid.load({
																params: {
																	Summary: summary,
																	AcctSubj: AcctSubj,
																	mode: mode,
																	bookID: bookID
																}
															});
														}
													},
													failure: function (result, request) {
														return;
													}
												});
											}
										}
									}
								},
								failure: function (result, request) {
									return;
								}
							});
						}
					}
				});
		
			}
		}
	});

///////////////////////////////期末调汇设置///////////////////////////////
var queryPanel = new Ext.FormPanel({
		// height : 100,
		title: '期末调汇设置',
		iconCls:'maintain',
		region: 'center',
		//frame: true,
		tbar: [findButton],
		defaults: {
			bodyStyle: 'padding:5px;border:0;background:none;'
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				style:'paddingTop:5px',
				items: [{
						xtype: 'displayfield',
						value: '汇兑损益科目  ',
						style: 'line-height:15px;',
						width: 100
					},
					AcctSubjCombo
				]
			}, {
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				items: [{
						xtype: 'displayfield',
						value: '',
						width: 28
					}, {
						xtype: 'displayfield',
						value: '借贷方向  ',
						style: 'line-height:15px;',
						width: 72
					},
					modeCombo
				]
			}, {
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				items: [{
						xtype: 'displayfield',
						value: '',
						width: 28
					}, {
						xtype: 'displayfield',
						value: '凭证分类：',
						style: 'line-height:18px;',
						width: 70
					}, {
						xtype: 'displayfield',
						value: '汇兑损益',
						style: 'line-height:18px;',
						width: 70
					}
				]
			}, {
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				items: [{
						xtype: 'displayfield',
						value: '',
						width: 28
					}, {
						xtype: 'displayfield',
						value: '凭证摘要  ',
						style: 'line-height:17px;',
						width: 72
					},
					summaryField
				]
			}
		]
	});

/////////////////////生成凭证按钮///////////////////////////////////
var VouchButton = new Ext.Button({
		text: '&nbsp;生成凭证',
		width: 80,
		tooltip: '生成凭证',
		iconCls: 'createvouch',
		handler: function () {
			var len = transferGrid.getStore().getCount();
			var value=0;
			var DebitValue,CreditValue;
			for (var i = 0; i < len; i++) {
				DebitValue = transferGrid.getStore().getAt(0).data.Debit;
				CreditValue = transferGrid.getStore().getAt(0).data.Credit;
				value=value+DebitValue+CreditValue
			}
			if (value == 0 || value == undefined) {
				Ext.Msg.show({
					title: '提示',
					msg: '调汇金额无损益，不需要生成汇兑损益凭证！ ',
					icon: Ext.Msg.INFO,
					buttons: Ext.MessageBox.OK
				});
				return;
			} else {
				var AcctSubj = AcctSubjCombo.getValue();
				var mode = modeCombo.getValue();
				var summary = summaryField.getRawValue();
				scpzcr(AcctSubj,mode,summary);
			}
		}
	});
//////////////本月已结账,调汇按钮不可操作//////////
Ext.Ajax.request({
	url: projUrl + '?action=GetPeriodStatus&bookID=' + bookID,
	method: 'POST',
	success: function (result, request) {
		var respText = Ext.util.JSON.decode(result.responseText);
		PeriodStatus = respText.info;
		if (PeriodStatus == 1) {
			AcctSubjCombo.disable();
			findButton.disable();
		}
	},
	failure: function (result, request) {
		return;
	}
});

/////////////////////////////////汇兑损益概览/////////////////////////////////
var transferGrid = new dhc.herp.GridMain({
		title: '汇兑损益凭证概览',
		iconCls:'list',
		width: 600,
		height: 350,
		region: 'south',
		url: projUrl,
		atLoad: true, // 是否自动刷新
		tbar: [VouchButton],
		fields: [{
				header: '汇率表ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">凭证号</div>',
				width: 150,
				allowBlank: true,
				editable: false,
				hidden: true,
				dataIndex: 'VouchNo',
				renderer: function (v) {
					if (v) {
						return "<span style='color:blue;cursor:hand;'><u>" + v + "</u></span>";
					}
				}
			}, {
				id: 'SubjName',
				header: '<div style="text-align:center">科目名称</div>',
				width: 400,
				allowBlank: true,
				dataIndex: 'SubjName',
				//align: 'center',
				editable: false,
				renderer: function formatQtip(data,metadata){
					var title = "";
					var tip = data;
					metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
					if (data == "合计：") {
						return '<div align="right">' + data + '</div>';
					} 
					return data;
				}
			}, {
				id: 'summary',
				header: '<div style="text-align:center">摘要</div>',
				width: 250,
				allowBlank: true,
				editable: false,
				dataIndex: 'summary'
			}, {
				id: 'Debit',
				header: '<div style="text-align:center">借方金额</div>',
				width: 150,
				align: 'right',
				allowBlank: true,
				dataIndex: 'Debit',
				type: 'numberField',
				editable: false
			}, {
				id: 'Credit',
				header: '<div style="text-align:center">贷方金额</div>',
				width: 150,
				align: 'right',
				allowBlank: true,
				dataIndex: 'Credit',
				type: 'numberField',
				editable: false
			}
		]
	});
	
transferGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	if (columnIndex == '2') {
		//p_URL = 'acct.html?acctno=2';
		//document.getElementById("frameReport").src='acct.html';
		var records = transferGrid.getSelectionModel().getSelections();
		var VouchNo = records[0].get("VouchNo");
		// var VouchState = records[0].get("VouchState1");
		if(!VouchNo) return;
		var myPanel = new Ext.Panel({
				layout: 'fit',
				//scrolling="auto"
				html: '<iframe id="frameReport" style="margin-top:-3px" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno=' + VouchNo + '&user=' + UserId + '&acctstate=11&bookID=' + bookID + '&SearchFlag=1" /></iframe>'
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