/// 名称: 妊娠结果
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组- 
/// 编写日期: 2012-8-29
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACOutcomeOfPregnancy&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACOutcomeOfPregnancy&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACOutcomeOfPregnancy";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACOutcomeOfPregnancy&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACOutcomeOfPregnancy&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.PACOutcomeOfPregnancy";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_OutcomeOfPregnancy"
	});
	Ext.BDP.FunLib.TableName="PAC_OutcomeOfPregnancy";
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
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName);
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
       RowID=rows[0].get('OPREGRowId');
       Desc=rows[0].get('OPREGDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  }); 
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('OPREGRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('OPREGRowId')
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
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 120,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'OPREGRowId',mapping:'OPREGRowId',type:'int'},
                                         {name: 'OPREGCode',mapping:'OPREGCode',type:'string'},
                                         {name: 'OPREGDesc',mapping:'OPREGDesc',type:'string'},
                                         {name: 'OPREGNationalCode',mapping:'OPREGNationalCode',type:'string'},
                                         {name: 'OPREGUseForPara',mapping:'OPREGUseForPara',type:'string'},
                                         {name: 'OPREGOutcomeType',mapping:'OPREGOutcomeType',type:'string'},
                                         {name: 'OPREGAutoRegister',mapping:'OPREGAutoRegister',type:'string'},
                                         {name: 'OPREGAutoAdmit',mapping:'OPREGAutoAdmit',type:'string'}
                                   ]),
				defaults : {
					anchor : '85%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'OPREGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'OPREGRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
                            labelSeparator:"",
							name : 'OPREGCode',
							id:'OPREGCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACOutcomeOfPregnancy";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('OPREGRowId'); //此条数据的rowid
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
							name : 'OPREGDesc',
							id:'OPREGDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGDescF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACOutcomeOfPregnancy"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('OPREGRowId'); //此条数据的rowid
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
						}, {
							fieldLabel : 'NationalCode',
                            labelSeparator:"",
							name : 'OPREGNationalCode',
							id:'OPREGNationalCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGNationalCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGNationalCodeF'))
						}, {
							xtype : 'combo',
                            labelSeparator:"",
							fieldLabel : '分娩结果类型',
							hiddenName : 'OPREGOutcomeType',
							id:'OPREGOutcomeTypeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGOutcomeTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGOutcomeTypeF')),
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['LC', 'Living Children'],
											['MB', 'Multiple Birth'],
											['PB', 'Preterm Birth'],
											['TP', 'Termination of Pregnancy'],
											['TAM', 'Therapeutic Abortion/Miscarriage']
										]
							}),
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, {
							xtype : 'checkbox',
                            labelSeparator:"",
							fieldLabel : 'UseForPara',
							name : 'OPREGUseForPara',
							id:'OPREGUseForParaF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGUseForParaF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGUseForParaF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
                            labelSeparator:"",
							fieldLabel : '自动注册患者信息',
							name : 'OPREGAutoRegister',
							id:'OPREGAutoRegisterF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGAutoRegisterF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGAutoRegisterF')),
							inputValue : 'Y'
						}, {
							xtype : 'checkbox',
                            labelSeparator:"",
							fieldLabel : '自动入院登记',
							name : 'OPREGAutoAdmit',
							id:'OPREGAutoAdmitF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OPREGAutoAdmitF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OPREGAutoAdmitF')),
							inputValue : 'Y'
						}]
			});
	
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 240,
		 items : [WinForm, AliasGrid]
	 });
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 420,
		height : 360,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
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
				var tempCode = Ext.getCmp("form-save").getForm().findField("OPREGCode").getValue();
				var tempDesc = Ext.getCmp("form-save").getForm().findField("OPREGDesc").getValue();
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
				Ext.getCmp("form-save").getForm().findField("OPREGCode").focus(true,800);
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
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
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
			                url : OPEN_ACTION_URL + '&id=' + _record.get('OPREGRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('OPREGRowId');
				        AliasGrid.loadGrid();
			        }
				}
			});
	/** grid数据存储 */
	var fields=[{
					name : 'OPREGRowId',
					mapping : 'OPREGRowId',
					type : 'int'
				}, {
					name : 'OPREGCode',
					mapping : 'OPREGCode',
					type : 'string'
				}, {
					name : 'OPREGDesc',
					mapping : 'OPREGDesc',
					type : 'string'
				}, {
					name : 'OPREGNationalCode',
					mapping : 'OPREGNationalCode',
					type : 'string'
				}, {
					name : 'OPREGUseForPara',
					mapping : 'OPREGUseForPara',
					type : 'string'
				}, {
					name : 'OPREGOutcomeType',
					mapping : 'OPREGOutcomeType',
					type : 'string'
				}, {
					name : 'OPREGAutoRegister',
					mapping : 'OPREGAutoRegister',
					type : 'string'
				}, {
					name : 'OPREGAutoAdmit',
					mapping : 'OPREGAutoAdmit',
					type : 'string'
				} ]
						
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }), 
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
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue(),
							OutcomeType : Ext.getCmp("OutcomeType").getValue()
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
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("OutcomeType").reset();
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
						}, '-',
						'分娩结果类型', {
							xtype : 'combo',
							id : 'OutcomeType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('OutcomeType'),
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['LC', 'Living Children'],
											['MB', 'Multiple Birth'],
											['PB', 'Preterm Birth'],
											['TP', 'Termination of Pregnancy'],
											['TAM', 'Therapeutic Abortion/Miscarriage']
										]
							}),
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							minChars : 1,
							valueField : 'value',
							displayField : 'text'
						},'-',LookUpConfigureBtn, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	
	/** 创建grid */
	var GridCM= [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'OPREGRowId',
							sortable : true,
							dataIndex : 'OPREGRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'OPREGCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'OPREGDesc'
						}, {
							header : 'NationalCode',
							sortable : true,
							dataIndex : 'OPREGNationalCode'
						}, {
							header : '分娩结果类型',
							sortable : true,
							dataIndex : 'OPREGOutcomeType',
							renderer : function(v){
								if(v=='LC'){ return 'Living Children'; }
								if(v=='MB'){ return 'Multiple Birth'; }
								if(v=='PB'){ return 'Preterm Birth'; }
								if(v=='TP'){ return 'Termination of Pregnancy'; }
								if(v=='TAM'){ return 'Therapeutic Abortion/Miscarriage'; }
							}
						}, {
							header : 'UseForPara',
							sortable : true,
							dataIndex : 'OPREGUseForPara',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '自动注册患者信息',
							sortable : true,
							dataIndex : 'OPREGAutoRegister',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '自动入院登记',
							sortable : true,
							dataIndex : 'OPREGAutoAdmit',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				title : '妊娠结果',
				//stateful : true,
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
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
		/// 单击事件：翻译要用到
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('OPREGRowId');
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
		                url : OPEN_ACTION_URL + '&id=' + _record.get('OPREGRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		         	
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('OPREGRowId');
			        AliasGrid.loadGrid();
		        }
			});
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
});
