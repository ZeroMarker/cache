/// 名称: 角色对照
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-4-2
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var QUERY_DEFINE_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.Roles&pClassQuery=GetList";
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.RoleSubFilterDef&pClassQuery=GetList";
	var BindingRoles="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.Roles&pClassQuery=GetDataForCmb1";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.RoleSubFilterDef&pClassMethod=SaveData&pEntityName=web.Entity.KB.RoleSubFilterDef";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.RoleSubFilterDef&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.RoleSubFilterDef&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_define = Ext.BDP.FunLib.PageSize.Main;
/********************************角色************************************/	
	/** grid数据存储 */
	var dsDefine = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_DEFINE_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RoleRowId',
									mapping : 'RoleRowId',
									type : 'string'
								}, {
									name : 'Description',
									mapping : 'Description',
									type : 'string'
								}, {
									name : 'ParentRole',
									mapping : 'ParentRole',
									type : 'string'
								}, {
									name : 'Desc',
									mapping : 'Desc',
									type : 'string'
								}, {
									name : 'LicMax',
									mapping : 'LicMax',
									type : 'string'
								}, {
									name : 'MinDrl',
									mapping : 'MinDrl',
									type : 'string'
								}, {
									name : 'MdLog',
									mapping : 'MdLog',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : dsDefine
					});
	/** grid加载数据 */
	dsDefine.load({
		params : {
					start : 0,
					limit : pagesize_define
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var pagingDefine = new Ext.PagingToolbar({
				pageSize : pagesize_define,
				store : dsDefine,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_define=this.pageSize;
					}
				}
			});
	/** 搜索按钮 */
	var buttonSearch = new Ext.Button({
				id : 'buttonSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('buttonSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					gridDefine.getStore().baseParams={			
							desc : Ext.getCmp("textDesc").getValue()
					};
					gridDefine.getStore().load({
						params : {
									start : 0,
									limit : pagesize_define
								}
						});
					grid.getStore().load({
						params : {
							parref : 0,
							start : 0,
							limit : pagesize_main
						}
					});
				}
			});
	/** 重置按钮 */
	var buttonRefresh = new Ext.Button({
				id : 'buttonRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('buttonRefresh'),
				handler : function() {
					Ext.getCmp("textDesc").reset();
					gridDefine.getStore().baseParams={};
					gridDefine.getStore().load({
						params : {
									start : 0,
									limit : pagesize_define
								}
						});
					grid.getStore().load({
								params : {
									parref : 0,
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
	/** 搜索工具条 */
	var tbDefine = new Ext.Toolbar({
				id : 'tbDefine',
				items : [
						'描述:', {
							xtype : 'textfield',
							id : 'textDesc',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
						}, '-', buttonSearch, '-', buttonRefresh, '->'
				]
			});
	
	/** 创建grid */
	var gridDefine = new Ext.grid.GridPanel({
				id : 'gridDefine',
				region : 'west',
				width:650,
				split:true,
				collapsible:true,
				closable : true,
				store : dsDefine,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'RoleRowId',
							sortable : true,
							dataIndex : 'RoleRowId',
							hidden : true
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'Description'
						}, {
							header : 'ParentRole',
							sortable : true,
							dataIndex : 'ParentRole',
							hidden:true
						}, {
							header : '父角色',
							sortable : true,
							dataIndex : 'Desc'
						},  {
							header : 'LicMax',
							sortable : true,
							dataIndex : 'LicMax'
						},	{
							header : 'MinDrl',
							sortable : true,
							dataIndex : 'MinDrl'
						},  {
							header : 'MdLog',
							sortable : true,
							dataIndex : 'MdLog'
						}],
				stripeRows : true,
				title : '角色',
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingDefine,
				tbar : tbDefine,
				stateId : 'gridDefine'
			});
	/**默认选中*/
	gridDefine.store.on("load",function(){  
		if(gridDefine.getStore().getCount()!=0){
	        gridDefine.getSelectionModel().selectRow(0,true);  
	        var parref = gridDefine.getSelectionModel().getSelections()[0].get('RoleRowId');
		 	ds.load({
				params : {
					parref : parref,
					start : 0,
					limit : pagesize_main
				}
			});
		}
    }); 
	/**根据父定义表查询子明细表*/
	 gridDefine.on("rowclick", function(grid, rowIndex, e){
	 	var parref = gridDefine.getSelectionModel().getSelections()[0].get('RoleRowId');
	 	ds.load({
			params : {
				parref : parref,
				start : 0,
				limit : pagesize_main
			}
		});
	 });
/*******************************过滤器对照*************************************/
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function DelData() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('RoleRowId')
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
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'RoleRowId',mapping:'RoleRowId',type:'string'},
                         {name: 'RoleDR',mapping:'RoleDR',type:'string'},
                         {name: 'ClassName',mapping:'ClassName',type:'string'},
                         {name: 'Filter',mapping:'Filter',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'RoleRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'RoleRowId'
						}, {
							xtype : 'combo',
							hidden:true,
							//fieldLabel : '<font color=red>*</font>角色',
							name : 'RoleDR',
							id:'RoleDRF',
							hiddenName:'RoleDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RoleDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RoleDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '角色不能为空',
							allowBlank : false,
							valueField : 'RoleRowId',
							displayField : 'Description',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingRoles,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'RoleRowId',
								fields : ['RoleRowId', 'Description'],
								remoteSort : true,
								sortInfo : {
									field : 'RoleRowId',
									direction : 'ASC'
								}
							})
						}, {
							fieldLabel : '<font color=red>*</font>表名称',
							name : 'ClassName',
							id:'ClassNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClassNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClassNameF')),
							allowBlank : false,
							blankText:'表名称不能为空'/*,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.RoleSubFilterDef"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('RoleRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该表名称已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }*/
						}, {
							xtype:'textarea',
							height:100,
							fieldLabel : '<font color=red>*</font>过滤字符串',
							name : 'Filter',
							id:'FilterF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('FilterF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('FilterF')),
   							allowBlank:false,
   							blankText:'过滤字符串不能为空'
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 330,
		height : 320,
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
		items : WinForm,
		buttons : [{
			text : '保存',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var ClassName = Ext.getCmp("ClassNameF").getValue();
				var Filter = Ext.getCmp("FilterF").getValue();
				if(WinForm.form.isValid()==false){return;}
    			if (ClassName=="") {
    				Ext.Msg.show({ title : '提示', msg : '表名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (Filter=="") {
    				Ext.Msg.show({ title : '提示', msg : '过滤字符串不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
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
			text : '取消',
			handler : function() {
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("ClassName").focus(true,800);
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
				handler : function AddData() {
					if(gridDefine.selModel.hasSelection()){
						win.setTitle('添加');
						win.setIconClass('icon-add');
						win.show('new1');
						WinForm.getForm().reset();
						Ext.getCmp("RoleDRF").setValue(gridDefine.getSelectionModel().getSelected().get('RoleRowId'));
					}else{
						Ext.Msg.show({
							title : '提示',
							msg : '请选择一条指标定义!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}
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
				handler : function UpdateData() {
					if(grid.selModel.hasSelection()){
						var _record = grid.getSelectionModel().getSelected();
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('RoleRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
					}else{
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
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
									name : 'RoleRowId',
									mapping : 'RoleRowId',
									type : 'string'
								}, {
									name : 'ClassName',
									mapping : 'ClassName',
									type : 'string'
								}, {
									name : 'Filter',
									mapping : 'Filter',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : ds
					});
		/**加载分页参数**/
	ds.on('beforeload',function(thiz,options){ 
		if(gridDefine.getSelectionModel().getCount()!=0){
			Ext.apply(   
			  this.baseParams,   
			  {   
			     parref:gridDefine.getSelectionModel().getSelections()[0].get('RoleRowId')
			  }   
			)	
		}
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
	var tbbtn = new Ext.Toolbar({
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
							name : Ext.getCmp("ClassName").getValue()
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
					Ext.getCmp("ClassName").reset();
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
				items : ['表名称:', {
							xtype : 'textfield',
							id : 'ClassName',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ClassName')
						}, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbtn.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
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
							header : 'RoleRowId',
							sortable : true,
							dataIndex : 'RoleRowId',
							hidden : true
						}, {
							header : '表名称',
							sortable : true,
							dataIndex : 'ClassName'
						},  {
							header : '过滤字符串',
							sortable : true,
							dataIndex : 'Filter'
						}],
				stripeRows : true,
				title : '过滤器对照',
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
		                url : OPEN_ACTION_URL + '&id=' + _record.get('RoleRowId'),
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
				items : [gridDefine,grid]
			});
});
