/// 名称: 诊断逻辑推导目录表（树形）：User.DHCPHDiseaseTree
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-谷雪萍  陈莹  
/// 编写日期: 2017-04-13
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreePanelPublic.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qitp';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var sysurl="../csp/"

	var SAVE_ACTION_URL = sysurl+"dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseTree";
	var OPEN_ACTION_URL = sysurl+"dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=OpenData";
	var DELETE_ACTION_URL = sysurl+"dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=DeleteData";
	var TREE_ACTION_URL = sysurl+"dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=GetTreeJson";
	var TREE_COMBO_URL = sysurl+"dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=GetTreeComboJson";
	var DRAG_ACTION_URL = sysurl+"dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseTree&pClassMethod=DragNode";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var selectNode="",selectNodeDesc="";
	var ObjectReference="";
	
	var QUERY_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassQuery=GetList";
	var SAVE_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseLinkLabel";
	var OPEN_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassMethod=OpenData";
	var DELETE_ACTION_URL_LinkLabel = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseLinkLabel&pClassMethod=DeleteData";
	var Label_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHGuideLabel&pClassQuery=GetDataForCmb1";
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	
	var Gen_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb2";
	var KeyWord_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHKeyWord&pClassQuery=GetDataForCmb1&type=0";
	var ID_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassQuery=GetIDDataForCmb";
	
	
	
	
	/** 删除按钮 */
	var btnDelLinkLabel = new Ext.Toolbar.Button({
					text : '删除',
					iconCls : 'icon-delete',
					id:'del_btn_LinkLabel',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_LinkLabel'),
					handler : DelDataLinkLabel=function () {
						
						
					
						if (gridLinkLabel.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = gridLinkLabel.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL_LinkLabel,
										method : 'POST',
										params : {
											'id' : rows[0].get('PDLRowId')
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
															
															Ext.BDP.FunLib.DelForTruePage(gridLinkLabel,pagesize_pop);
															tkMakeServerCall("web.DHCBL.KB.DHCPHDisLabelItm","DeleteDataAll",rows[0].get('PDLRowId'))
															//dsLabelItm.removeAll()   //诊断逻辑推导目录，删除推导目录后，推导目录明细页签未清空刷新  2017-10-13
															//pagingLabelItm.refresh;
															//pagingLabelItm.removeAll()
															Ext.BDP.FunLib.DelForTruePage(gridLabelItm,pagesize_pop);
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
					}
				});

	/**指南目录多选下拉框*/	  
	var genComboxLinkLabel =  new Ext.form.MultiSelect({ 
							fieldLabel : '<font color=red>*</font>指南目录',
							hiddenName : 'PDLLabelDr',
							name : 'PDLLabelDr',
							id:'PDLLabelDrF',
							//xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLLabelDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLLabelDrF')),
   							store : new Ext.data.JsonStore({
								url : Label_Dr_QUERY_ACTION_URL,
								root : 'data',
								totalProperty : 'total',
								fields : ['PGLRowId', 'PGLDesc'],
								listeners:{
									'load':function(store){
										if(Ext.getCmp('PDLLabelDrF').getValue()!=""){
											var cfmF = window.confirm('本页数据已变动,是否保存?');
								    		if(cfmF){ //是
								    			var tempValue = Ext.getCmp("form-save-LinkLabel").getForm().findField("PDLLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormLinkLabel.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 			return;}
					 
					 		Ext.getCmp("PDLDisTreeDrF").setValue( selectNode);
							WinFormLinkLabel.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LinkLabel,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															//var totalnum=gridLinkLabel.getStore().getTotalCount();
															//var myrowid = action.result.id;
															gridLinkLabel.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																				//,rowid : myrowid
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
								    		}else{
								    			Ext.getCmp('PDLLabelDrF').setValue("");
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
							displayField : 'PGLDesc',
							valueField : 'PGLRowId',
							showSelectAll:true, 
    						resizable: true,
    						triggerAction: 'all'	
					});
						
	/** 创建修改Form表单 */
	var WinFormUpdateLinkLabel = new Ext.form.FormPanel({
				id : 'form-update-LinkLabel',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDLRowId',mapping:'PDLRowId',type:'string'},
                                         {name: 'PDLDisTreeDr',mapping:'PDLDisTreeDr',type:'string'},
                                         {name: 'PDLLabelDr',mapping:'PDLLabelDr',type:'string'},                                     
                                         {name: 'PDLOperator',mapping:'PDLOperator',type:'string'},
                                         {name: 'PDLRelation',mapping:'PDLRelation',type:'string'},
                                         {name: 'PDLNum',mapping:'PDLNum',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDLRowId'
						}, {
							id : 'PDLDisTreeDrU',
							xtype : 'textfield',
							fieldLabel : 'PDLDisTreeDr',
							name : 'PDLDisTreeDr',
							hideLabel : 'True',
							hidden : true
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank : false,
							fieldLabel : '<font color=red>*</font>指南目录',
							hiddenName : 'PDLLabelDr',
							name : 'PDLLabelDr',
							id:'PDLLabelDrU',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLLabelDrU'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLLabelDrU')),
							store :new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PGLDesc',
							valueField : 'PGLRowId'
						},{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PDLRelation',
							hiddenName : 'PDLRelation',
							id:'PDLRelationU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLRelationU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLRelationU')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						},{
							fieldLabel:'运算符',
							xtype : 'combo',
							name : 'PDLOperator',
							hiddenName:'PDLOperator',
							id:'PDLOperatorU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLOperatorU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLOperatorU')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})
						},{
							fieldLabel:'数量',
							xtype:'numberfield',
							name : 'PDLNum',
							id:'PDLNumU',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLNumU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLNumU'))
						}]
			});
	/** 修改时弹出窗口 */
	var winUpdateLinkLabel = new Ext.Window({
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
					items : WinFormUpdateLinkLabel,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'update_btn_LinkLabel',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_LinkLabel'),
						handler : function () {
							var tempValue = Ext.getCmp("form-update-LinkLabel").getForm().findField("PDLLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormUpdateLinkLabel.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}								
							Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinFormUpdateLinkLabel.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL_LinkLabel,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdateLinkLabel.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("gridLinkLabel", QUERY_ACTION_URL_LinkLabel, myrowid)
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
							winUpdateLinkLabel.hide();
						}
					}],
					listeners : {
						"show" : function() {
							},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
		/** 创建添加Form表单 */
	var WinFormLinkLabel = new Ext.form.FormPanel({
				id : 'form-save-LinkLabel',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDLRowId',mapping:'PDLRowId',type:'string'},
                                         {name: 'PDLDisTreeDr',mapping:'PDLDisTreeDr',type:'string'},
                                         {name: 'PDLLabelDr',mapping:'PDLLabelDr',type:'string'},                                     
                                         {name: 'PDLOperator',mapping:'PDLOperator',type:'string'},
                                         {name: 'PDLRelation',mapping:'PDLRelation',type:'string'},
                                         {name: 'PDLNum',mapping:'PDLNum',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDLRowId'
						}, {
							id : 'PDLDisTreeDrF',
							xtype : 'textfield',
							fieldLabel : 'PDLDisTreeDr',
							name : 'PDLDisTreeDr',
							hideLabel : 'True',
							hidden : true
						},genComboxLinkLabel,{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PDLRelation',
							hiddenName : 'PDLRelation',
							id:'PDLRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLRelationF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLRelationF')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						},{
							fieldLabel:'运算符',
							xtype : 'combo',
							name : 'PDLOperator',
							hiddenName:'PDLOperator',
							id:'PDLOperatorF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLOperatorF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLOperatorF')),
   							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})
						},{
							fieldLabel:'数量',
							xtype:'numberfield',
							name : 'PDLNum',
							id:'PDLNumF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLNumF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLNumF'))
						}]
			});
	/** 增加时弹出窗口 */
	var winLinkLabel = new Ext.Window({
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
					items : WinFormLinkLabel,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn_LinkLabel',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_LinkLabel'),
						handler : saveDataLinkLabel=function () {
							var tempValue = Ext.getCmp("form-save-LinkLabel").getForm().findField("PDLLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormLinkLabel.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 			return;}
					 
					 		Ext.getCmp("PDLDisTreeDrF").setValue( selectNode);
							WinFormLinkLabel.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LinkLabel,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											winLinkLabel.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															//var totalnum=gridLinkLabel.getStore().getTotalCount();
															//var myrowid = action.result.id;
															gridLinkLabel.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																				//,rowid : myrowid
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
						id:'resave_btn_LinkLabel',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn_LinkLabel'),
						handler : function () {
							var tempValue = Ext.getCmp("form-save-LinkLabel").getForm().findField("PDLLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinFormLinkLabel.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
							Ext.getCmp("PDLDisTreeDrF").setValue(selectNode);
							
								WinFormLinkLabel.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LinkLabel,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save-LinkLabel").getForm().reset();							
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															gridLinkLabel.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
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
							winLinkLabel.hide();
						}
					}],
					listeners : {
						"show" : function() {
							
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwinLinkLabel = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn_LinkLabel',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_LinkLabel'),
				handler : AddDataLinkLabel=function () {
					
					
					if (selectNode=="")
					{
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				            
						
					}
					else
					{
						winLinkLabel.setTitle('添加');
						winLinkLabel.setIconClass('icon-add');
						winLinkLabel.show();
						WinFormLinkLabel.getForm().reset();
					}
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwinLinkLabel = new Ext.Toolbar.Button({
				text : '修改',
				iconCls : 'icon-update',
				id:'update_btn_LinkLabel',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_LinkLabel'),
				handler : UpdateDataLinkLabel=function () {
					
					if (selectNode=="")
					{
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				            
						
					}
					else
					{
					
						if (gridLinkLabel.selModel.hasSelection()) {
							var _record = gridLinkLabel.getSelectionModel().getSelected();
							winUpdateLinkLabel.show('');
							Ext.getCmp("form-update-LinkLabel").getForm().reset();
				            Ext.getCmp("form-update-LinkLabel").getForm().load({
				                url : OPEN_ACTION_URL_LinkLabel + '&id=' + _record.get('PDLRowId'),
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
				}
			});
	/** gridLinkLabel数据存储 */
	var dsLinkLabel = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL_LinkLabel }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PDLRowId',
									mapping : 'PDLRowId',
									type : 'string'
								}, {
									name : 'PDLDisTreeDr',
									mapping : 'PDLDisTreeDr',
									type : 'string'
									
								}, {
									name : 'PDLLabelDrID',
									mapping : 'PDLLabelDrID',
									type : 'string'	
									
									
								}, {
									name : 'PDLLabelDr',
									mapping : 'PDLLabelDr',
									type : 'string'
								},{
									name : 'PDLRelation',
									mapping : 'PDLRelation',
									type : 'string'
								},{
									name : 'PDLOperator',
									mapping : 'PDLOperator',
									type : 'string'
								},{
									name : 'PDLNum',
									mapping : 'PDLNum',
									type : 'string'
								}// 列的映射
						])
			});
	
	/** gridLinkLabel加载数据 */
	dsLinkLabel.load({
				params : {
					start : 0,
					limit : pagesize_pop
				},
				callback : function(records, options, success) {
				}
			});
	
	/** gridLinkLabel分页工具条 */
	var pagingLinkLabel = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : dsLinkLabel,
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
	var tbbuttonLinkLabel = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwinLinkLabel, '-', btnEditwinLinkLabel, '-', btnDelLinkLabel]
		});
	/** 搜索按钮 */
	var btnSearchLinkLabel = new Ext.Button({
				id : 'btnSearchLinkLabel',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchLinkLabel'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if (selectNode=="")
					{
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				            
						
					}
					else
					{
						gridLinkLabel.getStore().baseParams={			
								treeid :selectNode,
								label : Ext.getCmp("Textlabel").getValue()
						};
						gridLinkLabel.getStore().load({
							params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						}
					}
			});
	/** 重置按钮 */
	var btnRefreshLinkLabel = new Ext.Button({
				id : 'btnRefreshLinkLabel',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshLinkLabel'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : RefreshLinkLabel=function() {
					Ext.getCmp("Textlabel").reset();
					gridLinkLabel.getStore().baseParams={
						treeid :selectNode
					};
					gridLinkLabel.getStore().load({
								params : {
											start : 0,
											limit : pagesize_pop
										}
								});
					dsLabelItm.removeAll();
						}
						
				});
	/** 搜索工具条 */
	var tbLinkLabel = new Ext.Toolbar({
				id : 'tbVal',
				items : ['指南目录', {
							hiddenName : 'PDLLabelDr',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('Textlabel'),
							id : 'Textlabel',
   							store : new Ext.data.Store({
										//baseParams:{code:'LAB'},
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PGLDesc',
							valueField : 'PGLRowId'
							
						}, '-', btnSearchLinkLabel, '-', btnRefreshLinkLabel, '->'
				],
				listeners : {
					render : function() {
						tbbuttonLinkLabel.render(gridLinkLabel.tbar);
					}
				}
			});
	/** 创建grid */
	var gridLinkLabel = new Ext.grid.GridPanel({
				id : 'gridLinkLabel',
				region : 'north',
				closable : true,
				store : dsLinkLabel,
				height:300,
				frame : true,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PDLRowId',
							sortable : true,
							dataIndex : 'PDLRowId',
							hidden : true
						}, {
							header : '检验项目',
							sortable : true,
							dataIndex : 'PDLDisTreeDr',
							hidden : true
						}, {
							header : '指南目录id',
							sortable : true,
							hidden : true,
							dataIndex : 'PDLLabelDrID'
						}, {
							header : '指南目录',
							sortable : true,
							dataIndex : 'PDLLabelDr'
						},{
							header : '逻辑关系',
							sortable : true,
							dataIndex : 'PDLRelation',
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
						},{
							header : '运算符',
							sortable : true,
							dataIndex : 'PDLOperator',
							renderer:function(value)
            				{
			            		if (value==">")
			            		{
			            		   return "大于";
			            		}
			            		if (value=="<")
			            		{
			            		   return "小于";
			            		}
			            		if (value=="=")
			            		{
			            		   return "等于";
			            		}
			            		if (value=="!>")
			            		{
			            		   return "不大于";
			            		}
			            		if (value=="!<")
			            		{
			            		   return "不小于";
			            		}
			            		if (value=="<>")
			            		{
			            		   return "不等于";
			            		}			            		
			            	}
						},{
							header : '数量',
							sortable : true,
							dataIndex : 'PDLNum'
						}],
				stripeRows : true,
				title : '推导目录',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingLinkLabel,
				tbar : tbLinkLabel,
				stateId : 'gridLinkLabel'
			});
			
	HideComponent= function(formid,id){
        var obj=  Ext.getCmp(formid).findById(id);
        if(obj){
            obj.getEl().up('.x-form-item').setDisplayed(false);
        }
    }
    ShowComponent= function(formid,id){
        var obj=  Ext.getCmp(formid).findById(id);
        if(obj){
            obj.getEl().up('.x-form-item').setDisplayed(true);
            obj.show();
        }
    }
	/** gridLinkLabel单击事件 */
	gridLinkLabel.on("rowclick", function(gridLinkLabel, rowIndex, e) {
		
				if (gridLinkLabel.selModel.hasSelection()) {
						var _record = gridLinkLabel.getSelectionModel().getSelected();
				 		
						gridLabelItm.getStore().baseParams={			
								pdliid :_record.get('PDLRowId')
						};
						gridLabelItm.getStore().load({
							params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						if ((_record.get('PDLLabelDr')=="症状"))
						{
							gridLabelItm.getColumnModel().setHidden(1, true);
							gridLabelItm.getColumnModel().setHidden(2, true);
							gridLabelItm.getColumnModel().setHidden(3, true);
							gridLabelItm.getColumnModel().setHidden(4, true);
							gridLabelItm.getColumnModel().setHidden(5, true);
							gridLabelItm.getColumnModel().setHidden(7, true);
							gridLabelItm.getColumnModel().setHidden(6, false);
							gridLabelItm.getColumnModel().setHidden(8, true);
							gridLabelItm.viewConfig={
										forceFit : true
								}
							gridLabelItm.doLayout()
						}
						
						if ((_record.get('PDLLabelDr')=="诊断"))
						{
							gridLabelItm.getColumnModel().setHidden(1, true);
							gridLabelItm.getColumnModel().setHidden(2, true);
							gridLabelItm.getColumnModel().setHidden(3, true);
							gridLabelItm.getColumnModel().setHidden(4, true);
							gridLabelItm.getColumnModel().setHidden(5, true);
							gridLabelItm.getColumnModel().setHidden(7, true);
							gridLabelItm.getColumnModel().setHidden(6, false);
							gridLabelItm.getColumnModel().setHidden(8, true);
							gridLabelItm.viewConfig={
										forceFit : true
								}
								gridLabelItm.doLayout()
							
						}
						if ((_record.get('PDLLabelDr')=="检验")||(_record.get('PDLLabelDr')=="检查"))		
						{
								gridLabelItm.getColumnModel().setHidden(8, false);
								gridLabelItm.getColumnModel().setHidden(7, false);
								gridLabelItm.getColumnModel().setHidden(6, true);
								gridLabelItm.getColumnModel().setHidden(5, false);
								gridLabelItm.getColumnModel().setHidden(4, false);
								gridLabelItm.getColumnModel().setHidden(3, false);
								gridLabelItm.getColumnModel().setHidden(2, false);
								gridLabelItm.getColumnModel().setHidden(1, true);
								
								gridLabelItm.viewConfig={
										forceFit : false
								}
								gridLabelItm.doLayout()
								
								if (_record.get('PDLLabelDr')=="检验")
								{
									GenDRStore.baseParams = {
										libcode :'LAB'
									};
								}
								if (_record.get('PDLLabelDr')=="检查")
								{
									GenDRStore.baseParams = {
										libcode :'CHECK'
									};
								}
								
						}
							
					}
					else{
						 Ext.Msg.show({
													title : '提示',
													msg : '请选择推导目录!',
													icon : Ext.Msg.WARNING,
													buttons : Ext.Msg.OK
												});
					}
				
			});	
	/** gridLinkLabel双击事件 */
	gridLinkLabel.on("rowdblclick", function(gridLinkLabel, rowIndex, e) {
				var _record = gridLinkLabel.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
		        	gridLabelItm.getColumnModel().setHidden(7, true);
					winUpdateLinkLabel.show('');
					Ext.getCmp("form-update-LinkLabel").getForm().reset();
		            Ext.getCmp("form-update-LinkLabel").getForm().load({
		                url : OPEN_ACTION_URL_LinkLabel + '&id=' + _record.get('PDLRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});	
			
			
	/**********************诊断目录明细表 start*****************************/		
			
			
			
	
	var QUERY_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassQuery=GetList";
	var SAVE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLabelItm";
	var OPEN_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=OpenData";
	var DELETE_ACTION_URL_LabelItm = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelItm&pClassMethod=DeleteData";
	
	/** 删除按钮 */
	var btnDelLabelItm = new Ext.Toolbar.Button({
					text : '删除',
					iconCls : 'icon-delete',
					id:'del_btn_LabelItm',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_LabelItm'),
					handler : DelDataLabelItm=function () {
						
						if (selectNode=="")
						{
							Ext.Msg.show({
								title : '提示',
								msg : '请先选择左侧诊断逻辑推导目录!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}
						else
						{
							
						
							if (gridLinkLabel.selModel.hasSelection()) {
								if (gridLabelItm.selModel.hasSelection()) {
									Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
										if (btn == 'yes') {
											Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
											var gsm = gridLabelItm.getSelectionModel();// 获取选择列
											var rows = gsm.getSelections();// 根据选择列获取到所有的行
											
											Ext.Ajax.request({
												url : DELETE_ACTION_URL_LabelItm,
												method : 'POST',
												params : {
													'id' : rows[0].get('PDLIRowId')
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
																	
																	Ext.BDP.FunLib.DelForTruePage(gridLabelItm,pagesize_pop);
																	
																	
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
							} else {
								Ext.Msg.show({
											title : '提示',
											msg : '请先选择推导目录!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
							}
						}
					}
				});
	
	/**通用名多选下拉框*/	  
	var PDLIGenDrComboxLabelItm =  new Ext.form.MultiSelect({ 
							fieldLabel : '通用名',  //<font color=red>*</font>
							hiddenName : 'PDLIGenDr',
							name:'PDLIGenDr',
							id:'PDLIGenDrF',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrF')),
   							store : new Ext.data.JsonStore({
								url : Gen_Dr_QUERY_ACTION_URL,
								root : 'data',
								totalProperty : 'total',
								fields : ['PHEGRowId', 'PHEGDesc'],
								listeners:{
									'load':function(store){
										if(Ext.getCmp('PDLIGenDrF').getValue()!=""){
											var cfmF = window.confirm('本页数据已变动,是否保存?');
								    		if(cfmF){ //是
								    				if (!gridLinkLabel.selModel.hasSelection()) {
											Ext.Msg.show({ title : '提示', msg : '请先选择推导目录!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
						          			return;
										}
							
							
			   			 			if(WinFormLabelItm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
										 return;}
									WinFormLabelItm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LabelItm,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															//var totalnum=gridLabelItm.getStore().getTotalCount();
															//var myrowid = action.result.id;
															gridLabelItm.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																				//,rowid : myrowid
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
								    		}else{
								    			Ext.getCmp('PDLIGenDrF').setValue("");
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
	//上面选择症状，出现知识库关键字的数据，选择诊断，出现病症的数据
	var keywordds=new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : ID_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'RowId',mapping:'RowId'},
										{name:'Desc',mapping:'Desc'} ])
								})		
	var GenDRStore= new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Gen_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHEGRowId',mapping:'PHEGRowId'},
										{name:'PHEGDesc',mapping:'PHEGDesc'} ])
								})
	/** 创建修改Form表单 */
	var WinFormUpdateLabelItm = new Ext.form.FormPanel({
				id : 'form-update-LabelItm',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDLIRowId',mapping:'PDLIRowId',type:'string'},
                                         {name: 'PDLIId',mapping:'PDLIId',type:'string'},         
                                         {name: 'PDLIGenDr',mapping:'PDLIGenDr',type:'string'},
                                         {name: 'PDLIVal',mapping:'PDLIVal',type:'string'},
                                         {name: 'PDLIOperator',mapping:'PDLIOperator',type:'string'},
                                         {name: 'PDLIResultText',mapping:'PDLIResultText',type:'string'},
                                         {name: 'PDLIKeyWord',mapping:'PDLIKeyWord',type:'string'},
                                         {name: 'PDLIRelation',mapping:'PDLIRelation',type:'string'},
                                         {name: 'PDLISysFlag',mapping:'PDLISysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							
							fieldLabel : 'PDLIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDLIRowId'
						}, {
							id : 'PDLIIdUF', 
							xtype : 'textfield',
							fieldLabel : 'PDLIId',
							name : 'PDLIId',
							hideLabel : 'True',
							hidden : true
						},
						{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '通用名',
							name:'PDLIGenDr',
							hiddenName : 'PDLIGenDr',
							id:'PDLIGenDrUF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrUF')),
							store :GenDRStore,
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId'
						},{	
							fieldLabel:'检验值',
							xtype:'numberfield',
							name : 'PDLIVal',
							id:'PDLIValUF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIValUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIValUF'))
   						
   						},{
							fieldLabel:'运算符',
							xtype : 'combo',
							name : 'PDLIOperator',
							hiddenName:'PDLIOperator',   
							id:'PDLIOperatorUF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIOperatorUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIOperatorUF')),
   							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})
						
						},{
							fieldLabel:'结果',
							xtype : 'combo',
							name : 'PDLIResultText',
							hiddenName:'PDLIResultText',
							id:'PDLIResultTextUF',  
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIResultTextUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIResultTextUF')),
   							mode : 'local',
							triggerAction : 'all',// query
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
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '关联项目',
							name : 'PDLIKeyWord',
							hiddenName : 'PDLIKeyWord',
							id:'PDLIKeyWordUF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIKeyWordUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIKeyWordUF')),
							store :keywordds,
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
							
   						},{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PDLIRelation',
							hiddenName : 'PDLIRelation',
							id:'PDLIRelationUF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIRelationUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIRelationUF')),
   							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						
						
						
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDLISysFlag',
							id:'PDLISysFlagUF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLISysFlagUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLISysFlagUF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 修改时弹出窗口 */
	var winUpdateLabelItm = new Ext.Window({
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
					items : WinFormUpdateLabelItm,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'updatesave_btn_LabelItm',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('updatesave_btn_LabelItm'),
						handler : function () {
							/*var tempValue = Ext.getCmp("form-update-LabelItm").getForm().findField("PDLIGenDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}*/
							var _record = gridLinkLabel.getSelectionModel().getSelected();
							if ((_record.get('PDLLabelDr')=="症状")||(_record.get('PDLLabelDr')=="诊断"))
							{
								var PDLIKeyWord = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIKeyWord").getValue()
								if(PDLIKeyWord=="")
								{
									Ext.Msg.show({ title : '提示', msg : '关联项目不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}	
							}
							else		
							{
								var PDLIGenDr = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIGenDr").getValue()
								if(PDLIGenDr=="")
								{
									Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}
							}
			   			 	if(WinFormUpdateLabelItm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}								
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinFormUpdateLabelItm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL_LabelItm,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdateLabelItm.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("gridLabelItm", QUERY_ACTION_URL_LabelItm, myrowid)
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
							winUpdateLabelItm.hide();
						}
					}],
					listeners : {
						"show" : function() {
							
							var _record = gridLinkLabel.getSelectionModel().getSelected();
					 		
							
							if ((_record.get('PDLLabelDr')=="症状")||(_record.get('PDLLabelDr')=="诊断"))
							{
								
								ShowComponent("form-update-LabelItm","PDLIKeyWordUF") //关联项目
								
								HideComponent("form-update-LabelItm","PDLISysFlagUF")
								//HideComponent("form-update-LabelItm","PDLIIdUF")
								HideComponent("form-update-LabelItm","PDLIGenDrUF")
								HideComponent("form-update-LabelItm","PDLIValUF")
								HideComponent("form-update-LabelItm","PDLIOperatorUF")
								HideComponent("form-update-LabelItm","PDLIResultTextUF")
								HideComponent("form-update-LabelItm","PDLIRelationUF")
								HideComponent("form-update-LabelItm","PDLISysFlagUF")
								
								
							}
							
							
							if ((_record.get('PDLLabelDr')=="检验")||(_record.get('PDLLabelDr')=="检查"))		
							{
							
								HideComponent("form-update-LabelItm","PDLIKeyWordUF") //关联项目
								ShowComponent("form-update-LabelItm","PDLISysFlagUF")
								//ShowComponent("form-update-LabelItm","PDLIIdUF")
								ShowComponent("form-update-LabelItm","PDLIGenDrUF")
								ShowComponent("form-update-LabelItm","PDLIValUF")
								ShowComponent("form-update-LabelItm","PDLIOperatorUF")
								ShowComponent("form-update-LabelItm","PDLIResultTextUF")
								ShowComponent("form-update-LabelItm","PDLIRelationUF")
								ShowComponent("form-update-LabelItm","PDLISysFlagUF")
								
								if (_record.get('PDLLabelDr')=="检验")
								{
									GenDRStore.baseParams = {
										libcode :'LAB'
									};
								}
								if (_record.get('PDLLabelDr')=="检查")
								{
									GenDRStore.baseParams = {
										libcode :'CHECK'
									};
								}
							}
							
						
							
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
		/** 创建添加Form表单 */
	var WinFormLabelItm = new Ext.form.FormPanel({
				id : 'form-save-LabelItm',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDLIRowId',mapping:'PDLIRowId',type:'string'},
                                         {name: 'PDLIId',mapping:'PDLIId',type:'string'},         
                                         {name: 'PDLIGenDr',mapping:'PDLIGenDr',type:'string'},
                                         {name: 'PDLIVal',mapping:'PDLIVal',type:'string'},
                                         {name: 'PDLIOperator',mapping:'PDLIOperator',type:'string'},
                                         {name: 'PDLIKeyWord',mapping:'PDLIKeyWord',type:'string'},
                                         {name: 'PDLIResultText',mapping:'PDLIResultText',type:'string'},
                                         {name: 'PDLIRelation',mapping:'PDLIRelation',type:'string'},
                                         {name: 'PDLISysFlag',mapping:'PDLISysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDLIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDLIRowId'
						}, {
							id : 'PDLIIdF',
							xtype : 'textfield',
							fieldLabel : 'PDLIId',
							name : 'PDLIId',
							hideLabel : 'True',
							hidden : true
						},
						//PDLIGenDrComboxLabelItm,
						{
						xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '通用名',
							name:'PDLIGenDr',
							hiddenName : 'PDLIGenDr',
							id:'PDLIGenDrF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIGenDrF')),
							store :GenDRStore,
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId'
						},
						{	
							fieldLabel:'检验值',
							xtype:'numberfield',
							name : 'PDLIVal',
							id:'PDLIValF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIValF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIValF'))
   						
   						},{
							fieldLabel:'运算符',
							xtype : 'combo',
							name : 'PDLIOperator',
							hiddenName:'PDLIOperator',  ///id和hiddenName不能相同
							id:'PDLIOperatorF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIOperatorF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIOperatorF')),
   							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['>','大于'],
									      ['<','小于'],
									      ['=','等于'],
									      ['!>','不大于'],
									      ['!<','不小于'],
									      ['<>','不等于']
								     ]
							})
						
						},{
							fieldLabel:'结果',
							xtype : 'combo',
							name : 'PDLIResultText',
							hiddenName:'PDLIResultText',
							id:'PDLIResultTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIResultTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIResultTextF')),
   							mode : 'local',
							triggerAction : 'all',// query
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
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							name:'PDLIKeyWord',
							fieldLabel : '关联项目',
							hiddenName : 'PDLIKeyWord',
							id:'PDLIKeyWordF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIKeyWordF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIKeyWordF')),
							store :keywordds,
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
							
   						},{
							fieldLabel:'逻辑关系',
							xtype : 'combo',
							name : 'PDLIRelation',
							hiddenName : 'PDLIRelation',
							id:'PDLIRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLIRelationF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLIRelationF')),
   							mode : 'local',
							triggerAction : 'all',// query
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['O','Or'],
									      ['A','And']
								     ]
							})
						
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDLISysFlag',
							id:'PDLISysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDLISysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDLISysFlagF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 增加时弹出窗口 */
	var winLabelItm = new Ext.Window({
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
					items : WinFormLabelItm,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn_LabelItm',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_LabelItm'),
						handler : saveDataLabelItm=function () {
							/*var tempValue = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIGenDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}*/
							
							if (!gridLinkLabel.selModel.hasSelection()) {
								Ext.Msg.show({ title : '提示', msg : '请先选择推导目录!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
							}
							var _record = gridLinkLabel.getSelectionModel().getSelected();
							if ((_record.get('PDLLabelDr')=="症状")||(_record.get('PDLLabelDr')=="诊断"))
							{
								var PDLIKeyWord = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIKeyWord").getValue()
								if(PDLIKeyWord=="")
								{
									Ext.Msg.show({ title : '提示', msg : '关联项目不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}	
							}
							else		
							{
								var PDLIGenDr = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIGenDr").getValue()
								if(PDLIGenDr=="")
								{
									Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}
							}
							
							
			   			 	if(WinFormLabelItm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
								 return;}
							WinFormLabelItm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LabelItm,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											winLabelItm.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															//var totalnum=gridLabelItm.getStore().getTotalCount();
															//var myrowid = action.result.id;
															gridLabelItm.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																				//,rowid : myrowid
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
						id:'resave_btn_LabelItm',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn_LabelItm'),
						handler : function () {
							/*var tempValue = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIGenDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}*/
							var _record = gridLinkLabel.getSelectionModel().getSelected();
							if ((_record.get('PDLLabelDr')=="症状")||(_record.get('PDLLabelDr')=="诊断"))
							{
								var PDLIKeyWord = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIKeyWord").getValue()
								if(PDLIKeyWord=="")
								{
									Ext.Msg.show({ title : '提示', msg : '关联项目不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}	
							}
							else		
							{
								var PDLIGenDr = Ext.getCmp("form-save-LabelItm").getForm().findField("PDLIGenDr").getValue()
								if(PDLIGenDr=="")
								{
									Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          				return;	
								}
							}
			   			 	if(WinFormLabelItm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
					 		var _recordLinkLabel = gridLinkLabel.getSelectionModel().getSelected();
							Ext.getCmp("PDLIIdF").setValue(_recordLinkLabel.get('PDLRowId'));
							
							
								WinFormLabelItm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_LabelItm,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save-LabelItm").getForm().reset();							
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var myrowid = action.result.id;
															var totalnum=gridLabelItm.getStore().getTotalCount();
															gridLabelItm.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
																				//rowid : myrowid
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
							winLabelItm.hide();
						}
					}],
					listeners : {
						"show" : function() {
							var _record = gridLinkLabel.getSelectionModel().getSelected();
					 		
							
							if ((_record.get('PDLLabelDr')=="症状")||(_record.get('PDLLabelDr')=="诊断"))
							{
								ShowComponent("form-save-LabelItm","PDLIKeyWordF")
								//HideComponent("form-save-LabelItm","PDLIIdF")
								HideComponent("form-save-LabelItm","PDLIGenDrF")
								HideComponent("form-save-LabelItm","PDLIValF")
								HideComponent("form-save-LabelItm","PDLIOperatorF")
								HideComponent("form-save-LabelItm","PDLIResultTextF")
								HideComponent("form-save-LabelItm","PDLIRelationF")
								HideComponent("form-save-LabelItm","PDLISysFlagF")
								
								
							}
							
							if ((_record.get('PDLLabelDr')=="检验")||(_record.get('PDLLabelDr')=="检查"))		
							{
								HideComponent("form-save-LabelItm","PDLIKeyWordF")
								
								//ShowComponent("form-save-LabelItm","PDLIIdF")
								ShowComponent("form-save-LabelItm","PDLIGenDrF")
								ShowComponent("form-save-LabelItm","PDLIValF")
								ShowComponent("form-save-LabelItm","PDLIOperatorF")
								ShowComponent("form-save-LabelItm","PDLIResultTextF")
								ShowComponent("form-save-LabelItm","PDLIRelationF")
								ShowComponent("form-save-LabelItm","PDLISysFlagF")
								
								if (_record.get('PDLLabelDr')=="检验")
								{
									GenDRStore.baseParams = {
										libcode :'LAB'
									};
								}
								if (_record.get('PDLLabelDr')=="检查")
								{
									GenDRStore.baseParams = {
										libcode :'CHECK'
									};
								}
							}
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwinLabelItm = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn_LabelItm',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_LabelItm'),
				handler : AddDataLabelItm=function () {
					
					
					if (selectNode!="")
					{
						if (gridLinkLabel.selModel.hasSelection()) {
							
							winLabelItm.setTitle('添加');
							winLabelItm.setIconClass('icon-add');
							winLabelItm.show();
							WinFormLabelItm.getForm().reset();
							var _recordLinkLabel = gridLinkLabel.getSelectionModel().getSelected();
							Ext.getCmp("PDLIIdF").setValue( _recordLinkLabel.get('PDLRowId'));
							keywordds.baseParams = {
								labeldr :  _recordLinkLabel.get('PDLLabelDrID')
							};
							
						}else {
				        	Ext.Msg.show({
											title : '提示',
											msg : '请先选择推导目录!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
					}
				            
						
					}
					else
					{
						
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwinLabelItm = new Ext.Toolbar.Button({
				text : '修改',
				iconCls : 'icon-update',
				id:'update_btn_LabelItm',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_LabelItm'),
				handler : UpdateDataLabelItm=function () {
					
					if (selectNode!="")
					{
						if (gridLinkLabel.selModel.hasSelection()) {
							if (gridLabelItm.selModel.hasSelection()) {
								var _record = gridLabelItm.getSelectionModel().getSelected();
								winUpdateLabelItm.show('');
								keywordds.baseParams = {
									labeldr :  _recordLinkLabel.get('PDLLabelDrID')
								};
								Ext.getCmp("form-update-LabelItm").getForm().reset();
					            Ext.getCmp("form-update-LabelItm").getForm().load({
					                url : OPEN_ACTION_URL_LabelItm + '&id=' + _record.get('PDLIRowId'),
					                success : function(form,action) {
					                },
					                failure : function(form,action) {
					                	Ext.Msg.alert('编辑', '载入失败');
					                }
					            });	
					            
					            var _recordLinkLabel = gridLinkLabel.getSelectionModel().getSelected();
								Ext.getCmp("PDLIIdUF").setValue( _recordLinkLabel.get('PDLRowId'));
							
					        } else {
					        	Ext.Msg.show({
												title : '提示',
												msg : '请选择需要修改的行!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
					            
					        }
						}else {
				        	Ext.Msg.show({
											title : '提示',
											msg : '请先选择推导目录!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
						}
					}
					else
					{
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				          
					}
				}
			});
	/** gridLabelItm数据存储 */
	var dsLabelItm = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL_LabelItm }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PDLIRowId',
									mapping : 'PDLIRowId',
									type : 'string'
								}, {
									name : 'PDLIId',
									mapping : 'PDLIId',
									type : 'string'
								}, {
									name : 'PDLIGenDr',
									mapping : 'PDLIGenDr',
									type : 'string'
								},{
									name : 'PDLIVal',
									mapping : 'PDLIVal',
									type : 'string'
								},{
									name : 'PDLIOperator',
									mapping : 'PDLIOperator',
									type : 'string'
								},{
									name : 'PDLIResultText',
									mapping : 'PDLIResultText',
									type : 'string'
								},{
									name : 'PDLIKeyWord',
									mapping : 'PDLIKeyWord',
									type : 'string'
								},{
									name : 'PDLIRelation',
									mapping : 'PDLIRelation',
									type : 'string'
								},{
									name : 'PDLISysFlag',
									mapping : 'PDLISysFlag',
									type : 'string'
								},{
									name : 'PHEGDesc',
									mapping : 'PHEGDesc',
									type : 'string'
								},{
									name : 'PHKWDesc',
									mapping : 'PHKWDesc',
									type : 'string'
								}// 列的映射
						])
			});
	

	/** gridLabelItm分页工具条 */
	var pagingLabelItm = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : dsLabelItm,
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
	var tbbuttonLabelItm = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwinLabelItm, '-', btnEditwinLabelItm, '-', btnDelLabelItm]
		});
	/** 搜索按钮 */
	var btnSearchLabelItm = new Ext.Button({
				id : 'btnSearchLabelItm',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchLabelItm'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if (selectNode!="")
					{
						
				          	if (gridLinkLabel.selModel.hasSelection()) {
								var _record = gridLinkLabel.getSelectionModel().getSelected();
								gridLabelItm.getStore().baseParams={			
										pdliid :_record.get('PDLRowId')
								};
								gridLabelItm.getStore().load({
									params : {
												start : 0,
												limit : pagesize_pop
											}
									});
												
					        } else {
					        	Ext.Msg.show({
												title : '提示',
												msg : '请选择推导目录!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
					            
					        }  
						
					}
					else
					{
						Ext.Msg.show({
							title : '提示',
							msg : '请先选择左侧诊断逻辑推导目录!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
						
					
					}
				}
			});
	/** 重置按钮 */
	var btnRefreshLabelItm = new Ext.Button({
				id : 'btnRefreshLabelItm',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshLabelItm'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : RefreshLabelItm=function() {
					if (gridLinkLabel.selModel.hasSelection()) {	
							var _record = gridLinkLabel.getSelectionModel().getSelected();
							gridLabelItm.getStore().baseParams={
								pdliid :_record.get('PDLRowId')
							};
							gridLabelItm.getStore().load({
										params : {
													start : 0,
													limit : pagesize_pop
												}
										});
								
						}else {
				        	Ext.Msg.show({
											title : '提示',
											msg : '请选择推导目录!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
				            
				        }
				}
		});
	/** 搜索工具条 */
	var tbLabelItm = new Ext.Toolbar({
				id : 'tbLabelItm',
				items : [/*'指南目录', {
							hiddenName : 'PDLLabelDr',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('Textlabel'),
							id : 'Textlabel',
   							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PGLDesc',
							valuField : 'PGLRowId'
							
						}, '-',*/ 
						///btnSearchLabelItm, '-', btnRefreshLabelItm, '->'
				],
				listeners : {
					render : function() {
						tbbuttonLabelItm.render(gridLabelItm.tbar);
					}
				}
			});
	/** 创建grid */
	var gridLabelItm = new Ext.grid.GridPanel({
				id : 'gridLabelItm',
				region : 'center',
				closable : true,
				store : dsLabelItm,
				frame : true,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PDLIRowId',
							sortable : true,
							width:90,
							
							dataIndex : 'PDLIRowId',
							hidden : true
						/*}, {
							header : '推导目录ID',
							sortable : true,
							width:80,
							dataIndex : 'PDLIId',
							hidden : true
						}, {
							header : '通用名',
							sortable : true,
							width:80,
							dataIndex : 'PDLIGenDr',
							hidden : true*/
							
						}, {
							header : '通用名',
							sortable : true,
							width:130,
							dataIndex : 'PHEGDesc'
						}, {
							header : '检验值',
							sortable : true,
							width:90,
							dataIndex : 'PDLIVal'
						
						},{
							header : '运算符',
							sortable : true,
							width:90,
							dataIndex : 'PDLIOperator',
							renderer:function(value)
            				{
			            		if (value==">"){ return "大于"; }
			            		if (value=="<"){return "小于";}
			            		if (value=="="){ return "等于";}
			            		if (value=="!>"){return "不大于";}
			            		if (value=="!<"){return "不小于";}
			            		if (value=="<>"){return "不等于";}			            		
			            	}
			            },{
							header : '结果',
							sortable : true,
							width:80,
							dataIndex : 'PDLIResultText',
							renderer:function(value)
            				{
            					if (value=="H"){  return "高";  }
			            		if (value=="L"){  return "低"; }
			            		if (value=="N"){  return "正常"; }
			            		if (value=="I"){  return "包含"; }
			            		if (value=="NT"){  return "阴性"; }
			            		if (value=="PT"){  return "阳性"; }
			            	}
			          
						 },{
							header : '关联项目',
							width:130,
							sortable : true,
							dataIndex : 'PHKWDesc'
			            
			            },{
							header : '逻辑',
							width:50,
							sortable : true,
							dataIndex : 'PDLIRelation',
							renderer:function(value)
            				{
			            		if (value=="O"){  return "Or";  }
			            		if (value=="A"){  return "And"; }
			            	}
						},{
							header : '是否系统标识',
							sortable : true,
							width:80,
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PDLISysFlag'
						}],
				stripeRows : true,
				title : '推导目录明细',
				/*viewConfig : {
					forceFit : true
				},*/
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingLabelItm,
				tbar : tbLabelItm,
				stateId : 'gridLabelItm'
			});
	/** gridLabelItm双击事件 */
	gridLabelItm.on("rowdblclick", function(gridLabelItm, rowIndex, e) {
				var _record = gridLabelItm.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
					winUpdateLabelItm.show();
					Ext.getCmp("form-update-LabelItm").getForm().reset();
		            Ext.getCmp("form-update-LabelItm").getForm().load({
		                url : OPEN_ACTION_URL_LabelItm + '&id=' + _record.get('PDLIRowId'),
		                success : function(form,action) {
		                
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});	
			
	/*************************诊断目录明细表 end************************************/	
			
			
			
			
			
			
		
	/*************************代码自动生成配置开始************************************/
	var AutoCodeForm = new Ext.form.FormPanel({
		id:'AutoCodeForm',
		labelAlign:'right',
		labelWidth:100,
		frame :true,
		defaultType : 'textfield',
		items:[{
            boxLabel :'手动输入代码',
            name: 'AutoCode',
            id:'AutoCodeF',
            xtype:'checkbox',
            width: 'auto',
            checked:true,
			inputValue : true?'Y':'N',
			listeners:{
				'check':function(checked){
					   if(checked.checked){
							Ext.getCmp("CodeLenF").setDisabled(true);
							Ext.getCmp("StartCodeF").setDisabled(true);

						}else{
							Ext.getCmp("CodeLenF").setDisabled(false);
							Ext.getCmp("StartCodeF").setDisabled(false);

						}			
				}
			}
            
        },{
            fieldLabel : '<font color=red>*</font>代码长度',
            name: 'CodeLen',
            xtype:'numberfield',
            id:'CodeLenF',
            disabled:true
        },{
            fieldLabel : '<font color=red>*</font>代码起始字符',
            name: 'StartCode',
            id:'StartCodeF',
            disabled:true,
            regex:/^[a-zA-Z]+$/,
			regexText : '只能输入英文字符'
        }]
	});
	/****代码生成规则窗口***/
	var AutoCodeWin=new Ext.Window({
		title:'代码生成规则',
		width:340,
        height:240,
		layout:'fit',
		plain : true,//true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign:'center',
		closable:false,
	 	closeAction:'hide',   
		items: [AutoCodeForm],
		buttons:[{
				text:'保存',
				iconCls : 'icon-save',
				handler:function(){
					if(AutoCodeForm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
					var AutoCode=Ext.getCmp('AutoCodeF').getValue();
					var CodeLen=Ext.getCmp('CodeLenF').getValue();
					var StartCode=Ext.getCmp('StartCodeF').getValue();
					if (AutoCode!=true)
					{
						if (CodeLen=="") {
		    				Ext.Msg.show({ title : '提示', msg : '代码长度不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
		    			}
		    			if (StartCode=="") {
		    				Ext.Msg.show({ title : '提示', msg : '代码起始字符不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		          			return;
		    			}
					}
					//alert(AutoCode+"^"+CodeLen+"^"+StartCode)
					var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","SaveAutoCode",AutoCode,CodeLen,StartCode);
					if(saveflag==1)
					{
						Ext.Msg.show({ title : '提示', msg : '保存成功!', minWidth : 200, icon : Ext.Msg.INFO, buttons : Ext.Msg.OK });
						AutoCodeWin.hide();
					}
					else if (saveflag==2)
				    {
						Ext.Msg.show({ title : '提示', msg : '代码起始字符的长度要小于代码长度!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
					}
					else
					{
						Ext.Msg.show({ title : '提示', msg : '保存失败!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
					}
			}
		},{
			text:'关闭',
			iconCls : 'icon-close',
			handler:function(){
		  		Ext.getCmp('AutoCodeForm').getForm().reset();
				AutoCodeWin.hide();
			}
		}] 
	});

	/** 配置按钮 */
	var btnConfig = new Ext.Toolbar.Button({
		text : '配置',
		tooltip : '配置自动生成代码规则',
		iconCls : 'icon-config',
		id:'btnConfig',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnConfig'),
		handler : showNationalData=function () {
			AutoCodeWin.show();
			var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","AutoCode");
			var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","CodeLen");
			var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","ShowAutoCode","StartCode");
			if(AutoCode=="") {AutoCode=true}
			Ext.getCmp("AutoCodeF").setValue(AutoCode);
			Ext.getCmp("CodeLenF").setValue(CodeLen);
			Ext.getCmp("StartCodeF").setValue(StartCode);
		},
		scope : this
	});
	/*************************代码自动生成配置结束************************************/
	
	
	
	
	 		
	/**********************推导目录提示表 start*****************************/		
			
			
			
	
	var QUERY_ACTION_URL_DisLabelPrompt = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassQuery=GetList";
	var SAVE_ACTION_URL_DisLabelPrompt = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLabelPrompt";
	var OPEN_ACTION_URL_DisLabelPrompt = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassMethod=OpenData";
	var DELETE_ACTION_URL_DisLabelPrompt = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLabelPrompt&pClassMethod=DeleteData";
	
	/** 删除按钮 */
	var btnDelDisLabelPrompt = new Ext.Toolbar.Button({
					text : '删除',
					iconCls : 'icon-delete',
					id:'del_btn_DisLabelPrompt',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_DisLabelPrompt'),
					handler : DelDataDisLabelPrompt=function () {
						
							
							if (gridDisLabelPrompt.selModel.hasSelection()) {
									Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
										if (btn == 'yes') {
											Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
											var gsm = gridDisLabelPrompt.getSelectionModel();// 获取选择列
											var rows = gsm.getSelections();// 根据选择列获取到所有的行
											
											Ext.Ajax.request({
												url : DELETE_ACTION_URL_DisLabelPrompt,
												method : 'POST',
												params : {
													'id' : rows[0].get('PDPRowId')
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
																	
																	Ext.BDP.FunLib.DelForTruePage(gridDisLabelPrompt,pagesize_pop);
																	
																	
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
	
	var PDPidds=new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : ID_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'RowId',mapping:'RowId'},
										{name:'Desc',mapping:'Desc'} ])
								})		
								
	/** 创建修改Form表单 */
	var WinFormUpdateDisLabelPrompt = new Ext.form.FormPanel({
				id : 'form-update-DisLabelPrompt',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDPRowId',mapping:'PDPRowId',type:'string'},
                                         {name: 'PDPPrompt',mapping:'PDPPrompt',type:'string'},         
                                         {name: 'PDPLastId',mapping:'PDPLastId',type:'string'},
                                         {name: 'PDPLabelDr',mapping:'PDPLabelDr',type:'string'},
                                         {name: 'PDPPromptVal',mapping:'PDPPromptVal',type:'string'},
                                         {name: 'PDPSysFlag',mapping:'PDPSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							
							fieldLabel : 'PDPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDPRowId'
						}, {
							id : 'PDPLastIdUF',
							xtype : 'textfield',
							hideLabel : 'True',
							hidden : true,
							fieldLabel : 'PDPLastId',
							name : 'PDPLastId'
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联目录',
							name:'PDPLabelDr',
							hiddenName : 'PDPLabelDr',
							id:'PDPLabelDrUF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPLabelDrUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPLabelDrUF')),
							store :new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PGLDesc',
							valueField : 'PGLRowId',
							listeners : {
								'select' : function(combo, record, index) {
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrUF').getValue()
									};
									Ext.getCmp("PDPPromptUF").reset();
									
								},
								'collapse':function(){ //当下拉列表收起的时候触发
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrUF').getValue()
									};
									Ext.getCmp("PDPPromptUF").reset();
									
								},
								'keyup':function(){
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrUF').getValue()
									};
									Ext.getCmp("PDPPromptUF").reset();
								}
							}
					
						}, {	
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联项目',
							name:'PDPPrompt',
							hiddenName : 'PDPPrompt',
							id:'PDPPromptUF',	
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPPromptUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPPromptUF')),
							store :PDPidds,
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
						
						
						},{
							
							id : 'PDPPromptValUF',
							xtype : 'textfield',
							fieldLabel : '项目值',
							name : 'PDPPromptVal',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPPromptValUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPPromptValUF'))
							
						},{
							
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDPSysFlag',
							id:'PDPSysFlagUF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPSysFlagUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPSysFlagUF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 修改时弹出窗口 */
	var winUpdateDisLabelPrompt = new Ext.Window({
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
					items : WinFormUpdateDisLabelPrompt,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'updatesave_btn_DisLabelPrompt',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('updatesave_btn_DisLabelPrompt'),
						handler : function () {
							var tempValue = Ext.getCmp("form-update-DisLabelPrompt").getForm().findField("PDPLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '关联目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if(WinFormUpdateDisLabelPrompt.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}								
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										
										
										
										Ext.getCmp('PDPLastIdUF').setValue(selectNode)
										WinFormUpdateDisLabelPrompt.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL_DisLabelPrompt,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdateDisLabelPrompt.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("gridDisLabelPrompt", QUERY_ACTION_URL_DisLabelPrompt, myrowid)
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
							winUpdateDisLabelPrompt.hide();
						}
					}],
					listeners : {
						"show" : function() {
							
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
		/** 创建添加Form表单 */
	var WinFormDisLabelPrompt = new Ext.form.FormPanel({
				id : 'form-save-DisLabelPrompt',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDPRowId',mapping:'PDPRowId',type:'string'},
                                         {name: 'PDPPrompt',mapping:'PDPPrompt',type:'string'},         
                                         {name: 'PDPLastId',mapping:'PDPLastId',type:'string'},
                                         {name: 'PDPLabelDr',mapping:'PDPLabelDr',type:'string'},
                                         {name: 'PDPPromptVal',mapping:'PDPPromptVal',type:'string'},
                                         {name: 'PDPSysFlag',mapping:'PDPSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDPRowId'
						}, {
							id : 'PDPLastIdF',
							xtype : 'textfield',
							hideLabel : 'True',
							hidden : true,
							fieldLabel : 'PDPLastId',
							name : 'PDPLastId'
							
							
   						},
   						{
   							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联目录',
							name:'PDPLabelDr',
							allowBlank:false,
							hiddenName : 'PDPLabelDr',
							id:'PDPLabelDrF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPLabelDrF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPLabelDrF')),
							store :new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'PGLDesc',
							valueField : 'PGLRowId',
							listeners : {
								'select' : function(combo, record, index) {
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrF').getValue()
									};
									Ext.getCmp("PDPPromptF").reset();
									
								},
								'collapse':function(){ //当下拉列表收起的时候触发
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrF').getValue()
									};
									Ext.getCmp("PDPPromptF").reset();
									
								},
								'keyup':function(){
									PDPidds.baseParams = {
										labeldr : Ext.getCmp('PDPLabelDrF').getValue()
									};
									Ext.getCmp("PDPPromptF").reset();
								}
							}
							
							
   							
   						}
   						,{
   							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联项目',
							name:'PDPPrompt',
							hiddenName : 'PDPPrompt',
							id:'PDPPromptF',	
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPPromptF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPPromptF')),
							store :PDPidds,
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
							
							
						},
						{	
							id : 'PDPPromptValF',
							xtype : 'textfield',
							fieldLabel : '项目值',
							name : 'PDPPromptVal',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPPromptValF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPPromptValF'))
						},{
							
							
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDPSysFlag',
							id:'PDPSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDPSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDPSysFlagF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 增加时弹出窗口 */
	var winDisLabelPrompt = new Ext.Window({
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
					items : WinFormDisLabelPrompt,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn_DisLabelPrompt',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_DisLabelPrompt'),
						handler : saveDataDisLabelPrompt=function () {
							var tempValue = Ext.getCmp("form-save-DisLabelPrompt").getForm().findField("PDPLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '关联目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
							
							
							if(WinFormDisLabelPrompt.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
							Ext.getCmp('PDPLastIdF').setValue(selectNode)
							WinFormDisLabelPrompt.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_DisLabelPrompt,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											winDisLabelPrompt.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															//var totalnum=gridDisLabelPrompt.getStore().getTotalCount();
															//var myrowid = action.result.id;
															gridDisLabelPrompt.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
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
						id:'resave_btn_DisLabelPrompt',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn_DisLabelPrompt'),
						handler : function () {
							var tempValue = Ext.getCmp("form-save-DisLabelPrompt").getForm().findField("PDPLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '指南目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			Ext.getCmp('PDPLastIdF').setValue(selectNode)
			    			if(WinFormDisLabelPrompt.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
								WinFormDisLabelPrompt.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_DisLabelPrompt,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save-DisLabelPrompt").getForm().reset();							
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															var myrowid = action.result.id;
															var totalnum=gridDisLabelPrompt.getStore().getTotalCount();
															gridDisLabelPrompt.getStore().load({
																		params : {
																				start : 0,
																				limit : pagesize_pop
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
							winDisLabelPrompt.hide();
						}
					}],
					listeners : {
						"show" : function() {
							
						},
						"hide" : function(){
							Ext.BDP.FunLib.Component.FromHideClearFlag;   				
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwinDisLabelPrompt = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn_DisLabelPrompt',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_DisLabelPrompt'),
				handler : function () {
					
					
						if (selectNode!="") {
					
							winDisLabelPrompt.setTitle('添加');
							winDisLabelPrompt.setIconClass('icon-add');
							winDisLabelPrompt.show();
							WinFormDisLabelPrompt.getForm().reset();
							PDPidds.baseParams = {
									labeldr :""
							};
							Ext.getCmp('PDPLastIdF').setValue(selectNode)
						}else {
				        	Ext.Msg.show({
											title : '提示',
											msg : '请先选择诊断逻辑推导目录!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
					}
					
				},
				scope : this
			});
			
	loadFormDataDisLabelPrompt=function()
	{
		var _record = gridDisLabelPrompt.getSelectionModel().getSelected();
		if (!_record) {
            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
        } else {
			winUpdateDisLabelPrompt.show();
			//alert(_record.get('PDPLabelDr'))
			PDPidds.baseParams = {
					labeldr : _record.get('PDPLabelDr')
			};
			Ext.getCmp("form-update-DisLabelPrompt").getForm().reset();
            Ext.getCmp("form-update-DisLabelPrompt").getForm().load({
                url : OPEN_ACTION_URL_DisLabelPrompt + '&id=' + _record.get('PDPRowId'),
                success : function(form,action) {
                	Ext.getCmp('PDPLastIdUF').setValue(selectNode)
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
        }
	}
	/** 修改按钮 */
	var btnEditwinDisLabelPrompt = new Ext.Toolbar.Button({
				text : '修改',
				iconCls : 'icon-update',
				id:'update_btn_DisLabelPrompt',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_DisLabelPrompt'),
				handler :function () {
						loadFormDataDisLabelPrompt()
				}
			});
	/** gridDisLabelPrompt数据存储 */
	var dsDisLabelPrompt = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL_DisLabelPrompt }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PDPRowId',
									mapping : 'PDPRowId',
									type : 'string'
								}, {
									name : 'PDPPrompt',
									mapping : 'PDPPrompt',
									type : 'string'
								}, {
									name : 'PDPLastId',
									mapping : 'PDPLastId',
									type : 'string'
								},{
									name : 'PDTDesc',
									mapping : 'PDTDesc',
									type : 'string'
								},{
									name : 'PDPPromptVal',
									mapping : 'PDPPromptVal',
									type : 'string'
								}, {
									name : 'PDPLabelDr',
									mapping : 'PDPLabelDr',
									type : 'string'
								},{
									name : 'PDPLabelDrDesc',
									mapping : 'PDPLabelDrDesc',
									type : 'string'
								},{
									name : 'PDPSysFlag',
									mapping : 'PDPSysFlag',
									type : 'string'
								
								
								},{
									name : 'PDPPromptDesc',
									mapping : 'PDPPromptDesc',
									type : 'string'
								}// 列的映射
						])
			});
	

	/** gridDisLabelPrompt分页工具条 */
	var pagingDisLabelPrompt = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : dsDisLabelPrompt,
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
		var tbbuttonDisLabelPrompt = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwinDisLabelPrompt, '-', btnEditwinDisLabelPrompt, '-', btnDelDisLabelPrompt]
		});
	/** 搜索按钮 */
	var btnSearchDisLabelPrompt = new Ext.Button({
				id : 'btnSearchDisLabelPrompt',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchDisLabelPrompt'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
								gridDisLabelPrompt.getStore().baseParams={			
										lastid :selectNode,
										labeldr : Ext.getCmp('TextPDPLabelDr').getValue()
								};
								gridDisLabelPrompt.getStore().load({
									params : {
												start : 0,
												limit : pagesize_pop
											}
									});
						
					
				}
			});
	/** 重置按钮 */
	var btnRefreshDisLabelPrompt = new Ext.Button({
				id : 'btnRefreshDisLabelPrompt',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshDisLabelPrompt'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : RefreshDisLabelPrompt=function() {
							Ext.getCmp('TextPDPLabelDr').reset()
					
							gridDisLabelPrompt.getStore().baseParams={
								lastid :selectNode,
								labeldr : ""
							};
							gridDisLabelPrompt.getStore().load({
										params : {
													start : 0,
													limit : pagesize_pop
												}
										});
								
						
				}
		});
	/** 搜索工具条 */
	var tbLabelPrompt = new Ext.Toolbar({
				id : 'tbLabelPrompt',
				items : ['关联目录', {
							hiddenName : 'PDPLabelDr',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextPDPLabelDr'),
							id : 'TextPDPLabelDr',
   							store : new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : Label_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PGLRowId',mapping:'PGLRowId'},
										{name:'PGLDesc',mapping:'PGLDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PGLDesc',
							valueField : 'PGLRowId'
							
						}, '-',
						btnSearchDisLabelPrompt, '-', btnRefreshDisLabelPrompt, '->'
				],
				listeners : {
					render : function() {
						tbbuttonDisLabelPrompt.render(gridDisLabelPrompt.tbar);
					}
				}
			});
	/** 创建grid */
	var gridDisLabelPrompt = new Ext.grid.GridPanel({
				id : 'gridDisLabelPrompt',
				region : 'center',
				closable : true,
				store : dsDisLabelPrompt,
				frame : true,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PDPRowId',
							sortable : true,
							dataIndex : 'PDPRowId',
							hidden : true
						
						}, {
							header : '诊断逻辑推导目录id',
							hidden:true,
							sortable : true,
							dataIndex : 'PDPLastId'
						}, {
							header : '诊断逻辑推导目录',
							sortable : true,
							hidden:true,
							dataIndex : 'PDTDesc'
			             },{
							header : '关联目录id',
							sortable : true,
							hidden:true,
							dataIndex : 'PDPLabelDr'
						 },{
							header : '关联目录',
							sortable : true,
							dataIndex : 'PDPLabelDrDesc'
						}, {
							header : '关联项目id',
							sortable : true,
							hidden:true,
							dataIndex : 'PDPPrompt'
						}, {
							header : '关联项目',
							sortable : true,
							dataIndex : 'PDPPromptDesc'
						
						 },{
							header : '结果',
							sortable : true,
							dataIndex : 'PDPPromptVal'
						},{
							header : '是否系统标识',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PDPSysFlag'
						}],
				stripeRows : true,
				title : '推导目录提示表',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingDisLabelPrompt,
				tbar : tbLabelPrompt,  ////[btnAddwinDisLabelPrompt, '-', btnEditwinDisLabelPrompt, '-', btnDelDisLabelPrompt],
				stateId : 'gridDisLabelPrompt'
			});
			
	
	/** gridDisLabelPrompt双击事件 */
	gridDisLabelPrompt.on("rowdblclick", function(gridDisLabelPrompt, rowIndex, e) {
		
		
		      loadFormDataDisLabelPrompt()  
		});	
	
	var DisLabelPrompt_win = new Ext.Window({
					iconCls : 'icon-DP',
					width : Ext.getBody().getWidth()*0.7,
					height : 500,//Ext.getBody().getHeight()*.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [gridDisLabelPrompt],
					listeners : {
						"show" : function(){
													
						},
						"hide" : function(){
							
						},
						"close" : function(){
						}
					}
				});
	/** 推导目录提示表按钮 */
	var btnDisLabelPrompt = new Ext.Toolbar.Button({
				text : '推导目录提示表',
				tooltip : '推导目录提示表',
				iconCls : 'icon-DP',
				id:'btnGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnGuide'),
				handler : function() {
					if (selectNode!=""){
						Ext.getCmp('TextPDPLabelDr').reset()
						gridDisLabelPrompt.getStore().removeAll();
						gridDisLabelPrompt.getStore().baseParams={
							lastid:selectNode,
							labeldr:""
						};
						gridDisLabelPrompt.getStore().load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						
						DisLabelPrompt_win.setTitle('诊断逻辑推导目录——'+selectNodeDesc);
						DisLabelPrompt_win.show();
						
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请先选择诊断逻辑推导目录!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						
					}
				}
			});
			
	/*************************推导目录提示表 end************************************/	
			
	
	
	
	
	
	
	
	
	
	
	
	
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if (treePanel.getSelectionModel().getSelectedNode()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : treePanel.getSelectionModel().getSelectedNode().id
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
												Ext.getCmp('FindTreeText').reset();
												hiddenPkgs = [];
												
												treePanel.loadTreeOther();
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
						msg : '请选择需要删除的分类!',
						icon : Ext.Msg.WARNING,
						buttons : Ext.Msg.OK
					});
				}
			}
	});
	var comboTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "ParentID",
			dataUrl: TREE_COMBO_URL
		});
    var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'treeCombox',
         width : 180,  
         fieldLabel:"上级分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('treeCombox'),
         name:'PDTLastRowid',
         hiddenName : 'PDTLastRowid',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"分类",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: comboTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });  
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				frame : true,
				reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'PDTRowId',mapping:'PDTRowId',type:'string'},
                         {name: 'PDTCode',mapping:'PDTCode',type:'string'},
                         {name: 'PDTDesc',mapping:'PDTDesc',type:'string'},
                         {name: 'PDTLastRowid',mapping:'PDTLastRowid',type:'string'},
                         {name: 'PDTLevel',mapping:'PDTLevel',type:'string'},
                         {name: 'PDTSysFlag',mapping:'PDTSysFlag',type:'string'},
                         {name: 'PDTActiveFlag',mapping:'PDTActiveFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDTRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDTRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PDTCode',
							id:'PDTCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDTCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDTCodeF')),
							allowBlank : false,
							blankText : '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHDiseaseTree";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var id = treePanel.getSelectionModel().getSelectedNode().id; //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
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
							name : 'PDTDesc',
							id:'PDTDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDTDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDTDescF')),
							allowBlank : false,
							blankText : '描述不能为空',
							validationEvent : 'blur'
                            
						}, treeCombox, {
							fieldLabel : '级别',
							name : 'PDTLevel',
							id:'PDTLevelF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDTLevelF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDTLevelF'))
						},{
							xtype : 'checkbox',
							fieldLabel : '是否可用',
							name : 'PDTActiveFlag',
							id:'PDTActiveFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDTActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDTActiveFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDTSysFlag',
							id:'PDTSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDTSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDTSysFlagF')),
   							checked:true,
							inputValue : true ? 'Y' : 'N'
						}]
			});
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 460,
		height : 380,
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
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("PDTCodeF").getValue();
				var tempDesc = Ext.getCmp("PDTDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}

    			if(WinForm.form.isValid()==false){return;}
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
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.getCmp('FindTreeText').reset();
												hiddenPkgs = [];
												
												treePanel.loadTreeAdd();
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
										var myrowid = "rowid=" + treePanel.getSelectionModel().getSelectedNode().id; 
										Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													Ext.getCmp('FindTreeText').reset();
													hiddenPkgs = [];
													
													treePanel.loadTreeAdd();
													
													gridLinkLabel.getStore().load({
														params : {
																start : 0,
																limit : pagesize_pop
																}
													});
													/*treePanel.root.cascade(function(n) {   ///????
														alert(n.id)
														alert()
															if(n.id==selectNode){
																n.select();
															}
													});*/
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
		},{
			text : '继续添加',
			iconCls : 'icon-save',
			handler : function() {
				var tempCode = Ext.getCmp("PDTCodeF").getValue();
				var tempDesc = Ext.getCmp("PDTDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.form.isValid()==false){Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
    			var comboxValue=Ext.getCmp("treeCombox").getValue();
				var comboxText=Ext.get("treeCombox").dom.value
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								
								Ext.getCmp("form-save").getForm().reset();
								var code = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
								Ext.getCmp("PDTCodeF").setValue(code)
								 //给上级赋值
								treeCombox.setValue(comboxValue)
								Ext.get("treeCombox").dom.value = comboxText;
								treePanel.loadTreeAdd();								
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
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp('FindTreeText').reset();
								hiddenPkgs = [];
								
								treePanel.loadTreeAdd();
								 Ext.getCmp("form-save").getForm().reset();
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
				Ext.getCmp("form-save").getForm().findField("PDTCode").focus(true,800);
				if(win.title == "修改"){
					win.buttons[1].hide();
				}else{
					win.buttons[1].show();
				}
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});

	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					var code = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
					Ext.getCmp("PDTCodeF").setValue(code)
					if (treePanel.getSelectionModel().getSelectedNode()) {
						var _record = treePanel.getSelectionModel().getSelectedNode();
						/*treeCombox.setValue(_record.id)
						var desc=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetDesc",_record.id);
						Ext.get("treeCombox").dom.value = desc;  */
						treeCombox.setValue(_record.id)
						Ext.get("treeCombox").dom.value = _record.text;		
						var level =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLevel",_record.id);
						if (level==""){level=0}
						level=parseInt(level)+1
						Ext.getCmp("PDTLevelF").setValue(level);
					}
					else
					{
						Ext.getCmp("PDTLevelF").setValue(0);
					}
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					var _record = treePanel.getSelectionModel().getSelectedNode();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的分类!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
				  	}else {
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + treePanel.getSelectionModel().getSelectedNode().id,
			                success : function(form,action) {
			                	var id=treePanel.getSelectionModel().getSelectedNode().parentNode.id
			                	if(id==undefined){
			                		Ext.get("treeCombox").dom.value = "";
			                	}else{
			                		var desc=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetDesc",id);
									Ext.get("treeCombox").dom.value = desc;                	
			                	}
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
		        } 
			});
	function AddSame(){
		win.setTitle('添加');
		win.setIconClass('icon-add');
		win.show('new1');
		WinForm.getForm().reset();
		var code = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastCode");
		Ext.getCmp("PDTCodeF").setValue(code)
		if (treePanel.getSelectionModel().getSelectedNode()) {
			var _record = treePanel.getSelectionModel().getSelectedNode();
			if(_record){
				/*var LastLevel = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLastLevel",_record.id);
				var LastId = LastLevel.split("^")[0];
				var LastDesc = LastLevel.split("^")[1];
				treeCombox.setValue(LastId)
				Ext.get("treeCombox").dom.value = LastDesc;*/
				if(_record.parentNode.id=="TreeRoot")
				{
					treeCombox.setValue("")
					Ext.get("treeCombox").dom.value ="";	
				}
				else
				{
					treeCombox.setValue(_record.parentNode.id)
					Ext.get("treeCombox").dom.value = _record.parentNode.text;
				}
				var level =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetLevel",_record.id);
				if (level==""){level=0}
				level=parseInt(level)
				Ext.getCmp("PDTLevelF").setValue(level);
			}
		}
	}
	var treePanel = new Ext.BDP.Component.tree.TreePanel({
		region:'center',
		rootId : "TreeRoot",
		nodeParameter :"LastLevel",
		dataUrl: TREE_ACTION_URL,
		dragUrl: DRAG_ACTION_URL, //拖拽方法
		AddMethod:AddSame, //右键菜单添加本级方法
		comboId:"treeCombox" //下拉树id
	});
	treePanel.on("click",function(node,event){
		selectNodeDesc=node.text
		
        selectNode=node.id
        RefreshLinkLabel();
		dsLabelItm.removeAll();
		
	})
	
	if(treePanel){
		treePanel.on("dblclick",function (node, e){
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show('');
			Ext.getCmp("form-save").getForm().reset();
            Ext.getCmp("form-save").getForm().load({
                url : OPEN_ACTION_URL + '&id=' + node.id,
                success : function(form,action) {
                	var id=treePanel.getSelectionModel().getSelectedNode().parentNode.id
                	if(id==undefined){
                		Ext.get("treeCombox").dom.value = "";
                	}else{
                		var desc=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseTree","GetDesc",id);
						Ext.get("treeCombox").dom.value = desc;                	
                	}
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
		},this,{stopEvent:true});
	}	
	var panel = new Ext.Panel({
		title: '诊断逻辑推导目录',
		layout:'border',
		region:'west',
		width:600,
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		items:[treePanel],
		tbar:[
			'搜索',
			new Ext.form.TextField({ 
				id:'FindTreeText',
				width:150,
				enableKeyEvents: true,
				listeners:{
					keyup:function(node, event) {
						selectNode="";
						selectNodeDesc="";
						findByKeyWordFiler(node, event);
					},
					scope: this
				}
			}), '-', {
				text:'重置',
				iconCls:'icon-refresh',
				handler:Refresh = function(){
					//treePanel.doQuery();
					treePanel.store.load();
					clearFind();
					dsLinkLabel.removeAll();
					dsLabelItm.removeAll();
				} //清除树过滤
			}, '-',btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnDisLabelPrompt,'->', btnConfig
		]
	});
	
	
	var gridEast = new Ext.Panel({
		id : 'gridEast',
		//title:'推导目录',
		region : 'center',
	
		defaults:{split:true},  //宽度可以左右拖动
		layout:'border',
		items:[gridLinkLabel,gridLabelItm]
	})

	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		defaults:{split:true},  //宽度可以左右拖动
		items : [panel,gridEast]
	});
/*******************************搜索功能********************************/	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(treePanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		
		clearTimeout(timeOutId);// 清除timeOutId
		treePanel.expandAll();// 展开树节点
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
					var pinyin=Pinyin.getWordsCode(n.text)
					return !n.isLeaf() || re.test(n.text) || re.test(pinyin);
				});
				// 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
				treePanel.root.cascade(function(n) {
					
					n.unselect();  //取消树节点选择状态   ///chenying  2017-04-18
					if(n.id!='TreeRoot'){
						var pinyin=Pinyin.getWordsCode(n.text)
						if(!n.isLeaf() &&judge(n,re)==false&& (!re.test(n.text)||!re.test(pinyin))){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// 过滤不匹配的非叶子节点或者是叶子节点
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			var pinyin=Pinyin.getWordsCode(n1.text)
			if(n1.isLeaf()){
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
			} else {
				if(re.test(n1.text)||re.test(pinyin)){ str=true;return; }
			}
		});
		return str;
	};
	// 清除树过滤
	var clearFind = function () {
		selectNode=""
		selectNodeDesc=""
		Ext.getCmp('FindTreeText').reset();
		treePanel.root.cascade(function(n) {
					if(n.id!='TreeRoot'){
						n.ui.show();
					}
					if(n.id==selectNode){
						n.unselect();  //取消树节点选择状态
					}
			});
	}
	/*************************************************************/
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
