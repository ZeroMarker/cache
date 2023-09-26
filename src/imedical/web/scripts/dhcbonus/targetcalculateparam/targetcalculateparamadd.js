

// 添加按钮
var addButton = new Ext.Toolbar.Button({
	text : '添加',
	tooltip : '添加',
	iconCls : 'add',
	handler : function() {

		// 奖金方案
		var SchemeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		SchemeDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl
										+ '?action=schemelist1&str='
										+ Ext.getCmp('SchField').getRawValue(),
								method : 'POST'
							})
				});

		var SchField = new Ext.form.ComboBox({
					id : 'SchField',
					fieldLabel : '奖金方案',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : SchemeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'SchField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (SchField.getValue() != "") {
									UnField.focus();
								} else {
									Handler = function() {
										UnField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '奖金方案不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// 方案核算单元联动
		SchField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					UnField.setValue("");
					UnField.setRawValue("");
					UnitDs.load({
								params : {
									start : 0,
									limit : StratagemTabPagingToolbar.pageSize
								}
							});

				});

		function searchFun(BonusSchemeID) {
			UnitDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/targetcalculateparamexe.csp?action=suunit&str='
								+ Ext.getCmp('UnField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchField').getValue()
								+ '&BonusUnitTypeID='
								+ Ext.getCmp('UnTypeField').getValue(),
						method : 'POST'
					});
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};

		// 核算单元类别

		var UnitTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		UnitTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : '../csp/dhc.bonus.bonusunittypeexe.csp?action=list&start=0&limit=10&sort=code&dir=ASC',

				method : 'POST'
			})
		});

		var UnTypeField = new Ext.form.ComboBox({
					id : 'UnTypeField',
					fieldLabel : '单元类别',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnTypeField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (UnField.getValue() != "") {
									TarField.focus();
								} else {
									Handler = function() {
										TarField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '核算单元不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// 核算类别单元联动
		UnTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());
					UnField.setValue("");
					UnField.setRawValue("");
					UnitDs.load({
								params : {
									start : 0,
									limit : StratagemTabPagingToolbar.pageSize
								}
							});

				});


		// 核算单元
		var UnitDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		UnitDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl + '?action=suunit&str='
										+ Ext.getCmp('UnField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchField').getValue()

										+ '&BonusUnitTypeID='
										+ Ext.getCmp('UnTypeField').getValue(),
								method : 'POST'
							})
				});

		var UnField = new Ext.form.ComboBox({
					id : 'UnField',
					fieldLabel : '核算单元',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'UnField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (UnField.getValue() != "") {
									TarField.focus();
								} else {
									Handler = function() {
										TarField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '核算单元不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		// 奖金指标
		var TargetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		TargetDs.on('beforeload', function(ds, o) {

					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl + '?action=stunit&str='
										+ Ext.getCmp('TarField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchField').getValue(),
								method : 'POST'
							})
				});

		var TarField = new Ext.form.ComboBox({
					id : 'TarField',
					fieldLabel : '核算指标',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : TargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'TarField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (TarField.getValue() != "") {
									TargetUnitField.focus();
								} else {
									Handler = function() {
										TargetUnitField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '核算指标不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		// 方案和指标联动
		SchField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			TarField.setValue("");
			TarField.setRawValue("");
			TargetDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
				// unitdeptDs.load({params:{start:0,
				// limit:StratagemTabPagingToolbar.pageSize}});
			});

		function searchFun(BonusSchemeID) {
			TargetDs.proxy = new Ext.data.HttpProxy({
						url : '../csp/targetcalculateparamexe.csp?action=stunit&str='
								+ Ext.getCmp('TarField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchField').getValue(),
						method : 'POST'
					});
			TargetDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};

		// 计量单位
		var CalDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		CalDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : StratagemTabUrl
										+ '?action=calunit&str='
										+ Ext.getCmp('TargetUnitField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var TargetUnitField = new Ext.form.ComboBox({
					id : 'TargetUnitField',
					fieldLabel : '计量单位',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : CalDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'TargetUnitField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (TargetUnitField.getValue() != "") {
									AccountBaseField.focus();
								} else {
									Handler = function() {
										AccountBaseField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '计量单位不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});

		// 核算方向
		var DirectDs = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '正向'], ['-1', '负向']]
				});
		var TargetDirectionField = new Ext.form.ComboBox({
					id : 'TargetDirectionField',
					fieldLabel : '核算方向',
					width : 180,
					listWidth : 180,
					selectOnFocus : true,
					allowBlank : false,
					store : DirectDs,
					// anchor: '90%',
					value : '', // 默认值
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					hidden:true,
					minChars : 1,
					selectOnFocus : true,
					forceSelection : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// 计提系数
		var TargetRateField = new Ext.form.TextField({
					id : 'TargetRateField',
					fieldLabel : '计提系数',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '',
					// anchor: '90%',
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
					labelWidth : 100,
					items : [SchField, UnTypeField, UnField, TarField,
							TargetUnitField, //TargetDirectionField,
							TargetRateField]
				});

		// 初始化添加按钮
		addButton = new Ext.Toolbar.Button({
					text : '添 加'
				});

		// 定义添加按钮响应函数
		addHandler = function() {
			var BonusSchemeID = Ext.getCmp('SchField').getValue();
			// alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UnField').getValue();
			var TargetID = Ext.getCmp('TarField').getValue();
			var TargetUnit = Ext.getCmp('TargetUnitField').getValue();
			var TargetDirection ='1' //Ext.getCmp('TargetDirectionField').getValue();
			var TargetRate = Ext.getCmp('TargetRateField').getValue();
			var UnitTypeID= Ext.getCmp('UnTypeField').getValue();
			
			
			if (BonusSchemeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '奖金方案为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (UnitID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算单元为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (TargetID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算指标为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (TargetUnit == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '计量单位为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			var data = UnitID.trim() + "^" + TargetID.trim() + "^"
					+ TargetUnit.trim() + "^" + TargetDirection.trim() + "^"
					+ TargetRate.trim() + "^" + BonusSchemeID.trim()
					+ "^" + UnitTypeID.trim();
					
			//prompt('',data);

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.targetcalculateparamexe.csp?action=add&data='
						+ data,
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						TarField.focus();
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
				
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize}});
										
					}
					else if(jsonData.info=='RepScheme')
						{
						Ext.Msg.show({title:'错误',msg:'该方案中已存在该单元的指标',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
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
					title : '添加参数指标',
					width : 400,
					height : 400,
					minWidth : 400,
					minHeight : 400,
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
});