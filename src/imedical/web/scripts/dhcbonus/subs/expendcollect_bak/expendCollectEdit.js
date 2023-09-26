expendCollectEdit = function() {
	// addFun = function(node) {
	// alert("zlg aaaa")

	var rowObj = IncomeCollectMain.getSelections();
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
	}

	var cField = new Ext.form.TextField({
				id : 'cField',
				fieldLabel : '编码',
				allowBlank : false,
				width : 180,
				listWidth : 180,
				emptyText : '编码...',
				anchor : '90%',
				selectOnFocus : 'true',

				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (cField.getValue() != "") {
								itemValue.focus();
							} else {
								Handler = function() {
									cField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '编码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var itemValue = new Ext.form.NumberField({
				id : 'itemValue',
				fieldLabel : '项目数值',
				allowBlank : false,
				width : 230,
				listWidth : 230,
				emptyText : '',
				anchor : '90%',
				decimalPrecision : 3,
				valueNotFoundText : rowObj[0].get("ExpenItemName"),
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (itemValue.getValue() != "") {
								unitField.focus();
							} else {
								Handler = function() {
									itemValue.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '名称不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});
	var UnitTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['1', '病人科室'], ['2', '执行科室']]
			});
	var UnitTypeEdit = new Ext.form.ComboBox({
				id : 'UnitTypeEdit',
				fieldLabel : '科室类型',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : UnitTypeStore,
				anchor : '90%',
				value : '', // 默认值
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("UnitType"),
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	unitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=unit&str='
							+ Ext.getCmp('unitField').getRawValue(),
					method : 'POST'
				})
	});

	var unitField = new Ext.form.ComboBox({
				id : 'unitField',
				fieldLabel : '核算科室',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : unitDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("BonusUnitCode") + '_'
						+ rowObj[0].get("BonusUnitName"),
				name : 'unitField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});

	var subItemDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['SubItemCode', 'SubItemName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type=3&start=0&limit=10
	subItemDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonussubitemgroupexe.csp?action=listitem&type=3&start=0&limit=10',

			method : 'POST'
		})
	});

	var subItemField = new Ext.form.ComboBox({
				id : 'subItemField',
				fieldLabel : '核算项目',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : subItemDs,
				valueField : 'SubItemCode',
				displayField : 'SubItemName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("ExpenItemName"),
				name : 'subItemField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});
	var calUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'CalUnitName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10
	calUnitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10&str='
					+ Ext.getCmp('calUnitField').getRawValue(),
			method : 'POST'
		})
	});

	var calUnitField = new Ext.form.ComboBox({
				id : 'calUnitField',
				fieldLabel : '核算单位',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : calUnitDs,
				valueField : 'CalUnitName',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("CalculateUnit"),
				name : 'calUnitField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});
	var interTpDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'CalUnitName'])
			});
	// http://localhost/trakcareP8/web/csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10
	interTpDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.base10exe.csp?action=calUnitList&start=0&limit=10&str='
					+ Ext.getCmp('calUnitField').getRawValue(),
			method : 'POST'
		})
	});

	var interTsField = new Ext.form.ComboBox({
				id : 'interTsField',
				fieldLabel : '接口类型',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : interTpDs,
				valueField : 'CalUnitName',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("InterLocSetname"),
				name : 'interTsField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});

	cycleDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
					method : 'POST'
				})
	});

	var cycleEdit = new Ext.form.ComboBox({
				id : 'cycleEdit',
				fieldLabel : '核算周期',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : cycleDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'cycleEdit',
				valueNotFoundText : rowObj[0].get("BonusYear"),
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				//disabled : true,
				forceSelection : 'true',
				editable : false
			});

	var periodTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', '月'], ['Q', '季'], ['H', '半年'], ['Y', '年']]
			});
	var periodTypeEdit = new Ext.form.ComboBox({
				id : 'periodTypeEdit',
				fieldLabel : '期间类型',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '月份',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	periodTypeEdit.on("select", function(cmb, rec, id) {
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
					data = [['H01', '1~6上半年'], ['H02', '7~12下半年']];
				}
				if (cmb.getValue() == "Y") {
					data = [['Y00', '全年']];
				}
				periodStore1.loadData(data);
			});
	periodStore1 = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var periodEdit = new Ext.form.ComboBox({
				id : 'periodEdit',
				fieldLabel : '核算期间',
				selectOnFocus : true,
				allowBlank : false,
				width : 230,
				listWidth : 230,
				store : periodStore1,
				anchor : '90%',
				valueNotFoundText : rowObj[0].get("BonusPeriod"),
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // 本地模式
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});

	
	var locSetDs1 = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name', 'shortcut'])
			});

	locSetDs1.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=3',
			method : 'POST'
		})
	});

	var interTypeEdit = new Ext.form.ComboBox({
				id : 'interTypeEdit',
				fieldLabel : '接口类型',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : locSetDs1,
				valueField : 'rowid',
				displayField : 'shortcut',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("InterLocSetname"),
				name : 'interTypeEdit',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var interMedthodDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	interMedthodDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.intermethodexe.csp?action=InterMethod2&interLocSetDr='
					+ interTypeEdit.getValue() + '&start=0&limit=10',
			method : 'POST'
		})
	});
	interTypeEdit.on("select", function(cmb, rec, id) {

				interMedthodDs.load({
							params : {
								interLocSetDr : Ext.getCmp('interTypeEdit')
										.getValue(),
								start : 0,
								limit : 10
							}
						});
			});
			
	var interMethodEdit = new Ext.form.ComboBox({
				id : 'interMethodEdit',
				fieldLabel : '接口方法',
				width : 230,
				height : 230,
				listWidth : 230,
				allowBlank : false,
				store : interMedthodDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("methodDesc"),
				name : 'interMethodEdit',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [cycleEdit, periodTypeEdit, periodEdit, interTypeEdit,
						interMethodEdit, UnitTypeEdit, unitField, subItemField,
						calUnitField, itemValue]
			});
	// 面板加载
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);

		cycleEdit.setValue(rowObj[0].get("BonusYear"));
		var periodType = rowObj[0].get("periodType")
		periodTypeEdit.setValue(periodType);

		// alert(periodType)
		interTsField.setValue(5);
		periodEdit.setValue(periodType + rowObj[0].get("BonusPeriod"));
		// var period = substring(rowObj[0].get("BonusPeriod"),1,1)
		// alert(period)

		interTypeEdit.setValue(rowObj[0].get("InterLocSetID"));
		
		interMethodEdit.setValue(rowObj[0].get("InterLocMethodID"));
		var unittype1 = rowObj[0].get("UnitType")
		var unitypeID = ''
		if (unittype1 == '病人科室') {
			unitypeID = 1
		}
		if (unittype1 == '执行科室') {
			unitypeID = 2
		}
		UnitTypeEdit.setValue(unitypeID);

		unitField.setValue(rowObj[0].get("BonusUnitCode"));

		subItemField.setValue(rowObj[0].get("ExpendItemCode"));
		calUnitField.setValue(rowObj[0].get("CalculateUnit"));
		itemValue.setValue(rowObj[0].get("ItemValue"));
			/*
			 * 'rowid', 'ExpendItemCode', 'ExpenItemName', 'BonusYear',
			 * 'BonusPeriod', 'BonusUnitCode', 'BonusUnitName', 'UnitType',
			 * 'ExecuteDeptName', 'CalculateUnit', 'ItemValue', 'CollectDate',
			 * 'State', 'InterLocMethodID', 'methodDesc', 'InterLocSetname',
			 * 'UnitType'
			 */
		});
	// 初始化添加按钮
	addButton = new Ext.Toolbar.Button({
				text : '保 存'
			});

	// 定义添加按钮响应函数
	addHandler = function() {

		var sitemValue = itemValue.getValue();
		var scycleEdit = cycleEdit.getValue();
		var speriodTypeEdit = periodTypeEdit.getValue();
		var speriodEdit = periodEdit.getValue();
		var slocSetEdit = interTypeEdit.getValue();
		var sinterMethodEdit = interMethodEdit.getValue();

		var sUnitTypeEdit = UnitTypeEdit.getValue();
		var sunitField = unitField.getValue();
		var nunitField = Ext.get('unitField').dom.value;

		var ssubItemField = subItemField.getValue();
		var nsubItemField = Ext.get('subItemField').dom.value;

		var ncalUnitField = Ext.get('calUnitField').dom.value;
		var sitemValue = itemValue.getValue();

		var sparam1 = ssubItemField + '^' + (nsubItemField) + '^' + sunitField
				+ '^' + (nunitField) + '^' + scycleEdit + '^' + speriodEdit
				+ '^' + (ncalUnitField) + '^' + sitemValue + '^'
				+ sinterMethodEdit+ '^' + sUnitTypeEdit
		var rowid = rowObj[0].get("rowid")

		// alert(sparam1)
		// return;
		if (scycleEdit == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算年度不能为空！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (speriodEdit == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算期间不能为空！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (sinterMethodEdit == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算方法不能为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (ssubItemField == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '项目编码不能为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (nsubItemField == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '项目名称不能为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (nunitField == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算单位不能为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};

		// alert((name))
		// encodeURIComponent
		Ext.Ajax.request({
			url : '../csp/dhc.bonus.subexpendcollectexe.csp?action=edit&sParam='
					+ sparam1 + '&rowid=' + rowid,
			waitMsg : '保存中...',
			failure : function(result, request) {
				Handler = function() {
					unitField.focus();
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
				if (jsonData.success == '0') {
					Handler = function() {
						itemValue.focus();
					}
					Ext.Msg.show({
								title : '注意',
								msg : '添加成功!',
								icon : Ext.MessageBox.INFO,
								buttons : Ext.Msg.OK,
								fn : Handler
							});

					IncomeCollect.load({
								params : {
									start : 0,
									limit : OutKPIDataPagingToolbar.pageSize
								}
							});
					// addwin.close();
				} else {
					var message = "";
					if (jsonData.info == 'RepCode')
						message = '输入的编码已经存在!';

					Ext.Msg.show({
								title : '错误',
								msg : message,
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
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
				title : '添加记录',
				width : 400,
				height : 350,
				minWidth : 400,
				minHeight : 300,
				layout : 'fit',
				plain : true,
				modal : true,
				bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton, cancelButton]
			});

	// 窗口显示
	addwin.show();
}
