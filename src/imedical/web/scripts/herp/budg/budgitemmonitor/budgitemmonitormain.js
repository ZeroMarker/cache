var mainUrl = '../csp/herp.budg.budgitemmonitorexe.csp?action=list';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var hospid = session['LOGON.HOSPID'];
var tmpNode = "";
var tmpYear="";
var tmpCode="";
var Code = "";
var Year = "";
var checkActive = new Ext.form.Checkbox({
	fieldLabel : '是否有效'
});

// 支出控制
var ctrlitembutton = new Ext.Toolbar.Button(
		{
			text : '支出控制',
			tooltip : '支出控制',
			iconCls : 'option',
			handler : function() {
				if(tmpNode!=""){
					var isBatch;
					var tmpYear;
					var tmpCode;
					var tmpIsActive=tmpNode.attributes["Active"];
				}
			
				//根据是否选择节点来判断是否批量处理
			
					var YearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, [ 'year', 'year' ])
					});

					YearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
							url :  commonboxUrl + '?action=year',
							method : 'POST'
						});
					});

					var yearCombo = new Ext.form.ComboBox({
						fieldLabel : '预算年度',
						store : YearDs,
						displayField : 'year',
						valueField : 'year',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText:'选择年度...',
						//anchor: '95%',
						width:180,
						listWidth : 245,
						pageSize : 10,
						minChars : 1,
						columnWidth : 0.5,
						selectOnFocus : true
					});
					
					// ////////////科室名称////////////////////////
var itemtypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['code', 'name'])
		});

itemtypeDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl + '?action=itemtype&flag=1',method : 'POST'});
		});

