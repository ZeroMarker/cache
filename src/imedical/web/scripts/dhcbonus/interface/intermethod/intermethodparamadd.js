addMethodParamFun = function(dataStore, grid, pagingTool) {


	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if (len < 1) {
		Ext.Msg.show({
					title : '注意',
					msg : '请选择需要添加的接口方法!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		return;
	}

	if (interLocSetField.getValue() == "") {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择接口套',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
		return false;
	}
	var methodParamDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['code', 'name'])
			});

	methodParamDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : InterLocUrl + '?action=InterParam',
							method : 'POST'
						})
			});

	var methodParamField = new Ext.form.ComboBox({
				id : 'methodParamField',
				fieldLabel : '参数名称',
				allowBlank : false,
				store : methodParamDs,
				valueField : 'code',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'methodParamField',
				minChars : 1,
				// mode : 'local', // 本地模式
				pageSize : 10,
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var paramOrderField = new Ext.form.TextField({
				id : 'paramOrderField',
				fieldLabel : '顺序号',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : '方法编码',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : '方法名称',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var defalutValueField = new Ext.form.TextField({
				id : 'defalutValueField',
				fieldLabel : '默认值',
				allowBlank : true,
				emptyText : '',
				disableKeyFilter :true, 
				anchor : '90%'
			});
	var paramDescField = new Ext.form.TextField({
				id : 'paramDescField',
				fieldLabel : '格式说明',
				allowBlank : true,
				disabled : true,
				emptyText : '',
				anchor : '90%'
			});

	var paramDesc = new Ext.form.Label({
				id : 'paramDesc',
				name : 'paramDesc',
				text : '格式说明：'
			})
	methodParamField.on('select', function(combo, record, index) {
				// 年度
				if (combo.getValue() == '101') {
					paramDescField.setValue('如 2011')
					return;
				}
				// 核算期间
				if (combo.getValue() == '102') {
					paramDescField.setValue('月：M01、季度：Q01、半年：H01、年度：Y01')
					return;
				}
				// 开始时间
				if (combo.getValue() == '103') {
					paramDescField.setValue('xxxx年xx月xx日')
					return;
				}
				// 结束时间
				if (combo.getValue() == '104') {
					paramDescField.setValue('xxxx年xx月xx日')
					return;
				}
				// 固定科室
				if (combo.getValue() == '105') {
					paramDescField.setValue('科室编码1^科室编码2^科室编码3...')
					return;
				}
				// 方案科室
				if (combo.getValue() == '106') {
					paramDescField.setValue('方案编码1^方案编码2^方案编码3...')
					return;
				}// 固定人员
				if (combo.getValue() == '107') {
					paramDescField.setValue('人员编码1^人员编码2^人员编码3...')
					return;
				}// 方案人员
				if (combo.getValue() == '108') {
					paramDescField.setValue('方案编码1^方案编码2^方案编码3...')
					return;
				}// 固定指标
				if (combo.getValue() == '109') {
					paramDescField.setValue('指标编码1^指标编码2^指标编码3...')
					return;
				}// 方案指标
				if (combo.getValue() == '110') {
					paramDescField.setValue('方案编码1^方案编码2^方案编码3...')
					return;
				}
			})
	// create form panel
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [paramOrderField, methodParamField, defalutValueField,
						paramDescField]
			});

	// define window and show it in desktop
	var window = new Ext.Window({
		title : '添加接口方法参数',
		width : 380,
		height : 220,
		minWidth : 380,
		minHeight : 320,
		layout : 'fit',
		plain : true,
		modal : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		items : formPanel,
		buttons : [{
			text : '保存',
			handler : function() {

				var methodParam = methodParamField.getValue();
				var paramOrder = paramOrderField.getValue();
				var defalutValue = defalutValueField.getValue();
				var interMethodDr = rowObj[0].get("rowid")

				defalutValue = defalutValue.trim();
				methodParam = methodParam.trim();
				paramOrder = paramOrder.trim();
				var data = interMethodDr + '~' + methodParam + '~'
						+ defalutValue + '~' + paramOrder;
				if (paramOrder == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '顺序号不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (methodParam > 104) {

					if (defalutValue == "") {
						Ext.Msg.show({
									title : '错误',
									msg : '默认值不能为空！',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						return;
					};
				}

				if (methodParam == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '参数值不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};

				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
								url : InterLocUrl + '?action=addParam&data='
										+ data,
								failure : function(result, request) {
									Ext.Msg.show({
												title : '提示',
												msg : '错误',
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
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										dataStore.load({
													params : {
														start : 0,
														limit : pagingTool.pageSize
													}
												});
										// window.close();
									} else {
										var message = "";
										message = "SQLErr: " + jsonData.info;
										if (jsonData.info == 'EmptyRecData')
											message = '数据为空!';
										if (jsonData.info == 'RepCode')
											message = '代码不能重复!';
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
				} else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误后提交。',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}
			}
		}, {
			text : '取消',
			handler : function() {
				window.close();
			}
		}]
	});

	window.show();
};