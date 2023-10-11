/// 名称: 证型字典维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-10-31
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHSyndrome&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHSyndrome&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHSyndrome";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHSyndrome&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHSyndrome&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	CanUpdate=function(id){
		var RefText =tkMakeServerCall("web.DHCBL.KB.DHCPHSyndrome","GetRefFlag",id);
		if (RefText.indexOf("证型字典对照")>0){
			return true
		}else{
			return false
		}
	}
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					handler : DelData=function () {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('DRORowId')
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var startIndex = grid.getBottomToolbar().cursor;
															var totalnum=grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
														}
													});
												} else {
													var errorMsg = '';
													if (jsonData.info) {
														errorMsg = '<br/>错误信息:' + jsonData.info
													}
													Ext.Msg.show({
																title : '提示',
																msg : '数据删除失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
												}
											} else {
												Ext.Msg.show({
															title : '提示',
															msg : '异步通讯失败,请检查网络连接!',
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
										msg : '请选择需要删除的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
					}
				});
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'DRORowId',mapping:'DRORowId',type:'string'},
                                         {name: 'DROCode',mapping:'DROCode',type:'string'},
                                         {name: 'DRODesc',mapping:'DRODesc',type:'string'},                     
                                         {name: 'DROActiveFlag',mapping:'DROActiveFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'DRORowId',
							hideLabel : 'True',
							hidden : true,
							name : 'DRORowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'DROCode',
							id:'DROCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DROCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DROCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHSyndrome";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('DRORowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'DRODesc',
							id:'DRODescF',
							hiddenName:'DRODesc',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DRODescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DRODescF')),
							editable:false,
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHSyndrome"; //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('DRORowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						},{
							fieldLabel:'是否可用',
							xtype : 'checkbox',
							name : 'DROActiveFlag',
							id:'DROActiveFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DROActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DROActiveFlagF'))
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 350,
					height:250,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : WinForm,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("DROCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("DRODesc").getValue();
						
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			
			   			 	if(WinForm.form.isValid()==false){return;}
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().load({
																		params : {
																					start : 0,
																					limit : 1,
																					rowid : myrowid
																				}
																			});
															}
												});
											
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
											}
											Ext.Msg.show({
															title : '提示',
															msg : '添加失败!' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
												}			
									},
									failure : function(form, action) {
										Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
									}
								})
							} else {
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										//如果对照了则不允许修改代码和描述
										var DROid=grid.getSelectionModel().getSelections()[0].get('DRORowId')
										var disableFlag=CanUpdate(DROid)
										var code="",desc=""
							        	Ext.getCmp("DROCodeF").setDisabled(disableFlag);
							        	Ext.getCmp("DRODescF").setDisabled(disableFlag);
							        	if(disableFlag==true)
							        	{
							        		var code=grid.getSelectionModel().getSelections()[0].get('DROCode');
							        		var desc=grid.getSelectionModel().getSelections()[0].get('DRODesc');
							        	}
							        	else
							        	{
							        		var code=Ext.getCmp("DROCodeF").getValue();
							        		var desc=Ext.getCmp("DRODescF").getValue();
							        	}
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											params : {
												'DROCode' : code,   ///code只读，修改时禁用的话参数传不到，要单独传。
												'DRODesc' : desc   ///desc只读，修改时禁用的话参数传不到，要单独传。
											},
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													win.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
														}
													});
												} else {
													var errorMsg = '';
													if (action.result.errorinfo) {
														errorMsg = '<br/>错误信息:' + action.result.errorinfo
													}
													Ext.Msg.show({
																	title : '提示',
																	msg : '修改失败!' + errorMsg,
																	minWidth : 200,
																	icon : Ext.Msg.ERROR,
																	buttons : Ext.Msg.OK
																});
													}			
											},
											failure : function(form, action) {
												Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
											}
										})
									}
								}, this);
							}			
						}
					}, {
						text : '继续添加',
						iconCls : 'icon-save',
						id:'resave_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("DROCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("DRODesc").getValue();
						
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			
			   			 	if(WinForm.form.isValid()==false){return;}
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											//win.hide();
											var myrowid = action.result.id;
											Ext.getCmp("form-save").getForm().reset();
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().load({
																		params : {
																					start : 0,
																					limit : 1,
																					rowid : myrowid
																				}
																			});
															}
												});
											
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
											}
											Ext.Msg.show({
															title : '提示',
															msg : '添加失败!' + errorMsg,
															minWidth : 200,
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
												}			
									},
									failure : function(form, action) {
										Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
									}
								})				
						}
					},{
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save").getForm().findField("DROCode").focus(true,800);
							if(win.title == "修改"){
								win.buttons[1].hide();
							}else{
								win.buttons[1].show();
							}
						},
						"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {				
					if (!grid.selModel.hasSelection()) {
						Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
			        } else {

			        	var _record = grid.getSelectionModel().getSelected();
			        	var disableFlag=CanUpdate(_record.get('DRORowId'))
			        	Ext.getCmp("DROCodeF").setDisabled(disableFlag);
			        	Ext.getCmp("DRODescF").setDisabled(disableFlag);
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('DRORowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'DRORowId',
									mapping : 'DRORowId',
									type : 'string'
								}, {
									name : 'DROCode',
									mapping : 'DROCode',
									type : 'string'
								}, {
									name : 'DRODesc',
									mapping : 'DRODesc',
									type : 'string'
								},{
									name : 'DROActiveFlag',
									mapping : 'DROActiveFlag',
									type : 'string'
								}// 列的映射
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
					});
	/** grid加载数据 */
	ds.load({
				params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue()
					};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}
				});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							id : 'TextCode'
						}, '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
					}
				}
			});
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'DRORowId',
							sortable : true,
							dataIndex : 'DRORowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'DROCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'DRODesc'
						},  {
							header : '是否可用',
							sortable : true,
							dataIndex : 'DROActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
				stripeRows : true,
				title : '证型字典',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
		        	var disableFlag=CanUpdate(_record.get('DRORowId'))
		        	Ext.getCmp("DROCodeF").setDisabled(disableFlag);
		        	Ext.getCmp("DRODescF").setDisabled(disableFlag);
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('DRORowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	/** 调用keymap */

    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