var itemtypecomb = new Ext.form.ComboBox({
			fieldLabel : '科目类别',
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
						fieldLabel : '支出控制'
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
					
					
					
					//批量选择框
					var IsBatchField = new Ext.form.Checkbox({
						checked : isBatch,
						fieldLabel : '是否批量'
						
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
						text : '支出控制'
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
								title : '错误',
								msg : '请选择根节点!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
							
						}else if(isbatch==true&&!(budgyear&&itemtype)){
							Ext.Msg.show({
								title : '错误',
								msg : '请选择年度或项目类型!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
						}
						else{
						if (formPanel.form.isValid()) {
						

							Ext.Ajax
									.request({
										//此处调用的方法来自于另一个类
										url : '../csp/herp.budg.budgitemmonitorexe.csp?action=ctrl&Code='
												+ tmpCode
												+ '&Year='
												+ tmpYear
												+ '&Active=' + Active+'&isbatch='+isbatch+'&budgyear='+budgyear+'&itemtype='+itemtype+'&hospid='+hospid,
										waitMsg : '保存中...',
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
													message = '输入的编码已经存在!';
												if (jsonData.info == 'NoName')
													message = '已经非支出控制!';
												if (jsonData.info == 'RepName')
													message = '已经支出控制!';
												if (jsonData.info == 'fail')
													message = '保存到相应的组失败!';
												Ext.Msg.show({
													title : '错误',
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
								title : '错误',
								msg : '请修正页面上的错误!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}
					}
					}

					ctrlitembutton.addListener('click', addHandler, false);

					cancelButton = new Ext.Toolbar.Button({
						text : '取消'
					});

					cancelHandler = function() {
						editwin.close();
					}

					cancelButton.addListener('click', cancelHandler, false);

					editwin = new Ext.Window({
						title : '支出控制',
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
			text : '添加',
			tooltip : '添加',
			iconCls : 'add',
			handler : function() {

				var tmpCode = "";

				tmpCode = tmpNode.attributes["Code"];
				tmpYear = tmpNode.attributes["Year"];

				var TypeField = new Ext.form.ComboBox({
					fieldLabel : '全院科室',
					width : 180,
					anchor : '95%',
					store : new Ext.data.ArrayStore({
						fields : [ 'rowid', 'name' ],
						data : [ [ '1', '全院' ], [ '2', '科室' ] ]
					}),
					displayField : 'name',
					valueField : 'rowid',
					typeAhead : true,
					mode : 'local',
					value : '1',
					forceSelection : true,
					triggerAction : 'all',
					emptyText : '选择...',
					selectOnFocus : 'true'
				});
				// 图形
				var GraphField = new Ext.form.ComboBox({
					fieldLabel : '图形',
					width : 180,
					anchor : '95%',
					store : new Ext.data.ArrayStore({
						fields : [ 'rowid', 'name' ],
						data : [ [ '1', '柱图' ], [ '2', '仪表盘' ] ]
					}),
					displayField : 'name',
					valueField : 'rowid',
					typeAhead : true,
					mode : 'local',
					value : '1',
					forceSelection : true,
					triggerAction : 'all',
					emptyText : '选择...',
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
					text : '添加'
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
									waitMsg : '保存中...',
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
												message = '输入的信息已经存在!';
											if (jsonData.info == 'RepName')
												message = '输入的名称已经存在!';
											if (jsonData.info == 'fail')
												message = '保存到相应的组失败!';
											Ext.Msg.show({
												title : '错误',
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
							title : '错误',
							msg : '请修正页面上的错误!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
					}
				};

				addButton.addListener('click', addHandler, false);

				cancelButton = new Ext.Toolbar.Button({
					text : '取消'
				});

				cancelHandler = function() {
					addwin.close();
				};

				cancelButton.addListener('click', cancelHandler, false);

				addwin = new Ext.Window({
					title : '添加预算项',
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
			text : '修改',
			tooltip : '修改',
			iconCls : 'option',
			handler : function() {
				
					

				if(tmpNode!=""){
					var isBatch;
					
					var tmpCode = tmpNode.attributes["Code"];
					var tmpType = tmpNode.attributes["Type"];
					var tmpGraph = tmpNode.attributes["Graph"];
					var tmpYear = tmpNode.attributes["Year"];
			
				}	
					
					//根据是否选择节点来判断是否批量处理
					
					var YearDs = new Ext.data.Store({
						proxy : "",
						reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : 'rows'
						}, [ 'year', 'year' ])
					});

					YearDs.on('beforeload', function(ds, o) {

						ds.proxy = new Ext.data.HttpProxy({
							url :  commonboxUrl + '?action=year',
							method : 'POST'
						});
					});

					var yearCombo = new Ext.form.ComboBox({
						fieldLabel : '预算年度',
						store : YearDs,
						displayField : 'year',
						valueField : 'year',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText:'选择年度...',
						
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
						data:[['01','收入'],['02','支出']]
					});
					var itemtypecomb = new Ext.form.ComboBox({
						id: 'itemtype',
						fieldLabel: '项目类型',
						width:180,
						listWidth : 90,
						store: itemtype,
						anchor: '95%',
						valueNotFoundText:'',
						displayField: 'value',
						valueField: 'key',
						triggerAction: 'all',
						emptyText:'选择项目类型...',
						mode: 'local', //本地模式
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

					//批量选择框
					var IsBatchField = new Ext.form.Checkbox({
						checked : isBatch,
						fieldLabel : '是否批量'
						
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
						fieldLabel : '全院科室',
						width : 180,
						anchor : '95%',
						store : new Ext.data.ArrayStore({
							fields : [ 'rowid', 'name' ],
							data : [ [ '1', '全院' ], [ '2', '科室' ] ]
						}),
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						mode : 'local',
						value : tmpType,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '选择...',
						selectOnFocus : 'true'
					});
					// 图形
					var GraphField = new Ext.form.ComboBox({
						fieldLabel : '图形',
						width : 180,
						anchor : '95%',
						store : new Ext.data.ArrayStore({
							fields : [ 'rowid', 'name' ],
							data : [ [ '1', '柱图' ], [ '2', '仪表盘' ] ]
						}),
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						mode : 'local',
						value : tmpGraph,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '选择...',
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
						text : '修改'
					});

					editHandler = function() {

						var Type = TypeField.getValue();
						if (Type == '全院') {
							Type = 1;
						} 
						if (Type == '科室') {
							Type = 2;
						}
						var Graph = GraphField.getValue();
						if (Graph == '柱图') {
							Graph = 1;
						} 
						if (Graph == '仪表盘') {
							Graph = 2;
						}

						var budgyear=yearCombo.getValue();
						var itemtype=itemtypecomb.getValue();
						var isbatch=IsBatchField.getValue();
						
						var data = tmpCode + "|" + Type + "|" + Graph + "|"
								+ tmpYear + "|" + budgyear+ "|" + itemtype+ "|" + isbatch;
						if(tmpNode == ""&&isbatch==false){

							Ext.Msg.show({
								title : '错误',
								msg : '请选择根节点!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});	
							
						}else if(isbatch==true&&!(budgyear&&itemtype)){
							
							Ext.Msg.show({
								title : '错误',
								msg : '请选择年度或项目类型!',
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

										waitMsg : '保存中...',
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

												var message = "数据失败";
												if (jsonData.info == 'RepCode')
													message = '输入的数据已经存在!';
												if (jsonData.info == 'RepName')
													message = '输入的名称已经存在!';
												if (jsonData.info == 'fail')
													message = '保存到相应的组失败!';
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
								msg : '请修正页面上的错误!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
						}
						}
					};

					editButton.addListener('click', editHandler, false);

					cancelButton = new Ext.Toolbar.Button({
						text : '取消'
					});

					cancelHandler = function() {
						editwin.close();
					};

					cancelButton.addListener('click', cancelHandler, false);

					editwin = new Ext.Window({
						title : '修改预算项',
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
			text : '删除',
			tooltip : '删除',
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
										waitMsg : '删除中...',
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
													msg : '删除成功!',
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
												var message = "数据已删除";

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
							return;
						}
					}

					Ext.MessageBox.confirm('提示', '确实要删除吗?', handler);

				} else {
					Ext.Msg.show({
						title : '错误',
						msg : '请选择数据!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				}
			}
		});

var checkActive = new Ext.form.Checkbox({
	fieldLabel : '是否有效'
});
//var v = 'Y';
var expandAllButton = new Ext.Toolbar.Button({
	text : '全部展开',
	tooltip : '全部展开',
	iconCls : 'add',
	handler : function() {
		mainGrid.getRootNode().expand(true);
	}
});

var mainGrid = new Ext.ux.tree.TreeGrid({
	//useArrows : true,
	//frame : true,
	title : '仪表盘监控预算项维护',
	region : 'center',
	enableDD : true,

	columns : [
			{
				header : '名称',
				dataIndex : 'Name',
				width : 250
			},
			{
				header : '编码',
				width : 150,
				dataIndex : 'Code'
			},
			{
				header : '年',
				width : 150,
				dataIndex : 'Year'
			},
			{
				header : '医院名称',
				width : 150,
				dataIndex : 'CompDR'
			},
			{
				header : '科室全院',
				width : 150,
				dataIndex : 'Type'

			},
			{
				header : '图形',
				width : 150,
				dataIndex : 'Graph'
			},
			{
				id : 'Active',

				header : '是否控制',
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
	tbar : [ editButton, '-', delButton, '-', ctrlitembutton,'-', expandAllButton ]
});