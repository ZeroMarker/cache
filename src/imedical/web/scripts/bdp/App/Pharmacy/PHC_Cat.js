
 	/// 名称:药学-6 药理学分类维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹 
	/// 编写日期:2012-8-30
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
 
Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PHC_Cat"
	});
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCCat&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCCat&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCCat";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCCat&pClassMethod=DeleteData";
	
	///药理学子分类 PHC_SubCat
	var PHCSC_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCSubCat&pClassQuery=GetList";
	var PHCSC_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCSubCat&pClassMethod=OpenData";
	var PHCSC_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCSubCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCSubCat";
	var PHCSC_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCSubCat&pClassMethod=DeleteData"; 
	
	///药理学小子分类PHC_MinorSubCat
	var MIN_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCMinorSubCat&pClassQuery=GetList";
	var MIN_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCMinorSubCat&pClassMethod=OpenData";
	var MIN_DELETE_ACTION_URL ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCMinorSubCat&pClassMethod=DeleteData"; 
	var MIN_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCMinorSubCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCMinorSubCat";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;

	Ext.QuickTips.init();												  //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.PHCCat";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PHC_Cat"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	//-----------------（别忘了后面的grid单击事件）翻译结束--------//
	/////////////////////////////日志查看 ////////////////////////////////////////
	var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
	var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName)  
   
	///日志查看按钮是否显示
	var btnlogflag=Ext.BDP.FunLib.ShowBtnOrNotFun();
	if (btnlogflag==1)
	{
		btnlog.hidden=false;
	}
    else
    {
       btnlog.hidden=true;
    }
	/// 数据生命周期按钮 是否显示
	var btnhislogflag= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
	if (btnhislogflag ==1)
	{
		btnhislog.hidden=false;
	}
    else
    {
		btnhislog.hidden=true;
	}  
	btnhislog.on('click', function(btn,e){    
		var RowID="",Desc="";
		if (grid.selModel.hasSelection()) {
			var rows = grid.getSelectionModel().getSelections(); 
			RowID=rows[0].get('PHCCRowId');
			Desc=rows[0].get('PHCCDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
	//---------------------------------------------药理学小子分类--------------------------------------	
	
	// 删除功能
	var minbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'MIN_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('MIN_del_btn'),
		handler : function() {
			if (mingrid.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = mingrid.getSelectionModel();
						var rows = gsm.getSelections();
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : MIN_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('MINRowId')
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
												
												var startIndex = mingrid.getBottomToolbar().cursor;
												var totalnum=mingrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=mingrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												mingrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1,
																minparref : phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId')  
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
	var minWinForm = new Ext.FormPanel({
		id : 'min-form-save',
		//baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'MINCode',
							mapping : 'MINCode'
						}, {
							name : 'MINDesc',
							mapping : 'MINDesc'
						}, {
							name : 'MINRowId',
							mapping : 'MINRowId'
						}, {
							name : 'MINParRef',
							mapping : 'MINParRef'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'MINRowId',
					xtype : 'textfield',
					fieldLabel : 'MINRowId',
					name : 'MINRowId',
					hideLabel : 'True',
					hidden : true
		},{
					id : 'MINParRef',
					xtype : 'textfield',
					fieldLabel : 'MINParRef',
					name : 'MINParRef',
					hideLabel : 'True',
					hidden : true	
				}, {
					fieldLabel : '<font color=red>*</font>代码',
					xtype:'textfield',
					id:'MINCode',
					maxLength:15,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('MINCode'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MINCode'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MINCode')),
					name : 'MINCode',
					allowBlank:false
				}, {
					fieldLabel : '<font color=red>*</font>描述',
					xtype:'textfield',
					id:'MINDesc',
					maxLength:220,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('MINDesc'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('MINDesc'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('MINDesc')),
					name : 'MINDesc',
					allowBlank:false
				}]
	});

	// 增加修改时弹出窗口
	var minwin = new Ext.Window({
		title : '',
		width : 280,
		height : 220,
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
		items : minWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id : 'MIN_savebtn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('MIN_savebtn'),
			handler : function() {
				if(minWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				// -------添加----------
				if (minwin.title == "添加") {
					minWinForm.form.submit({
						url : MIN_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'MINParRef' : phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId')
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								minwin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = mingrid.getBottomToolbar().cursor;
												mingrid.getStore().baseParams={
													minparref : phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId')
												};
												mingrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
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
							minWinForm.form.submit({
								url : MIN_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										minwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = mingrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("mingrid",MIN_ACTION_URL,myrowid)
												/*mingrid.getStore().baseParams={
													minparref : phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId')
												};
												mingrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
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
				minwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("min-form-save").getForm().findField("MINCode").focus(true, 300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				minWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var minbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id : 'MIN_addbtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('MIN_addbtn'),
				handler : function() {
					minwin.setTitle('添加');
					minwin.setIconClass('icon-add');
					minwin.show();
					
					minWinForm.getForm().reset();

				},
				scope : this
			});

	// 修改按钮
	var minbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'MIN_updatebtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('MIN_updatebtn'),
				handler : function() {
					if (mingrid.selModel.hasSelection()) {
						minwin.setTitle('修改');
						minwin.setIconClass('icon-update');
						minwin.show();
						loadminFormData(mingrid);
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
	var minbtnRefresh = new Ext.Button({
				id : 'MINbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('MINbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					mingrid.getStore().baseParams={
								minparref : phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId')	
					};
					mingrid.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	var minds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : MIN_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'MINRowId',
								mapping : 'MINRowId',
								type : 'string'
							}, {
								name : 'MINParRef',
								mapping : 'MINParRef',
								type : 'string'	
							}, {
								name : 'MINCode',
								mapping : 'MINCode',
								type : 'string'	
							}, {
								name : 'MINDesc',
								mapping : 'MINDesc',
								type : 'string'
							}])
			// remoteSort : true
		});

	// 加载数据
	minds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var minpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : minds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize1=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
			});

	var minsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var mintbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [minbtnAddwin, '-', minbtnEditwin, '-',minbtnDel, '-',minbtnRefresh,'-']
			});

	// 创建Grid
	var mingrid = new Ext.grid.GridPanel({
				title : '药理学小子分类',
				id : 'mingrid',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : minds,
				trackMouseOver : true,
				columns : [minsm, {
							header : 'MINRowId',
							width : 70,
							sortable : true,
							dataIndex : 'MINRowId',
							hidden : true
						}, {
							header : 'MINParRef',
							width : 80,
							sortable : true,
							dataIndex : 'MINParRef',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'MINCode'
						}, {
							header : '描述',
							width : 80,
							sortable : true,
							dataIndex : 'MINDesc'
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
				bbar : minpaging,
				tbar : mintbbutton,
				stateId : 'mingrid'
			});
	Ext.BDP.FunLib.ShowUserHabit(mingrid,"User.PHCMinorSubCat");
	// 载入被选择的数据行的表单数据
	var loadminFormData = function(mingrid) {
		var _record = mingrid.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			minWinForm.form.load({
						url : MIN_OPEN_ACTION_URL + '&id='+ _record.get('MINRowId'),
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

	mingrid.on("rowdblclick", function(grid, rowIndex, e) {
				minwin.setTitle('修改');
				minwin.setIconClass('icon-update');
				minwin.show();
				loadminFormData(mingrid);
			});

	var minwindow = new Ext.Window({
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
				items : mingrid
			});
	var minbtn = new Ext.Toolbar.Button({
				text : '药理学小子分类',
				tooltip : '药理学小子分类',
				//iconCls : 'icon-add',
				id : 'btnMIN',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMIN'),
				handler : function() {
					if (phcscgrid.selModel.hasSelection()) {
					var gsm = phcscgrid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					minwindow.setTitle(rows[0].get('PHCSCDesc'));
					
					var minparref1=phcscgrid.getSelectionModel().getSelected().get('PHCSCRowId');
					//Ext.getCmp("MINParRef").setValue(minparref1);
					minds.removeAll();
					mingrid.getStore().baseParams={  //解决表格不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								minparref : minparref1
					};
					minds.load({
								params : {
									limit : pagesize1,
									statr:0
								}
							});
					minwindow.show();
					
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择药理学子分类！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				},
				scope : this
			});
		
	// ------------------------------------------药理学小子分类（完）-----------------------------------------------------
	//---------------------------------------------药理学子分类--------------------------------------	
	// 删除功能
	var phcscbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'sub_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn'),
		handler : function() {
			if (phcscgrid.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = phcscgrid.getSelectionModel();
						var rows = gsm.getSelections();
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : PHCSC_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHCSCRowId')
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
												var startIndex = phcscgrid.getBottomToolbar().cursor;
												var totalnum=phcscgrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=phcscgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												phcscgrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1,
																phcscparref : grid.getSelectionModel().getSelected().get('PHCCRowId')
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
	var phcscWinForm = new Ext.FormPanel({
		id : 'phcsc-form-save',
		//baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'PHCSCCode',
							mapping : 'PHCSCCode'
						}, {
							name : 'PHCSCDesc',
							mapping : 'PHCSCDesc'
						}, {
							name : 'PHCSCRowId',
							mapping : 'PHCSCRowId'
						}, {
							name : 'PHCSCPHCCParRef',
							mapping : 'PHCSCPHCCParRef'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'PHCSCRowId',
					xtype : 'textfield',
					fieldLabel : 'PHCSCRowId',
					name : 'PHCSCRowId',
					hideLabel : 'True',
					hidden : true
		},{
					id : 'PHCSCPHCCParRef',
					xtype : 'textfield',
					fieldLabel : 'PHCSCPHCCParRef',
					name : 'PHCSCPHCCParRef',
					hideLabel : 'True',
					hidden : true	
				}, {
					fieldLabel : '<font color=red>*</font>代码',
					xtype:'textfield',
					id:'PHCSCCode',
					maxLength:15,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCSCCode'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCSCCode'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCSCCode')),
					name : 'PHCSCCode',
					allowBlank:false
				}, {
					fieldLabel : '<font color=red>*</font>描述',
					xtype:'textfield',
					id:'PHCSCDesc',
					maxLength:220,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCSCDesc'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCSCDesc'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCSCDesc')),
					name : 'PHCSCDesc',
					allowBlank:false
				}]
	});

	// 增加修改时弹出窗口
	var phcscwin = new Ext.Window({
		title : '',
		width : 280,
		height : 220,
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
		items : phcscWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id : 'sub_savebtn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
			handler : function() {
				if(phcscWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				// -------添加----------
				if (phcscwin.title == "添加") {
					phcscWinForm.form.submit({
						url : PHCSC_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'PHCSCPHCCParRef' : grid.getSelectionModel().getSelected().get('PHCCRowId')
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								phcscwin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = phcscgrid.getBottomToolbar().cursor;
												phcscgrid.getStore().baseParams={  //解决phcscgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													phcscparref : grid.getSelectionModel().getSelected().get('PHCCRowId')
												};
												phcscgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
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
							phcscWinForm.form.submit({
								url : PHCSC_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										phcscwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = phcscgrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("phcscgrid",PHCSC_ACTION_URL,myrowid)
												/*phcscgrid.getStore().baseParams={  //解决phcscgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													phcscparref : grid.getSelectionModel().getSelected().get('PHCCRowId')
												};
												phcscgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
															}
														});*/
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
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
				phcscwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("phcsc-form-save").getForm().findField("PHCSCCode").focus(true, 300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				phcscWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var phcscbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id : 'sub_addbtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn'),
				handler : function() {
					phcscwin.setTitle('添加');
					phcscwin.setIconClass('icon-add');
					phcscwin.show();
					phcscWinForm.getForm().reset();

				},
				scope : this
			});

	// 修改按钮
	var phcscbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'sub_updatebtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn'),
				handler : function() {
					if (phcscgrid.selModel.hasSelection()) {
						phcscwin.setTitle('修改');
						phcscwin.setIconClass('icon-update');
						phcscwin.show();
						loadphcscFormData(phcscgrid);
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
	var phcscbtnRefresh = new Ext.Button({
				id : 'subbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('subbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					
					phcscgrid.getStore().baseParams={
						phcscparref : grid.getSelectionModel().getSelected().get('PHCCRowId')	
					};
					phcscgrid.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
								
						}
					});
				}
	});
	var phcscds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : PHCSC_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'PHCSCRowId',
								mapping : 'PHCSCRowId',
								type : 'string'
							}, {
								name : 'PHCSCPHCCParRef',
								mapping : 'PHCSCPHCCParRef',
								type : 'string'	
							}, {
								name : 'PHCSCCode',
								mapping : 'PHCSCCode',
								type : 'string'	
							}, {
								name : 'PHCSCDesc',
								mapping : 'PHCSCDesc',
								type : 'string'
							}])
			// remoteSort : true
		});

	// 加载数据
	phcscds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var phcscpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : phcscds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize1=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
			});

	var phcscsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var phcsctbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [phcscbtnAddwin, '-', phcscbtnEditwin, '-',
						phcscbtnDel, '-',phcscbtnRefresh,'-',minbtn,'-']
			});

	// 创建Grid
	var phcscgrid = new Ext.grid.GridPanel({
				title : '药理学子分类',
				id : 'phcscgrid',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : phcscds,
				trackMouseOver : true,
				columns : [phcscsm, {
							header : 'PHCSCRowId',
							width : 70,
							sortable : true,
							dataIndex : 'PHCSCRowId',
							hidden : true
						}, {
							header : 'PHCSCPHCCParRef',
							width : 80,
							sortable : true,
							dataIndex : 'PHCSCPHCCParRef',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'PHCSCCode'
						}, {
							header : '描述',
							width : 80,
							sortable : true,
							dataIndex : 'PHCSCDesc'
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
				bbar : phcscpaging,
				tbar : phcsctbbutton,
				stateId : 'phcscgrid'
			});
	Ext.BDP.FunLib.ShowUserHabit(phcscgrid,"User.PHCSubCat");
	
	// 载入被选择的数据行的表单数据
	var loadphcscFormData = function(phcscgrid) {
		var _record = phcscgrid.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			phcscWinForm.form.load({
						url : PHCSC_OPEN_ACTION_URL + '&id='+ _record.get('PHCSCRowId'),
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

	phcscgrid.on("rowdblclick", function(grid, rowIndex, e) {
				phcscwin.setTitle('修改');
				phcscwin.setIconClass('icon-update');
				phcscwin.show();
				loadphcscFormData(phcscgrid);
			});

	var phcscwindow = new Ext.Window({
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
				items : phcscgrid
			});
	var phcscbtn = new Ext.Toolbar.Button({
				text : '药理学子分类',
				tooltip : '药理学子分类',
				//iconCls : 'icon-add',
				id : 'btnPHCSC',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPHCSC'),
				handler : function() {
				if (grid.selModel.hasSelection()) {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					phcscwindow.setTitle(rows[0].get('PHCCDesc'));
					
					var phcscparref1=grid.getSelectionModel().getSelected().get('PHCCRowId');
					//Ext.getCmp("PHCSCPHCCParRef").setValue(phcscparref1);
					phcscds.removeAll();
					phcscgrid.getStore().baseParams={  //解决linkgrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								phcscparref : phcscparref1
					};
					
					phcscds.load({
								params : {
									limit : pagesize1,start : 0
								}
							});
					phcscwindow.show();
					// ds.load();
					
					
					
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择药理学分类！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				},
				scope : this
			});
		
	// ------------------------------------------药理学子分类（完）-----------------------------------------------------
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	/**---------在删除按钮下实现删除功能--------------*/
	var btnDel = new Ext.Toolbar.Button({                                 //-------创建一个删除按钮 
		text : '删除',													  //-------按钮的内容
		tooltip : '删除',												  //-------工具提示或说明
		iconCls : 'icon-delete',										  //-------给一个空间用来显示图标
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function (){											  //指定事件处理的函数,点击删除按钮后执行后面的函数
			if (grid.selModel.hasSelection()) {                           //-------如果选中某一行则继续执行删除操作
				
				/**Ext.MessageBox.confirm------------------------------------------用来弹出一个提示框() 
				  *调用格式： confirm(String title,String msg,[function fn],[Object scope]) 
				  */
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   //-------点击确定按钮后继续执行删除操作
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示'); //-------wait框
						var gsm = grid.getSelectionModel();				  // ------获取选择列
						var rows = gsm.getSelections();					  //-------根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('PHCCRowId');
						AliasGrid.delallAlias();
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('PHCCRowId')          //-------通过RowId来删除数据
							},
							
							/**callback : Function （可选项）(Optional) 
                                       *该方法被调用时附上返回的http response对象
                                       *该函数中传入了如下参数：
                                       *options : Object  //-----------------------请求所调用的参数
                                       *success : Boolean //-----------------------请求成功则为true
                                       *response : Object //-----------------------包含了返回数据的xhr(XML Http Request)对象
                                       **/
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              //-------请求成功									
									var jsonData = Ext.util.JSON.decode(response.responseText);//------获取返回的信息
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,          //-------显示图标样式(信息图标)
											buttons : Ext.Msg.OK,         //-------只显示一个确定按钮
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												
											}
										});
									} else {						     //--------如果返回的是错误的请求
										var errorMsg = '';
										if (jsonData.info) {			//---------获取传递来的错误信息
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,//--------显示图标样式(错误图标)
													buttons : Ext.Msg.OK//---------只有一个确定按钮
												});
									}
								} else {							    //---------删除失败提示错误信息
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,    //--------显示图标样式(错误图标)
												buttons : Ext.Msg.OK     //--------只有一个确定按钮
											});
								}
							}
						}, this);
					}
				}, this);
			} else {												   
				Ext.Msg.show({										     //--------没有选择行记录的时候
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	/**---------创建一个供增加和修改使用的form-----------*/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',	                                     //--------FORM标签的id									
				//collapsible : true,
				//title : '数据信息',
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				title:'基本信息',
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 75,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				reader: new Ext.data.JsonReader({root:'list'},           //-------使用open方法要在form中加上数据的映射
                                        [{name: 'PHCCRowId',mapping:'PHCCRowId',type:'string'},
                                         {name: 'PHCCCode',mapping:'PHCCCode',type:'string'},
                                         {name: 'PHCCDesc',mapping:'PHCCDesc',type:'string'}
                                        ]),
				defaultType : 'textfield',								 //--------统一设定items类型为textfield
				items : [{
							id:'PHCCRowId',
							fieldLabel : 'PHCCRowId',
							hideLabel : 'True',
							hidden : true,                               //--------RowId属性隐藏
							name : 'PHCCRowId'
						}, {
							id:'PHCCCodeF',
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHCCCode',
							id:'PHCCCodeF',
							maxLength:15,
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCCCodeF'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCCCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCCCodeF')),
							allowBlank: false,
							enableKeyEvents:true, 
 							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCCat";
	                            var classMethod = "FormValidate";                     
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCCRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
					}, {
							id:'PHCCDescF',
							fieldLabel : '<font color=red>*</font>描述',
							name : 'PHCCDesc',
							id:'PHCCDescF',
							maxLength:220,
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCCDescF'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCCDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCCDescF')),
							allowBlank: false,
							enableKeyEvents:true, 
						    validationEvent : 'blur',  
						    validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCCat";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCCRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						    
						}]
			});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });		
	/**---------增加、修改操作弹出的窗口-----------*/
	var win = new Ext.Window({
		title : '',
		width : 280,
		//height : 150,
		layout : 'fit',													//----------布局会充满整个窗口，组件自动根据窗口调整大小
		plain : true,                                                   //----------true则主体背景透明
		modal : true,//在页面上放置一层遮罩,确保用户只能跟window交互
		frame : true,													//----------win具有全部阴影，若为false则只有边框有阴影
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',										   //-----------关闭窗口后执行隐藏命令
		items : tabs,											   //-----------将增加和修改的表单加入到win窗口中
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			//formBind:true,
			handler : function() {									   //-----------保存按钮下调用的函数
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				/**-------添加部分操作----------*/	 
				if (win.title == "添加") {                                         //？？？可以换个判断方式
					WinForm.form.submit({
						clientValidation : true,                       //-----------进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,						//----------发出请求的路径（保存数据）
						method : 'POST',
						
						/**下面有两种不同类型的success对象其表示的意义有所不同
						 * ①是submit的一个配置选项 表示服务器成功响应。不管你响应给客户端的内容是什么，
						 * ---------------------------------------只要响应成功就会执行这个success，跟你返回的内容无关
						 * ②是根据返回json中success属性判断的，如果success为true，则success否则 failure
						 */
						success : function(form, action) {              
							if (action.result.success == 'true') {    //如果json中success属性返回的为true
								win.hide();
								var myrowid = action.result.id;		  
								// var myrowid = jsonData.id;
								Ext.Msg.show({						  //------------做一个文本提示框
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,	  //------------图标显示（信息图标样式）
											buttons : Ext.Msg.OK,     //------------只有一个确定按钮的样式
											fn : function(btn) {      //------------回调函数参数为button的Id
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数
												grid.getStore().load({ //-----------重新载入数据         
															params : { //-----------参数
																start : 0,
																limit : pagesize,
																rowid : myrowid   //新添加的数据rowid
															}
														});
											}
										});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} 
							else {									//--------------如果jason中success属性返回的不是true
								var errorMsg = '';
								if (action.result.errorinfo) {      //--------------保存返回的错误信息
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提 示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
							}
						},
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {			//--------------服务器端响应失败
							 /*if(action.failureType == 'client'){
                                  //客户端数据验证失败的情况下
                                      Ext.Msg.alert('提示','数据验证失败，<br/>请检查您的数据格式是否有误！');
								}
								else*/ Ext.Msg.alert('提示', '添加失败！');
						}
					})
				} 
				/**---------修改部分操作(操作过程与增加类似，重复代码不再注释)-------*/
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({                   //---------------确定修改后，将表单的数据提交
								clientValidation : true,            //---------------进行客户端验证
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												// salert(action.result);
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});*/
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
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
									/*if(action.failureType == 'client'){
                                     //客户端数据验证失败的情况下
                                      Ext.Msg.alert('提示','数据验证失败，<br/>请检查您的数据格式是否有误！');
								}
								else */Ext.Msg.alert('提示', '修改失败！');
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
				Ext.getCmp("form-save").getForm().findField("PHCCCode").focus(true,300);
				// grid.setDisabled(true); // ----------------------Form打开后grid灰化
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag;
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		} 
	});
	
	/**---------增加按钮-----------*/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {                              //------------在函数中调用添加窗口
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();					    //------------添加首先要将表单重置清空一下
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
		            
				},
				scope : this										//------------作用域
			});
	/**---------修改按钮-----------*/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					if (grid.selModel.hasSelection()) {
					loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('PHCCRowId');
				        AliasGrid.loadGrid();
				       
						}
				        else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	/*
	var btnPHCSC = new Ext.Button({
				id : 'btnPHCSC',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnPHCSC'),
				text : '药理学子分类',
				iconCls : 'icon-arrowrefresh',
				handler : function() {
					loadGridData(grid);
				}
			});
	var btnMIN = new Ext.Button({
				id : 'btnMIN',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMIN'),
				text : '药理学小子分类',
				iconCls : 'icon-arrowrefresh',
				handler : function() {
					loadMGridData(MSCGrid);
				}
			});*/
			
	//---------列的映射
	var fields=[{
									name : 'PHCCRowId',
									mapping : 'PHCCRowId',
									type : 'string'
								}, {
									name : 'PHCCCode',
									mapping : 'PHCCCode',
									type : 'string'
								}, {
									name : 'PHCCDesc',
									mapping : 'PHCCDesc',
									type : 'string'
								}
						]		
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
	var ds = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : ACTION_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields)
				//remoteSort : true										  //----------排序
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
		/**-------------------加载数据-----------------*/
	ds.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,	
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},										     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	/**---------增删改工具条-----------*/
	var tbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',phcscbtn
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
		
		})
		
		
	/**---------搜索按钮-----------*/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  //-----------执行回调函数
				grid.getStore().baseParams={							//-----------模糊查询		
						code : Ext.getCmp("TextCode").getValue()
								,
						desc :  Ext.getCmp("TextDesc").getValue()
									
				};
				grid.getStore().load({									//-----------加载查询出来的数据
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}

			});
			
	/**---------刷新按钮-----------*/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					Ext.BDP.FunLib.SelectRowId ="";
					Ext.getCmp("TextCode").reset();						//-----------将输入框清空
					Ext.getCmp("TextDesc").reset();                     //-----------将输入框清空
					grid.getStore().baseParams={};
					grid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

			});
			
	/**---------将工具条放在一起-----------*/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						 '-',
						'描述', {
							xtype : 'textfield',
							emptyText : '描述/别名',id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},
						'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	var  GridCM=[sm, {									//----------------定义列
							header : 'PHCC_RowId',
							width : 100,
							sortable : true,
							dataIndex : 'PHCCRowId',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'PHCCCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCCDesc'
						}]
	/**---------创建grid-----------*/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				closable : true,
				store : ds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns :GridCM,
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				title : '药理学分类',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHCCForeignDesc',
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid'
			});
			
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	

	/**---------双击事件-----------*/
   grid.on("rowdblclick", function(grid, rowIndex, e) { 
        loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('PHCCRowId');
	        AliasGrid.loadGrid();
			
    });
				//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('PHCCRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});
    /**--------载入被选择的数据行的表单数据(后台调用OpenData方法)---------------*/
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
               Ext.Msg.alert('提示', '请选择要修改的行！');
        } else {
        	win.setTitle('修改');
        	win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&PHCCRowId='+ _record.get('PHCCRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败！');
                }
            });
        }
    };
    	
			
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);		
			
	/**---------创建viewport-----------*/
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	

});
