// �޸ĺ���
updateFun = function(node) {
 
var SuperDargID = node.attributes.SuperID;
var Rowids = node.attributes.id;
	if (node == null) {
		Ext.Msg.show({
					title : '��ʾ',
					msg : '��ѡ��Ҫ�޸ĵ�����!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		if (node.attributes.id == "roo") {
			Ext.Msg.show({
						title : '��ʾ',
						msg : '���ڵ㲻�����޸�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {		
//Drag��Ŀ������
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
	fieldLabel:'�ϼ���Ŀ',
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
	listeners: {	//�����¼�
		select:function(){
		SuperDargID = DragFiled.getValue();
		}
	 },
	editable : true
});
			

var codeField = new Ext.form.TextField({
						id : 'codeField',
						fieldLabel : '��Ŀ����',
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
						fieldLabel : '��Ŀ����',
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
													title : '����',
													msg : '��Ŀ���Ʋ���Ϊ��!',
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
						fieldLabel : 'CMIֵ',
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
													title : '����',
													msg : 'CMIֵ����Ϊ��!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
		   //����ϵ��
			var CostRate = new Ext.form.TextField({
						id : 'CostRate',
						fieldLabel : '����ϵ��',
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
													title : '����',
													msg : '����ϵ������Ϊ��!',
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
						labelSeparator : 'ĩ�˱�־:',
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
						text : '�޸�'
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
								title : '��ʾ',
								msg : '��Ŀ��Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (name == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '��Ŀ����Ϊ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};

				if (cmi == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : 'cmiΪ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				if (rate == "") {
					Ext.Msg.show({
								title : '��ʾ',
								msg : '����ϵ��!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return false;
				};
				var data = code+"^"+name+"^"+cmi+"^"+rate+"^"+isEnd+"^"+SuperDargID+"^"+Rowids;

				Ext.Ajax.request({
							url : '../csp/dhc.bonus.drgsitemexe.csp?action=edit&data='
									+ data,
							waitMsg : '�޸���...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������?',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
												title : '��ʾ',
												msg : '�޸ĳɹ�!',
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
													title : '��ʾ',
													msg : '�����ظ�!',
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
													title : '��ʾ',
													msg : '�����ظ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
									else{
  									   Ext.Msg.show({
												title : '����',
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
						text : '�˳�'
					});

			cancelHandler1 = function() {
				window.close();
			}

			cancel.addListener('click', cancelHandler1, false);

			var window = new Ext.Window({
						title : '�޸Ľ���Ԫ��¼',
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