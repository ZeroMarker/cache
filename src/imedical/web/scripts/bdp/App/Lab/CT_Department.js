	
	/// 名称:检验系统 - 1 检验科室维护
	/// 描述:包含增删改查功能
	/// 编写者:基础平台组 - 陈莹
	/// 编写日期:2013-12-4
Ext.onReady(function() {
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTDepartment";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDepartment&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'under';

	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTDEPRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = grid.getBottomToolbar().cursor;
												var totalnum=grid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize==0)//最后一页只有一条
												{
														
														var pagenum=grid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize  
																}	
														});		
	
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,
												buttons : Ext.Msg.OK
											});
								}
							}
						}, this);
					}
				}, this);
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	// 增加修改的form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 100,
				split : true,
				frame : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTDEPCode',mapping:'CTDEPCode'},
                                         {name: 'CTDEPName',mapping:'CTDEPName'},
                                         {name: 'CTDEPManager',mapping:'CTDEPManager'},
                                         
                                         {name: 'CTDEPDisplaySequence',mapping:'CTDEPDisplaySequence'},
                                         {name: 'CTDEPPrintSequence',mapping:'CTDEPPrintSequence'},
                                         {name: 'CTDEPTSLeftMargin',mapping:'CTDEPTSLeftMargin'},
                                         {name: 'CTDEPDefaultPathologistDR',mapping:'CTDEPDefaultPathologistDR'},
                                         {name: 'CTDEPWelcanMinute',mapping:'CTDEPWelcanMinute'},
                                         //YN
                                         {name: 'CTDEPActiveFlag',mapping:'CTDEPActiveFlag'},
                                         {name: 'CTDEPInterimWardReport',mapping:'CTDEPInterimWardReport'},
                                         {name: 'CTDEPPrintDepartmentHeading',mapping:'CTDEPPrintDepartmentHeading'},
                                         {name: 'CTDEPPrintSeparatePage',mapping:'CTDEPPrintSeparatePage'},
                                         {name: 'CTDEPUserBasedPrinting',mapping:'CTDEPUserBasedPrinting'}, //取决于上面的是否对勾，对勾的话才能选
                                         {name: 'CTDEPxxx',mapping:'CTDEPxxx'}
                                         
                                        ]),
				items : [{
							id:'CTDEPRowId',
							xtype:'textfield',
							fieldLabel : 'CTDEPRowId',
							name : 'CTDEPRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'CTDEPCode',
							maxLength:1,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDEPCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDEPCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDEPCode')),
							name : 'CTDEPCode',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTDepartment";
	                            var classMethod = "FormValidate";                         
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTDEPRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}, {
							fieldLabel : '<font color=red>*</font>名称',
							xtype:'textfield',
							id:'CTDEPName',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDEPName'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDEPName'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDEPName')),
							name : 'CTDEPName',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTDepartment";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTDEPRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该名称已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						
						}, {
							id:'CTDEPManager',
							xtype:'textfield',
							fieldLabel : '负责人',
							maxLength:30,
							name : 'CTDEPManager'
						}, {
							id:'CTDEPDisplaySequence',
							xtype:'numberfield',         //数字
							fieldLabel : '显示顺序',
							name : 'CTDEPDisplaySequence'
						}, {
							id:'CTDEPPrintSequence',
							xtype:'textfield',
							maxLength:30,
							fieldLabel : '打印顺序',
							name : 'CTDEPPrintSequence'
						}, {
							id:'CTDEPTSLeftMargin',
							xtype:'numberfield',        //数字
							fieldLabel : 'TSLeftMargin',
							name : 'CTDEPTSLeftMargin'
						}, {
							id:'CTDEPDefaultPathologistDR',
							xtype:'textfield',
							fieldLabel : 'DefaultPathologistDR',
							name : 'CTDEPDefaultPathologistDR'
						}, {
							id:'CTDEPWelcanMinute',
							xtype:'textfield',
							maxLength:30,
							fieldLabel : 'WelcanMinute',
							name : 'CTDEPWelcanMinute'
						}, {
							fieldLabel: '<font color=red></font>激活标志',
							xtype : 'checkbox',
							name : 'CTDEPActiveFlag',
							id:'CTDEPActiveFlag',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDEPActiveFlag'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDEPActiveFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDEPActiveFlag')),
							inputValue : true?'Y':'N',//这句话对Checkbox不起作用，可以直接写成 inputValue : 'Y'
							checked:true
							/*
							单选框radio形式
							fieldLabel : '<font color=red></font>激活标志',
							xtype:'fieldset',
							title:' ',
							autoHeight:true,
							id:'CTDEPActiveFlag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDEPActiveFlag'),
							defaultType:'radio',
							layout:'column', //激活/未激活呈分列式排布
							//hideLabels:true,
							items:[{boxLabel:'激活',name:'CTDEPActiveFlag',inputValue:'Y'},
									{boxLabel:'未激活',name:'CTDEPActiveFlag',inputValue:'N',checked:true}
									]	
									
							*/
						
						}, {
							fieldLabel: '<font color=red></font>InterimWardReport',
							xtype : 'checkbox',
							name : 'CTDEPInterimWardReport',
							id:'CTDEPInterimWardReport'
						}, {
							fieldLabel: '<font color=red></font>PrintDepartmentHeading',
							xtype : 'checkbox',
							name : 'CTDEPPrintDepartmentHeading',
							id:'CTDEPPrintDepartmentHeading'
						
						}, {
							fieldLabel: '<font color=red></font>PrintSeparatePage',
							xtype : 'checkbox',
							name : 'CTDEPPrintSeparatePage',
							id:'CTDEPPrintSeparatePage'
						}, {
							fieldLabel: '<font color=red></font>UserBasedPrinting',
							xtype : 'checkbox',
							name : 'CTDEPUserBasedPrinting',
							id:'CTDEPUserBasedPrinting'
						}, {
							fieldLabel: '<font color=red></font>xxx',
							xtype : 'checkbox',
							name : 'CTDEPxxx',
							maxLength:30,
							id:'CTDEPxxx'
						
						}]	
	});
			
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 300,
		height: 450,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				//-------添加----------
				if (win.title == "添加") {
					//WinForm.form.isValid()
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
						}
					}, this);
				}
			}
		}, {
			text : '取消',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("form-save").getForm().findField("CTDEPCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
				},
				scope: this
	});
	// 修改按钮
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						loadFormData(grid);
						//var record = grid.getSelectionModel().getSelected();
						//Ext.getCmp("form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'CTDEPRowId',
								mapping : 'CTDEPRowId',
								type : 'number'
							}, {
								name : 'CTDEPCode',
								mapping : 'CTDEPCode',
								type : 'string'
							}, {
								name : 'CTDEPName',
								mapping : 'CTDEPName',
								type : 'string'
							},{
								name : 'CTDEPManager',
								mapping : 'CTDEPManager',
								type : 'string'
							},{
								name : 'CTDEPDisplaySequence',
								mapping : 'CTDEPDisplaySequence',
								type : 'number'
							},{
								name : 'CTDEPPrintSequence',
								mapping : 'CTDEPPrintSequence',
								type : 'string'
							
							},{
								name : 'CTDEPTSLeftMargin',
								mapping : 'CTDEPTSLeftMargin',
								type : 'number'
							},{
								name : 'CTDEPDefaultPathologistDR',
								mapping : 'CTDEPDefaultPathologistDR',
								type : 'string'
							},{
								name : 'CTDEPWelcanMinute',
								mapping : 'CTDEPWelcanMinute',
								type : 'string'
							}, {
								name : 'CTDEPActiveFlag',
								mapping : 'CTDEPActiveFlag',
								//type : 'string' // radio
								inputValue : true?'Y':'N' //checkbox
							}, {
								name : 'CTDEPInterimWardReport',
								mapping : 'CTDEPInterimWardReport',
								inputValue : true?'Y':'N'
							}, {
								name : 'CTDEPPrintDepartmentHeading',
								mapping : 'CTDEPPrintDepartmentHeading',
								inputValue : true?'Y':'N'
							}, {
								name : 'CTDEPPrintSeparatePage',
								mapping : 'CTDEPPrintSeparatePage',
								inputValue : true?'Y':'N'
							}, {
								name : 'CTDEPUserBasedPrinting',
								mapping : 'CTDEPUserBasedPrinting',
								inputValue : true?'Y':'N'
							}, {
								name : 'CTDEPxxx',
								mapping : 'CTDEPxxx',
								inputValue : true?'Y':'N'
							
							
							}
						])
				//remoteSort : true
				//sortInfo: {field : "OPERRowId",direction : "ASC"}
	});
	//ds.sort("CTDEPCode","DESC");
			
 	// 加载数据
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-']
	});
		
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={		
						code :  Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue(),
					
						active : Ext.getCmp("TextCTDEPActiveFlag").getValue()
						
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}
	});
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextCTDEPActiveFlag").reset();  
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}
	});
		
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码：', {xtype : 'textfield',id : 'TextCode',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'-',
						'名称：', {xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-',
						'激活标志：',
						 {
							fieldLabel : '<font color=red></font>激活标志',
							xtype : 'combo',
							//name : 'CTDEPActiveFlag',
							id : 'TextCTDEPActiveFlag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTDEPActiveFlag'),
							width : 140,
							mode : 'local',
							//hiddenName:'CTDEPActiveFlag',
							triggerAction : 'all',
							//forceSelection : true,
							//selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							listWidth : 140,
							shadow:false,
							valueField : 'value',
							displayField : 'name',
							//editable:false,
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{value : 'Y',name : 'Yes'}, 
												{value : 'N',name : 'No'}			
										]
							})	
						},'-',
						btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '检验科室',
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :[sm, {
							header : 'CTDEPRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTDEPRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTDEPCode'
						}, {
							header : '名称',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPName'
						}, {
							header : '负责人',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPManager'
						}, {
							header : '显示顺序',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPDisplaySequence'
						}, {
							header : '打印顺序',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPPrintSequence'
						}, {
							header : 'TSLeftMargin',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPTSLeftMargin'
						}, {
							header : 'DefaultPathologistDR',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPDefaultPathologistDR'
						}, {
							header : 'WelcanMinute',
							width : 100,
							sortable : true,
							dataIndex : 'CTDEPWelcanMinute'					
						}, {
							header : '激活标志',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPActiveFlag'
						}, {
							header : 'InterimWardReport',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPInterimWardReport'
						}, {
							header : 'PrintDepartmentHeading',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPPrintDepartmentHeading'
						}, {
							header : 'PrintSeparatePage',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPPrintSeparatePage'
						}, {
							header : 'UserBasedPrinting',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPUserBasedPrinting'
						}, {
							header : 'xxx',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'CTDEPxxx'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});


   // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTDEPRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
            Ext.getCmp("form-save").getForm().findField('CTDEPActiveFlag').setValue((_record.get('CTDEPActiveFlag'))=='Y'?true:false);
        }
    };

    //双击事件
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
    });	
	
    if(window.ActiveXObject)
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    } 
    
	//创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});