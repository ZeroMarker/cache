/// 名称: 主题维护
/// 描述: 包含主题维护定义表和明细表的增删改查
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-3-20
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'side';

var QUERY_DEFINE_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.Subject&pClassQuery=GetList";
var	SAVE_DEFINE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.Subject&pClassMethod=SaveData&pEntityName=web.Entity.KB.Subject";
var	OPEN_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.Subject&pClassMethod=OpenData";
var	DELETE_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.Subject&pClassMethod=DeleteData";
var BindingMeasure="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.Measure&pClassQuery=GetDataForCmb1";
var QUERY_CONFIG_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.SubMeasure&pClassQuery=GetList";
var SAVE_CONFIG_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.SubMeasure&pClassMethod=SaveData&pEntityName=web.Entity.KB.SubMeasure";
var	OPEN_CONFIG_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.SubMeasure&pClassMethod=OpenData";
var DELETE_CONFIG_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.SubMeasure&pClassMethod=DeleteData";
var GENERATOR_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.SubMeasure&pClassMethod=SubjectGenerator";
var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
var pagesize_west = Ext.BDP.FunLib.PageSize.Main;

/*********************************主题维护表***********************************/
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function DelData() {
			if (gridWest.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridWest.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_DEFINE_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('SubjectRowId')
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
															var startIndex = gridWest.getBottomToolbar().cursor;
															var totalnum=gridWest.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_west==0)//最后一页只有一条
															{
																var pagenum=gridWest.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_west;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridWest.getStore().load({
																params : {
																			start : startIndex,
																			limit : pagesize_west
																		}
															});
															gridCenter.getStore().load({
																params : {
																	parref : 0,
																	start : 0,
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
                        [{name: 'SubjectRowId',mapping:'SubjectRowId',type:'string'},
                         {name: 'SubjectCode',mapping:'SubjectCode',type:'string'},
                         {name: 'SubjectName',mapping:'SubjectName',type:'string'},
                         {name: 'ClassName',mapping:'ClassName',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'SubjectRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'SubjectRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'SubjectCode',
							id:'SubjectCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SubjectCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SubjectCodeF')),
							allowBlank : false,
							blankText:'代码不能为空',
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.Subject"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = gridWest.getSelectionModel().getSelected();
	                            	var id = _record.get('SubjectRowId'); //此条数据的rowid
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
							fieldLabel : '<font color=red>*</font>名称',
							name : 'SubjectName',
							id:'SubjectNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SubjectNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SubjectNameF')),
							allowBlank : false,
							blankText:'名称不能为空'
						}, {
							fieldLabel : '<font color=red>*</font>主题名称',
							name : 'ClassName',
							id:'ClassNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ClassNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ClassNameF')),
							allowBlank : false,
							blankText:'主题名称不能为空'
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 330,
		height : 280,
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
				if(WinForm.form.isValid()==false){return;}
				var SubjectCode = Ext.getCmp("SubjectCodeF").getValue();
				var SubjectName = Ext.getCmp("SubjectNameF").getValue();
				var ClassName = Ext.getCmp("ClassNameF").getValue();
				if (SubjectCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (SubjectName=="") {
    				Ext.Msg.show({ title : '提示', msg : '名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (ClassName=="") {
    				Ext.Msg.show({ title : '提示', msg : '主题名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_DEFINE_URL,
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
												gridWest.getStore().load({
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
								url : SAVE_DEFINE_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										//var myrowid = "rowid=" + action.result.id;
										var myrowid = action.result.id;
										Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													//Ext.BDP.FunLib.ReturnDataForUpdate("gridWest", QUERY_DEFINE_URL, myrowid)
												 	gridWest.getStore().load({
														params : {
																	start : 0,
																	limit : 1,
																	rowid : myrowid
																}
													});
													gridCenter.getStore().load({
														params : {
															parref : 0,
															start : 0,
															limit : pagesize_main
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
				Ext.getCmp("form-save").getForm().findField("SubjectCode").focus(true,800);
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
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
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
					var _record = gridWest.getSelectionModel().getSelected();
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
			                url : OPEN_DEFINE_URL + '&id=' + _record.get('SubjectRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			});
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_DEFINE_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'SubjectRowId',
							mapping : 'SubjectRowId', 
							type : 'string'
						}, {
							name : 'SubjectCode',
							mapping : 'SubjectCode',
							type : 'string'
						}, {
							name : 'SubjectName',
							mapping : 'SubjectName',
							type : 'string'
						}, {
							name : 'ClassName',
							mapping : 'ClassName',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWest
	});
	/** grid加载数据 */
	dsWest.load({
		params : {
			start : 0,
			limit : pagesize_west
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWest = new Ext.PagingToolbar({
		pageSize : pagesize_west,
		store : dsWest,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_west=this.pageSize;
			}
		}
	});
	/** 增删改工具条 */
	var tbbtn = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel]
	});
	/**搜索按钮 */
	var btnWestSearch = new Ext.Button({
		id : 'btnWestSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridWest.getStore().baseParams={			
					desc : Ext.getCmp("textDesc").getValue()
			};
			gridWest.getStore().load({
				params : {
							start : 0,
							limit : pagesize_west
						}
			});
			gridCenter.getStore().load({
				params : {
					parref : 0,
					start : 0,
					limit : pagesize_main
				}
			});
		}
	});
	/**重置按钮 */
	var btnWestRefresh = new Ext.Button({
		id : 'btnWestRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestRefresh'),
		handler : function() {
			Ext.getCmp("textDesc").reset();
			gridWest.getStore().baseParams={};
			gridWest.getStore().load({
				params : {
					start : 0,
					limit : pagesize_west
					}
			});
			gridCenter.getStore().load({
				params : {
					parref : 0,
					start : 0,
					limit : pagesize_main
				}
			});
		}
	});
	/**搜索工具条 */
	var tbWest = new Ext.Toolbar({
		id : 'tbWest',
		items : [
				'名称:', {
					xtype : 'textfield',
					id : 'textDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
				}, '-', btnWestSearch, '-', btnWestRefresh, '->' 
		],
		listeners : {
			render : function() {
				tbbtn.render(gridWest.tbar) // tbar.render(panel.bbar)这个效果在底部
			}
		}
	});
	/** 创建grid */
	var gridWest = new Ext.grid.GridPanel({
		id : 'gridWest',
		title:'CUBE模型主题',
		region : 'west',
		width:580,
		split:true,
		collapsible:true,
		closable : true,
		store : dsWest,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'SubjectRowId',
					sortable : true,
					dataIndex : 'SubjectRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'SubjectCode'
				}, {
					header : '名称',
					sortable : true,
					dataIndex : 'SubjectName'
				}, {
					header : '主题名称',
					sortable : true,
					dataIndex : 'ClassName'
				}],
		stripeRows : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWest,
		tbar : tbWest,
		stateId : 'gridWest'
	});
	/**默认选中*/
	gridWest.store.on("load",function(){  
		if(gridWest.getStore().getCount()!=0){
	        gridWest.getSelectionModel().selectRow(0,true);  
	        var parref = gridWest.getSelectionModel().getSelections()[0].get('SubjectRowId');
		 	gridCenter.getStore().load({
				params : {
					parref : parref,
					start : 0,
					limit : pagesize_main
				}
			});
		}
    }); 
	/**根据父定义表查询子明细表*/
	 gridWest.on("rowclick", function(grid, rowIndex, e){
	 	var parref = gridWest.getSelectionModel().getSelections()[0].get('SubjectRowId');
	 	gridCenter.getStore().load({
			params : {
				parref : parref,
				start : 0,
				limit : pagesize_main
			}
		});
	 });
/**********************************主题维护明细*************************************/
	/** 删除按钮 */
	var buttonDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_button',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_button'),
		handler : function DelData() {
			if (gridCenter.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridCenter.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_CONFIG_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('SubRowId')
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
															var startIndex = gridCenter.getBottomToolbar().cursor;
															var totalnum=gridCenter.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=gridCenter.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridCenter.getStore().load({
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
	var WForm = new Ext.form.FormPanel({
				id : 'form',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'SubRowId',mapping:'SubRowId',type:'string'},
                         {name: 'SubParRef',mapping:'SubParRef',type:'string'},
                         {name: 'MeasureDR',mapping:'MeasureDR',type:'string'},
                         {name: 'Definition',mapping:'Definition',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'SubRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'SubRowId'
						},{
							fieldLabel : 'SubParRef',
							hideLabel : 'True',
							id : 'SubParRef',
							hidden : true,
							name : 'SubParRef'
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>度量类型',
							name : 'MeasureDR',
							id:'MeasureDRF',
							hiddenName:'MeasureDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('MeasureDR'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MeasureDR')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '度量类型不能为空',
							allowBlank : false,
							valueField : 'RowId',
							displayField : 'CatName',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingMeasure,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'RowId',
								fields : ['RowId', 'CatName'],
								remoteSort : true,
								sortInfo : {
									field : 'RowId',
									direction : 'ASC'
								}
							})
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>维度类型',
							name : 'Definition',
							id : 'DefinitionF',
							hiddenName : 'Definition',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Definition'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Definition')),
							editable:false,
							mode : 'local',
							triggerAction : 'all',// query
							blankText : '维度类型不能为空',
							allowBlank : false,
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['Date','Date'],
									      ['Values','Values'],
									      ['Sum','Sum'],
									      ['DC','Distinct Count']
								     ]
							})
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var window = new Ext.Window({
		width : 330,
		height : 280,
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
		items : WForm,
		buttons : [{
			text : '保存',
			id:'save_button',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_button'),
			handler : function() {
				if(WForm.form.isValid()==false){return;}
				var MeasureDR = Ext.getCmp("MeasureDRF").getValue();
				var Definition = Ext.getCmp("DefinitionF").getValue();
				if (MeasureDR=="") {
    				Ext.Msg.show({ title : '提示', msg : '度量类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (Definition=="") {
    				Ext.Msg.show({ title : '提示', msg : '维度类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
				if (window.title == "添加") {
					WForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_CONFIG_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								window.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												gridCenter.getStore().load({
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
							WForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_CONFIG_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										window.hide();
										var myrowid = "rowid=" + action.result.id;
										//var myrowid = action.result.id;
										Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													Ext.BDP.FunLib.ReturnDataForUpdate("gridCenter", QUERY_CONFIG_URL, myrowid)
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
				window.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form").getForm().findField("MeasureDR").focus(true,800);
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	/** 添加按钮 */
	var buttonAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_button',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_button'),
				handler : function AddData() {
					if(gridWest.selModel.hasSelection()){
						window.setTitle('添加');
						window.setIconClass('icon-add');
						window.show('new1');
						Ext.getCmp("form").getForm().reset();
						Ext.getCmp("SubParRef").setValue(gridWest.getSelectionModel().getSelections()[0].get('SubjectRowId'));
					}else{
						Ext.Msg.show({
							title : '提示',
							msg : '请选择一条主题!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}
					
				},
				scope : this
			});
	/** 修改按钮 */
	var buttonEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_button',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_button'),
				handler : function UpdateData() {
					if(gridCenter.selModel.hasSelection()){
						window.setTitle('修改');
						window.setIconClass('icon-update');
						window.show('');
						Ext.getCmp("form").getForm().reset();
			            Ext.getCmp("form").getForm().load({
			                url : OPEN_CONFIG_URL + '&id=' + gridCenter.getSelectionModel().getSelected().get('SubRowId'),
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
	/** Cube生成类按钮 */
	/*
	var buttonCubewin = new Ext.Toolbar.Button({
		text : 'Cube生成类',
		tooltip : '请只选一个Date类型，至少一个sum类型，至少一个values类型生成类',
		iconCls : 'icon-DP',
		id:'cube_button',
 		disabled : Ext.BDP.FunLib.Component.DisableFlag('cube_button'),
		handler : function GenerateData() {
			var dateCount=0,sumCount=0,valueCount=0
			for(var i = 0 ; i < gridCenter.getSelectionModel().getSelections().length ; i++){
				if(gridCenter.getSelectionModel().getSelections()[i].get('Definition')=="Date"){
					var dateCount = dateCount + 1;
				}
				if(gridCenter.getSelectionModel().getSelections()[i].get('Definition')=="Sum"){
					var sumCount = sumCount + 1;
				}
				if(gridCenter.getSelectionModel().getSelections()[i].get('Definition')=="Values"){
					var valueCount = valueCount + 1;
				}
			}
			if((dateCount!=1)||(sumCount<1)||(valueCount<1)){
				Ext.Msg.show({
					title : '提示',
					msg : '请只选一个Date类型，至少一个sum类型，至少一个values类型生成类!',
					icon : Ext.Msg.WARNING,
					buttons : Ext.Msg.OK
				});
			}else{
				Ext.Ajax.request({
					url : GENERATOR_URL,
					method : 'POST',
					params : {
						'Code' : gridWest.getSelectionModel().getSelections()[0].get('SubjectCode'),
						'Name' : gridWest.getSelectionModel().getSelections()[0].get('SubjectName')
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '生成成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK
								});
							} else {
								var errorMsg = '';
								if (jsonData.info) {
									errorMsg = '<br/>错误信息:' + jsonData.info
								}
								Ext.Msg.show({
									title : '提示',
									msg : '生成失败!' + errorMsg,
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
	});
	*/
	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CONFIG_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'SubRowId',
							mapping : 'SubRowId',
							type : 'string'
						},{
							name : 'SubParRef',
							mapping : 'SubParRef',
							type : 'string'
						},{
							name : 'MeasureDR',
							mapping : 'MeasureDR',
							type : 'string'
						},{
							name : 'CatName',
							mapping : 'CatName',
							type : 'string'
						},{
							name : 'Definition',
							mapping : 'Definition',
							type : 'string'
						}
				])
	});
	/** grid 数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsCenter
	});
	/**加载分页参数**/
	dsCenter.on('beforeload',function(thiz,options){ 
		if(gridWest.getSelectionModel().getCount()!=0){
			Ext.apply(   
			  this.baseParams,   
			  {   
			     parref:gridWest.getSelectionModel().getSelections()[0].get('SubjectRowId')
			  }   
			)	
		}
	});
	/** grid 加载数据 */
	dsCenter.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid 分页工具条 */
	var pagingCenter = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsCenter,
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
		items : [buttonAddwin, '-', buttonEditwin, '-', buttonDel ]//,'-', buttonCubewin
	});
	/**搜索按钮 */
	var buttonCenterSearch = new Ext.Button({
		id : 'buttonCenterSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('buttonCenterSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridCenter.getStore().baseParams={	
					desc : Ext.getCmp("Desc").getValue()
			};
			gridCenter.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
				});
		}
	});
	/**重置按钮 */
	var buttonCenterRefresh = new Ext.Button({
		id : 'buttonCenterRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('buttonCenterRefresh'),
		handler : function() {
			Ext.getCmp("Desc").reset();
			gridCenter.getStore().baseParams={};
			gridCenter.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
					}
				});
		}
	});
	/**搜索工具条 */
	var tbCenter = new Ext.Toolbar({
		id : 'tbCenter',
		items : [
				'维度类型:', {
					xtype : 'combo',
					name : 'Definition',
					id : 'Desc',
					hiddenName : 'Definition',
					width:150,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('Definition'),
					mode : 'local',
					triggerAction : 'all',// query
					valueField : 'value',
					displayField : 'name',
					store:new Ext.data.SimpleStore({
						fields:['value','name'],
						data:[
							      ['Date','Date'],
							      ['Values','Values'],
							      ['Sum','Sum'],
							      ['DC','Distinct Count']
						     ]
					})
				}, '-', buttonCenterSearch, '-', buttonCenterRefresh, '->'
		],
		listeners : {
			render : function() {
				tbbutton.render(gridCenter.tbar) // tbar.render(panel.bbar)这个效果在底部
			}
		}
	});
	/** 创建grid */
	var gridCenter = new Ext.grid.GridPanel({
		id : 'gridCenter',
		region : 'center',
		closable : true,
		store : dsCenter,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'SubRowId',
					hidden:true,
					sortable : true,
					dataIndex : 'SubRowId'
				},{
					header : 'SubParRef',
					hidden:true,
					sortable : true,
					dataIndex : 'SubParRef'
				}, {
					header : 'MeasureDR',
					hidden:true,
					sortable:true,
					dataIndex : 'MeasureDR'
				}, {
					header : '度量类型',
					sortable:true,
					dataIndex : 'CatName'
				}, {
					header : '维度类型',
					sortable:true,
					dataIndex : 'Definition',
					renderer:function(value){
						if(value=="Date"){return "Date"}
						if(value=="Values"){return "Values"}
						if(value=="Sum"){return "Sum"}
						if(value=="DC"){return "Distinct Count"}
					}
				}],
		stripeRows : true,
		title : '主题明细',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.CheckboxSelectionModel(),
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingCenter,
		tbar : tbCenter,
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter'
	});
	/** grid双击事件 */
	gridCenter.on("rowdblclick", function(grid, rowIndex, e) {
		if(gridCenter.selModel.hasSelection()){
			window.setTitle('修改');
			window.setIconClass('icon-update');
			window.show('');
			Ext.getCmp("form").getForm().reset();
            Ext.getCmp("form").getForm().load({
                url : OPEN_CONFIG_URL + '&id=' + gridCenter.getSelectionModel().getSelected().get('SubRowId'),
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
	});
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
