/// 名称: 诊断字典维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-11-3
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCExtIcdFeild";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	CanUpdate=function(id){
		var RefText =tkMakeServerCall("web.DHCBL.KB.DHCExtIcdFeild","GetRefFlag",id);
		if (RefText.indexOf("诊断与his诊断对照")>0){
			return true
		}else{
			return false
		}
	}
	
			/************************关联症状*************************************/
	var btnSym = new Ext.Toolbar.Button({
			text : '关联症状',
			tooltip : '关联症状',
			iconCls : 'icon-DP',
			id : 'btnSym',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSym'),
	      	handler: ConLab=function () {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 };
				if(recordsLen > 1){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择其中一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('ICDDesc');
					    var itemRowId=rows[0].get('ICDRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHDisLinkSym&selectrow="+itemRowId; 
						var windowSym = new Ext.Window({
										iconCls : 'icon-DP',
										width : 780,
										height : 480,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										autoScroll : false,
										collapsible : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
											    	keymap_main.disable();
											    }
											},
											"hide" : function(){
											},
											"close" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
													keymap_main.enable();
											    }
											}
										}
									});
						windowSym.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowSym.setTitle(itemdesc);
						windowSym.show();
				}
	      }	
    });
		/************************关联证型*************************************/
	var btnSyn = new Ext.Toolbar.Button({
			text : '关联证型',
			tooltip : '关联证型',
			iconCls : 'icon-DP',
			id : 'btnSyn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSyn'),
	      	handler: ConLab=function () {			        
				var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 };
				if(recordsLen > 1){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择其中一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
				  }
				 else{
				        var gsm = grid.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('ICDDesc');
					    var itemRowId=rows[0].get('ICDRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHSyndromeIcd&selectrow="+itemRowId; 
						var windowSyn = new Ext.Window({
										iconCls : 'icon-DP',
										width : 780,
										height : 480,
										layout : 'fit',
										plain : true,// true则主体背景透明
										modal : true,
										frame : true,
										autoScroll : false,
										collapsible : true,
										hideCollapseTool : true,
										titleCollapse : true,
										constrain : true,
										closeAction : 'close',
										html : '',
										listeners : {
											"show" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
											    	keymap_main.disable();
											    }
											},
											"hide" : function(){
											},
											"close" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
													keymap_main.enable();
											    }
											}
										}
									});
						windowSyn.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowSyn.setTitle(itemdesc);
						windowSyn.show();
				}
	      }	
    });
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
											'id' : rows[0].get('ICDRowId')
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
                                        [{name: 'ICDRowId',mapping:'ICDRowId',type:'string'},
                                         {name: 'ICDCode',mapping:'ICDCode',type:'string'},
                                         {name: 'ICDDesc',mapping:'ICDDesc',type:'string'},
                                         {name: 'ICDType',mapping:'ICDType',type:'string'},
                                         {name: 'ICDAcitveFlag',mapping:'ICDAcitveFlag',type:'string'},
                                         {name: 'ICDSysFlag',mapping:'ICDSysFlag',type:'string'},
                                         {name: 'ICDOpStatus',mapping:'ICDOpStatus',type:'string'},
                                         {name: 'ICDRemark',mapping:'ICDRemark',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ICDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ICDRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'ICDCode',
							id:'ICDCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCExtIcdFeild";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ICDRowId'); //此条数据的rowid
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
							name : 'ICDDesc',
							id:'ICDDescF',
							hiddenName:'ICDDesc',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDDescF')),
							editable:false,
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCExtIcdFeild"; //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ICDRowId'); //此条数据的rowid
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
						},  {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>类型',
							name : 'ICDType',
							hiddenName : 'ICDType',
							id:'ICDTypeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDTypeF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							editable: false	,
							allowBlank : false,
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['9','ICD9'],
									      ['10','ICD10'],
									      ['99','非ICD']
								     ]
							})
						}, {
							fieldLabel:'是否可用',
							xtype : 'checkbox',
							name : 'ICDAcitveFlag',
							id:'ICDAcitveFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDAcitveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDAcitveFlagF'))
						},{
							fieldLabel:'系统标识',
							xtype : 'checkbox',
							name : 'ICDSysFlag',
							id:'ICDSysFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDSysFlagF'))
						}, {
							xtype : 'combo',
							fieldLabel : '操作状态',
							name : 'ICDOpStatus',
							hiddenName : 'ICDOpStatus',
							id:'ICDOpStatusF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDOpStatusF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDOpStatusF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							editable: false	,
							//allowBlank : false,
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['0','放弃'],
									      ['1','确认']
								     ]
							})
						},{
							fieldLabel:'备注',
							xtype:'textarea',
							height:100,
							name : 'ICDRemark',
							id:'ICDRemarkF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ICDRemarkF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ICDRemarkF'))
						}]
			});
	
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 420,
					height:430,
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
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("ICDCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("ICDDesc").getValue();
							var tempType = Ext.getCmp("form-save").getForm().findField("ICDType").getValue();
			
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
										var icdid=grid.getSelectionModel().getSelections()[0].get('ICDRowId')
										var disableFlag=CanUpdate(icdid)
										var code="",desc=""
							        	Ext.getCmp("ICDCodeF").setDisabled(disableFlag);
							        	Ext.getCmp("ICDDescF").setDisabled(disableFlag);
							        	if(disableFlag==true)
							        	{
							        		var code=grid.getSelectionModel().getSelections()[0].get('ICDCode');
							        		var desc=grid.getSelectionModel().getSelections()[0].get('ICDDesc');
							        	}
							        	else
							        	{
							        		var code=Ext.getCmp("ICDCodeF").getValue();
							        		var desc=Ext.getCmp("ICDDescF").getValue();
							        	}
							        	
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											params : {
												'ICDCode' : code,   ///code只读，修改时禁用的话参数传不到，要单独传。
												'ICDDesc' : desc   ///desc只读，修改时禁用的话参数传不到，要单独传。
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
					},{
						text : '继续添加',
						id:'resave_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("ICDCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("ICDDesc").getValue();
							var tempType = Ext.getCmp("form-save").getForm().findField("ICDType").getValue();
							
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
							Ext.getCmp("form-save").getForm().findField("ICDCode").focus(true,800);
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
				handler :AddData= function () {
					var flagcode=Ext.BDP.FunLib.Component.DisableFlag('ICDCodeF');
					Ext.getCmp("ICDCodeF").setDisabled(flagcode);
					var flagdesc=Ext.BDP.FunLib.Component.DisableFlag('ICDDescF');
					Ext.getCmp("ICDDescF").setDisabled(flagdesc);
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
			        	var disableFlag=CanUpdate(_record.get('ICDRowId'))
			        	Ext.getCmp("ICDCodeF").setDisabled(disableFlag);
			        	Ext.getCmp("ICDDescF").setDisabled(disableFlag);
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ICDRowId'),
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
									name : 'ICDType',
									mapping : 'ICDType',
									type : 'float'
								}, {
									name : 'ICDAcitveFlag',
									mapping : 'ICDAcitveFlag',
									type : 'string'
								}, {
									name : 'ICDSysFlag',
									mapping : 'ICDSysFlag',
									type : 'string'
								},{
									name : 'ICDOpStatus',
									mapping : 'ICDOpStatus',
									type : 'string'
								}, {
									name : 'ICDRemark',
									mapping : 'ICDRemark',
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
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnSym,'-',btnSyn]
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
							header : 'ICDRowId',
							sortable : true,
							dataIndex : 'ICDRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'ICDCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'ICDDesc'
						}, {
							header : '类型',
							sortable : true,
							dataIndex : 'ICDType',
							renderer:function(value){
								if(value=="9"){
									value="ICD9"
									return value
								}
								if(value=="10"){
									value="ICD10"
									return value
								}
								if(value=="99"){
									value="非ICD"
									return value
								}
							}
						},  {
							header : '是否可用',
							sortable : true,
							dataIndex : 'ICDAcitveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header : '系统标识',
							sortable : true,
							dataIndex : 'ICDSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
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
						}],
				stripeRows : true,
				title : '诊断字典',
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
		        	var disableFlag=CanUpdate(_record.get('ICDRowId'))
		        	Ext.getCmp("ICDCodeF").setDisabled(disableFlag);
		        	Ext.getCmp("ICDDescF").setDisabled(disableFlag);
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ICDRowId'),
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
