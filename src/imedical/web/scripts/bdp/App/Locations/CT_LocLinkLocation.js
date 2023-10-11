/// 名称: 科室-关联科室	CTLocLinkLocation
/// 描述: 科室-关联科室	
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期:2013-05-31


/**----------------------------------关联科室部分--------------------------------------**/	
  
	
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var Link_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkLocation&pClassQuery=GetList";
	var Link_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkLocation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocLinkLocation";	
	var Link_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkLocation&pClassMethod=DeleteData";
	var Link_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkLocation&pClassMethod=OpenData";
	var Link_CTLOC_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
 	//---------------------子表：关联科室-------------------------
	// 删除功能
	var linkbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'LinkbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnDel'),
		handler : function() {
			if (gridCTLocLinkLocation.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = gridCTLocLinkLocation.getSelectionModel();
						var rows = gsm.getSelections();
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : Link_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('LINKRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										// var myrowid = action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = gridCTLocLinkLocation.getBottomToolbar().cursor;
												var totalnum=gridCTLocLinkLocation.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=gridCTLocLinkLocation.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												gridCTLocLinkLocation.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1,
																rowid : Ext.getCmp("Hidden_LocLink_CTLocID").getValue()
																}	
														});		
	
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
	var linkWinForm = new Ext.FormPanel({
		id : 'link-form-save',
		URL : Link_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'LINKParRef',
							mapping : 'LINKParRef'
						}, {
							name : 'LINKCTLOCDR',
							mapping : 'LINKCTLOCDR'
						}, {
							name : 'LINKRowId',
							mapping : 'LINKRowId'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'LINKRowId',
					xtype : 'textfield',
					fieldLabel : 'LINKRowId',
					name : 'LINKRowId',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'LINKParRef',
					xtype : 'textfield',
					fieldLabel : 'LINKParRef',
					name : 'LINKParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype : "bdpcombo",
					emptyText : '请选择',
					fieldLabel : '<font color=red>*</font>关联科室',
					allowBlank:false,
					id: 'LINKCTLOCDR1',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('LINKCTLOCDR'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('LINKCTLOCDR'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LINKCTLOCDR')),
					hiddenName : 'LINKCTLOCDR',
					listWidth : 300,
					// id :'LINKCTLOCDR',
					store : new Ext.data.Store({
								autoLoad : true,
								baseParams:{communityid:communityid},
								proxy : new Ext.data.HttpProxy({
											url : Link_CTLOC_DR_QUERY_ACTION_URL
										}),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{
													name : 'CTLOCRowID',
													mapping : 'CTLOCRowID'
												}, {
													name : 'CTLOCDesc',
													mapping : 'CTLOCDesc'
												}])
							}),
					mode : 'local',
					shadow : false,
					forceSelection : true,
					//triggerAction : 'all',
					// hideTrigger: false,
					displayField : 'CTLOCDesc',
					valueField : 'CTLOCRowID',
					listeners:{
						   'beforequery': function(e){
								this.store.baseParams = {
									desc:e.query
									//,hospid:Ext.getCmp("hidden_LocLink_HOSPDR").getValue()
								};
								this.store.load({params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
								}})
						
							}
					}
				}]
	});

	// 增加修改时弹出窗口
	var linkwin = new Ext.Window({
		title : '',
		width : 300,
		height : 150,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		//autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : linkWinForm,
		buttons : [{
			text : '保存',
			id : 'Link_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('Link_savebtn'),
			handler : function() {
				// -------添加----------
				if (linkwin.title == "添加") {
					
					linkWinForm.form.submit({
						url : Link_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'LINKParRef' : Ext.getCmp("Hidden_LocLink_CTLocID").getValue() //在打开的时候,已赋值
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								linkwin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocLinkLocation.getBottomToolbar().cursor;
												gridCTLocLinkLocation.getStore().baseParams = { // 解决gridCTLocLinkLocation不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													rowid : Ext.getCmp("Hidden_LocLink_CTLocID").getValue()
												};
												gridCTLocLinkLocation.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																linkrowid:myrowid
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
							linkWinForm.form.submit({
								url : Link_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										linkwin.hide();
										var myrowid = "linkrowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocLinkLocation.getBottomToolbar().cursor;
												gridCTLocLinkLocation.getStore().baseParams = { // 解决gridCTLocLinkLocation不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													rowid : Ext.getCmp("Hidden_LocLink_CTLocID").getValue()
												};
												Ext.BDP.FunLib.ReturnDataForUpdate("gridCTLocLinkLocation",Link_QUERY_ACTION_URL,myrowid);
												/*gridCTLocLinkLocation.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																linkrowid:myrowid
															}
														});*/
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
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				linkwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("link-form-save").getForm().findField("LINKCTLOCDR").focus(true, 300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				linkWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var linkbtnAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'LinkbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnAdd'),
		handler : function() {
			linkwin.setTitle('添加');
			linkwin.setIconClass('icon-add');
			linkwin.show();
			linkWinForm.getForm().reset();
		},
		scope : this
	});

	// 修改按钮
	var linkbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'LinkbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnUpdate'),
				handler : function() {
					if (gridCTLocLinkLocation.selModel.hasSelection()) {
						linkwin.setTitle('修改');
						linkwin.setIconClass('icon-update');
						linkwin.show();
						loadlinkFormData(gridCTLocLinkLocation);
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
	var linkbtnRefresh = new Ext.Button({
				id : 'LinkbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LinkbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					gridCTLocLinkLocation.getStore().baseParams={  //解决gridCTLocLinkLocation不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								rowid : Ext.getCmp("Hidden_LocLink_CTLocID").getValue()
					};
					gridCTLocLinkLocation.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var linkds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : Link_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'LINKRowId',
								mapping : 'LINKRowId',
								type : 'string'
							}, {
								name : 'LINKCTLOCDR',
								mapping : 'LINKCTLOCDR',
								type : 'string'
							}, {
								name : 'LINKParRef',
								mapping : 'LINKParRef',
								type : 'string'
							}])
			// remoteSort : true
			// sortInfo: {field : "CMCBMRowId",direction : "ASC"}
		});
	// ds.sort("CMCBMCode","DESC");

	// 加载数据
	linkds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var linkpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : linkds,
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

	var linksm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var linktbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [linkbtnAddwin, '-', linkbtnEditwin, '-',
						linkbtnDel, '-',linkbtnRefresh,{ //'科室ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_LocLink_CTLocID'
						},{ //医院id
							xtype : 'textfield',
							hidden:true,
							id:'hidden_LocLink_HOSPDR'
						},'-']
			});

	// 创建Grid
	var gridCTLocLinkLocation = new Ext.grid.GridPanel({
				//title : '手术关联医嘱项',
				id : 'gridCTLocLinkLocation',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : linkds,
				trackMouseOver : true,
				columns : [linksm, {
							header : 'LINKRowId',
							width : 70,
							sortable : true,
							dataIndex : 'LINKRowId',
							hidden : true
						}, {
							header : 'LINKParRef', //LINKParRef
							width : 80,
							sortable : true,
							dataIndex : 'LINKParRef',
							hidden : true
						}, {
							header : '关联科室',
							width : 80,
							sortable : true,
							dataIndex : 'LINKCTLOCDR'
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
				bbar : linkpaging,
				tbar : linktbbutton,
				stateId : 'gridCTLocLinkLocation'
			});
	Ext.BDP.FunLib.ShowUserHabit(gridCTLocLinkLocation,"User.CTLocLinkLocation");

	// 载入被选择的数据行的表单数据
	var loadlinkFormData = function(gridCTLocLinkLocation) {
		var _record = gridCTLocLinkLocation.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			linkWinForm.form.load({
						url : Link_OPEN_ACTION_URL + '&id='+ _record.get('LINKRowId'),
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

	gridCTLocLinkLocation.on("rowdblclick", function(grid, rowIndex, e) {
				linkwin.setTitle('修改');
				linkwin.setIconClass('icon-update');
				linkwin.show();
				loadlinkFormData(gridCTLocLinkLocation);
			});

	var linkwindow = new Ext.Window({
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
				items : gridCTLocLinkLocation
			});
	//----------------------子表完----------------------
	
    function getCTLocLinkLocationPanel(){
	var winCTLocLinkLocation = new Ext.Window({
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
			items: gridCTLocLinkLocation,
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
  	return winCTLocLinkLocation;
}

	