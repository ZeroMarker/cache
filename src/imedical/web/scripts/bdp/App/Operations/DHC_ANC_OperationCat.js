	
	/// 名称:手术和过程 - 手术分类
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - ybq
	/// 编写日期:2019-1-31
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "DHC_ANC_OperationCat"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.DHCANCOperationCat";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    
	//翻译
	Ext.BDP.FunLib.TableName="DHC_ANC_OperationCat";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	    /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名 
    
	 //////////////////////////////日志查看 ////////////////////////////////////////
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
   if (btnhislogflag==1)
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
       RowID=rows[0].get('ANCOCRowId');
       Desc=rows[0].get('ANCOCDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCANCOperationCat&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCANCOperationCat&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCANCOperationCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCANCOperationCat";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCANCOperationCat&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
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
						//删除所有别名
									
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('ANCOCRowId');
						AliasGrid.delallAlias();
						
						

						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ANCOCRowId')
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
												var startIndex = grid.getBottomToolbar().cursor;
												var totalnum=grid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize==0)//最后一页只有一条
												{
														
														var pagenum=grid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize  
																}	
														});		
	
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
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				title:'基本信息',
				labelWidth : 75,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ANCOCCode',mapping:'ANCOCCode'},
                                         {name: 'ANCOCDesc',mapping:'ANCOCDesc'},
                                         {name: 'ANCOCType',mapping:'ANCOCType'},
                                         {name: 'ANCOCRowId',mapping:'ANCOCRowId'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'ANCOCRowId',
							xtype:'textfield',
							fieldLabel : 'ANCOCRowId',
							name : 'ANCOCRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							maxLength:220, //这个例外不是15
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'ANCOCCode',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANCOCCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANCOCCode')),
							name : 'ANCOCCode',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.DHCANCOperationCat";
	                            var classMethod = "FormValidate";                           
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ANCOCRowId');
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
							id:'ANCOCDesc',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ANCOCDesc'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANCOCDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANCOCDesc')),
							name : 'ANCOCDesc',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.DHCANCOperationCat";
	                            var classMethod = "FormValidate";                           
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ANCOCRowId');
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
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}, {
							fieldLabel : '类别',
							xtype : 'combo',
							hiddenName: 'ANCOCType',
							//name : 'CTCPTInternalType',
							id : 'ANCOCTypeF',
		   					//disabled : Ext.BDP.FunLib.Component.DisableFlag('ANCOCType'),
		   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANCOCType')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANCOCType'),
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
											name : '手术',
											value : 'O'
										}, {
											name : '诊断',
											value : 'P'
										}]
							})
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
		width : 300,
		height: 280,
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
		items : tabs,
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
				//-------添加----------	
				if (win.title == "添加") {
					//WinForm.form.isValid()
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
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});*/
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
				Ext.getCmp("form-save").getForm().findField("ANCOCCode").focus(true,300);
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
						loadFormData(grid);
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('ANCOCRowId');
				        AliasGrid.loadGrid();
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
								name : 'ANCOCRowId',
								mapping : 'ANCOCRowId',
								type : 'number'
							}, {
								name : 'ANCOCCode',
								mapping : 'ANCOCCode',
								type : 'string'
							}, {
								name : 'ANCOCDesc',
								mapping : 'ANCOCDesc',
								type : 'string'
							}, {
								name : 'ANCOCType',
								mapping : 'ANCOCType',
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
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
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
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
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
				handler : search = function () {
				grid.getStore().baseParams={
						code :  Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue(),
						
						type :  Ext.getCmp("TextANCOCType").getValue()
						
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
					
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextANCOCType").reset();
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
				items : ['代码', 
				{
					xtype : 'textfield',
					id : 'TextCode',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							if(event.getKey() == 13){

								search()
							}
						},
						scope: this
					}
				},'-','描述', 
				{
					xtype : 'textfield',
					emptyText : '描述/别名',
					id : 'TextDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							if(event.getKey() == 13){
								search()
							}
						},
						scope: this
					}
				},'-', '类别',
				{
					fieldLabel : '类别',
					xtype : 'combo',
					id : 'TextANCOCType',
   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TextANCOCType')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('TextANCOCType'),
					mode : 'local',
					// hiddenName:'hxxx',//不能与id相同
					triggerAction : 'all',// query
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					minChars : 1,
					valueField : 'value',
					displayField : 'name',
					store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
									name : '手术',
									value : 'O'
								}, {
									name : '诊断',
									value : 'P'
								}]
					}),
					enableKeyEvents: true,
					listeners:{
						keyup:function(node, event) {
							if(event.getKey() == 13){
								search()
							}
						},
						scope: this
					}
				},'-',
					LookUpConfigureBtn,'-',
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
							header : 'ANCOCRowId',
							width : 70,
							sortable : true,
							dataIndex : 'ANCOCRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'ANCOCCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'ANCOCDesc'
						}, {
							header : '类别',
							width : 100,
							sortable : true,
							dataIndex : 'ANCOCType',
							renderer:function(value)
			            	{
			            		if (value=="O")
			            		{
			            		   return "手术";
			            		}
			            		if (value=="P")
			            		{
			            		   return "诊断";
			            		}
			            	}
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '手术分类',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
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
	

    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
        } else {
        	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ANCOCRowId'),
                success : function(form,action) {
                },
                failure : function(form,action) {
                }
            });
        }
    };
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('ANCOCRowId');	           
		 	} else {
		 		var selectrow="";
			 }
				Ext.BDP.FunLib.SelectRowId = selectrow;	

			})

			
    grid.on("rowdblclick", function(grid, rowIndex, e) {
        	loadFormData(grid);
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('ANCOCRowId');
	        AliasGrid.loadGrid();
    });	
    
	
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});
});