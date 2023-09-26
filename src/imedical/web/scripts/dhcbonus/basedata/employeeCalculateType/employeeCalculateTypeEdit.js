employeeCalTypeEditFun = function() {

	// alert('aaa')
	var OldCalculateTypeID = ""
	// 定义并初始化行对象
	var rowObj = BonusEmployeeTab.getSelections();
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
		var rowid = rowObj[0].get("rowid");
	}
	var empDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	empDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonusemployeeexe.csp?action=list&searchField=code&searchValue='
					+ Ext.getCmp('empFieldE').getRawValue()
					+ '&sort=&dir=&start=0&limit=25',
			method : 'POST'
		})
	});

	var empFieldE = new Ext.form.ComboBox({
				id : 'empFieldE',
				fieldLabel : '管理人员',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : empDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'empFieldE',
				minChars : 1,
				pageSize : 10,
				valueNotFoundText : rowObj[0].get("EmployeeName"),
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

	// ----------------------------------
	// ----------核算单元------------------------------
	var EsupUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	EsupUnitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.bonusunitexe.csp?action=FlagUnit&unitFlag=4&start=0&limit=25',
			method : 'POST'
		})
	});

	var EsupUnitField = new Ext.form.ComboBox({
				id : 'EsupUnitField',
				fieldLabel : '所属科室',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : EsupUnitDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				valueNotFoundText : rowObj[0].get("superName"),
				name : 'EsupUnitField',
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

	var EUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	EUnitDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
							+ '&start=0&limit=25'
							+ '&parent='
							+ Ext.getCmp('EsupUnitField').getValue(),
					method : 'POST'
				})
	});

	var EUnitField = new Ext.form.ComboBox({
				id : 'EUnitField',
				fieldLabel : '核算单元',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : EUnitDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'EUnitField',
				minChars : 1,
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				valueNotFoundText : rowObj[0].get("BonusUnitName"),
				editable : true,
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							addButton.focus();
						}
					}
				}
			});

	// 核算单元上级和核算单元联动
	EsupUnitField.on("select", function(cmb, rec, id) {

		// alert(Ext.getCmp('EsupUnitField').getValue())

		EUnitDs.proxy = new Ext.data.HttpProxy({
					url : '../csp/dhc.bonus.bonusunitexe.csp?action=GetUnitBySuper'
							+ '&start=0&limit=25'
							+ '&parent='
							+ Ext.getCmp('EsupUnitField').getValue(),
					method : 'POST'
				});
		EUnitDs.load({
					params : {
						start : 0,
						limit : 10,
						parent : Ext.getCmp('EsupUnitField').getValue()
					}
				});
	});

	// ----------------------------------

	var CalculateTypeDs1 = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	CalculateTypeDs1.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
					+ Ext.getCmp('CalculateTypeFieldE').getRawValue()
					+ '&start=0&limit=10'
					+ '&CalTypeGroupID='
					+ CalculateTypeGroupCombE.getValue(),
			method : 'POST'
		})
	});

	var CalculateTypeFieldE = new Ext.form.ComboBox({
				id : 'CalculateTypeFieldE',
				fieldLabel : '核算类别',
				width : 230,
				listWidth : 230,
				allowBlank : false,
				store : CalculateTypeDs1,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'CalculateTypeFieldE',
				minChars : 1,
				pageSize : 5,
				valueNotFoundText : rowObj[0].get("CalculateTypeName"),
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
	var CalculateTypeGroupDs1 = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name'])
			});

	CalculateTypeGroupDs1.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.calculatetypegroupexe.csp?action=list',
							method : 'POST'
						})
			});
	var CalculateTypeGroupCombE = new Ext.form.ComboBox({
				fieldLabel : '核算类型组',
				width : 230,
				allowBlank : true,
				store : CalculateTypeGroupDs1,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				pageSize : 10,
				valueNotFoundText : rowObj[0].get("CalculateGroupName"),
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	// 方案和核算单元联动
	CalculateTypeGroupCombE.on("select", function(cmb, rec, id) {
				searchFun(cmb.getValue());

				CalculateTypeDs1.load({
							params : {
								start : 0,
								limit : 10
							}
						});
			});
	function searchFun(SetCfgDr) {

		CalculateTypeDs1.proxy = new Ext.data.HttpProxy({
			url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=CalculateType&CalTypeName='
					+ Ext.getCmp('CalculateTypeFieldE').getRawValue()
					+ '&CalTypeGroupID='
					+ SetCfgDr.toString()
					+ '&start=0&limit=10',
			method : 'POST'
		});
		CalculateTypeDs1.load({
					params : {
						start : 0,
						limit : 10
					}
				});
	};

	// 定义并初始化面板
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [EsupUnitField, EUnitField, CalculateTypeGroupCombE,
						CalculateTypeFieldE]
			});

	// 面板加载
	formPanel.on('afterlayout', function(panel, layout) {
				this.getForm().loadRecord(rowObj[0]);

				CalculateTypeFieldE.setValue(rowObj[0].get("CalculateTypeID"));

				OldCalculateTypeID = rowObj[0].get("CalculateTypeID");

				CalculateTypeGroupCombE.setValue(rowObj[0]
						.get("CalTypeGroupID"));

				EsupUnitField.setValue(rowObj[0].get("SuperiorUnitID"));
				EUnitField.setValue(rowObj[0].get("BonusUnitID"));

			});

	// 定义并初始化保存修改按钮
	var editButton = new Ext.Toolbar.Button({
				text : '保存修改'
			});

	// 定义修改按钮响应函数
	editHandler = function() {

		var BonusUnitID = EUnitField.getValue();
		var supBonusUnitID = EsupUnitField.getValue();
		
		var calculateTypeID = CalculateTypeFieldE.getValue();
		var ChangeTarget = 0

		Ext.MessageBox.confirm('提示', '单元类型改变，是否要改变单元的核算标准?', handler);

		function handler(id) {
			if (id == "yes") {
				ChangeTarget = 1
			} else {
				ChangeTarget = 0
			}

			// alert(ChangeTarget)
			if (BonusUnitID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算单元为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};
			if (calculateTypeID == "") {
				Ext.Msg.show({
							title : '错误',
							msg : '核算类别为空',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			};

			Ext.Ajax.request({
				url : '../csp/dhc.bonus.employeecalculatetypeexe.csp?action=edit&rowid='
						+ rowid
						+ '&BonusUnitID='
						+ BonusUnitID
						+ '&supUnitID='
						+ supBonusUnitID
						+ '&NewCalculateTypeID='
						+ calculateTypeID
						+ '&OldCalculateTypeID='
						+ OldCalculateTypeID
						+ '&ChangeTarget=' + ChangeTarget,
				// EmployeeID CalculateTypeID OldCalculateTypeID
				waitMsg : '保存中...',
				failure : function(result, request) {
					Handler = function() {
						activeFlag.focus();
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

						var sParam = "6^1^3^20"
						var calcTypeGroupID = CalculateTypeGroupComb1
								.getValue()
						var calcTypeID = CalculateTypeField1.getValue()
						var supUnitID = supUnitField1.getValue()
						var bonusUnitID = empField1.getValue()
						sParam = supUnitID + "^" + bonusUnitID + "^"
								+ calcTypeGroupID + "^" + calcTypeID

						BonusEmployeeTabDs.load({
									params : {
										start : 0,
										limit : BonusEmployeeTabPagingToolbar.pageSize,
										QParam : sParam
									}
								});

						editwin.close();
					} else {
						var message = "";
						if (jsonData.info == 'RepCode')
							message = '输入的记录已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的记录已经存在!';
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
	}
	// }

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
				title : '修改记录',
				width : 400,
				height : 250,
				minWidth : 400,
				minHeight : 250,
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