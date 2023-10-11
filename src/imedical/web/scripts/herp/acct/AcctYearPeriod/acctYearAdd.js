addwinFun = function (acctbookid) {

	function cancelwin() {
		addwin.close();
	};

	var cField = new Ext.form.TextField({
			id: 'cField',
			fieldLabel: '会计期间批量生成',
			allowBlank: false,
			width: 150,
			listWidth: 150,
			regex: /^\d{4}$/,
			emptyText: '请输入有效年份...',
			anchor: '90%',
			selectOnFocus: 'true',
			listeners: {
				blur: function (field, e) {
					// if (e.getKey() == Ext.EventObject.ENTER) {
					if (cField.getValue() != "") {
						var reg = /^\d{4}$/;
						if (!reg.test(cField.getValue())) {
							Ext.Msg.show({
								title: '错误',
								msg: '输入的年份格式不正确，请重新输入！ ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR
							});
							cField.setValue("");
						}
						// cField.focus();
						return;
					} else {

						Ext.Msg.show({
							title: '错误',
							msg: '年份不能为空! ',
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
				title: '错误',
				msg: '年份不能为空! ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		};

		Ext.Ajax.request({
			url: tmpUrl + '?action=GetMaxMonthAndEndday&acctYear=' + acctYear + '&acctbookid=' + acctbookid,
			waitMsg: '保存中...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var maxMonth = jsonData.info.split("^")[0];
					var endDay = jsonData.info.split("^")[1];
					var curMonth= jsonData.info.split("^")[2];
					if (maxMonth == '12') {
						Ext.Msg.show({
							title: '注意',
							msg: '输入年度的会计期间已生成! ',
							icon: Ext.MessageBox.INFO,
							buttons: Ext.Msg.OK
						});
						return;
					}
					if (!maxMonth)
						maxMonth = 0;
					if (!endDay) {
						Ext.Msg.show({
							title: '注意',
							msg: '当前账套没有维护结账日! ',
							icon: Ext.MessageBox.INFO,
							buttons: Ext.Msg.OK
						});
						return;
					}

					var ajaxObj = {
						url: tmpUrl + '?action=addYear&acctYear=' + acctYear + '&acctbookid=' + acctbookid + '&maxMonth=' + maxMonth + '&endDay=' +endDay,
						waitMsg: '保存中...',
						failure: function (result, request) {
							add = function () {
								cField.focus();
							};
							Ext.Msg.show({
								title: '错误',
								msg: '请检查网络连接! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.ERROR,
								fn: add
							});
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title: '注意',
									msg: '添加成功! ',
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
										title: '错误',
										msg: '该年度已添加，请重新输入年度！ ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								} else if (jsonData.info == 'RecordEndday') {
									Ext.Msg.show({
										title: '错误',
										msg: '会计账套的结账日不能为空! ',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								} else {
									Ext.Msg.show({
										title: '错误',
										msg: message,
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								}
							}
						},
						scope: this

					}
					// 取当前月的最大天数
					var maxDays = new Date(acctYear + "/" + curMonth + "/01").format('t');
					if (maxDays == endDay) {
						Ext.Msg.show({
							title: "提示",
							msg: "结账日是当前月的最后一天，是否将此后<br/>每个月的最后一天设为结账日？ ",
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
								// 结账日是31日时，只能以每月最后一天作为结账日
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
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 120,
			labelAlign: 'right',
			labelSeparator: ' ',
			style: 'padding-top:20px;padding-left:15px;',
			items: [cField]
		});

	addwin = new Ext.Window({
			title: '批量生成',
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
					xtype: 'button', //保存按钮
					iconCls: 'save',
					text: '保存',
					listeners: {
						click: {
							scope: this,
							fn: save
						}
					}
				}, {
					xtype: 'button', //取消按钮
					text: '取消',
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

	// 窗口显示
	addwin.show();

}
