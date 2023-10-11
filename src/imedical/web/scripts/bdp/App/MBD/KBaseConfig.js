/// 名称: 知识库度量
/// 描述: 包含知识库度量定义表和明细表的增删改查
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-2-12
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'side';
	
var	DELETE_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KBaseDefine&pClassMethod=DeleteData";
var	SAVE_DEFINE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KBaseDefine&pClassMethod=SaveData&pEntityName=web.Entity.KB.KBaseDefine";
var	OPEN_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KBaseDefine&pClassMethod=OpenData";
var BindingTable="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KBaseDefine&pClassQuery=GetDataForCmb1";
var QUERY_DEFINE_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KBaseDefine&pClassQuery=GetList";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KBaseConfig&pClassQuery=GetTypeList";
var QUERY_CONFIG_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KBaseConfig&pClassQuery=GetList";
var SAVE_CONFIG_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KBaseConfig&pClassMethod=SaveData&pEntityName=web.Entity.KB.KBaseConfig";
var DELETE_CONFIG_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KBaseConfig&pClassMethod=DeleteData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KBaseConfig&pClassMethod=Save&pEntityName=web.Entity.KB.KBaseConfig";
var pagesize_westn = Ext.BDP.FunLib.PageSize.Main;
var pagesize_wests = Ext.BDP.FunLib.PageSize.Main;
var pagesize_center = Ext.BDP.FunLib.PageSize.Main;

