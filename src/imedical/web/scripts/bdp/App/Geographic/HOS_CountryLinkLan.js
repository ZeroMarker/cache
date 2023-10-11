/**----------------------------------国家关联语言--------------------------------------**/	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var CouLinkLan_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassQuery=GetList";
	var CouLinkLan_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HOSCountryLinkLan";	
	var CouLinkLan_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=DeleteData";
	var CouLinkLan_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HOSCountryLinkLan&pClassMethod=OpenDataExt";
	var BindingLanTp = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;

	// 删除功能  
	var CouLinkLanbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'CouLinkLanbtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnDel'),
		handler : function() {
			if (gridCouLinkLan.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = gridCouLinkLan.getSelectionModel();
						var rows = gsm.getSelections();
						Ext.Ajax.request({
							url : CouLinkLan_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ID')
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
												Ext.BDP.FunLib.DelForTruePage(gridCouLinkLan,pagesize);	
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
	var CouLinkLanWinForm = new Ext.FormPanel({
			id : 'CouLinkLan-form-save',
			URL : CouLinkLan_SAVE_ACTION_URL,
			baseCls : 'x-plain',// form透明,不显示框框
			labelAlign : 'right',
			labelWidth : 75,
			split : true,
			frame : true,
			waitMsgTarget : true,
			reader : new Ext.data.JsonReader({
						root : 'list'
					}, [{
								name : 'ID',
								mapping : 'ID'
							},{
								name : 'CLLLANCode',
								mapping : 'CLLLANCode'
							}, {
								name : 'CLLActivity',
								mapping : 'CLLActivity'
							}, {
								name : 'CLLIsDefault',
								mapping : 'CLLIsDefault'
							}, {
								name : 'CLLStartDate',
								mapping : 'CLLStartDate'
							}, 
							{
								name : 'CLLEndDate',
								mapping : 'CLLEndDate'
							},
							{
								name : 'CLLPYCode',
								mapping : 'CLLPYCode'
							},
							{
								name : 'CLLWBCode',
								mapping : 'CLLWBCode'
							},
							{
								name : 'CLLMark',
								mapping : 'CLLMark'
							},
							]),
			defaults : {
				anchor : '90%',
				bosrder : false
			},
			items : [{
						id : 'ID',
						xtype : 'textfield',
						fieldLabel : 'RowId',
						name : 'ID',
						hideLabel : 'True',
						hidden : true
					},{
						xtype : 'bdpcombo',
						fieldLabel: "<span style='color:red;'>*</span>语言",
						id:'CLLLANCodeF',
						blankText: '不能为空',
						allowBlank : false,
						name: 'CLLLANCode',
						hiddenName:'CLLLANCode',//不能与id相同
						loadByIdParam : 'rowid',
						forceSelection: true,
						//triggerAction : 'all',
						selectOnFocus:false,
						queryParam : 'desc', //chneying
						//hidden : true,
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLLANCode'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLLANCode')),
						mode:'remote',
						pageSize:Ext.BDP.FunLib.PageSize.Combo,
						listWidth:250,
						valueField:'CTLANRowId',
						displayField:'CTLANDesc',
						store:new Ext.data.JsonStore({
						url:BindingLanTp,
						root: 'data',
						totalProperty: 'total',
						autoLoad: true,
						idProperty: 'CTLANRowId',
						fields:['CTLANRowId','CTLANDesc']
							
						}),
					},
					{
						xtype:'checkbox',
						fieldLabel: '是否有效',
				        name: 'CLLActivity',
				        id: 'CLLActivity',
				        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLActivity'),
				        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLActivity')),
				        //dataIndex:'CTCPTRotaryFlag',
				        checked:true,  //chenying
				        inputValue : true?'Y':'N'
					},
					{
						xtype:'checkbox',
						fieldLabel: '是否默认',
				        name: 'CLLIsDefault',
				        id: 'CLLIsDefault',
				        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLIsDefault'),
				        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLIsDefault')),
				        //dataIndex:'CTCPTRotaryFlag',
				        checked:true,  //chenying
				        inputValue : true?'Y':'N'
					},{
						xtype : 'datefield',
						fieldLabel : '<span style="color:red;">*</span>开始日期',
						name : 'CLLStartDate',
						format : BDPDateFormat,
						id:'CLLStartDate',
						allowBlank:false,
						//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLStartDate')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLStartDate'),
						enableKeyEvents : true,
						listeners : {
						   'keyup' : function(field, e){
								Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
								}
						}
						                                    //-------------使用自定义的vtype验证
					},{
						xtype : 'datefield',
						fieldLabel : '结束日期',
						name : 'CLLEndDate',
						format : BDPDateFormat,
						id:'CLLEndDate',
						//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
						style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CLLEndDate')),
						readOnly : Ext.BDP.FunLib.Component.DisableFlag('CLLEndDate'),
						enableKeyEvents : true,
						listeners : {
						   'keyup' : function(field, e){
								Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
								}
						}
						                                    
					},{
						fieldLabel: "拼音码",
						hiddenName:'CLLPYCode',
						dataIndex:'CLLPYCode',
						id:'CLLPYCode',
						xtype: "textfield",
						//labelSeparator: "：",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						},{
						fieldLabel: "五笔码",
						hiddenName:'CLLWBCode',
						dataIndex:'CLLWBCode',
						id:'CLLWBCode',
						xtype: "textfield",
						//labelSeparator: "：",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						},{
						fieldLabel: "备注",
						hiddenName:'CLLMark',
						dataIndex:'CLLMark',
						id:'CLLMark',
						labelWidth: 80,
						width: 150,
						xtype: "textfield",
						//labelSeparator: "：",
						labelAlign: "left",
						msgTarget: "side",
						autoFitErrors: false,
						}]
		});
		
		
	var height=Math.min(Ext.getBody().getViewSize().height-30,830)	
	//增加修改时弹出的窗口
	var CouLinkLanwin = new Ext.Window({
		title : '',
		width : 280,
		height : 300,
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
		items : CouLinkLanWinForm,
		buttons : [{
			text : '保存',
			id : 'CouLinkLan_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLan_savebtn'),
			handler : function() {
				if(CouLinkLanWinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				var startDate = Ext.getCmp("CLLStartDate").getValue();
			   	var endDate = Ext.getCmp("CLLEndDate").getValue();
			   	if (startDate != "" && endDate != "") {
        			if (startDate > endDate) {
	        			///alert(123)
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
				if (CouLinkLanwin.title == "添加") {
					CouLinkLanWinForm.form.submit({
						url : CouLinkLan_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'CLLCountryCode' : Ext.getCmp("Hidden_CTCountryId").getValue() //在打开的时候,已赋值
							},
						success : function(form, action){
							if (action.result.success == 'true'){
								CouLinkLanwin.hide();
								var myrowid = action.result.id;
								//alert(myrowid)
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridCouLinkLan.getBottomToolbar().cursor;
												gridCouLinkLan.getStore().baseParams = {	
													cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
												};
												gridCouLinkLan.getStore().load({
															params : {
																start : 0,
																limit : pagesize1,
																rowid:myrowid
															}
														});
											}
										});
							} 
							else {
								var errorMsg = '';
								if (action.result.errorinfo){
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
							CouLinkLanWinForm.form.submit({
								url : CouLinkLan_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								params : {
										'CLLCountryCode' : Ext.getCmp("Hidden_CTCountryId").getValue() //在打开的时候,已赋值
									},
								success : function(form, action) {
									if (action.result.success == 'true') {
										CouLinkLanwin.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												gridCouLinkLan.getStore().baseParams={  //解决gridCouLinkLan不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
												cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
						
													};
													gridCouLinkLan.getStore().load({
														params : {
																start : 0,
																limit : pagesize1,
																rowid :myrowid
														}
													});
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
				CouLinkLanwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				CouLinkLanWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	//增加按钮
	var CouLinkLanbtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'CouLinkLanbtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnAdd'),
		handler : function() {
			CouLinkLanwin.setTitle('添加');
			CouLinkLanwin.setIconClass('icon-add');
			CouLinkLanwin.show();
			CouLinkLanWinForm.getForm().reset();
		},
		scope : this
	});
	
	// 修改按钮
	var CouLinkLanbtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'CouLinkLanbtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnUpdate'),
				handler : function() {
					if (gridCouLinkLan.selModel.hasSelection()) {
						CouLinkLanwin.setTitle('修改');
						CouLinkLanwin.setIconClass('icon-update');
						CouLinkLanwin.show();
						loadCouLinkLanFormData(gridCouLinkLan);
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
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [CouLinkLanbtnAdd, '-', CouLinkLanbtnEdit, '-', CouLinkLanbtnDel, ]
			
		})
		
	//搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					gridCouLinkLan.getStore().baseParams={				
							clllandr: Ext.getCmp("CLLlan").getValue(),
							cllcoudr: Ext.getCmp("Hidden_CTCountryId").getValue()					
					};
					gridCouLinkLan.getStore().load({
						params : {
							start : 0,
							limit : pagesize
						}
					});
				}

			});

				
	// 刷新工作条
	var CouLinkLanbtnRefresh = new Ext.Button({
		id : 'CouLinkLanbtnRefresh',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('CouLinkLanbtnRefresh'),
		tooltip : '重置',
		iconCls : 'icon-refresh',
		text : '重置',
		handler : function() {
			Ext.getCmp("CLLlan").reset();
			gridCouLinkLan.getStore().baseParams={  //解决gridCouLinkLan不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23 
						cllcoudr : Ext.getCmp("Hidden_CTCountryId").getValue()
						
			};
			gridCouLinkLan.getStore().load({
				params : {
						start : 0,
						limit : pagesize1
				}
			});
		}
});
	//语言检索下拉框
	var CLLlansearch = new Ext.BDP.Component.form.ComboBox({
				width:100,
				loadByIdParam : 'rowid',
				fieldLabel: '语言',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('CLLlan'),
				id:'CLLlan',
				//triggerAction:'all',//query
				forceSelection: true,
				selectOnFocus:false,
				mode:'remote',
				pageSize:Ext.BDP.FunLib.PageSize.Combo,
				listWidth:250,
				valueField:'CTLANRowId',
				displayField:'CTLANDesc',
				store:new Ext.data.JsonStore({
					url:BindingLanTp,
					root: 'data',
					totalProperty: 'total',
					idProperty: 'CTLANRowId',
					fields:['CTLANRowId','CTLANDesc']
				}),
				
			});
	//将工具条放在一起
	var CouLinkLantbbutton = new Ext.Toolbar({
		id:'CouLinkLantbbutton',
		enableOverflow : true,
		items : [/*'语言', {
							xtype : 'textfield',
							id : 'TextCLLMark',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCLLMark'),
							emptyText:'输入备注..'
						}*/'语言',CLLlansearch,'-',btnSearch,'-',CouLinkLanbtnRefresh,  //chenying
				{  
					xtype : 'textfield',
					hidden:true,
					id:'Hidden_CTCountryId'
				}],
				listeners : {
					render : function() {
					tbbutton.render(gridCouLinkLan.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
	});


	var CouLinkLands = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : CouLinkLan_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'ID',   //RowId
								mapping : 'ID',
								type : 'string'
							}, 
							{
								name : 'CLLCountryCode', //国家
								mapping : 'CLLCountryCode',
								type : 'string'
							},
							{
								name : 'CLLLANCode',  //语言
								mapping : 'CLLLANCode',
								type : 'string'
							},
							{
								name : 'CLLActivity', //是否有效
								mapping : 'CLLActivity',
								type : 'string'
							},
							{
								name : 'CLLIsDefault', //是否默认
								mapping : 'CLLIsDefault',
								type : 'string'
							},
							{
								name : 'CLLStartDate', //开始日期
								mapping : 'CLLStartDate',
								type : 'string'
							},{
								name : 'CLLEndDate', //结束日期
								mapping : 'CLLEndDate',
								type : 'string'
							},{
								name : 'CLLPYCode',  //拼音码
								mapping : 'CLLPYCode',
								type : 'string'
							},{
								name : 'CLLWBCode',  //五笔码
								mapping : 'CLLWBCode',
								type : 'string'
							},{
								name : 'CLLMark',  //备注
								mapping : 'CLLMark',
								type : 'string'
							}
								
				   			])

		});
		// 加载数据
	CouLinkLands.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});
			
		// 分页工具条
	var CouLinkLanpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : CouLinkLands,
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
			
	// 创建Grid
	var CouLinkLansm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	var gridCouLinkLan = new Ext.grid.GridPanel({
		id : 'gridCouLinkLan',
		region : 'center',
		width : 560,
		height : 370,
		closable : true,
		store : CouLinkLands,
		trackMouseOver : true,
		columns : [CouLinkLansm, {
					header : 'RowId',
					width : 70,
					sortable : true,
					dataIndex : 'ID',
					hidden : true
				},{
					header : '语言',
					width : 80,
					sortable : true,
					dataIndex : 'CLLLANCode'
				},{
					header : '是否有效',
					width : 80,
					sortable : true,
					renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon, 
					dataIndex : 'CLLActivity'
				},{
					header : '是否默认',
					width : 80,
					sortable : true,
					renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon, 
					dataIndex : 'CLLIsDefault'
				},{
					header : '开始日期',
					width : 80,
					sortable : true,
					dataIndex : 'CLLStartDate'
				},{
					header : '结束日期',
					width : 80,
					sortable : true,
					dataIndex : 'CLLEndDate'
				},{
					header : '备注',
					width : 80,
					sortable : true,
					dataIndex : 'CLLMark'
				},{
					header : '拼音码',
					width : 80,
					sortable : true,
					dataIndex : 'CLLPYCode'
				},{
					header : '五笔码',
					width : 80,
					sortable : true,
					dataIndex : 'CLLWBCode'
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
		bbar : CouLinkLanpaging,
		tbar : CouLinkLantbbutton,
		stateId : 'gridCouLinkLan'
	});
	Ext.BDP.FunLib.ShowUserHabit(gridCouLinkLan,Ext.BDP.FunLib.SortTableName); 
	
	
	var loadCouLinkLanFormData = function(gridCouLinkLan) {
		var _record = gridCouLinkLan.getSelectionModel().getSelected();
		//alert(_record)
		if (!_record) {
			// Ext.Msg.alert('修改','请选择要修改的一项！');
		} else {
			CouLinkLanWinForm.form.load({
						url : CouLinkLan_OPEN_ACTION_URL + '&id='+ _record.get('ID'),
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
	
	gridCouLinkLan.on("rowdblclick", function(grid, rowIndex, e) {
		CouLinkLanwin.setTitle('修改');
		CouLinkLanwin.setIconClass('icon-update');
		CouLinkLanwin.show();
		loadCouLinkLanFormData(gridCouLinkLan);
	});
	
	var CouLinkLanwindow = new Ext.Window({
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
		items : gridCouLinkLan
	});
	
	var width=Math.min(Ext.getBody().getViewSize().width-30,830)	
    function getCouLinkLanPanel(){
        var winCouLinkLan = new Ext.Window({
                title:'',
                width:width, //chenying
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
                items: gridCouLinkLan,
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
          return winCouLinkLan;
    }