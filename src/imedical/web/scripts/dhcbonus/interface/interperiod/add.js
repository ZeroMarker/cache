addFun = function(locSetField, grid, ds, pagingToolbar) {
	var locsetName = Ext.getCmp('locSetField').getRawValue();
	var locsetDr = Ext.getCmp('locSetField').getValue();
	var periodStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue']
			});

	var data = "";
	var data1 = [['01', '01月'], ['02', '02月'], ['03', '03月'], ['04', '04月'],
			['05', '05月'], ['06', '06月'], ['07', '07月'], ['08', '08月'],
			['09', '09月'], ['10', '10月'], ['11', '11月'], ['12', '12月']];
	var data2 = [['01', '01季度'], ['02', '02季度'], ['03', '03季度'], ['04', '04季度']];
	var data3 = [['01', '1~6上半年'], ['02', '7~12下半年']];
	var data4 = [['00', '00']];

	var yearField = new Ext.form.NumberField({
				id : 'yearField',
				fieldLabel : '核算年度',
				allowBlank : false,
				emptyText : '',
				anchor : '90%',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
				allowNegative : false,
				allowDecimals : false,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (yearField.getValue() != "") {
								periodTypeField.focus();
							} else {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '核算年度不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var periodTypeStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['M', 'M-月'], ['Q', 'Q-季'], ['H', 'H-半年'], ['Y', 'Y-年']]
			});
	var periodTypeField = new Ext.form.ComboBox({
				id : 'periodTypeField',
				fieldLabel : '期间类型',
				width : 220,
				listWidth : 220,
				selectOnFocus : true,
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

	periodTypeField.on("select", function(cmb, rec, id) {
				if (cmb.getValue() == "M") {
					data = data1;
				}
				if (cmb.getValue() == "Q") {
					data = data2;
				}
				if (cmb.getValue() == "H") {
					data = data3;
				}
				if (cmb.getValue() == "Y") {
					data = data4;
				}
				periodStore.loadData(data);

			});

	var periodField = new Ext.form.ComboBox({
				id : 'periodField',
				fieldLabel : '核算期间',
				width : 180,
				// listWidth : 180,
				selectOnFocus : true,
				allowBlank : false,
				store : periodStore,
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
				forceSelection : true,
				isteners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (periodField.getValue() != "") {
								startDate.focus();
							} else {
								Handler = function() {
									periodField.focus();
								}
								Ext.Msg.show({
											title : '错误',
											msg : '期间不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var monthCombo = new Ext.ux.form.LovCombo({
		id : 'monthCombo',
		fieldLabel : '引用期间',
		hideOnSelect : false,
		store : new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
						url : 'dhc.pa.interperiodexe.csp?action=quotelist&locSetDr='
								+ locsetDr
					}),
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results',
						id : 'rowid'
					}, ['rowid', 'name'])
		}, ['rowid', 'name']),
		valueField : 'rowid',
		displayField : 'name',
		typeAhead : false,
		triggerAction : 'all',
		pageSize : 18,
		width : 220,
		listWidth : 220,
		allowBlank : false,
		disabled : false,
		emptyText : '',
		editable : false,
		anchor : '90%'
	});

	// 定义起始时间控件
	var startDate = new Ext.form.DateField({
				id : 'startDate',
				format : 'Y-m-d',
				fieldLabel : '起始时间',
				width : 220,
				disabled : false,
				emptyText : '',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (startDate.getValue() != "") {
								endDate.focus();
							} else {
								Handler = function() {
									startDate.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '起始时间不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	// 定义结束时间控件
	var endDate = new Ext.form.DateField({
				id : 'endDate',
				format : 'Y-m-d',
				fieldLabel : '结束时间',
				width : 220,
				disabled : false,
				emptyText : '',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (endDate.getValue() != "") {
								remarkField.focus();
							} else {
								Handler = function() {
									endDate.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '结束时间不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var remarkField = new Ext.form.TextField({
				id : 'remarkField',
				fieldLabel : '备注',
				allowBlank : true,
				width : 220,
				listWidth : 220,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});


		// 初始化面板
		formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 60,
					items : [yearField, periodTypeField, periodField,
							startDate, endDate, remarkField]
				});


	// 初始化添加按钮
	addButton = new Ext.Toolbar.Button({
				text : '添 加'
			});

	// 定义添加按钮响应函数
	addHandler = function() {
		var syear = yearField.getRawValue();
	

						  
		var periodType = periodTypeField.getValue();
		var period = periodField.getValue();

		var remark = remarkField.getValue();

		var data = "";
 
			var startDate = Ext.getCmp('startDate').getValue();
			if (startDate != "") {
				startDate = startDate.format('Y-m-d');
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '开始日期为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if (endDate != "") {
				endDate = endDate.format('Y-m-d');
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '结束日期为空!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
			if (checkDate(startDate, endDate)) {
				var corrType = "I";
				data = locsetDr + "^" + period  + "^" + periodType + "^" + remark
						+ "^" + startDate + "^" + endDate + "^" + corrType+ "^" + syear;
			//prompt("data",data)
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '开始日期大于结束日期',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			}
		

		Ext.Ajax.request({
					url : 'dhc.bonus.interperiodexe.csp?action=add&data=' + data,
					waitMsg : '保存中...',
					failure : function(result, request) {
						Handler = function() {
							codeField.focus();
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
						if (jsonData.success == 'true') {
							Ext.Msg.show({
										title : '提示',
										msg : '添加成功!',
										icon : Ext.MessageBox.INFO,
										buttons : Ext.Msg.OK
									});
							ds.load({
										params : {
											start : 0,
											limit : pagingToolbar.pageSize,
											locSetDr : locsetDr
										}
									});
						} else {
							if (jsonData.info == 'RepRecord') {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '此记录已经存在!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
							if (jsonData.info == 'dataEmpt') {
								Handler = function() {
									yearField.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '记录为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
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
				title : '添加接口期间记录',
				width : 343,
				height : 270,
				minWidth : 343,
				minHeight : 220,
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