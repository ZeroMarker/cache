/// 名称: 科室字典维护
/// 描述: 包含增删改查功能,还包含与诊断关联功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-7-15
document.write('<script type="text/javascript" src="../scripts/bdp/App/KB/Dic/DHC_PHDiseaseComList.js"> </script>');
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
/**********************************科室字典表***********************************/
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHHospLoc";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLoc&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	CanUpdate=function(id){
		var RefText =tkMakeServerCall("web.DHCBL.KB.DHCPHHospLoc","GetRefFlag",id);
		if (RefText.indexOf("科室字典对照")>0){
			return true
		}else{
			return false
		}
	}
	 //清空选中的表头全选框checkbox  
	 function clearCheckGridHead(grid){  
	  	var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');    
	     var hd = hd_checker.first();   
	     hd.removeClass('x-grid3-hd-checker-on'); 
	 } 
	 
	 	/** ****************************清空已对照数据 *************************/
	function clearSubWin() {
			gridWestS.getStore().removeAll()
			document.getElementById('ext-comp-1039').innerHTML="没有记录",
			document.getElementById('ext-comp-1035').innerHTML="页,共 1 页",
			document.getElementById('ext-comp-1034').value="1"
	}
    /************************主表科室字典部分*************************************/
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
											'id' : rows[0].get('HOSPLRowId')
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
															gridWestS.getStore().removeAll();
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
                                        [{name: 'HOSPLRowId',mapping:'HOSPLRowId',type:'string'},
                                         {name: 'HOSPLCode',mapping:'HOSPLCode',type:'string'},
                                         {name: 'HOSPLDesc',mapping:'HOSPLDesc',type:'string'},                                   
                                         {name: 'HOSPLActiveFlag',mapping:'HOSPLActiveFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'HOSPLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'HOSPLRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'HOSPLCode',
							id:'HOSPLCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPLCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPLCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHHospLoc";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('HOSPLRowId'); //此条数据的rowid
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
							name : 'HOSPLDesc',
							id:'HOSPLDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPLDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPLDescF')),
							editable:false,
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }

	                            var className =  "web.DHCBL.KB.DHCPHHospLoc"; //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名
	                           
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('HOSPLRowId'); //此条数据的rowid
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
							name : 'HOSPLActiveFlag',
							id:'HOSPLActiveFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPLActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPLActiveFlagF'))
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
					width : 480,
					height:400,
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
					items : tabs,
					buttons : [{
						text : '保存',
						id:'save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("HOSPLCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("HOSPLDesc").getValue();
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
															gridWestS.getStore().removeAll();
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
										var locid=grid.getSelectionModel().getSelections()[0].get('HOSPLRowId')
										var disableFlag=CanUpdate(locid)
										var code="",desc=""
							        	Ext.getCmp("HOSPLCodeF").setDisabled(disableFlag);
							        	Ext.getCmp("HOSPLDescF").setDisabled(disableFlag);
							        	if(disableFlag==true)
							        	{
							        		var code=grid.getSelectionModel().getSelections()[0].get('HOSPLCode');
							        		var desc=grid.getSelectionModel().getSelections()[0].get('HOSPLDesc');
							        	}
							        	else
							        	{
							        		var code=Ext.getCmp("HOSPLCodeF").getValue();
							        		var desc=Ext.getCmp("HOSPLDescF").getValue();
							        	}
										
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											params : {
												'HOSPLCode' : code,   ///code只读，修改时禁用的话参数传不到，要单独传。
												'HOSPLDesc' : desc   ///desc只读，修改时禁用的话参数传不到，要单独传。
											},
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													win.hide();
													var disrowid = action.result.id;
													var myrowid = "rowid=" + disrowid;
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
					},{
						text : '继续添加',
						id:'resave_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("HOSPLCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("HOSPLDesc").getValue();
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
											Ext.getCmp("form-save").getForm().reset();
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
							Ext.getCmp("form-save").getForm().findField("HOSPLCode").focus(true,800);
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
					//常用名和别名			        
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					
					//激活基本信息面板

		            tabs.setActiveTab(0);
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
				        var disableFlag=CanUpdate(_record.get('HOSPLRowId'))
			        	Ext.getCmp("HOSPLCodeF").setDisabled(disableFlag);
			        	Ext.getCmp("HOSPLDescF").setDisabled(disableFlag);
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						//激活基本信息面板
				        tabs.setActiveTab(0);	        
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('HOSPLRowId'),
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
									name : 'HOSPLRowId',
									mapping : 'HOSPLRowId',
									type : 'string'
								}, {
									name : 'HOSPLCode',
									mapping : 'HOSPLCode',
									type : 'string'
								}, {
									name : 'HOSPLDesc',
									mapping : 'HOSPLDesc',
									type : 'string'
								},{
									name : 'HOSPLActiveFlag',
									mapping : 'HOSPLActiveFlag',
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
					var desc=Ext.getCmp("TextDesc").getValue();
					grid.getStore().baseParams={			
							desc : desc
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
				handler : Refresh=function () {
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
					gridWestS.getStore().removeAll()
					clearSubWin();
					}
				});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						'搜索框', {
							xtype : 'textfield',
							width:150,
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
				region : 'north',
				height:300,
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'HOSPLRowId',
							sortable : true,
							dataIndex : 'HOSPLRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'HOSPLCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'HOSPLDesc',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : '是否可用',
							sortable : true,
							//hidden : true,
							dataIndex : 'HOSPLActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
							
						}],
				stripeRows : true,
				title : '科室字典',
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


