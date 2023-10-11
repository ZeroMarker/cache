/// 名称: 特殊人群与既往史关联表维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-11-10
/// 修改日期：2015-6-18
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var selectrow=Ext.getUrlParam('selectrow');

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuHistory&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuHistory&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCSpecialPopuHistory";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuHistory&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopuHistory&pClassMethod=DeleteData";
	var PO_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCSpecialPopu&pClassQuery=GetDataForCmb1";
	var DH_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCDisHistoryFeild&pClassQuery=GetDataForCmb1";
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
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
											'id' : rows[0].get('SPEHRowId')
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
															else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_pop
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

	/**既往史多选下拉框*/	  
	var hisCombox =  new Ext.form.MultiSelect({ 
				fieldLabel : '<font color=red>*</font>既往史',
				name : 'SPEHDHDr',
				id:'SPEHDHDrF',
				hiddenName:'SPEHDHDr',
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHDHDrF'),
				style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHDHDrF')),
				triggerAction : 'all',// query
				forceSelection : true,
				selectOnFocus : false,
				typeAhead : true,
				queryParam : "desc",
				mode : 'remote',
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				minChars : 0,
				listWidth : 250,
				blankText : '既往史不能为空',
				allowBlank : false,
				valueField : 'DHIRowId',
				displayField : 'DHIDesc',
				showSelectAll:true,
				store :new Ext.data.JsonStore({
					autoLoad : true,
					url : DH_Dr_QUERY_ACTION_URL,
					root : 'data',
					totalProperty : 'total',
					idProperty : 'DHIRowId',
					fields : ['DHIRowId', 'DHIDesc'],
					listeners:{
									'load':function(store){
										if(Ext.getCmp('SPEHDHDrF').getValue()!=""){
											var cfmF = window.confirm('本页数据已变动,是否保存?');
								    		if(cfmF){ //是
								    			saveData();
								    		}else{
								    			Ext.getCmp('SPEHDHDrF').setValue("");
								    		}
										}
									}
								}
				})
			});

	/** 创建修改Form表单 */
	var WinFormUpdate = new Ext.form.FormPanel({
				id : 'form-update',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'SPEHRowId',mapping:'SPEHRowId',type:'string'},
                                         {name: 'SPEHPODr',mapping:'SPEHPODr',type:'string'},
                                         {name: 'SPEHDHDr',mapping:'SPEHDHDr',type:'string'},                                     
                                         {name: 'SPEHActiveFlag',mapping:'SPEHActiveFlag',type:'string'},
                                         {name: 'SPEHSysFlag',mapping:'SPEHSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'SPEHRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'SPEHRowId'
						}, {
							id : 'SPEHPODrU',
							xtype : 'textfield',
							fieldLabel : 'SPEHPODr',
							name : 'SPEHPODr',
							hideLabel : 'True',
							hidden : true
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank : false,
							fieldLabel : '<font color=red>*</font>既往史',
							hiddenName : 'SPEHDHDr',
							id:'SPEHDHDrU',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHDHDrU'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHDHDrU')),
							store :new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : DH_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'DHIRowId',mapping:'DHIRowId'},
										{name:'DHIDesc',mapping:'DHIDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'DHIDesc',
							valueField : 'DHIRowId'
						}, {
							fieldLabel:'是否启用',
							xtype : 'checkbox',
							inputValue : true ? 'Y' : 'N',
							checked:true,
							//xtype : 'combo',
							name : 'SPEHActiveFlag',
							id:'SPEHActiveFlagU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHActiveFlagU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHActiveFlagU'))
						},{
							fieldLabel:'系统标识',
							xtype : 'checkbox',
							name : 'SPEHSysFlag',
							id:'SPEHSysFlagU',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHSysFlagU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHSysFlagU'))
						}]
			});
	
	/** 修改时弹出窗口 */
	var winUpdate = new Ext.Window({
					title:'修改',
					iconCls:'icon-update',
					width : 420,
					height:360,
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
					items : WinFormUpdate,
					buttons : [{
						text : '保存',
						id:'update_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
						handler : function () {
							var tempHis = Ext.getCmp("form-update").getForm().findField("SPEHDHDr").getValue();
			   				if (tempHis=="") {
			    				Ext.Msg.show({ title : '提示', msg : '既往史不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormUpdate.form.isValid()==false){return;}
							Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinFormUpdate.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdate.hide();
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
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							winUpdate.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-update").getForm().findField("SPEHPODr").focus(true,800);
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
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
                                        [{name: 'SPEHRowId',mapping:'SPEHRowId',type:'string'},
                                         {name: 'SPEHPODr',mapping:'SPEHPODr',type:'string'},
                                         {name: 'SPEHDHDr',mapping:'SPEHDHDr',type:'string'},                                     
                                         {name: 'SPEHActiveFlag',mapping:'SPEHActiveFlag',type:'string'},
                                         {name: 'SPEHSysFlag',mapping:'SPEHSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'SPEHRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'SPEHRowId'
						}, {
							id : 'SPEHPODr',
							xtype : 'textfield',
							fieldLabel : 'SPEHPODr',
							name : 'SPEHPODr',
							hideLabel : 'True',
							hidden : true
						},hisCombox, {
							fieldLabel:'是否启用',
							xtype : 'checkbox',
							inputValue : true ? 'Y' : 'N',
							checked:true,
							//xtype : 'combo',
							name : 'SPEHActiveFlag',
							id:'SPEHActiveFlagF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHActiveFlagF'))
						},{
							fieldLabel:'系统标识',
							xtype : 'checkbox',
							name : 'SPEHSysFlag',
							id:'SPEHSysFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SPEHSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SPEHSysFlagF'))
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 420,
					height:360,
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
						id:'save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : saveData=function () {
							var tempHis = Ext.getCmp("form-save").getForm().findField("SPEHDHDr").getValue();
			   				if (tempHis=="") {
			    				Ext.Msg.show({ title : '提示', msg : '既往史不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinForm.form.isValid()==false){return;}
							WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									params : {
										'SPEHPODr' : selectrow//在打开的时候,已赋值
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var totalnum=grid.getStore().getTotalCount();
															var myrowid = action.result.id;
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop,
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
						text : '继续添加',
						id:'resave_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
						handler : function () {
							var tempHis = Ext.getCmp("form-save").getForm().findField("SPEHDHDr").getValue();
			   				if (tempHis=="") {
			    				Ext.Msg.show({ title : '提示', msg : '既往史不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinForm.form.isValid()==false){return;}
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									params : {
										'SPEHPODr' : selectrow//在打开的时候,已赋值
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save").getForm().reset();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var totalnum=grid.getStore().getTotalCount();
															var myrowid = action.result.id;
															grid.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop,
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
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save").getForm().findField("SPEHPODr").focus(true,800);
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
					if (!grid.selModel.hasSelection()) {
						Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
			        } else {
			        	var _record = grid.getSelectionModel().getSelected();
						winUpdate.show('');
						Ext.getCmp("form-update").getForm().reset();
			            Ext.getCmp("form-update").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('SPEHRowId'),
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
									name : 'SPEHRowId',
									mapping : 'SPEHRowId',
									type : 'string'
								}, {
									name : 'SPEHPODr',
									mapping : 'SPEHPODr',
									type : 'string'
								}, {
									name : 'SPEHDHDr',
									mapping : 'SPEHDHDr',
									type : 'string'
								},{
									name : 'SPEHActiveFlag',
									mapping : 'SPEHActiveFlag',
									type : 'string'
								}, {
									name : 'SPEHSysFlag',
									mapping : 'SPEHSysFlag',
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
					limit : pagesize_pop,
					parref: selectrow
				},
				callback : function(records, options, success) {
				}
			});
	/** 加载前设置参数 */
	ds.on('beforeload',function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(ds.lastOptions.params, {
				    	parref:selectrow
				    });
			},this);
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_pop=this.pageSize;
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
							parref :selectrow,
							disHis : Ext.getCmp("TextHis").getValue()
					};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_pop
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
					Ext.getCmp("TextHis").reset();
					grid.getStore().baseParams={
						parref :selectrow
					};
					grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_pop
										}
								});
						}
				});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						'既往史', {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextHis'),
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							shadow:false,
							id : 'TextHis',
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : DH_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'DHIRowId',mapping:'DHIRowId'},
										{name:'DHIDesc',mapping:'DHIDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'DHIDesc',
							valueField : 'DHIRowId'
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
							header : 'SPEHRowId',
							sortable : true,
							dataIndex : 'SPEHRowId',
							hidden : true
						}, {
							header : '特殊人群',
							sortable : true,
							dataIndex : 'SPEHPODr'
						}, {
							header : '既往史',
							sortable : true,
							dataIndex : 'SPEHDHDr'
						}, {
							header : '是否启用',
							sortable : true,
							dataIndex : 'SPEHActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header : '系统标识',
							sortable : true,
							dataIndex : 'SPEHSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
				stripeRows : true,
				title : '特殊人群与既往史关联字典',
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
				if (!grid.selModel.hasSelection()) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
		        	var _record = grid.getSelectionModel().getSelected();
					winUpdate.show('');
					Ext.getCmp("form-update").getForm().reset();
		            Ext.getCmp("form-update").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('SPEHRowId'),
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
