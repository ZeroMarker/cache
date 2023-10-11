/// 名称: 医院楼层表-医院楼的子表
/// 描述: 医院楼层弹窗
/// 编写者： 基础数据平台-李可凡
/// 编写日期:2020年8月31日

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var CTLBF_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassQuery=GetList";
	var CTLBF_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLocBuildingFloor";	
	var CTLBF_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassMethod=DeleteData";
	var CTLBF_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLocBuildingFloor&pClassMethod=OpenData";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
	///单独定义翻译按钮
	/************************************ 翻译按钮开始************************************/	
	var btnTransFloor= new Ext.Toolbar.Button({
				text : $g('翻译'),
				tooltip : $g('翻译'),
				id:'translation_btnfloor',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('translation_btnfloor'),
				iconCls : 'icon-edit',
				handler : function OpenTransWin() {
					if(gridCTLBF.selModel.hasSelection()){
						var gsm = gridCTLBF.getSelectionModel();
						var rows = gsm.getSelections();
						var row = rows[0].get('CTLBFRowId');
						 var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPTranslation&selectrow="+row+"&tableName=CTLoc_BuildingFloor";
						 if ('undefined'!==typeof websys_getMWToken)
						{
							link += "&MWToken="+websys_getMWToken() //增加token  
						}
						 var TransWin = new Ext.Window({
								width:650,
					            height:400,
					            id:'TransWin',
					            title:'',
							   	layout : 'fit',
								plain : true,// true则主体背景透明
								modal : true,
								frame : true,
							    autoScroll : false,
								collapsible : true,
								hideCollapseTool : true,
								titleCollapse : true,
								constrain : true,
								closeAction : 'close',
								html : '<iframe src=" '+link+' " width="100%" height="100%"></iframe>'
							});
						//TransWin.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';						
						TransWin.setTitle($g('数据翻译'));
						TransWin.setIconClass('icon-edit');
						TransWin.show();				
					}else{
						Ext.Msg.show({
									title : $g('提示'),
									msg : $g('请选择需要翻译的行！'),
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
			
	var TransFlagFloor =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation","CTLoc_BuildingFloor");
	if(TransFlagFloor=="false"){
		btnTransFloor.hidden=false;
	}else{
		btnTransFloor.hidden=true;
	}
	
/************************************ 翻译按钮结束************************************/		
	
	// 删除功能
	var CTLBFbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'CTLBFbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFbtnDel'),
		handler : function() {
			if (gridCTLBF.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridCTLBF.getSelectionModel();
						var rows = gsm.getSelections();
						Ext.Ajax.request({
							url : CTLBF_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTLBFRowId')
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
												Ext.BDP.FunLib.DelForTruePage(gridCTLBF,pagesize);	
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
	var CTLBFWinForm = new Ext.FormPanel({
		id : 'CTLBF-form-save',
		URL : CTLBF_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'CTLBFParRef',
							mapping : 'CTLBFParRef'
						}, {
							name : 'CTLBFRowId',
							mapping : 'CTLBFRowId'
						}, {
							name : 'CTLBFFloor',
							mapping : 'CTLBFFloor'
						}, {
							name : 'CTLBFDateFrom',
							mapping : 'CTLBFDateFrom'
						}, {
							name : 'CTLBFDateTo',
							mapping : 'CTLBFDateTo'
						}, {
							name : 'CTLBFMark',
							mapping : 'CTLBFMark'
						}]),
		defaults : {
			anchor : '90%',
			bosrder : false
		},
		items : [{
					id : 'CTLBFParRef',
					xtype : 'textfield',
					fieldLabel : 'CTLBFParRef',
					hideLabel : 'True',
					hidden : true,
					name : 'CTLBFParRef'
				}, {
					id : 'CTLBFRowId',
					xtype : 'textfield',
					fieldLabel : 'CTLBFRowId',
					hideLabel : 'True',
					hidden : true,
					name : 'CTLBFRowId'
				}, {
					xtype : 'textfield',
					fieldLabel: "<span style='color:red;'>*</span>楼层",
					name: 'CTLBFFloor',
					id:'CTLBFFloor',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLBFFloor')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLBFFloor'),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFFloor'),
					allowBlank : false,
					blankText: '楼层不能为空',
					enableKeyEvents:true, 
					validationEvent : 'blur',
					validator : function(thisText){
						if(thisText==""){ //当文本框里的内容为空的时候不用此验证
							return true;
						}
						var className =  "web.DHCBL.CT.CTLocBuildingFloor";
						var classMethod = "FormValidate";
						var parreftext = Ext.getCmp("Hidden_CTLBFParRef").getValue()
						var id="";
						if(CTLBFwin.title=='修改'){
							var _record = gridCTLBF.getSelectionModel().getSelected();
							var id = _record.get('CTLBFRowId');
						}
						var flag = "";
						var flag = tkMakeServerCall(className,classMethod,parreftext,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
						if(flag == "1"){
							return false;
						 }else{
							return true;
						 }
					},
					invalidText : '该描述已经存在',
					listeners : {
						'change' : Ext.BDP.FunLib.Component.ReturnValidResult
					}
				}, {
					xtype : 'textfield',
					fieldLabel: "备注",
					name: 'CTLBFMark',
					id:'CTLBFMark',
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLBFMark')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLBFMark')
				}, {
					xtype: 'datefield',
					fieldLabel: "<span style='color:red;'>*</span>开始日期",
					allowBlank : false,
					name: 'CTLBFDateFrom',
					id:'CTLBFDateFrom',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateFrom'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateFrom')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateFrom'),
					dataIndex : 'CTLBFDateFrom',
					format: BDPDateFormat,
					enableKeyEvents : true,
					listeners : {
						'keyup' : function(field, e){
						Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
						}
					}
				}, {
					xtype:'datefield',
					fieldLabel: '结束日期',
					name: 'CTLBFDateTo',
					id:'CTLBFDateTo',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateTo'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateTo')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTLBFDateTo'),
					dataIndex : 'CTLBFDateTo',
					format: BDPDateFormat,
					enableKeyEvents : true,
					listeners : {
						'keyup' : function(field, e){
						Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
						}
					}
				}]
	});

	// 增加修改时弹出窗口
	var CTLBFwin = new Ext.Window({
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
		items : CTLBFWinForm,
		buttons : [{
			text : '保存',
			id : 'CTLBF_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBF_savebtn'),
			handler : function() {
				if(CTLBFWinForm.getForm().isValid()==false){
				 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
				 return;
				}
				var startDate = Ext.getCmp("CTLBFDateFrom").getValue();
				var endDate = Ext.getCmp("CTLBFDateTo").getValue();
				if (startDate != "" && endDate != "") {
					if (startDate > endDate) {
						Ext.Msg.show({
							title : '提示',
							msg : '开始日期不能大于结束日期！',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
						return;
					}
				}
				
				// -------添加----------
				if (CTLBFwin.title == "添加") {
					
					CTLBFWinForm.form.submit({
						url : CTLBF_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								CTLBFwin.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLBF.getBottomToolbar().cursor;
												gridCTLBF.getStore().baseParams = { // 解决gridCTLBF不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_CTLBFParRef").getValue()
												};
												gridCTLBF.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																CTLBFrowid:myrowid
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
							CTLBFWinForm.form.submit({
								url : CTLBF_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										CTLBFwin.hide();
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCTLBF.getBottomToolbar().cursor;
												gridCTLBF.getStore().baseParams = { // 解决gridCTLBF不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_CTLBFParRef").getValue()
												};
												gridCTLBF.getStore().load(); 
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
				CTLBFwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("CTLBFFloor").focus(true,100);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				CTLBFWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	// 增加按钮
	var CTLBFbtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		id : 'CTLBFbtnAdd',
		iconCls : 'icon-add',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFbtnAdd'),
		handler : function() {
			CTLBFwin.setTitle('添加');
			CTLBFwin.setIconClass('icon-add');
			CTLBFwin.show();
			CTLBFWinForm.getForm().reset();
			Ext.getCmp("CTLBFParRef").setValue(Ext.getCmp("Hidden_CTLBFParRef").getValue());
		},
		scope : this
	});

	// 修改按钮
	var CTLBFbtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				id : 'CTLBFbtnUpdate',
				iconCls : 'icon-update',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFbtnUpdate'),
				handler : function() {
					if (gridCTLBF.selModel.hasSelection()) {
						CTLBFwin.setTitle('修改');
						CTLBFwin.setIconClass('icon-update');
						CTLBFwin.show();
						loadCTLBFFormData(gridCTLBF);
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
	
	// 增删改工具条
	var CTLBFtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [CTLBFbtnAdd, '-', CTLBFbtnEdit, '-',CTLBFbtnDel,'-',btnTransFloor]
			});

	//搜索按钮
	var CTLBFbtnSearch=new Ext.Button({
                    id:'CTLBFbtnSearch',
                    iconCls:'icon-search',
					tooltip : '重置',
                    text:'搜索',
                    disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFbtnSearch'),
                    handler:function(){
						gridCTLBF.getStore().baseParams={
							parref : Ext.getCmp("Hidden_CTLBFParRef").getValue(),
							desc : Ext.getCmp("TextFloor").getValue(),
						};
						gridCTLBF.getStore().load({
							params : {
							start : 0,
							limit : pagesize1
						}
						});	
                    }

                });
	
	// 刷新按钮
	var CTLBFbtnRefresh = new Ext.Button({
				id : 'CTLBFbtnRefresh',
				iconCls : 'icon-refresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLBFbtnRefresh'),
				tooltip : '重置',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextFloor").reset();
					gridCTLBF.getStore().baseParams={  //解决gridCTLBF不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								parref : Ext.getCmp("Hidden_CTLBFParRef").getValue()
					};
					gridCTLBF.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	
	//刷新搜索工具条
	var CTLBFtb=new Ext.Toolbar({
                    id:'CTLBFtb',
                    items:[
                        '楼层',
                        {
						xtype: 'textfield',
						id: 'TextFloor',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFloor')
						},'-',CTLBFbtnSearch,'-',CTLBFbtnRefresh,{ 
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_CTLBFParRef'
						}
                    ],
					listeners:{
                    render:function(){
                    CTLBFtbbutton.render(gridCTLBF.tbar)  //tbar.render(panel.bbar)这个效果在底部
                    }
                }
				});
	
	var CTLBFds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : CTLBF_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'CTLBFRowId',
								mapping : 'CTLBFRowId',
								type : 'string'
							}, {
								name : 'CTLBFFloor',
								mapping : 'CTLBFFloor',
								type : 'string'
							}, {
								name : 'CTLBFParRef',
								mapping : 'CTLBFParRef',
								type : 'string'
							}, {
								name : 'CTLBFDateFrom',
								mapping : 'CTLBFDateFrom',
								type : 'string'
							}, {
								name : 'CTLBFDateTo',
								mapping : 'CTLBFDateTo',
								type : 'string'
							}, {
								name : 'CTLBFMark',
								mapping : 'CTLBFMark',
								type : 'string'
							}])
		});

	// 加载数据
	CTLBFds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var CTLBFpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : CTLBFds,
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

	var CTLBFsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 创建Grid
	var gridCTLBF = new Ext.grid.GridPanel({
				id : 'gridCTLBF',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : CTLBFds,
				trackMouseOver : true,
				columns : [CTLBFsm, {
							header : 'CTLBFRowId',
							width : 70,
							sortable : true,
							dataIndex : 'CTLBFRowId',
							hidden : true
						}, {
							header : 'CTLBFParRef',
							width : 80,
							sortable : true,
							dataIndex : 'CTLBFParRef',
							hidden : true
						}, {
							header : '楼层',
							width : 80,
							sortable : true,
							dataIndex : 'CTLBFFloor'
						}, {
							header : '备注',
							width : 80,
							sortable : true,
							dataIndex : 'CTLBFMark'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							dataIndex : 'CTLBFDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							dataIndex : 'CTLBFDateTo'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : CTLBFpaging,
				tbar : CTLBFtb,
				stateId : 'gridCTLBF'
			});
	Ext.BDP.FunLib.ShowUserHabit(gridCTLBF,"User.CTLocBuildingFloor");

	// 载入被选择的数据行的表单数据
	var loadCTLBFFormData = function(gridCTLBF) {
		var _record = gridCTLBF.getSelectionModel().getSelected();
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			CTLBFWinForm.form.load({
						url : CTLBF_OPEN_ACTION_URL + '&id='+ _record.get('CTLBFRowId'),
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

	gridCTLBF.on("rowdblclick", function(grid, rowIndex, e) {
				CTLBFwin.setTitle('修改');
				CTLBFwin.setIconClass('icon-update');
				CTLBFwin.show();
				loadCTLBFFormData(gridCTLBF);
			});

	var CTLBFwindow = new Ext.Window({
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
				items : gridCTLBF
			});
	//----------------------子表完----------------------
	
    function getCTLBFPanel(){
	var winLinkCTLBF = new Ext.Window({
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
			items: gridCTLBF,
			listeners:{
				"show":function(){
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
  	return winLinkCTLBF;
}

	