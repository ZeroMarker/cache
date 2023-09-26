var InterLocSetTabUrl = '../csp/dhc.bonus.interlocsetexe.csp';
var outKpiUrl = '../csp/dhc.bonus.outkpiruleexe.csp';
editFun = function(KPIGrid, outKpiDs, outKpiGrid, outKpiPagingToolbar) {
	var rowObj = outKpiGrid.getSelections();
	var KPIObj = KPIGrid.getSelections();
	var KPIDr = "" // KPIObj[0].get("rowid");
	var len = rowObj.length;
	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要修改的奖金指标记录!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return false;
	} else {

		var interLocSetDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name', 'shortcut', 'desc',
									'active'])
				});

		interLocSetDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						//url : 'dhc.bonus.intermethodexe.csp?action=getScheme',
						url : 'dhc.bonus.outkpiruleexe.csp?action=locsetlist&searchField=type&searchValue=1',
						method : 'POST'
					})
		});

		var interLocSetField = new Ext.form.ComboBox({
					id : 'interLocSetField',
					fieldLabel : '接口套',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : interLocSetDs,
					valueField : 'rowid',
					displayField : 'shortcut',
					valueNotFoundText : rowObj[0].get('InterLocSetname'),
					triggerAction : 'all',
					emptyText : '',
					// name: 'interLocSetField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var outkpiRuleDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name', 'active'])
				});

		interLocSetField.on("select", function(cmb, rec, id) {
			outkpiRuleDs.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('interLocSetField').getValue(),
						method : 'POST'
					})
			outkpiRuleDs.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							locSetDr : cmb.getValue()
						}
					});
			schemeTarget1Ds.load({
						params : {
							start : 0,
							limit : outKpiPagingToolbar.pageSize,
							schemeID : cmb.getValue()
						}
					});
		});
		outkpiRuleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.outkpiruleexe.csp?action=kpilist&locSetDr='
								+ Ext.getCmp('interLocSetField').getValue()
								+ '&sort=rowid&dir=asc',
						method : 'POST'
					})
		});
		var bonusTargetTypeEDs = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'code', 'name'])
				});

		bonusTargetTypeEDs.on('beforeload', function(ds, o) {
					ds.proxy = new Ext.data.HttpProxy({
								url : 'dhc.bonus.base10exe.csp?action=targetTypelist',
								method : 'POST'
							})
				});
	var bonusTargetTypeEdit = new Ext.form.ComboBox({
					fieldLabel : '指标类别',
					width : 230,
					allowBlank : true,
					store : bonusTargetTypeEDs,
					valueField : 'rowid',
					displayField : 'name',
					triggerAction : 'all',
					emptyText : '',
					minChars : 1,
					pageSize : 10,
					valueNotFoundText : rowObj[0].get('TargetTypeName'),
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
	// 方案和核算单元联动
	bonusTargetTypeEdit.on("select", function(cmb, rec, id) {
				schemeTarget1Ds.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
		var schemeTarget1Ds = new Ext.data.Store({
					autoLoad : true,
					proxy : "",
					reader : new Ext.data.JsonReader({
								totalProperty : 'results',
								root : 'rows'
							}, ['rowid', 'name'])
				});

		schemeTarget1Ds.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.interkpiexe.csp?action=interkpiTarget&dataSource=1&targetType='
						+ bonusTargetTypeEdit.getValue(),
						method : 'POST'
					})
		});

		var outkpiRuleField = new Ext.form.ComboBox({
					id : 'outkpiRuleField',
					fieldLabel : '接口指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : outkpiRuleDs,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get('InterTargetName'),
					triggerAction : 'all',
					emptyText : '',
					// name: 'outkpiRuleField',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});

		var schemeTargetEdit = new Ext.form.ComboBox({
					id : 'schemeTargetEdit',
					fieldLabel : '奖金指标',
					width : 230,
					listWidth : 230,
					allowBlank : false,
					store : schemeTarget1Ds,
					valueField : 'rowid',
					displayField : 'name',
					valueNotFoundText : rowObj[0].get('name'),
					triggerAction : 'all',
					emptyText : '',
					name : 'schemeTargetEdit',
					minChars : 1,
					pageSize : 10,
					selectOnFocus : true,
					forceSelection : 'true',
					editable : true
				});
		var remarkField = new Ext.form.TextField({
					id : 'remarkField',
					fieldLabel : '接口指标描述',
					name : 'remark',
					allowBlank : true,
					valueNotFoundText : rowObj[0].get('InterTargetemark'),
					// width:180,
					// listWidth : 180,
					emptyText : '',
					anchor : '90%',
					selectOnFocus : 'true'
				});

		var formPanel = new Ext.form.FormPanel({
					baseCls : 'x-plain',
					labelWidth : 80,
					items : [interLocSetField,outkpiRuleField,bonusTargetTypeEdit,schemeTargetEdit, remarkField]
				});

		formPanel.on('afterlayout', function(panel, layout) {
					this.getForm().loadRecord(rowObj[0]);

					interLocSetField.setValue(rowObj[0].get("inLocSetDr"));
					outkpiRuleField.setValue(rowObj[0].get("okrDr"));
					remarkField.setValue(rowObj[0].get("InterTargetemark"))
					schemeTargetEdit.setValue(rowObj[0].get("InterTargetDr"))
					bonusTargetTypeEdit.setValue(rowObj[0].get("TargetTypeID"))
					
				});

		interLocSetField.on("select", function(cmb, rec, id) {
					outkpiRuleDs.proxy = new Ext.data.HttpProxy({
								url : outKpiUrl + '?action=kpilist&locSetDr='
										+ interLocSetField.getValue
										+ '&sort=rowid&dir=asc'
							});
					outkpiRuleDs.load({
								params : {
									start : 0,
									limit : outkpiRuleField.pageSize
								}
							});
				});
		var editButton = new Ext.Toolbar.Button({
					text : '修改'
				});

		// 添加处理函数
		var editHandler = function() {
			var locSetDr = Ext.getCmp('interLocSetField').getValue();
			var outKPIRlue = Ext.getCmp('outkpiRuleField').getValue();
			var remark = Ext.getCmp('remarkField').getValue();
			var schemeTargetID= Ext.getCmp('schemeTargetEdit').getValue();
			
			var active = 'Y'
			locSetDr = trim(locSetDr);
			outKPIRlue = trim(outKPIRlue);
			remark = trim(remark);
			if (locSetDr == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择接口套!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			if (outKPIRlue == "") {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择接口规则指标!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.INFO
						});
				return false;
			};
			var data = schemeTargetID + '^' + outKPIRlue + '^' + remark + '^' + active;

			var rowid = rowObj[0].get("InterMaprowid");

			Ext.Ajax.request({
						url : KPIUrl + '?action=edit&data=' + data + '&rowid='
								+ rowid,
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
											msg : '修改成功!',
											icon : Ext.MessageBox.INFO,
											buttons : Ext.Msg.OK
										});
								// outKpiDs.load({params:{start:0,limit:outKpiPagingToolbar.pageSize,KPIDr:KPIGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
								KPIDs.load({
											params : {
												start : 0,
												limit : KPIPagingToolbar.pageSize
											}
										});
								win.close();
							} else {
								if (jsonData.info == 'RepKPI') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '数据记录重复!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
								if (jsonData.info == 'rowidEmpt') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '错误数据!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO,
												fn : Handler
											});
								}
								if (jsonData.info == 'EmptyRecData') {
									Handler = function() {
										CodeField.focus();
									}
									Ext.Msg.show({
												title : '提示',
												msg : '输入数据为空!',
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
		editButton.addListener('click', editHandler, false);

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
					title : '修改奖金指标',
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
					buttons : [editButton, cancelButton]
				});
		win.show();
	}
}