function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
addFun = function(KPIGrid, outKpiDs, outKpiGrid, outKpiPagingToolbar) {

	var rowObj = KPIGrid.getSelections();
	var len = 1 // rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择要对照的指标!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		// var KPIDr = rowObj[0].get("rowid");
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
				// url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
				url : 'dhc.bonus.outkpiruleexe.csp?action=locsetlist&searchField=type&searchValue=1',
				method : 'POST'
			})
		});

		var locSetField = new Ext.form.ComboBox({
					id : 'locSetField',
					fieldLabel : '接口套',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : locSetDs,
					valueField : 'rowid',
					displayField : 'shortcut',
					triggerAction : 'all',
					emptyText : '',
					name : 'locSetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		locSetField.on("select", function(cmb, rec, id) {
			outKPIRlueDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('locSetField').getValue(),
						method : 'POST'
					})
			outKPIRlueDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							locSetDr : cmb.getValue()
						}
					});
			schemeTargetDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							schemeID : cmb.getValue()
						}
					});
		});

		var outKPIRlueDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		outKPIRlueDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('locSetField').getValue(),
						method : 'POST'
					})
		});
		var bonusTargetTypeDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		bonusTargetTypeDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
								method : 'POST'
							})
				});

		var bonusTargetTypeComb = new Ext.form.ComboBox({
					fieldLabel : '指标类别',
					width : 230,
					allowBlank : true,
					store : bonusTargetTypeDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
	// 方案和核算单元联动
	bonusTargetTypeComb.on("select", function(cmb, rec, id) {
				schemeTargetDs.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
		var schemeTargetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTargetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
				url : 'dhc.bonus.interkpiexe.csp?action=interkpiTarget&dataSource=1&targetType='
						+ bonusTargetTypeComb.getValue(),
				method : 'POST'
			})
		});

		var outKPIRlueField = new Ext.form.ComboBox({
					id : 'outKPIRlueField',
					fieldLabel : '接口指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : outKPIRlueDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'outKPIRlueField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var bonusTargetField = new Ext.form.ComboBox({
					id : 'bonusTargetField',
					fieldLabel : '奖金指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTargetDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					name : 'bonusTargetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		var remarkField = new Ext.form.TextField({
					id : 'remarkField',
					fieldLabel : '指标描述',
					allowBlank : true,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 60,
					items : [locSetField, outKPIRlueField, bonusTargetTypeComb,
							bonusTargetField, remarkField]
				});

		var addButton = new Ext.Toolbar.Button({
					text : '添加'
				});

		// 添加处理函数
		var addHandler = function() {

			var locSetDr = Ext.getCmp('locSetField').getValue();
			var outKPIRlue = Ext.getCmp('outKPIRlueField').getValue();
			var remark = Ext.getCmp('remarkField').getValue();
			var schemeTargetID = Ext.getCmp('bonusTargetField').getValue();

			locSetDr = trim(locSetDr);
			outKPIRlue = trim(outKPIRlue);
			remark = trim(remark);
			if (locSetDr == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '请选奖金方案!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (outKPIRlue == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '请选接口指标!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (schemeTargetID == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '请选方案指标!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			var data = schemeTargetID + '^' + outKPIRlue + '^' + remark;
			// prompt('data', data)
			Ext.Ajax.request({
						url : KPIUrl + '?action=add&data=' + data,
						waitMsg : '添加中..',
						failure : function(result, request) {
							Ext.Msg.show({
										title : '错误',
										msg : '请检查网络连接!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
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
								// outKpiDs.load({params:{start:0,
								// limit:outKpiPagingToolbar.pageSize,locSetDr:locSetDr,dir:'asc',sort:'rowid'}});
								KPIDs.load({
											params : {
												start : 0,
												limit : KPIPagingToolbar.pageSize
											}
										});
								// win.close();

							} else {
								if (jsonData.info == 'RepKPI') {
									Handler = function() {
										codeField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '数据记录重复!',
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

		// 添加按钮的响应事件
		addButton.addListener('click', addHandler, false);

		// 定义取消按钮
		var cancelButton = new Ext.Toolbar.Button({
					text : '取消'
				});

		// 取消处理函数
		var cancelHandler = function() {
			win.close();
		}

		// 取消按钮的响应事件
		cancelButton.addListener('click', cancelHandler, false);

		var win = new Ext.Window({
					title : '添加KPI指标',
					width : 355,
					height : 230,
					minWidth : 355,
					minHeight : 200,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [addButton, cancelButton]
				});
		win.show();
	}
}