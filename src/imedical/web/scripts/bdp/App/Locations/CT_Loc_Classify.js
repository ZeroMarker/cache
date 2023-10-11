/// 名称: 科室病区--科室分类
/// 描述: 科室病区--科室分类---本功能维护的表为PAC_AdmTypeLocation.js，是病人管理-访问类型位置。
/// 编写者: 基础数据平台组-蔡昊哲
/// 编写日期: 2013-7-15


	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var LocClassify_CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var LocClassify_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassQuery=GetList";
	var LocClassify_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACAdmTypeLocation";
	var LocClassify_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=OpenData";
	var LocClassify_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAdmTypeLocation&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Pop;

	/** 删除按钮 */
	var LocClassifybtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除',
		iconCls : 'icon-delete',
		id:'LocClassify_del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('LocClassify_del_btn'),
		handler : function LocClassifyDelData() {
			if (LocClassifygrid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = LocClassifygrid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : LocClassify_DELETE_ACTION_URL,
							method : 'POST',
							params : {'id' : rows[0].get('ADMLOCRowId')},
							callback : function(options, success, response) {
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = LocClassifygrid.getBottomToolbar().cursor; //加载当前页
												var totalnum=LocClassifygrid.getStore().getTotalCount();
												if((totalnum!=1)&&(totalnum/pagesize_main!=0)&&(totalnum%pagesize_main==1)){ startIndex-=pagesize_main; }
												LocClassifygrid.getStore().load({
															params : {start : startIndex, limit : pagesize_main}
														});
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:' + jsonData.info
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
	/** 创建Form表单 */
	var LocClassifyWinForm = new Ext.form.FormPanel({
				id : 'LocClassify-form-save',
				labelAlign : 'right',
				labelWidth : 70,
				baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ADMLOCRowId',mapping:'ADMLOCRowId',type:'string'},
                                         {name: 'ADMLOCAdmType',mapping:'ADMLOCAdmType',type:'string'},
                                         {name: 'ADMLOCCTLOCDR',mapping:'ADMLOCCTLOCDR',type:'string'}
                                   ]),
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
							fieldLabel : '<font color=red>*</font>科室分类',
							xtype : 'combo',
							hiddenName : 'ADMLOCAdmType',
							id:'ADMLOCAdmTypeF',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMLOCAdmTypeF'),
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['O', '门诊'],
											['I', '住院'],
											['E', '急诊'],
											['H', '体检']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
							/*listeners : { // 实现mode为local时的模糊查询功能
								'beforequery' : function(e) {
									var combo = e.combo;
									if(!e.forceAll){
										var input = e.query;
										var input = Ext.util.Format.uppercase(input); // 转换大写,小写用lowercase()
										var regExp = new RegExp(".*" + input + ".*"); // 检索的正则
										combo.store.filterBy(function(record,id) { // 执行检索
											var text = record.get(combo.displayField); // 得到每个record的项目名称值
											var text = Ext.util.Format.uppercase(text);
											return regExp.test(text);
										});
								   		combo.expand();
										return false;
									}
								}
							}*/
						}, {
							xtype : 'combo',
							hidden : true,
							hideLabel : 'True',
							fieldLabel : '<font color=red>*</font>位置描述',
							hiddenName : 'ADMLOCCTLOCDR',
							id:'ADMLOCCTLOCDRF',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('ADMLOCCTLOCDRF'),
							allowBlank : false,
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : LocClassify_CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,//true表示获取焦点时选中既有值
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc'
						}]
			});
	/** 增加修改时弹出窗口 */
	var LocClassifywin = new Ext.Window({
		title : '',
		width : 280,
		height:150,
		layout : 'fit',
		plain : true,// true则主体背景透明
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
		items : LocClassifyWinForm,
		buttons : [{
			text : '保存',
			id:'save_btn_LocClassify',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn_LocClassify'),
			handler : function() {
				var ADMLOCAdmType = Ext.getCmp("LocClassify-form-save").getForm().findField("ADMLOCAdmType").getValue();
				var ADMLOCCTLOCDR = Ext.getCmp("LocClassify-form-save").getForm().findField("ADMLOCCTLOCDR").getValue();
				if (ADMLOCAdmType=="") {
    				Ext.Msg.show({ title : '提示', msg : '科室分类不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (ADMLOCCTLOCDR=="") {
    				Ext.Msg.show({ title : '提示', msg : '位置描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
				if (LocClassifywin.title == "添加") {
					LocClassifyWinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : LocClassify_SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								LocClassifywin.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												LocClassifygrid.getStore().load({ params : {start : 0, limit : pagesize_main} });
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br />错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({title : '提示',msg : '添加失败!' + errorMsg,minWidth : 200,icon : Ext.Msg.ERROR,buttons : Ext.Msg.OK});
							}

						},
						failure : function(form, action) { Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!'); }
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							LocClassifyWinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : LocClassify_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										LocClassifywin.hide();
										//var myrowid = action.result.id;
										var myrowid = "rowid="+ action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("LocClassifygrid",LocClassify_QUERY_ACTION_URL,myrowid);
													//LocClassifygrid.getStore().load({ params : {start : 0, limit : pagesize_main} });														
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
					// LocClassifyWinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				LocClassifywin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("LocClassify-form-save").getForm().findField("ADMLOCAdmType").focus(true,800);
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	/** 添加按钮 */
	var LocClassifybtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'LocClassify_add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('LocClassify_add_btn'),
				handler : function AddData() {
					LocClassifywin.setTitle('添加');
					LocClassifywin.setIconClass('icon-add');
					LocClassifywin.show('new1');
					LocClassifyWinForm.getForm().reset();
					Ext.getCmp("ADMLOCCTLOCDRF").setValue(Ext.getCmp("hidden_LocRef").getValue());
				},
				scope : this
			});
	/** 修改按钮 */
	var LocClassifybtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'LocClassify_update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('LocClassify_update_btn'),
				handler : function LocClassifyUpdateData() {
					var _record = LocClassifygrid.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			            LocClassifywin.setTitle('修改');
						LocClassifywin.setIconClass('icon-update');
						LocClassifywin.show('');
			            Ext.getCmp("LocClassify-form-save").getForm().load({
			                url : LocClassify_OPEN_ACTION_URL + '&id=' + _record.get('ADMLOCRowId'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }
				}
			});
	/** grid数据存储 */
	var LocClassifyds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : LocClassify_QUERY_ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ADMLOCRowId',
									mapping : 'ADMLOCRowId',
									type : 'string'
								}, {
									name : 'ADMLOCAdmType',
									mapping : 'ADMLOCAdmType',
									type : 'string'
								}, {
									name : 'ADMLOCCTLOCDesc',
									mapping : 'ADMLOCCTLOCDesc',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 *//*
	var LocClassifyloadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : LocClassifyds
					});*/
			
	/** grid加载数据 */
	LocClassifyds.load({
				params : { start : 0, limit : pagesize_main },
				callback : function(records, options, success) {
					// alert(options);
					// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
				}
			});
	/** grid分页工具条 */
	var LocClassifypaging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : LocClassifyds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				 plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize_main = this.pageSize;
				         }
		        }
			});
	/** 增删改工具条 */
	var LocClassifytbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [LocClassifybtnAddwin, '-', LocClassifybtnEditwin, '-', LocClassifybtnDel,
			{
			xtype: 'textfield',
			id: 'hidden_LocRef',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('hidden_LocRef'),
			hidden : true
			}]
		});
	/** 搜索按钮 */
	var LocClassifybtnSearch = new Ext.Button({
				id : 'LocClassifybtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('LocClassifybtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					LocClassifygrid.getStore().baseParams={
							AdmType : Ext.getCmp("AdmType").getValue(),
							CTLOCRowID : Ext.getCmp("CTLOCRowID").getValue()
					};
					LocClassifygrid.getStore().load({
						params : { start : 0, limit : pagesize_main }
					});
				}
			});
	/** 重置按钮 */
	var LocClassifybtnRefresh = new Ext.Button({
				id : 'LocClassifybtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("AdmType").reset();
					Ext.getCmp("CTLOCRowID").reset();
					LocClassifygrid.getStore().baseParams={};
					LocClassifygrid.getStore().load({
								params : { start : 0, limit : pagesize_main }
							});
				}
			});
	/** 搜索工具条 */
	var LocClassifytb = new Ext.Toolbar({
				id : 'LocClassifytb',
				items : ['科室分类:', {
							id : 'AdmType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('AdmType'),
							xtype : 'combo',
							width : 140,
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['O', 'OutPatient'],
											['I', 'InPatient'],
											['E', 'Emergency'],
											['H', 'HealthPromotion']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							listWidth : 140,
							valueField : 'value',
							displayField : 'text'
							//hiddenName : 'ADMLOCAdmType'//不能与id相同
						}, '-', '位置:', {
							id : 'CTLOCRowID',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('CTLOCRowID'),
							xtype : 'combo',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : LocClassify_CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							mode : 'remote',
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,//true表示获取焦点时选中既有值
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc'
						}, '-',  LocClassifybtnSearch, '-', LocClassifybtnRefresh
				],
				listeners : {
					render : function() {
						//LocClassifytbbutton.render(LocClassifygrid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	/** 创建grid */
	var LocClassifygrid = new Ext.grid.GridPanel({
		id : 'LocClassifygrid',
		region : 'center',
		closable : true,
		store : LocClassifyds,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'ADMLOCRowId',
					sortable : true,
					dataIndex : 'ADMLOCRowId',
					hidden : true
				}, {
					header : '科室分类',
					sortable : true,
					dataIndex : 'ADMLOCAdmType',
					renderer : function(v){
						if(v=='O'){ return '门诊'; }
						if(v=='I'){ return '住院'; }
						if(v=='E'){ return '急诊'; }
						if(v=='H'){ return '体检'; }
					}
				}, {
					header : '位置描述',
					sortable : true,
					dataIndex : 'ADMLOCCTLOCDesc'
				}],
		stripeRows : true,
		//title : '访问类型位置',
		//stateful : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : LocClassifypaging,
		tbar : LocClassifytbbutton,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'LocClassifygrid'
	});
	
	Ext.BDP.FunLib.ShowUserHabit(LocClassifygrid,"LocClassify");
	/** grid双击事件 */
	LocClassifygrid.on("rowdblclick", function(grid, rowIndex, e) {				
				var _record = LocClassifygrid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            LocClassifywin.setTitle('修改');
					LocClassifywin.setIconClass('icon-update');
					LocClassifywin.show();
		            Ext.getCmp("LocClassify-form-save").getForm().load({
		                url : LocClassify_OPEN_ACTION_URL + '&id=' + _record.get('ADMLOCRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});

	 function getLocClassifyPanel(){
	var winLocClassify = new Ext.Window({
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
			items: LocClassifygrid,
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
  	return winLocClassify;
}