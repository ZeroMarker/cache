/// 名称: KPI指标条件定义表
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-3-5
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=SaveData&pEntityName=web.Entity.KB.BaseKPIDefine";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	/** 删除按钮 */
	var buttonDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_button',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_button'),
		handler : function DelData() {
			if (gridDefine.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = gridDefine.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('KPIRowId')
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
															var startIndex = gridDefine.getBottomToolbar().cursor;
															var totalnum=gridDefine.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=gridDefine.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridDefine.getStore().load({
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
	var WinF = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'KPIRowId',mapping:'KPIRowId',type:'string'},
                         {name: 'KPICode',mapping:'KPICode',type:'string'},
                         {name: 'KPIName',mapping:'KPIName',type:'string'},
                         {name: 'KPIType',mapping:'KPIType',type:'string'},
                         {name: 'DivCode',mapping:'DivCode',type:'string'},
                         {name: 'DivendCode',mapping:'DivendCode',type:'string'},
                         {name: 'KPIAlias',mapping:'KPIAlias',type:'string'},
                         {name: 'TableName',mapping:'TableName',type:'string'},
                         {name: 'DecDigits',mapping:'DecDigits',type:'string'},
                         {name: 'ConvFactor',mapping:'ConvFactor',type:'string'},
                         {name: 'ShowFormat',mapping:'ShowFormat',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'KPIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'KPIRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'KPICode',
							id:'KPICode',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KPICode'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KPICode')),
							allowBlank : false,
							blankText:'代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.BaseKPIDefine";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(window.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = gridDefine.getSelectionModel().getSelected();
	                            	var id = _record.get('KPIRowId'); //此条数据的rowid
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
									var KPICode=Ext.getCmp("KPICode").getValue();
									var tableName = tkMakeServerCall("web.DHCBL.KB.BaseKPIDefine","GetTableName",KPICode,"");
									Ext.getCmp("TableName").setValue(tableName);
								}
						    }
						}, {
							fieldLabel : '<font color=red>*</font>名称',
							name : 'KPIName',
							id:'KPIName',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KPIName'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KPIName')),
							allowBlank : false,
							blankText:'名称不能为空',
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.BaseKPIDefine"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(window.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = gridDefine.getSelectionModel().getSelected();
	                            	var id = _record.get('KPIRowId'); //此条数据的rowid
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
							fieldLabel : '<font color=red>*</font>数据来源',
							name : 'TableName',
							id:'TableName',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TableName'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TableName')),
   							allowBlank:false,
   							blankText:'数据来源不能为空'
						}, {
							xtype:'radiogroup',
							id:'KPIType',
					        fieldLabel:'指标类型',   
					        columns:2,
					        width:300,
					        items:[   
					            {id:'Types',boxLabel:'单值指标',name:'KPIType',inputValue:'S',checked:true},   
					            {id:'Typec',boxLabel:'均值指标',name:'KPIType',inputValue:'C'}  
					        ]
						}, {
							fieldLabel : '分子',
							name : 'DivCode',
							id:'DivCode',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DivCode'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DivCode'))
						}, {
							fieldLabel : '分母',
							name : 'DivendCode',
							id:'DivendCode',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DivendCode'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DivendCode'))
						}, {
							fieldLabel : '别名',
							name : 'KPIAlias',
							id:'KPIAlias',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KPIAlias'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KPIAlias'))
						}, {
							fieldLabel : '小数位数',
							name : 'DecDigits',
							id:'DecDigits',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DecDigits'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DecDigits'))
						}, {
							fieldLabel : '指标转换因子',
							name : 'ConvFactor',
							id:'ConvFactor',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ConvFactor'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ConvFactor'))
						}, {
							fieldLabel : '显示风格',
							name : 'ShowFormat',
							id:'ShowFormat',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ShowFormat'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ShowFormat'))
						}]
			});
	
	/** 增加修改时弹出窗口 */
	var window = new Ext.Window({
		width : 330,
		height : 400,
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
		items : WinF,
		buttons : [{
			text : '保存',
			id:'save_button',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_button'),
			handler : function() {
				var tempCode = Ext.getCmp("KPICode").getValue();
				var tempDesc = Ext.getCmp("KPIName").getValue();
				var TableName = Ext.getCmp("TableName").getValue();
				if(WinF.form.isValid()==false){return;}
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (TableName=="") {
    				Ext.Msg.show({ title : '提示', msg : '数据来源不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
				if (window.title == "添加") {
					WinF.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
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
												gridDefine.getStore().load({
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
							WinF.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										window.hide();
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.ReturnDataForUpdate("gridDefine", QUERY_ACTION_URL, myrowid)
														 
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
				Ext.getCmp("form-save").getForm().findField("KPICode").focus(true,800);
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
					window.setTitle('添加');
					window.setIconClass('icon-add');
					window.show('new1');
					WinF.getForm().reset();
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
					var _record = gridDefine.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			            window.setTitle('修改');
						window.setIconClass('icon-update');
						window.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('KPIRowId'),
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
	var dsDefine = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'KPIRowId',
									mapping : 'KPIRowId',
									type : 'string'
								}, {
									name : 'KPICode',
									mapping : 'KPICode',
									type : 'string'
								}, {
									name : 'KPIName',
									mapping : 'KPIName',
									type : 'string'
								}, {
									name : 'TableName',
									mapping : 'TableName',
									type : 'string'
								}, {
									name : 'KPIType',
									mapping : 'KPIType',
									type : 'string'
								}, {
									name : 'DivCode',
									mapping : 'DivCode',
									type : 'string'
								}, {
									name : 'DivendCode',
									mapping : 'DivendCode',
									type : 'string'
								}, {
									name : 'KPIAlias',
									mapping : 'KPIAlias',
									type : 'string'
								}, {
									name : 'DecDigits',
									mapping : 'DecDigits',
									type : 'string'
								}, {
									name : 'ConvFactor',
									mapping : 'ConvFactor',
									type : 'string'
								}, {
									name : 'ShowFormat',
									mapping : 'ShowFormat',
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
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var pagingDefine = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : dsDefine,
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
			items : [buttonAddwin, '-', buttonEditwin, '-', buttonDel]
		});
	/** 搜索按钮 */
	var buttonSearch = new Ext.Button({
				id : 'buttonSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('buttonSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					gridDefine.getStore().baseParams={			
							code : Ext.getCmp("textCode").getValue(),
							desc : Ext.getCmp("textDesc").getValue()
					};
					gridDefine.getStore().load({
						params : {
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
					Ext.getCmp("textCode").reset();
					Ext.getCmp("textDesc").reset();
					gridDefine.getStore().baseParams={};
					gridDefine.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});
	/** 搜索工具条 */
	var tbDefine = new Ext.Toolbar({
				id : 'tbDefine',
				items : ['代码:', {
							xtype : 'textfield',
							id : 'textCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textCode')
						}, '-',
						'名称:', {
							xtype : 'textfield',
							id : 'textDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
						}, '-', buttonSearch, '-', buttonRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(gridDefine.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	
	/** 创建grid */
	var gridDefine = new Ext.grid.GridPanel({
				id : 'gridDefine',
				region : 'center',
				closable : true,
				store : dsDefine,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'KPIRowId',
							sortable : true,
							dataIndex : 'KPIRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'KPICode'
						}, {
							header : '名称',
							sortable : true,
							dataIndex : 'KPIName'
						}, {
							header : '数据来源',
							sortable : true,
							dataIndex : 'TableName'
						}, {
							header : '指标类型',
							sortable : true,
							dataIndex : 'KPIType',
							renderer:function(value){
								if(value=="S"){
									return "单值指标";
								}
								if(value=="C"){
									return "均值指标"
								}
							}
						},  {
							header : '分子',
							sortable : true,
							dataIndex : 'DivCode'
						},	{
							header : '分母',
							sortable : true,
							dataIndex : 'DivendCode'
						},  {
							header : '别名',
							sortable : true,
							dataIndex : 'KPIAlias'
						},  {
							header : '小数位数',
							sortable : true,
							dataIndex : 'DecDigits'
						},	{
							header : '指标转换因子',
							sortable : true,
							dataIndex : 'ConvFactor'
						},  {
							header : '显示风格',
							sortable : true,
							dataIndex : 'ShowFormat'
						}],
				stripeRows : true,
				title : 'KPI指标条件定义',
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingDefine,
				tbar : tbDefine,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'gridDefine'
			});
		
	/** gridDefine双击事件 */
	gridDefine.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = gridDefine.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
						title : '提示',
						msg : '请选择需要修改的行!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
		       	 } else {
		            window.setTitle('修改');
					window.setIconClass('icon-update');
					window.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('KPIRowId'),
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
				items : [gridDefine]
			});
});
