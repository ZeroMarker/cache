/// 名称: 病人管理-国际协定
/// 描述: 包含增删改查功能
/// 编写者: sunfengchao
/// 编写日期: 2015-3-4
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var INAGCountryDR_ACTIONURL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCountry&pClassQuery=GetDataForCmb1";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTInternatAgreem&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTInternatAgreem&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTInternatAgreem";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTInternatAgreem&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTInternatAgreem&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var comboPage=Ext.BDP.FunLib.PageSize.Combo;
	//初始化“别名”维护面板
	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTInternatAgreem";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_InternatAgreem"
	});
	 Ext.BDP.FunLib.TableName="CT_InternatAgreem";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
	 var btnTrans=Ext.BDP.FunLib.TranslationBtn;
	 var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	 if (TransFlag=="false")
	 {
		btnTrans.hidden=false;
	  }
	 else
	 {
		btnTrans.hidden=true;
	 }
    //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName) ;
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
	       RowID=rows[0].get('INAGRowId');
	       Desc=rows[0].get('INAGDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  });
	/****************************** 删除按钮 ******************************/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler :DelData= function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						
						AliasGrid.DataRefer = rows[0].get('INAGRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('INAGRowId')
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
														 Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
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
	/** **********************************创建Form表单 ***************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 50,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'INAGRowId',mapping:'INAGRowId',type:'int'},
                                         {name: 'INAGCode',mapping:'INAGCode',type:'string'},
                                         {name: 'INAGDesc',mapping:'INAGDesc',type:'string'},
                                         {name: 'INAGCountryDR',mapping:'INAGCountryDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'INAGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'INAGRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
                            labelSeparator:"",
							name : 'INAGCode',
							id:'INAGCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('INAGCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INAGCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTInternatAgreem";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('INAGRowId'); //此条数据的rowid
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
                            labelSeparator:"",
							name : 'INAGDesc',
							id:'INAGDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('INAGDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INAGDescF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTInternatAgreem"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('INAGRowId'); //此条数据的rowid
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
							xtype : "bdpcombo",
                            labelSeparator:"",
							fieldLabel : '国家',
                            loadByIdParam:'rowid',
                            hiddenName : 'INAGCountryDR',
                            id:'INAGCountryDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('INAGCountryDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('INAGCountryDRF')),
							store : new Ext.data.Store({
										autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
										proxy : new Ext.data.HttpProxy({ url : INAGCountryDR_ACTIONURL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTCOURowId',mapping:'CTCOURowId'},
										{name:'CTCOUDesc',mapping:'CTCOUDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'CTCOUDesc',
							valueField : 'CTCOURowId'
						}]
			});
	
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 200,
		 items : [WinForm, AliasGrid]
	 });
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	/*********************************** 增加修改时弹出窗口 **********************************/
	var win = new Ext.Window({
		width : 400,
		layout : 'fit',
		plain : true, // true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		constrain : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("form-save").getForm().findField("INAGCode").getValue();
				var tempDesc = Ext.getCmp("form-save").getForm().findField("INAGDesc").getValue();
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
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
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
								
								//保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
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
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									//保存别名
									AliasGrid.saveAlias();
									
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
				Ext.getCmp("form-save").getForm().findField("INAGCode").focus(true,800);
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	/************************************ 添加按钮 *****************************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				},
				scope : this
			});
	/*********************************** 修改按钮 **************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				handler : UpdateData=function() {
						var _record = grid.getSelectionModel().getSelected();
						if (!_record) {
				            Ext.Msg.show({
											title : '提示',
											msg : '请选择需要修改的行!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
				       	 } else {
				            win.setTitle('修改');
							win.setIconClass('icon-update');
							win.show('');
							Ext.getCmp("form-save").getForm().reset();
				            Ext.getCmp("form-save").getForm().load({
				                url : OPEN_ACTION_URL + '&id=' + _record.get('INAGRowId'),
				                success : function(form,action) {
				                },
				                failure : function(form,action) {
				                	Ext.Msg.alert('编辑', '载入失败');
				                }
				            });
			            
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('INAGRowId');
				        AliasGrid.loadGrid();
				        }
				}
			});
	/** grid数据存储 */
	var fields=[{
					name : 'INAGRowId',
					mapping : 'INAGRowId',
					type : 'int'
				}, {
					name : 'INAGCode',
					mapping : 'INAGCode',
					type : 'string'
				}, {
					name : 'INAGDesc',
					mapping : 'INAGDesc',
					type : 'string'
				},{
					name:'INAGCountryDR',
					mapping:'INAGCountryDR',
					type:'string'
				}]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields)
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
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
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
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
					Ext.BDP.FunLib.SelectRowId="";
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
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},'-',LookUpConfigureBtn, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) 
					}
				}
			});
	/** 创建grid */
	var GridCM=[new Ext.grid.CheckboxSelectionModel(),
						{
							header : 'INAGRowId',
							sortable : true,
							dataIndex : 'INAGRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'INAGCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'INAGDesc'
						},{
							header:'国家',
							sortable:true,
							dataIndex:'INAGCountryDR'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				title : '国际协定',
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, 
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
		Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);	
		/// 单击事件：翻译要用到
		btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('INAGRowId');
		 }
		else
		{
		  var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
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
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('INAGRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		         	
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('INAGRowId');
			        AliasGrid.loadGrid();
		        }
			});
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/****************************** 调用keymap ****************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});
