// 添加函数
addFun = function(node) {
	if (node != null) {
		var end = node.attributes.lastStage;
		if (end == 1) {
			Ext.Msg.show({
						title : '提示',
						msg : '末端不能添加子节点!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// 非末端节点,允许添加

			var codeField = new Ext.form.TextField({
						id : 'codeField',
						fieldLabel : '项目代码',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									nameField.focus();
								}
							}
						}
					});

			var nameField = new Ext.form.TextField({
						id : 'nameField',
						fieldLabel : '项目名称',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (nameField.getValue() != "") {
										pyField.focus();
									} else {
										Handler = function() {
											nameField.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : '项目名称不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
				

			var itemTypeStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['1', '收入项目'], ['2', '工作量项目'], ['3', '支出项目']]
					});
			var itemTypeField = new Ext.form.ComboBox({
						id : 'itemTypeField',
						fieldLabel : '项目属性',
						width : 275,
						listWidth : 275,
						selectOnFocus : true,
						allowBlank : false,
						store : itemTypeStore,
						anchor : '90%',
						value : '1', // 默认值
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
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (itemTypeField.getValue() != "") {
										unitTypeField.focus();
									} else {
										Handler = function() {
											itemTypeField.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : '项目属性不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});

		

			

			var isEndField = new Ext.form.Checkbox({
						id : 'isEndField',
						labelSeparator : '末端标志:',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addButton.focus();
								}
							}
						}
					});

				formPanel = new Ext.form.FormPanel({
						baseCls : 'x-plain',
						labelWidth : 70,
						items : [

								codeField, nameField, itemTypeField,isEndField]
					});
			// 定义添加按钮
			var addButton = new Ext.Toolbar.Button({
						text : '添加'
					});

			// 添加处理函数
			var addHandler = function() {
				var code = codeField.getValue();
				var name = nameField.getValue();

				//var py = pyField.getValue();
				var type = itemTypeField.getValue();
				//var typeDr = unitTypeField.getValue();

				var isEnd = (isEndField.getValue() == true) ? '1' : '0';
				
				var parent = 0;
				//var level = 0;
				if (node.attributes.id != "roo") {
					parent = node.attributes.id;
					//level = node.attributes.level;
				}
				
				

				name = trim(name);
				code = trim(code);
				//py = trim(py);

			 //alert(parent);
				if (code == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '项目代码为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '项目名称为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};

				
//encodeURIComponent encodeURI
				var url = '../csp/dhc.bonus.bonussubitemexe.csp?action=add&code='
									+ code
									+ '&name='
									+ (name)
									+ '&itemType='
									+ type
									+ '&lastStage='
									+ isEnd
									+ '&parent=' + parent ;

			   //alert(url);
									

				// code,name,spell,itemType,unitType,lastStage,parent, level
				Ext.Ajax.request({
							url : Ext.util.Format.htmlDecode(url),
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
									Ext.getCmp('detailReport')
											.getNodeById(node.attributes.id)
											.reload();
									// win.close();
								} else {

									if (jsonData.info == 'RepCode') {
										Handler = function() {
											codeField.focus();
										}
										Ext.Msg.show({
													title : '提示',
													msg : '代码重复!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
									if (jsonData.info == 'RepName') {
										Handler = function() {
											nameField.focus();
										}
										Ext.Msg.show({
													title : '提示',
													msg : '名称重复!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}

									if (jsonData.info == 'null') {
										Handler = function() {
											nameField.focus();
										}
										Ext.Msg.show({
													title : '提示',
													msg : '你以前添加过错误数据,没有上级节点ID!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
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
						title : '添加项目记录',
						width : 415,
						height : 235,
						minWidth : 415,
						minHeight : 335,
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
	} else {
		Ext.Msg.show({
					title : '错误',
					msg : '请选择要添加子节点的记录！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
	}
};