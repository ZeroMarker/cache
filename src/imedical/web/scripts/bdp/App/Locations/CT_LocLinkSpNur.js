/// 名称: 科室-专项护理	CTLocLinkSpNur
/// 描述: 关联专项护理弹窗	
/// 项目：重庆人民医院，科室病区添加专项护理按钮
/// 编写者： 基础数据平台组 李可凡
/// 编写日期:2019年8月30日


/**----------------------------------专项护理部分--------------------------------------**/	
  
	
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var SpNur_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkSpNur&pClassQuery=GetList";
	var SpNur_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkSpNur&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocLinkSpNur";	
	var SpNur_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkSpNur&pClassMethod=DeleteData";
	var SpNur_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocLinkSpNur&pClassMethod=OpenData";
	var SpNur_DR_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSpecialNursing&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
 	//---------------------子表：专项护理-------------------------
	// 删除功能
	var SpNurbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'SpNurbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNurbtnDel'),
		handler : function() {
			if (gridCTLocLinkSpNur.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = gridCTLocLinkSpNur.getSelectionModel();
						var rows = gsm.getSelections();
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : SpNur_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('SpNurRowId')
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
												Ext.BDP.FunLib.DelForTruePage(gridCTLocLinkSpNur,pagesize);	
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
	var SpNurWinForm = new Ext.FormPanel({
		id : 'SpNur-form-save',
		URL : SpNur_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'SpNurParRef',
							mapping : 'SpNurParRef'
						}, {
							name : 'SpNurDR',
							mapping : 'SpNurDR'
						}, {
							name : 'SpNurRowId',
							mapping : 'SpNurRowId'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'SpNurRowId',
					xtype : 'textfield',
					fieldLabel : 'SpNurRowId',
					name : 'SpNurRowId',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'SpNurParRef',
					xtype : 'textfield',
					fieldLabel : 'SpNurParRef',
					name : 'SpNurParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					xtype : "bdpcombo",
					emptyText : '请选择',
					fieldLabel : '<font color=red>*</font>专项护理',
					allowBlank:false,
					id: 'SpNurDR1',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNurDR'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SpNurDR'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SpNurDR')),
					hiddenName : 'SpNurDR',
					listWidth : 300,
					store : new Ext.data.Store({
								autoLoad : true,
								baseParams:{communityid:communityid},
								proxy : new Ext.data.HttpProxy({
											url : SpNur_DR_URL
										}),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{
													name : 'SpecialNursingRowId',
													mapping : 'SpecialNursingRowId'
												}, {
													name : 'SpecialNursingDesc',
													mapping : 'SpecialNursingDesc'
												}])
							}),
					mode : 'local',
					shadow : false,
					forceSelection : true,
					triggerAction : 'all',
					queryParam : 'desc',
					// hideTrigger: false,
					displayField : 'SpecialNursingDesc',
					valueField : 'SpecialNursingRowId'
				}]
	});

	// 增加修改时弹出窗口
	var SpNurwin = new Ext.Window({
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
		items : SpNurWinForm,
		buttons : [{
			text : '保存',
			id : 'SpNur_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNur_savebtn'),
			handler : function() {
				// -------添加----------
				if (SpNurwin.title == "添加") {
					
					SpNurWinForm.form.submit({
						url : SpNur_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'SpNurParRef' : Ext.getCmp("Hidden_SpNur_CTLocID").getValue() //在打开的时候,已赋值
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								SpNurwin.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocLinkSpNur.getBottomToolbar().cursor;
												gridCTLocLinkSpNur.getStore().baseParams = { // 解决gridCTLocLinkSpNur不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_SpNur_CTLocID").getValue()
												};
												gridCTLocLinkSpNur.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																spnurrowid:myrowid
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
							SpNurWinForm.form.submit({
								url : SpNur_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										SpNurwin.hide();
										var myrowid = "spnurrowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLocLinkSpNur.getBottomToolbar().cursor;
												gridCTLocLinkSpNur.getStore().baseParams = { // 解决gridCTLocLinkSpNur不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_SpNur_CTLocID").getValue()
												};
												Ext.BDP.FunLib.ReturnDataForUpdate("gridCTLocLinkSpNur",SpNur_QUERY_ACTION_URL,myrowid);
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
				SpNurwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				SpNurWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var SpNurbtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'SpNurbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNurbtnAdd'),
		handler : function() {
			SpNurwin.setTitle('添加');
			SpNurwin.setIconClass('icon-add');
			SpNurwin.show();
			SpNurWinForm.getForm().reset();
		},
		scope : this
	});

	// 修改按钮
	var SpNurbtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'SpNurbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNurbtnUpdate'),
				handler : function() {
					if (gridCTLocLinkSpNur.selModel.hasSelection()) {
						SpNurwin.setTitle('修改');
						SpNurwin.setIconClass('icon-update');
						SpNurwin.show();
						loadSpNurFormData(gridCTLocLinkSpNur);
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
	var SpNurbtnRefresh = new Ext.Button({
				id : 'SpNurbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SpNurbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					gridCTLocLinkSpNur.getStore().baseParams={  //解决gridCTLocLinkSpNur不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								parref : Ext.getCmp("Hidden_SpNur_CTLocID").getValue()
					};
					gridCTLocLinkSpNur.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var SpNurds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : SpNur_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'SpNurRowId',
								mapping : 'SpNurRowId',
								type : 'string'
							}, {
								name : 'SpNurDR',
								mapping : 'SpNurDR',
								type : 'string'
							}, {
								name : 'SpNurParRef',
								mapping : 'SpNurParRef',
								type : 'string'
							}])
			// remoteSort : true
			// sortInfo: {field : "CMCBMRowId",direction : "ASC"}
		});
	// ds.sort("CMCBMCode","DESC");

	// 加载数据
	SpNurds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var SpNurpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : SpNurds,
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

	var SpNursm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var SpNurtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [SpNurbtnAdd, '-', SpNurbtnEdit, '-',
						SpNurbtnDel, '-',SpNurbtnRefresh,{ //'科室ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_SpNur_CTLocID'
						},'-']
			});

	// 创建Grid
	var gridCTLocLinkSpNur = new Ext.grid.GridPanel({
				id : 'gridCTLocLinkSpNur',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : SpNurds,
				trackMouseOver : true,
				columns : [SpNursm, {
							header : 'SpNurRowId',
							width : 70,
							sortable : true,
							dataIndex : 'SpNurRowId',
							hidden : true
						}, {
							header : 'SpNurParRef', //SpNurParRef
							width : 80,
							sortable : true,
							dataIndex : 'SpNurParRef',
							hidden : true
						}, {
							header : '专项护理',
							width : 80,
							sortable : true,
							dataIndex : 'SpNurDR'
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
				bbar : SpNurpaging,
				tbar : SpNurtbbutton,
				stateId : 'gridCTLocLinkSpNur'
			});
	Ext.BDP.FunLib.ShowUserHabit(gridCTLocLinkSpNur,"User.CTLocLinkSpNur");

	// 载入被选择的数据行的表单数据
	var loadSpNurFormData = function(gridCTLocLinkSpNur) {
		var _record = gridCTLocLinkSpNur.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			SpNurWinForm.form.load({
						url : SpNur_OPEN_ACTION_URL + '&id='+ _record.get('SpNurRowId'),
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

	gridCTLocLinkSpNur.on("rowdblclick", function(grid, rowIndex, e) {
				SpNurwin.setTitle('修改');
				SpNurwin.setIconClass('icon-update');
				SpNurwin.show();
				loadSpNurFormData(gridCTLocLinkSpNur);
			});

	var SpNurwindow = new Ext.Window({
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
				items : gridCTLocLinkSpNur
			});
	//----------------------子表完----------------------
	
    function getCTLocLinkSpNurPanel(){
	var winCTLocLinkSpNur = new Ext.Window({
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
			items: gridCTLocLinkSpNur,
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
  	return winCTLocLinkSpNur;
}

	