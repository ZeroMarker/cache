/// 名称: 检验项目与指标关联表维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-11-4
/// 修改日期：2015-6-18
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var selectrow=Ext.getUrlParam('selectrow');

document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	var QUERY_ACTION_URL_VAL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLabItmVal&pClassQuery=GetList";
	var SAVE_ACTION_URL_VAL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCLabItmVal&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCLabItmVal";
	var OPEN_ACTION_URL_VAL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLabItmVal&pClassMethod=OpenData";
	var DELETE_ACTION_URL_VAL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCLabItmVal&pClassMethod=DeleteData";
	var ParRef_Dr_QUERY_ACTION_URL_VAL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCLabItmFeild&pClassQuery=GetDataForCmb1";
	var Gen_Dr_QUERY_ACTION_URL_VAL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1&code=LAB";
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	/** 删除按钮 */
	var btnDelVal = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					id:'del_btn_Val',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_Val'),
					handler : DelData=function () {
						if (gridVal.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = gridVal.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL_VAL,
										method : 'POST',
										params : {
											'id' : rows[0].get('PHLFIRowId')
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
															var startIndex = gridVal.getBottomToolbar().cursor;
															var totalnum=gridVal.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
															{
																var pagenum=gridVal.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															gridVal.getStore().load({
																		params : {
																			start : startIndex,
																			limit : pagesize_pop
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

	/**通用名多选下拉框*/	  
	var genComboxVal =  new Ext.form.MultiSelect({ 
							fieldLabel : '<font color=red>*</font>通用名',
							hiddenName : 'PHLFIGenDr',
							id:'PHLFIGenDrF',
							//xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIGenDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIGenDrF')),
   							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : Gen_Dr_QUERY_ACTION_URL_VAL,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEGRowId',
								fields : ['PHEGRowId', 'PHEGDesc'],
								listeners:{
									'load':function(store){
										if(Ext.getCmp('PHLFIGenDrF').getValue()!=""){
											var cfmF = window.confirm('本页数据已变动,是否保存?');
								    		if(cfmF){ //是
								    			saveData();
								    		}else{
								    			Ext.getCmp('PHLFIGenDrF').setValue("");
								    		}
										}
									}
								}
							}),
							mode : 'remote',
							minChars : 0,
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId',
							showSelectAll:true, 
    						resizable: true,
    						triggerAction: 'all'	
					});
						
	/** 创建修改Form表单 */
	var WinFormUpdate = new Ext.form.FormPanel({
				id : 'form-update-Val',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PHLFIRowId',mapping:'PHLFIRowId',type:'string'},
                                         {name: 'PHLFIParRefDr',mapping:'PHLFIParRefDr',type:'string'},
                                         {name: 'PHLFIGenDr',mapping:'PHLFIGenDr',type:'string'},                                     
                                         {name: 'PHLFIVal',mapping:'PHLFIVal',type:'string'},
                                         {name: 'PHLFIRelation',mapping:'PHLFIRelation',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHLFIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHLFIRowId'
						}, {
							id : 'PHLFIParRefDrU',
							xtype : 'textfield',
							fieldLabel : 'PHLFIParRefDr',
							name : 'PHLFIParRefDr',
							hideLabel : 'True',
							hidden : true
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank : false,
							fieldLabel : '<font color=red>*</font>通用名',
							hiddenName : 'PHLFIGenDr',
							id:'PHLFIGenDrU',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIGenDrU'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIGenDrU')),
							store :new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Gen_Dr_QUERY_ACTION_URL_VAL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHEGRowId',mapping:'PHEGRowId'},
										{name:'PHEGDesc',mapping:'PHEGDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId'
						},{
							fieldLabel:'标识',
							xtype : 'combo',
							name : 'PHLFIVal',
							hiddenName:'PHLFIVal',
							id:'PHLFIValU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIValU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIValU')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['H','高'],
									      ['L','低'],
									      ['N','正常'],
									      ['I','包含'],
									      ['NT','阴性'],
									      ['PT','阳性']
								     ]
							})
						},{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PHLFIRelation',
							hiddenName : 'PHLFIRelation',
							id:'PHLFIRelationU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIRelationU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIRelationU')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						}]
			});
	/** 修改时弹出窗口 */
	var winUpdate = new Ext.Window({
					title:'修改',
					iconCls:'icon-update',
					width : 420,
					height:360,
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
					items : WinFormUpdate,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'update_btn_Val',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_Val'),
						handler : function () {
							var tempGen = Ext.getCmp("form-update-Val").getForm().findField("PHLFIGenDr").getValue();
			    			if (tempGen=="") {
			    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormUpdate.form.isValid()==false){return;}								
							Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinFormUpdate.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL_VAL,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdate.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("gridVal", QUERY_ACTION_URL_VAL, myrowid)
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
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							winUpdate.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save-Val").getForm().findField("PHLFIParRefDr").focus(true,800);
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
		/** 创建添加Form表单 */
	var WinFormVal = new Ext.form.FormPanel({
				id : 'form-save-Val',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PHLFIRowId',mapping:'PHLFIRowId',type:'string'},
                                         {name: 'PHLFIParRefDr',mapping:'PHLFIParRefDr',type:'string'},
                                         {name: 'PHLFIGenDr',mapping:'PHLFIGenDr',type:'string'},                                     
                                         {name: 'PHLFIVal',mapping:'PHLFIVal',type:'string'},
                                         {name: 'PHLFIRelation',mapping:'PHLFIRelation',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHLFIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHLFIRowId'
						}, {
							id : 'PHLFIParRefDr',
							xtype : 'textfield',
							fieldLabel : 'PHLFIParRefDr',
							name : 'PHLFIParRefDr',
							hideLabel : 'True',
							hidden : true
						},genComboxVal,{
							fieldLabel:'标识',
							xtype : 'combo',
							name : 'PHLFIVal',
							hiddenName:'PHLFIVal',
							id:'PHLFIValF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIValF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIValF')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['H','高'],
									      ['L','低'],
									      ['N','正常'],
									      ['I','包含'],
									      ['NT','阴性'],
									      ['PT','阳性']
								     ]
							})
						},{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PHLFIRelation',
							hiddenName : 'PHLFIRelation',
							id:'PHLFIRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHLFIRelationF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHLFIRelationF')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						}]
			});
	/** 增加修改时弹出窗口 */
	var winVal = new Ext.Window({
					width : 420,
					height:360,
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
					items : WinFormVal,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn_Val',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_Val'),
						handler : saveData=function () {
							var tempGen = Ext.getCmp("form-save-Val").getForm().findField("PHLFIGenDr").getValue();
			    			if (tempGen=="") {
			    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormVal.form.isValid()==false){return;}
							WinFormVal.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_VAL,
									method : 'POST',
									params : {
										'PHLFIParRefDr' : selectrow //在打开的时候,已赋值
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											winVal.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var totalnum=gridVal.getStore().getTotalCount();
															var myrowid = action.result.id;
															gridVal.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop,
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
						}
					},{
						text : '继续添加',
						iconCls : 'icon-save',
						id:'resave_btn_Val',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn_Val'),
						handler : function () {
							var tempGen = Ext.getCmp("form-save-Val").getForm().findField("PHLFIGenDr").getValue();
			    			if (tempGen=="") {
			    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormVal.form.isValid()==false){return;}
								WinFormVal.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_VAL,
									method : 'POST',
									params : {
										'PHLFIParRefDr' : selectrow //在打开的时候,已赋值
									},
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save-Val").getForm().reset();							
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var myrowid = action.result.id;
															var totalnum=gridVal.getStore().getTotalCount();
															gridVal.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop,
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
						}
					}, {
						text : '关闭',
						iconCls : 'icon-close',
						handler : function() {
							winVal.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save-Val").getForm().findField("PHLFIParRefDr").focus(true,800);
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwinVal = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn_Val',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_Val'),
				handler : AddData=function () {
					winVal.setTitle('添加');
					winVal.setIconClass('icon-add');
					winVal.show('new1');
					WinFormVal.getForm().reset();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwinVal = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn_Val',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_Val'),
				handler : UpdateData=function () {
					if (gridVal.selModel.hasSelection()) {
						var _record = gridVal.getSelectionModel().getSelected();
						winUpdate.show('');
						Ext.getCmp("form-update-Val").getForm().reset();
			            Ext.getCmp("form-update-Val").getForm().load({
			                url : OPEN_ACTION_URL_VAL + '&id=' + _record.get('PHLFIRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });					
			        } else {
			        	Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
			            
			        }
				}
			});
	/** gridVal数据存储 */
	var dsVal = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL_VAL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PHLFIRowId',
									mapping : 'PHLFIRowId',
									type : 'string'
								}, {
									name : 'PHLFIParRefDr',
									mapping : 'PHLFIParRefDr',
									type : 'string'
								}, {
									name : 'PHLFIGenDr',
									mapping : 'PHLFIGenDr',
									type : 'string'
								},{
									name : 'PHLFIVal',
									mapping : 'PHLFIVal',
									type : 'string'
								},{
									name : 'PHLFIRelation',
									mapping : 'PHLFIRelation',
									type : 'string'
								}// 列的映射
						])
			});
	/** gridVal数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : dsVal
					});
	/** gridVal加载数据 */
	dsVal.load({
				params : {
					start : 0,
					limit : pagesize_pop,
					parref: selectrow
				},
				callback : function(records, options, success) {
				}
			});
	/** 加载前设置参数 */
	dsVal.on('beforeload',function() {
					var gsm = gridVal.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(dsVal.lastOptions.params, {
				    	parref:selectrow
				    });
			},this);		
	
	/** gridVal分页工具条 */
	var pagingVal = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : dsVal,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_pop=this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbuttonVal = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwinVal, '-', btnEditwinVal, '-', btnDelVal]
		});
	/** 搜索按钮 */
	var btnSearchVal = new Ext.Button({
				id : 'btnSearchVal',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchVal'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					gridVal.getStore().baseParams={			
							parref :selectrow,
							gen : Ext.getCmp("TextGen2").getValue(),
							val : Ext.getCmp("TextVal").getValue(),
							relation : Ext.getCmp("TextRelation").getValue()
					};
					gridVal.getStore().load({
						params : {
									start : 0,
									limit : pagesize_pop
								}
						});
					}
			});
	/** 重置按钮 */
	var btnRefreshVal = new Ext.Button({
				id : 'btnRefreshVal',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshVal'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextGen2").reset();
					Ext.getCmp("TextVal").reset();
					Ext.getCmp("TextRelation").reset();
					gridVal.getStore().baseParams={
						parref :selectrow
					};
					gridVal.getStore().load({
								params : {
											start : 0,
											limit : pagesize_pop
										}
								});
						}
				});
	/** 搜索工具条 */
	var tbVal = new Ext.Toolbar({
				id : 'tbVal',
				items : ['通用名', {
							hiddenName : 'PHLFIGenDr',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							emptyText:'请选择',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextGen2'),
							id : 'TextGen2',
   							store : new Ext.data.Store({
										autoLoad: true,
										//baseParams:{code:'LAB'},
										proxy : new Ext.data.HttpProxy({ url : Gen_Dr_QUERY_ACTION_URL_VAL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHEGRowId',mapping:'PHEGRowId'},
										{name:'PHEGDesc',mapping:'PHEGDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId'
							
						}, '-',
						'标识',{
							xtype : 'combo',
							emptyText:'请选择',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextVal'),
							id : 'TextVal',
							hiddenName:'PHLFIVal',
   							width : 80,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['H','高'],
									      ['L','低'],
									      ['N','正常'],
									      ['I','包含'],
									      ['NT','阴性'],
									      ['PT','阳性']
								     ]
							})
						},'-',
						'逻辑关系',{
							xtype : 'combo',
							emptyText:'请选择',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextRelation'),
							id : 'TextRelation',
							hiddenName:'PHLFIRelation',
   							width : 80,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						}, '-', btnSearchVal, '-', btnRefreshVal, '->'
				],
				listeners : {
					render : function() {
						tbbuttonVal.render(gridVal.tbar);
					}
				}
			});
	/** 创建grid */
	var gridVal = new Ext.grid.GridPanel({
				id : 'gridVal',
				region : 'center',
				closable : true,
				store : dsVal,
				frame : true,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHLFIRowId',
							sortable : true,
							dataIndex : 'PHLFIRowId',
							hidden : true
						}, {
							header : '检验项目',
							sortable : true,
							dataIndex : 'PHLFIParRefDr'
						}, {
							header : '通用名',
							sortable : true,
							dataIndex : 'PHLFIGenDr'
						},{
							header : '标识',
							sortable : true,
							dataIndex : 'PHLFIVal',
							renderer:function(value)
            				{
			            		if (value=="H")
			            		{
			            		   return "高";
			            		}
			            		if (value=="L")
			            		{
			            		   return "低";
			            		}
			            		if (value=="N")
			            		{
			            		   return "正常";
			            		}
			            		if (value=="I")
			            		{
			            		   return "包含";
			            		   //return "<span style='color:black;<font size=15>;'>"+value+"</span>";
			            		}
			            		if (value=="NT")
			            		{
			            		   return "阴性";
			            		}
			            		if (value=="PT")
			            		{
			            		   return "阳性";
			            		}			            		
			            	}
						},{
							header : '逻辑关系',
							sortable : true,
							dataIndex : 'PHLFIRelation',
							renderer:function(value)
            				{
			            		if (value=="O")
			            		{
			            		   return "Or";
			            		}
			            		if (value=="A")
			            		{
			            		   return "And";
			            		}
			            	}
						}],
				stripeRows : true,
				title : '检验项目与指标关联字典',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingVal,
				tbar : tbVal,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'gridVal'
			});
	/** gridVal双击事件 */
	gridVal.on("rowdblclick", function(gridVal, rowIndex, e) {
				var _record = gridVal.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
					winUpdate.show('');
					Ext.getCmp("form-update-Val").getForm().reset();
		            Ext.getCmp("form-update-Val").getForm().load({
		                url : OPEN_ACTION_URL_VAL + '&id=' + _record.get('PHLFIRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});		
	/** 布局 */
	var viewportVal = new Ext.Viewport({
				layout : 'border',
				items : [gridVal]
			});
	/** 调用keymap */

    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
});
