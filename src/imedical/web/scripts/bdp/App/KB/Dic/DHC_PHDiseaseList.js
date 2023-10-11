/// 名称: 病症字典维护
/// 描述: 包含增删改查功能,还包含与诊断关联功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-6-17
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/App/KB/Dic/DHC_PHDiseaseComList.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
/**********************************病症字典表***********************************/
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseList&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	 //清空选中的表头全选框checkbox  
	 function clearCheckGridHead(grid){  
	  	var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');    
	     var hd = hd_checker.first();   
	     hd.removeClass('x-grid3-hd-checker-on'); 
	 } 
	
	 
	 
	 
	 		
	/**********************确诊病症指南 start*****************************/		
			
			
			
	
	var QUERY_ACTION_URL_DiseaseGuide = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassQuery=GetList";
	var SAVE_ACTION_URL_DiseaseGuide = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseGuide";
	var OPEN_ACTION_URL_DiseaseGuide = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassMethod=OpenData";
	var DELETE_ACTION_URL_DiseaseGuide = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassMethod=DeleteData";
	
	/** 删除按钮 */
	var btnDelDiseaseGuide = new Ext.Toolbar.Button({
					text : '删除',
					iconCls : 'icon-delete',
					id:'del_btn_DiseaseGuide',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn_DiseaseGuide'),
					handler : DelDataDiseaseGuide=function () {
						
						
						
							
								if (gridDiseaseGuide.selModel.hasSelection()) {
									Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
										if (btn == 'yes') {
											Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
											var gsm = gridDiseaseGuide.getSelectionModel();// 获取选择列
											var rows = gsm.getSelections();// 根据选择列获取到所有的行
											
											Ext.Ajax.request({
												url : DELETE_ACTION_URL_DiseaseGuide,
												method : 'POST',
												params : {
													'id' : rows[0].get('PDGRowId')
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
																	
																	Ext.BDP.FunLib.DelForTruePage(gridDiseaseGuide,pagesize_pop);
																	
																	
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
	var Label_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHGuideLabel&pClassQuery=GetDataForCmb1";
	var PDGID_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseGuide&pClassQuery=GetIDDataForCmb";
	
	var PDGidds=new Ext.data.Store({
										proxy : new Ext.data.HttpProxy({ url : PDGID_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'RowId',mapping:'RowId'},
										{name:'Desc',mapping:'Desc'} ])
								})				
					
	/** 创建修改Form表单 */
	var WinFormUpdateDiseaseGuide = new Ext.form.FormPanel({
				id : 'form-update-DiseaseGuide',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDGRowId',mapping:'PDGRowId',type:'string'},
                                         {name: 'PDGId',mapping:'PDGId',type:'string'},         
                                         {name: 'PDGDisDr',mapping:'PDGDisDr',type:'string'},
                                         {name: 'PDGLabelDr',mapping:'PDGLabelDr',type:'string'},
                                         {name: 'PDGText',mapping:'PDGText',type:'string'},
                                         {name: 'PDGSysFlag',mapping:'PDGSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							
							fieldLabel : 'PDGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDGRowId'
						}, {
							id : 'PDGDisDrUF',
							xtype : 'textfield',
							hideLabel : 'True',
							hidden : true,
							fieldLabel : 'PDGDisDr',
							name : 'PDGDisDr'
						},{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank:false,
							fieldLabel : '<font color=red>*</font>关联目录',
							name:'PDGLabelDr',
							hiddenName : 'PDGLabelDr',
							id:'PDGLabelDrUF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGLabelDrUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGLabelDrUF')),
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
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrUF').getValue()
									};
									Ext.getCmp("PDGIdUF").reset();
									
								},
								
								'collapse':function(){ //当下拉列表收起的时候触发
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrUF').getValue()
									};
									PDGidds.load()
									Ext.getCmp("PDGIdUF").reset();
									
								},
								'keyup':function(){
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrUF').getValue()
									};
									PDGidds.load()
									Ext.getCmp("PDGIdUF").reset();
								}
							}
					
						}, {	
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联项目',
							name:'PDGId',
							hiddenName : 'PDGId',
							id:'PDGIdUF',	
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGIdUF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGIdUF')),
							store :PDGidds,
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
						
						},{
							fieldLabel:'结果',
							xtype : 'combo',
							name : 'PDGText',
							hiddenName:'PDGText',
							id:'PDGTextUF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGTextUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGTextUF')),
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
							
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDGSysFlag',
							id:'PDGSysFlagUF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGSysFlagUF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGSysFlagUF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 修改时弹出窗口 */
	var winUpdateDiseaseGuide = new Ext.Window({
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
					items : WinFormUpdateDiseaseGuide,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'updatesave_btn_DiseaseGuide',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('updatesave_btn_DiseaseGuide'),
						handler : function () {
							var tempValue = Ext.getCmp("form-update-DiseaseGuide").getForm().findField("PDGLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '关联目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if(WinFormUpdateDiseaseGuide.form.isValid()==false){
			    				Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;}								
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinFormUpdateDiseaseGuide.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL_DiseaseGuide,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													winUpdateDiseaseGuide.hide();
													var myrowid = "rowid=" + action.result.id;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("gridDiseaseGuide", QUERY_ACTION_URL_DiseaseGuide, myrowid)
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
							winUpdateDiseaseGuide.hide();
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
	var WinFormDiseaseGuide = new Ext.form.FormPanel({
				id : 'form-save-DiseaseGuide',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PDGRowId',mapping:'PDGRowId',type:'string'},
                                         {name: 'PDGId',mapping:'PDGId',type:'string'},         
                                         {name: 'PDGDisDr',mapping:'PDGDisDr',type:'string'},
                                         {name: 'PDGLabelDr',mapping:'PDGLabelDr',type:'string'},
                                         {name: 'PDGText',mapping:'PDGText',type:'string'},
                                         {name: 'PDGSysFlag',mapping:'PDGSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PDGRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDGRowId'
						}, {
							id : 'PDGDisDrF',
							xtype : 'textfield',
							hideLabel : 'True',
							hidden : true,
							fieldLabel : 'PDGDisDr',
							name : 'PDGDisDr'
   						}, {
   							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联目录',
							name:'PDGLabelDr',
							allowBlank:false,
							hiddenName : 'PDGLabelDr',
							id:'PDGLabelDrF',							
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGLabelDrF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGLabelDrF')),
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
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrF').getValue()
									};
									Ext.getCmp("PDGIdF").reset();
									
								},
								'collapse':function(){ //当下拉列表收起的时候触发
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrF').getValue()
									};
									PDGidds.load()
									Ext.getCmp("PDGIdF").reset();
									
								},
								'keyup':function(){
									PDGidds.baseParams = {
										labeldr : Ext.getCmp('PDGLabelDrF').getValue()
									};
									Ext.getCmp("PDGIdF").reset();
								}
							}
   						}
   						,{
   							
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>关联项目',
							name:'PDGId',
							hiddenName : 'PDGId',
							id:'PDGIdF',	
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGIdF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGIdF')),
							store :PDGidds,
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'Desc',
							valueField : 'RowId'
						},
						{	
							
							fieldLabel:'结果',
							xtype : 'combo',
							name : 'PDGText',
							hiddenName:'PDGText',
							id:'PDGTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGTextF')),
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
							
							
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PDGSysFlag',
							id:'PDGSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDGSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDGSysFlagF')),
   							checked:true,
							inputValue : 'Y'
						}]
			});
	/** 增加时弹出窗口 */
	var winDiseaseGuide = new Ext.Window({
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
					items : WinFormDiseaseGuide,
					buttons : [{
						text : '保存',
						iconCls : 'icon-save',
						id:'save_btn_DiseaseGuide',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_DiseaseGuide'),
						handler : saveDataDiseaseGuide=function () {
							var tempValue = Ext.getCmp("form-save-DiseaseGuide").getForm().findField("PDGLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '关联目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
							
							
							if(WinFormDiseaseGuide.form.isValid()==false){ 
								Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;}
							WinFormDiseaseGuide.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_DiseaseGuide,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											winDiseaseGuide.hide();
											
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															gridDiseaseGuide.getStore().load({
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
						id:'resave_btn_DiseaseGuide',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn_DiseaseGuide'),
						handler : function () {
							var tempValue = Ext.getCmp("form-save-DiseaseGuide").getForm().findField("PDGLabelDr").getValue();
			    			if (tempValue=="") {
			    				Ext.Msg.show({ title : '提示', msg : '关联目录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			
			    			
			    			var _record = grid.getSelectionModel().getSelected();
							Ext.getCmp("PDGDisDrF").setValue( _record.get('PHDISLRowId'));
							
			   			 	if(WinFormDiseaseGuide.form.isValid()==false){ 
			   			 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
								 return;}
								WinFormDiseaseGuide.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL_DiseaseGuide,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save-DiseaseGuide").getForm().reset();							
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															gridDiseaseGuide.getStore().load({
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
							winDiseaseGuide.hide();
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
	var btnAddwinDiseaseGuide = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn_DiseaseGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn_DiseaseGuide'),
				handler : AddDataDiseaseGuide=function () {
					
					
						if (grid.selModel.hasSelection()) {
							PDGidds.baseParams = {
								labeldr : ""
							};
							winDiseaseGuide.setTitle('添加');
							winDiseaseGuide.setIconClass('icon-add');
							winDiseaseGuide.show();
							WinFormDiseaseGuide.getForm().reset();
							
							
							
							var _record = grid.getSelectionModel().getSelected();
							Ext.getCmp("PDGDisDrF").setValue( _record.get('PHDISLRowId'));
							
							
							
						}else {
				        	Ext.Msg.show({
											title : '提示',
											msg : '请先选择病症!',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
					}
					
				},
				scope : this
			});
			
	loadFormDataDiseaseGuide=function()
	{
						
		if (gridDiseaseGuide.selModel.hasSelection()) {
			var _record = grid.getSelectionModel().getSelected();
			Ext.getCmp("PDGDisDrUF").setValue( _record.get('PHDISLRowId'));
			
			
			var _recordDiseaseGuide = gridDiseaseGuide.getSelectionModel().getSelected();
			//alert(_recordDiseaseGuide.get('PDGLabelDr'))
			winUpdateDiseaseGuide.show('');
			PDGidds.baseParams = {
					labeldr : _recordDiseaseGuide.get('PDGLabelDr')
			};
			Ext.getCmp("form-update-DiseaseGuide").getForm().reset();
            Ext.getCmp("form-update-DiseaseGuide").getForm().load({
                url : OPEN_ACTION_URL_DiseaseGuide + '&id=' + _recordDiseaseGuide.get('PDGRowId'),
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
			
	/** 修改按钮 */
	var btnEditwinDiseaseGuide = new Ext.Toolbar.Button({
				text : '修改',
				iconCls : 'icon-update',
				id:'update_btn_DiseaseGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn_DiseaseGuide'),
				handler : UpdateDataDiseaseGuide=function () {
					
					loadFormDataDiseaseGuide()
						
				}
			});
	/** gridDiseaseGuide数据存储 */
	var dsDiseaseGuide = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL_DiseaseGuide }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PDGRowId',
									mapping : 'PDGRowId',
									type : 'string'
								}, {
									name : 'PDGDisDr',
									mapping : 'PDGDisDr',
									type : 'string'	
								},{
									name : 'PHDISLDiseaDesc',
									mapping : 'PHDISLDiseaDesc',
									type : 'string'	
									
								}, {
									name : 'PDGId',
									mapping : 'PDGId',
									type : 'string'
								}, {
									name : 'PDGIdDesc',
									mapping : 'PDGIdDesc',
									type : 'string'
								}, {
									name : 'PDGLabelDr',
									mapping : 'PDGLabelDr',
									type : 'string'
								},{
									name : 'PDGText',
									mapping : 'PDGText',
									type : 'string'
								},{
									name : 'PDGSysFlag',
									mapping : 'PDGSysFlag',
									type : 'string'
								
								},{
									name : 'PDGLabelDrDesc',
									mapping : 'PDGLabelDrDesc',
									type : 'string'
								}// 列的映射
						])
			});
	

	/** gridDiseaseGuide分页工具条 */
	var pagingDiseaseGuide = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : dsDiseaseGuide,
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
		var tbbuttonDiseaseGuide = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwinDiseaseGuide, '-', btnEditwinDiseaseGuide, '-', btnDelDiseaseGuide]
		});
	/** 搜索按钮 */
	var btnSearchDiseaseGuide = new Ext.Button({
				id : 'btnSearchDiseaseGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearchDiseaseGuide'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					gridDiseaseGuide.getStore().baseParams={
						disdr:rows[0].get('PHDISLRowId'),
						labeldr:Ext.getCmp("TextPDLLabelDr").getValue()
					};
					gridDiseaseGuide.getStore().load({
							params : {
									start : 0,
									limit : pagesize_pop
								}
						});
					
				
				
				}
			});
	/** 重置按钮 */
	var btnRefreshDiseaseGuide = new Ext.Button({
				id : 'btnRefreshDiseaseGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefreshDiseaseGuide'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : RefreshDiseaseGuide=function() {
					
					Ext.getCmp("TextPDLLabelDr").reset()
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					gridDiseaseGuide.getStore().baseParams={
						disdr:rows[0].get('PHDISLRowId'),
						labeldr:""
					};
					gridDiseaseGuide.getStore().load({
							params : {
									start : 0,
									limit : pagesize_pop
								}
						});
				}
		});
	/** 搜索工具条 */
	var tbDiseaseGuide = new Ext.Toolbar({
				id : 'tbDiseaseGuide',
				items : ['关联目录', {
							hiddenName : 'PDLLabelDr',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextPDLLabelDr'),
							id : 'TextPDLLabelDr',
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
							displayField : 'PGLDesc',
							valueField : 'PGLRowId'
							
						}, '-',
						btnSearchDiseaseGuide, '-', btnRefreshDiseaseGuide, '->'
				],
				listeners : {
					render : function() {
						tbbuttonDiseaseGuide.render(gridDiseaseGuide.tbar);
					}
				}
			});
	/** 创建grid */
	var gridDiseaseGuide = new Ext.grid.GridPanel({
				id : 'gridDiseaseGuide',
				region : 'center',
				closable : true,
				store : dsDiseaseGuide,
				frame : true,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PDGRowId',
							sortable : true,
							dataIndex : 'PDGRowId',
							hidden : true
						}, {
							header : '病症id',
							hidden:true,
							sortable : true,
							dataIndex : 'PDGDisDr'
						}, {
							header : '病症',
							sortable : true,
							hidden:true,
							dataIndex : 'PHDISLDiseaDesc'
			             },{
							header : '关联目录id',
							sortable : true,
							hidden:true,
							dataIndex : 'PDGLabelDr'
						 },{
							header : '关联目录',
							sortable : true,
							dataIndex : 'PDGLabelDrDesc'
						}, {
							header : '关联项目id',
							sortable : true,
							hidden:true,
							dataIndex : 'PDGId'
						}, {
							header : '关联项目',
							sortable : true,
							dataIndex : 'PDGIdDesc'
						
						 },{
							header : '结果',
							sortable : true,
							dataIndex : 'PDGText',
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
							header : '是否系统标识',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PDGSysFlag'
						}],
				stripeRows : true,
				title : '确诊病症指南',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : pagingDiseaseGuide,
				tbar : tbDiseaseGuide,   //[btnAddwinDiseaseGuide, '-', btnEditwinDiseaseGuide, '-', btnDelDiseaseGuide],
				stateId : 'gridDiseaseGuide'
			});
	/** gridDiseaseGuide双击事件 */
	gridDiseaseGuide.on("rowdblclick", function(gridDiseaseGuide, rowIndex, e) {
				loadFormDataDiseaseGuide()
			});	
	
	var DiseaseGuide_win = new Ext.Window({
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
					items : [gridDiseaseGuide],
					listeners : {
						"show" : function(){
													
						},
						"hide" : function(){
							
						},
						"close" : function(){
						}
					}
				});
	/** 确诊病症指南按钮 */
	var btnDiseaseGuide = new Ext.Toolbar.Button({
				text : '确诊病症指南',
				tooltip : '确诊病症指南',
				iconCls : 'icon-DP',
				id:'btnDiseaseGuide',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDiseaseGuide'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						Ext.getCmp("TextPDLLabelDr").reset()
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						gridDiseaseGuide.getStore().removeAll();
						gridDiseaseGuide.getStore().baseParams={
							disdr:rows[0].get('PHDISLRowId'),
							labeldr:""
						};
						gridDiseaseGuide.getStore().load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						
						DiseaseGuide_win.setTitle('病症——'+rows[0].get('PHDISLDiseaDesc'));
						DiseaseGuide_win.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条病症!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
			
	/*************************确诊病症指南 end************************************/	
			
	
			
			
	/************************别名/常用名*************************************/	
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({	
		type : "A",
		title:"别名"
	});
	var ComGrid = new Ext.BDP.grid.ComEditorGridPanel({	
		type : "C",
		title:"常用名"
	});
	
	
///***************************国家标准编码要显示字段表单********************************/
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
						var saveflag =tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","SaveAutoCode",AutoCode,CodeLen,StartCode);
						if(saveflag==1)
						{
							alert("保存成功")
							AutoCodeWin.hide();
						}
						else if (saveflag==2)
					    {
							alert("代码起始字符的长度要小于代码长度")
						}
						else
						{
							alert("保存失败!")
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
					var AutoCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","AutoCode");
					var CodeLen=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","CodeLen");
					var StartCode=tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","ShowAutoCode","StartCode");
					if(AutoCode=="") {AutoCode=true}
					Ext.getCmp("AutoCodeF").setValue(AutoCode);
					Ext.getCmp("CodeLenF").setValue(CodeLen);
					Ext.getCmp("StartCodeF").setValue(StartCode);
				},
				scope : this
			});
    /************************主表病症字典部分*************************************/
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					handler : DelData=function () {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('PHDISLRowId')
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
															gridWestS.getStore().removeAll();
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
				labelWidth : 100,
				title : '基本信息',
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PHDISLRowId',mapping:'PHDISLRowId',type:'string'},
                                         {name: 'PHDISLDiseaCode',mapping:'PHDISLDiseaCode',type:'string'},
                                         {name: 'PHDISLDiseaDesc',mapping:'PHDISLDiseaDesc',type:'string'},
                                         {name: 'PHDISLKey',mapping:'PHDISLKey',type:'string'},
                                         {name: 'PHDISLRemark',mapping:'PHDISLRemark',type:'string'},
                                         {name: 'PHDISLActiveFlag',mapping:'PHDISLActiveFlag',type:'string'},
                                         {name: 'PHDISLSysFlag',mapping:'PHDISLSysFlag',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHDISLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHDISLRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHDISLDiseaCode',
							id:'PHDISLDiseaCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLDiseaCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLDiseaCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.KB.DHCPHDiseaseList";  //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHDISLRowId'); //此条数据的rowid
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
							fieldLabel : '<font color=red>*</font>诊断中心词',
							name : 'PHDISLDiseaDesc',
							id:'PHDISLDiseaDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLDiseaDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLDiseaDescF')),
							editable:false,
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            //var pycode= tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            //Ext.getCmp("PHDISLKeyF").setValue(pycode);
	                            var className =  "web.DHCBL.KB.DHCPHDiseaseList"; //后台类名称
	                            var classMethod = "Validate"; //数据重复验证后台函数名
	                           
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHDISLRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该诊断中心词已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
            			        'blur':function(){
            			        	var txt=Ext.getCmp("PHDISLDiseaDescF").getValue()
            			        	var pycode= tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",txt);//用tkMakeServerCall函数实现与后台同步调用交互
	                            	Ext.getCmp("PHDISLKeyF").setValue(pycode);
            			        }
						    }
						},{
							fieldLabel:'拼音码',
							name : 'PHDISLKey',
							id:'PHDISLKeyF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLKeyF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLKeyF'))
						},{
							fieldLabel:'备注',
							xtype:'textarea',
							height:150,
							name : 'PHDISLRemark',
							id:'PHDISLRemarkF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLRemarkF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLRemarkF'))  							
						},{
							fieldLabel:'是否可用',
							xtype : 'checkbox',
							name : 'PHDISLActiveFlag',
							id:'PHDISLActiveFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLActiveFlagF'))
						},{
							fieldLabel:'系统标识',
							xtype : 'checkbox',
							name : 'PHDISLSysFlag',
							id:'PHDISLSysFlagF',
        					inputValue : true ? 'Y' : 'N',
							checked:true,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHDISLSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHDISLSysFlagF'))
						}]
			});
		var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm,ComGrid, AliasGrid]
		
			 });	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					width : 640,
					height:450,
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
					items : tabs,
					buttons : [{
						text : '保存',
						id:'save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("PHDISLDiseaCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("PHDISLDiseaDesc").getValue();
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '诊断中心词不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinForm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;}
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
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
															gridWestS.getStore().removeAll();
															}
												});
										//添加时 同时保存别名
										AliasGrid.PHDCLDisDr = myrowid;
										AliasGrid.saveAlias();
										//添加时 同时保存别名
										ComGrid.PHDCLDisDr = myrowid;
										ComGrid.saveAlias();
											
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
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {
												
												if (action.result.success == 'true') {
													win.hide();
													var disrowid = action.result.id;
													var myrowid = "rowid=" + disrowid;
													// var myrowid = jsonData.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															 Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
														}
													});
													//添加时 同时保存别名
														AliasGrid.PHDCLDisDr = disrowid;
														AliasGrid.saveAlias();
														
														ComGrid.PHDCLDisDr = disrowid;
														ComGrid.saveAlias();
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
						id:'resave_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
						handler : function () {
							var tempCode = Ext.getCmp("form-save").getForm().findField("PHDISLDiseaCode").getValue();
							var tempDesc = Ext.getCmp("form-save").getForm().findField("PHDISLDiseaDesc").getValue();
			    			if (tempCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (tempDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '诊断中心词不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			   			 	if(WinForm.form.isValid()==false){ Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;}
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											Ext.getCmp("form-save").getForm().reset();
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
											//添加时 同时保存别名
											AliasGrid.PHDCLDisDr = myrowid;
											AliasGrid.saveAlias();
											//添加时 同时保存别名
											ComGrid.PHDCLDisDr = myrowid;
											ComGrid.saveAlias();
											var code = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","GetLastCode");
											Ext.getCmp("PHDISLDiseaCodeF").setValue(code)
											
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
							win.hide();
						}
					}],
					listeners : {
						"show" : function() {
							Ext.getCmp("form-save").getForm().findField("PHDISLDiseaCode").focus(true,800);
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
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					
					//常用名和别名			        
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					var code = tkMakeServerCall("web.DHCBL.KB.DHCPHDiseaseList","GetLastCode");
					Ext.getCmp("PHDISLDiseaCodeF").setValue(code)
					//激活基本信息面板

		            tabs.setActiveTab(0);
			        //清空别名面板grid

		            AliasGrid.PHDCLDisDr = "";
		            AliasGrid.clearGrid();
		            ComGrid.PHDCLDisDr = "";
		            ComGrid.clearGrid();
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
				handler : UpdateData=function () {				
					if (!grid.selModel.hasSelection()) {
						Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
			        } else {
			        	var _record = grid.getSelectionModel().getSelected();
				        //常用名和别名
			            win.setTitle('修改');
						win.setIconClass('icon-update');
											 //激活基本信息面板
				        tabs.setActiveTab(0);
				        //加载别名面板
				        var _record = grid.getSelectionModel().getSelected();			        
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('PHDISLRowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			           	AliasGrid.PHDCLDisDr = _record.get('PHDISLRowId');
				        AliasGrid.loadGrid();
				        ComGrid.PHDCLDisDr = _record.get('PHDISLRowId');
				        ComGrid.loadGrid();

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
									name : 'PHDISLRowId',
									mapping : 'PHDISLRowId',
									type : 'string'
								}, {
									name : 'PHDISLDiseaCode',
									mapping : 'PHDISLDiseaCode',
									type : 'string'
								}, {
									name : 'PHDISLDiseaDesc',
									mapping : 'PHDISLDiseaDesc',
									type : 'string'
								},{
									name : 'PHDISLKey',
									mapping : 'PHDISLKey',
									type : 'string'
								},{
									name : 'comKey',
									mapping : 'comKey',
									type : 'string'
								},{
									name : 'PHDISLCom',
									mapping : 'PHDISLCom',
									type : 'string'
								},{
									name : 'PHDISLAlias',
									mapping : 'PHDISLAlias',
									type : 'string'
								},{
									name : 'PHDISLActiveFlag',
									mapping : 'PHDISLActiveFlag',
									type : 'string'
								}, {
									name : 'PHDISLSysFlag',
									mapping : 'PHDISLSysFlag',
									type : 'string'
								},{
									name : 'PHDISLRemark',
									mapping : 'PHDISLRemark',
									type : 'string'
								}// 列的映射
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
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
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnDiseaseGuide, '->',btnConfig]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var desc=Ext.getCmp("TextDesc").getValue();
					var allEn=""
					//if(desc.match("^[A-Za-z]+$")){ //如果是全英文
					if(desc.match("^[a-zA-Z 0-9]+$")){ //如果是英文或数字
						allEn="Y"
					}
					grid.getStore().baseParams={			
							allEn : allEn,
							desc : desc
							//alias : Ext.getCmp("TextAlias").getValue(),
							//com : Ext.getCmp("TextCom").getValue()
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
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : Refresh=function () {
					//Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					clearCheckGridHead(gridWestS);  //重置全选按钮
					//Ext.getCmp("TextCom").reset();
					//Ext.getCmp("TextAlias").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
					gridWestS.getStore().removeAll()
					}
				});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [/*'代码:', {
							xtype : 'textfield',
							width:100,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							id : 'TextCode'
						}, '-',*/
						'搜索框', {
							xtype : 'textfield',
							width:150,
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}/*, '-',
						'常用名:', {
							xtype : 'textfield',
							width:100,
							id : 'TextCom',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCom')
						}, '-',
						'别名:', {
							xtype : 'textfield',
							width:100,
							id : 'TextAlias',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextAlias')
						}*/, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
					}
				}
			});
			
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'north',
				height:300,
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHDISLRowId',
							sortable : true,
							dataIndex : 'PHDISLRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'PHDISLDiseaCode'
						}, {
							header : '诊断中心词',
							sortable : true,
							dataIndex : 'PHDISLDiseaDesc',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '拼音码',
							sortable : true,
							dataIndex : 'PHDISLKey'
						},{
							header : '常用名',
							sortable : true,
							dataIndex : 'PHDISLCom',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : '常用名拼音码',
							sortable : true,
							dataIndex : 'comKey',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : '别名',
							sortable : true,
							dataIndex : 'PHDISLAlias',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						},{
							header : '是否可用',
							sortable : true,
							dataIndex : 'PHDISLActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden : true
						},{
							header : '系统标识',
							sortable : true,
							dataIndex : 'PHDISLSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden : true
						},{
							header : '备注',
							sortable : true,
							dataIndex : 'PHDISLRemark',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}],
				stripeRows : true,
				title : '病症字典',
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


