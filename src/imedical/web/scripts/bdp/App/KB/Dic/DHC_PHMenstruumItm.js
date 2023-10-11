/// 名称: 溶媒分类明细
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-11-7
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHMenstruumItm";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumItm&pClassMethod=DeleteData";
	var BindingDrug="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb1";
	var BindingMent="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMenstruumCat&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
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
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHMIRowId')
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
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'PHMIRowId',mapping:'PHMIRowId',type:'string'},
                         {name: 'PHMIDrugDr',mapping:'PHMIDrugDr',type:'string'},
                         {name: 'PHMIMentDr',mapping:'PHMIMentDr',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHMIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHMIRowId'
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>药品名',
							name : 'PHMIDrugDr',
							id:'PHMIDrugDrFU',
							hiddenName:'PHMIDrugDr',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMIDrugDrFU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMIDrugDrFU')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '药品名不能为空',
							allowBlank : false,
							valueField : 'PHNRowId',
							displayField : 'PHNDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingDrug,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHNRowId',
								fields : ['PHNRowId', 'PHNDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHNRowId',
									direction : 'ASC'
								}
							})
						},{
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>溶媒',
							name : 'PHMIMentDr',
							id:'PHMIMentDrFU',
							hiddenName:'PHMIMentDr',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMIMentDrFU'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMIMentDrFU')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							blankText : '溶媒不能为空',
							allowBlank : false,
							valueField : 'PHMCRowId',
							displayField : 'PHMCDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingMent,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHMCRowId',
								fields : ['PHMCRowId', 'PHMCDesc']
							})
						}]
			});
	
	/** 修改时弹出窗口 */
	var win = new Ext.Window({
		width : 330,
		height : 260,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'upsave_btn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('upsave_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("PHMIDrugDrFU").getValue();
				var tempDesc = Ext.getCmp("PHMIMentDrFU").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '药品名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '溶媒不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if(WinForm.form.isValid()==false){return;}
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
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var myrowid = action.result.id;
												var totalnum=grid.getStore().getTotalCount();
												grid.getStore().load({
													params : {
																start : 0,
																limit : pagesize_main,
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
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
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
			text : '继续添加',
			iconCls : 'icon-save',
			handler : function() {
				var tempCode = Ext.getCmp("PHMIDrugDrFU").getValue();
				var tempDesc = Ext.getCmp("PHMIMentDrFU").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '药品名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '溶媒不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.BDP.FunLib.Component.FromHideClearFlag;
								var myrowid = action.result.id;
								Ext.getCmp("form-save").getForm().reset();
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
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'PHMIRowId':""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.BDP.FunLib.Component.FromHideClearFlag;
								var myrowid = action.result.id;
								Ext.getCmp("form-save").getForm().reset();
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
			}
		},  {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("PHMIDrugDr").focus(true,800);
				if(win.title == "修改"){
					win.buttons[1].hide();
				}else{
					win.buttons[1].show();
				}
			},
			"hide" : function(){
				Ext.BDP.FunLib.Component.FromHideClearFlag;
			},
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
					if (grid.selModel.hasSelection()) {
						var _record = grid.getSelectionModel().getSelected();
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('PHMIRowId'),
			                success : function(form,action) {
			                	
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			        } else {
			        	 Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
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
									name : 'PHMIRowId',
									mapping : 'PHMIRowId',
									type : 'string'
								}, {
									name : 'PHNDesc',
									mapping : 'PHNDesc',
									type : 'string'
								}, {
									name : 'PHMCDesc',
									mapping : 'PHMCDesc',
									type : 'string'
								}, {
									name : 'PHMIDrugDr',
									mapping : 'PHMIDrugDr',
									type : 'string'
								}, {
									name : 'PHMIMentDr',
									mapping : 'PHMIMentDr',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
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
							drug : Ext.getCmp("PHMIDrugDr").getValue(),
							ment : Ext.getCmp("PHMIMentDr").getValue()
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
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					Ext.getCmp("PHMIDrugDr").reset();
					Ext.getCmp("PHMIMentDr").reset();
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
				items : [
						
						'药品名', {
							xtype : 'combo',
							id : 'PHMIDrugDr',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHMIDrugDr'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'PHNRowId',
							displayField : 'PHNDesc',
							store : new Ext.data.JsonStore({
								url : BindingDrug,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHNRowId',
								fields : ['PHNRowId', 'PHNDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHNRowId',
									direction : 'ASC'
								}
							})
						},'-',
						'溶媒', {
							xtype : 'combo',
							id : 'PHMIMentDr',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHMIMentDr'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'PHMCRowId',
							displayField : 'PHMCDesc',
							store : new Ext.data.JsonStore({
								url : BindingMent,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHMCRowId',
								fields : ['PHMCRowId', 'PHMCDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHMCRowId',
									direction : 'ASC'
								}
							})
						},  '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
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
							header : 'PHMIRowId',
							sortable : true,
							dataIndex : 'PHMIRowId',
							hidden : true
						}, {
							header : '药品名',
							sortable : true,
							dataIndex : 'PHNDesc'
						}, {
							header : '药品名ID',
							sortable : true,
							dataIndex : 'PHMIDrugDr',
							hidden:true
						}, {
							header : '溶媒',
							sortable : true,
							dataIndex : 'PHMCDesc'
						},  {
							header : '溶媒ID',
							sortable : true,
							dataIndex : 'PHMIMentDr',
							hidden:true
						}],
				stripeRows : true,
				title : '溶媒分类明细',
				//stateful : true,
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
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHMIRowId'),
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
