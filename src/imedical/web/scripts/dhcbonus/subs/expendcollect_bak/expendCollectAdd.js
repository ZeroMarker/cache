expendCollectAdd = function() {
	// addFun = function(node) {
	// alert("zlg aaaa")
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
	var UnitTypeAdd = new Ext.form.ComboBox({
				id : 'UnitTypeAdd',
				fieldLabel : '科室类型',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : UnitTypeStore,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '',
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

	var unitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
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
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
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
				valueField : 'rowid',
				displayField : 'CalUnitName',
				triggerAction : 'all',
				emptyText : '',
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

	cycleDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonustargetcollectexe.csp?action=yearlist',
					method : 'POST'
				})
	});

	var cycleAdd = new Ext.form.ComboBox({
				id : 'cycleAdd',
				fieldLabel : '核算周期',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : cycleDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'cycleAdd',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var periodTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', '月'], ['Q', '季'], ['H', '半年'], ['Y', '年']]
			});
	var periodTypeAdd = new Ext.form.ComboBox({
				id : 'periodTypeAdd',
				fieldLabel : '期间类型',
				selectOnFocus : true,
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : periodTypeStore,
				anchor : '90%',
				value : '', // 默认值
				valueNotFoundText : '',
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

	periodTypeAdd.on("select", function(cmb, rec, id) {
		if (cmb.getValue() == "M") {
			data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
					['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
					['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
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

	var periodAdd = new Ext.form.ComboBox({
				id : 'periodAdd',
				fieldLabel : '核算期间',
				selectOnFocus : true,
				allowBlank : false,
				width : 230,
				listWidth : 230,
				store : periodStore1,
				anchor : '90%',
				valueNotFoundText : '',
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

	var locSetDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name', 'shortcut'])
			});

	locSetDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : 'dhc.bonus.outkpiruleexe.csp?action=locsetSublist&searchField=TypeID&searchValue=3',
			method : 'POST'
		})
	});

	var locSetAdd = new Ext.form.ComboBox({
				id : 'locSetAdd',
				fieldLabel : '接口类型:',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : locSetDs,
				valueField : 'rowid',
				displayField : 'shortcut',
				triggerAction : 'all',
				emptyText : '',
				name : 'locSetAdd',
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
					+ locSetAdd.getValue() + '&start=0&limit=10',
			method : 'POST'
		})
	});
	locSetAdd.on("select", function(cmb, rec, id) {

				interMedthodDs.load({
							params : {
								interLocSetDr : Ext.getCmp('locSetAdd')
										.getValue(),
								start : 0,
								limit : 10
							}
						});
			});
	var interMethodAdd = new Ext.form.ComboBox({
				id : 'interMethodAdd',
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
				name : 'interMethodAdd',
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
				items : [cycleAdd, periodTypeAdd, periodAdd, locSetAdd,
						interMethodAdd, UnitTypeAdd, unitField, subItemField,
						calUnitField, itemValue]
			});

	// 初始化添加按钮
	addButton = new Ext.Toolbar.Button({
				text : '添 加'
			});

	// 定义添加按钮响应函数
	addHandler = function() {

		var sitemValue = itemValue.getValue();
		var scycleAdd = cycleAdd.getValue();
		var speriodTypeAdd = periodTypeAdd.getValue();
		var speriodAdd = periodAdd.getValue();
		var slocSetAdd = locSetAdd.getValue();
		var sinterMethodAdd = interMethodAdd.getValue();

		var sUnitTypeAdd = UnitTypeAdd.getValue();
		var sunitField = unitField.getValue();
		var nunitField = Ext.get('unitField').dom.value;

		var ssubItemField = subItemField.getValue();
		var nsubItemField = Ext.get('subItemField').dom.value;

		var ncalUnitField = Ext.get('calUnitField').dom.value;
		var sitemValue = itemValue.getValue();

		var sparam1 = ssubItemField + '^' + (nsubItemField) + '^' + sunitField
				+ '^' + (nunitField) + '^' + scycleAdd + '^' + speriodAdd
				+ '^' + (ncalUnitField) + '^' + sitemValue + '^'
				+ sinterMethodAdd+ '^'+ sUnitTypeAdd

		// alert(sparam1)
		// return;
		if (scycleAdd == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算年度不能为空！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (speriodAdd == "") {
			Ext.Msg.show({
						title : '错误',
						msg : '核算期间不能为空！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
			return;
		};
		if (sinterMethodAdd == "") {
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
					url : '../csp/dhc.bonus.subexpendcollectexe.csp?action=add&sParam='
							+ sparam1,
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
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
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
							if (jsonData.info == 'RecordExist')
								message = '相关数据已经存在!';

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
