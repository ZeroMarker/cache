	
	/// 名称:医嘱状态变化原因维护	
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2015-1-12
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() { 
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "OEC_AdminStatusChReason"
	});
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECAdminStatusChReason&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECAdminStatusChReason&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.OECAdminStatusChReason&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.OECAdminStatusChReason";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.OECAdminStatusChReason&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.OECAdminStatusChReason";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="OEC_AdminStatusChReason"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	//-----------------（别忘了后面的grid单击事件）翻译结束--------//
	/////////////////////////////日志查看 ////////////////////////////////////////
	var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
	var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
	///日志查看按钮是否显示
	var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
	if (btnlogflag==1)
	{
		btnlog.hidden=false;
	}
    else
    {
       btnlog.hidden=true;
    }
	/// 数据生命周期按钮 是否显示
	var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
	if (btnhislogflag ==1)
	{
		btnhislog.hidden=false;
	}
    else
    {
		btnhislog.hidden=true;
	}  
	btnhislog.on('click', function(btn,e){    
		var RowID="",Desc="";
		if (grid.selModel.hasSelection()) {
			var rows = grid.getSelectionModel().getSelections(); 
			RowID=rows[0].get('ASCRRowId');
			Desc=rows[0].get('ASCRDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	Ext.QuickTips.init();
	
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
			
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
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('ASCRRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ASCRRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												
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
	
	// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				URL : SAVE_ACTION_URL,
				title:'基本信息', 
				labelAlign : 'right',
				labelWidth : 130,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ASCRCode',mapping:'ASCRCode'},
                                         {name: 'ASCRDesc',mapping:'ASCRDesc'},
                                         {name: 'ASCRRowId',mapping:'ASCRRowId'},
										 {  
										 name : 'ASCRCancelOperaReason',
										 mapping :'ASCRCancelOperaReason' 
										}, {
										 name : 'ASCRPDAExcuteReason',
										 mapping :'ASCRPDAExcuteReason' 
										},{
										 name:'ASCRDateFrom',
										 mapping:'ASCRDateFrom' 
										}, {
										 name :'ASCRDateTo',
										 mapping :'ASCRDateTo' 
										}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'ASCRRowId',
							xtype:'textfield',
							fieldLabel : 'ASCRRowId',
							name : 'ASCRRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'ASCRCode',
							maxLength:15,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ASCRCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRCode')),
							name : 'ASCRCode',
							allowBlank:false,
							validationEvent : 'blur',  
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.OECAdminStatusChReason";
	                            var classMethod = "FormValidate";                          
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ASCRRowId');
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
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'ASCRDesc',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ASCRDesc'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRDesc')),
							name : 'ASCRDesc',
							allowBlank:false,
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.OECAdminStatusChReason";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ASCRRowId');
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
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						},{
							xtype:'datefield',
						   fieldLabel : '<font color=red>*</font>开始日期',
						   name : 'ASCRDateFrom',
						   format : BDPDateFormat,
						   id:'ASCRDateFromF',
						   readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRDateFromF'),
						   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRDateFromF')),
						   allowBlank:false,
						   regexText:"开始日期不能为空",
						   editable:true,
						   enableKeyEvents : true,
						   listeners : {   
								'keyup' : function(field, e)
								{ 
									 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
								}
							}
					},{
						   xtype:'datefield',
						   fieldLabel : '结束日期',
						   name : 'ASCRDateTo',
						   id:'ASCRDateToF',
						   readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRDateToF'),
						   style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRDateToF')),
						   format : BDPDateFormat,
						   enableKeyEvents : true,
						   listeners : {   
							'keyup' : function(field, e)
							{ 
							  Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
							}}
					   }, {
							fieldLabel: '撤销类操作原因',
							xtype : 'checkbox',
							name : 'ASCRCancelOperaReason',
							id:'ASCRCancelOperaReasonF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRCancelOperaReasonF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRCancelOperaReasonF')),
							inputValue : 'Y',
							checked:true,
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '【包括对医嘱、执行记录的反向操作，比如停止医嘱、撤销医嘱、停止执行、撤销执行等等】'  
				                    })  
				                }  
				            }  
					}, {
							fieldLabel: 'PDA电脑端执行原因',
							xtype : 'checkbox',
							name : 'ASCRPDAExcuteReason',
							id:'ASCRPDAExcuteReasonF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ASCRPDAExcuteReasonF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ASCRPDAExcuteReasonF')),
							inputValue : 'Y',
							checked:false,
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '【护士使用PC端执行执行记录时需要选择的执行原因】'  
				                    })  
				                }  
				            }  
					}] 	 
	});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });		
	// 增加修改时弹出窗口
	var win = new Ext.Window({ 
		width :380,
		height: 370,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("form-save").getForm().findField("ASCRCode").getValue();
				var tempDesc = Ext.getCmp("form-save").getForm().findField("ASCRDesc").getValue();
				var startDate = Ext.getCmp("form-save").getForm().findField("ASCRDateFrom").getValue();
				var endDate = Ext.getCmp("form-save").getForm().findField("ASCRDateTo").getValue();
				if (tempCode=="") {
					Ext.Msg.show({ 
									title : '<font color=blue>提示</font>',
									msg : '代码不能为空!', 
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK ,
									fn:function()
									{
										Ext.getCmp("form-save").getForm().findField("ASCRCode").focus(true,true);
									}
								});
						return;
					}
				if (tempDesc=="") {
					Ext.Msg.show({ 
									title : '<font color=blue>提示</font>',
									msg : '描述不能为空!', 
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK ,
									fn:function()
									{
										Ext.getCmp("form-save").getForm().findField("ASCRDesc").focus(true,true);
									}
								 });
							return;
						}
				if (startDate=="") {
					Ext.Msg.show({ 
									title : '<font color=blue>提示</font>', 
									msg : '开始日期不能为空!', 
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK ,
									fn:function()
									{
										Ext.getCmp("form-save").getForm().findField("ASCRDateFrom").focus(true,true);
									}
								 });
						return;
				}
				if (startDate != "" && endDate != "") {
					if (startDate > endDate) {
						Ext.Msg.show({
										title : '<font color=blue>提示</font>',
										msg : '<font color=red>开始日期不能大于结束日期!</font>',
										minWidth : 200,
										animEl: 'form-save',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								return;
						}
					}
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				//-------添加----------
				if (win.title == "添加") {
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
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
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
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
											
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
					// WinForm.getForm().reset();
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
				Ext.getCmp("form-save").getForm().findField("ASCRCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
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
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
		            
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
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('ASCRRowId');
				        AliasGrid.loadGrid();
				        
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
	var fields=[{
								name : 'ASCRRowId',
								mapping : 'ASCRRowId',
								type : 'number'
							}, {
								name : 'ASCRCode',
								mapping : 'ASCRCode',
								type : 'string'
							}, {
								name : 'ASCRDesc',
								mapping : 'ASCRDesc',
								type : 'string'
							}, {  
							 name : 'ASCRCancelOperaReason',
							 mapping :'ASCRCancelOperaReason' 
							}, {
							 name : 'ASCRPDAExcuteReason',
							 mapping :'ASCRPDAExcuteReason' 
							},{
							 name:'ASCRDateFrom',
							 mapping:'ASCRDateFrom' 
							}, {
							 name :'ASCRDateTo',
							 mapping :'ASCRDateTo' 
							}
						]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields),
				//remoteSort : true
				sortInfo: {field : "ASCRRowId",direction : "ASC"}
	});
	//ds.sort("CMCBMCode","DESC");
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);	
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
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
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
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
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
						code : Ext.getCmp("TextCode").getValue(),
						
						desc : Ext.getCmp("TextDesc").getValue()
						
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
					Ext.BDP.FunLib.SelectRowId ="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
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
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},'-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-', 
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',  btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});
	var GridCM=[sm, {
							header : 'ASCRRowId',
							width : 70,
							sortable : true,
							dataIndex : 'ASCRRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'ASCRCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'ASCRDesc'
						}, {
							header : '撤销类操作原因',
							width : 60,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'ASCRCancelOperaReason'
							
						}, {
							header : 'PDA电脑端执行原因',
							width : 160,
							sortable : true,
							dataIndex : 'ASCRPDAExcuteReason',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
						
						}, {
							header : '开始日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat), 
							dataIndex : 'ASCRDateFrom'
						}, {
							header : '结束日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ASCRDateTo'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '医嘱状态变化原因',
				id : 'grid',
				region : 'center',
				width : 900,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true ,
				// config options for stateful behavior
				stateful : true, 
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);

	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ASCRRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };			
			
	grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('ASCRRowId');
	        AliasGrid.loadGrid();
			
    });	
    		//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ASCRRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
   
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});
