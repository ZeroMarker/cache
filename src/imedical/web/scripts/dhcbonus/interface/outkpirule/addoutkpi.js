function trim(str) {
	var tmp = str.replace(/(^\s*)|(\s*$)/g, "");
	return tmp;
}
addFun = function(locSetDr, outKpiDs, LocSetGrid, outKpiPagingToolbar) {
var rowObj = LocSetGrid.getSelections();
var schemeID= rowObj[0].get('rowid')
//alert(schemeID)

	var codeField = new Ext.form.TextField({
				id : 'codeField',
				fieldLabel : '指标代码',
				allowBlank : false,
				width : 150,
				listWidth : 150,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (codeField.getValue() != "") {
								nameField.focus();
							} else {
								Handler = function() {
									codeField.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '代码不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});

	var nameField = new Ext.form.TextField({
				id : 'nameField',
				fieldLabel : '指标名称',
				allowBlank : true,
				width : 180,
				listWidth : 180,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true',
				listeners : {
					specialKey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if (nameField.getValue() != "") {
								addButton.focus();
							} else {
								Handler = function() {
									nameField.focus();
								}
								Ext.Msg.show({
											title : '提示',
											msg : '名称不能为空!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO,
											fn : Handler
										});
							}
						}
					}
				}
			});
	var orderField = new Ext.form.NumberField({
				id : 'orderField',
				fieldLabel : '取值位置',
				allowBlank : true,
				width : 150,
				listWidth : 150,
				emptyText : '',
				anchor : '90%',
				selectOnFocus : 'true'
				
			});
	var interMethodDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});

	interMethodDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.intermethodexe.csp?action=InterMethod&interLocSetDr='+schemeID,
							method : 'POST'
						})
			});

	var interMethodField = new Ext.form.ComboBox({
				id : 'interMethodField',
				fieldLabel : '接口方法',
				allowBlank : false,
				store : interMethodDs,
				valueField : 'rowid',
				displayField : 'name',
				triggerAction : 'all',
				emptyText : '',
				name : 'interMethodField',
				minChars : 1,
				// mode : 'local', // 本地模式
				pageSize : 10,
				anchor : '90%',
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
	var formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				labelWidth : 100,
				items : [codeField, nameField,interMethodField,orderField]
			});

	var addButton = new Ext.Toolbar.Button({
				text : '添加'
			});

	// 添加处理函数
	var addHandler = function() {
		var code = Ext.getCmp('codeField').getValue();
		var name = Ext.getCmp('nameField').getValue();
		var interMethodDr = Ext.getCmp('interMethodField').getValue();
		var order = Ext.getCmp('orderField').getValue();
		
		code = trim(code);
		name = trim(name);
		if (code == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '代码为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		};
		if (name == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '名称为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		};

		Ext.Ajax.request({
					url : 'dhc.bonus.outkpiruleexe.csp?action=add&locSetDr='
							+ locSetDr + '&code=' + code + '&name=' + (name)
							+ '&interMethodDr=' + interMethodDr+ '&order=' + order,
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
							outKpiDs.load({
										params : {
											start : 0,
											limit : outKpiPagingToolbar.pageSize,
											locSetDr : locSetDr,
											dir : 'asc',
											sort : 'rowid'
										}
									});
						} else {
							if (jsonData.info == 'RepRecode') {
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
				title : '添加奖金指标',
				width : 380,
				height : 200,
				minWidth : 380,
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