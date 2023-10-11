addwinFun = function (acctbookid) {

	function cancelwin() {
		addwin.close();
	};

	var cField = new Ext.form.TextField({
			id: 'cField',
			fieldLabel: '����ڼ���������',
			allowBlank: false,
			width: 150,
			listWidth: 150,
			regex: /^\d{4}$/,
			emptyText: '��������Ч���...',
			anchor: '90%',
			selectOnFocus: 'true',
			listeners: {
				blur: function (field, e) {
					// if (e.getKey() == Ext.EventObject.ENTER) {
					if (cField.getValue() != "") {
						var reg = /^\d{4}$/;
						if (!reg.test(cField.getValue())) {
							Ext.Msg.show({
								title: '����',
								msg: '�������ݸ�ʽ����ȷ�����������룡 ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
							cField.setValue("");
						}
						// cField.focus();
						return;
					} else {

						Ext.Msg.show({
							title: '����',
							msg: '��ݲ���Ϊ��! ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.ERROR
						});
						return;
					}
					// }
				}
			}
		});

	function save() {
		var acctYear = cField.getValue();
		//var name=nField.getValue();

		if (acctYear == "") {
			Ext.Msg.show({
				title: '����',
				msg: '��ݲ���Ϊ��! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		};

		Ext.Ajax.request({
			url: tmpUrl + '?action=GetMaxMonthAndEndday&acctYear=' + acctYear + '&acctbookid=' + acctbookid,
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var maxMonth = jsonData.info.split("^")[0];
					var endDay = jsonData.info.split("^")[1];
					var curMonth= jsonData.info.split("^")[2];
					if (maxMonth == '12') {
						Ext.Msg.show({
							title: 'ע��',
							msg: '������ȵĻ���ڼ�������! ',
							icon: Ext.MessageBox.INFO,
							buttons: Ext.Msg.OK
						});
						return;
					}
					if (!maxMonth)
						maxMonth = 0;
					if (!endDay) {
						Ext.Msg.show({
							title: 'ע��',
							msg: '��ǰ����û��ά��������! ',
							icon: Ext.MessageBox.INFO,
							buttons: Ext.Msg.OK
						});
						return;
					}

					var ajaxObj = {
						url: tmpUrl + '?action=addYear&acctYear=' + acctYear + '&acctbookid=' + acctbookid + '&maxMonth=' + maxMonth + '&endDay=' +endDay,
						waitMsg: '������...',
						failure: function (result, request) {
							add = function () {
								cField.focus();
							};
							Ext.Msg.show({
								title: '����',
								msg: '������������! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: add
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: 'ע��',
									msg: '��ӳɹ�! ',
									icon: Ext.MessageBox.INFO,
									buttons: Ext.Msg.OK
									//fn : add
								});
								addwin.close();
								itemGrid.load({
									params: {
										start: 0,
										limit: 25
									}
								});
								// addwin.close();
							} else {
								var message = "";
								if (jsonData.info == 'RecordExist') {
									Ext.Msg.show({
										title: '����',
										msg: '���������ӣ�������������ȣ� ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								} else if (jsonData.info == 'RecordEndday') {
									Ext.Msg.show({
										title: '����',
										msg: '������׵Ľ����ղ���Ϊ��! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								} else {
									Ext.Msg.show({
										title: '����',
										msg: message,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								}
							}
						},
						scope: this

					}
					// ȡ��ǰ�µ��������
					var maxDays = new Date(acctYear + "/" + curMonth + "/01").format('t');
					if (maxDays == endDay) {
						Ext.Msg.show({
							title: "��ʾ",
							msg: "�������ǵ�ǰ�µ����һ�죬�Ƿ񽫴˺�<br/>ÿ���µ����һ����Ϊ�����գ� ",
							buttons: Ext.Msg.YESNOCANCEL,
							icon: Ext.Msg.INFO,
							fn: callback
						});
						function callback(id) {
							if (id == 'yes') {
								// alert("y");
								ajaxObj.url += '&ifEndDday=Y';
								Ext.Ajax.request(ajaxObj);
								
							} else if (id == "no") {
								// alert("n")
								// ��������31��ʱ��ֻ����ÿ�����һ����Ϊ������
								if (endDay == '31') {
									ajaxObj.url += '&ifEndDday=Y';
								} else {
									ajaxObj.url += '&ifEndDday=N';
								}
								Ext.Ajax.request(ajaxObj);
							} else
								return;
							addwin.close();
						}

					} else {
						Ext.Ajax.request(ajaxObj);
					}
				}

			}

		});
	}
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 120,
			labelAlign: 'right',
			labelSeparator: ' ',
			style: 'padding-top:20px;padding-left:15px;',
			items: [cField]
		});

	addwin = new Ext.Window({
			title: '��������',
			width: 320,
			height: 170,
			minWidth: 300,
			minHeight: 150,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: formPanel,
			buttons: [{
					xtype: 'button', //���水ť
					iconCls: 'save',
					text: '����',
					listeners: {
						click: {
							scope: this,
							fn: save
						}
					}
				}, {
					xtype: 'button', //ȡ����ť
					text: 'ȡ��',
					iconCls: 'cancel',
					listeners: {
						click: {
							scope: this,
							fn: cancelwin
						}
					}
				}
			]
		});

	// ������ʾ
	addwin.show();

}
