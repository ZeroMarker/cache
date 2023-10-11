// / 名称: 访问类型位置维护
// / 描述: 包含增删改查功能
// / 编写者: 基础数据平台组- sfc
// / 编写日期: 2012-8-29
// / 修改日期： 2014-8-25 孙凤超
document
		.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document
		.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACAdmTypeLocation";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
 
	// 初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_AdmTypeLocation"
	});
	Ext.BDP.FunLib.TableName = "PAC_AdmTypeLocation";
    /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;
	var TransFlag = tkMakeServerCall("web.DHCBL.BDP.BDPTranslation",
			"IfTransLation", Ext.BDP.FunLib.TableName);
	if (TransFlag == "false") {
		btnTrans.hidden = false;
	} else {
		btnTrans.hidden = true;
	}
	// ////////////////////////////日志查看
	// ///////////////////////////////////////////////////////////
	var btnlog = Ext.BDP.FunLib.GetLogBtn("User.PACAdmTypeLocation");
	var btnhislog = Ext.BDP.FunLib.GetHisLogBtn("User.PACAdmTypeLocation");
	// /日志查看按钮是否显示
	var btnlogflag = Ext.BDP.FunLib.ShowBtnOrNotFun();
	if (btnlogflag == 1) {
		btnlog.hidden = false;
	} else {
		btnlog.hidden = true;
	}
	// / 数据生命周期按钮 是否显示
	var btnhislogflag = Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
	if (btnhislogflag == 1) {
		btnhislog.hidden = false;
	} else {
		btnhislog.hidden = true;
	}
	btnhislog.on('click', function(btn, e) {
				var RowID = "", Desc = "", Type = "";
				if (grid.selModel.hasSelection()) {
					var rows = grid.getSelectionModel().getSelections();
					RowID = rows[0].get('ADMLOCRowId');
					Type = rows[0].get('ADMLOCAdmType');
					if (Type == 'O') {
						Type = '门诊';
					}
					if (Type == 'I') {
						Type = '住院';
					}
					if (Type == 'E') {
						Type = '急诊';
					}
					if (Type == 'H') {
						Type = '体检';
					}
					Desc = Type + "->" + rows[0].get('ADMLOCCTLOCDesc');
					var result = tkMakeServerCall(
							"web.DHCBL.BDP.BDPDataChangeLog", "SaveLogParams",
							RowID, Desc);
				} else {
					var result = tkMakeServerCall(
							"web.DHCBL.BDP.BDPDataChangeLog",
							"KillDatalogGlobal");
				}
			});
	//多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		grid.enable();
		Ext.getCmp("AdmType").reset(); 
        Ext.getCmp("CTLOCRowID").reset(); 
        Ext.getCmp("TextDesc").reset(); 
		grid.getStore().baseParams = {
			AdmType : Ext.getCmp("AdmType").getValue(),
			CTLOCRowID : Ext.getCmp("CTLOCRowID").getValue(),
			Alias : Ext.getCmp("TextDesc").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_main
					}
				});
		
	});	
	/**
	 * ************************* 删除按钮
	 * *************************************************
	 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData = function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行

						// 删除所有别名
						AliasGrid.DataRefer = rows[0].get('ADMLOCRowId');
						AliasGrid.delallAlias();

						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ADMLOCRowId')
							},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON
											.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除成功!',
													icon : Ext.Msg.INFO,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														Ext.BDP.FunLib
																.DelForTruePage(
																		grid,
																		pagesize_main);
													}
												});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:'
													+ jsonData.info
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
	/** ***************************** 创建Form表单 ******************************* */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 70,
				frame : true,
				title : '基本信息',
				reader : new Ext.data.JsonReader({
							root : 'list'
						}, [{
									name : 'ADMLOCRowId',
									mapping : 'ADMLOCRowId',
									type : 'int'
								}, {
									name : 'ADMLOCAdmType',
									mapping : 'ADMLOCAdmType',
									type : 'string'
								}, {
									name : 'ADMLOCCTLOCDR',
									mapping : 'ADMLOCCTLOCDR',
									type : 'string'
								}]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ADMLOCRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ADMLOCRowId'
						}, {
							fieldLabel : '<font color=red>*</font>病人类型',
							xtype : 'combo',
							labelSeparator : "",
							hiddenName : 'ADMLOCAdmType',
							id : 'ADMLOCAdmTypeF',
							readOnly : Ext.BDP.FunLib.Component
									.DisableFlag('ADMLOCAdmTypeF'),
							style : Ext.BDP.FunLib
									.ReadonlyStyle(Ext.BDP.FunLib.Component
											.DisableFlag('ADMLOCAdmTypeF')),
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [['O', '门诊'], ['I', '住院'],
												['E', '急诊'], ['H', '体检']]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							minChars : 0,
							valueField : 'value',
							displayField : 'text'

						}, {
							xtype : 'bdpcombo',
							labelSeparator : "",
							fieldLabel : '<font color=red>*</font>位置描述',
							hiddenName : 'ADMLOCCTLOCDR',
							id : 'ADMLOCCTLOCDRF',
							readOnly : Ext.BDP.FunLib.Component .DisableFlag('ADMLOCCTLOCDRF'),
							style : Ext.BDP.FunLib .ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ADMLOCCTLOCDRF')),
							allowBlank : false,
							store : new Ext.data.Store({
										autoLoad : true,
										proxy : new Ext.data.HttpProxy({
													url : CTLOC_QUERY_ACTION_URL
												}),
										reader : new Ext.data.JsonReader({
													totalProperty : 'total',
													root : 'data',
													successProperty : 'success'
												}, ['CTLOCRowID', 'CTLOCDesc'])
									}),
							mode : 'remote',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,// true表示获取焦点时选中既有值
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							//minChars : 0,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
			
								'beforequery': function(e){
									this.store.baseParams = {
											desc:e.query,
											hospid:hospComp.getValue()
									};
									this.store.load({params : {
												start : 0,
												limit : Ext.BDP.FunLib.PageSize.Combo
									}})
								
							 	}

							}
						}]
			});
	var tabs = new Ext.TabPanel({
				activeTab : 0,
				frame : true,
				border : false,
				height : 200,
				items : [WinForm, AliasGrid]
			});
	Ext.BDP.AddTabpanelFun(tabs, Ext.BDP.FunLib.TableName);
	/**
	 * ******************************** 增加修改时弹出窗口
	 * *******************************
	 */
	var win = new Ext.Window({
		width : 420,
		layout : 'fit',
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
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id : 'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var ADMLOCAdmType = Ext.getCmp("form-save").getForm()
						.findField("ADMLOCAdmType").getValue();
				var ADMLOCCTLOCDR = Ext.getCmp("form-save").getForm()
						.findField("ADMLOCCTLOCDR").getValue();
				if (ADMLOCAdmType == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '病人类型不能为空!',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
					return;
				}
				if (ADMLOCCTLOCDR == "") {
					Ext.Msg.show({
								title : '提示',
								msg : '位置描述不能为空!',
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
							});
					return;
				}
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
										// 保存别名
										AliasGrid.DataRefer = myrowid;
										AliasGrid.saveAlias();

									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br />错误信息:'
													+ action.result.errorinfo
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
									// 保存别名
									AliasGrid.saveAlias();
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="
												+ action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib
														.ReturnDataForUpdate(
																"grid",
																QUERY_ACTION_URL,
																myrowid)
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br />错误信息:'
													+ action.result.errorinfo
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
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("ADMLOCAdmType")
						.focus(true, 800);
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {
			}
		}
	});
	/** ******************************* 添加按钮 ********************************* */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id : 'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData = function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
					// 激活基本信息面板
					tabs.setActiveTab(0);
					// 清空别名面板grid
					AliasGrid.DataRefer = "";
					AliasGrid.clearGrid();
				},
				scope : this
			});
	/** *******************************修改按钮 ************************************* */
	var btnEditwin = new Ext.Toolbar.Button({
		text : '修改',
		tooltip : '请选择一行后修改(Shift+U)',
		iconCls : 'icon-update',
		id : 'update_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
		handler : UpdateData = function() {
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
					url : OPEN_ACTION_URL + '&id=' + _record.get('ADMLOCRowId'),
					success : function(form, action) {
					},
					failure : function(form, action) {
						Ext.Msg.alert('编辑', '载入失败');
					}
				});
				// 激活基本信息面板
				tabs.setActiveTab(0);
				// 加载别名面板
				AliasGrid.DataRefer = _record.get('ADMLOCRowId');
				AliasGrid.loadGrid();
			}
		}
	});
	/** grid数据存储 */
	var fields = [{
				name : 'ADMLOCRowId',
				mapping : 'ADMLOCRowId',
				type : 'int'
			}, {
				name : 'ADMLOCAdmType',
				mapping : 'ADMLOCAdmType',
				type : 'string'
			}, {
				name : 'ADMLOCCTLOCDesc',
				mapping : 'ADMLOCCTLOCDesc',
				type : 'string'
			}]

	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : QUERY_ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields)
			});
	Ext.BDP.AddReaderFieldFun(ds, fields, Ext.BDP.FunLib.TableName);
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body, {
				disabled : false,
				store : ds
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
					"change" : function(t, p) {
						pagesize_main = this.pageSize;
					}
				}
			});
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-', btnTrans,'->', btnlog, '-', btnhislog]
			});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams = {
						AdmType : Ext.getCmp("AdmType").getValue(),
						CTLOCRowID : Ext.getCmp("CTLOCRowID").getValue(),
						Alias : Ext.getCmp("TextDesc").getValue(),
						hospid:hospComp.getValue()
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
				handler : function() {
					Ext.BDP.FunLib.SelectRowId = "";
					Ext.getCmp("AdmType").reset();
					Ext.getCmp("CTLOCRowID").reset();
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={hospid:hospComp.getValue()};
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
				items : ['病人类型', {
					id : 'AdmType',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('AdmType'),
					xtype : 'combo',
					width : 140,
					mode : 'local',
					store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [['O', '门诊'], ['I', '住院'], ['E', '急诊'],
										['H', '体检']]
							}),
					triggerAction : 'all',
					forceSelection : true,
					selectOnFocus : false,
					minChars : 0,
					listWidth : 140,
					valueField : 'value',
					displayField : 'text'
						// hiddenName : 'ADMLOCAdmType'//不能与id相同
				}, '-', '位置', {
					id : 'CTLOCRowID',
					disabled : Ext.BDP.FunLib.Component .DisableFlag('CTLOCRowID'),
					xtype : 'bdpcombo',
					store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({
											url : CTLOC_QUERY_ACTION_URL
										}),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, ['CTLOCRowID', 'CTLOCDesc'])
							}),
					mode : 'remote',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					listWidth : 250,
					queryParam : 'desc',
					//triggerAction : 'all',
					forceSelection : true,
					selectOnFocus : false,// true表示获取焦点时选中既有值
					//minChars : 0,
					valueField : 'CTLOCRowID',
					displayField : 'CTLOCDesc',
					listeners:{
			
						'beforequery': function(e){
							this.store.baseParams = {
									desc:e.query,
									hospid:hospComp.getValue()
							};
							this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
							}})
						
					 	}

					}
				}, '别名', {
					xtype : 'textfield',
					id : 'TextDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				},'-',LookUpConfigureBtn, '-', btnSearch, '-', btnRefresh],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
			});
	/** 创建grid */
	var GridCM = [new Ext.grid.CheckboxSelectionModel(), {
				header : 'ADMLOCRowId',
				sortable : true,
				dataIndex : 'ADMLOCRowId',
				hidden : true
			}, {
				header : '病人类型',
				sortable : true,
				dataIndex : 'ADMLOCAdmType',
				renderer : function(v) {
					if (v == 'O') {
						return '门诊';
					}
					if (v == 'I') {
						return '住院';
					}
					if (v == 'E') {
						return '急诊';
					}
					if (v == 'H') {
						return '体检';
					}
				}
			}, {
				header : '位置描述',
				sortable : true,
				dataIndex : 'ADMLOCCTLOCDesc'
			}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				title : '访问类型位置',
				// stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				bbar : paging,
				tbar : tb,
				tools : Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	Ext.BDP.AddColumnFun(grid, Ext.BDP.FunLib.TableName, GridCM);
	// / 单击事件：翻译要用到
	btnTrans.on("click", function() {
				if (grid.selModel.hasSelection()) {
					var _record = grid.getSelectionModel().getSelected();
					var selectrow = _record.get('ADMLOCRowId');
				} else {
					var selectrow = ""
				}
				Ext.BDP.FunLib.SelectRowId = selectrow
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
					win.show();
					Ext.getCmp("form-save").getForm().reset();
					Ext.getCmp("form-save").getForm().load({
						url : OPEN_ACTION_URL + '&id='
								+ _record.get('ADMLOCRowId'),
						success : function(form, action) {
						},
						failure : function(form, action) {
							Ext.Msg.alert('编辑', '载入失败');
						}
					});
					// 激活基本信息面板
					tabs.setActiveTab(0);
					// 加载别名面板
					AliasGrid.DataRefer = _record.get('ADMLOCRowId');
					AliasGrid.loadGrid();
				}
			});
	Ext.BDP.FunLib.ShowUserHabit(grid, Ext.BDP.FunLib.TableName);
	/**
	 * ************************* 调用keymap
	 * ***********************************************
	 */
	Ext.BDP.FunLib.Component.KeyMap(AddData, UpdateData, DelData);
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid]
			});
    ///多院区医院
    var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
		/** grid加载数据 */
		ds.load({
			params : {
				start : 0,
				limit : pagesize_main
			},
			callback : function(records, options, success) {
			}
		});
	
	}
});
