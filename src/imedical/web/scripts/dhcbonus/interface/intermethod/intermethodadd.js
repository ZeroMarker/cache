addInterLocFun = function(dataStore, grid, pagingTool) {

	if (interLocSetField.getValue() == "") {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择接口套',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
		return false;
	}
	var jxUnitDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'code', 'name', 'shortcut'])
			});

	jxUnitDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : InterLocUrl + '?action=getjxunit',
							method : 'POST'
						})
			});

	var returnStore = new Ext.data.SimpleStore({
				fields : ['key', 'keyValue'],
				data : [['201', '标准Global'], ['202', '扩展Global'],['203', '收入Global'], ['204', '支出工作量Global']]
			});
	var returnTypeField = new Ext.form.ComboBox({
				id : 'returnTypeField',
				fieldLabel : '返回类型',
				allowBlank : false,
				store : returnStore,
				valueField : 'key',
				displayField : 'keyValue',
				triggerAction : 'all',
				emptyText : '',
				name : 'returnTypeField',
				minChars : 1,
				mode : 'local', // 本地模式
				pageSize : 10,
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});

	var orderField = new Ext.form.TextField({
				id : 'orderField',
				fieldLabel : '顺序号',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});
	var descField = new Ext.form.TextArea({
		id : 'descField',
		fieldLabel : '接口格式',
		allowBlank : false,
		height:200,
		emptyText : 'class(M类名称).类方法(开始日期，结束日期，接口方案ID); //日期格式=YYYY-MM-DD',
		disabled : true,
		anchor : '90%'
	})
	/*  class(dhc.bonus.uinter.uGetYWSRgdj).GetYWData
	returnTypeField.on('select', function(cmb, rd, index) {
				if (cmb.getValue() == "201") {
					descField.setValue('单元编码^单元名称^指标编码^指标名称^指标值')
					return;

				}
				if (cmb.getValue() == "202") {
					descField.setValue('单元编码^单元名称^指标值1^指标值2^指标值3...^指标值n')
					return;

				}
				if (cmb.getValue() == "203") {
					descField.setValue('^dhcbsSubIncomeDactaTemp（"自定义节点"，num） =项目编码^项目名称^核算年度^核算期间^开单科室编码^开单科室名称^执行科室编码^执行科室名称^病人科室编码^病人科室名称^主治医编码^主治医名称^开单医师编码^开单医师名称^执行医师编码^执行医师名称^患者类别^费用类别^项目金额')
					return;

				}
				if (cmb.getValue() == "204") {
					descField.setValue('单元编码^单元名称^指标值1^指标值2^指标值3...^指标值n')
					return;

				}
			})
			*/
	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : '方法名称',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : '方法类名',
				allowBlank : false,
				emptyText : '',
				anchor : '90%'
			});

	var returnField = new Ext.form.TextField({
				id : 'returnField',
				fieldLabel : '备注说明',
				allowBlank : true,
				emptyText : '',
				anchor : '90%'
			});

	// create form panel， returnTypeField,
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 80,
				items : [orderField, codeField, nameField, 
						returnField, descField]
			});

	// define window and show it in desktop  
	var window = new Ext.Window({
		title : '添加接口方法',
		width : 450,
		height : 320,
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

				var returnType = returnTypeField.getValue();
				var order = orderField.getValue();
				var code = codeField.getValue();
				var name = nameField.getValue();
				var returName = returnField.getValue();
				code = code.trim();
				name = name.trim();
				returName = returName.trim();
				returnType = returnType.trim();
				order = order.trim();
				var data = encodeURIComponent(order) + '~' + interLocSetField.getValue() + '~'
						+ code + '~' + name + '~' + returnType + '~'
						+ returName;

				// prompt('data',data)
					if (order == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '顺序号不能为空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};		
				if (code == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '方法代码不能空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '方法名称不能空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				/*if (returnType == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '返回类型不能空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};
				
				if (returName == "") {
					Ext.Msg.show({
								title : '错误',
								msg : '返回值不能空',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				};*/

				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
								url : InterLocUrl + '?action=add&data=' + data,
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
										if (jsonData.info == 'RepOrder')
											message = '顺序号不能重复!';
										if (jsonData.info == 'RepDesc')
											message = '方法名称不能重复!';
										if (jsonData.info == 'RepName')
											message = '方法类名不能重复!';
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