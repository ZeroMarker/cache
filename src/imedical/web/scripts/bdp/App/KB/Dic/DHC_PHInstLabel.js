/// 名称: 知识库目录字典表维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-10-31
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHInstLabel";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=DeleteData";
	var Lib_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibaryLabel&pClassQuery=GetDataForCmb1";
	var ORDER_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=SaveOrder";
	var DRAG_ORDER_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHInstLabel&pClassMethod=SaveDragOrder";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var up = new Ext.Action({
	    text : 'Up',
	    id:'up',
	    //iconCls : 'icon-up',
	    icon : '../scripts/bdp/Framework/imgs/up.gif',//或者添加样式iconCls
	    //disabled : true,
	    handler : function() {
	        var record = grid.getSelectionModel().getSelected();
		
	        if (record) {
	            var index = grid.store.indexOf(record);
	          // alert("index"+index+"^"+"PINLOrderNum"+record.get('PINLOrderNum')+"^PINLRowID"+record.get('PINLRowID'))
	            if (index > 0) {
	            	var checkId=record.get('PINLRowID')
	            	var upId=grid.getStore().getAt(index-1).get('PINLRowID')
	            	 //alert(index+"^"+checkId+"^"+upId)
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':upId
								},
							callback:function(options,success,response){
									if(success){	
										/*grid.store.removeAt(index);
						                grid.store.insert(index - 1, record);
						                grid.getView().refresh(); // refesh the row number
						                grid.getSelectionModel().selectRow(index - 1);*/
						             grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
									 setTimeout(function(){
									        grid.selModel.selectRows([0,index-1]);
									 },300); 
						  			}
								}
					})	
	            	//alert(checkId+upId)
	               
	            }

	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
	    }
	});

	var down = new Ext.Action({
	    text : 'Down',
	    icon : '../scripts/bdp/Framework/imgs/down.gif',//或者添加样式iconCls
	    //iconCls : 'icon-down',
	    //disabled : true,
	    handler : function() {
	        var record = grid.getSelectionModel().getSelected();
	        if (record) {
	            var index = grid.store.indexOf(record);
	            if (index < grid.store.getCount() - 1) {
	            	var checkId=record.get('PINLRowID')
	            	var downId=grid.getStore().getAt(index+1).get('PINLRowID')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':downId
								},
							callback:function(options,success,response){
									if(success){
										grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
										setTimeout(function(){
									        grid.selModel.selectRows([0,index+1]);
										 },300);
					/*grid.store.removeAt(index);
	                grid.store.insert(index + 1, record);
	                grid.getView().refresh(); // refesh the row number
	                grid.getSelectionModel().selectRow(index + 1);*/
						  			}
								}
					})
					             
	            }
	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
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
											'id' : rows[0].get('PINLRowID')
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
				labelWidth : 160,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PINLRowID',mapping:'PINLRowID',type:'string'},
                                         {name: 'PINLCode',mapping:'PINLCode',type:'string'},
                                         {name: 'PINLDesc',mapping:'PINLDesc',type:'string'},
                                         {name: 'PINLOrderNum',mapping:'PINLOrderNum',type:'int'},
                                         {name: 'PINLManageMode',mapping:'PINLManageMode',type:'string'},
                                         {name: 'PINLLabelDr',mapping:'PINLLabelDr',type:'string'},
                                         {name: 'PINLIcon',mapping:'PINLIcon',type:'string'},
                                         {name: 'PINLAlertMsg',mapping:'PINLAlertMsg',type:'string'},
                                         {name: 'PINLGenFlag',mapping:'PINLGenFlag',type:'string'},
                                         {name: 'PINLProFlag',mapping:'PINLProFlag',type:'string'},
                                         {name: 'PINLAllFlag',mapping:'PINLAllFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PINLRowID',
							hideLabel : 'True',
							hidden : true,
							name : 'PINLRowID'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PINLCode',
							id:'PINLCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHInstLabel";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PINLRowID'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
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
							name : 'PINLDesc',
							id:'PINLDescF',
							hiddenName:'PINLDesc',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLDescF')),
							editable:false,
							allowBlank : false
							
						}, {
							fieldLabel : '知识库标识',
							hiddenName : 'PINLLabelDr',
							id:'PINLLabelDrF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLLabelDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLLabelDrF')),
   							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							//allowBlank : false,
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url :Lib_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHLIRowId',mapping:'PHLIRowId'},
										{name:'PHLIDesc',mapping:'PHLIDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'PHLIDesc',
							valueField : 'PHLIRowId'
						},{
							xtype : 'numberfield',
							fieldLabel : '顺序',
							name : 'PINLOrderNum',
							id:'PINLOrderNumF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLOrderNumF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLOrderNumF')),
							//allowBlank : false,
							allowDecimals : false, //不允许输入小数
							minValue : 0,
							minText : '顺序不能小于0',
							nanText : '顺序只能是数字',
							listeners:{
								'beforerender':function(){
									 //if(win.title=='添加'){ 
									 	//var  ordNum = grid.store.getCount()+1;
									 	//Ext.getCmp("PINLOrderNumF").setValue(ordNum)
									// }
								}
							}
						}, {
							xtype : 'combo',
							fieldLabel : '管理模式',
							name : 'PINLManageMode',
							hiddenName : 'PINLManageMode',
							id:'PINLManageModeF',
							editable:false,
							//allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLManageModeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLManageModeF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['W','警示'],
									      ['C','管控'],
									      ['S','统计']
								     ]
							})
						},{
							fieldLabel : '图标路径',
							name : 'PINLIcon',
							id:'PINLIconF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLIconF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLIconF'))
						},{
							fieldLabel : '提示消息',
							name : 'PINLAlertMsg',
							id:'PINLAlertMsgF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLAlertMsgF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLAlertMsgF'))
						},{
							fieldLabel:'是否全部通过',
							xtype : 'checkbox',
							name : 'PINLAllFlag',
							id:'PINLAllFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLAllFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLAllFlagF'))
						},{
							fieldLabel:'在药品通用名目录显示',
							xtype : 'checkbox',
							name : 'PINLGenFlag',
							id:'PINLGenFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLGenFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLGenFlagF'))
						},{
							fieldLabel:'在药品商品名目录显示',
							xtype : 'checkbox',
							name : 'PINLProFlag',
							id:'PINLProFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PINLProFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PINLProFlagF'))
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 600,
					height:500,
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
							var tempCode = Ext.getCmp("form-save").getForm().findField("PINLCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("PINLDesc").getValue();
							
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
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											params : {
												'PINLCode' : grid.getSelectionModel().getSelections()[0].get('PINLCode')   ///code只读，修改时禁用的话参数传不到，要单独传。
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
							var tempCode = Ext.getCmp("form-save").getForm().findField("PINLCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("PINLDesc").getValue();
							
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
											var sequence = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetLastOrder");
											Ext.getCmp("PINLOrderNumF").setValue(sequence)
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
							Ext.getCmp("form-save").getForm().findField("PINLCode").focus(true,800);
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
					var flagcode=Ext.BDP.FunLib.Component.DisableFlag('PINLCodeF');
					Ext.getCmp("PINLCodeF").setDisabled(flagcode);
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					
					var sequence = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetLastOrder");
					Ext.getCmp("PINLOrderNumF").setValue(sequence)
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
			        	Ext.getCmp("PINLCodeF").setDisabled(true)  ///代码不可修改
			        	var _record = grid.getSelectionModel().getSelected();
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('PINLRowID'),
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
									name : 'PINLRowID',
									mapping : 'PINLRowID',
									type : 'string'
								}, {
									name : 'PINLCode',
									mapping : 'PINLCode',
									type : 'string'
								}, {
									name : 'PINLDesc',
									mapping : 'PINLDesc',
									type : 'string'
								}, {
									name : 'PINLOrderNum',
									mapping : 'PINLOrderNum',
									type : 'int'
								}, {
									name : 'PINLManageMode',
									mapping : 'PINLManageMode',
									type : 'string'
								},{
									name : 'PHLIRowId',
									mapping : 'PHLIRowId',
									type : 'string'
								}, {
									name : 'PINLLabelDr',
									mapping : 'PINLLabelDr',
									type : 'string'
								}, {
									name : 'PINLIcon',
									mapping : 'PINLIcon',
									type : 'string'
								}, {
									name : 'PINLAlertMsg',
									mapping : 'PINLAlertMsg',
									type : 'string'
								},{
									name : 'PINLAllFlag',
									mapping : 'PINLAllFlag',
									type : 'string'
								},{
									name : 'PINLGenFlag',
									mapping : 'PINLGenFlag',
									type : 'string'
								},{
									name : 'PINLProFlag',
									mapping : 'PINLProFlag',
									type : 'string'
								}// 列的映射
						]),
				sortInfo: {field: 'PINLOrderNum', direction: 'asc'}
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
							desc : Ext.getCmp("TextDesc").getValue(),
							lib : Ext.getCmp("TextLib").getValue()
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
					Ext.getCmp("TextLib").reset();
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
						},'-', 
						'知识库标识',{
							fieldLabel : '知识库标识',
							hiddenName : 'PINLLabelDr',
							id : 'TextLib',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextLib'),
   							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							//allowBlank : false,
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url :Lib_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHLIRowId',mapping:'PHLIRowId'},
										{name:'PHLIDesc',mapping:'PHLIDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'PHLIDesc',
							valueField : 'PHLIRowId'
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
							header : 'PINLRowID',
							sortable : true,
							dataIndex : 'PINLRowID',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'PINLCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'PINLDesc'
						}, {
							header : '知识库标识字典rowid',
							sortable : true,
							dataIndex : 'PHLIRowId',
							hidden:true
						},{
							header : '知识库标识',
							sortable : true,
							dataIndex : 'PINLLabelDr'
						}, {
							header : '顺序',
							sortable : true,
							dataIndex : 'PINLOrderNum'
						}, {
							header : '管理模式',
							sortable : true,
							dataIndex : 'PINLManageMode',
							renderer:function(value){
										if(value=="W"){
											value="警示"
			            		  			return "<span style='color:black;<font size=15>;'>"+value+"</span>";
										}
										if(value=="C"){
											value="管控"
			            		  			return "<span style='color:black;<font size=15>;'>"+value+"</span>";
										}
										if(value=="S"){
											value="统计"
			            		  			return "<span style='color:black;<font size=15>;'>"+value+"</span>";
										}							
									}
						},{
							header : '提示消息',
							sortable : true,
							dataIndex : 'PINLAlertMsg'
						},{
							header : '图标路径',
							sortable : true,
							dataIndex : 'PINLIcon'
						},  {
							header : '是否全部通过',
							sortable : true,
							dataIndex : 'PINLAllFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '在药品通用名目录显示',
							sortable : true,
							dataIndex : 'PINLGenFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '在药品商品名目录显示',
							sortable : true,
							dataIndex : 'PINLProFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
				           	header:"上移/下移",
							dataIndex : 'PINLRowID',
				            width:50,
				            renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
				            			var formatStr1 = '<img src="../scripts/bdp/Framework/imgs/up.gif" onclick="javascript:return false;" class="upBtn" ></img>';   
				         				var resultStr1 = String.format(formatStr1); 
				         				var formatStr2 = '<img src="../scripts/bdp/Framework/imgs/down.gif" onclick="javascript:return false;" class="downBtn" ></img>';   
				         				var resultStr2 = String.format(formatStr2);
				         				if(rowIndex==0){
				         					value ='<div>'+resultStr2+'</div>';
				         				}
				         				else if(rowIndex==grid.store.getCount()-1){
				         					value ='<div>'+resultStr1+'</div>';
				         				}
				         				else{
				         					value='<div>' + resultStr1 +" / " +resultStr2+'</div>';
				         				}
				         				if(grid.store.getCount()==1){
				         					value=""
				         				}	
				         				return value	            	
				            }.createDelegate(this)
								    
				        }],
				stripeRows : true,
				title : '知识库目录字典表',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid',
				
				enableDragDrop : true,
    			ddGroup: "GridDD",
				listeners : {
			        'afterrender' : function() {		        		
			            var ddrow = new Ext.dd.DropTarget(grid.container, {  
			                ddGroup : 'GridDD',  
			                copy    : false,  
			                notifyDrop : function(dd, e, data) {		                
			                    var rows = data.selections;  
			                    var index = dd.getDragData(e).rowIndex;
			                    var rowid =rows[0].get('PINLRowID')
			                    var page=document.getElementById('ext-comp-1009').value
			                    var start=(page-1)*pagesize_main
			                   	//alert("index"+index+"^"+"PINLLabelDr"+rows[0].get('PHLIRowId')+"^PINLRowID"+rows[0].get('PINLRowID'))
			                  if(typeof(index) == "undefined") return; 
			                   for(i = 0; i < rows.length; i++) {		                
			                        if(!this.copy) {
			                            grid.getStore().remove(rows[i]);
			                            grid.getStore().insert(index, rows[i]);  
			                            grid.view.refresh();			                         
			                            grid.getSelectionModel().selectRow(index);
			                        }
			                    }
			                    var orderId=""
			                    var afterOrder=""
			                    //遍历列表
							    grid.store.each(function (record) {
							        if(orderId.length == 0)
							        {
							            orderId = record.data.PINLRowID;
							            afterOrder=record.data.PINLOrderNum;
							        }
							        else
							        {
							           orderId += "^"+record.data.PINLRowID
							           afterOrder+= "^"+record.data.PINLOrderNum;
							        }
							    });
							    //alert(orderId+"||"+afterOrder)
								Ext.Ajax.request({											
								url:DRAG_ORDER_ACTION_URL,
								method:'post', 
								params:{
									'orderId':orderId,
									'afterOrder':afterOrder
									},
								callback:function(options,success,response){
										if(success){
							             grid.getStore().load({
											params : {
														start : start,
														limit : pagesize_main
													}
											});
										 setTimeout(function(){
										        grid.selModel.selectRows([0,index]);
										 },300); 
							  			}
									}
								})	
							 
			                }
			            });
			        }
				}
			        
			});

