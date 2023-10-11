/// 名称: 科室-其他科主任
/// 描述: 其他科主任弹窗
/// 编写者： 基础数据平台-李可凡
/// 编写日期:2021-01-06

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var CTDHU_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocDepHeadUser&pClassQuery=GetList";
	var CTDHU_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocDepHeadUser&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocDepHeadUser";	
	var CTDHU_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocDepHeadUser&pClassMethod=DeleteData";
	var CTDHU_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocDepHeadUser&pClassMethod=OpenData";
	var CTDHU_DepHeadUserDR = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSUser&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
	// 删除功能
	var CTDHUbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'CTDHUbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUbtnDel'),
		handler : function() {
			if (gridCTLocDepHeadUser.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridCTLocDepHeadUser.getSelectionModel();
						var rows = gsm.getSelections();
						Ext.Ajax.request({
							url : CTDHU_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTDHURowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(gridCTLocDepHeadUser,pagesize);	
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});

	// 增加修改的Form
	var CTDHUWinForm = new Ext.FormPanel({
		id : 'CTDHU-form-save',
		URL : CTDHU_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'CTDHUParRef',
							mapping : 'CTDHUParRef'
						}, {
							name : 'CTDHUDepHeadUserDR',
							mapping : 'CTDHUDepHeadUserDR'
						}, {
							name : 'CTDHURowId',
							mapping : 'CTDHURowId'
						}, {
							name : 'CTDHUDateFrom',
							mapping : 'CTDHUDateFrom'
						}, {
							name : 'CTDHUDateTo',
							mapping : 'CTDHUDateTo'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'CTDHURowId',
					xtype : 'textfield',
					fieldLabel : 'CTDHURowId',
					name : 'CTDHURowId',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'CTDHUParRef',
					xtype : 'textfield',
					fieldLabel : 'CTDHUParRef',
					name : 'CTDHUParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype:'bdpcombo',
					loadByIdParam : 'rowid',
					fieldLabel : '<font color=red>*</font>其他科主任',
					allowBlank:false,
					name : 'CTDHUDepHeadUserDR',
					id:'CTDHUDepHeadUserDRF',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDHUDepHeadUserDRF')),	
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDepHeadUserDRF'),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDepHeadUserDRF'),
					store : new Ext.data.Store({
						autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : CTDHU_DepHeadUserDR }),
						reader : new Ext.data.JsonReader({
									totalProperty : 'total',
									root : 'data',
									successProperty : 'success'
								}, [ 'SSUSRRowId', 'SSUSRName' ])
					}),
					queryParam : 'desc',
					//triggerAction : 'all',
					forceSelection : true,
					selectOnFocus : false,
					//typeAhead : true,
					//minChars : 1,
					listWidth : 250,
					valueField : 'SSUSRRowId',
					displayField : 'SSUSRName',
					hiddenName : 'CTDHUDepHeadUserDR',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					listeners:{
					   'beforequery': function(e){
							this.store.baseParams = {
								desc:e.query,
								hospid:2
							};
							this.store.load({params : {
										start : 0,
										limit : Ext.BDP.FunLib.PageSize.Combo
							}})

						}
					}
				}, {
					xtype : 'datefield',
					fieldLabel : '<font color=red>*</font>开始日期',
					name : 'CTDHUDateFrom',
					format : 'Y-m-d',
					id:'CTDHUDateFrom',
					allowBlank:false,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateFrom'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateFrom')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateFrom'),
					enableKeyEvents : true,
					listeners : {
		       		'keyup' : function(field, e){
							Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
			       	 	}
					}
				}, {
					xtype : 'datefield',
					fieldLabel : '结束日期',
					name : 'CTDHUDateTo',
					format : BDPDateFormat,
					id:'CTDHUDateTo',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateTo'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateTo')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTDHUDateTo'),
					enableKeyEvents : true,
					listeners : {
		       		'keyup' : function(field, e){
							Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
			       	 	}
					}
				}]
	});

	// 增加修改时弹出窗口
	var CTDHUwin = new Ext.Window({
		title : '',
		width : 280,
		height : 230,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : CTDHUWinForm,
		buttons : [{
			text : '保存',
			id : 'CTDHU_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHU_savebtn'),
			handler : function() {
				var startdate = Ext.getCmp("CTDHU-form-save").getForm().findField("CTDHUDateFrom").getValue();
		    	var enddate = Ext.getCmp("CTDHU-form-save").getForm().findField("CTDHUDateTo").getValue();
				if (startdate=="") {
					Ext.Msg.show({ title : '提示', msg : '开始日期不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
					return;
				}
				if (startdate != "" && enddate != "") {
					if (startdate > enddate) {
						Ext.Msg.show({ title : '提示', msg : '开始日期不能大于结束日期！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
						return;
					}
				}
				if(CTDHUWinForm.getForm().isValid()==false){
							 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;
				}
				// -------添加----------
				if (CTDHUwin.title == "添加") {
					
					CTDHUWinForm.form.submit({
						url : CTDHU_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'CTDHUParRef' : Ext.getCmp("Hidden_CTLocID").getValue() //在打开的时候,已赋值
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								CTDHUwin.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocDepHeadUser.getBottomToolbar().cursor;
												gridCTLocDepHeadUser.getStore().baseParams = { // 解决gridCTLocDepHeadUser不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_CTLocID").getValue()
												};
												gridCTLocDepHeadUser.getStore().load({
															params : {
																start : 0,
																limit : pagesize1
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})
				}
				// ---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							CTDHUWinForm.form.submit({
								url : CTDHU_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										CTDHUwin.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocDepHeadUser.getBottomToolbar().cursor;
												gridCTLocDepHeadUser.getStore().baseParams = { // 解决gridCTLocDepHeadUser不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_CTLocID").getValue()
												};
												Ext.BDP.FunLib.ReturnDataForUpdate("gridCTLocDepHeadUser",CTDHU_QUERY_ACTION_URL,myrowid);
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'
													+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}

								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
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
				CTDHUwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				CTDHUWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var CTDHUbtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'CTDHUbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUbtnAdd'),
		handler : function() {
			CTDHUwin.setTitle('添加');
			CTDHUwin.setIconClass('icon-add');
			CTDHUwin.show();
			CTDHUWinForm.getForm().reset();
		},
		scope : this
	});

	// 修改按钮
	var CTDHUbtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'CTDHUbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUbtnUpdate'),
				handler : function() {
					if (gridCTLocDepHeadUser.selModel.hasSelection()) {
						CTDHUwin.setTitle('修改');
						CTDHUwin.setIconClass('icon-update');
						CTDHUwin.show();
						loadCTDHUFormData(gridCTLocDepHeadUser);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
		// 刷新工作条
	var CTDHUbtnRefresh = new Ext.Button({
				id : 'CTDHUbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTDHUbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					gridCTLocDepHeadUser.getStore().baseParams={  //解决gridCTLocDepHeadUser不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								parref : Ext.getCmp("Hidden_CTLocID").getValue()
					};
					gridCTLocDepHeadUser.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var CTDHUds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : CTDHU_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'CTDHURowId',
								mapping : 'CTDHURowId',
								type : 'string'
							}, {
								name : 'CTDHUDepHeadUserDR',
								mapping : 'CTDHUDepHeadUserDR',
								type : 'string'
							}, {
								name : 'CTDHUDepHeadUserCode',
								mapping : 'CTDHUDepHeadUserCode',
								type : 'string'
							}, {
								name : 'CTDHUDepHeadUserDesc',
								mapping : 'CTDHUDepHeadUserDesc',
								type : 'string'
							}, {
								name : 'CTDHUParRef',
								mapping : 'CTDHUParRef',
								type : 'string'
							}, {
								name : 'CTDHUDateFrom',
								mapping : 'CTDHUDateFrom',
								type : 'string'
							}, {
								name : 'CTDHUDateTo',
								mapping : 'CTDHUDateTo',
								type : 'string'
							}])
		});

	// 加载数据
	CTDHUds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var CTDHUpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : CTDHUds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize1 = this.pageSize;
				         }
		        }
			});

	var CTDHUsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var CTDHUtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [CTDHUbtnAdd, '-', CTDHUbtnEdit, '-',
						CTDHUbtnDel, '-',CTDHUbtnRefresh,{ //'科室ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_CTLocID'
						},'-']
			});

	// 创建Grid
	var gridCTLocDepHeadUser = new Ext.grid.GridPanel({
				id : 'gridCTLocDepHeadUser',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : CTDHUds,
				trackMouseOver : true,
				columns : [CTDHUsm, {
							header : 'CTDHURowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTDHURowId',
							hidden : true
						}, {
							header : 'CTDHUParRef', //CTDHUParRef
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUParRef',
							hidden : true
						}, {
							header : '科主任DR',
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUDepHeadUserDR',
							hidden : true
						}, {
							header : '科主任工号',
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUDepHeadUserCode',
							hidden : true
						}, {
							header : '其他科主任',
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUDepHeadUserDesc'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							dataIndex : 'CTDHUDateTo'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : CTDHUpaging,
				tbar : CTDHUtbbutton,
				stateId : 'gridCTLocDepHeadUser'
			});
	Ext.BDP.FunLib.ShowUserHabit(gridCTLocDepHeadUser,"User.CTLocDepHeadUser");

	// 载入被选择的数据行的表单数据
	var loadCTDHUFormData = function(gridCTLocDepHeadUser) {
		var _record = gridCTLocDepHeadUser.getSelectionModel().getSelected();
		if (!_record) {
		} else {
			CTDHUWinForm.form.load({
						url : CTDHU_OPEN_ACTION_URL + '&id='+ _record.get('CTDHURowId'),
						// waitMsg : '正在载入数据...',
						success : function(form, action) {
							// Ext.Msg.alert('编辑','载入成功！');
						},
						failure : function(form, action) {
							Ext.Msg.alert('编辑', '载入失败！');
						}
					});
		}
	};

	gridCTLocDepHeadUser.on("rowdblclick", function(grid, rowIndex, e) {
				CTDHUwin.setTitle('修改');
				CTDHUwin.setIconClass('icon-update');
				CTDHUwin.show();
				loadCTDHUFormData(gridCTLocDepHeadUser);
			});

	var CTDHUwindow = new Ext.Window({
				title : '',
				width : 590,
				height : 420,
				plain : true,// true则主体背景透明
				modal : true,
				frame : true,// win具有全部阴影,若为false则只有边框有阴影
				autoScroll : true,
				collapsible : true,
				hideCollapseTool : true,
				titleCollapse : true,
				bodyStyle : 'padding:3px',
				buttonAlign : 'center',
				closeAction : 'hide',// 关闭窗口后执行隐藏命令
				items : gridCTLocDepHeadUser
			});
	//----------------------子表完----------------------
	
    function getCTLocDepHeadUserPanel(){
	var winCTLocDepHeadUser = new Ext.Window({
			title:'',
			width:700,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			//autoScroll: true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: gridCTLocDepHeadUser,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	//gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  	return winCTLocDepHeadUser;
}

	