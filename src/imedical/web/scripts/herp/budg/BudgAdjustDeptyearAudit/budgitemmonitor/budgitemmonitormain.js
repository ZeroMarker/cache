var mainUrl = '../csp/herp.budg.budgitemmonitorexe.csp?action=list';
var tmpNode = "";
var tmpYear="";
var tmpCode="";
var Code = "";
var Year = "";
var checkActive = new Ext.form.Checkbox({
	fieldLabel : '�Ƿ���Ч'
});
// ֧������
var ctrlitembutton = new Ext.Toolbar.Button(
		{
			text : '֧������',
			tooltip : '֧������',
			iconCls : 'option',
			handler : function() {
				if(tmpNode!=""){
					var isBatch;
					var tmpYear;
					var tmpCode;
					var tmpIsActive=tmpNode.attributes["Active"];
				}
			
				//�����Ƿ�ѡ��ڵ����ж��Ƿ���������
			
					var YearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, [ 'key', 'value' ])
					});

					YearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/herp.budg.budgitemmonitorexe.csp?action=yearList',
							method : 'POST'
						});
					});

					var yearCombo = new Ext.form.ComboBox({
						fieldLabel : 'Ԥ�����',
						store : YearDs,
						displayField : 'value',
						valueField : 'key',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText:'ѡ�����...',
						//anchor: '95%',
						width:180,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						columnWidth : 0.5,
						selectOnFocus : true
					});
					
					// ////////////��������////////////////////////
var itemtypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['code', 'name'])
		});

itemtypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.budg.budgitemmonitorexe.csp?action=listType',method : 'POST'});
		});