/**已选列表上移或下移操作**/
	grid.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
		var upbtn = e.getTarget('.upBtn');
		var downbtn = e.getTarget('.downBtn');
		if(upbtn){
		 var record = grid.getSelectionModel().getSelected();	
	        if (record) {
	            var index = grid.store.indexOf(record); 
	          // alert("index"+index+"^"+"PINLOrderNum"+record.get('PINLOrderNum')+"^PINLRowID"+record.get('PINLRowID'))
	            if (index > 0) {
	            	var checkId=record.get('PINLRowID')
	            	var upId=grid.getStore().getAt(index-1).get('PINLRowID')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':upId
								},
							callback:function(options,success,response){
									if(success){	
						             grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
									 setTimeout(function(){
									        grid.selModel.selectRows([0,index-1]);
									 },300); 
						  			}
								}
					})	
	            	//alert(checkId+upId)
	               
	            }

	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
		if(downbtn){
			 var record = grid.getSelectionModel().getSelected();
	        if (record) {
	            var index = grid.store.indexOf(record);
	            if (index < grid.store.getCount() - 1) {
	            	var checkId=record.get('PINLRowID')
	            	var downId=grid.getStore().getAt(index+1).get('PINLRowID')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':downId
								},
							callback:function(options,success,response){
									if(success){
										grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
										setTimeout(function(){
									        grid.selModel.selectRows([0,index+1]);
										 },300);
						  			}
								}
					})
					             
	            }
	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
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
		        	Ext.getCmp("PINLCodeF").setDisabled(true);
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PINLRowID'),
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
