/// 名称: 科室开医嘱限制 
/// 描述: 包含增删查功能
/// 编写者: sunfnegchao
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
 /// 获取到表的 ID 
 var OrderLimtParRef= Ext.getUrlParam('OrderLimtParRef');   
 Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif'; 
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side'; 
	var CTLocOrderLimit_CTLoc_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	var CTLocOrderLimit_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocOrderLimit&pClassQuery=GetList";
	var CTLocOrderLimit_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocOrderLimit&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocOrderLimit";
	var CTLocOrderLimit_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocOrderLimit&pClassMethod=DeleteData";
	var CTLocOrderLimit_pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;

	/** 删除按钮 */
	var CTLocOrderLimit_btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除',
					iconCls : 'icon-delete',
					id:'CTLocOrderLimit_del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocOrderLimit_del_btn'),
					handler : function CTLocOrderLimit_DelData() {
						if (CTLocOrderLimit_grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') { 
									var gsm = CTLocOrderLimit_grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									for(var i=0;i<rows.length;i++){
										Ext.Ajax.request({
											url : CTLocOrderLimit_DELETE_ACTION_URL,
											method : 'POST',
											params : {
												'id' : rows[i].get('OrderLimtRowId')
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
																var startIndex = CTLocOrderLimit_grid.getBottomToolbar().cursor;
																var totalnum=CTLocOrderLimit_grid.getStore().getTotalCount();
																if((totalnum!=1)&&(totalnum/CTLocOrderLimit_pagesize_pop!=0)&&(totalnum%CTLocOrderLimit_pagesize_pop==1)){ startIndex-=CTLocOrderLimit_pagesize_pop; }
																CTLocOrderLimit_grid.getStore().load({
																			params : {
																				start : startIndex,
																				limit : CTLocOrderLimit_pagesize_pop,
																				OrderLimtParRef : Ext.getCmp('CTLocOrderLimit_CTLocID').getValue()
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
	/** checkbox数据存储 */
	var CTLocOrderLimit_ds_CTLoc = new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({ url : CTLocOrderLimit_CTLoc_ACTION_URL }),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'ARCIMRowId', 'ARCIMDesc' ])
			});
	/** 创建Form表单 */
	var CTLocOrderLimit_WinForm = new Ext.form.FormPanel({
				id : 'CTLocOrderLimit-form-save',
				labelAlign : 'right',
				labelWidth : 100,
				baseCls : 'x-plain',
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'OrderLimtParRef',
							hideLabel : 'True',
							hidden : true,
							name : 'OrderLimtParRef'
						}, {
							xtype:'bdpcombo',
							loadByIdParam : 'rowid',
							fieldLabel : '<font color=red>*</font>医嘱项',
							name : 'OrderLimtARCItmMastDR',
							hiddenName : 'OrderLimtARCItmMastDR',
							id:'OrderLimtARCItmMastDRF',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('OrderLimtARCItmMastDRF'),
							allowBlank : false,
							store : CTLocOrderLimit_ds_CTLoc,
							listWidth : 330,
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true, 
							valueField : 'ARCIMRowId',
							displayField : 'ARCIMDesc'
						}]
			});
	/** 增加修改时弹出窗口 */
	var CTLocOrderLimit_win = new Ext.Window({
					height: 130,
					width : 330,
					layout : 'fit',
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : CTLocOrderLimit_WinForm,
					buttons : [{
						text : '保存',
						id:'CTLocOrderLimit_save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocOrderLimit_save_btn'),
						handler : function () {
							var OrderLimtARCItmMastDR = Ext.getCmp("CTLocOrderLimit-form-save").getForm().findField("OrderLimtARCItmMastDR").getValue();
			    			if (OrderLimtARCItmMastDR=="") {
			    				Ext.Msg.show({ title : '提示', msg : '医嘱姓不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			} 
							if (CTLocOrderLimit_win.title == "添加") {
								CTLocOrderLimit_WinForm.form.submit({
									clientValidation : true, // 进行客户端验证 
									waitTitle : '提示',
									url : CTLocOrderLimit_SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											CTLocOrderLimit_win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															CTLocOrderLimit_grid.getStore().load({
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
							} else {}
						}
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							CTLocOrderLimit_win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp('CTLocOrderLimit_CTLocID').setValue(OrderLimtParRef)
						},
						"hide" : function() {
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var CTLocOrderLimit_btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'CTLocOrderLimit_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocOrderLimit_add_btn'),
				handler : function CTLocOrderLimit_AddData() {
					CTLocOrderLimit_win.setTitle('添加');
					CTLocOrderLimit_win.setIconClass('icon-add');
					CTLocOrderLimit_win.show('new1');
					CTLocOrderLimit_WinForm.getForm().reset();
					Ext.getCmp("CTLocOrderLimit-form-save").getForm().findField('OrderLimtParRef').setValue(Ext.getCmp('CTLocOrderLimit_CTLocID').getValue());
				},
				scope : this
			});
	
	/** CTLocOrderLimit_grid数据存储 */
	var CTLocOrderLimit_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CTLocOrderLimit_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'OrderLimtRowId',
									mapping : 'OrderLimtRowId',
									type : 'string'
								},{
									name:'CTLocDesc',
									mapping:'CTLocDesc',
									type:'string'
								}, {
									name : 'ARCIMCode',
									mapping : 'ARCIMCode',
									type : 'string'
								}, {
									name : 'ARCIMDesc',
									mapping : 'ARCIMDesc',
									type : 'string'
								}, {
									name : 'OrderLimtARCItmMastDR',
									mapping : 'OrderLimtARCItmMastDR',
									type : 'string'
								}
						])
			}); 

	
	/** CTLocOrderLimit_grid分页工具条 */
	var CTLocOrderLimit_paging = new Ext.PagingToolbar({
				pageSize : CTLocOrderLimit_pagesize_pop,
				store : CTLocOrderLimit_ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             CTLocOrderLimit_pagesize_pop = this.pageSize;
				         }
		        }
			});
	/** 增删改工具条 */
	var CTLocOrderLimit_tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [CTLocOrderLimit_btnAddwin, '-', CTLocOrderLimit_btnDel]
		});
	/** 搜索按钮 */
	var CTLocOrderLimit_btnSearch = new Ext.Button({
				id : 'CTLocOrderLimit_btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocOrderLimit_btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var TextARCItmMastDR=Ext.getCmp("TextARCItmMastDR").getValue();
					CTLocOrderLimit_grid.getStore().baseParams={
							ParRef : OrderLimtParRef
					};
					CTLocOrderLimit_grid.getStore().load({
						params : {
							start : 0,
							limit : CTLocOrderLimit_pagesize_pop,
							ARCIMDR:TextARCItmMastDR
						}
					});
				}
			});
	/** 重置按钮 */
	var CTLocOrderLimit_btnRefresh = new Ext.Button({
				id : 'CTLocOrderLimit_btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocOrderLimit_btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextARCItmMastDR").reset(); 
					CTLocOrderLimit_grid.getStore().baseParams={ParRef : OrderLimtParRef };
					CTLocOrderLimit_grid.getStore().load({
								params : {
									start : 0,
									limit : CTLocOrderLimit_pagesize_pop 
								}
							});
				}
			});
	/** 搜索工具条 */
	var CTLocOrderLimit_tb = new Ext.Toolbar({
				id : 'CTLocOrderLimit_tb',
				items : [{  
							xtype : 'textfield',
							hidden:true,
							id:'CTLocOrderLimit_CTLocID'
						},'医嘱项', {
							xtype:'bdpcombo',
							loadByIdParam : 'rowid', 
							id:'TextARCItmMastDR',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextARCItmMastDR'), 
							store : CTLocOrderLimit_ds_CTLoc,
							listWidth : 330,
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true, 
							valueField : 'ARCIMRowId',
							displayField : 'ARCIMDesc'
						}, '-', CTLocOrderLimit_btnSearch, '-', CTLocOrderLimit_btnRefresh, '->'
				],
				listeners : {
					render : function() {
						CTLocOrderLimit_tbbutton.render(CTLocOrderLimit_grid.tbar);
					}
				}
			});
	/** 创建CTLocOrderLimit_grid */ 
	var childsm = new Ext.grid.CheckboxSelectionModel({ ///可以多选
				singleSelect : false,
				checkOnly : false,
				width : 20
	});
	var CTLocOrderLimit_grid = new Ext.grid.GridPanel({
				id : 'CTLocOrderLimit_grid',
				region : 'center', 
				store : CTLocOrderLimit_ds,
				trackMouseOver : true,				
				columns : [childsm, // 单选列
						{
							header : 'OrderLimtRowId',
							sortable : true,
							dataIndex : 'OrderLimtRowId',
							hidden : true
						}, {
							header : '科室',
							sortable : true,
							dataIndex : 'CTLocDesc'
						},{
							header:'医嘱代码',
							sortable:true,
							dataIndex:'ARCIMCode',
							hidden:true
						},{
							header : '医嘱名称',
							sortable : true,
							dataIndex : 'ARCIMDesc'
						}],
				stripeRows : true,
				viewConfig : {
					forceFit : true
				},
				sm : childsm, // 按"Ctrl+鼠标左键"也只能单选
				bbar : CTLocOrderLimit_paging,
				tbar : CTLocOrderLimit_tb,
				stateId : 'CTLocOrderLimit_grid'
			});
			
	CTLocOrderLimit_grid.getStore().baseParams={
			ParRef : OrderLimtParRef
	};
	CTLocOrderLimit_grid.getStore().load({
		params : {
			start : 0,
			limit : CTLocOrderLimit_pagesize_pop
		}
	});
	 
	var winCTLocOrderLimit = new Ext.Window({
			title:'',
			width:700,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: CTLocOrderLimit_grid,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		}); 
  	 	var CTLocOrderLimit_viewport = new Ext.Viewport({
				layout : 'border',
				items : [CTLocOrderLimit_grid]
			}); 
	   Ext.BDP.FunLib.ShowUserHabit(CTLocOrderLimit_grid,"User.CTLocOrderLimit");
}); 


