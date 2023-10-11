 	
	/// 名称:系统配置 - 1 登录语言维护	
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2013-7-3
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "SS_Language"
	});
	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.SSLanguage";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	Ext.BDP.FunLib.TableName="SS_Language";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
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
			RowID=rows[0].get('CTLANRowId');
			Desc=rows[0].get('CTLANDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSLanguage";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;

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
						AliasGrid.DataRefer = rows[0].get('CTLANRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTLANRowId')
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
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTLANCode',mapping:'CTLANCode'},
                                         {name: 'CTLANDesc',mapping:'CTLANDesc'},
                                         {name: 'CTLANRowId',mapping:'CTLANRowId'},
				                         {name: 'CTLANStartDate',mapping:'CTLANStartDate',type:'string'},
				                         {name: 'CTLANEndDate',mapping:'CTLANEndDate',type:'string'},
				                         {name: 'CTLANActivity',mapping:'CTLANActivity',type:'string'},
				                         {name: 'CTLANSeqNo',mapping:'CTLANSeqNo',type:'string'},
				                         {name: 'CTLANPYCode',mapping:'CTLANPYCode',type:'string'},
				                         {name: 'CTLANWBCode',mapping:'CTLANWBCode',type:'string'},
				                         {name: 'CTLANMark',mapping:'CTLANMark',type:'string'}                                         
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'CTLANRowId',
							xtype:'textfield',
							fieldLabel : 'CTLANRowId',
							name : 'CTLANRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'CTLANCode',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLANCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLANCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLANCode')),
							name : 'CTLANCode',
							maxLength:2, //表结构定义里限制了MAXLEN = 2
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.SSLanguage";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTLANRowId');
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
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult},
						    
							allowBlank:false
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'CTLANDesc',
							maxLength:40,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLANDesc'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLANDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLANDesc')),
							name : 'CTLANDesc',
							allowBlank:false,
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.SSLanguage";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTLANRowId');
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
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
						        'blur':function()
            			        {
	            			        var Desc=Ext.getCmp("CTLANDesc").getValue()
	            			        if(Desc!="")
	            			        {
        			                  var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
							          var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
									  Ext.getCmp("CTLANPYCode").setValue(PYCode)
									  Ext.getCmp("CTLANWBCode").setValue(WBCode)
		            			        
	            			        }
            			        }
						    }
						}, {
							xtype : 'datefield',
                            labelSeparator:"",
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'CTLANStartDate',
							id:'CTLANStartDateF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLANStartDateF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLANStartDateF')),
							format : BDPDateFormat,
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'datefield',
                            labelSeparator:"",
							fieldLabel : '结束日期',
							name : 'CTLANEndDate',
							id:'CTLANEndDateF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLANEndDateF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLANEndDateF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'checkbox',
                            labelSeparator:"",
							fieldLabel : '是否有效',
							name : 'CTLANActivity',
							id:'CTLANActivity',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLANActivity'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLANActivity')),
							enableKeyEvents : true,
							checked:true,
							inputValue : true?'Y':'N'
						},{
							fieldLabel: "排序号",
							hiddenName:'CTLANSeqNo',
							dataIndex:'CTLANSeqNo',
							id:'CTLANSeqNo',
							xtype: "textfield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							},{
							fieldLabel: "拼音码",
							hiddenName:'CTLANPYCode',
							dataIndex:'CTLANPYCode',
							id:'CTLANPYCode',
							xtype: "textfield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							},{
							fieldLabel: "五笔码",
							hiddenName:'CTLANWBCode',
							dataIndex:'CTLANWBCode',
							id:'CTLANWBCode',
							xtype: "textfield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
							},{
							fieldLabel: "备注",
							hiddenName:'CTLANMark',
							dataIndex:'CTLANMark',
							id:'CTLANMark',
							xtype: "textfield",
							//labelSeparator: "：",
							labelAlign: "left",
							msgTarget: "side",
							autoFitErrors: false,
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
		title : '', 
		width : 280,
		height: 400,
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
			id:'save_btn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
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
				Ext.getCmp("form-save").getForm().findField("CTLANCode").focus(true,300);
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
			            AliasGrid.DataRefer = _record.get('CTLANRowId');
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
								name : 'CTLANRowId',
								mapping : 'CTLANRowId',
								type : 'number'
							}, {
								name : 'CTLANCode',
								mapping : 'CTLANCode',
								type : 'string'
							}, {
								name : 'CTLANDesc',
								mapping : 'CTLANDesc',
								type : 'string'
							},
							{
								name : 'CTLANStartDate',
								mapping : 'CTLANStartDate',
								type : 'date' ,
			                    dateFormat : 'm/d/Y'
							}, {
								name : 'CTLANEndDate',
								mapping : 'CTLANEndDate',
								type : 'date' ,
			                    dateFormat : 'm/d/Y'
							}, {
								name : 'CTLANActivity',
								mapping : 'CTLANActivity',
								type : 'string'
							}, {
								name : 'CTLANSeqNo',
								mapping : 'CTLANSeqNo',
								type : 'string'
							}, {
								name : 'CTLANPYCode',
								mapping : 'CTLANPYCode',
								type : 'string'
							}, {
								name : 'CTLANWBCode',
								mapping : 'CTLANWBCode',
								type : 'string'
							}, {
								name : 'CTLANMark',
								mapping : 'CTLANMark',
								type : 'string'
							}
						]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
				//remoteSort : true
				//sortInfo: {field : "***RowId",direction : "ASC"}
	});
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
		,'-',btnSort,'-',btnTrans
		,'->',btnlog,'-',btnhislog
		
]
	});
	
	// 搜索工具条
	var btnSearch = new Ext.Button({
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
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
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置' ,
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					
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
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', 
						btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});
	
	var GridCM=[sm, {
							header : 'CTLANRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTLANRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTLANCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'CTLANDesc'
						}, {
							header : '开始日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTLANStartDate'
						}, {
							header : '结束日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTLANEndDate'
						},{
							header : '是否有效',
							sortable : true,
							dataIndex : 'CTLANActivity',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
							header : '排序号',
							sortable : true,
							dataIndex : 'CTLANSeqNo'
						},{
							header : '拼音码',
							sortable : true,
							dataIndex : 'CTLANPYCode'
						},{
							header : '五笔码',
							sortable : true,
							dataIndex : 'CTLANWBCode'
						},{
							header : '备注',
							sortable : true,
							dataIndex : 'CTLANMark'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '登录语言',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns :GridCM,
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
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
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTLANRowId'),
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
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('CTLANRowId');
	        AliasGrid.loadGrid();
		}	
    });	
    
    
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
  			  var _record = grid.getSelectionModel().getSelected();
   			 var selectrow = _record.get('CTLANRowId');	           
 		} else {
 			var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow;	
		})


				 
	
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
   
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});
