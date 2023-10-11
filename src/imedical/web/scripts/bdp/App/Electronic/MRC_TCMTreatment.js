/// 名称: 中医治法
/// 描述: 中医治法，包含增删改查功能
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2020-12-22
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
Ext.onReady(function() {
	
	///陈莹 根据系统配置 获取日期格式  
	/*try
	{
		var BDPDateFormat=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetDateFormat");
	}
	catch(e)
	{
		var BDPDateFormat='j/n/Y';
	}
	*/
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "MRC_TCMTreatment"
	});
	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.MRCICDDx";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//翻译
	Ext.BDP.FunLib.TableName="MRC_TCMTreatment";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
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
			RowID=rows[0].get('TCMTRowId');
			Desc=rows[0].get('TCMTDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
  
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCTCMTreatment&pClassMethod=GetList";
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCTCMTreatment&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCTCMTreatment&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCTCMTreatment";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCTCMTreatment&pClassMethod=OpenData";
		

    
	
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				title:'基本信息',
				labelAlign : 'right',
				labelWidth : 120,
				autoScroll : true, //滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'TCMTRowId',mapping:'TCMTRowId',type:'string'},
                                         {name: 'TCMTCode',mapping:'TCMTCode',type:'string'},
                                         {name: 'TCMTDesc',mapping:'TCMTDesc',type:'string'},
                                         {name: 'TCMTNationalDesc',mapping:'TCMTNationalDesc',type:'string'},
                                         {name: 'TCMTDateFrom',mapping:'TCMTDateFrom',type:'string'},
                                         {name: 'TCMTDateTo',mapping:'TCMTDateTo',type:'string'},
                                         {name: 'TCMTValid',mapping:'TCMTValid',type:'string'},
                                         {name: 'TCMTNumber',mapping:'TCMTNumber',type:'string'},
                                         {name: 'TCMTAlias',mapping:'TCMTAlias',type:'string'}
                                        
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				items : [{
							xtype: 'textfield',
							fieldLabel : 'TCMTRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'TCMTRowId'
						}, {
							xtype: 'textfield',
							fieldLabel : '<font color=red>*</font>代码', //代码允许重复
							name : 'TCMTCode',
							id:'TCMTCode',
							maxLength:100,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTCode'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTCode')),
							allowBlank : false,
							blankText: '代码不能为空'
						}, {
							xtype: 'textfield',
							fieldLabel : '<font color=red>*</font>名称',
							name : 'TCMTDesc',
							id:'TCMTDesc',
							maxLength:220,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTDesc'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTDesc')),
							allowBlank : false,
							blankText: '名称不能为空',
			                enableKeyEvents:true, 
							validationEvent : 'blur',
			                validator : function(thisText){
			                	//Ext.Msg.alert(thisText);
			                    if(thisText==""){ //当文本框里的内容为空的时候不用此验证
			                    	return true;
			                    }
			                    var className =  "web.DHCBL.CT.MRCTCMTreatment"; //后台类名称
			                    var classMethod = "FormValidate"; //数据重复验证后台函数名
			                    var id="";
			                    if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
			                    	var _record = grid.getSelectionModel().getSelected();
			                    	var id = _record.get('TCMTRowId'); //此条数据的rowid
			                    }
			                    var flag = "";
			                    var flag = tkMakeServerCall(className,classMethod,id,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
			                    //Ext.Msg.alert(flag);
			                    if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
			                     	return false;
			                     }else{
			                     	return true;
			                     }
			                },
			                invalidText : '该名称已经存在',
						    listeners : {
						        'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
						        'blur' : function(){
									if (Ext.getCmp("TCMTAlias").getValue=="")  //别名为空时自动生成别名
									{
										Ext.getCmp("TCMTAlias").setValue(Pinyin.GetJPU(Ext.getCmp("TCMTDesc").getValue()));
									}
								}
						    }
							
						}, {
							xtype: 'textfield',
							fieldLabel : '国家标准名称',
							name : 'TCMTNationalDesc',
							id:'TCMTNationalDesc',
							maxLength:100,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTNationalDesc'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTNationalDesc'))
						}, {
							xtype: 'textfield',
							fieldLabel : '编号',
							name : 'TCMTNumber',
							id:'TCMTNumber',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTNumber'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTNumber'))
						}, {
							xtype: 'textfield',
							fieldLabel : '检索码',
							name : 'TCMTAlias',
							id:'TCMTAlias',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTAlias'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTAlias'))
						}, {
							
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'TCMTDateFrom',
							format : BDPDateFormat,
							id:'TCMTDateFrom',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTDateFrom'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTDateFrom')),
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'TCMTDateTo',
							id:'TCMTDateTo',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTDateTo'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTDateTo')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
						
							xtype : 'checkbox',
							fieldLabel : '临床可用标识',
							name : 'TCMTValid',
							id:'TCMTValid',
							checked:true, // 默认勾选
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('TCMTValid'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('TCMTValid')),
							inputValue : 'Y'
						
						}]						
				
				
			});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });	
			 
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		title : '',
		width : 450,
		height:400,
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
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function () {
				
				var startDate = Ext.getCmp("form-save").getForm().findField("TCMTDateFrom").getValue();
    			var endDate = Ext.getCmp("form-save").getForm().findField("TCMTDateTo").getValue();
				if (Ext.getCmp("form-save").getForm().findField("TCMTCode").getValue()=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (Ext.getCmp("form-save").getForm().findField("TCMTDesc").getValue()=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (startDate=="") {
    				Ext.Msg.show({ title : '提示', msg : '开始日期不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
    			if (startDate != "" && endDate != "") {
    				startDate = startDate.format("Ymd");
    				endDate = endDate.format("Ymd");
        			if (startDate > endDate) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始日期不能大于结束日期!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
   			 	}
    			
				if (win.title == "添加")
				{
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {									   ///多院区医院
									    
								},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												grid.getStore().load({
															params : {
																start : 0,
																limit : 1,
																rowid : myrowid
															}
														});
											}
								});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败!' + errorMsg,
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
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid) //只查询列表里修改的这一条数据
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
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
				
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag(); 
				WinForm.getForm().reset();  //表单重置
			},
			"close" : function() {
			}
		}
	});
	
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();

					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				},
				scope : this
			});
	
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler :UpdateData= function () {
					
					if (!grid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的数据!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
					
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						if (rows.length!=1) {
				            Ext.Msg.show({
								title : '提示',
								msg : '请选择一条需要修改的数据!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
				        } else {
				            win.setTitle('修改');
							win.setIconClass('icon-update');
							win.show('');
							Ext.getCmp("form-save").getForm().reset();
							
					        
				            Ext.getCmp("form-save").getForm().load({
				                url : OPEN_ACTION_URL + '&id=' + rows[0].get('TCMTRowId'),
				                //waitMsg : '正在载入数据...',
				                success : function(form,action) {
				                    //Ext.Msg.alert(action);
				                	//Ext.Msg.alert('编辑', '载入成功');
				                	
				                },
				                failure : function(form,action) {
				                	Ext.Msg.alert('编辑', '载入失败');
				                }
				            });
				            
				            //激活基本信息面板
				            tabs.setActiveTab(0);
					        //加载别名面板
				            var _record = grid.getSelectionModel().getSelected();
				            AliasGrid.DataRefer = _record.get('TCMTRowId');
					        AliasGrid.loadGrid();
				        }
				        
			        }
			        
				}
			});
	
	var fields=[{
					name : 'TCMTRowId',
					mapping : 'TCMTRowId',
					type : 'int'
				}, {
					name : 'TCMTCode',
					mapping : 'TCMTCode',
					type : 'string'
				}, {
					name : 'TCMTDesc',
					mapping : 'TCMTDesc',
					type : 'string'
				}, {
					name : 'TCMTNationalDesc',
					mapping : 'TCMTNationalDesc',
					type : 'string'
				}, {
					name : 'TCMTNumber',
					mapping : 'TCMTNumber',
					type : 'string'
				}, {
					name : 'TCMTAlias',
					mapping : 'TCMTAlias',
					type : 'string'
				}, {
					name : 'TCMTDateFrom',
					mapping : 'TCMTDateFrom',
					type : 'string'
				}, {
					name : 'TCMTDateTo',
					mapping : 'TCMTDateTo',
					type : 'string'
				}, {
					name : 'TCMTValid',
					mapping : 'TCMTValid',
					type : 'string'
				
				}
		]
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields )
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		

	
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
					});

	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
	
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin
				,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog
				
			]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					
					grid.getStore().baseParams={
						code:Ext.getCmp("TextCode").getValue(),  //代码
						desc:Ext.getCmp("TextDesc").getValue(),  //名称
						nationaldesc:Ext.getCmp("TextNationalDesc").getValue(),  //国家标准名称
						validflag:Ext.getCmp("TextValidFlag").getValue()  //临床可用标识
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_main
						}
					});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();  //代码
					Ext.getCmp("TextDesc").reset();  //名称
					Ext.getCmp("TextNationalDesc").reset();  //国家标准名称
					Ext.getCmp("TextValidFlag").setValue(""); //临床可用标识
					grid.getStore().baseParams={
						
					};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'名称', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							emptyText : '名称/检索码/别名'
						}, '-',
						'国家标准名称', {
							xtype : 'textfield',
							id : 'TextNationalDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextNationalDesc')
						}, '-', '临床可用标识',{
							xtype : 'combo',
							listWidth:100,
							width:100,
							shadow:false,
							id :'TextValidFlag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextValidFlag'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}, {
									name : '不限',
									value : ''
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name'
						},
						btnSearch, '-', btnRefresh
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	Ext.getCmp("TextValidFlag").setValue("");
	
	var GridCM=[
	new Ext.grid.RowNumberer({ header: '序号', locked: true, width: 40 }),
	new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'TCMTRowId',
							hidden : true,
							width :80
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'TCMTCode',
							width : 140
						}, {
							header : '名称',
							sortable : true,
							dataIndex : 'TCMTDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 200
						}, {
							header : '国家标准名称',
							sortable : true,
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'TCMTNationalDesc',
							width : 140
						}, {
							header : '编号',
							sortable : true,
							dataIndex : 'TCMTNumber',
							width : 140
						
						}, {
							header : '检索码',
							sortable : true,
							dataIndex : 'TCMTAlias',
							width : 140
						
						}, {
							header : '开始日期',
							sortable : true,
							dataIndex : 'TCMTDateFrom',
							width : 100
						}, {
							header : '结束日期',
							sortable : true,
							dataIndex : 'TCMTDateTo',
							width : 100
						}, {
							header : '临床可用标识',
							sortable : true,
							dataIndex : 'TCMTValid',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width : 120
						
						
						}]
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM, 
				stripeRows : true,
				title : '中医治法',
				//stateful : true,
				viewConfig : { forceFit : true },
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), //单选
				//sm : new Ext.grid.CheckboxSelectionModel(), //多选
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	
	//翻译按钮
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
      			var _record = grid.getSelectionModel().getSelected();
       			 var selectrow = _record.get('TCMTRowId');	           
	 	} else {
	 		var selectrow="";
		 }
		Ext.BDP.FunLib.SelectRowId = selectrow;	

	})
	
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				UpdateData()
			});
	
	/** 快捷键 */
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData);
	
	var loadflag=0;   
    /** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid],
				 listeners:{
			
					'afterlayout':function(){
						//打开页面默认加载数据(以下)
						if (loadflag==0)
						{
							loadflag=1
						   /** grid加载数据 */
							grid.getStore().baseParams={
								
							};
							grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
								}
							});
						
							
						}
					}
				
				}
			});
		
	
});
