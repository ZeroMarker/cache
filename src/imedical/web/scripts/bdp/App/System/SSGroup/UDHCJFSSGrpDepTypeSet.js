 /// websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFSSGrpDepTypeSet 
/// 安全组与押金类型配置
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2014-12-9  
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	
Ext.onReady(function() {	
   ///User.DHC_JFSSGrpDepTypeConfig
	var DEPT_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGrpDepTypeSet&pClassQuery=FindGrpDepType";
	var DEPT_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpDepTypeSet&pClassMethod=SaveInfo";
	var DEPT_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpDepTypeSet&pClassMethod=OpenData";
	var DEPT_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGrpDepTypeSet&pClassMethod=DelInfo";
	//押金类型
	var ARCDT_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCDepType&pClassQuery=GetDataForCmb1";
	
	pagesize1=Ext.BDP.FunLib.PageSize.Main;
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
    
    var DEPTbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'DEPT_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('DEPT_del_btn'),
		handler : function() {   
			
			if (DEPTgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = DEPTgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DEPT_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'rowid' : rows[0].get('rowid')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') //if (jsonData== 0)
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = DEPTgrid.getBottomToolbar().cursor;
												var totalnum=DEPTgrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=DEPTgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												DEPTgrid.getStore().load({
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
	var DEPTWinForm = new Ext.FormPanel({
				id : 'DEPT-form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				autoScroll : true, //滚动条
				URL : DEPT_SAVE_ACTION_URL,
				//bodyStyle : 'padding:5px 5px 0 0',
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 100,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                         {name: 'rowid',mapping:'rowid'},
                                         {name: 'DepType',mapping:'DepType'},  //////mapping 与ds对应，name与formpanel提交的数据对应。
                                       	{name: 'Default',mapping:'Default'}
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
							fieldLabel : '<font color=red>*</font>押金类型',
							hiddenName : 'DepType',
							id:'DepType1',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('DepType1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DepType1')),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : ARCDT_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'ARCDTRowId',mapping:'ARCDTRowId'},
										{name:'ARCDTDesc',mapping:'ARCDTDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'ARCDTDesc',
							valueField : 'ARCDTRowId'
							
							
							
						}, {
							fieldLabel: '是否默认',
							xtype : 'checkbox',
							name : 'Default',
							id:'Default',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('Default'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Default')),
							inputValue : 'Y'
						}]	
	});
			
	// 增加修改时弹出窗口
	var DEPTwin = new Ext.Window({
		title : '',
		width:320,
		height: 250,
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
		items : DEPTWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'DEPT_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('DEPT_save_btn'),
			handler : function() {
					
				var grp=Ext.BDP.FunLib.getParam("gid");
				var drpType=Ext.getCmp("DepType1").getValue();
				
				var defa=Ext.getCmp("Default").getValue()
				var flagstr =""
				
				
				if (DEPTwin.title == "添加") {
					var flagstr = tkMakeServerCall("web.DHCBL.CT.SSGrpDepTypeSet","CheckInfo",grp,drpType,defa,"");
				}
				else
				{
					var _record = DEPTgrid.getSelectionModel().getSelected();
					var flagstr = tkMakeServerCall("web.DHCBL.CT.SSGrpDepTypeSet","CheckInfo",grp,drpType,defa,_record.get('rowid'));
				}
				//alert(flagstr)
				var arryField = flagstr.split("^"); 
				var flag1=arryField[0]; //判断是否已有记录 1为有，0为无
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
				if (DEPTwin.title == "添加") {
					
					
					
					DEPTWinForm.form.submit({
						url : DEPT_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'Grp' : Ext.BDP.FunLib.getParam("gid")
							},
						success : function(form, action) {
							if (action.result.success == 'true') {  ///if (action.result== 0) {
								DEPTwin.hide();
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = DEPTgrid.getBottomToolbar().cursor;
												DEPTgrid.getStore().load({
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
							
						}
					})	
				
				
				} 
				//---------修改-------
				else {
					
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							DEPTWinForm.form.submit({
								url : DEPT_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								params : {									  //-------请求带的参数
									'Grp' : Ext.BDP.FunLib.getParam("gid")
								},
								success : function(form, action) {
								if (action.result.success == 'true') { ///	if (action.result== 0) {
								DEPTwin.hide();
								Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = DEPTgrid.getBottomToolbar().cursor;
												DEPTgrid.getStore().load({
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
				DEPTwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("DEPT-form-save").getForm().findField("STCTLOCDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				DEPTWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var DEPTbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'DEPT_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('DEPT_add_btn'),
				handler : function() {
				
						DEPTwin.setTitle('添加');
						DEPTwin.setIconClass('icon-add');
						DEPTwin.show();
						DEPTWinForm.getForm().reset();
				
					
				},
				scope: this
	});
	// 修改按钮
	var DEPTbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'DEPT_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('DEPT_update_btn'),
				handler : function() {
					
					if (DEPTgrid.selModel.hasSelection()) {
						DEPTwin.setTitle('修改');
						DEPTwin.setIconClass('icon-update');
						DEPTwin.show();
						loadDEPTFormData(DEPTgrid);
						//var record = DEPTgrid.getSelectionModel().getSelected();
						//Ext.getCmp("DEPT-form-save").getForm().loadRecord(record);
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
	
	var DEPTds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : DEPT_ACTION_URL}),
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
								name : 'DepType',
								mapping : 'DepType',
								type : 'string'
							}, {
								name : 'Default',
								mapping : 'Default',
								type : 'string'
							
							}
						])
	});
	
	DEPTds.baseParams = {UserGrp:Ext.BDP.FunLib.getParam("gid")}		
 	// 加载数据
	DEPTds.load({
				params : { start : 0, limit : pagesize1 },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var DEPTpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : DEPTds,
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

	var DEPTsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var DEPTtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [DEPTbtnAddwin, '-', DEPTbtnEditwin, '-', DEPTbtnDel,'-']
	});
	
	
		
	// 将工具条放到一起
	var DEPTtb = new Ext.Toolbar({
				id : 'DEPTtb',
			
				listeners : {
					render : function() {
						DEPTtbbutton.render(DEPTgrid.tbar)
					}
				}
	});

	// 创建Grid
	var DEPTgrid = new Ext.grid.GridPanel({
				id : 'DEPTgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : DEPTds,
				trackMouseOver : true,
				columns :[DEPTsm, {
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
							header : '押金类型',
							width : 120,
							sortable : true,
							dataIndex : 'DepType'
						}, {
							header : '是否默认',
							width : 80,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'Default'
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
				bbar : DEPTpaging,
				tbar : DEPTtb,
				stateId : 'DEPTgrid'
	});
	
	Ext.BDP.FunLib.ShowUserHabit(DEPTgrid,"User.DHCJFSSGrpDepTypeConfig");
   // 载入被选择的数据行的表单数据
    var loadDEPTFormData = function(grid) {
        var _record = DEPTgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
        	
        	 DEPTWinForm.form.load( {
                url : DEPT_OPEN_ACTION_URL + '&rowid='+ _record.get('rowid'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        
        }
    };

    //双击事件
    DEPTgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			DEPTwin.setTitle('修改');
			DEPTwin.setIconClass('icon-update');
			DEPTwin.show();
        	loadDEPTFormData(DEPTgrid);
    });	
	
    
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [DEPTgrid]
    });
	
	});