/*********************************已关联表***************************************/
  var QUERY_CON_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassQuery=GetList";
  var DELETE_CON_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassMethod=DeleteData";
  /** 已关联grid数据存储 */
	var dsWestS = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CON_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'LOCIRowId',
							mapping : 'LOCIRowId',
							type : 'string'
						},{
							name : 'LOCILOCDr',
							mapping : 'LOCILOCDr',
							type : 'string'
						},{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						},{
							name : 'LOCIICDDr',
							mapping : 'LOCIICDDr',
							type : 'string'
						},{
							name : 'ICDOpStatus',
							mapping : 'ICDOpStatus',
							type : 'string'
						},{
							name : 'ICDRemark',
							mapping : 'ICDRemark',
							type : 'string'
						}// 列的映射
				])
	});
	/** 已关联grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestS
	}); 
	/**加载分页参数**/
	dsWestS.on('beforeload',function(){ 
		if(dsWestS.getCount()!='0'){
			if(grid.getSelectionModel().getCount()!=0){
				Ext.apply(this.baseParams,{parref:grid.getSelectionModel().getSelections()[0].get('HOSPLRowId')})
			}
		}
	});  
	/** 已关联grid加载数据 */
	dsWestS.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** 已关联grid分页工具条 */
	var pagingWestS = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWestS,
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
	/** 创建已关联grid */
	var gridWestS = new Ext.grid.GridPanel({
		id : 'gridWestS',
		region : 'center',
		closable : true,
		store : dsWestS,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
			{
					header : 'rowid',
					sortable : true,
					dataIndex : 'LOCIRowId',
					hidden : true
				},{
					header : '科室',
					sortable : true,
					dataIndex : 'LOCILOCDr'
				},{
					header : '诊断rowid',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden:true
				},{
					header : '诊断',
					sortable : true,
					dataIndex : 'LOCIICDDr'
				},{
					header : '操作状态',
					sortable : true,
					dataIndex : 'ICDOpStatus',
					renderer:function(value){
						if(value=="0"){
							value="放弃"
							return value
						}
						if(value=="1"){
							value="确认"
							return value
						}
					}
				},{
					header : '备注',
					sortable : true,
					dataIndex : 'ICDRemark',
					renderer: Ext.BDP.FunLib.Component.GirdTipShow
				},{
					header : '操作',
					dataIndex : 'PHLCRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '已关联诊断',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestS,
		stateId : 'gridWestS'
	});
	
	var isdblclick;
	/**查询已关联*/
	 grid.on("rowclick", function(grid, rowIndex, e){
	 	isdblclick=false;
	    window.setTimeout(rowclickFn, 500);
	    function rowclickFn(){
	        if(isdblclick!=false)return;
		 	var id = grid.getSelectionModel().getSelections()[0].get('HOSPLRowId');
		 	gridWestS.getStore().load({
				params : {
					parref : id,
					start : 0,
					limit : pagesize_main
				}
			});
	    }
	 });
	 	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				isdblclick=true;
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
		        	var disableFlag=CanUpdate(_record.get('HOSPLRowId'))
		        	Ext.getCmp("HOSPLCodeF").setDisabled(disableFlag);
		        	Ext.getCmp("HOSPLDescF").setDisabled(disableFlag);
		        	//常用名和别名
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					 //激活基本信息面板
			        tabs.setActiveTab(0);
			        //加载别名面板
			        var _record = grid.getSelectionModel().getSelected();
					
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('HOSPLRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });

		        }
			});
	 
	/**删除**/
	gridWestS.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		Ext.MessageBox.confirm('提示','确定撤销该关联数据吗?', function(button) {
	 		if(button=="yes"){
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行		
				Ext.Ajax.request({
					url : DELETE_CON_ACTION_URL,
					method : 'POST',
					params : {
						'id' : rows[0].get('LOCIRowId')
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '关联撤销成功!',
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
										if(grid.getSelectionModel().getCount()!='0'){
											var id = grid.getSelectionModel().getSelections()[0].get('HOSPLRowId');
										}
										grid.getStore().load({
											params : {
													id : id,
													start : startIndex,
													limit : pagesize_main
												}
												});
										//诊断列表重新加载
										gridICD.getStore().baseParams={			
												desc : Ext.getCmp("TextICDDesc").getValue(),
												con : Ext.getCmp("TextCon").getValue()
										};
										gridICD.getStore().load({
											params : {
														start : 0,
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
	 		}
	});
/************************************West***********************************************/
var gridWest = new Ext.Panel({
		id : 'gridWest',
		title:'科室和诊断关联',
		region : 'west',
		width:760,
		split:true,
		collapsible:true,
		layout:'border',
		items:[grid,gridWestS]
})


/**********************************Center 诊断字典表*************************************/
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassQuery=GetDataForLoc";
var SAVE_ACTION_URL_ICD = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHHospLocIcd&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHHospLocIcd";
	/** grid数据存储 */
	var dsICD = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						}, {
							name : 'ICDCode',
							mapping : 'ICDCode',
							type : 'string'
						}, {
							name : 'ICDDesc',
							mapping : 'ICDDesc',
							type : 'string'
						}, {
							name : 'ConFlag',
							mapping : 'ConFlag',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsICD
	});

	/** grid加载数据 */
	dsICD.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingICD = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsICD,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_main=this.pageSize;
				clearCheckGridHead(gridICD);  //重置全选按钮
			}
		}
	});
		/** 工具条 */
	
		/** 搜索按钮 */
	var btnICDSearch = new Ext.Button({
				id : 'btnICDSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDSearch'),
				iconCls : 'icon-search',
				text : '',
				handler : function() {
					gridICD.getStore().baseParams={			
							desc : Ext.getCmp("TextICDDesc").getValue(),
							con : Ext.getCmp("TextCon").getValue()
					};
					gridICD.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	/** 重置按钮 */
	var btnICDRefresh = new Ext.Button({
				id : 'btnICDRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDRefresh'),
				iconCls : 'icon-refresh',
				text : '',
				handler :  RefreshICDData=function (){
					Ext.getCmp("TextICDDesc").reset();
					Ext.getCmp("TextCon").reset();
					clearCheckGridHead(gridICD);  //重置全选按钮
					//Ext.getCmp("textType").reset();
					gridICD.getStore().baseParams={};
					gridICD.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}
				});
				
		var btnICDSave = new Ext.Button({			
					xtype : 'button',
					text : '关联',
					icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
					id:'btnICDSave',
	   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDSave'),
					handler : function SaveData() {
						var rs=gridICD.getSelectionModel().getSelections();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						if(rs.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请选择需要保存的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else if(rows.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请先选择一条科室记录进行关联!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else{
							var fieldStr = "";
							var selectrow=rows[0].get('HOSPLRowId')
							Ext.each(rs,function(){
								if(fieldStr!="") fieldStr = fieldStr+",";
								var fieldDR=this.get('ICDRowId');//诊断id
								fieldStr = fieldStr+fieldDR;
							})
								Ext.Ajax.request({
									url : SAVE_ACTION_URL_ICD , 		
									method : 'POST',	
									params : {
											'LOCIICDDr' : fieldStr,
											'LOCILOCDr':selectrow											
									},
									callback : function(options, success, response) {	
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												var myrowid = jsonData.id;

												gridWestS.getStore().load({
															params : {
																	   'parref':selectrow,
																		start : 0,
																		limit : pagesize_main
																	}
															});
												
												gridICD.getStore().load({
													params : {
														start : 0,
														limit : pagesize_main
													},
													callback : function(records, options, success) {
													}
												});
											}else{
												var errorMsg ='';
												if(jsonData.errorinfo){
													errorMsg='<br />'+jsonData.errorinfo
												}
												Ext.Msg.show({
													title:'提示',
													msg:errorMsg,
													minWidth:210,
													icon:Ext.Msg.ERROR,
													buttons:Ext.Msg.OK
												});
											}
										}
									}	
								});
					
						}
					},
					scope : this
				});
				
				
	var ICDtb = new Ext.Toolbar({
		id : 'ICDtb',
		items : [
				'描述',{
						xtype : 'textfield',
						id : 'TextICDDesc',
						emptyText : '描述',
						width : 120,
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextICDDesc'),
						enableKeyEvents : true,
						listeners : {
				       	'keyup' : function(field, e){
							gridICD.getStore().baseParams={			
									desc : Ext.getCmp("TextICDDesc").getValue(),
									con : Ext.getCmp("TextCon").getValue()
							};
							gridICD.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
							}
						}
					}, '-', '已关联', {
							fieldLabel : '标识',
							xtype : 'combo',
							id : 'TextCon',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCon'),
							emptyText:'',
							width : 60,
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							listWidth : 60,
							//value:"A",
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [ {
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}]
							})
						},'-', btnICDSearch,'-',btnICDRefresh,'-',btnICDSave
				]
	});


 

	/** 创建grid */
	var gridICD = new Ext.grid.GridPanel({
		id : 'gridICD',
		region : 'center',
		//width:240,
		//collapsed:true,
		//collapsible:true,
		closable : true,
		store : dsICD,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'ICDRowId',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden : true
				}, {
					header : '诊断代码',
					sortable : true,
					dataIndex : 'ICDCode'
					//hidden : true
				}, {
					header : '诊断描述',
					sortable : true,
					dataIndex : 'ICDDesc',
					renderer: Ext.BDP.FunLib.Component.GirdTipShow
				}, {
					header : '已关联',
					sortable : true,
					dataIndex : 'ConFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
				}],
		stripeRows : true,
		title:'诊断列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.RowSelectionModel({singleSelect:false}), // 按"Ctrl+鼠标左键"也只能单选
		sm : new Ext.grid.CheckboxSelectionModel,
		bbar : pagingICD,
		tbar:ICDtb,
		stateId : 'gridICD'
	});

	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridICD]
	});	
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
})
