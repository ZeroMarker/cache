	
	/// 名称：清业务数据维护信息
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 谷雪萍
	/// 编写日期:2015-9-15
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.DHCClearBusinessData&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCClearBusinessData&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.DHCClearBusinessData&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.DHCClearBusinessData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.DHCClearBusinessData&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();

	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BDP.FunLib.TableName="DHC_ClearBusinessData";
	
	
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		hidden : true,
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ClearRowID')
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
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 110,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ClearProductGroup',mapping:'ClearProductGroup'},
                                         {name: 'ClearGlobal',mapping:'ClearGlobal'},
                                         {name: 'ClearGlobalTable',mapping:'ClearGlobalTable'},
                                         {name: 'ClearDesc',mapping:'ClearDesc'},
                                         {name: 'ClearStatus',mapping:'ClearStatus'},
                                         {name: 'ClearNamespace',mapping:'ClearNamespace'},
                                         {name: 'ClearRowID',mapping:'ClearRowID'}
                                        ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'ClearRowIDF',
							xtype:'textfield',
							fieldLabel : 'ClearRowID',
							name : 'ClearRowID',
							hideLabel : 'True',
							hidden : true
						}, {
							fieldLabel : '产品组',
							xtype:'textfield',
							id:'ClearProductGroupF',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ClearProductGroup'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearProductGroupF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearProductGroupF')),
							name : 'ClearProductGroup'
						}, {
							fieldLabel : '<font color=red>*</font>Global名称',
							xtype:'textfield',
							id:'ClearGlobalF',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ClearGlobal'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearGlobalF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearGlobalF')),
							name : 'ClearGlobal',
							allowBlank:false,
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.DHCClearBusinessData";
	                            var classMethod = "Validate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ClearRowID');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该Global名称已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}, {
							fieldLabel : 'Global对应的表名',
							xtype:'textfield',
							id:'ClearGlobalTableF',
							maxLength:30,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ClearGlobal'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearGlobalTableF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearGlobalTableF')),
							name : 'ClearGlobalTable',
							allowBlank:true
						}, {
								fieldLabel : '中文描述',
								xtype:'textfield',
								id:'ClearDescF',
								maxLength:30,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearDescF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearDescF')),
								name : 'ClearDesc'
						},{
								fieldLabel : '命名空间',
								xtype:'textfield',
								id:'ClearNamespaceF',
								maxLength:30,
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearNamespaceF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearNamespaceF')),
								name : 'ClearNamespace'
						}, {
								xtype : 'combo',
								listWidth:140,
								id:'ClearStatusF',
								name:'ClearStatus',
								hiddenName : 'ClearStatus', //若没有hiddenname 传入的值是name
								readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClearStatusF'),
								style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClearStatusF')),
								fieldLabel : '有效标记',
								store : new Ext.data.JsonStore({
									fields:['name','value'],
									data:[{name:'有效',value:'1'},{name:'无效',value:'0'}]
								}),
								mode : 'local',
								queryParam : 'desc',
								shadow:false,
								forceSelection : true,
								selectOnFocus : true,
								triggerAction : 'all',
								displayField : 'name',
								valueField : 'value',
								listeners :{  
								        "beforerender":function(){  
								        	Ext.getCmp("ClearStatusF").setValue('1');  
								        }
									}
						}]	
	});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm]
			 });		
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 420,
		height: 350,
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
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
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
										var myrowid = "rowid="+action.result.id;

										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {												
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
									Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
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
				Ext.getCmp("form-save").getForm().findField("ClearProductGroup").focus(true,300);
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
					win.show('new1');
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
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'ClearRowID',
								mapping : 'ClearRowID',
								type : 'string'
							}, {
								name : 'ClearProductGroup',
								mapping : 'ClearProductGroup',
								type : 'string'
							}, {
								name : 'ClearGlobal',
								mapping : 'ClearGlobal',
								type : 'string'
							}, {
								name : 'ClearGlobalTable',
								mapping : 'ClearGlobalTable',
								type : 'string'
							}, {
								name : 'ClearDesc',
								mapping : 'ClearDesc',
								type : 'string'
							}, {
								name : 'ClearNamespace',
								mapping : 'ClearNamespace',
								type : 'string'
							}, {
								name : 'ClearStatus',
								mapping : 'ClearStatus',
								type : 'string'
							}
						])
				//remoteSort : true
				//sortInfo: {field : "ClearRowID",direction : "ASC"}
	});
	//ds.sort("ClearProductGroup","DESC");
			
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

	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel]
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
						group : Ext.getCmp("TextGroup").getValue(),						
						global : Ext.getCmp("TextGlobal").getValue(),
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
					Ext.getCmp("TextGroup").reset(); 
					Ext.getCmp("TextGlobal").reset();
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
				items : ['产品组', {xtype : 'textfield',id : 'TextGroup',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextGroup')},'-',
						'Global名称', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextGlobal',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextGlobal')},'-', 
						'中文描述', {xtype : 'textfield',emptyText : '中文描述',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-', 
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
				title : '清业务数据维护信息',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :[sm, {
							header : 'ClearRowID',
							width : 70,
							sortable : true,
							dataIndex : 'ClearRowID',
							hidden : true
						}, {
							header : '产品组',
							width : 80,
							sortable : true,
							dataIndex : 'ClearProductGroup'
						}, {
							header : 'Global名称',
							width : 100,
							sortable : true,
							dataIndex : 'ClearGlobal'
						}, {
							header : 'Global对应的表名',
							width : 80,
							sortable : true,
							dataIndex : 'ClearGlobalTable'
						}, {
							header : '中文描述',
							width : 80,
							sortable : true,
							dataIndex : 'ClearDesc'
						}, {
							header : '命名空间',
							width : 80,
							sortable : true,
							dataIndex : 'ClearNamespace'
						},{
							header : '有效标记',
							width : 80,
							sortable : true,
							dataIndex : 'ClearStatus',
							renderer : function(v){
								if(v=='1'){return '有效';}
								if(v=='0'){return '无效';}
								
							}
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
        if (!grid.selModel.hasSelection()) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ClearRowID'),
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
    	/** grid双击事件 */
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
			
    });

    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,"");
    
	// 创建viewport
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});

});