/*********************************知识库度量定义表***********************************/
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : function DelData() {
			if (gridWestN.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridWestN.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_DEFINE_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('KBDRowId')
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
															var startIndex = gridWestN.getBottomToolbar().cursor;
															var totalnum=gridWestN.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_westn==0)//最后一页只有一条
															{
																var pagenum=gridWestN.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_westn;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridWestN.getStore().load({
																params : {
																			start : startIndex,
																			limit : pagesize_westn
																		}
															});
															gridCenter.getStore().load({
																params : {
																	tableName : '',
																	start : 0,
																	limit : pagesize_center
																}
															});
															gridWestS.getStore().load({
																params : {
																	start : 0,
																	limit : pagesize_wests
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
	var code = "";
	var dsTable = new Ext.data.JsonStore({
					autoLoad : true,
					url : BindingTable, 
					//baseParams:{code:code},
					root : 'data',
					totalProperty : 'total',
					idProperty : 'TableName',
					fields : ['TableName', 'TableName']
				});
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'KBDRowId',mapping:'KBDRowId',type:'string'},
                         {name: 'KBDCode',mapping:'KBDCode',type:'string'},
                         {name: 'KBDName',mapping:'KBDName',type:'string'},
                         {name: 'TableName',mapping:'TableName',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'KBDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'KBDRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'KBDCode',
							id:'KBDCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KBDCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KBDCodeF')),
							allowBlank : false,
							blankText:'代码不能为空',
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.KBaseDefine"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = gridWestN.getSelectionModel().getSelected();
	                            	var id = _record.get('KBDRowId'); //此条数据的rowid
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
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
            			        'blur':function(){
									var code = Ext.getCmp("KBDCodeF").getValue();
									dsTable.baseParams = {
										code : code
									}
									dsTable.load({
										params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
										}
									});
								}
						    }
						}, {
							fieldLabel : '<font color=red>*</font>名称',
							name : 'KBDName',
							id:'KBDNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KBDNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KBDNameF')),
							allowBlank : false,
							blankText:'名称不能为空'
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>数据来源',
							name : 'TableName',
							id:'TableNameF',
							hiddenName:'TableName',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TableNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TableNameF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 1,
							listWidth : 250,
							blankText : '数据来源不能为空',
							allowBlank : false,
							valueField : 'TableName',
							displayField : 'TableName',
							store : dsTable
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
				var KBDCode = Ext.getCmp("KBDCodeF").getValue();
				var KBDName = Ext.getCmp("KBDNameF").getValue();
				var TableName = Ext.getCmp("TableNameF").getValue();
				if (KBDCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (KBDName=="") {
    				Ext.Msg.show({ title : '提示', msg : '名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (TableName=="") {
    				Ext.Msg.show({ title : '提示', msg : '数据来源不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){return;}
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
												gridWestN.getStore().load({
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
													//Ext.BDP.FunLib.ReturnDataForUpdate("gridWestN", QUERY_DEFINE_URL, myrowid)
												 	gridWestN.getStore().load({
														params : {
																	start : 0,
																	limit : 1,
																	rowid : myrowid
																}
													});
													gridCenter.getStore().load({
														params : {
															tableName : '',
															start : 0,
															limit : pagesize_center
														}
													});
													gridWestS.getStore().load({
														params : {
															start : 0,
															limit : pagesize_wests
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
				Ext.getCmp("form-save").getForm().findField("KBDCode").focus(true,800);
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
					var _record = gridWestN.getSelectionModel().getSelected();
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
			                url : OPEN_DEFINE_URL + '&id=' + _record.get('KBDRowId'),
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
	var dsWestN = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_DEFINE_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'KBDRowId',
							mapping : 'KBDRowId', 
							type : 'string'
						}, {
							name : 'KBDCode',
							mapping : 'KBDCode',
							type : 'string'
						}, {
							name : 'KBDName',
							mapping : 'KBDName',
							type : 'string'
						}, {
							name : 'TableName',
							mapping : 'TableName',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestN
	});
	/** grid加载数据 */
	dsWestN.load({
		params : {
			start : 0,
			limit : pagesize_westn
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWestN = new Ext.PagingToolbar({
		pageSize : pagesize_westn,
		store : dsWestN,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_westn=this.pageSize;
			}
		}
	});
	/**搜索按钮 */
	var btnWestNSearch = new Ext.Button({
		id : 'btnWestNSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridWestN.getStore().baseParams={			
					desc : Ext.getCmp("textDesc").getValue()
			};
			gridWestN.getStore().load({
				params : {
							start : 0,
							limit : pagesize_westn
						}
				});
		}
	});
	/**重置按钮 */
	var btnWestNRefresh = new Ext.Button({
		id : 'btnWestNRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNRefresh'),
		handler : function() {
			Ext.getCmp("textDesc").reset();
			gridWestN.getStore().baseParams={};
			gridWestN.getStore().load({
				params : {
					start : 0,
					limit : pagesize_westn
						}
			});
			gridCenter.getStore().load({
				params : {
					tableName : '',
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					parref : 0,
					start : 0,
					limit : pagesize_wests
				}
			});
		}
	});
	/**搜索工具条 */
	var tbWestN = new Ext.Toolbar({
		id : 'tbWestN',
		items : [
				'名称:', {
					xtype : 'textfield',
					id : 'textDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
				}, '-', btnWestNSearch, '-', btnWestNRefresh, '-', btnAddwin, '-', btnEditwin, '-', btnDel, '->'
		]
	});
	/** 创建grid */
	var gridWestN = new Ext.grid.EditorGridPanel({
		id : 'gridWestN',
		region : 'north',
		height:300,
		closable : true,
		store : dsWestN,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'KBDRowId',
					sortable : true,
					dataIndex : 'KBDRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'KBDCode'
				}, {
					header : '名称',
					sortable : true,
					dataIndex : 'KBDName'
				}, {
					header : '数据来源',
					sortable : true,
					dataIndex : 'TableName'
				}],
		stripeRows : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestN,
		tbar : tbWestN,
		stateId : 'gridWestN'
	});
	/**默认选中*/
	gridWestN.store.on("load",function(){  
		if(gridWestN.getStore().getCount()!=0){
	        gridWestN.getSelectionModel().selectRow(0,true);  
	        var tableName = gridWestN.getSelectionModel().getSelections()[0].get('TableName');
		 	var parref = gridWestN.getSelectionModel().getSelections()[0].get('KBDRowId');
		 	if(tableName=="PHC_DrgForm"){
		 		Ext.Msg.show({
						title : '提示',
						msg : '此条数据来源不维护知识库度量明细',
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
		    		})
		 	}
		 	gridCenter.getStore().load({
				params : {
					tableName : tableName,
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					parref : parref,
					start : 0,
					limit : pagesize_wests
				}
			});
		}else{
			gridCenter.getStore().load({
				params : {
					tableName : '',
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					parref : 0,
					start : 0,
					limit : pagesize_wests
				}
			});
		}
    }); 	
	/*********************************知识库度量明细表***************************************/
	/** 明细grid数据存储 */
	var dsWestS = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CONFIG_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'TypeRowID',
							mapping : 'TypeRowID',
							type : 'string'
						},{
							name : 'TypeName',
							mapping : 'TypeName',
							type : 'string'
						}, {
							name : 'ADMType',
							mapping : 'ADMType',
							type : 'string'
						}, {
							name : 'StartDate',
							mapping : 'StartDate',
							type : 'date',
							dateFormat : 'm/d/Y'
						}, {
							name : 'EndDate',
							mapping : 'EndDate',
							type : 'date',
							dateFormat : 'm/d/Y'
						},{
							name : 'KBCRowId',
							mapping : 'KBCRowId',
							type : 'string'
						}
				])
	});
	/** 明细grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestS
	}); 
	/**加载分页参数**/
	dsWestS.on('beforeload',function(thiz,options){ 
		if(dsWestS.getCount()!='0'){
			if(gridWestN.getSelectionModel().getCount()!=0){
				Ext.apply(   
				  this.baseParams,   
				  {   
				     parref:gridWestN.getSelectionModel().getSelections()[0].get('KBDRowId')
				  }   
				)
			}
		}
		
	});
	/** 明细grid加载数据 */
	dsWestS.load({
		params : {
			start : 0,
			limit : pagesize_wests
		},
		callback : function(records, options, success) {
		}
	});
	/** 明细grid分页工具条 */
	var pagingWestS = new Ext.PagingToolbar({
		pageSize : pagesize_wests,
		store : dsWestS,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_wests=this.pageSize;
			}
		}
	});
	/** 创建明细grid */
	var gridWestS = new Ext.grid.EditorGridPanel({
		id : 'gridWestS',
		region : 'center',
		closable : true,
		store : dsWestS,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列 
				{
					header : '数据来源RowId',
					sortable : true,
					dataIndex : 'TypeRowID',
					hidden:true
				},{
					header : '数据来源名称',
					sortable : true,
					dataIndex : 'TypeName'
				}, {
					header : '就诊类型',
					sortable : true,
					dataIndex : 'ADMType',
					renderer:function(value){
						if(value=="A"){return "全院"}
						if(value=="I"){return "住院"}
						if(value=="OE"){return "门急诊"}
						if(value=="O"){return "门诊"}
						if(value=="E"){return "急诊"}
						if(value=="H"){return "体检"}
						if(value=="N"){return "新生儿"}
						if(value=="S"){return "留观"}
					},
					editor:new Ext.form.ComboBox({
						name : 'ADMType',
						hiddenName : 'ADMType',
						editable:false,
						allowBlank : false,
						width : 230,
						labelWidth:30,
						mode : 'local',
						triggerAction : 'all',// query
						valueField : 'value',
						displayField : 'name',
						store:new Ext.data.SimpleStore({
							fields:['value','name'],
							data:[
								      ['A','全院'],
								      ['I','住院'],
								      ['OE','门急诊'],
								      ['O','门诊'],
								      ['E','急诊'],
								      ['H','体检'],
								      ['N','新生儿'],
								      ['S','留观']
							     ]
						})
					})
				}, {
					header : '开始日期',
					sortable : true,
					dataIndex : 'StartDate',
					renderer : Ext.util.Format.dateRenderer('Y/m/d'),
					editor:new Ext.form.DateField({format:'Y/m/d'})
				}, {
					header : '截止日期',
					sortable : true,
					dataIndex : 'EndDate',
					renderer : Ext.util.Format.dateRenderer('Y/m/d'),
					editor:new Ext.form.DateField({format:'Y/m/d'})
				}, {
					header : '操作',
					dataIndex : 'KBCRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '知识库度量明细',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestS,
		stateId : 'gridWestS',
		listeners:{
			'afteredit':function(e){
				var record = e.record; //得到当前行所有数据
       			//var v = e.value; //得到修改列修改后值
				var ADMType = record.get("ADMType");
				var StartDate = record.get("StartDate");
				var EndDate = record.get("EndDate");
				if (ADMType=="") {
    				Ext.Msg.show({ title : '提示', msg : '就诊类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (StartDate != null && EndDate != null && StartDate != "" && EndDate != "") {
    				StartDate = StartDate.format("Ymd");
					EndDate = EndDate.format("Ymd");
        			if (StartDate > EndDate) {
        				Ext.Msg.show({
			        					title : '提示',
										msg : '开始日期不能大于结束日期!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
          			 		return;
      					}
   			 	}
                Ext.Ajax.request({
                   url: SAVE_ACTION_URL,
                   method: "POST",
                   params: {
                       id: record.get("KBCRowId"),
                       ADMType:ADMType,
                       StartDate:StartDate,
                       EndDate:EndDate
                   },
                   success: function(r) {
                       	gridWestS.getStore().reload(); 
                 		gridWestS.getSelectionModel().selectRow(0,false);// 
                       	gridWestS.getView().focusCell(0,0); //选中的获取焦点 
                   },
                   failure: function() {
                        MessageBox("提示", "操作失败！", Ext.MessageBox.ERROR);
                      	gridWestS.getStore().reload();
                   }
               });
			}
		}
	});
	/**删除**/
	gridWestS.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		Ext.MessageBox.confirm('提示','确定删除此条数据吗?', function(button) {
	 		if(button=="yes"){
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行	
				Ext.Ajax.request({
					url : DELETE_CONFIG_URL,
					method : 'POST',
					params : {
						'id' : rows[0].get('KBCRowId')
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '删除成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										var startIndex = gridWestS.getBottomToolbar().cursor;
										var totalnum=gridWestS.getStore().getTotalCount();
										if(totalnum==1){   //修改添加后只有一条，返回第一页
											var startIndex=0
										}
										else if((totalnum-1)%pagesize_wests==0)//最后一页只有一条
										{
											var pagenum=gridWestS.getStore().getCount();
											if (pagenum==1){ startIndex=startIndex-pagesize_wests;}  //最后一页的时候,不是最后一页则还停留在这一页
										}
										if(gridWestN.getSelectionModel().getCount()!='0'){
											var parref = gridWestN.getSelectionModel().getSelections()[0].get('KBDRowId');
										}
										gridWestS.getStore().load({
											params : {
													parref : parref,
													start : startIndex,
													limit : pagesize_wests
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
	 		}
	});
/************************************West***********************************************/
var gridWest = new Ext.Panel({
		id : 'gridWest',
		title:'知识库度量定义',
		region : 'west',
		width:620,
		split:true,
		collapsible:true,
		layout:'border',
		items:[gridWestN,gridWestS]
})
/**********************************Center 知识库度量数据来源*************************************/

	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'TypeName',
							mapping : 'TypeName',
							type : 'string'
						},{
							name : 'TypeRowID',
							mapping : 'TypeRowID',
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
		if(gridWestN.getSelectionModel().getCount()!=0){
			Ext.apply(   
			  this.baseParams,   
			  {   
			     tableName:gridWestN.getSelectionModel().getSelections()[0].get('TableName')
			  }   
			)	
		}
		
	});
	/** grid 加载数据 */
	dsCenter.load({
		params : {
			start : 0,
			limit : pagesize_center
		},
		callback : function(records, options, success) {
		}
	});
	/** grid 分页工具条 */
	var pagingCenter = new Ext.PagingToolbar({
		pageSize : pagesize_center,
		store : dsCenter,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_center=this.pageSize;
			}
		}
	});
		/**搜索按钮 */
	var btnCenterSearch = new Ext.Button({
		id : 'btnCenterSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridCenter.getStore().baseParams={	
					desc : Ext.getCmp("Desc").getValue()
			};
			gridCenter.getStore().load({
				params : {
							start : 0,
							limit : pagesize_center
						}
				});
		}
	});
	/**重置按钮 */
	var btnCenterRefresh = new Ext.Button({
		id : 'btnCenterRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterRefresh'),
		handler : function() {
			Ext.getCmp("Desc").reset();
			gridCenter.getStore().baseParams={};
			gridCenter.getStore().load({
				params : {
					start : 0,
					limit : pagesize_center
						}
				});
		}
	});
	/**搜索工具条 */
	var tbCenter = new Ext.Toolbar({
		id : 'tbCenter',
		items : [
				'名称:', {
					xtype : 'textfield',
					id : 'Desc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('Desc')
				}, '-', btnCenterSearch, '-', btnCenterRefresh, '->'
		]
	});
	/** 创建grid */
	var gridCenter = new Ext.grid.EditorGridPanel({
		id : 'gridCenter',
		region : 'center',
		closable : true,
		store : dsCenter,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : '数据来源名称',
					sortable : true,
					dataIndex : 'TypeName'
				}, {
					header : '操作',
					dataIndex : 'TypeRowID',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >添加</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="conBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '知识库度量数据来源',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingCenter,
		tbar : tbCenter,
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter'
	});
	/**根据TableName查询数据来源；根据父定义表查询子明细表*/
	 gridWestN.on("rowclick", function(grid, rowIndex, e){
	 	var tableName = gridWestN.getSelectionModel().getSelections()[0].get('TableName');
	 	var parref = gridWestN.getSelectionModel().getSelections()[0].get('KBDRowId');
	 	if(tableName=="PHC_DrgForm"){
	 		Ext.Msg.show({
					title : '提示',
					msg : '此条数据来源不维护知识库度量明细',
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
	    		})
	 	}
	 	gridCenter.getStore().load({
			params : {
				tableName : tableName,
				start : 0,
				limit : pagesize_center
			}
		});
		gridWestS.getStore().load({
			params : {
				parref : parref,
				start : 0,
				limit : pagesize_wests
			}
		});
	 });
	/**添加明细**/
	 gridCenter.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.conBtn');
	 	if(btn){
		 	if(gridWestN.getSelectionModel().getCount()!=0){
		 		var parref = gridWestN.getSelectionModel().getSelections()[0].get('KBDRowId');
		 		var rowid = gridCenter.getSelectionModel().getSelections()[0].get('TypeRowID');
		 		var name = gridCenter.getSelectionModel().getSelections()[0].get('TypeName');
		 		//var type = gridCenter.getSelectionModel().getSelections()[0].get('ADMType'); 
		 		var type="A";  //默认就诊类型为全院
		    	var config = parref+"^"+rowid+"^"+name+"^"+type;
				Ext.Ajax.request({
				url : SAVE_CONFIG_URL , 		
				method : 'POST',	
				params : {
						'config' : config
				},
				callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								gridWestS.getStore().load({
									params : {
										parref : parref,
										start : 0,
										limit : pagesize_wests
										
									}
								})
							}else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br />'+jsonData.info
								}
								Ext.Msg.show({
									title:'提示',
									msg:errorMsg,
									minWidth:210,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					}
				})
			}else{
		 		Ext.Msg.show({
					title : '提示',
					msg : '请先选择一条知识库度量定义!',
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
	    		})
		 	}	
		 }	
	 });
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
