 	
	/// 名称：结算 - 出院条件维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2014-6-24
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_DischCondit"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.PACDischCondit";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//翻译
	Ext.BDP.FunLib.TableName="PAC_DischCondit";
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
       RowID=rows[0].get('DISCONRowId');
       Desc=rows[0].get('DISCONDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACDischCondit&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACDischCondit&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACDischCondit&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACDischCondit";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACDischCondit&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();

	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDateText:'结束日期应该大于开始日期'
	});
	
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
						AliasGrid.DataRefer = rows[0].get('DISCONRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('DISCONRowId')
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
				URL : SAVE_ACTION_URL,
				title:'基本信息',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'DISCONCode',mapping:'DISCONCode'},
                                         {name: 'DISCONDesc',mapping:'DISCONDesc'},
                                         {name: 'DISCONDeadFlag',mapping:'DISCONDeadFlag'},
                                         {name: 'DISCONNationalCode',mapping:'DISCONNationalCode'},
                                         {name: 'DISCONEpisodeType',mapping:'DISCONEpisodeType'},
                                         {name: 'DISCONDateFrom',mapping:'DISCONDateFrom'},
                                         {name: 'DISCONDateTo',mapping:'DISCONDateTo'},
                                         {name: 'DISCONRowId',mapping:'DISCONRowId'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'DISCONRowId',
							xtype:'textfield',
							fieldLabel : 'DISCONRowId',
							name : 'DISCONRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'DISCONCode',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('DISCONCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DISCONCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DISCONCode')),
							name : 'DISCONCode',
							allowBlank:false,
							validationEvent : 'blur',  
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACDischCondit";
	                            var classMethod = "FormValidate";                    
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('DISCONRowId');
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
							id:'DISCONDesc',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('DISCONDesc'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DISCONDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DISCONDesc')),
							name : 'DISCONDesc',
							allowBlank:false,
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACDischCondit";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('DISCONRowId');
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
						}, {
								///add @ 2015-4-10 by chenying
								xtype : 'combo',
								listWidth:140,
								id:'DISCONDeadFlag1',
								name:'DISCONDeadFlag',
								hiddenName : 'DISCONDeadFlag', //若没有hiddenname 传入的值是name
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('DISCONDeadFlag1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DISCONDeadFlag1')),
								
								fieldLabel : 'Status',
								store : new Ext.data.JsonStore({
									fields:['name','value'],
									data:[{name:'InPatientAdmission',value:'IP'},{name:'Death',value:'D'},{name:'Waiting List',value:'WL'},{name:'Appointment',value:'A'},{name:'Transfer',value:'T'}]
								
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								triggerAction : 'all',
								displayField : 'name',
								valueField : 'value'
						}, {
								fieldLabel : 'NationalCode',
								xtype:'textfield',
								id:'DISCONNationalCode',
								maxLength:30,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('DISCONNationalCode'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DISCONNationalCode')),
								name : 'DISCONNationalCode'
						}, {
								xtype : 'combo',
								listWidth:140,
								id:'DISCONEpisodeType1',
								name:'DISCONEpisodeType',
								hiddenName : 'DISCONEpisodeType', //若没有hiddenname 传入的值是name
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('DISCONEpisodeType1'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DISCONEpisodeType1')),
								fieldLabel : '就诊类型',
								store : new Ext.data.JsonStore({
									fields:['name','value'],
									data:[{name:'急诊',value:'E'},{name:'住院',value:'I'}]
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : false,
								triggerAction : 'all',
								displayField : 'name',
								valueField : 'value'
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'DISCONDateFrom',
							format : BDPDateFormat,
							id:'date1',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
							vtype:'cKDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							allowBlank:false
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'DISCONDateTo',
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
							id:'date2',
							vtype:'cKDate'
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
		width : 320,
		height: 400,
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
			id:'save_btn',
			iconCls : 'icon-save',
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
				Ext.getCmp("form-save").getForm().findField("DISCONCode").focus(true,300);
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
			            AliasGrid.DataRefer = _record.get('DISCONRowId');
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
								name : 'DISCONRowId',
								mapping : 'DISCONRowId',
								type : 'number'
							}, {
								name : 'DISCONCode',
								mapping : 'DISCONCode',
								type : 'string'
							}, {
								name : 'DISCONDesc',
								mapping : 'DISCONDesc',
								type : 'string'
							}, {
								name : 'DISCONDeadFlag',
								mapping : 'DISCONDeadFlag',
								type : 'string'
							}, {
								name : 'DISCONNationalCode',
								mapping : 'DISCONNationalCode',
								type : 'string'
							}, {
								name : 'DISCONEpisodeType',
								mapping : 'DISCONEpisodeType',
								type : 'string'
							},{
								name : 'DISCONDateFrom',
								mapping : 'DISCONDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'DISCONDateTo',
								mapping : 'DISCONDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
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
				//sortInfo: {field : "DISCONRowId",direction : "ASC"}
	});
	//ds.sort("DISCONCode","DESC");
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
			})

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
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'DISCONRowId',
							width : 70,
							sortable : true,
							dataIndex : 'DISCONRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'DISCONCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'DISCONDesc'
						}, {
							header : 'Status',
							width : 80,
							sortable : true,
							dataIndex : 'DISCONDeadFlag',
							renderer : function(v){
								if(v=='IP'){return 'InPatientAdmission';}
								if(v=='D'){return 'Death';}
								if(v=='WL'){return 'Waiting List';}
								if(v=='A'){return 'Appointment';}
								if(v=='T'){return 'Transfer';}
							}
						}, {
							header : 'National Code',
							width : 80,
							sortable : true,
							dataIndex : 'DISCONNationalCode'
						}, {
							header : '就诊类型',
							width : 80,
							sortable : true,
							dataIndex : 'DISCONEpisodeType',
							renderer : function(v){
								if(v=='E'){return '急诊';}
								if(v=='I'){return '住院';}
								
							}
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'DISCONDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'DISCONDateTo'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '出院条件',
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
                url : OPEN_ACTION_URL + '&id='+ _record.get('DISCONRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！')
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
            AliasGrid.DataRefer = _record.get('DISCONRowId');
	        AliasGrid.loadGrid();
			
    });
    //翻译
		btnTrans.on("click",function(){
			if (grid.selModel.hasSelection()) {		
	      			var _record = grid.getSelectionModel().getSelected();
	       			 var selectrow = _record.get('DISCONRowId');	           
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