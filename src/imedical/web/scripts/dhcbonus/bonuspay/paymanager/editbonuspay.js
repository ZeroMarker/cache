function editBonus() {

	// 定义并初始化行对象
	var rowObj = BonusPay.getSelections();
	// 定义并初始化行对象长度变量
	var len = rowObj.length;
	// 判断是否选择了要修改的数据
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	} else {
		var rowid = rowObj[0].get("rowID");
	}

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
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : cycleDs,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : rowObj[0].get("BonusYear"),
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
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // 默认值
				// valueNotFoundText : rowObj[0].get("dateTypeField"),
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
				disabled : true,
				allowBlank : false,
				store : addperiodStore,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : rowObj[0].get("BonusPeriod"),
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

	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	var editUnitField = new Ext.form.ComboBox({
				id : 'editUnitField',
				fieldLabel : '核算单元',
				listWidth : 230,
				disabled : true,
				selectOnFocus : true,
				allowBlank : false,
				store : unitDs,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : rowObj[0].get("BonusUnitName"),
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
	unitDs.on('beforeload', function(ds, o) {

				ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/dhc.bonus.bonusunitexe.csp'
									+ '?action=lastunit&sUnitFlag=1&LastStage=0',
							method : 'POST'
						})
			});

	var editProxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.paymanagerexe.csp?action=unitemp'
		
			});
	var editEmpDS = new Ext.data.Store({
				proxy : editProxy,
				reader : new Ext.data.JsonReader({
							root : 'rows',
							totalProperty : 'results'
						}, ['rowid', 'name']),
				remoteSort : true
			});

	editUnitField.on("select", function(cmb, rec, id) {
				if (Ext.getCmp('editUnitField').getValue() != '') {
					editEmpDS.load({
								params : {
									UnitID : Ext.getCmp('editUnitField')
											.getValue()
								}
							});
				}

			});

	var editEmpField = new Ext.form.ComboBox({
				id : 'editEmpField',
				fieldLabel : '领取人员',
				disabled : true,
				listWidth : 230,
				selectOnFocus : true,
				allowBlank : false,
				store : editEmpDS,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : rowObj[0].get("EmployeeName"),

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
				value : '',
				valueNotFoundText : rowObj[0].get("BonusValue"),
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

	// 定义并初始化面板
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [bonusYearField, dateTypeField, bonusPeriodField,
						editUnitField, editEmpField, BonusValueField]
			});

	// 面板加载
	formPanel.on('afterlayout', function(panel, layout) {

				var sBonusPeriod = rowObj[0].get("PeriodCode")
				var periodType = sBonusPeriod.substring(0, 1)

				bonusYearField.setValue(rowObj[0].get("BonusYear"))

				dateTypeField.setValue(periodType)
				bonusPeriodField.setValue(sBonusPeriod)

				editUnitField.setValue(rowObj[0].get("BonusUnitID"))
				editEmpField.setValue(rowObj[0].get("BonusEmployeeID"))
				BonusValueField.setValue(rowObj[0].get("BonusValue"))
			});

	// 定义并初始化保存修改按钮
	var editButton = new Ext.Toolbar.Button({
				text : '保存修改'
			});

	// 定义修改按钮响应函数
	editHandler = function() {

		var empid = editEmpField.getValue();
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
		var edits = rowid + '^' + empid + '^' + BonusYear + '^' + BonusPeriod
				+ '^' + BonusValue

		Ext.Ajax.request({
			url : '../csp/dhc.bonus.paymanagerexe.csp?action=edit&edits='
					+ edits,
			waitMsg : '保存中...',
			failure : function(result, request) {
				Handler = function() {
					BonusValueField.focus();
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
					Ext.Msg.show({
								title : '注意',
								msg : '修改成功!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK
							});
					// 重新加载页面
					BonusPayTabDs.load({
						params : {
							bonusYear : Ext.getCmp('periodYear').getValue(),
							bonusPeriod : Ext.getCmp('periodField').getValue(),
							bonusUnit : Ext.getCmp('editUnitField').getValue(),
							start : 0,
							limit : BonusPayTabPagingToolbar.pageSize
						}
					});

					editwin.close();
				} else {
					if (jsonData.info == 'RepCode') {
						Handler = function() {
							BonusValueField.focus();
						}
						Ext.Msg.show({
									title : '错误',
									msg : '维度分类代码已经存在!',
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

	// 添加保存修改按钮的监听事件
	editButton.addListener('click', editHandler, false);

	// 定义并初始化取消修改按钮
	var cancelButton = new Ext.Toolbar.Button({
				text : '取消修改'
			});

	// 定义取消修改按钮的响应函数
	cancelHandler = function() {
		editwin.close();
	}

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);

	// 定义并初始化窗口
	var editwin = new Ext.Window({
				title : '修改人员奖金发放',
				width : 380,
				height : 260,
				minWidth : 380,
				minHeight : 260,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [editButton, cancelButton]
			});

	// 窗口显示
	editwin.show();
}
