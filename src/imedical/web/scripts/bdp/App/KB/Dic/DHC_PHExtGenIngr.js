/// 名称: 药品通用名成分明细表
/// 描述: 包含增删改查、维护成分功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-11-10
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHExtGenIngr";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGenIngr&pClassMethod=DeleteData";
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=GetTreeComboJson";
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
								'id' : rows[0].get('PHEGIRowId')
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
	var comboTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: "ParentID",
		dataUrl: TREE_COMBO_URL
	});
	var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'PHEGIIngrDrF',
         width : 180,  
         fieldLabel:"<font color=red>*</font>成分",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('PHEGIIngrDrF'),
         name:'PHEGIIngrDr',
         hiddenName : 'PHEGIIngrDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"成分",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         allowBlank:false,
		 blankText:'成分不能为空',
         loader: comboTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false
     });  
/*	var comboTreePanel = new Ext.tree.TreePanel({
			id: 'treeComboPanel',
			root: new Ext.tree.AsyncTreeNode({
					id:"CatTreeRoot",
					text:"成分",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
				}),
			loader: comboTreeLoader,
			//boxMaxHeight:30,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false
		});
	var treeCombox = new Ext.tet.TreeComboField({
			name:'PHEGIIngrDr',
			id:'PHEGIIngrDrF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGIIngrDrF'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGIIngrDrF')),
			fieldLabel:"<font color=red>*</font>成分",
			hiddenName : 'PHEGIIngrDr',
			allowBlank:false,
			blankText:'成分不能为空',
			anchor:"92%",
			editable : true,
			enableKeyEvents: true,
			tree:comboTreePanel
		});*/
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 100,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'data'},
                        [{name: 'PHEGIRowId',mapping:'PHEGIRowId',type:'string'},
                         {name: 'PHEGIPHEGDr',mapping:'PHEGIPHEGDr',type:'string'},      
                         {name: 'PHEGIIngrDr',mapping:'PHEGIIngrDr',type:'string'},
                         {name: 'PHEGILevel',mapping:'PHEGILevel',type:'string'},
                         {name: 'PHEGISysFlag',mapping:'PHEGISysFlag',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'PHEGIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHEGIRowId'
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>通用名',
							name : 'PHEGIPHEGDr',
							id:'PHEGIPHEGDrF',
							hiddenName:'PHEGIPHEGDr',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGIPHEGDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGIPHEGDrF')),
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
								baseParams:{code:'DRUG'},
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
						},treeCombox, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>主要成分标识',
							name:'PHEGILevel',
							hiddenName : 'PHEGILevel',
							id:'PHEGILevelF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGILevelF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGILevelF')),
   							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['1', '一级'],
											['2', '二级'],
											['3', '三级']
										]
							}),
							blankText : '主要成分标识不能为空',
							allowBlank : false,
							mode : 'local',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, {
							xtype : 'checkbox',
							fieldLabel : '是否系统标识',
							name : 'PHEGISysFlag',
							id:'PHEGISysFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHEGISysFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHEGISysFlagF')),
							checked:true,
							inputValue : true ? 'Y' : 'N'
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
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("PHEGIPHEGDrF").getValue();		
				var tempLib = Ext.getCmp("PHEGIIngrDrF").getValue();
				var tempDesc = Ext.getCmp("PHEGILevelF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempLib=="") {
    				Ext.Msg.show({ title : '提示', msg : '成分不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '主要成分标识不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
		},{
			text : '继续添加',
			iconCls : 'icon-save',
			handler : function() {
				var tempCode = Ext.getCmp("PHEGIPHEGDrF").getValue();		
				var tempLib = Ext.getCmp("PHEGIIngrDrF").getValue();
				var tempDesc = Ext.getCmp("PHEGILevelF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '通用名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempLib=="") {
    				Ext.Msg.show({ title : '提示', msg : '成分不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '主要成分标识不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
								Ext.BDP.FunLib.Component.FromHideClearFlag;
								var myrowid = action.result.id;
								Ext.getCmp("form-save").getForm().reset();
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
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'PHEGIRowId':""
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								Ext.BDP.FunLib.Component.FromHideClearFlag;
								var myrowid = action.result.id;
								Ext.getCmp("form-save").getForm().reset();
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
				Ext.getCmp("form-save").getForm().findField("PHEGIPHEGDr").focus(true,800);
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
				handler : UpdateData=function () {
					var _record = grid.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	comboTreeLoader.on("beforeload", function(treeLoader, node) {  
					        comboTreeLoader.baseParams.nodeid = _record.get('PHEGIIngrDr');    
					    }, this);  
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('PHEGIRowId'),
			                success : function(form,action) {
			                	var PHEINGDesc=_record.get('PHEINGDesc');
                				Ext.get("PHEGIIngrDrF").dom.value = PHEINGDesc;
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
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
									name : 'PHEGIRowId',
									mapping : 'PHEGIRowId',
									type : 'string'
								}, {
									name : 'PHEGDesc',
									mapping : 'PHEGDesc',
									type : 'string'
								}, {
									name : 'PHEGIPHEGDr',
									mapping : 'PHEGIPHEGDr',
									type : 'string'
								}, {
									name : 'PHEINGDesc',
									mapping : 'PHEINGDesc',
									type : 'string'
								}, {
									name : 'PHEGIIngrDr',
									mapping : 'PHEGIIngrDr',
									type : 'string'
								}, {
									name : 'PHEGILevel',
									mapping : 'PHEGILevel',
									type : 'string'
								}, {
									name : 'PHEGISysFlag',
									mapping : 'PHEGISysFlag',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
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
							gen : Ext.getCmp("PHEGIPHEGDr").getValue()
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
					Ext.getCmp("PHEGIPHEGDr").reset();
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
				items : [
						'通用名', {
							xtype : 'combo',
							id : 'PHEGIPHEGDr',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('PHEGIPHEGDr'),
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
							valueField : 'PHEGRowId',
							displayField : 'PHEGDesc',
							store : new Ext.data.JsonStore({
								url : BindingGen,
								baseParams:{code:'DRUG'},
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
							header : 'PHEGIRowId',
							sortable : true,
							dataIndex : 'PHEGIRowId',
							hidden : true
						}, {
							header : '通用名',
							sortable : true,
							dataIndex : 'PHEGDesc'
						}, {
							header : '通用名ID',
							sortable : true,
							dataIndex : 'PHEGIPHEGDr',
							hidden:true
						}, {
							header : '成分',
							sortable : true,
							dataIndex : 'PHEINGDesc'
						}, {
							header : '成分ID',
							sortable : true,
							dataIndex : 'PHEGIIngrDr',
							hidden:true
						}, {
							header : '主要成分标识',
							sortable : true,
							dataIndex : 'PHEGILevel',
							renderer : function(v){
								if(v=='1'){ return '一级'; }
								if(v=='2'){ return '二级'; }
								if(v=='3'){ return '三级'; }
							}
						},  {
							header : '是否系统标识',
							sortable : true,
							dataIndex : 'PHEGISysFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}],
				stripeRows : true,
				title : '药品通用名成分明细',
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
		       	 	comboTreeLoader.on("beforeload", function(treeLoader, node) {  
				        comboTreeLoader.baseParams.nodeid = _record.get('PHEGIIngrDr');    
				    }, this);  
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHEGIRowId'),
		                success : function(form,action) {
		                	var PHEINGDesc=_record.get('PHEINGDesc');
                			Ext.get("PHEGIIngrDrF").dom.value = PHEINGDesc;
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
				items : [grid]
			});
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
