/// 名称:导入导出基础配置表
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-9-2
 Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var strURL="../csp"
	//Ext.BLANK_IMAGE_URL = '../bi/js/bibdp/ext3/resources/images/default/s.gif';
	var SAVE_ACTION_URL = strURL+"/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEILink&pClassMethod=SaveData&pEntityName=web.Entity.BDP.BDPEILink";
	var QUERY_ACTION_URL = strURL+"/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEILink&pClassQuery=GetList";
	var OPEN_ACTION_URL = strURL+"/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEILink&pClassMethod=OpenData";
	var DELETE_ACTION_URL = strURL+"/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEILink&pClassMethod=DeleteData";
	
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.BDP.FunLib.TableName="BDPEILink";
	
	var showtype//showtype是要显示的配置项类型
	var ConfigData //修改时要显示的配置项的值
	var preciousType //之前的配置项类型
	
	
	
    
	/** ****删除按钮 **************/
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
				
	/**************************创建添加修改的Form表单 ***************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ID',mapping:'ID',type:'string'},                                        
                                         {name: 'EILFileName',mapping:'EILFileName',type:'string'},
                                         {name: 'EILType',mapping:'EILType',type:'string'},     
                                         {name: 'EILFileType',mapping:'EILFileType',type:'string'},
                                         {name: 'EILEIType',mapping:'EILEIType',type:'string'},
                                         {name: 'EILStartSheet',mapping:'EILStartSheet',type:'string'},
                                         {name: 'EILEndSheet',mapping:'EILEndSheet',type:'string'},                  
                                         {name: 'EILStartRow',mapping:'EILStartRow',type:'string'}
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
							fieldLabel : '<font color=red>*</font>配置名',
							name : 'EILFileName',
							id:'EILFileNameF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILFileNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILFileNameF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPEILink";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该配置名已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>模板类型',
							name : 'EILType',
							id:'EILTypeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILTypeF')),
							allowBlank : false,
							blankText: '不能为空'
						}, {
							fieldLabel:'<font color=red>*</font>导入导出类型',
							xtype : 'combo',
							name : 'EILEIType',
							hiddenName:'EILEIType',
							id:'EILEITypeF',
							editable:false,
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILEITypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILEITypeF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['I','Import'],
									      ['E','Export']
								     ]
							})
						},{
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>文件类型',
							name : 'EILFileType',
							hiddenName:'EILFileType',
							id:'EILFileTypeF',
							editable:false,
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILFileTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILFileTypeF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['E','Excel'],
									      ['G','Gof']
								     ]
							}),
							listeners:{
										'select':function(){
											if(Ext.getCmp("EILFileTypeF").getValue()=="E"){
												Ext.getCmp('EILStartSheetF').setDisabled(false);
												Ext.getCmp('EILEndSheetF').setDisabled(false);
												Ext.getCmp('EILStartRowF').setDisabled(false);
											}
											else{
												Ext.getCmp('EILStartSheetF').setDisabled(true);
												Ext.getCmp('EILEndSheetF').setDisabled(true);
												Ext.getCmp('EILStartRowF').setDisabled(true);
												Ext.getCmp('EILStartSheetF').setValue("");
												Ext.getCmp('EILEndSheetF').setValue("");
												Ext.getCmp('EILStartRowF').setValue("");
											}
										}
									}
						}, {
							fieldLabel:'开始sheet',
							xtype:'numberfield',
							name : 'EILStartSheet',
							id:'EILStartSheetF',
        					readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILStartSheetF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILStartSheetF'))						
						},{
							fieldLabel:'结束sheet',
							xtype:'numberfield',
							name : 'EILEndSheet',
							id:'EILEndSheetF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILEndSheetF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILEndSheetF'))							
						}, {
							fieldLabel :'起读行数',
							xtype:'numberfield',
							name : 'EILStartRow',
							id:'EILStartRowF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EILStartRowF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EILStartRowF'))
							
						}]
			});
	

	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm]
			 });
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					title : '',
					width : 420,
					height:400,
					layout : 'fit',
					//autoHeight:true,
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
					items : tabs,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {			
							var hasType=Ext.getCmp('EILTypeF').getValue();
							var hasFileName=Ext.getCmp('EILFileNameF').getValue();
							var hasFileType=Ext.getCmp('EILFileTypeF').getValue();
							var hasEIType=Ext.getCmp('EILEITypeF').getValue();
							if (hasFileName=="") {
			    				Ext.Msg.show({ title : '提示', msg : '配置名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (hasFileType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '文件类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}	
					 		if (hasType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '模板类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}	
					 		if (hasEIType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '导入导出类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}	
			    			if(WinForm.form.isValid()==false){
			    			    Ext.Msg.show({ title : '提示', msg : '数据验证失败,请检查您的数据填写是否有误!', minWidth : 300, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
            					return;
			    			}
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
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
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
								// WinForm.getForm().reset();
							}	

						}
						
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							win.hide();
							WinForm.getForm().reset();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save").getForm().findField("EILFileName").focus(true,800);
						},
						"hide" : function() {
							Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾、
						},
						"close" : function() {}
					}
				});
				
	var sheetDisabled=function(){
		if(Ext.getCmp("EILFileTypeF").getValue()=="E"){			
			Ext.getCmp('EILStartSheetF').setDisabled(false);
			Ext.getCmp('EILEndSheetF').setDisabled(false);
			Ext.getCmp('EILStartRowF').setDisabled(false);
		}
		else{
			Ext.getCmp('EILStartSheetF').setDisabled(true);
			Ext.getCmp('EILEndSheetF').setDisabled(true);
			Ext.getCmp('EILStartRowF').setDisabled(true);
			Ext.getCmp('EILStartSheetF').setValue("");
			Ext.getCmp('EILEndSheetF').setValue("");
			Ext.getCmp('EILStartRowF').setValue("");
		}
	}
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
					win.show();
					WinForm.getForm().reset();
					Ext.getCmp('EILStartSheetF').setDisabled(false);
					Ext.getCmp('EILEndSheetF').setDisabled(false);
					Ext.getCmp('EILStartRowF').setDisabled(false);
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
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						var _record = grid.getSelectionModel().getSelected();// records[0]
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                	//Ext.Msg.alert('编辑','载入成功！');
			                	sheetDisabled();
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            })
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
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'EILFileName',
									mapping : 'EILFileName',
									type : 'string'
								}, {
									name : 'EILType',
									mapping : 'EILType',
									type : 'string'
								},{
									name : 'EILFileType',
									mapping : 'EILFileType',
									type : 'string'
								},{
									name : 'EILEIType',
									mapping : 'EILEIType',
									type : 'string'
								}, {
									name : 'EILStartSheet',
									mapping : 'EILStartSheet',
									type : 'string'
								},{
									name : 'EILEndSheet',
									mapping : 'EILEndSheet',
									type : 'string'
								}, {
									name : 'EILStartRow',
									mapping : 'EILStartRow',
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
			id:'tbbutton',
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
							filename : Ext.getCmp("TextFileName").getValue(),
							type : Ext.getCmp("TextType").getValue(),
							filetype : Ext.getCmp("TextFileType").getValue(),
							eitype : Ext.getCmp("TextEIType").getValue()
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
					Ext.getCmp("TextFileName").reset();
					Ext.getCmp("TextType").reset();
					Ext.getCmp("TextFileType").reset();
					Ext.getCmp("TextEIType").reset();
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
				items : ['配置名', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFileName'),
							id : 'TextFileName'
						}, '-',
						'模板类型', {
							xtype : 'textfield',
							id : 'TextType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextType')
						}, '-', 
						'文件类型',{
							xtype : 'combo',
							id:'TextFileType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFileType'),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['E','Excel'],
									      ['G','Gof']
								     ]
							})
						}, '-', 
						'导入导出类型',{
							xtype : 'combo',
							id:'TextEIType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextEIType'),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['I','Import'],
									      ['E','Export']
								     ]
							})
						},'-', btnSearch, '-', btnRefresh, '->'
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
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						}, {
							header : '配置名',
							sortable : true,
							dataIndex : 'EILFileName'
						}, {
							header : '模板类型',
							sortable : true,
							dataIndex : 'EILType'
						}, {
							header : '文件类型',
							sortable : true,
							dataIndex : 'EILFileType',
							renderer:function(value)
            				{
			            		if (value=="E")
			            		{
			            		   return "Excel";
			            		}
			            		if (value=="G")
			            		{
			            		   return "Gof";
			            		}
			            	}
							
						}, {
							header : '导入导出类型',
							sortable : true,
							dataIndex : 'EILEIType',
							renderer:function(value)
            				{
			            		if (value=="I")
			            		{
			            		   return "Import";
			            		}
			            		if (value=="E")
			            		{
			            		   return "Export";
			            		}
			            	}
						}, {
							header : '开始sheet',
							sortable : true,
							dataIndex : 'EILStartSheet'
						}, {
							header : '结束sheet',
							sortable : true,
							dataIndex : 'EILEndSheet'
						}, {
							header : '起读行数',
							sortable : true,
							dataIndex : 'EILStartRow'
						}],
				stripeRows : true,
				loadMask: { msg: '数据加载中,请稍候...' },
    			title: '导入导出基础配置',
				//stateful : true,// 记录表格状态
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
				if (grid.selModel.hasSelection()) {
					win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
		                success : function(form,action) {
		                	//Ext.Msg.alert('编辑','载入成功！');
		                	sheetDisabled();
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
		
	});

	/** 布局 */
	var viewport = new Ext.Viewport({
				id:'vp',
				layout : 'border',
				items : [grid]
			});
			
	/** 调用keymap */

    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
});
 