var itemtypecomb = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ���',
			store : itemtypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 180,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});

					
 
					var IsActiveField = new Ext.form.Checkbox({
						checked : tmpIsActive,
						fieldLabel : '֧������'
					});
					if(tmpNode == ""){
						isBatch=true;
						yearCombo.enable();
					
					
						itemtypecomb.enable();
									
					}else{
						isBatch=false;
						tmpYear = tmpNode.attributes["Year"];
						tmpCode = tmpNode.attributes["Code"];
						tmpIsActive = tmpNode.attributes["Active"];
						if (tmpIsActive == 'Y') {
							tmpIsActive = true;
						} else {
							tmpIsActive = false;
						}
						yearCombo.disable();
						yearCombo.setValue("");
						itemtypecomb.disable();
						itemtypecomb.setValue("");

					}
					
					
					
					//����ѡ���
					var IsBatchField = new Ext.form.Checkbox({
						checked : isBatch,
						fieldLabel : '�Ƿ�����'
						
					});
					IsBatchField.on('check', function( c , checked ){
						if(checked){
							yearCombo.enable();
							itemtypecomb.enable();
							isBatch=true;
						
						}else{
							isBatch=false;
							yearCombo.disable();
							yearCombo.setValue("");
							itemtypecomb.disable();
							itemtypecomb.setValue("");
						}
					});
				
					var colItems = [ {
						layout : 'column',
						border : false,
						defaults : {
							columnWidth : '1',
							bodyStyle : 'padding:5px 5px 0',
							border : false
						},
						items : [ {
							xtype : 'fieldset',
							autoHeight : true,
							items : [

							IsActiveField,
							IsBatchField,
							yearCombo,
							itemtypecomb
							]
						}
						]
					} ];

					var formPanel = new Ext.form.FormPanel({
						// baseCls: 'x-plain',
						labelWidth : 100,
						// layout: 'form',
						frame : true,
						items : colItems
					});

					ctrlitembutton = new Ext.Toolbar.Button({
						text : '֧������'
					});

					addHandler = function() {

						var Active = IsActiveField.getValue();
						
						if (Active) {
							Active = 1;
						} else {
							Active = 0;
						}
						
						
						
					
						var budgyear=yearCombo.getValue();
						var itemtype=itemtypecomb.getValue();
						var isbatch=IsBatchField.getValue();
						
						if(tmpNode == ""&&isbatch==false){

							Ext.Msg.show({
								title : '����',
								msg : '��ѡ����ڵ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
							
						}else if(isbatch==true&&!(budgyear&&itemtype)){
							Ext.Msg.show({
								title : '����',
								msg : '��ѡ����Ȼ���Ŀ����!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
						}
						else{
						if (formPanel.form.isValid()) {
						

							Ext.Ajax
									.request({
										//�˴����õķ�����������һ����
										url : '../csp/herp.budg.budgitemmonitorexe.csp?action=ctrl&Code='
												+ tmpCode
												+ '&Year='
												+ tmpYear
												+ '&Active=' + Active+'&isbatch='+isbatch+'&budgyear='+budgyear+'&itemtype='+itemtype,
										waitMsg : '������...',
										failure : function(result, request) {
											Ext.Msg.show({
												title : '����',
												msg : '������������!',
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
										
												if(isbatch==true){
													mainGrid.root.reload();
													}else{
												if (tmpNode.attributes.parent == 0) {
													tmpNode.attributes.parent = "roo";
												}

												
												// alert(Ext.getCmp('itemGrid').getNodeById(tmpNode.attributes.id).parentNode.text)
												mainGrid
														.getNodeById(tmpNode.attributes.id).parentNode
														.reload();
													}

											} else {
											
												var message = "";
												if (jsonData.info == 'RepCode')
													message = '����ı����Ѿ�����!';
												if (jsonData.info == 'NoName')
													message = '�Ѿ���֧������!';
												if (jsonData.info == 'RepName')
													message = '�Ѿ�֧������!';
												if (jsonData.info == 'fail')
													message = '���浽��Ӧ����ʧ��!';
												Ext.Msg.show({
													title : '����',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
											}
											editwin.close();
										},
										scope : this
									});
						} else {
							Ext.Msg.show({
								title : '����',
								msg : '������ҳ���ϵĴ���!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}
					}
					}

					ctrlitembutton.addListener('click', addHandler, false);

					cancelButton = new Ext.Toolbar.Button({
						text : 'ȡ��'
					});

					cancelHandler = function() {
						editwin.close();
					}

					cancelButton.addListener('click', cancelHandler, false);

					editwin = new Ext.Window({
						title : '֧������',
						width : 500,
						height : 280,
						// autoHeight: true,
						layout : 'fit',
						plain : true,
						modal : true,
						bodyStyle : 'padding:5px;',
						buttonAlign : 'center',
						items : formPanel,
						buttons : [ ctrlitembutton, cancelButton ]
					});

					editwin.show();

				
			}
		});

var addButton = new Ext.Toolbar.Button(
		{
			text : '���',
			tooltip : '���',
			iconCls : 'add',
			handler : function() {

				var tmpCode = "";

				tmpCode = tmpNode.attributes["Code"];
				tmpYear = tmpNode.attributes["Year"];

				var TypeField = new Ext.form.ComboBox({
					fieldLabel : 'ȫԺ����',
					width : 180,
					anchor : '95%',
					store : new Ext.data.ArrayStore({
						fields : [ 'rowid', 'name' ],
						data : [ [ '1', 'ȫԺ' ], [ '2', '����' ] ]
					}),
					displayField : 'name',
					valueField : 'rowid',
					typeAhead : true,
					mode : 'local',
					value : '1',
					forceSelection : true,
					triggerAction : 'all',
					emptyText : 'ѡ��...',
					selectOnFocus : 'true'
				});
				// ͼ��
				var GraphField = new Ext.form.ComboBox({
					fieldLabel : 'ͼ��',
					width : 180,
					anchor : '95%',
					store : new Ext.data.ArrayStore({
						fields : [ 'rowid', 'name' ],
						data : [ [ '1', '��ͼ' ], [ '2', '�Ǳ���' ] ]
					}),
					displayField : 'name',
					valueField : 'rowid',
					typeAhead : true,
					mode : 'local',
					value : '1',
					forceSelection : true,
					triggerAction : 'all',
					emptyText : 'ѡ��...',
					selectOnFocus : 'true'
				});

				var colItems = [ {
					layout : 'column',
					border : false,
					defaults : {
						columnWidth : '.5',
						bodyStyle : 'padding:5px 5px 0',
						border : false
					},
					items : [ {
						xtype : 'fieldset',
						autoHeight : true,
						items : [

						TypeField ]
					}, {
						xtype : 'fieldset',
						autoHeight : true,
						items : [

						GraphField ]
					} ]
				} ];

				var formPanel = new Ext.form.FormPanel({
					// baseCls: 'x-plain',
					labelWidth : 70,
					// layout: 'form',
					frame : true,
					items : colItems
				});

				addButton = new Ext.Toolbar.Button({
					text : '���'
				});

				addHandler = function() {

					var Graph = GraphField.getValue();
					var Type = TypeField.getValue();

					// var data =
					// CompDR+"|"+Year+"|"+Code+"|"+tmpCode+"|"+Name+"|"+NameAll+"|"+tmpLevel+"|"+TypeCodeFirst+"|"+TypeCode+"|"+Spell+"|"+Direction+"|"+IsLast+"|"+IsSpecial+"|"+SubjClassMT+"|"+SubjClassPay+"|"+IsCash+"|"+SubjClassCostType+"|"+UseRange+"|"+IdxType+"|"+EditMod+"|"+EditMeth+"|"+IsCarry+"|"+ProperyType+"|"+IsCalc+"|"+Formula+"|"+FormulaDesc+"|"+IsResult+"|"+CalUnit
					var data = tmpCode + "|" + Type + "|" + Graph + "|"
							+ tmpYear;

					if (formPanel.form.isValid()) {
						Ext.Ajax
								.request({
									url : '../csp/herp.budg.budgitemmonitorexe.csp?action=add&data='
											+ encodeURIComponent(data),
									waitMsg : '������...',
									failure : function(result, request) {
										Ext.Msg.show({
											title : '����',
											msg : '������������!',
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
												msg : '��ӳɹ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});

											if (tmpNode.attributes.parent == 0) {
												tmpNode.attributes.parent = "roo";
											}

											// alert(tmpNode.attributes.id);
											// alert(Ext.getCmp('itemGrid').getNodeById(tmpNode.attributes.id).parentNode.text)
											mainGrid
													.getNodeById(tmpNode.attributes.id).parentNode
													.reload();

										} else {
											var message = "";
											if (jsonData.info == 'RepCode')
												message = '�������Ϣ�Ѿ�����!';
											if (jsonData.info == 'RepName')
												message = '����������Ѿ�����!';
											if (jsonData.info == 'fail')
												message = '���浽��Ӧ����ʧ��!';
											Ext.Msg.show({
												title : '����',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
										}
										addwin.close();
									},
									scope : this
								});
					} else {
						Ext.Msg.show({
							title : '����',
							msg : '������ҳ���ϵĴ���!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					}
				};

				addButton.addListener('click', addHandler, false);

				cancelButton = new Ext.Toolbar.Button({
					text : 'ȡ��'
				});

				cancelHandler = function() {
					addwin.close();
				};

				cancelButton.addListener('click', cancelHandler, false);

				addwin = new Ext.Window({
					title : '���Ԥ����',
					width : 500,
					height : 130,
					// autoHeight: true,
					atLoad : true,
					layout : 'fit',
					plain : true,
					modal : true,
					bodyStyle : 'padding:5px;',
					buttonAlign : 'center',
					items : formPanel,
					buttons : [ addButton, cancelButton ]
				});

				addwin.show();

				// }

			}
		});

var editButton = new Ext.Toolbar.Button(
		{
			text : '�޸�',
			tooltip : '�޸�',
			iconCls : 'option',
			handler : function() {
				
					

				if(tmpNode!=""){
					var isBatch;
					
					var tmpCode = tmpNode.attributes["Code"];
					var tmpType = tmpNode.attributes["Type"];
					var tmpGraph = tmpNode.attributes["Graph"];
					var tmpYear = tmpNode.attributes["Year"];
			
				}	
					
					//�����Ƿ�ѡ��ڵ����ж��Ƿ���������
					
					var YearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, [ 'key', 'value' ])
					});

					YearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
							url : '../csp/herp.budg.budgitemmonitorexe.csp?action=yearList',
							method : 'POST'
						});
					});

					var yearCombo = new Ext.form.ComboBox({
						fieldLabel : 'Ԥ�����',
						store : YearDs,
						displayField : 'value',
						valueField : 'key',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText:'ѡ�����...',
						
						anchor: '95%',
						width:180,
						listWidth : 90,
						pageSize : 10,
						minChars : 1,
						columnWidth : 0.5,
						selectOnFocus : true
					});
					
					var itemtype = new Ext.data.SimpleStore({
						fields:['key','value'],
						data:[['01','����'],['02','֧��']]
					});
					var itemtypecomb = new Ext.form.ComboBox({
						id: 'itemtype',
						fieldLabel: '��Ŀ����',
						width:180,
						listWidth : 90,
						store: itemtype,
						anchor: '95%',
						valueNotFoundText:'',
						displayField: 'value',
						valueField: 'key',
						triggerAction: 'all',
						emptyText:'ѡ����Ŀ����...',
						mode: 'local', //����ģʽ
						editable:false,
						pageSize: 10,
						minChars: 1

					});
					
					if(tmpNode == ""){
						isBatch=true;
						yearCombo.enable();
					
					
						itemtypecomb.enable();
									
					}else{
						isBatch=false;
						tmpYear = tmpNode.attributes["Year"];
						tmpCode = tmpNode.attributes["Code"];
				
						yearCombo.disable();
						yearCombo.setValue("");
						itemtypecomb.disable();
						itemtypecomb.setValue("");

					}

					//����ѡ���
					var IsBatchField = new Ext.form.Checkbox({
						checked : isBatch,
						fieldLabel : '�Ƿ�����'
						
					});
					IsBatchField.on('check', function( c , checked ){
						if(checked){
							yearCombo.enable();
							itemtypecomb.enable();
							isBatch=true;
						
						}else{
							isBatch=false;
							yearCombo.disable();
							yearCombo.setValue("");
							itemtypecomb.disable();
							itemtypecomb.setValue("");
						}
					});
					
					var TypeField = new Ext.form.ComboBox({
						fieldLabel : 'ȫԺ����',
						width : 180,
						anchor : '95%',
						store : new Ext.data.ArrayStore({
							fields : [ 'rowid', 'name' ],
							data : [ [ '1', 'ȫԺ' ], [ '2', '����' ] ]
						}),
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						mode : 'local',
						value : tmpType,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : 'ѡ��...',
						selectOnFocus : 'true'
					});
					// ͼ��
					var GraphField = new Ext.form.ComboBox({
						fieldLabel : 'ͼ��',
						width : 180,
						anchor : '95%',
						store : new Ext.data.ArrayStore({
							fields : [ 'rowid', 'name' ],
							data : [ [ '1', '��ͼ' ], [ '2', '�Ǳ���' ] ]
						}),
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						mode : 'local',
						value : tmpGraph,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : 'ѡ��...',
						selectOnFocus : 'true'
					});

					var colItems = [ {
						layout : 'column',
						border : false,
						defaults : {
							columnWidth : '1',
							bodyStyle : 'padding:5px 5px 0',
							border : false
						},
						items : [ {
							xtype : 'fieldset',
							autoHeight : true,
							items : [IsBatchField,
							         TypeField,
							          GraphField,
							          yearCombo,
							          itemtypecomb]
						}]
					} ];

					var formPanel = new Ext.form.FormPanel({
						// baseCls: 'x-plain',
						labelWidth : 70,
						// layout: 'form',
						frame : true,
						items : colItems
					});

					editButton = new Ext.Toolbar.Button({
						text : '�޸�'
					});

					editHandler = function() {

						var Type = TypeField.getValue();
						if (Type == 'ȫԺ') {
							Type = 1;
						} 
						if (Type == '����') {
							Type = 2;
						}
						var Graph = GraphField.getValue();
						if (Graph == '��ͼ') {
							Graph = 1;
						} 
						if (Graph == '�Ǳ���') {
							Graph = 2;
						}

						var budgyear=yearCombo.getValue();
						var itemtype=itemtypecomb.getValue();
						var isbatch=IsBatchField.getValue();
						
						var data = tmpCode + "|" + Type + "|" + Graph + "|"
								+ tmpYear + "|" + budgyear+ "|" + itemtype+ "|" + isbatch;
						if(tmpNode == ""&&isbatch==false){

							Ext.Msg.show({
								title : '����',
								msg : '��ѡ����ڵ�!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
							
						}else if(isbatch==true&&!(budgyear&&itemtype)){
							
							Ext.Msg.show({
								title : '����',
								msg : '��ѡ����Ȼ���Ŀ����!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
						}
						else{
						
						if (formPanel.form.isValid()) {
							
							Ext.Ajax
									.request({
										url : '../csp/herp.budg.budgitemmonitorexe.csp?action=edit&data='
												+ encodeURIComponent(data),

										waitMsg : '������...',
										failure : function(result, request) {
										
											Ext.Msg.show({
												title : '����',
												msg : '������������!',
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
												
												if(isbatch==true){
												
													editwin.close();
													mainGrid.root.reload();
													}else{
												
												if (tmpNode.attributes.parent == 0) {
													tmpNode.attributes.parent = "roo";
												}

												// alert(node.attributes.id);
												// alert(Ext.getCmp('itemGrid').getNodeById(node.attributes.id).parentNode.text)

												mainGrid
														.getNodeById(tmpNode.attributes.id).parentNode
														.reload();
												editwin.close();
												
													}
											} else {

												var message = "����ʧ��";
												if (jsonData.info == 'RepCode')
													message = '����������Ѿ�����!';
												if (jsonData.info == 'RepName')
													message = '����������Ѿ�����!';
												if (jsonData.info == 'fail')
													message = '���浽��Ӧ����ʧ��!';
												Ext.Msg.show({
													title : '����',
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
								title : '����',
								msg : '������ҳ���ϵĴ���!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}
						}
					};

					editButton.addListener('click', editHandler, false);

					cancelButton = new Ext.Toolbar.Button({
						text : 'ȡ��'
					});

					cancelHandler = function() {
						editwin.close();
					};

					cancelButton.addListener('click', cancelHandler, false);

					editwin = new Ext.Window({
						title : '�޸�Ԥ����',
						width : 500,
						height : 280,
						// autoHeight: true,
						layout : 'fit',
						plain : true,
						modal : true,
						bodyStyle : 'padding:5px;',
						buttonAlign : 'center',
						items : formPanel,
						buttons : [ editButton, cancelButton ]
					});

					editwin.show();

				
			}
		});

var delButton = new Ext.Toolbar.Button(
		{
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'remove',
			handler : function() {
				// var tmpRowid = "";
				var tmpLeaf = "";
				if (tmpNode != "") {
					tmpRowid = tmpNode.attributes["Rowid"];
					tmpYear = tmpNode.attributes["Year"];
					tmpLeaf = tmpNode.attributes["leaf"];
					tmpCode = tmpNode.attributes["Code"];
					// alert(tmpLeaf);
					function handler(id) {
						if (id == "yes") {
							Ext.Ajax
									.request({
										url : '../csp/herp.budg.budgitemmonitorexe.csp?action=del&code='
												+ tmpCode,
										waitMsg : 'ɾ����...',
										failure : function(result, request) {
											Ext.Msg.show({
												title : '����',
												msg : '������������!',
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
													msg : 'ɾ���ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});

												if (tmpNode.attributes.parent == 0) {
													tmpNode.attributes.parent = "roo";
												}

												// alert(tmpNode.attributes.id);
												// alert(Ext.getCmp('itemGrid').getNodeById(tmpNode.attributes.id).parentNode.text)
												mainGrid
														.getNodeById(tmpNode.attributes.id).parentNode
														.reload();

											} else {
												var message = "������ɾ��";

												Ext.Msg.show({
													title : '����',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
											}

										},
										scope : this
									});
						} else {
							return;
						}
					}

					Ext.MessageBox.confirm('��ʾ', 'ȷʵҪɾ����?', handler);

				} else {
					Ext.Msg.show({
						title : '����',
						msg : '��ѡ������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				}
			}
		});

var checkActive = new Ext.form.Checkbox({
	fieldLabel : '�Ƿ���Ч'
});
//var v = 'Y';
var expandAllButton = new Ext.Toolbar.Button({
	text : 'ȫ��չ��',
	tooltip : 'ȫ��չ��',
	iconCls : 'add',
	handler : function() {
		mainGrid.getRootNode().expand(true);
	}
});

var mainGrid = new Ext.ux.tree.TreeGrid({
	//useArrows : true,
	//frame : true,
	title : '�Ǳ��̼��Ԥ����ά��',
	region : 'center',
	enableDD : true,

	columns : [
			{
				header : '����',
				dataIndex : 'Name',
				width : 250
			},
			{
				header : '����',
				width : 150,
				dataIndex : 'Code'
			},
			{
				header : '��',
				width : 150,
				dataIndex : 'Year'
			},
			{
				header : '����ȫԺ',
				width : 150,
				dataIndex : 'Type'

			},
			{
				header : 'ͼ��',
				width : 150,
				dataIndex : 'Graph'
			},
			{
				id : 'Active',

				header : '�Ƿ����',
				width : 120,
				dataIndex : 'Active'


			} ],

	requestUrl : mainUrl,

	listeners : {
		'beforeload' : function(node) {
			// alert(node.isRoot);
			if (node.isRoot) {
				this.loader.dataUrl = this.requestUrl + "&rnode=";
			} else {
				var nodeText = node.attributes["Code"];
				var Year = node.attributes["Year"];
				var rqtUrl = this.requestUrl + "&rnode=" + nodeText + "&Year="
						+ Year;
				if (node.attributes.loader.dataUrl) {
					this.loader.dataUrl = rqtUrl;
				}
			}
			this.root.attributes.loader = null;
		},

		'click' : function(node, e) {
			tmpNode = node;
		}
	},

	// tbar:[addButton,'-',editButton,'-',delButton,'-',expandAllButton]
	//tbar : [ addButton, '-', editButton, '-', delButton, '-', ctrlitembutton,'-', expandAllButton ]
	tbar : [ delButton, '-', ctrlitembutton,'-', expandAllButton ]
});