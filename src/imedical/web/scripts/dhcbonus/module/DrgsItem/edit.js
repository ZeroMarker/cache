// 修改函数
updateFun = function(node) {
 
var SuperDargID = node.attributes.SuperID;
var Rowids = node.attributes.id;
	if (node == null) {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		if (node.attributes.id == "roo") {
			Ext.Msg.show({
						title : '提示',
						msg : '根节点不允许被修改!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {		
//Drag项目下拉框
var DragDataStor  = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'Code','Name'])
		});

DragDataStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:'../csp/dhc.bonus.drgsitemexe.csp?action=GetDrag&str='+DragFiled.getValue()+'&rowid='+Rowids,
	method : 'POST'
					})
});


var DragFiled = new Ext.form.ComboBox({
    id:'DragFiled',
	fieldLabel:'上级项目',
	width:125,
	listWidth:205,
	anchor : '90%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'Name',
	store : DragDataStor,
	triggerAction : 'all',
	name : 'DragFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	listeners: {	//监听事件
		select:function(){
		SuperDargID = DragFiled.getValue();
		}
	 },
	editable : true
});
			

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
										CMI.focus();
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

		var CMI = new Ext.form.TextField({
						id : 'CMI',
						fieldLabel : 'CMI值',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (CMI.getValue() != "") {
										CostRate.focus();
									} else {
										Handler = function() {
											CMI.focus();
										}
										Ext.Msg.show({
													title : '错误',
													msg : 'CMI值不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
		   //费用系数
			var CostRate = new Ext.form.TextField({
						id : 'CostRate',
						fieldLabel : '费用系数',
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
													msg : '费用系数不能为空!',
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
						items :[codeField, nameField,DragFiled,CMI,CostRate,isEndField]
					});

			formPanel.on('afterlayout', function(panel, layout) {
						this.getForm().loadRecord(node);
						//alert(node.attributes.Name);
						codeField.setValue(node.attributes.Code);
						nameField.setValue(node.attributes.Name);
						CMI.setValue(node.attributes.Cmi);
						CostRate.setValue(node.attributes.Rate);
						isEndField.setValue(node.attributes.IsLast);
						DragFiled.setValue(node.attributes.SuperName);
					});

			editButton = new Ext.Toolbar.Button({
						text : '修改'
					});

			editHandler = function() {
            
			    var code = codeField.getValue();
				var name = nameField.getValue();
                var cmi  = CMI.getValue();
				var rate = CostRate.getValue();
				var isEnd = (isEndField.getValue() == true) ? '1' : '0';
		
				name = trim(name);
				code = trim(code);
				if (code == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '项目码为空!',
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

				if (cmi == "") {
					Ext.Msg.show({
								title : '提示',
								msg : 'cmi为空!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (rate == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '费用系数!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				var data = code+"^"+name+"^"+cmi+"^"+rate+"^"+isEnd+"^"+SuperDargID+"^"+Rowids;

				Ext.Ajax.request({
							url : '../csp/dhc.bonus.drgsitemexe.csp?action=edit&data='
									+ data,
							waitMsg : '修改中...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接?',
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
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									if (node.attributes.SupCode == 0) {
										node.attributes.SuperID = "roo";
									}
									Ext.getCmp('detailReport').getNodeById(node.attributes.SuperID).reload();
									window.close();
								} else {
									var message = jsonData.info;
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
									else if (jsonData.info == 'RepName') {
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
									else{
  									   Ext.Msg.show({
												title : '错误',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
										}
								
								}
							},
							scope : this
						});
			};

			editButton.addListener('click', editHandler, false);

			cancel = new Ext.Toolbar.Button({
						text : '退出'
					});

			cancelHandler1 = function() {
				window.close();
			}

			cancel.addListener('click', cancelHandler1, false);

			var window = new Ext.Window({
						title : '修改奖金单元记录',
					    width : 395,
						height : 255,
						minWidth : 395,
						minHeight : 255,
						layout : 'fit',
						plain : true,
						modal : true,
						bodyStyle : 'padding:5px;',
						buttonAlign : 'center',
						items : formPanel,
						buttons : [editButton, cancel]
					});
			window.show();
		}
	}
};