/*********************************已关联表***************************************/
  var QUERY_CON_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassQuery=GetList";
  var DELETE_CON_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=DeleteData";
  /** 已关联grid数据存储 */
	var dsWestS = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CON_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHDISLIRowId',
							mapping : 'PHDISLIRowId',
							type : 'string'
						},{
							name : 'PHDISLIDisDr',
							mapping : 'PHDISLIDisDr',
							type : 'string'
						},{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						},{
							name : 'ICDCode',
							mapping : 'ICDCode',
							type : 'string'
						},{
							name : 'PHDISLIICDDr',
							mapping : 'PHDISLIICDDr',
							type : 'string'
						},{
							name : 'ICDOpStatus',
							mapping : 'ICDOpStatus',
							type : 'string'
						},{
							name : 'ICDRemark',
							mapping : 'ICDRemark',
							type : 'string'
						},{
							name : 'PHDISLIType',
							mapping : 'PHDISLIType',
							type : 'string'
						}, {
							name : 'PHDISLISysFlag',
							mapping : 'PHDISLISysFlag',
							type : 'string'
						}// 列的映射
				])
	});
	/** 已关联grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestS
	}); 
	/**加载分页参数**/
	dsWestS.on('beforeload',function(){ 
		if(dsWestS.getCount()!='0'){
			if(grid.getSelectionModel().getCount()!=0){
				Ext.apply(this.baseParams,{parref:grid.getSelectionModel().getSelections()[0].get('PHDISLRowId')})
			}
		}
	});  
	/** 已关联grid加载数据 */
	dsWestS.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** 已关联grid分页工具条 */
	var pagingWestS = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWestS,
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
	var btnICDDelete = new Ext.Button({			
					xtype : 'button',
					text : '批量删除',
					icon : Ext.BDP.FunLib.Path.URL_Icon+'delete.gif',
					id:'btnICDDelete',
	   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDDelete'),
					handler : function DeleteConICDData() {
						var rs=gridWestS.getSelectionModel().getSelections();
						if(rs.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请选择需要删除的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else{
						    var deleteflag=""
							Ext.each(rs,function(){
								Ext.Ajax.request({
									url : DELETE_CON_ACTION_URL,
									method : 'POST',
									params : {
										'id' : this.get('PHDISLIRowId')
									},
									callback : function(options, success, response) {
										if (success) 
										{
											var deleteflag=deleteflag+"Y"
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												var deleteflag="Y"
											} else {
												var deleteflag=deleteflag+"N"
											}
										} 
										else 
										{
											var deleteflag=deleteflag+"N"
										}
									}
									}, this);
							})
							
							if(deleteflag.indexOf("N")>0){
									Ext.Msg.show({
										title : '提示',
										msg : '批量删除失败!',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
								
							}else{
									Ext.Msg.show({
										title : '提示',
										msg : '批量删除成功!',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
											var startIndex = gridWestS.getBottomToolbar().cursor;
											var totalnum=gridWestS.getStore().getTotalCount();
											if(totalnum==1){   //修改添加后只有一条，返回第一页
												var startIndex=0
											}
											else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
											{
												var pagenum=gridWestS.getStore().getCount();
												if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
											}
										 	var id = grid.getSelectionModel().getSelections()[0].get('PHDISLRowId');
										 	gridWestS.getStore().load({
												params : {
													parref : id,
													start : 0,
													limit : pagesize_main
												}
											});
											clearCheckGridHead(gridWestS);  //重置全选按钮
											//诊断列表重新加载
											gridICD.getStore().baseParams={			
													desc : Ext.getCmp("TextICDDesc").getValue(),
													con : Ext.getCmp("TextCon").getValue()
											};
											gridICD.getStore().load({
												params : {
															start : 0,
															limit : pagesize_main
														}
												});
												}
											
										});
							}
					
						}
					},
					scope : this
				});
	var conICDtb = new Ext.Toolbar({
		id : 'conICDtb',
		items : [btnICDDelete]
	});
	/** 创建已关联grid */
	var gridWestS = new Ext.grid.GridPanel({
		id : 'gridWestS',
		region : 'center',
		closable : true,
		store : dsWestS,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
			{
					header : 'rowid',
					sortable : true,
					dataIndex : 'PHDISLIRowId',
					hidden : true
				},{
					header : '病症',
					sortable : true,
					dataIndex : 'PHDISLIDisDr'
				},{
					header : '诊断rowid',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden:true
				},{
					header : '诊断代码',
					sortable : true,
					dataIndex : 'ICDCode'
				},{
					header : '诊断描述',
					sortable : true,
					dataIndex : 'PHDISLIICDDr'
				},{
					header : '操作状态',
					sortable : true,
					dataIndex : 'ICDOpStatus',
					renderer:function(value){
						if(value=="0"){
							value="放弃"
							return value
						}
						if(value=="1"){
							value="确认"
							return value
						}
					}
				},{
					header : '备注',
					sortable : true,
					dataIndex : 'ICDRemark',
					renderer: Ext.BDP.FunLib.Component.GirdTipShow
				},{
					header : '诊断类型',
					sortable : true,
					hidden : true,
					dataIndex : 'PHDISLIType'
					//hidden : true
				},{
					header : '系统标识',
					sortable : true,
					hidden : true,
					dataIndex : 'PHDISLISysFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
					},{
					header : '操作',
					dataIndex : 'PHLCRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '已关联诊断',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.CheckboxSelectionModel,
		//tbar:conICDtb,
		//sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestS,
		stateId : 'gridWestS'
	});
	
	var isdblclick;
	/**查询已关联*/
	grid.on("rowclick", function(grid, rowIndex, e){
		isdblclick=false;
	    window.setTimeout(rowclickFn, 500);
	    function rowclickFn(){
	        if(isdblclick!=false)return;
		 	var id = grid.getSelectionModel().getSelections()[0].get('PHDISLRowId');
		 	gridWestS.getStore().load({
				params : {
					parref : id,
					start : 0,
					limit : pagesize_main
				}
			});
			clearCheckGridHead(gridWestS)
	    }
	
	 });
	 
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
			    isdblclick=true;
	    		//alert("这是双击")
				if (!grid.selModel.hasSelection()) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		        } else {
		        	var _record = grid.getSelectionModel().getSelected();
		        	//常用名和别名
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					 //激活基本信息面板
			        tabs.setActiveTab(0);
			        //加载别名面板
			        var _record = grid.getSelectionModel().getSelected();				
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHDISLRowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            AliasGrid.PHDCLDisDr = _record.get('PHDISLRowId');
			        AliasGrid.loadGrid();
			        ComGrid.PHDCLDisDr = _record.get('PHDISLRowId');
			        ComGrid.loadGrid();
			        
			        var id = grid.getSelectionModel().getSelections()[0].get('PHDISLRowId');
				 	gridWestS.getStore().load({
						params : {
							parref : id,
							start : 0,
							limit : pagesize_main
						}
					});

		        }
			});
	/**删除**/
	gridWestS.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		Ext.MessageBox.confirm('提示','确定撤销该关联数据吗?', function(button) {
	 		if(button=="yes"){
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行		
				Ext.Ajax.request({
					url : DELETE_CON_ACTION_URL,
					method : 'POST',
					params : {
						'id' : rows[0].get('PHDISLIRowId')
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '关联撤销成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										var startIndex = gridWestS.getBottomToolbar().cursor;
										var totalnum=gridWestS.getStore().getTotalCount();
										if(totalnum==1){   //修改添加后只有一条，返回第一页
											var startIndex=0
										}
										else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
										{
											var pagenum=gridWestS.getStore().getCount();
											if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
										}
									 	var id = grid.getSelectionModel().getSelections()[0].get('PHDISLRowId');
									 	gridWestS.getStore().load({
											params : {
												parref : id,
												start : 0,
												limit : pagesize_main
											}
										});
										clearCheckGridHead(gridWestS);//重置全选按钮
										//诊断列表重新加载
										gridICD.getStore().baseParams={			
												desc : Ext.getCmp("TextICDDesc").getValue(),
												con : Ext.getCmp("TextCon").getValue()
										};
										gridICD.getStore().load({
											params : {
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
	 		}
	});
/************************************West***********************************************/
var gridWest = new Ext.Panel({
		id : 'gridWest',
		title:'病症和诊断关联',
		region : 'west',
		width:760,
		split:true,
		collapsible:true,
		layout:'border',
		items:[grid,gridWestS]
})


/**********************************Center 诊断字典表*************************************/
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassQuery=GetDataForCmb2";
var SAVE_ACTION_URL_ICD = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseItmList";
	/** grid数据存储 */
	var dsICD = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						}, {
							name : 'ICDCode',
							mapping : 'ICDCode',
							type : 'string'
						}, {
							name : 'ICDDesc',
							mapping : 'ICDDesc',
							type : 'string'
						}, {
							name : 'ConFlag',
							mapping : 'ConFlag',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsICD
	});

	/** grid加载数据 */
	dsICD.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingICD = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsICD,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_main=this.pageSize;
				clearCheckGridHead(gridICD);  //重置全选按钮
			}
		}
	});
		/** 工具条 */
	
		/** 搜索按钮 */
	var btnICDSearch = new Ext.Button({
				id : 'btnICDSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDSearch'),
				iconCls : 'icon-search',
				text : '',
				handler : function() {
					gridICD.getStore().baseParams={			
							desc : Ext.getCmp("TextICDDesc").getValue(),
							con : Ext.getCmp("TextCon").getValue()
					};
					gridICD.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	/** 重置按钮 */
	var btnICDRefresh = new Ext.Button({
				id : 'btnICDRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDRefresh'),
				iconCls : 'icon-refresh',
				text : '',
				handler : function() {
					Ext.getCmp("TextICDDesc").reset();
					Ext.getCmp("TextCon").reset();
					clearCheckGridHead(gridICD);  //重置全选按钮
					//Ext.getCmp("textType").reset();
					gridICD.getStore().baseParams={};
					gridICD.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}
				});
				
		var btnICDSave = new Ext.Button({			
					xtype : 'button',
					text : '关联',
					icon : Ext.BDP.FunLib.Path.URL_Icon+'folder_go.png',
					id:'btnICDSave',
	   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnICDSave'),
					handler : function SaveData() {
						var rs=gridICD.getSelectionModel().getSelections();
						if(rs.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请选择需要保存的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else{
							var fieldStr = "";
							/*var PHDISLIType=Ext.getCmp("textType").getValue();
							var PHDISLISysFlag=Ext.getCmp("textFlag").getValue();
							if(PHDISLISysFlag==true){
						       		PHDISLISysFlag="Y"
						    }else{
						       	PHDISLISysFlag="N"
						    }*/
							var PHDISLIType=""  //类型和激活标识都为空
							var PHDISLISysFlag=""
					        var gsm = grid.getSelectionModel();// 获取选择列
						    var rows = gsm.getSelections();// 根据选择列获取到所有的行
						    var selectrow=rows[0].get('PHDISLRowId')
							Ext.each(rs,function(){
								if(fieldStr!="") fieldStr = fieldStr+",";
								var fieldDR=this.get('ICDRowId');//诊断id
								fieldStr = fieldStr+fieldDR;
							})
								Ext.Ajax.request({
									url : SAVE_ACTION_URL_ICD , 		
									method : 'POST',	
									params : {
											'PHDISLIICDDr' : fieldStr,
											'PHDISLIDisDr':selectrow,
											'PHDISLIType':PHDISLIType,
											'PHDISLISysFlag':PHDISLISysFlag
											
									},
									callback : function(options, success, response) {	
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												var myrowid = jsonData.id;

												gridWestS.getStore().load({
															params : {
																	   'parref':selectrow,
																		start : 0,
																		limit : pagesize_main
																	}
															});
												
												gridICD.getStore().load({
													params : {
														start : 0,
														limit : pagesize_main
													},
													callback : function(records, options, success) {
													}
												});
											}else{
												var errorMsg ='';
												if(jsonData.errorinfo){
													errorMsg='<br />'+jsonData.errorinfo
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
								});
					
						}
					},
					scope : this
				});
				
				
	var ICDtb = new Ext.Toolbar({
		id : 'ICDtb',
		items : [
				'搜索',{
						xtype : 'textfield',
						id : 'TextICDDesc',
						emptyText : '描述/代码',
						width : 120,
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextICDDesc'),
						enableKeyEvents : true
						/*listeners : {
				       	'keyup' : function(field, e){
							gridICD.getStore().baseParams={			
									desc : Ext.getCmp("TextICDDesc").getValue(),
									con : Ext.getCmp("TextCon").getValue()
							};
							gridICD.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
							}
						}*/
					}, '-', '已关联', {
							fieldLabel : '标识',
							xtype : 'combo',
							id : 'TextCon',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCon'),
							emptyText:'',
							width : 60,
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							listWidth : 60,
							//value:"A",
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [ {
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}]
							})
						},'-', btnICDSearch,'-',btnICDRefresh,'-',btnICDSave
				]
	});


 

	/** 创建grid */
	var gridICD = new Ext.grid.GridPanel({
		id : 'gridICD',
		region : 'center',
		//width:240,
		//collapsed:true,
		//collapsible:true,
		closable : true,
		store : dsICD,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'ICDRowId',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden : true
				}, {
					header : '诊断代码',
					sortable : true,
					dataIndex : 'ICDCode'
					//hidden : true
				}, {
					header : '诊断描述',
					sortable : true,
					dataIndex : 'ICDDesc',
					renderer: Ext.BDP.FunLib.Component.GirdTipShow
				}, {
					header : '已关联',
					sortable : true,
					dataIndex : 'ConFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
				}],
		stripeRows : true,
		title:'诊断列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.RowSelectionModel({singleSelect:false}), // 按"Ctrl+鼠标左键"也只能单选
		sm : new Ext.grid.CheckboxSelectionModel,
		bbar : pagingICD,
		tbar:ICDtb,
		stateId : 'gridICD'
	});

	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridICD]
	});	
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
})
