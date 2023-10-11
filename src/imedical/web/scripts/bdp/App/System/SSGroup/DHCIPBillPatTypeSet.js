 ///websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPatTypeSet
///安全组与病人类型配置
///编写者:基础数据平台组 - 陈莹
///编写日期:2014-12-12
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	
Ext.onReady(function() {	
   
	
	///User.DHCJFSSGrpAdmReasonConfig
	
	var ADMR_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGrpBillPatTypeSet&pClassQuery=FindGrpPatType";
	var ADMR_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpBillPatTypeSet&pClassMethod=SaveInfo";
	var ADMR_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpBillPatTypeSet&pClassMethod=OpenData";
	var ADMR_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpBillPatTypeSet&pClassMethod=DelInfo";
	//病人类型
	var ADMREA_DR_QUERY_ACTION_URL  = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmReason&pClassQuery=GetDataForCmb1";
	
	pagesize1=Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
    
    var ADMRbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'ADMR_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMR_del_btn'),
		handler : function() {   
			
			if (ADMRgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = ADMRgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : ADMR_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'rowid' : rows[0].get('rowid')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')  ///if (jsonData== 0)
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = ADMRgrid.getBottomToolbar().cursor;
												var totalnum=ADMRgrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=ADMRgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												ADMRgrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1  
																}	
														});		
	
											}
											
									});
								}
								else {
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
								} 
								else {
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
	
	// 增加修改的form
	var ADMRWinForm = new Ext.FormPanel({
				id : 'ADMR-form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth :100,
				split : true,
				autoScroll : true, //滚动条
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                         {name: 'rowid',mapping:'rowid'},
                                         {name: 'PatType',mapping:'PatType'},  //////mapping 与ds对应，name与formpanel提交的数据对应。
                                       	{name: 'Default',mapping:'Default'},
                                       	{name: 'billNotPrintFlag',mapping:'billNotPrintFlag'}
                                       	
                                         ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'rowid',
							xtype:'textfield',
							fieldLabel : 'rowid',
							name : 'rowid',
							hideLabel : 'True',
							hidden : true
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							allowBlank:false,
							fieldLabel : '<font color=red>*</font>病人类型',
							hiddenName : 'PatType',
							id:'PatType1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PatType1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PatType1')),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : ADMREA_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'REARowId',mapping:'REARowId'},
										{name:'READesc',mapping:'READesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'READesc',
							valueField : 'REARowId'
						}, {
							fieldLabel: '是否默认',
							xtype : 'checkbox',
							name : 'Default',
							id:'Default',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Default'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Default')),
							inputValue : true?'Y':'N'
								
						}, {
							fieldLabel: '不打印标志',
							xtype : 'checkbox',
							name : 'billNotPrintFlag',
							id:'billNotPrintFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('billNotPrintFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('billNotPrintFlag')),
							inputValue : true?'Y':'N'
							
						}]	
	});
			
	// 增加修改时弹出窗口
	var ADMRwin = new Ext.Window({
		title : '',
		width:320,
		height: 300,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : ADMRWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'ADMR_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMR_save_btn'),
			handler : function() {
				var grp=Ext.BDP.FunLib.getParam("gid");
				var drpType=Ext.getCmp("PatType1").getValue();
				
				var defa=Ext.getCmp('Default').getValue();
				
				var flagstr =""
				
				
				if (ADMRwin.title == "添加") {
					var flagstr = tkMakeServerCall("web.DHCBL.CT.SSGrpBillPatTypeSet","CheckInfo",grp,drpType,defa,"");
				}
				else
				{
					var _record = ADMRgrid.getSelectionModel().getSelected();
					var flagstr = tkMakeServerCall("web.DHCBL.CT.SSGrpBillPatTypeSet","CheckInfo",grp,drpType,defa, _record.get('rowid'));
				}
				var arryField = flagstr.split("^"); 
				var flag1=arryField[0]; //判断是否已有记录 0为有，1为无
				var flag2=arryField[1]; //判断是否有默认记录
				
				if (flag1==1)
				{
					Ext.Msg.show({ title : '提示', msg : '该记录已存在!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });   
		    		return;
				}
				if (flag2==1)
				{
					Ext.Msg.show({ title : '提示', msg : '只能有一条默认记录!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });   
		    		return;
				}
				//-------添加----------
				if (ADMRwin.title == "添加") {
					
					
					ADMRWinForm.form.submit({
						url : ADMR_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'Grp' : Ext.BDP.FunLib.getParam("gid")
							},
						success : function(form, action) {
							if (action.result.success == 'true'){  ///(action.result== 0) {
								ADMRwin.hide();
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = ADMRgrid.getBottomToolbar().cursor;
												ADMRgrid.getStore().load({
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
							///?
							
						}
					})	
					
			
				} 
				//---------修改-------
				else {
					
					
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							ADMRWinForm.form.submit({
								url : ADMR_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								params : {									  //-------请求带的参数
									'Grp' : Ext.BDP.FunLib.getParam("gid")
								},
								success : function(form, action) {
									if (action.result.success == 'true'){  ///	if (action.result== 0) {
								ADMRwin.hide();
								Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = ADMRgrid.getBottomToolbar().cursor;
												ADMRgrid.getStore().load({
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
											msg : '修改失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
								},
								failure : function(form, action) {
									
								
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
				ADMRwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("ADMR-form-save").getForm().findField("STCTLOCDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				ADMRWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var ADMRbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'ADMR_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMR_add_btn'),
				handler : function() {
				
						ADMRwin.setTitle('添加');
						ADMRwin.setIconClass('icon-add');
						ADMRwin.show();
						ADMRWinForm.getForm().reset();
				
					
				},
				scope: this
	});
	// 修改按钮
	var ADMRbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'ADMR_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMR_update_btn'),
				handler : function() {
					
					if (ADMRgrid.selModel.hasSelection()) {
						ADMRwin.setTitle('修改');
						ADMRwin.setIconClass('icon-update');
						ADMRwin.show();
						loadADMRFormData(ADMRgrid);
						//var record = ADMRgrid.getSelectionModel().getSelected();
						//Ext.getCmp("ADMR-form-save").getForm().loadRecord(record);
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
	
	var ADMRds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ADMR_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'rowid',
								mapping : 'rowid',
								type : 'string'
							}, {
								name : 'grp',
								mapping : 'grp',
								type : 'string'
							}, {
								name : 'PatType',
								mapping : 'PatType',
								type : 'string'
							}, {
								name : 'Default',
								mapping : 'Default',
								type : 'string'
							}, {
								name : 'billNotPrintFlag',
								mapping : 'billNotPrintFlag',
								type : 'string'
							
							}
						])
	});
	
	ADMRds.baseParams = {UserGrp:Ext.BDP.FunLib.getParam("gid")}		
 	// 加载数据
	ADMRds.load({
				params : { start : 0, limit : pagesize1 },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var ADMRpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : ADMRds,
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

	var ADMRsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var ADMRtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [ADMRbtnAddwin, '-', ADMRbtnEditwin, '-', ADMRbtnDel,'-']
	});
	
	
		
	// 将工具条放到一起
	var ADMRtb = new Ext.Toolbar({
				id : 'ADMRtb',
			
				listeners : {
					render : function() {
						ADMRtbbutton.render(ADMRgrid.tbar)
					}
				}
	});

	// 创建Grid
	var ADMRgrid = new Ext.grid.GridPanel({
				id : 'ADMRgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ADMRds,
				trackMouseOver : true,
				columns :[ADMRsm, {
							hidden:true,
							header : 'rowid',
							width : 80,
							sortable : true,
							dataIndex : 'rowid'
						}, {
							header : '安全组',
							width : 80,
							sortable : true,
							dataIndex : 'grp'
						}, {
							header : '病人类型',
							width : 120,
							sortable : true,
							dataIndex : 'PatType'
						}, {
							header : '是否默认',
							width : 80,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'Default'
						}, {
							header : '不打印标志',
							width : 80,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'billNotPrintFlag'
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
				bbar : ADMRpaging,
				tbar : ADMRtb,
				stateId : 'ADMRgrid'
	});
	Ext.BDP.FunLib.ShowUserHabit(ADMRgrid,"User.DHCJFSSGrpAdmReasonConfig");
	

   // 载入被选择的数据行的表单数据
    var loadADMRFormData = function(grid) {
        var _record = ADMRgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
        	
        	 ADMRWinForm.form.load( {
                url : ADMR_OPEN_ACTION_URL + '&rowid='+ _record.get('rowid'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	
	        	

                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
           // Ext.getCmp("DEPT-form-save").getForm().findField('Default').setValue((_record.get('Default'))=='Y'?true:false);
        	 //Ext.getCmp("DEPT-form-save").getForm().findField('billNotPrintFlag').setValue((_record.get('billNotPrintFlag'))=='Y'?true:false);
        
        }
    };

    //双击事件
    ADMRgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			ADMRwin.setTitle('修改');
			ADMRwin.setIconClass('icon-update');
			ADMRwin.show();
        	loadADMRFormData(ADMRgrid);
    });	
	
    
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [ADMRgrid]
    });
	
	});