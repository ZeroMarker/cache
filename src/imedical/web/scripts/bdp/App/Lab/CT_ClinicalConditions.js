	
	/// 名称:检验系统 - 2 临床条件维护
	/// 描述:包含增删改查功能
	/// 编写者:基础平台组 - 陈莹
	/// 编写日期:2013-12-5

Ext.onReady(function() {
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTClinicalConditions&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTClinicalConditions&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTClinicalConditions&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTClinicalConditions";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTClinicalConditions&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'under';
	
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
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTCLCRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
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
	
	// 增加修改的form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'CTCLCCode',mapping:'CTCLCCode'},
                                         {name: 'CTCLCDescriptionription',mapping:'CTCLCDescription'}, 
                                         {name: 'CTCLCRowId',mapping:'CTCLCRowId'}
                                        ]),
				items : [{
							id:'CTCLCRowId',
							xtype:'textfield',
							fieldLabel : 'CTCLCRowId',
							name : 'CTCLCRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'CTCLCCode',
							maxLength:10,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCLCCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCLCCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCLCCode')),
							name : 'CTCLCCode',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTClinicalConditions";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTCLCRowId');
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
							id:'CTCLCDescription',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCLCDescription'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCLCDescription'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCLCDescription')),
							name : 'CTCLCDescription',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTClinicalConditions";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTCLCRowId');
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
						}]	
	});
			
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 280,
		height: 160,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
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
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
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
				}
			}
		}, {
			text : '取消',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("form-save").getForm().findField("CTCLCDescription").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
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
	
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'CTCLCRowId',
								mapping : 'CTCLCRowId',
								type : 'string'
							}, {
								name : 'CTCLCCode',
								mapping : 'CTCLCCode',
								type : 'string'
							}, {
								name : 'CTCLCDescription',
								mapping : 'CTCLCDescription',
								type : 'string'
							
							}
						])
				//remoteSort : true
				//sortInfo: {field : "OPERRowId",direction : "ASC"}
	});
	//ds.sort("CTCLCCode","DESC");
			
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
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-']
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
						code :  Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue()
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
				items : ['代码：', {xtype : 'textfield',id : 'TextCode',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'-',
						'描述：', {xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-',
						'-',
						btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '临床条件',
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :[sm, {
							header : 'CTCLCRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTCLCRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'CTCLCCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'CTCLCDescription'
						
						
						}],
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


   // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTCLCRowId'),
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

    //双击事件
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
    });	
	
    if(window.ActiveXObject)
    {
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    } 
    
	//创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});