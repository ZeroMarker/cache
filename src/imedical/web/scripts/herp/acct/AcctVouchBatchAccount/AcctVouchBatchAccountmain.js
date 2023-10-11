var UserId = session['LOGON.USERID'];
var AcctBookID = IsExistAcctBook();

var VouchBatchUrl = '../csp/herp.acct.acctvouchbatchaccountexe.csp';

//ʱ��ؼ�
var AcctYearMonthField = new Ext.form.DateField({
		id: 'AcctYearMonthField',
		name: 'AcctYearMonthField',
		fieldLabel: '����ڼ�',
		emptyMsg: "",
		format: 'Y-m',
		plugins: 'monthPickerPlugin', //�������¿ؼ��������������31��ʱ��û��31�յ��·ݲ��ܲ�ѯ
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

//ȡ��ǰ���׻���ڼ�
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


//��ѯ����
var CondQuery = new Ext.form.Checkbox({
		id: "CondQuery",
		fieldLabel:'��������',
		//width: 15,
		inputValue: 1,
		style: 'border:0;background:none;margin-top:0px;',
		checked: false,
		listeners: {
			'check': function () {
				FindButton.handler() //��������¼����ı�״̬ʱ����ѯ����
			}
		}
	});

//��ѯ��ť
var FindButton = new Ext.Toolbar.Button({
		text: '��ѯ',
		tooltip: '��ѯ',
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
				//������ڼ�Ϊ��ʱ�����store
				VouchBatchDs.removeAll();
				Ext.Msg.show({
					title: '����',
					msg: '���������ڼ�! ',
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

//���˰�ť
var AcctRecButton = new Ext.Toolbar.Button({
		text: '����',
		iconCls: 'account',
		width: 55,
		cls: 'x-btn-text-icon details',
		// disabled:true,
		handler: function () {
			var AcctRecButtonFlag = CondQuery.getValue();
			if (AcctRecButtonFlag != 1) {
				AcctRecButton.disabled = 0;
				Ext.Msg.show({
					title: '����',
					msg: '��ɸѡ����������ƾ֤! ',
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
						title: '����',
						msg: 'û�з��ϼ��˵�����! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
					return;
				} else if (VouchBatchGrid.getStore().getAt(0) != undefined) {
					Ext.MessageBox.confirm('��ʾ', 'ȷʵҪ���м��˲�����? ', function handler(id) {
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
										title: '����',
										msg: '������������! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								},
								success: function (result, request) {

									var jsonData = Ext.util.JSON.decode(result.responseText);
									// alert("123");
									if (jsonData.success == 'true') {
										// ��ӽ�����
										var progressBar = Ext.MessageBox.show({
												title: "����",
												msg: "���ڼ�����...",
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
																	Ext.MessageBox.updateProgress(t / CondCount, '���ڸ��µ�' + t + '����һ��' + CondCount + '����');
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
											title: 'ע��',
											msg: '�������! ',
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
											title: '����',
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
				title : '����',
				msg : 'û�з��ϼ���������ƾ֤!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.ERROR
				});
				} */
			}
		}

	});

//�����˰�ť
var anti_AcctRecButton = new Ext.Toolbar.Button({
		text: '������',
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
			Ext.MessageBox.confirm('��ʾ', '��ȷʵҪ��' + AcctYear + '��' + AcctMonth + '�µ�ƾ֤���з����˲�����? ', function handler(id) {
				if (id == 'yes') {
					Ext.Ajax.request({
						url: VouchBatchUrl + '?action=antiAcctRec' + '&AcctYear=' + AcctYear + '&AcctMonth=' + AcctMonth
						 + '&UserId=' + UserId + '&AcctBookID=' + AcctBookID,

						failure: function (result, request) {
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

								// timeout:5000,	//5s��ʱ
								/* // ��ӽ�����
								var progressBar = Ext.MessageBox.show({
										title: "������",
										msg: "���ڽ��з�������...",
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
															Ext.MessageBox.updateProgress(t / CondCount, '���ڸ��µ�' + t + '����һ��' + CondCount + '����');
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
										title: 'ע��',
										msg: '���������! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.INFO
									});
								}, 5000);

							} else {
								Ext.Msg.show({
									title: '����',
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

//����������¼���ݣ�
var CondCountField = new Ext.form.DisplayField({
		width: 70,
		style: 'padding-top:0px;text-align:left;color:red',
		triggerAction: 'all'
	});

//������������¼���ݣ�
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
				value: '����ڼ�',
				width: 65
			},AcctYearMonthField,{
				xtype: 'displayfield',
				text: '',
				width: 30
			},CondQuery,{
				xtype: 'tbtext',
				text: '��������',
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


// ������Դ
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

//��ҳ�Ǵ�����
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
			"����������¼���ݣ�", CondCountField, "������������¼���ݣ�", DisCondCountField]); */

var VouchBatchGrid = new Ext.grid.GridPanel({
		atLoad: true,
		store: VouchBatchDs,
		pageSize: 25,
		region: 'center',
		trackMouseOver: true, //�������������
		stripeRows: true, //���л�ɫ
		// autoHeight:true,
		viewConfig: { //�����ͼ����
			// forceFit : true,		//ǿ�Ƶ�������п������ñ��������ȣ���ֹ����ˮƽ������
			getRowClass: function (record) {
				if (parseInt(record.data.VouchState1)<21) {
					return "grid-discond-row-color";
				}
				if(parseInt(record.data.VouchState1)==21&&
				(record.data.TypeCode=="01"||record.data.TypeCode=="02")&&
				(record.data.IsCheck=="δ����")){
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
				header: '<div style="text-align:center">��</div>',
				dataIndex: 'AcctYear',
				width: 60,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">��</div>',
				dataIndex: 'AcctMonth',
				width: 50,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">ƾ֤����</div>',
				dataIndex: 'VouchDate',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">ƾ֤��</div>',
				dataIndex: 'VouchNo',
				width: 100,
				// sortable:true,	//������
				// align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				sortable: true
			}, {
				header: '<div style="text-align:center">��������</div>',
				dataIndex: 'VouchBillNum',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">�ܽ��</div>',
				dataIndex: 'TotalAmount',
				align: 'right',
				width: 150,
				sortable: true
			}, {
				header: '<div style="text-align:center">�Ƶ���</div>',
				dataIndex: 'Operator',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">����ǩ��</div>',
				dataIndex: 'IsCheck',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">�����</div>',
				dataIndex: 'Auditor',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">������</div>',
				dataIndex: 'Poster',
				width: 100,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">ƾ֤״̬</div>',
				dataIndex: 'VouchState',
				width: 80,
				align: 'center',
				sortable: true
			}, {
				id: 'VouchProgress',
				header: '<div style="text-align:center">ƾ֤�������</div>',
				dataIndex: 'VouchProgress',
				width: 120,
				align: 'center',
				renderer: function (value, cellmeta, record, rowIndex, columnIndex, store) {
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">' + value + '</span>';
				},
				sortable: true
			}, {
				header: '<div style="text-align:center">ƾ֤״̬����</div>',
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
				header: '<div style="text-align:center">ƾ֤����</div>',
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
			"����������¼���ݣ�", CondCountField, "������������¼���ݣ�", DisCondCountField],
/* 		listeners: {
			//���з��ð�ť
			'render': function () {
				buttons.render(VouchBatchGrid.tbar)
			}
		}, */
		bbar: new Ext.PagingToolbar({
			store: VouchBatchDs,
			pageSize: 25,
			atLoad: true,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}����',
			emptyMsg: "û������"
		})
	});

//ƾ֤����
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
	}
	if (columnIndex == '13') {

		var selectedRow = VouchBatchDs.data.items[rowIndex];
		var AcctVouchID = selectedRow.data['rowid'];
		VouchProgressFun(AcctVouchID);
	}

});

//��ѯ���ϼ��˺Ͳ����ϼ��˵���������
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

