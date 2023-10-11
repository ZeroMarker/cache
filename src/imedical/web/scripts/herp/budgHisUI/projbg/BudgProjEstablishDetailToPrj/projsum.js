projsumFun = function (dutydept, detailtoprjUrl, rowids, budgdept, itemname, isaudit) {
	var hospid = session['LOGON.HOSPID'];
	var userid = session['LOGON.USERID'];
	var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';

	//项目编码
	var coTxt = new Ext.form.TextField({
			id: 'coTxtA',
			fieldLabel: '项目编号',
			emptyText: '后台自动生成...',
			disabled: true,
			anchor: '95%'
		});

	//项目名称
	var naCmb = new Ext.form.ComboBox({
			fieldLabel: '项目名称',
			//width: 150,
			//listWidth: 285,
			store: new Ext.data.JsonStore({
				proxy: new Ext.data.HttpProxy({
					url: detailtoprjUrl + '?action=projList',
					listeners: {
						'beforeload': function (proxy, params) {
							if (!yearCmb.getValue()) {
								Ext.Msg.show({
									title: '注意',
									width: 200,
									msg: '请先选择年度！',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
								return false;
							}
							params.year = yearCmb.getValue();
						}
					}
				}),
				root: 'rows',
				totalProperty: 'results',
				fields: ['rowid', 'name']
			}),
			valueField: 'rowid',
			displayField: 'name',
			value: itemname,
			selectOnFocus: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText: '请选择...',
			pageSize: 10,
			minChars: 1,
			anchor: '95%',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				},
				'keyup': function () {
					spellTxt.setValue(makePy(naCmb.getRawValue().trim()));
				},
				'select': function (combo, record, index) {
					var prjname = combo.getRawValue();
					var len = prjname.indexOf(" ");
					if (len !== -1) {
						var prjcode = prjname.substring(0, len);
						coTxt.setValue(prjcode);
						var name = prjname.substring(len + 1, prjname.length);
						var Pinyin = makePy(name);
						spellTxt.setValue(Pinyin);
					}
				}
			}
		});

	//拼音码
	var spellTxt = new Ext.form.TextField({
			id: 'spellTxtA',
			fieldLabel: '项目拼音码',
			value: makePy(itemname),
			emptyText: '自动生成...',
			anchor: '95%'
		});
	//年度
	var yearCmb = new Ext.form.ComboBox({
			fieldLabel: '年度',
			//width: 120,
			//listWidth: 285,
			store: new Ext.data.JsonStore({
				url: commonboxUrl + '?action=year',
				root: 'rows',
				totalProperty: "results",
				fields: ['year', 'year']
			}),
			valueField: 'year',
			displayField: 'year',
			value: new Date().getFullYear(),
			selectOnFocus: true,
			forceSelection: true,
			emptyText: '请选择...',
			pageSize: 10,
			minChars: 1,
			anchor: '95%',
			triggerAction: 'all'
		});

	//编制方式
	var modelDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '自上而下'], ['2', '自下而上']]
		});
	var modelCmb = new Ext.form.ComboBox({
			id: 'ModelCmb',
			fieldLabel: '编制方式',
			store: modelDs,
			valueNotFoundText: '',
			emptyText: '必填...',
			displayField: 'keyValue',
			valueField: 'key',
			value: 2,
			mode: 'local',
			anchor: '95%',
			triggerAction: 'all',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				},
				select: function (combo, record, index) {
					if (index == 1) {
						bgTotalTxt.disable();
					} else {
						bgTotalTxt.enable();
					}

				}
			}
		});

	//项目总预算
	var bgTotalTxt = new Ext.form.TextField({
			id: 'bgTotalTxt',
			fieldLabel: '项目总预算',
			emptyText: '请输入项目总预算值...',
			anchor: '95%'
		});

	//结余计算方式
	var banTyDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '按总预算计算'], ['2', '按明细项计算']]
		});
	var banTyCmb = new Ext.form.ComboBox({
			id: 'banTyCmb',
			fieldLabel: '结余计算方式',
			store: banTyDs,
			valueNotFoundText: '',
			emptyText: '必填...',
			displayField: 'keyValue',
			valueField: 'key',
			value: 1,
			mode: 'local',
			anchor: '95%',
			triggerAction: 'all',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				}
			}
		});

	//责任科室
	var deptCmb = new Ext.form.ComboBox({
			id: 'deptCmb',
			fieldLabel: '责任科室',
			//width: 150,
			//listWidth: 285,
			store: new Ext.data.JsonStore({
				url: 'herp.budg.budgprojectdictexe.csp' + '?action=calItemdept',
				root: 'rows',
				totalProperty: 'results',
				fields: ['rowid', 'name']
			}),
			valueField: 'rowid',
			displayField: 'name',
			value: dutydept,
			selectOnFocus: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText: '必填...',
			pageSize: 10,
			minChars: 1,
			anchor: '95%',
			disabled: true
		});

	//预算科室
	var bgDeptCmb = new Ext.form.ComboBox({
			fieldLabel: '预算科室',
			//width: 150,
			//listWidth: 285,
			store: new Ext.data.JsonStore({
				url: commonboxUrl + '?action=dept&flag=1',
				root: 'rows',
				totalProperty: 'results',
				fields: ['rowid', 'name']
			}),
			valueField: 'rowid',
			displayField: 'name',
			value: budgdept,
			selectOnFocus: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText: '必填...',
			pageSize: 10,
			minChars: 1,
			anchor: '95%'
		});

	//负责人
	var userCmb = new Ext.form.ComboBox({
			id: 'userCmb',
			fieldLabel: '负责人',
			//width: 120,
			//listWidth: 285,
			store: new Ext.data.JsonStore({
				url: 'herp.budg.budgprojectdictexe.csp' + '?action=caluser',
				root: 'rows',
				totalProperty: "results",
				fields: ['rowid', 'name']
			}),
			valueField: 'rowid',
			displayField: 'name',
			value: session['LOGON.USERCODE'] + '-' + session['LOGON.USERNAME'],
			selectOnFocus: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText: '必填...',
			pageSize: 10,
			minChars: 1,
			anchor: '95%',
			disabled: true
		});

	//项目性质
	var tyDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '一般性项目'], ['2', '基建项目'], ['3', '科研项目']]
		});
	var tyCmb = new Ext.form.ComboBox({
			fieldLabel: '项目性质',
			//width: 150,
			store: tyDs,
			valueField: 'key',
			displayField: 'keyValue',
			value: 1,
			allowBlank: false,
			valueNotFoundText: '',
			emptyText: '请选择...',
			mode: 'local',
			anchor: '95%',
			triggerAction: 'all',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				},
				'select': function (combo, record, index) {
					if (combo.value == "3") {
						PEDateFied.setValue("");
					} else {
						PEDateFied.setValue(new Date().getFullYear() + '-12-31');
					}
				}
			}
		});

	//政府采购
	var govBuyDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '是'], ['2', '否']]
		});
	var govBuyCmb = new Ext.form.ComboBox({
			id: 'govBuyCmb',
			fieldLabel: '政府采购',
			width: 150,
			store: govBuyDs,
			emptyText: '请选择...',
			displayField: 'keyValue',
			valueField: 'key',
			value: 1,
			mode: 'local',
			anchor: '95%',
			triggerAction: 'all',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				}
			}
		});

	//项目状态
	var projStateDs = new Ext.data.SimpleStore({
			fields: ['key', 'keyValue'],
			data: [['1', '新建'], ['2', '执行'], ['3', '完成'], ['4', '取消']]
		});
	var stateCmb = new Ext.form.ComboBox({
			fieldLabel: '项目状态',
			//width: 150,
			store: projStateDs,
			valueNotFoundText: '',
			emptyText: '请选择...',
			displayField: 'keyValue',
			valueField: 'key',
			value: 1,
			disabled: true,
			mode: 'local',
			anchor: '95%',
			triggerAction: 'all',
			listeners: {
				'beforequery': function (qe) {
					delete qe.combo.lastQuery;
				}
			}
		});

	//项目说明
	var descTxt = new Ext.form.TextField({
			id: 'descTxt',
			fieldLabel: '项目说明',
			//width: 200,
			value: itemname,
			emptyText: '选填...',
			anchor: '95%'
		});

	//计划开始时间
	var PSDateFied = new Ext.form.DateField({
			id: 'PSDateFied',
			fieldLabel: '计划开始时间',
			//width: 200,
			value: yearCmb.getValue() + '-' + '01-01',
			allowBlank: false,
			emptyText: '',
			anchor: '95%'
		});
	//计划结束时间
	var PEDateFied = new Ext.form.DateField({
			id: 'PEDateFied',
			fieldLabel: '计划结束时间',
			//width: 200,
			value: yearCmb.getValue() + '-' + '12-31',
			allowBlank: false,
			emptyText: '',
			anchor: '95%'
		});
	//实际开始时间
	var RSDateFied = new Ext.form.DateField({
			id: 'RSDateFied',
			fieldLabel: '实际开始时间',
			//width: 200,
			emptyText: '',
			anchor: '95%'
		});
	//实际结束时间
	var REDateFied = new Ext.form.DateField({
			id: 'REDateFied',
			fieldLabel: '实际结束时间',
			//width: 200,
			emptyText: '',
			anchor: '95%'
		});

	var formPanel = new Ext.form.FormPanel({
			//baseCls: 'x-plain',
			labelWidth: 90,
			//layout: 'form',
			frame: true,
			items: [{
					layout: 'column',
					border: false,
					defaults: {
						columnWidth: '.5',
						bodyStyle: 'padding:5px 5px 0',
						border: false
					},
					items: [{
							xtype: 'fieldset',
							autoHeight: true,
							items: [
								coTxt, naCmb,
								spellTxt, yearCmb,
								modelCmb, bgTotalTxt,
								banTyCmb, deptCmb,
								bgDeptCmb
							]
						}, {
							xtype: 'fieldset',
							autoHeight: true,
							items: [
								userCmb,
								tyCmb, govBuyCmb,
								stateCmb, descTxt,
								PSDateFied, PEDateFied,
								RSDateFied, REDateFied
							]
						}
					]
				}
			]
		});

	var addWin = new Ext.Window({
			title: '汇总编制项目信息',
			width: 1000,
			height: 450,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: formPanel,
			buttons: [{
					text: '生成',
					handler: function () {
						if (formPanel.form.isValid()) {

							var code = coTxt.getValue();
							var name = naCmb.getRawValue();
							var lenn = name.indexOf(" ");
							if (lenn !== -1) {
								name = name.substring(len + 1, name.length);
							}
							name = encodeURIComponent(name);
							var Pinyin = spellTxt.getValue();
							var year = yearCmb.getValue();
							var pretype = modelCmb.getValue(); //编制方式
							var budgvalue = bgTotalTxt.getValue(); //项目总预算
							var blancetype = banTyCmb.getValue(); //结余计算方式
							var budgdeptdr = bgDeptCmb.getValue(); //预算科室
							var len = budgdeptdr.indexOf("_");
							if (len !== "-1") {
								budgdeptdr = budgdeptdr.substring(0, len);
							}
							var deptdr = deptCmb.getValue(); //责任科室
							var lenth = deptdr.indexOf("_");
							if (lenth !== "-1") {
								deptdr = deptdr.substring(0, lenth)
							};
							var userdr = session['LOGON.USERID']; //直接默认当前登录人id //userCmb.getValue();
							var goal = encodeURIComponent(descTxt.getRawValue());
							var property = tyCmb.getValue();
							var isgovbuy = govBuyCmb.getValue();
							var state = stateCmb.getValue();

							var plansdate = PSDateFied.getValue();
							var planedate = PEDateFied.getValue();
							var realsdate = RSDateFied.getValue();
							var realedate = REDateFied.getValue();
							if (plansdate != "") {
								plansdate = plansdate.format('Y-m-d');
							}
							if (planedate != "") {
								planedate = planedate.format('Y-m-d');
							}
							if (realsdate != "") {
								realsdate = realsdate.format('Y-m-d');
							}
							if (realedate != "") {
								realedate = realedate.format('Y-m-d');
							}

							if (name == "") {
								Ext.Msg.show({
									title: '注意',
									msg: '请填写项目名称!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
								return;
							}
							if (plansdate == "") {
								Ext.Msg.show({
									title: '注意',
									msg: '请填写计划开始时间!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
								return;
							}
							if (planedate == "") {
								Ext.Msg.show({
									title: '注意',
									msg: '请填写计划开始时间!',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.WARNING
								});
								return;
							}
							if ((plansdate > planedate) || (realsdate > realedate)) {
								Ext.Msg.show({
									title: '注意',
									msg: '开始时间不能晚于结束时间！',
									icon: Ext.MessageBox.INFO,
									buttons: Ext.Msg.WARNING
								})
								return;
							}
							var data = code + "^" + name + "^" + year + "^" + budgdeptdr + "^" + deptdr + "^" + userdr + "^" + goal + "^" + property + "^" + isgovbuy + "^" + state + "^" + plansdate + "^" + planedate + "^" + realsdate + "^" + realedate + "^" + userid + "^" + hospid + "^" + budgvalue + "^" + pretype + "^" + blancetype + "^" + hospid + "^" + Pinyin;
							//alert(data);
							Ext.Ajax.request({
								url: detailtoprjUrl + '?action=sum&rowids=' + rowids + '&data=' + data,
								waitMsg: '保存中...',
								failure: function (result, request) {
									Ext.Msg.show({
										title: '错误',
										msg: '请检查网络连接!',
										buttons: Ext.Msg.OK,
										icon: Ext.MessageBox.ERROR
									});
								},
								success: function (result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title: '注意',
											msg: '操作成功!',
											icon: Ext.MessageBox.INFO,
											buttons: Ext.Msg.OK
										});
										itemGrid.load({
											params: {
												start: Ext.isEmpty(itemGrid.getBottomToolbar().cursor) ? 0 : itemGrid.getBottomToolbar().cursor,
												limit: itemGrid.getBottomToolbar().pageSize
											}
										});

										submitButton.disable();
										deleteButton.disable();
										sumButton.disable();
										editButton.disable(); //修改按钮不可用
										if (isaudit == "1") {
											editButton.enable(); //修改按钮可用
											deleteButton.disable();
										}

										addWin.close();
									} else {
										var message = jsonData.info;
										if (message == "RepCode") {
											message = "项目编码重复";
										}
										Ext.Msg.show({
											title: '错误',
											msg: message,
											buttons: Ext.Msg.OK,
											icon: Ext.MessageBox.ERROR
										});
									}
								},
								scope: this
							});
						}
					}
				}, {
					text: '取消',
					handler: function () {
						addWin.close();
					}
				}
			]
		});
	addWin.show();
};
