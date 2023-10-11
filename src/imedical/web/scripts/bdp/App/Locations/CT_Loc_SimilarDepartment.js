/// 名称: 相似部门维护
/// 描述: 包含增删查功能
/// 编写者: 基础数据平台组-李森
/// 编写日期: 2013-6-5
/// 修改日期：  2013-6-5 by 蔡昊哲
//Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var CTLocSimilarDepartment_CTLoc_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var CTLocSimilarDepartment_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocSimilarDepartment&pClassQuery=GetList";
	var CTLocSimilarDepartment_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocSimilarDepartment&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocSimilarDepartment";
	var CTLocSimilarDepartment_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocSimilarDepartment&pClassMethod=DeleteData";
	var CTLocSimilarDepartment_pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;

	/** 删除按钮 */
	var CTLocSimilarDepartment_btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除',
					iconCls : 'icon-delete',
					id:'CTLocSimilarDepartment_del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocSimilarDepartment_del_btn'),
					handler : function CTLocSimilarDepartment_DelData() {
						if (CTLocSimilarDepartment_grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = CTLocSimilarDepartment_grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									Ext.Ajax.request({
										url : CTLocSimilarDepartment_DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('DEPRowId')
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
															var startIndex = CTLocSimilarDepartment_grid.getBottomToolbar().cursor;
															var totalnum=CTLocSimilarDepartment_grid.getStore().getTotalCount();
															if((totalnum!=1)&&(totalnum/CTLocSimilarDepartment_pagesize_pop!=0)&&(totalnum%CTLocSimilarDepartment_pagesize_pop==1)){ startIndex-=CTLocSimilarDepartment_pagesize_pop; }
															CTLocSimilarDepartment_grid.getStore().load({
																		params : {
																			start : startIndex,
																			limit : CTLocSimilarDepartment_pagesize_pop,
																			DEPParRef : Ext.getCmp('CTLocSimilarDepartment_CTLocID').getValue()
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
	/** checkbox数据存储 */
	var CTLocSimilarDepartment_ds_CTLoc = new Ext.data.Store({
				autoLoad : true,
				proxy : new Ext.data.HttpProxy({ url : CTLocSimilarDepartment_CTLoc_ACTION_URL }),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [ 'CTLOCRowID', 'CTLOCDesc' ])
			});
	/** 创建Form表单 */
	var CTLocSimilarDepartment_WinForm = new Ext.form.FormPanel({
				id : 'CTLocSimilarDepartment-form-save',
				labelAlign : 'right',
				labelWidth : 100,
				baseCls : 'x-plain',
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'DEPParRef',
							hideLabel : 'True',
							hidden : true,
							name : 'DEPParRef'
						}, {
							xtype:'bdpcombo',
							loadByIdParam : 'rowid',
							fieldLabel : '<font color=red>*</font>相似部门',
							name : 'DEPCTLOCDR',
							hiddenName : 'DEPCTLOCDR',
							id:'DEPCTLOCDRF',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('DEPCTLOCDRF'),
							allowBlank : false,
							store : CTLocSimilarDepartment_ds_CTLoc,
							listWidth : 330,
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,//true表示获取焦点时选中既有值
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
											desc:e.query,
											hospid:Ext.getCmp("hidden_SimilarDepHOSPDR").getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
								
									}
							}
						}]
			});
	/** 增加修改时弹出窗口 */
	var CTLocSimilarDepartment_win = new Ext.Window({
					title : '',
					width : 330,
					height:150,
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
					items : CTLocSimilarDepartment_WinForm,
					buttons : [{
						text : '保存',
						id:'CTLocSimilarDepartment_save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocSimilarDepartment_save_btn'),
						handler : function () {
							var DEPCTLOCDR = Ext.getCmp("CTLocSimilarDepartment-form-save").getForm().findField("DEPCTLOCDR").getValue();
			    			if (DEPCTLOCDR=="") {
			    				Ext.Msg.show({ title : '提示', msg : '相似部门不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(CTLocSimilarDepartment_WinForm.form.isValid()==false){return;}
							if (CTLocSimilarDepartment_win.title == "添加") {
								CTLocSimilarDepartment_WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : CTLocSimilarDepartment_SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											CTLocSimilarDepartment_win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															CTLocSimilarDepartment_grid.getStore().load({
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
							CTLocSimilarDepartment_win.hide();
						}
					}],
					listeners : {
						"show" : function() {
						},
						"hide" : function() {
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var CTLocSimilarDepartment_btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'CTLocSimilarDepartment_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocSimilarDepartment_add_btn'),
				handler : function CTLocSimilarDepartment_AddData() {
					CTLocSimilarDepartment_win.setTitle('添加');
					CTLocSimilarDepartment_win.setIconClass('icon-add');
					CTLocSimilarDepartment_win.show('new1');
					CTLocSimilarDepartment_WinForm.getForm().reset();
					Ext.getCmp("CTLocSimilarDepartment-form-save").getForm().findField('DEPParRef').setValue(Ext.getCmp('CTLocSimilarDepartment_CTLocID').getValue());
				},
				scope : this
			});
	
	/** CTLocSimilarDepartment_grid数据存储 */
	var CTLocSimilarDepartment_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CTLocSimilarDepartment_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'DEPRowId',
									mapping : 'DEPRowId',
									type : 'string'
								}, {
									name : 'DEPCTLOCDRCode',
									mapping : 'DEPCTLOCDRCode',
									type : 'string'
								}, {
									name : 'DEPCTLOCDR',
									mapping : 'DEPCTLOCDR',
									type : 'string'
								}
						])
			});
	/** CTLocSimilarDepartment_grid数据加载遮罩 */
	/*var CTLocSimilarDepartment_loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : CTLocSimilarDepartment_ds
					});*/
	
	/** CTLocSimilarDepartment_grid分页工具条 */
	var CTLocSimilarDepartment_paging = new Ext.PagingToolbar({
				pageSize : CTLocSimilarDepartment_pagesize_pop,
				store : CTLocSimilarDepartment_ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             CTLocSimilarDepartment_pagesize_pop = this.pageSize;
				         }
		        }
			});
	/** 增删改工具条 */
	var CTLocSimilarDepartment_tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [CTLocSimilarDepartment_btnAddwin, '-', CTLocSimilarDepartment_btnDel]
		});
	/** 搜索按钮 */
	var CTLocSimilarDepartment_btnSearch = new Ext.Button({
				id : 'CTLocSimilarDepartment_btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocSimilarDepartment_btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : SD_search=function() {
					CTLocSimilarDepartment_grid.getStore().baseParams={
							DEPParRef : Ext.getCmp('CTLocSimilarDepartment_CTLocID').getValue(),
							DEPDesc : Ext.getCmp("TextCode2").getValue()
					};
					CTLocSimilarDepartment_grid.getStore().load({
						params : {
							start : 0,
							limit : CTLocSimilarDepartment_pagesize_pop
						}
					});
				}
			});
	/** 重置按钮 */
	var CTLocSimilarDepartment_btnRefresh = new Ext.Button({
				id : 'CTLocSimilarDepartment_btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLocSimilarDepartment_btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : SD_refresh=function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextCode2").reset();
					CTLocSimilarDepartment_grid.getStore().baseParams={};
					CTLocSimilarDepartment_grid.getStore().load({
								params : {
									start : 0,
									limit : CTLocSimilarDepartment_pagesize_pop,
									DEPParRef : Ext.getCmp('CTLocSimilarDepartment_CTLocID').getValue()
								}
							});
				}
			});
	/** 搜索工具条 */
	var CTLocSimilarDepartment_tb = new Ext.Toolbar({
				id : 'CTLocSimilarDepartment_tb',
				items : [{ //'病区ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'CTLocSimilarDepartment_CTLocID'
						},'相似部门描述', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
							id : 'TextCode2',
							enableKeyEvents: true,
							listeners:{
								keyup:function(node, event) {
									if(event.getKey()==13){
										SD_search()
									}
								},
								scope: this
							}
						}, '-', CTLocSimilarDepartment_btnSearch, '-', CTLocSimilarDepartment_btnRefresh, '->',{ //医院id
							xtype : 'textfield',
							hidden:true,
							id:'hidden_SimilarDepHOSPDR'
						}
				],
				listeners : {
					render : function() {
						CTLocSimilarDepartment_tbbutton.render(CTLocSimilarDepartment_grid.tbar);
					}
				}
			});
	/** 创建CTLocSimilarDepartment_grid */
	var CTLocSimilarDepartment_grid = new Ext.grid.GridPanel({
				id : 'CTLocSimilarDepartment_grid',
				region : 'center',
				closable : true,
				store : CTLocSimilarDepartment_ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'DEPRowId',
							sortable : true,
							dataIndex : 'DEPRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'DEPCTLOCDRCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'DEPCTLOCDR'
						}],
				stripeRows : true,
				viewConfig : {
					forceFit : true
				},
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : CTLocSimilarDepartment_paging,
				tbar : CTLocSimilarDepartment_tb,
				stateId : 'CTLocSimilarDepartment_grid'
			});
			
	Ext.BDP.FunLib.ShowUserHabit(CTLocSimilarDepartment_grid,"User.CTLocSimilarDepartment");
	
/*	*//** 布局 *//*
	var CTLocSimilarDepartment_viewport = new Ext.Viewport({
				layout : 'border',
				items : [CTLocSimilarDepartment_grid]
			});*/
	
	// 保存病区ID
	//Ext.getCmp('CTLocSimilarDepartment_CTLocID').setValue('314');
	
	
	/** CTLocSimilarDepartment_grid加载数据 */
/*	CTLocSimilarDepartment_ds.load({
				params : {
					start : 0,
					limit : CTLocSimilarDepartment_pagesize_pop,
					DEPParRef : Ext.getCmp('CTLocSimilarDepartment_CTLocID').getValue()
				},
				callback : function(records, options, success) {
					// alert(options);
					// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
				}
			});*/
	
			 function getCTLocSimilarDepartmentPanel(){
	var winCTLocSimilarDepartment = new Ext.Window({
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
			items: CTLocSimilarDepartment_grid,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	//gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  		return winCTLocSimilarDepartment;
	}
//});
