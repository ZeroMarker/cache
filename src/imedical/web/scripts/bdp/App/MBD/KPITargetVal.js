/// 名称: KPI目标值维护表
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-3-25
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var QUERY_DEFINE_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassQuery=GetList";
	var SAVE_DEFINE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=SaveData&pEntityName=web.Entity.KB.BaseKPIDefine";
	var OPEN_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=OpenData";
	var DELETE_DEFINE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassMethod=DeleteData";
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KPITargetVal&pClassQuery=GetList";
	var BindingKPI="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassQuery=GetDataForCmb1";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KPITargetVal&pClassMethod=SaveData&pEntityName=web.Entity.KB.KPITargetVal";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KPITargetVal&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KPITargetVal&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_define = Ext.BDP.FunLib.PageSize.Main;
/********************************指标定义************************************/	
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
							url : DELETE_DEFINE_URL,
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
															else if((totalnum-1)%pagesize_define==0)//最后一页只有一条
															{
																var pagenum=gridDefine.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_define;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridDefine.getStore().load({
																params : {
																			start : startIndex,
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
				id : 'form',
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
						url : SAVE_DEFINE_URL,
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
												grid.getStore().load({
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
								url : SAVE_DEFINE_URL,
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
															Ext.BDP.FunLib.ReturnDataForUpdate("gridDefine", QUERY_DEFINE_URL, myrowid)
														 
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
				Ext.getCmp("form").getForm().findField("KPICode").focus(true,800);
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
						Ext.getCmp("form").getForm().reset();
			            Ext.getCmp("form").getForm().load({
			                url : OPEN_DEFINE_URL + '&id=' + _record.get('KPIRowId'),
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
				proxy : new Ext.data.HttpProxy({ url : QUERY_DEFINE_URL }),// 调用的动作
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
					Ext.getCmp("textCode").reset();
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
				items : ['代码:', {
							xtype : 'textfield',
							id : 'textCode',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textCode')
						}, '-',
						'名称:', {
							xtype : 'textfield',
							id : 'textDesc',
							width:120,
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
				region : 'west',
				width:730,
				split:true,
				collapsible:true,
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
				stateId : 'gridDefine'
			});
	/**默认选中*/
	gridDefine.store.on("load",function(){  
		if(gridDefine.getStore().getCount()!=0){
	        gridDefine.getSelectionModel().selectRow(0,true);  
	        var parref = gridDefine.getSelectionModel().getSelections()[0].get('KPIRowId');
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
	 	var parref = gridDefine.getSelectionModel().getSelections()[0].get('KPIRowId');
	 	ds.load({
			params : {
				parref : parref,
				start : 0,
				limit : pagesize_main
			}
		});
	 });
/*******************************目标值维护*************************************/
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
                        [{name: 'KPIRowId',mapping:'KPIRowId',type:'string'},
                         {name: 'KPIDR',mapping:'KPIDR',type:'string'},
                         {name: 'ElementName',mapping:'ElementName',type:'string'},
                         {name: 'TargetVal',mapping:'TargetVal',type:'string'},
                         {name: 'Period',mapping:'Period',type:'string'},
                         {name: 'TargetDate',mapping:'TargetDate',type:'string'}
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
							xtype : 'combo',
							hidden:true,
							//fieldLabel : '<font color=red>*</font>指标条件',
							name : 'KPIDR',
							id:'KPIDRF',
							hiddenName:'KPIDR',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('KPIDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('KPIDRF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '指标条件不能为空',
							allowBlank : false,
							valueField : 'KPIRowId',
							displayField : 'KPIName',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingKPI,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'KPIRowId',
								fields : ['KPIRowId', 'KPIName'],
								remoteSort : true,
								sortInfo : {
									field : 'KPIRowId',
									direction : 'ASC'
								}
							})
						}, {
							fieldLabel : '<font color=red>*</font>因素名称',
							name : 'ElementName',
							id:'ElementNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ElementNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ElementNameF')),
							allowBlank : false,
							blankText:'因素名称不能为空'/*,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.KPITargetVal"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
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
                            invalidText : '该因素名称已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }*/
						}, {
							fieldLabel : '<font color=red>*</font>目标值',
							name : 'TargetVal',
							id:'TargetValF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TargetValF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TargetValF')),
   							allowBlank:false,
   							blankText:'目标值不能为空'
						}, {
							xtype : 'combo',
							fieldLabel : '周期类型',
							name : 'Period',
							id : 'PeriodF',
							hiddenName : 'Period',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PeriodF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PeriodF')),
							editable:false,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['Y','年'],
									      ['Q','季'],
									      ['M','月'],
									      ['D','日'],
									      ['W','星期']
								     ]
							})
						}, {
							xtype : 'datefield',
							fieldLabel : '目标值日期',
							name : 'TargetDate',
							id:'TargetDateF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TargetDateF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TargetDateF')),
							format : 'Y/m/d',
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
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
				var ElementName = Ext.getCmp("ElementNameF").getValue();
				var TargetVal = Ext.getCmp("TargetValF").getValue();
				if(WinForm.form.isValid()==false){return;}
    			if (ElementName=="") {
    				Ext.Msg.show({ title : '提示', msg : '因素名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (TargetVal=="") {
    				Ext.Msg.show({ title : '提示', msg : '目标值不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
				Ext.getCmp("form-save").getForm().findField("ElementName").focus(true,800);
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
						Ext.getCmp("KPIDRF").setValue(gridDefine.getSelectionModel().getSelected().get('KPIRowId'));
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
			                url : OPEN_ACTION_URL + '&id=' + _record.get('KPIRowId'),
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
									name : 'KPIRowId',
									mapping : 'KPIRowId',
									type : 'string'
								}, {
									name : 'ElementName',
									mapping : 'ElementName',
									type : 'string'
								}, {
									name : 'TargetVal',
									mapping : 'TargetVal',
									type : 'string'
								}, {
									name : 'Period',
									mapping : 'Period',
									type : 'string'
								}, {
									name : 'TargetDate',
									mapping : 'TargetDate',
									type : 'date',
									dateFormat : 'm/d/Y'
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
			     parref:gridDefine.getSelectionModel().getSelections()[0].get('KPIRowId')
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
							name : Ext.getCmp("ElementName").getValue()
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
					Ext.getCmp("ElementName").reset();
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
				items : ['因素名称:', {
							xtype : 'textfield',
							id : 'ElementName',
							width:120,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ElementName')
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
							header : 'KPIRowId',
							sortable : true,
							dataIndex : 'KPIRowId',
							hidden : true
						}, {
							header : '因素名称',
							sortable : true,
							dataIndex : 'ElementName'
						},  {
							header : '目标值',
							sortable : true,
							dataIndex : 'TargetVal'
						}, {
							header : '周期类型',
							sortable : true,
							dataIndex : 'Period',
							renderer:function(value){
								if(value=="Y"){
									return "年";
								}
								if(value=="Q"){
									return "季"
								}
								if(value=="M"){
									return "月";
								}
								if(value=="D"){
									return "日"
								}
								if(value=="W"){
									return "星期"
								}
							}
						},	{
							header : '目标值日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer('Y/m/d'),
							dataIndex : 'TargetDate'
						}],
				stripeRows : true,
				title : 'KPI目标值维护',
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
				items : [gridDefine,grid]
			});
});
