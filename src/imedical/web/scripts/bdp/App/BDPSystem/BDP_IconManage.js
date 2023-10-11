/// 名称: 教育水平	
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2012-8-30
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

    Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();  
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPIconManage&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPIconManage&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPIconManage";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPIconManage&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPIconManage&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "BDP_IconManage"
	});
	 Ext.BDP.FunLib.TableName="BDP_IconManage"
	 
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除',
					iconCls : 'icon-delete',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					handler : DelData=function() {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
 									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									//删除所有别名
									AliasGrid.DataRefer = rows[0].get('ID');
									AliasGrid.delallAlias();
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('ID')
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
															 Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
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
				labelWidth : 70,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ID',mapping:'ID',type:'int'},
                                         {name: 'BDPICONCode',mapping:'BDPICONCode',type:'string'},
                                         {name: 'BDPICONDesc',mapping:'BDPICONDesc',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ID',
							hideLabel : 'True',
							hidden : true,
							name : 'ID'
						}, {
							fieldLabel : '<font color=red>*</font>图标名',
							name : 'BDPICONCode',
							id:'BDPICONCodeF',
                            labelSeparator : "",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPICONCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPICONCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
                                var id="",flag = "";
	                            var className =  "web.DHCBL.BDP.BDPIconManage";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID'); //此条数据的rowid
	                            }
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
                                if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该图标名已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>图标含义',
                            labelSeparator : "",
							name : 'BDPICONDesc',
							id:'BDPICONDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BDPICONDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BDPICONDescF')),
							allowBlank : false 
						}]
				});
	
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });
	  Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	/** 增加修改时弹出窗口 */
			var win = new Ext.Window({
					width : 430,
					height:300,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : false,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					bodyStyle : 'padding:1px',
					buttonAlign : 'center',
					closeAction : 'hide',
					items : tabs,
					buttons : [{
						text : '保存',
                        iconCls : 'icon-save',
						id:'save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function() {
							var tempCode = Ext.getCmp("form-save").getForm().findField("BDPICONCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("BDPICONDesc").getValue();
							if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '图标名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '图标含义不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			} 
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = action.result.id;
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
											
											//保存别名
											AliasGrid.DataRefer = myrowid;
											AliasGrid.saveAlias();
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
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {
												//保存别名
												AliasGrid.saveAlias();
												
												if (action.result.success == 'true') {
													win.hide();
													var myrowid = "rowid=" + action.result.id;
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
						text : '关闭',
                        iconCls : 'icon-close',
						handler : function() {
							win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							var tempCode = Ext.getCmp("form-save").getForm().findField("BDPICONCode").focus(true,800);
						},
						"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					var _record = grid.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
			        } else {
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('ID');
				        AliasGrid.loadGrid();
			        }
				}
			});
	/** grid数据存储 */
	var fields= [{
					name : 'ID',
					mapping : 'ID',
					type : 'int'
				}, {
					name : 'BDPICONCode',
					mapping : 'BDPICONCode',
					type : 'string'
				}, {
					name : 'BDPICONDesc',
					mapping : 'BDPICONDesc',
					type : 'string'
				}]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }), 
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
			});
 
	/** grid加载数据 */
	ds.load({
				params : {
					start : 0,
					limit : pagesize_main
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
					Ext.BDP.FunLib.SelectRowId="";
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
				items : ['图标名', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'图标含义', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-', btnSearch, '-', btnRefresh, '->'
				// btnHelp
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	/** 创建grid */
	var GridCM= [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						}, {
							header : '图标名',
							sortable : true,
							dataIndex : 'BDPICONCode'
						}, {
							header : '图标含义',
							sortable : true,
							dataIndex : 'BDPICONDesc'
						}, {
							header : '图标缩略图',
							sortable : true,
							dataIndex : 'BDPICONCode',
						    renderer : function(value) {   
								value="<img src='../scripts/bdp/Framework/BdpIconsLib/"+value+"'/>";
								return value; 
							}
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				title : '图标库管理',
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
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		         	
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('ID');
			        AliasGrid.loadGrid();
		        }
			});
	 Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.TableName);
     Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	 var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});
