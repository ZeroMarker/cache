// 修改按钮
var editButton = new Ext.Toolbar.Button({
	text : '修改',
	tooltip : '修改',
	iconCls : 'add',
	handler : function() {
		// 定义并初始化行对象
		var rowObj = StratagemTab.getSelections();
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
		} else if (len > 1) {
			Ext.Msg.show({
						title : '注意',
						msg : '请选择一条记录!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("SchemeState");
			// alert(state);
			if (state == "审核完成") {
				Ext.Msg.show({
							title : '注意',
							msg : '该条数据方案已经被审核,不允许再修改!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
			if (state == "confirm") {
				Ext.Msg.show({
							title : '注意',
							msg : '该战略已下达,不允许再编辑!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.WARNING
						});
				return false;
			}
		}
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
										+ Ext.getCmp('SchmeField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var SchmeField = new Ext.form.ComboBox({
					id : 'SchmeField',
					fieldLabel : '奖金方案',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : SchemeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '请选择奖金方案...',
					valueNotFoundText : rowObj[0].get("BonusSchemeName"),
					name : 'SchmeField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					// readOnly:false,
					disabled : true,
					editable : true,
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								if (SchmeField.getValue() != "") {
									SchField.focus();
								} else {
									Handler = function() {
										workField.focus();
									}
									Ext.Msg.show({
												title : '错误',
												msg : '目标代码不能为空!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR,
												fn : Handler
											});
								}
							}
						}
					}
				});
		SchmeField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			UField.setValue("");
			UField.setRawValue("");
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
				// unitdeptDs.load({params:{start:0,
				// limit:StratagemTabPagingToolbar.pageSize}});
			});

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

		var editUnTypeField = new Ext.form.ComboBox({
					id : 'editUnTypeField',
					fieldLabel : '单元类别',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'editUnTypeField',
					valueNotFoundText : rowObj[0].get("UnitTypeName"),
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
		editUnTypeField.on("select", function(cmb, rec, id) {
					searchFun(cmb.getValue());

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
								+ Ext.getCmp('UField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchmeField').getValue(),
						method : 'POST'
					});
			UnitDs.load({
						params : {
							start : 0,
							limit : StratagemTabPagingToolbar.pageSize
						}
					});
		};
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
										+ Ext.getCmp('UField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchmeField').getValue()
										+ '&BonusUnitTypeID='
										+ Ext.getCmp('editUnTypeField').getValue(),
								method : 'POST'
							})
				});

		var UField = new Ext.form.ComboBox({
					id : 'UField',
					fieldLabel : '核算单元',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : UnitDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '请选择核算单元...',
					valueNotFoundText : rowObj[0].get("UnitName"),
					name : 'UField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
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
										+ Ext.getCmp('TargField').getRawValue()
										+ '&SchemeID='
										+ Ext.getCmp('SchmeField').getValue(),
								method : 'POST'
							})
				});

		var TargField = new Ext.form.ComboBox({
					id : 'TargField',
					fieldLabel : '核算指标',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : TargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : rowObj[0].get("TargetName"),
					name : 'TargField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
				});
		// 方案和指标联动
		SchmeField.on("select", function(cmb, rec, id) {
			searchFun(cmb.getValue());
			// tmpStr=cmb.getValue();
			TargField.setValue("");
			TargField.setRawValue("");
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
								+ Ext.getCmp('TargField').getRawValue()
								+ '&SchemeID='
								+ Ext.getCmp('SchmeField').getValue(),
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
										+ Ext.getCmp('TargetUField')
												.getRawValue(),
								method : 'POST'
							})
				});

		var TargetUField = new Ext.form.ComboBox({
					id : 'TargetUField',
					fieldLabel : '计量单位',
					width : 180,
					listWidth : 200,
					allowBlank : false,
					store : CalDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					valueNotFoundText : rowObj[0].get("TargetUnitName"),
					name : 'TargetUField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : false,
					forceSelection : 'true',
					editable : true
				});

		// 核算方向
		var DirectDs = new Ext.data.SimpleStore({
					fields : ['key', 'keyValue'],
					data : [['1', '正向'], ['-1', '负向']]
				});
		var DirectionField = new Ext.form.ComboBox({
					id : 'DirectionField',
					fieldLabel : '核算方向',
					width : 180,
					listWidth : 180,
					selectOnFocus : true,
					allowBlank : false,
					store : DirectDs,
					value : '1', // 默认值
					valueNotFoundText : '正向',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '.',
					name : 'TargetDirection',
					mode : 'local', // 本地模式
					editable : false,
					pageSize : 10,
					minChars : 1,
					hidden:true,
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
		var RateField = new Ext.form.TextField({
					id : 'RateField',
					fieldLabel : '计提系数',
					allowBlank : false,
					width : 180,
					listWidth : 180,
					emptyText : '计提系数...',
					// anchor: '90%',
					selectOnFocus : 'true',
					name : 'TargetRate',
					listeners : {
						specialKey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								addButton.focus();
							}
						}
					}
				});

		// 定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 100,
					items : [SchmeField, editUnTypeField, UField, TargField,
							TargetUField, RateField]
				});

		// 面板加载
		formPanel.on('afterlayout', function(panel, layout) {

					var sTargetDirection = rowObj[0].get("TargetDirection")
					this.getForm().loadRecord(rowObj[0]);
					SchmeField.setValue(rowObj[0].get("BonusSchemeID"));
					UField.setValue(rowObj[0].get("UnitID"));
					TargField.setValue(rowObj[0].get("TargetID"));
					TargetUField.setValue(rowObj[0].get("TargetUnit"));
					editUnTypeField.setValue(rowObj[0].get("UnitTypeID"));

					// alert(rowObj[0].get("UnitTypeID"))

					var a = rowObj[0].get("ParameterTarget");
					DirectionField.setValue("1");
					
//					if (sTargetDirection == "正向") {
//						DirectionField.setValue("1");
//					} else {
//						DirectionField.setValue("-1");
//					}

				});

		// 定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
					text : '保存修改'
				});

		// 定义修改按钮响应函数
		editHandler = function() {
			var BonusSchemeID = Ext.getCmp('SchmeField').getValue();
			// alert(BonusSchemeID);
			var UnitID = Ext.getCmp('UField').getValue();
			var TargetID = Ext.getCmp('TargField').getValue();
			var TargetUnit = Ext.getCmp('TargetUField').getValue();
			
			var TargetDirection = '1' //Ext.getCmp('DirectionField').getValue();
			var TargetRate = Ext.getCmp('RateField').getValue();
			var TargetRate = Ext.getCmp('RateField').getValue();
			var editUnType = Ext.getCmp('editUnTypeField').getValue(); 
			
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
					+ TargetRate.trim() + "^" + BonusSchemeID.trim()+ "^" + editUnType.trim();
					
			//prompt('',rowid + '&data=' + data)		
			// alert(data);
			Ext.Ajax.request({
				url : '../csp/dhc.bonus.targetcalculateparamexe.csp?action=edit&rowid='
						+ rowid + '&data=' + data,
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
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					title : '修改参数指标',
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
					buttons : [editButton, cancelButton]
				});

		// 窗口显示
		editwin.show();
	}
});
