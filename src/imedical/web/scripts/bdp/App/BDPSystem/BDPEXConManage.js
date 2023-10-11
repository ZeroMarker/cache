/**
 * @Title: 导出配置表管理
 * @Description:包含增删改查的功能
 * @Created on 2016-1-29 谷雪萍
 */
 
 Ext.onReady(function() {
    
	/**--------------调用后台数据用到的类方法的URL-------------------*/
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var strURL="../csp"
	//Ext.BLANK_IMAGE_URL = '../bi/js/bibdp/ext3/resources/images/default/s.gif';
	var ACTION_URL = strURL+"/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEXConfig&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = strURL+"/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEXConfig&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPEXConfig";
	var DELETE_ACTION_URL = strURL+"/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEXConfig&pClassMethod=DeleteData";
	var EILink_Dr_QUERY_ACTION_URL=strURL+"/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEILink&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEXConfig&pClassMethod=OpenData";
	
	var CHILD_ACTION_URL = strURL+"/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEXFieldConfig&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_New = strURL+"/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPEXFieldConfig&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPEXFieldConfig";
	var CHILD_DELETE_ACTION_URL = strURL+"/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPEXFieldConfig&pClassMethod=DeleteData";
	

	Ext.QuickTips.init();												   
	Ext.form.Field.prototype.msgTarget = 'qtip';                         
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.BDP.FunLib.TableName="BDPEXConManage";
	
	/*********************************在删除按钮下实现删除功能**********************************************/
	var btnDel = new Ext.Toolbar.Button({                                   
			text : '删除',													   
			id:'delete-btn',
			tooltip : '删除',												   
			iconCls : 'icon-delete',										   
			disabled:Ext.BDP.FunLib.Component.DisableFlag('delete-btn'),
			handler : function() {											  
			if (grid.selModel.hasSelection()) {                           
				var gsm = grid.getSelectionModel();				  
				var rows = gsm.getSelections();
				if(rows[0].get('ID')==""||typeof(rows[0].get('ID'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
						return;
				}
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                 
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');  
						var gsm = grid.getSelectionModel();				  
						var rows = gsm.getSelections();					  
						Ext.Ajax.request({	                              	
								url : DELETE_ACTION_URL,					 
								method : 'POST',                              
								params : {									 
									'id' : rows[0].get('ID')          
								},
								callback : function(options, success, response) {
										Ext.MessageBox.hide();
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
																if(totalnum==1){   
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)  
														   {
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}   
															}
															grid.getStore().load({
																  params : {
																				start : startIndex,
																				limit : pagesize_main
																			},
																		callback : function(records, options, success) {					
																			// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
																			clearSubWin();
																		}
																	});
															  }
														});
													} else {		 //--------如果返回的是错误的请求
														var errorMsg = '';
														if (jsonData.info) {			 
															errorMsg = '<br />错误信息:'
																	+ jsonData.info
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
																	msg : '异步通讯失败.....',
																	icon : Ext.Msg.ERROR,    
																	buttons : Ext.Msg.OK     
																});
															}
														}
												}, this);
											}
										}, this);
									} else {												   
										Ext.Msg.show({										     //--------没有选择行记录的时候
													title : '提示',
													msg : '请选择需要删除的行!',
													icon : Ext.Msg.WARNING,
													buttons : Ext.Msg.OK
												});
											}
										}
							});
	
	/** ****************************清空基本元素维护 *************************/
	function clearSubWin() {
			Ext.getCmp("TextCode2").reset();
			Ext.getCmp("TextDesc2").reset();
			BDEFgrid.setTitle("");
			BDEFds.removeAll();
			BDEFgrid.getStore().baseParams={};
			BDEFds.load({                                    
				params : {
							start : 0,
							limit : pagesize_main,
							ParRef: ""
						}
				});
			
			BDEFgrid.disable()
			
			//document.getElementById('ext-comp-1038').innerHTML="没有记录",
			//document.getElementById('ext-comp-1034').innerHTML="页,共 1 页",
			//document.getElementById('ext-comp-1033').value="1"
	}
	
		var BDET = Ext.data.Record.create([				        
								{	name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'EXCTableName',
									mapping : 'EXCTableName',
									type : 'string'
								}, {
									name : 'EXCTableDesc',
									mapping : 'EXCTableDesc',
									type : 'string'
								},{
									name: 'EXCIDName',
									mapping:'EXCIDName',
									type:'string'
								},{
									name : 'EXCXGlobal',
									mapping : 'EXCXGlobal',
									type : 'string'
								}, {
									name: 'EXCLinkGofDr',
									mapping:'EXCLinkGofDr',
									type:'string'
								},{
									name : 'EXCLinkExcelDr',
									mapping : 'EXCLinkExcelDr',
									type : 'string'
								}, {
									name: 'EXCIsChildTable',
									mapping:'EXCIsChildTable',
									type:'string'
								},{
									name : 'EXCParRefGlobal',
									mapping : 'EXCParRefGlobal',
									type : 'string'
								}
								
                       ]);
			
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
     var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ // ---------通过HttpProxy的方式读取原始数据
					url : ACTION_URL
				}),
				reader : new Ext.data.JsonReader({ // ---------将原始数据转换
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDET)
			});
		/** -------------------加载数据----------------- */
			
			
	//关联Gof配置 store
	var storeGof = new Ext.data.JsonStore({
		autoLoad : true,
		url : EILink_Dr_QUERY_ACTION_URL,
		root : 'data',
		baseParams:{
			eitype:'E',
			filetype:'G'
		},
		totalProperty : 'total',
		idProperty : 'ID',
		fields : ['ID', 'EILFileName'],
		remoteSort : true,
		sortInfo : {
			field : 'ID',
			direction : 'ASC'
		}
	});
	//关联Excel配置store
	var storeExcel = new Ext.data.JsonStore({
		autoLoad : true,
		url : EILink_Dr_QUERY_ACTION_URL,
		root : 'data',
		baseParams:{
			eitype:'E',
			filetype:'E'
		},
		totalProperty : 'total',
		idProperty : 'ID',
		fields : ['ID', 'EILFileName'],
		remoteSort : true,
		sortInfo : {
			field : 'ID',
			direction : 'ASC'
		}
	});
	//grid加载之前加载可编辑下拉框
	storeGof.load();
	storeExcel.load();
	
	ds.load({
				params : {												 
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {          
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,											      
				displayInfo : true,										  
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',  
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
			
		// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				//collapsible : true,
				title:'基本信息',
				labelAlign : 'right',
				labelWidth : 120,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'EXCTableDesc',mapping:'EXCTableDesc'},
                                         {name: 'EXCTableName',mapping:'EXCTableName'}, 
                                         {name: 'EXCIDName',mapping:'EXCIDName'},
                                         {name: 'EXCXGlobal',mapping:'EXCXGlobal'},
                                         {name: 'EXCLinkGofDr',mapping:'EXCLinkGofDr'},
                                         {name: 'EXCLinkExcelDr',mapping:'EXCLinkExcelDr'},
                                         {name: 'EXCIsChildTable',mapping:'EXCIsChildTable'},
                                         {name: 'EXCParRefGlobal',mapping:'EXCParRefGlobal'},
                                         {name: 'ID',mapping:'ID'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				defaultType : 'textfield',
				//defaultType : 'textfield',
				items : [{
							xtype:'textfield',
							fieldLabel : 'ID',
							name : 'ID',
							hideLabel : 'True',
							hidden : true
						},{
							fieldLabel : '<font color=red>*</font>表名',
							xtype:'textfield',
							id:'EXCTableName1',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('EXCTableName'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCTableName1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCTableName1')),
							name : 'EXCTableName',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPEXConfig";
	                            var classMethod = "Validate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID');
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
                            invalidText : '该表名已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
							
						},  {
							maxLength:220, //这个例外不是15
							fieldLabel : '<font color=red>*</font>中文描述',
							xtype:'textfield',
							id:'EXCTableDesc1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCTableDesc1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCTableDesc1')),
							name : 'EXCTableDesc',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPEXConfig";
	                            var classMethod = "Validate";                           
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID');
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
                            invalidText : '该中文描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}, {
							fieldLabel : 'RowId名',
							name : 'EXCIDName',
							id:'EXCIDName1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCIDName1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCIDName1'))
						}, {
							fieldLabel : '获取Global',
							name : 'EXCXGlobal',
							id:'EXCXGlobal1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCXGlobal1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCXGlobal1'))
						}, {
							xtype : 'combo',
							fieldLabel : '关联Gof配置',
							id :'EXCLinkGofDr1',
							hiddenName : 'EXCLinkGofDr',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCLinkGofDr1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCLinkGofDr1')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							listWidth:250,
							store : storeGof,
							displayField : 'EILFileName',
							valueField : 'ID',
							mode : 'remote',
							minChars : 0,
							loadByIdParam : 'rowid',
							queryParam : 'desc'

						}, {
							xtype : 'combo',
							///emptyText:'请选择',
							fieldLabel : '关联Excel配置',
							id :'EXCLinkExcelDr1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCLinkExcelDr1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCLinkExcelDr1')),
							hiddenName : 'EXCLinkExcelDr',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							listWidth:250,
							store : storeExcel,
							displayField : 'EILFileName',
							valueField : 'ID',
							mode : 'remote',
							minChars : 0,
							loadByIdParam : 'rowid',
							queryParam : 'desc'

						}, {
							fieldLabel : '是否子表',
							xtype : 'combo',
							id:'EXCIsChildTable1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCIsChildTable1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCIsChildTable1')),
							hiddenName:'EXCIsChildTable',
							emptyText : '请选择...',
							typeAhead : true, 
							triggerAction : 'all',
							forceSelection : true,
							displayField : 'name', 
							valueField : 'value', 
							mode : 'local',  
							lazyRender : true,
						    store: new Ext.data.SimpleStore({
								fields : ['value','name'],
						        data: [['Y', 'Yes'], ['N', 'No']]
						    }),
						    listeners:{
								'select':function(){
									//是子表获取父表Global才能用
									if(Ext.getCmp("EXCIsChildTable1").getValue()=="Y"){
										Ext.getCmp('EXCParRefGlobal1').setDisabled(false);
									}
									else{
										Ext.getCmp('EXCParRefGlobal1').setDisabled(true);
										Ext.getCmp('EXCParRefGlobal1').setValue("");
									}
								}
							}
						}, {
							fieldLabel : '获取父表Global',
							name : 'EXCParRefGlobal',
							id:'EXCParRefGlobal1',
							disabled:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('EXCParRefGlobal1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('EXCParRefGlobal1'))
						}]	
	});	
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 620,
		height: 460,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : WinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() { 
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
    			if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,
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
																		RowId : myrowid
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
				else
				{
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "RowId=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												 Ext.BDP.FunLib.ReturnDataForUpdate("grid", ACTION_URL, myrowid)
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
				Ext.getCmp("form-save").getForm().findField("EXCTableDesc").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
		/*********************************增加按钮*********************************/
	var btnAddwin = new Ext.Toolbar.Button({
			id:'btnAddwin',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwin'),
			text : '添加',
			tooltip : '添加',
			iconCls : 'icon-add',
			handler : function() {//点击触发的事件   
					var _record = grid.getSelectionModel().getSelected();
		            win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					Ext.getCmp("form-save").getForm().reset();
			
		},
		scope : this												 
	});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				//tooltip : '请选择一行后修改(Shift+U)',
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
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&ID=' + _record.get('ID'),
			                success : function(form,action) {
			                	//是子表获取父表Global才能用
								if(Ext.getCmp("EXCIsChildTable1").getValue()=="Y"){
									Ext.getCmp('EXCParRefGlobal1').setDisabled(false);
								}
								else{
									Ext.getCmp('EXCParRefGlobal1').setDisabled(true);
									Ext.getCmp('EXCParRefGlobal1').setValue("");
								}
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            

			        }
				}
			});

	/*******************************增删改工具条*******************************/
	var tbbutton = new Ext.Toolbar({
		items : [btnAddwin, '-',btnEditwin, '-', btnDel]			                  
		});
	
	/********************************搜索按钮*********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  
					//grid加载之前加载可编辑下拉框
					storeGof.load();
					storeExcel.load();
					grid.getStore().baseParams={
						    name : Ext.getCmp("TextCode").getValue(), 	
							desc : Ext.getCmp("TextDesc").getValue()
					};
					
					grid.getStore().load({									 
						params : {
							start : 0,
							limit : pagesize_main
						},
						callback : function(records, options, success) {					
							// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
							clearSubWin();
						}
					});
				}
			});		
	/******************************刷新按钮****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					//clearSubWin();
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset(); 
					//grid加载之前加载可编辑下拉框
					storeGof.load();
					storeExcel.load();
					grid.getStore().baseParams={};
					grid.getStore().load({                               
								params : {
											start : 0,
											limit : pagesize_main
										},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
									clearSubWin();
								}
							}); 
				    }
				});		
	/*************************将工具条放在一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['表名', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							width:100
						},'-','中文描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							width:100
						},'-', btnSearch, '-',btnRefresh, '->'],
				listeners : {                                        
					render : function() {                             
						tbbutton.render(grid.tbar)                    
					}
				}
			});
			
	/***************************************创建grid******************************************/

	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 400,
				split: true,
				height : 300,                                 
				store : ds,											 
				//collapsible: true, 往上收缩按钮
				trackMouseOver : true,                               
				columns : [sm, {									 
							header : 'ID',
							dataIndex : 'ID',
							width : 20,
							hidden : true                           
						}, {
							header : '表名',
							dataIndex : 'EXCTableName',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : '中文描述',
							dataIndex : 'EXCTableDesc',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						},  {
							header : 'RowId名',
							dataIndex : 'EXCIDName',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '获取Global',
							dataIndex : 'EXCXGlobal',
							width : 200,
							sortable : true,
							renderer : function(value, metadata, record, rowIndex, columnIndex, store){
								return "<div ext:qtitle='' ext:qtip='" + value + "'>"+ value +"</div>";
							}
						},{
							header : '关联Gof配置',
							dataIndex : 'EXCLinkGofDr',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							hidden : true 
						},{
							header : '关联Excel配置',
							dataIndex : 'EXCLinkExcelDr',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							hidden : true 
						},{
							header : '关联Gof配置id',
							dataIndex : 'LinkGofDr',
							hidden : true          
						},{
							header : '关联Excel配置id',
							dataIndex : 'LinkExcelDr',
							hidden : true          
						},{
							header : '是否子表',
							dataIndex : 'EXCIsChildTable',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '获取父表Global',
							dataIndex : 'EXCParRefGlobal',
							width : 200,
							sortable : true,
							renderer : function(value, metadata, record, rowIndex, columnIndex, store){
								return "<div ext:qtitle='' ext:qtip='" + value + "'>"+ value +"</div>";
							}
						} ],
				stripeRows : true,                                
				loadMask : {                                      
					msg : '数据加载中,请稍候...'
				},
				title : '导出配置表管理',
				// config options for stateful behavior
				stateful : true,                                   
				viewConfig : {									  
					forceFit : true								   
				},
				bbar : paging,                                    
				tbar : tb,                                        
				stateId : 'grid'
			});
    /*******************************定义Grid的行单击事件**************************/
		grid.on("rowclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				var FieldTitle=_record.get('EXCTableDesc')+"-表字段维护";
				BDEFgrid.setTitle(FieldTitle);
				
				Ext.getCmp("TextCode2").reset();
				Ext.getCmp("TextDesc2").reset();
				BDEFgrid.getStore().baseParams={};
				BDEFds.load({                                    
					params : {
								start : 0,
								limit : pagesize_main,
								ParRef : _record.get('ID')
							}
					});
				BDEFgrid.expand();
			});
			
	/*****************************以下为子表部分*******************************************************/
	var BDEFbtnDel = new Ext.Toolbar.Button({                               
			text : '删除',													  
			id:'BDEF-deletebtn',
			tooltip : '删除',												 
			iconCls : 'icon-delete',										 
			disabled:true,
			handler : function() {											 
			if (BDEFgrid.selModel.hasSelection()) {                           
				var gsm = BDEFgrid.getSelectionModel();				 
				var rows = gsm.getSelections();
				if(rows[0].get('FieldRowId')==""||typeof(rows[0].get('FieldRowId'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
					return;
				}
				 
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');  
						var gsm = BDEFgrid.getSelectionModel();				  
						var rows = gsm.getSelections();					 
						
						Ext.Ajax.request({	                              	
							url : CHILD_DELETE_ACTION_URL,					  
							method : 'POST',                              
							params : {								 
								'id' : rows[0].get('FieldRowId')          
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              							
									var jsonData = Ext.util.JSON		  
											.decode(response.responseText); 
									if (jsonData.success == 'true') {
										Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,           
														buttons : Ext.Msg.OK,          
														fn : function(btn) {
															var startIndex = BDEFgrid.getBottomToolbar().cursor;
															var totalnum=BDEFgrid.getStore().getTotalCount();
															if(totalnum==1){    
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0) 
															{
																var pagenum=BDEFgrid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  
															}
															BDEFgrid.getStore().load({
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
													errorMsg = '<br />错误信息:'
															+ jsonData.info
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
																msg : '异步通讯失败.....',
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
	
	/************************************增加按钮****************************************/
	var BDEFbtnAddwin = new Ext.Toolbar.Button({
				id:'BDEF-Add-Btn',
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				disabled:true,
				handler : function(thiz) { 
					BDEFeditor.stopEditing();
					if(BDEFds.getCount()!=0&&BDEFds.getAt(0).get('FieldName')==""){
						BDEFgrid.getSelectionModel().selectRow(0);
						BDEFeditor.startEditing(0);
					}else{
						if (grid.selModel.hasSelection()) {	
							var record1 = grid.getSelectionModel().getSelected();
							var b = new BDEF({  
								FieldParRef : record1.get('ID'),
								FieldRowId : '',
								EXFCFieldName : '',
								EXFCFieldDesc : '',
								EXFCFieldType:'',
								EXFCIDToCode:'',
								EXFCGetField:'',
								EXFCExport:'',
								EXFCOrder:''
							});
							BDEFds.insert(0, b); 
							BDEFgrid.getSelectionModel().selectRow(0);
							BDEFeditor.startEditing(0);
						}
						else
						{
							Ext.Msg.show({
								title : '提示',
								msg : '请选择父表记录！',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
							
							
						}
					}
				},
				scope : this									 
			});
var BDEF = Ext.data.Record.create([											 
				{	name : 'FieldParRef',
					mapping : 'FieldParRef',
					type : 'string'
				},{	name : 'FieldRowId',
					mapping : 'FieldRowId',
					type : 'string'
				}, {
					name : 'EXFCFieldName',
					mapping : 'EXFCFieldName',
					type : 'string'
				}, {
					name : 'EXFCFieldDesc',
					mapping : 'EXFCFieldDesc',
					type : 'string'
				} , {
					name : 'EXFCFieldType',
					mapping : 'EXFCFieldType',
					type : 'string'
				}, {
					name : 'EXFCIDToCode',
					mapping : 'EXFCIDToCode',
					type : 'string'
				}, {
					name : 'EXFCGetField',
					mapping : 'EXFCGetField',
					type : 'string'
				}, {
					name : 'EXFCExport',
					mapping : 'EXFCExport',
					type : 'string'
				}, {
					name : 'EXFCOrder',
					mapping : 'EXFCOrder',
					type : 'string'
				}]);
			
     /*************************将数据读取出来并转换(成record实例)，为后面的读取和修改做准备********************/
	var BDEFds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({  
					url : CHILD_ACTION_URL
				}),
				reader : new Ext.data.JsonReader({  
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDEF),
				listeners : {// 对数据集进行监听
					'update' : function(thiz, record, operation) { 
						var user = thiz.getAt(thiz.indexOf(record)).data;
						if (operation == Ext.data.Record.EDIT) {  
							thiz.commitChanges();  
							Ext.Ajax.request({  
								url : CHILD_SAVE_ACTION_URL_New,
								method : 'POST',
								params : 'ParRef=' + user.FieldParRef
										+ '&FieldRowId=' + user.FieldRowId
										+ '&EXFCFieldName=' + user.EXFCFieldName
										+ '&EXFCFieldDesc=' + user.EXFCFieldDesc
										+ '&EXFCFieldType=' + user.EXFCFieldType
										+ '&EXFCIDToCode=' + user.EXFCIDToCode
										+ '&EXFCGetField=' + user.EXFCGetField
										+ '&EXFCExport=' + user.EXFCExport
										+ '&EXFCOrder=' + user.EXFCOrder,
								success : function(response, opts) {
									var Child_respText = Ext.util.JSON.decode(response.responseText);
									if(Child_respText.success=='true'){
										var startIndex = BDEFgrid.getBottomToolbar().cursor;
										BDEFgrid.getStore().load({
												params : {
													//RowId : Child_respText.id,
													start :startIndex,   
													limit : pagesize_main
												}
											});
										BDEFgrid.getView().refresh();
									}else{
										var errorMsg = '';
										if (Child_respText.errorinfo) {
											errorMsg = '<br/>错误信息:' + Child_respText.errorinfo
										}
										Ext.Msg.show({
											title : '提示',
											msg : '保存失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
										var r = BDEFgrid.getSelectionModel().getSelected();
							            if(r){
							                var index = BDEFgrid.store.indexOf(r);
							                BDEFeditor.startEditing(index);
							            }
									}
								},
								failure : function(response, opts) {
									Ext.Msg.alert('错误', '提交数据错误!错误代码： '
													+ response.status);
									thiz.rejectChanges(); // 请求失败,回滚本地记录:)
									var startIndex = BDEFgrid.getBottomToolbar().cursor;
									BDEFgrid.getStore().load({
												params : {
															start :startIndex,   
															limit : pagesize_main
														}
											});
									BDEFgrid.getView().refresh();
								}
							});
						}
					},
					'load' : function(thiz, record, operation) {
						//BDEFtbbutton.setDisabled(false);
						//BDEFtb.setDisabled(false);
						BDEFgrid.enable();
						Ext.getCmp('EXFCIDToCodeF').setDisabled(true);
						//Ext.getCmp('EXFCGetFieldF').setDisabled(true);
						Ext.getCmp('BDEFbtnSearch').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'));
						Ext.getCmp('BDEF-deletebtn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-deletebtn'));
						Ext.getCmp('BDEF-Add-Btn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-Add-Btn'));
						Ext.getCmp('BDEFbtnRefresh').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'));
						Ext.getCmp('TextCode2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextCode2'));
						Ext.getCmp('TextDesc2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'));
					}
				}
			});
	 
	/** ***************************加载前设置参数 ********************************/
	BDEFds.on('beforeload',function() {
			if (grid.selModel.hasSelection()) {
				var gsm = grid.getSelectionModel(); 
				var rows = gsm.getSelections(); 
				Ext.apply(BDEFds.lastOptions.params, {
			    		ParRef : rows[0].get('ID')
			   	 });
			}
		},this);		
	/******************************分页工具条**********************************/	
	var BDEFpaging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : BDEFds,											      
				displayInfo : true,										 
				emptyMsg : "没有记录"
			});

	/**-**************************增删改工具条********************************/
	var BDEFtbbutton = new Ext.Toolbar({
		items : [BDEFbtnAddwin, '-', BDEFbtnDel]			   
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		});
		
	var BDEFbtnSearch = new Ext.Button({
				id : 'BDEFbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					
					BDEFgrid.getStore().baseParams={			
							code : Ext.getCmp("TextCode2").getValue(),
							desc : Ext.getCmp("TextDesc2").getValue()
					};
					BDEFgrid.getStore().load({
						params : {
									ParRef : rows[0].get('ID'),
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	var BDEFbtnRefresh = new Ext.Button({
				id : 'BDEFbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.getCmp("TextCode2").reset();
					Ext.getCmp("TextDesc2").reset();
					BDEFgrid.getStore().baseParams={};
					BDEFgrid.getStore().load({
								params : {
											ParRef : rows[0].get('ID'),
											start : 0,
											limit : pagesize_main
										}
									});
							}
			});
		
	/*****************************将工具条放在一起*********************/
	var BDEFtb = new Ext.Toolbar({
				id : 'BDEFtbtb',
				disabled : true,
				items : ['字段名', {
							xtype : 'textfield',						
							id : 'TextCode2',
							width:100,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2')
						}, '-',
						'字段描述', {
							xtype : 'textfield',
							width:100,
							id : 'TextDesc2',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')
						}, '-', BDEFbtnSearch, '-', BDEFbtnRefresh, '->'
				],
				listeners : {                                       
					render : function() {                            
						BDEFtbbutton.render(BDEFgrid.tbar)                   
					}
				}
			});
			
	var BDEFeditor = new Ext.ux.grid.RowEditor({ 
			saveText : '保存',
			cancelText : '取消',
			commitChangesText : '提交!',
			errorSummary: false
	});
	
	BDEFeditor.on({
    canceledit : function() {
    				var startIndex = BDEFgrid.getBottomToolbar().cursor;
					BDEFgrid.getStore().load({                               
								params : {
											start :startIndex,   
											limit : pagesize_main
										}
							})
    				}
		});
	
	
	// 标志位判断数据源
	var XTypeData = [  
	                 ['String','String'], 
	                 ['Date ','Date'],
	                 ['Time','Time'],
	                 ['DR','DR'],
	                 ['Float','Float'],
	                 ['Integer','Integer']
	                // ['GlobalCharacterStream','GlobalCharacterStream']
	                 ];
	var XTypestore = new Ext.data.SimpleStore({
			fields : ['value','display'],
			data : XTypeData
		});
	                 
	/*****************************创建grid**************************/
	var BDEFgrid = new Ext.grid.GridPanel({
				id : 'BDEFgrid',
				region : 'south',
				width : 610,
				split: true,
				height : 500,
				collapsible: true,
				plugins: [BDEFeditor],
				store : BDEFds,											 
				trackMouseOver : true,                              
				columns : [sm, {									 
							header : 'Field_RowId',
							dataIndex : 'FieldRowId',
							width : 80,
							hidden : true                           
						}, {
							header : '父表rowid',
							dataIndex : 'FieldParRef',
							hidden : true 
						}, {
							header : '字段名',
							dataIndex : 'EXFCFieldName',
							editor:{
								id:'EXFCFieldNameF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCFieldNameF'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '字段描述',
							dataIndex : 'EXFCFieldDesc',
							editor:{
								id:'EXFCFieldDescF',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCFieldDescF'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '字段类型',
							dataIndex : 'EXFCFieldType',
							editor : new Ext.form.ComboBox({ 
									id:'EXFCFieldTypeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCFieldTypeF'),
									emptyText : '请选择...',
									typeAhead : true, 
									triggerAction : 'all',
									store : XTypestore, 
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true,
									listWidth:140,
									listeners:{
										'select':function(){
											if(Ext.getCmp("EXFCFieldTypeF").getValue()=="DR"){
												Ext.getCmp('EXFCIDToCodeF').setDisabled(false);

											}
											else{
												Ext.getCmp('EXFCIDToCodeF').setDisabled(true);
												Ext.getCmp('EXFCIDToCodeF').setValue("");

											}
										}
									}
							})
						} ,{
							header : '获取DR指针的代码或描述',
							dataIndex : 'EXFCIDToCode',
							width : 200,
							editor : {  
									id:'EXFCIDToCodeF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCIDToCodeF'),
									xtype: 'textfield'
							}
						},{
							header : '获取字段',
							dataIndex : 'EXFCGetField',
							width : 200,
							editor : {  
									id:'EXFCGetFieldF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCGetFieldF'),
									xtype: 'textfield'
							}
						},{
							header : '是否导出',
							dataIndex : 'EXFCExport',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor :new Ext.form.ComboBox({ 
								    //pageSize : Ext.BDP.FunLib.PageSize.Combo,
									id:'EXFCExportF',
									hiddenName : 'EXFCExport',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCExportF'),
									editable:false,
									//width : 140,
									mode : 'local',
									triggerAction : 'all',// query
									blankText:'请选择',
									valueField : 'value',
									displayField : 'name',
									store:new Ext.data.SimpleStore({
										fields:['value','name'],
										data:[
											      ['Y','Yes'],
											      ['N','No']
										     ]
									})
									
							})
						},{
							header : '顺序',
							dataIndex : 'EXFCOrder',
							width : 200,
							editor : {  
									id:'EXFCOrderF',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EXFCOrderF'),
									xtype: 'textfield'
							}
						}],
				stripeRows : true,                               
				loadMask : {                                     
					msg : '数据加载中,请稍候...'
				},
				//title : '',
				// config options for stateful behavior
				viewConfig : {									  
					forceFit : true								   
				},
				stateful : true,                                  
				bbar : BDEFpaging,                                   
				tbar : BDEFtb,                                         
				stateId : 'BDEFgrid'
			});		
	BDEFgrid.on('rowclick',function(Grid,index,e){
		if(Ext.getCmp("EXFCFieldTypeF").getValue()=="DR"){
			Ext.getCmp('EXFCIDToCodeF').setDisabled(false);
			//Ext.getCmp('EXFCGetFieldF').setDisabled(false);
		}else{
			Ext.getCmp('EXFCIDToCodeF').setDisabled(true);
			//Ext.getCmp('EXFCGetFieldF').setDisabled(true);
		}
		if(BDEFds.getAt(0).get('EXFCFieldName')==""){
			BDEFds.removeAt(0);
			if(0==index) return;
		}
	});
			
	/*****************************创建viewport*************************************/
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid,BDEFgrid]
			});
	
	/** ***************************keymap ***************************************/
	if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
    {
    	var keymap = new Ext.KeyMap(document, 
			[{
				key:Ext.EventObject.ENTER, /**按钮转换功能，将enter键转换为tab键。当为button时不进行按键的转换**/
				fn:  function changeFocus() {
			    		if(event.keyCode==13 && event.srcElement.type!='button') {
			    			event.keyCode=9;  
			      		}
			   		}
			}]
	   );
    }
});