/// 名称: 药品通用名和剂型关联
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-11-7
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/MultiSelect.js"> </script>');
document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/Framework/css/multiselect.css"> </link>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var selectrow=Ext.getUrlParam('selectrow');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCGenLinkPointer";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCGenLinkPointer&pClassMethod=DeleteData";
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var BindingForm="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtForm&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
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
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('GlPRowId')
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
																			gen:selectrow,
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
	var WinFormAdd = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'GlPRowId',mapping:'GlPRowId',type:'string'},
                         {name: 'GlPGenDr',mapping:'GlPGenDr',type:'string'},
                         {name: 'GlPPointer',mapping:'GlPPointer',type:'string'},
                         {name: 'GlPActiveFlag',mapping:'GlPActiveFlag',type:'string'},
                         {name: 'GlPSysFlag',mapping:'GlPSysFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'GlPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'GlPRowId'
						}, {
							xtype : 'combo',   //通用名
							hidden:true,
							name : 'GlPGenDr',
							id:'GlPGenDrF',
							hiddenName:'GlPGenDr',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPGenDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPGenDrF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '通用名不能为空',
							allowBlank : false,
							valueField : 'PHEGRowId',
							displayField : 'PHEGDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingGen,
								baseParams:{code:'PHIC'},
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEGRowId',
								fields : ['PHEGRowId', 'PHEGDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHEGRowId',
									direction : 'ASC'
								}
							})
						},{
							xtype : 'multiSelect',
							fieldLabel : '<font color=red>*</font>剂型',
							name : 'GlPPointer',
							id:'GlPPointerF',
							hiddenName:'GlPPointer',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPPointerF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPPointerF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '剂型不能为空',
							allowBlank : false,
							valueField : 'PHEFRowId',
							displayField : 'PHEFDesc',
							showSelectAll:true,
							store :new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingForm,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEFRowId',
								fields : ['PHEFRowId', 'PHEFDesc'],
								listeners:{
									'load':function(store){
										if(Ext.getCmp('GlPPointerF').getValue()!=""){
											var cfmF = window.confirm('本页数据已变动,是否保存?');
								    		if(cfmF){ //是
								    			saveData();
								    		}else{
								    			Ext.getCmp('GlPPointerF').setValue("");
								    		}
										}
									}
								}
							})
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否可用',
							name : 'GlPActiveFlag',
							id:'GlPActiveFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPActiveFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPActiveFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'GlPSysFlag',
							id:'GlPSysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPSysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPSysFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}]
			});
	function saveData(){
				var tempDesc = Ext.getCmp("GlPPointerF").getValue();
				if(WinFormAdd.form.isValid()==false){return;}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '剂型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
				if (winAdd.title == "添加") {
					WinFormAdd.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var totalnum=grid.getStore().getTotalCount();
												grid.getStore().load({
													params : {
																gen:selectrow,
																start : 0,
																limit : pagesize_main,
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
	}		
	
	/** 增加时弹出窗口 */
	Ext.getCmp('GlPGenDrF').setValue(selectrow);
	var winAdd = new Ext.Window({
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
		items : WinFormAdd,
		buttons : [{
			text : '保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempDesc = Ext.getCmp("GlPPointerF").getValue();
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '剂型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if(WinFormAdd.form.isValid()==false){return;}
				if (winAdd.title == "添加") {
					WinFormAdd.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								winAdd.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var totalnum=grid.getStore().getTotalCount();
												grid.getStore().load({
													params : {
																gen:selectrow,
																start : 0,
																limit : pagesize_main,
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
							WinFormAdd.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										winAdd.hide();
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
		},{
			text : '继续添加',
			id:'resave_btn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('resave_btn'),
			handler : function() {
				var tempDesc = Ext.getCmp("GlPPointerF").getValue();
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '剂型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if(WinFormAdd.form.isValid()==false){return;}
				if (winAdd.title == "添加") {
					WinFormAdd.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp("form-save").getForm().reset();
								var myrowid = action.result.id;
								var totalnum=grid.getStore().getTotalCount();
								grid.getStore().load({
									params : {
												gen:selectrow,
												start : 0,
												limit : pagesize_main,
												rowid : myrowid
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
					WinFormAdd.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'GlPRowId':""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.getCmp("form-save").getForm().reset();
								var myrowid = action.result.id;
								var totalnum=grid.getStore().getTotalCount();
								grid.getStore().load({
									params : {
												gen:selectrow,
												start : 0,
												limit : pagesize_main,
												rowid : myrowid
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
			}
		},  {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				winAdd.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("GlPGenDr").focus(true,800);
			},
			"hide" : function(){
				Ext.BDP.FunLib.Component.FromHideClearFlag;
			},
			"close" : function() {}
		}
	});
	/** 创建Form表单 */
	var WinFormUpdate = new Ext.form.FormPanel({
				id : 'form-update',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'GlPRowId',mapping:'GlPRowId',type:'string'},
                         {name: 'GlPGenDr',mapping:'GlPGenDr',type:'string'},
                         {name: 'GlPPointer',mapping:'GlPPointer',type:'string'},
                         {name: 'GlPActiveFlag',mapping:'GlPActiveFlag',type:'string'},
                         {name: 'GlPSysFlag',mapping:'GlPSysFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'GlPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'GlPRowId'
						}, {
							xtype : 'combo',   //通用名
							hidden:true,
							name : 'GlPGenDr',
							id:'GlPGenDrFU',
							hiddenName:'GlPGenDr',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPGenDrFU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPGenDrFU')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							listWidth : 250,
							blankText : '通用名不能为空',
							allowBlank : false,
							valueField : 'PHEGRowId',
							displayField : 'PHEGDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingGen,
								baseParams:{code:'PHIC'},
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEGRowId',
								fields : ['PHEGRowId', 'PHEGDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHEGRowId',
									direction : 'ASC'
								}
							})
						},{
							xtype : 'combo',   
							fieldLabel : '<font color=red>*</font>剂型',
							name : 'GlPPointer',
							id:'GlPPointerFU',
							hiddenName:'GlPPointer',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPPointerFU'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPPointerFU')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							minChars : 0,
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							blankText : '剂型不能为空',
							allowBlank : false,
							valueField : 'PHEFRowId',
							displayField : 'PHEFDesc',
							store : new Ext.data.JsonStore({
								autoLoad : true,
								url : BindingForm,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEFRowId',
								fields : ['PHEFRowId', 'PHEFDesc']
							})
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否可用',
							name : 'GlPActiveFlag',
							id:'GlPActiveFlagFU',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPActiveFlagFU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPActiveFlagFU')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'GlPSysFlag',
							id:'GlPSysFlagFU',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('GlPSysFlagFU'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('GlPSysFlagFU')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
						}]
			});
	
	/** 修改时弹出窗口 */
	Ext.getCmp('GlPGenDrFU').setValue(selectrow);
	var winUpdate = new Ext.Window({
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
		items : WinFormUpdate,
		buttons : [{
			text : '保存',
			id:'upsave_btn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('upsave_btn'),
			handler : function() {
				var tempDesc = Ext.getCmp("GlPPointerFU").getValue();
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '剂型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			
    			if(WinFormUpdate.form.isValid()==false){return;}
				if (winUpdate.title == "添加") {
					WinFormUpdate.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								winUpdate.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var myrowid = action.result.id;
												var totalnum=grid.getStore().getTotalCount();
												grid.getStore().load({
													params : {
																gen:selectrow,
																start : 0,
																limit : pagesize_main,
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
							WinFormUpdate.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										winUpdate.hide();
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
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				winUpdate.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-update").getForm().findField("GlPGenDr").focus(true,800);
			},
			"hide" : function(){
				Ext.BDP.FunLib.Component.FromHideClearFlag;
			},
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
					winAdd.setTitle('添加');
					winAdd.setIconClass('icon-add');
					winAdd.show('new1');
					WinFormAdd.getForm().reset();
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
					if(grid.selModel.hasSelection()){
						var _record = grid.getSelectionModel().getSelected();
						winUpdate.setTitle('修改');
						winUpdate.setIconClass('icon-update');
						winUpdate.show('');
						Ext.getCmp("form-update").getForm().reset();
			            Ext.getCmp("form-update").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('GlPRowId'),
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
									name : 'GlPRowId',
									mapping : 'GlPRowId',
									type : 'string'
								}, {
									name : 'PHEGDesc',
									mapping : 'PHEGDesc',
									type : 'string'
								}, {
									name : 'PHEFDesc',
									mapping : 'PHEFDesc',
									type : 'string'
								}, {
									name : 'GlPGenDr',
									mapping : 'GlPGenDr',
									type : 'string'
								}, {
									name : 'GlPPointer',
									mapping : 'GlPPointer',
									type : 'string'
								}, {
									name : 'GlPActiveFlag',
									mapping : 'GlPActiveFlag',
									type : 'string'
								}, {
									name : 'GlPSysFlag',
									mapping : 'GlPSysFlag',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : ds
					});
	ds.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		    gen:selectrow
		  }   
		)
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
							pointer : Ext.getCmp("GlPPointer").getValue()
					};
					grid.getStore().load({
						params : {
									gen:selectrow,
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
					Ext.getCmp("GlPPointer").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
						params : {
									gen:selectrow,
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						'剂型', {
							xtype : 'combo',
							id : 'GlPPointer',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('GlPPointer'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'PHEFRowId',
							displayField : 'PHEFDesc',
							store : new Ext.data.JsonStore({
								url : BindingForm,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'PHEFRowId',
								fields : ['PHEFRowId', 'PHEFDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'PHEFRowId',
									direction : 'ASC'
								}
							})
						},  '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
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
							header : 'GlPRowId',
							sortable : true,
							dataIndex : 'GlPRowId',
							hidden : true
						}, {
							header : '药品通用名',
							sortable : true,
							dataIndex : 'PHEGDesc'
						}, {
							header : '通用名ID',
							sortable : true,
							dataIndex : 'GlPGenDr',
							hidden:true
						}, {
							header : '剂型',
							sortable : true,
							dataIndex : 'PHEFDesc'
						},  {
							header : '剂型ID',
							sortable : true,
							dataIndex : 'GlPPointer',
							hidden:true
						},  {
							header : '是否可用',
							sortable : true,
							dataIndex : 'GlPActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},  {
							header : '是否系统标识',
							sortable : true,
							dataIndex : 'GlPSysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
				stripeRows : true,
				title : '药品通用名和剂型关联',
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
				if(grid.selModel.hasSelection()){
					var _record = grid.getSelectionModel().getSelected();
					winUpdate.setTitle('修改');
					winUpdate.setIconClass('icon-update');
					winUpdate.show('');
					Ext.getCmp("form-update").getForm().reset();
		            Ext.getCmp("form-update").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('GlPRowId'),
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
				items : [grid]
			});
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
