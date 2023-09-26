function addBotton() {

	var cycleDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['RowID', 'BonusYear'])
			});
	var bonusYearField = new Ext.form.ComboBox({
				id : 'bonusYearField',
				fieldLabel : '核算年度',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : cycleDs,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'BonusYear',
				valueField : 'BonusYear',
				triggerAction : 'all',
				emptyText : '选择核算年度...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.deptbonuscalcexe.csp'
									+ '?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

	var dateTypeField = new Ext.form.ComboBox({
				id : 'dateTypeField',
				fieldLabel : '期间类型',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '选择期间类型...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var addperiodStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	dateTypeField.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'],
							['M04', '04月'], ['M05', '05月'], ['M06', '06月'],
							['M07', '07月'], ['M08', '08月'], ['M09', '09月'],
							['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
				}
				if (cmb.getValue() == "Q") {
					data = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
							['Q04', '04季度']];
				}
				if (cmb.getValue() == "H") {
					data = [['H01', '上半年'], ['H02', '下半年']];
				}
				if (cmb.getValue() == "Y") {
					data = [['Y00', '00']];
				}
				addperiodStore.loadData(data);

			});

	var bonusPeriodField = new Ext.form.ComboBox({
				id : 'bonusPeriodField',
				fieldLabel : '核算期间',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : addperiodStore,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '选择核算期间...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				name : 'order',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var unitDatas = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var bonusUnitAdd = new Ext.form.ComboBox({
				id : 'bonusUnitAdd',
				fieldLabel : '核算单元',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDatas,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '选择核算单元...',
				//mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			}); 
	unitDatas.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0', //&start=0&limit=5
							method : 'POST'
						})
			});

	var Proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.paymanagerexe.csp?action=unitemp'
			});
	var empDs = new Ext.data.Store({
				proxy : Proxy,
				reader : new Ext.data.JsonReader({
							root : 'rows',
							totalProperty : 'results'
						}, ['rowid', 'name']),
				remoteSort : true
			});

	bonusUnitAdd.on("select", function(cmb, rec, id) {
				if (Ext.getCmp('bonusUnitAdd').getValue() != '') {
					empDs.load({
								params : {
									UnitID : Ext.getCmp('bonusUnitAdd')
											.getValue()
								}
							});
				}

			});

	var bonusEmpField = new Ext.form.ComboBox({
				id : 'bonusEmpField',
				fieldLabel : '领取人员',
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : empDs,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("appSysName"),
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '选择领取人员...',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (appField.getValue() != "") {
								descField.focus();
							} else {
								Handler = function() {
									appField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '应用系统代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var BonusValueField = new Ext.form.NumberField({
				id : 'BonusValueField',
				fieldLabel : '所得奖金',
				allowBlank : false,
				emptyText : '所得奖金...',
				anchor : '90%',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
				allowNegative : false,
				allowDecimals : false,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (orderField.getValue() != "") {
								appSysField.focus();
							} else {
								Handler = function() {
									orderField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '维度分类顺序不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	// 初始化面板
	var addformPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [bonusYearField, dateTypeField, bonusPeriodField,
						bonusUnitAdd, bonusEmpField, BonusValueField]
			});
	// 初始化添加按钮
	addButton = new Ext.Toolbar.Button({
				text : '添 加'
			});

	// 定义添加按钮响应函数
	addHandler = function() {

		var empid = bonusEmpField.getValue();
		var BonusYear = bonusYearField.getValue();
		var BonusPeriod = bonusPeriodField.getValue();
		var BonusValue = Ext.getCmp('BonusValueField').getValue();

		if (empid == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '领取人员为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusPeriod == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算期间为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusYear == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算年度为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (BonusValue == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '领取金额为空',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		var inserts = empid + '^' + BonusYear + '^' + BonusPeriod + '^'
				+ BonusValue

		Ext.Ajax.request({
			url : '../csp/dhc.bonus.paymanagerexe.csp?action=add&inserts='
					+ inserts,
			waitMsg : '保存中...',
			failure : function(result, request) {
				Handler = function() {
					BonusValue.focus();
				}
				Ext.Msg.show({
							title : '错误',
							msg : '请检查网络连接!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR,
							fn : Handler
						});
			},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Handler = function() {
						BonusValueField.focus();
					}
					Ext.Msg.show({
								title : '注意',
								msg : '添加成功!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK,
								fn : Handler
							});
					// 重新加载页面
					BonusPayTabDs.load({
						params : {
							bonusYear : Ext.getCmp('periodYear').getValue(),
							bonusPeriod : Ext.getCmp('periodField').getValue(),
							bonusUnit : Ext.getCmp('bonusUnitField').getValue(),
							start : 0,
							limit : BonusPayTabPagingToolbar.pageSize
						}
					});

				} else {
					if (jsonData.info == 'exist') {
						Handler = function() {
							BonusValueField.focus();
						}
						Ext.Msg.show({
									title : '错误',
									msg : '数据已经添加!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR,
									fn : Handler
								});
					}
				}
			},
			scope : this
		});
	}

	// 添加保存按钮的监听事件
	addButton.addListener('click', addHandler, false);

	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '取消'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		addwin.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	// 初始化窗口
	addwin = new Ext.Window({
				title : '添加维度分类记录',
				width : 380,
				height : 300,
				minWidth : 380,
				minHeight : 250,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : addformPanel,
				buttons : [addButton, cancelButton]
			});

	// 窗口显示
	addwin.show();
}
