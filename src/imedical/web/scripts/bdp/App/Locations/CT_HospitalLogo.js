/// 名称: 医院-医院logo维护
/// 编写者： 基础数据平台-李可凡
/// 编写日期:2022-07-07

    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
	var LOGO_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospitalLogo&pClassQuery=GetList";
	var LOGO_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHospitalLogo&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHospitalLogo";	
	var LOGO_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHospitalLogo&pClassMethod=DeleteData";
	var LOGO_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHospitalLogo&pClassMethod=OpenData";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	
	//parent调用方法
	ReloadPreview=function(){
		var globalLOGOUrl=tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","GetTempHospLogo","LOGOUrl");
		if (globalLOGOUrl!=""){
			Ext.getCmp('LOGOImg').getEl().dom.src=globalLOGOUrl;
		}
    }
	
	// 删除功能
	var LOGObtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'LOGObtnDel',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LOGObtnDel'),
		handler : function() {
			if (gridLOGO.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						var gsm = gridLOGO.getSelectionModel();
						var rows = gsm.getSelections();
						var deleteurl=rows[0].get('LOGOUrl');	//取要删除的图片url
						Ext.Ajax.request({
							url : LOGO_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('LOGORowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据及图片删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(gridLOGO,pagesize);	
											}
										});
										tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","DeleteFile",deleteurl);		//删除url对应图片
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
	
	// 上传图片面板
	var URLupload="dhc.bdp.bdp.uploadhospdata.csp";
	if ('undefined'!==typeof websys_getMWToken)
    {
		URLupload += "?MWToken="+websys_getMWToken() //增加token  
	}
	var csppanel = new Ext.Panel({
					frame:true,
					//xtype: 'panel',
			        //region: 'north',
					height: 300,
					//width:1000,
					border: false,
					items:[{
						name:'csppanel',
						id:'csppanel',
						fieldLabel : '图片上传',
						html:'<iframe id="iframea" src="'+URLupload+'" width="100%" height="100%"></iframe>'
					}]
			    })
	
	// 添加修改时的Form
	var LOGOwinForm = new Ext.FormPanel({
		id : 'LOGO-form-save',
		URL : LOGO_SAVE_ACTION_URL,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 80,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'LOGOParRef',
							mapping : 'LOGOParRef'
						}, {
							name : 'LOGOChildsub',
							mapping : 'LOGOChildsub'
						}, {
							name : 'LOGORowId',
							mapping : 'LOGORowId'
						}, {
							name : 'LOGOCode',
							mapping : 'LOGOCode'
						}, {
							name : 'LOGOUrl',
							mapping : 'LOGOUrl'
						}, {
							name : 'LOGORemarks',
							mapping : 'LOGORemarks'
						}, {
							name : 'LOGOImg',
							mapping : 'LOGOImg'
						}]),
		defaults : {
			anchor : '95%',
			bosrder : false
		},
		items:
		
		//横版弹窗
		/*{
				xtype:'fieldset',
				border:false,
				autoHeight:true,
				items :[{
					baseCls : 'x-plain',
					layout:'column',
					border:false,
					items:[{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelPad:1,//默认5
						border:false,
						defaults: {anchor:'95%'},
						items: [
							
										 {
											xtype : 'textfield',
											fieldLabel : '<font color=red>*</font>业务代码',
											name : 'LOGOCode',
											id:'LOGOCode',
											allowBlank:false,
											blankText: '代码不能为空',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGOCode')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGOCode')
										},csppanel
										
						]					
					},{
						baseCls : 'x-plain',
						columnWidth:'.5',
						layout: 'form',
						labelPad:1,
						border:false,
						defaults: {anchor:'95%'},
						items: [
										{
											xtype : 'textfield',
											fieldLabel : '备注',
											name : 'LOGORemarks',
											id:'LOGORemarks',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGORemarks')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGORemarks')
										},{
											xtype : 'box',  
											id : 'LOGOImg',  
											fieldLabel : '预览',
											autoEl : {  
												width : 300,  
												height : 297,  
												tag : 'img',  
												src : Ext.BLANK_IMAGE_URL,  
												style : 'border : 1px solid #999;',  
												id : 'imageBrowse' 
											}
										},{
											id : 'LOGORowId',
											xtype : 'textfield',
											fieldLabel : 'LOGORowId',
											name : 'LOGORowId',
											hideLabel : 'True',
											hidden : true
										}, {
											id : 'LOGOParRef',
											xtype : 'textfield',
											fieldLabel : 'LOGOParRef',
											name : 'LOGOParRef',
											hideLabel : 'True',
											hidden : true
										}, {
											id : 'LOGOChildsub',
											xtype : 'textfield',
											fieldLabel : 'LOGOChildsub',
											name : 'LOGOChildsub',
											hideLabel : 'True',
											hidden : true
										}, {
											xtype : 'textfield',
											fieldLabel : 'Logo Url地址',
											name : 'LOGOUrl',
											hideLabel : 'True',
											hidden:true,
											id:'LOGOUrl',
											style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGOUrl')),
											readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGOUrl')
										}
						]						
					}]
				}]
		}*/
		
		//竖版弹窗
		[
			{
				id : 'LOGORowId',
				xtype : 'textfield',
				fieldLabel : 'LOGORowId',
				name : 'LOGORowId',
				hideLabel : 'True',
				hidden : true
			}, {
				id : 'LOGOParRef',
				xtype : 'textfield',
				fieldLabel : 'LOGOParRef',
				name : 'LOGOParRef',
				hideLabel : 'True',
				hidden : true
			}, {
				id : 'LOGOChildsub',
				xtype : 'textfield',
				fieldLabel : 'LOGOChildsub',
				name : 'LOGOChildsub',
				hideLabel : 'True',
				hidden : true
			}, {
				xtype : 'textfield',
				fieldLabel : '<font color=red>*</font>业务代码',
				name : 'LOGOCode',
				id:'LOGOCode',
				allowBlank:false,
				blankText: '代码不能为空',
				style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGOCode')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGOCode')
			}, {
				xtype : 'textfield',
				fieldLabel : 'Logo Url地址',
				name : 'LOGOUrl',
				hideLabel : 'True',
				hidden:true,
				id:'LOGOUrl',
				style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGOUrl')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGOUrl')
			},{
				xtype : 'textfield',
				fieldLabel : '备注',
				name : 'LOGORemarks',
				id:'LOGORemarks',
				style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LOGORemarks')),
				readOnly : Ext.BDP.FunLib.Component.DisableFlag('LOGORemarks')
			},{
				xtype : 'box',  
				id : 'LOGOImg',  
				fieldLabel : '图片预览',
				autoEl : {  
					width : 300,  
					height : 200,  
					tag : 'img',  
					src : Ext.BLANK_IMAGE_URL,  
					style : 'border : 1px solid #999;',  
					id : 'imageBrowse' 
				}
			},csppanel
		]
		
	});

	// 添加修改时弹出窗口
	var LOGOwin = new Ext.Window({
		title : '',
		width : 570,
		height : Math.min(Ext.getBody().getViewSize().height-10,640),
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
		items : LOGOwinForm,
		buttons : [{
			text : '保存',
			id : 'LOGO_savebtn',
			iconCls : 'icon-save',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('LOGO_savebtn'),
			handler : function() {
				
				var LOGOCodeFlag=tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","FormValidate",Ext.getCmp("LOGORowId").getValue(),Ext.getCmp("Hidden_HospID").getValue(),Ext.getCmp("LOGOCode").getValue());
				if (LOGOCodeFlag==1) {
			    	Ext.Msg.show({ title : '提示', msg : '业务代码已存在！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			        return;
			    }
				
				if(LOGOwinForm.getForm().isValid()==false){
							 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
							 return;
				}
				if (LOGOwin.title=="添加"){
					// -------添加----------
					LOGOwinForm.form.submit({
						url : LOGO_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {
								'LOGOParRef' : Ext.getCmp("Hidden_HospID").getValue()
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								LOGOwin.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridLOGO.getBottomToolbar().cursor;
												gridLOGO.getStore().baseParams = { // 解决gridLOGO不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_HospID").getValue()
												};
												gridLOGO.getStore().load({
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
				else
				{
					// ---------修改-------
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							LOGOwinForm.form.submit({
								url : LOGO_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										LOGOwin.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = gridLOGO.getBottomToolbar().cursor;
												gridLOGO.getStore().baseParams = { // 解决gridLOGO不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
													parref : Ext.getCmp("Hidden_HospID").getValue()
												};
												gridLOGO.getStore().load({
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
				LOGOwin.hide();
				tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","CloseDeleteFile");	//删除已上传的图片文件
			}
		}],
		listeners : {
			"show" : function() {
				//打开时清空临时global里保存的url和base64编码
				tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","SaveTempHospLogo","LOGOUrl","");
				tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","SaveTempHospLogo","LOGOImg","");
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				LOGOwinForm.getForm().reset();
				var URLuploadhosp="dhc.bdp.bdp.uploadhospdata.csp";
				if ('undefined'!==typeof websys_getMWToken)
				{
					URLuploadhosp += "?MWToken="+websys_getMWToken() //增加token  
				}
				//重新加载html
				Ext.getCmp('csppanel').update('<iframe id="iframea" src="'+URLuploadhosp+'" width="100%" height="100%"></iframe>');
			
				gridLOGO.getStore().baseParams = { // 解决gridLOGO不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
					parref : Ext.getCmp("Hidden_HospID").getValue()
				};
				gridLOGO.getStore().load({
					params : {
						start : 0,
						limit : pagesize1
					}
				});
				
			},
			"close" : function() {
			}
		}
	});
	
	
	
	// 增加按钮
	var LOGObtnAdd = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id : 'LOGObtnAdd',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('LOGObtnAdd'),
		handler : function() {
			var HOSPRowId=Ext.getCmp("Hidden_HospID").getValue()
			var re=tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","SaveTempHospLogo","HOSPID",HOSPRowId);	//将医院id存到临时global
			LOGOwin.setTitle('添加');
			LOGOwin.setIconClass('icon-add');
			LOGOwin.show();
			LOGOwinForm.getForm().reset();
			Ext.getCmp('LOGOImg').getEl().dom.src='../scripts/bdp/App/Locations/HospitalLogo/null.jpg';
		},
		scope : this
	});

	// 修改按钮
	var LOGObtnEdit = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'LOGObtnUpdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LOGObtnUpdate'),
				handler : function() {
					if (gridLOGO.selModel.hasSelection()) {
						LOGOwin.setTitle('修改');
						LOGOwin.setIconClass('icon-update');
						LOGOwin.show();
						loadLOGOFormData(gridLOGO);
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
	var LOGObtnRefresh = new Ext.Button({
				id : 'LOGObtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LOGObtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : Refresh=function() {
					
					gridLOGO.getStore().baseParams={  //解决gridLOGO不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								parref : Ext.getCmp("Hidden_HospID").getValue()
					};
					gridLOGO.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
				}
	});
	
	var LOGOds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : LOGO_QUERY_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'LOGORowId',
								mapping : 'LOGORowId',
								type : 'string'
							}, {
								name : 'LOGOParRef',
								mapping : 'LOGOParRef',
								type : 'string'
							}, {
								name : 'LOGOChildsub',
								mapping : 'LOGOChildsub',
								type : 'string'
							}, {
								name : 'LOGOCode',
								mapping : 'LOGOCode',
								type : 'string'
							}, {
								name : 'LOGOUrl',
								mapping : 'LOGOUrl',
								type : 'string'
							}, {
								name : 'LOGORemarks',
								mapping : 'LOGORemarks',
								type : 'string'
							}, {
								name : 'LOGOImg',
								mapping : 'LOGOImg',
								type : 'string'
							}])
		});

	// 加载数据
	LOGOds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var LOGOpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : LOGOds,
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

	var LOGOsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var LOGOtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [LOGObtnAdd, '-', LOGObtnEdit, '-',
						LOGObtnDel, '-',LOGObtnRefresh,{ //'科室ID:', 
							xtype : 'textfield',
							hidden:true,
							id:'Hidden_HospID'
						},'-']
			});

	// 创建Grid
	var gridLOGO = new Ext.grid.GridPanel({
				id : 'gridLOGO',
				region : 'center',
				width : 560,
				height : 370,
				closable : true,
				store : LOGOds,
				trackMouseOver : true,
				columns : [LOGOsm, {
							header : 'LOGORowId',
							width : 80,
							sortable : true,
							dataIndex : 'LOGORowId',
							hidden : true
						}, {
							header : 'LOGOParRef',
							width : 80,
							sortable : true,
							dataIndex : 'LOGOParRef',
							hidden : true
						}, {
							header : 'LOGOChildsub',
							width : 80,
							sortable : true,
							dataIndex : 'LOGOChildsub',
							hidden : true
						}, {
							header : '业务代码',
							width : 80,
							sortable : true,
							dataIndex : 'LOGOCode'
						}, {
							header : 'Logo Url地址',
							width : 200,
							sortable : true,
							dataIndex : 'LOGOUrl'
						}, {
							header : '备注',
							width : 80,
							sortable : true,
							dataIndex : 'LOGORemarks'
						}, {
							header : '图片',
							width : 80,
							sortable : true,
							dataIndex : 'LOGOImg',
							renderer :function(value){	//value为列值
							
								if (value==""){
									//return "<img src='../scripts/bdp/Framework/BdpIconsLib/null.png' style='border: 0px '/>"
								}
								else{
									return "<img src='"+value+"' style='border: 0px ;width : 30;height: 20'/>"
								}
							}
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
				bbar : LOGOpaging,
				tbar : LOGOtbbutton,
				stateId : 'gridLOGO'
			});
	Ext.BDP.FunLib.ShowUserHabit(gridLOGO,"User.CTHospitalLogo");

	// 载入被选择的数据行的表单数据
	var loadLOGOFormData = function(gridLOGO) {
		var _record = gridLOGO.getSelectionModel().getSelected();
		if (!_record) {
		} else {
			LOGOwinForm.form.load({
						url : LOGO_OPEN_ACTION_URL + '&id='+ _record.get('LOGORowId'),
						// waitMsg : '正在载入数据...',
						success : function(form, action) {
							// Ext.Msg.alert('编辑','载入成功！');
							var imgdata=Ext.getCmp("LOGOUrl").getValue();
							if(imgdata!=""){
								var FileFlag=tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","FileExist",imgdata);
								if (FileFlag==1){
									Ext.getCmp('LOGOImg').getEl().dom.src=imgdata;
								}else{
									Ext.getCmp('LOGOImg').getEl().dom.src=_record.get('LOGOImg');
								}
								
							}else{
								Ext.getCmp('LOGOImg').getEl().dom.src='../scripts/bdp/App/Locations/HospitalLogo/null.jpg';
							}	
						},
						failure : function(form, action) {
							Ext.Msg.alert('编辑', '载入失败！');
						}
					});
			
				
		}
	};

	gridLOGO.on("rowdblclick", function(grid, rowIndex, e) {
				LOGOwin.setTitle('修改');
				LOGOwin.setIconClass('icon-update');
				LOGOwin.show();
				loadLOGOFormData(gridLOGO);
			});

	//----------------------子表完----------------------
	
    function getLOGOPanel(){
	var winLOGO = new Ext.Window({
			title:'',
			width:Math.min(Ext.getBody().getViewSize().width-10,1400),
            height:Math.min(Ext.getBody().getViewSize().height-10,760),
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
			items: gridLOGO,
			listeners:{
				"show":function(){
					tkMakeServerCall("web.DHCBL.CT.CTHospitalLogo","CloseDeleteFile");	//重新打开窗口时删除刷新前已上传的图片文件（上传图片后直接刷新页面的情况）
				},
				"hide":function(){
				},
				"close":function(){
				}
			}
		});
	//gridResource.getStore().load({params:{start:0, limit:12,RESCode:ctcode}})	
  	return winLOGO;
	}

	