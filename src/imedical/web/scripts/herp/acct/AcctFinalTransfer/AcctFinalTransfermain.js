
/// Creator: yangyuying
/// CreatDate:  2016-8-2
/// Description:��ĩ����

//ȡ��ǰ�û�ID
var UserId = session['LOGON.USERID'];
var bookID = IsExistAcctBook();
var projUrl = "herp.acct.AcctFinalTransferexe.csp"

	/////////////////////////////��ǰ����ڼ�/////////////////////////
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
		summaryField.setValue(year + '��' + month + '�½�ת�������');
	},
	failure: function (result, request) {
		return;
	}
});

var queryPanelmain = new Ext.FormPanel({
	    title:'��ĩ����',
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
						value: '��ǰ����ڼ䣺',
						style: 'line-height: 15px;',
						width: 100
					},
					CurYearMonth
				]
			}
		]
	});

//////////////////���ʱ��水ť//////////////////////////
var rateSaveButton = new Ext.Toolbar.Button({
		text: '���ʱ���',
		tooltip: '�������',
		iconCls: 'save',
		handler: function () {
			var rowObj = AcctCurRateGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len > 0) {
				Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ�޸ĵ�ǰ������ ', callback);
				function callback(id) {
					if (id == 'yes') {
						//���ñ��溯��
						AcctCurRateGrid.save();
					}
				}
			} else {
				Ext.Msg.show({
					title: '��ʾ',
					msg: 'û���޸ĵĻ���! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.WARNING
				});
			}
		}
	});

//////////////////����ά�����///////////////////////////
var AcctCurRateGrid = new dhc.herp.Grid({
		title: '����ά��',
		iconCls:'maintain',
		width: 500,
		height:100,
		region: 'west',
		url: projUrl,
		//atLoad : true, // �Ƿ��Զ�ˢ��
		tbar: [rateSaveButton],
		fields: [{
				id: 'rowid',
				header: '���ʱ�ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'AcctYearMonth',
				header: '<div style="text-align:center">����</div>',
				width: 100,
				allowBlank: true,
				editable: false,
				align: 'center',
				dataIndex: 'AcctYearMonth'
			}, {
				id: 'CurrName',
				header: '<div style="text-align:center">����</div>',
				width: 120,
				allowBlank: true,
				dataIndex: 'CurrName',
				align: 'center',
				editable: false
			}, {
				id: 'EndRate',
				header: '<div style="text-align:center">��ǰ����</div>',
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

AcctCurRateGrid.btnAddHide() //�������Ӱ�ť
AcctCurRateGrid.btnSaveHide() //���ر��水ť
AcctCurRateGrid.btnDeleteHide() //����ɾ����ť
AcctCurRateGrid.btnResetHide() //�������ð�ť
AcctCurRateGrid.btnPrintHide() //���ش�ӡ��ť
//year=2017;month="04";
/* function IfRepVouch(){
	//alert(month)
	oplogstr = year + "��" + month + "����ĩ����";
	Ext.Ajax.request({	
		url: projUrl + '?action=IfRepVouch&UserID=' + UserId + '&oplogstr=' + encodeURI(oplogstr),
		method: 'GET',
		success: function (result, request) {
			var respText = Ext.util.JSON.decode(result.responseText);
			str = respText.info;
			if (str == 1) {
				Ext.Msg.show({
					title: '��ʾ',
					msg: year + '��' + month + '����ĩ����ƾ֤�Ѵ��ڣ� ',
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
//////////////////////////////��ĩ���㰴ť/////////////////////////////
var findButton = new Ext.Toolbar.Button({
		text: '��ĩ����',
		tooltip: '��ĩ����',
		iconCls: 'find', //����ť��ͼ��
		width: 100,
		handler: function () {
			var AcctSubj = AcctSubjCombo.getValue();
			//alert(AcctSubj)
			var mode = modeCombo.getValue();
			var summary = summaryField.getRawValue();
			if (AcctSubj == "") {
				Ext.Msg.show({
					title: '��ʾ',
					msg: '��ѡ���������Ŀ�� ',
					icon: Ext.Msg.INFO,
					buttons: Ext.MessageBox.OK
				});
			} else {
				oplogstr = year + "��" + month + "����ĩ����";
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
											title: '��ʾ',
											msg: '������δ����ƾ֤����ȫ�����˺��ٵ��㣡 ',
											icon: Ext.Msg.INFO,
											buttons: Ext.MessageBox.OK
										});
										return;
									} else {
										Ext.Msg.confirm('��ʾ', '��ȷ��Ҫ��' + year + '��' + month + '�½�����ĩ������ ', callback);
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
																title: '��ʾ',
																msg: '����û�пɵ������ݣ� ',
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

///////////////////////////////��ĩ��������///////////////////////////////
var queryPanel = new Ext.FormPanel({
		// height : 100,
		title: '��ĩ��������',
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
						value: '��������Ŀ  ',
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
						value: '�������  ',
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
						value: 'ƾ֤���ࣺ',
						style: 'line-height:18px;',
						width: 70
					}, {
						xtype: 'displayfield',
						value: '�������',
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
						value: 'ƾ֤ժҪ  ',
						style: 'line-height:17px;',
						width: 72
					},
					summaryField
				]
			}
		]
	});

/////////////////////����ƾ֤��ť///////////////////////////////////
var VouchButton = new Ext.Button({
		text: '&nbsp;����ƾ֤',
		width: 80,
		tooltip: '����ƾ֤',
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
					title: '��ʾ',
					msg: '�����������棬����Ҫ���ɻ������ƾ֤�� ',
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
//////////////�����ѽ���,���㰴ť���ɲ���//////////
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

/////////////////////////////////����������/////////////////////////////////
var transferGrid = new dhc.herp.GridMain({
		title: '�������ƾ֤����',
		iconCls:'list',
		width: 600,
		height: 350,
		region: 'south',
		url: projUrl,
		atLoad: true, // �Ƿ��Զ�ˢ��
		tbar: [VouchButton],
		fields: [{
				header: '���ʱ�ID',
				dataIndex: 'rowid',
				hidden: true
			}, {
				id: 'VouchNo',
				header: '<div style="text-align:center">ƾ֤��</div>',
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
				header: '<div style="text-align:center">��Ŀ����</div>',
				width: 400,
				allowBlank: true,
				dataIndex: 'SubjName',
				//align: 'center',
				editable: false,
				renderer: function formatQtip(data,metadata){
					var title = "";
					var tip = data;
					metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
					if (data == "�ϼƣ�") {
						return '<div align="right">' + data + '</div>';
					} 
					return data;
				}
			}, {
				id: 'summary',
				header: '<div style="text-align:center">ժҪ</div>',
				width: 250,
				allowBlank: true,
				editable: false,
				dataIndex: 'summary'
			}, {
				id: 'Debit',
				header: '<div style="text-align:center">�跽���</div>',
				width: 150,
				align: 'right',
				allowBlank: true,
				dataIndex: 'Debit',
				type: 'numberField',
				editable: false
			}, {
				id: 'Credit',
				header: '<div style="text-align:center">�������</div>',
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