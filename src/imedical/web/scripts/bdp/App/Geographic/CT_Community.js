/// 名称: 地理信息-社区/村维护
/// 编写者: 基础数据平台组-孙凤超
/// 编写日期: 2015-11-13
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	
    /// 调用过敏原因的后台类方法
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTCommunity&pClassMethod=GetList"; 
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCommunity&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCommunity";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCommunity&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCommunity&pClassMethod=DeleteData";
	/// 街道/乡镇
	var STREET_QUERY_ACTION="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.CT.CTLocalityType&pClassMethod=GetDataForCmb1&type="+escape('Street'); 
	var limit = Ext.BDP.FunLib.PageSize.Main;
	var combopage=Ext.BDP.FunLib.PageSize.Combo  
 
     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_Community"
  });
	 Ext.BDP.FunLib.TableName="CT_Community";
     /// 获取查询配置按钮 
     var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名
	 var btnTrans=Ext.BDP.FunLib.TranslationBtn;
	 var TransFlag=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	 if (TransFlag=="false")
	 {
		btnTrans.hidden=false;
	  }
	 else
	 {
		btnTrans.hidden=true;
	 }
	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.CTCommunity";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName) ;
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
   if (btnhislogflag==1)
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
       RowID=rows[0].get('CTCMUNTRowId');
       Desc=rows[0].get('CTCMUNTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	/************************************** 删除按钮 ********************************/
	var btnDel = new Ext.Toolbar.Button({
			text : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
	   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			handler : DelData=function() {
			if (grid.selModel.hasSelection()) {
                var gsm = grid.getSelectionModel(); 
                var rows = gsm.getSelections(); 
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
                         //删除所有别名
                        AliasGrid.DataRefer=rows[0].get('CTCMUNTRowId') ;
                        AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTCMUNTRowId')
							},
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
														Ext.BDP.FunLib.DelForTruePage(grid,limit);
													 }
											});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:' + jsonData.info
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
	/*****************************************创建Form表单 *******************************************/
	  
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
                title:'基本信息',
				labelAlign : 'right',
				labelWidth :130,
                frame:true,
        		reader: new Ext.data.JsonReader({root:'list'},
                         [{name: 'CTCMUNTRowId',mapping:'CTCMUNTRowId',type:'int'},
                         {name: 'CTCMUNTCode',mapping:'CTCMUNTCode',type:'string'},
                         {name: 'CTCMUNTDesc',mapping:'CTCMUNTDesc',type:'string'},
                         {name:'CTCMUNTNationalCode',mapping:'CTCMUNTNationalCode',type:'string'},
                         {name:'CTCMUNTActiveFlag',mapping:'CTCMUNTActiveFlag',type:'string'} ,
                         {name:'CTCMUNTDR',mapping:'CTCMUNTDR',type:'string'} 
                  ]),
				defaults : {
					width : 200,
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'CTCMUNTRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'CTCMUNTRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'CTCMUNTCode',
                            labelSeparator : "",
							id:'CTCMUNTCodeF',
  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTCommunity";  
	                            var classMethod = "FormValidate";  	                            
	                            var id="";
	                            if(win.title=='修改'){  
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('CTCMUNTRowId');  
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText); 
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'CTCMUNTDesc',
                            labelSeparator : "",
							id:'CTCMUNTDescF',
  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTDescF')),
							allowBlank : false
						},{
							xtype:'bdpcombo',
							fieldLabel : '所属乡镇/街道',
							id:'CTCMUNTNationalCodeF',
  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTNationalCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTNationalCodeF')) ,
					        loadByIdParam:'rowid',
					        store : new Ext.data.Store({
					         	proxy : new Ext.data.HttpProxy({ url : STREET_QUERY_ACTION }),
					         	reader : new Ext.data.JsonReader({
					          	totalProperty : 'total',
					          	root : 'data',
					          	successProperty : 'success'
					         }, [ 'LOCTYPERowId', 'LOCTYPEDesc' ])
					       }),
						     queryParam : 'desc',
						     triggerAction : 'all',
						     forceSelection : true,
						     selectOnFocus : false,
						     minChars : 0,
						     listWidth : 250,
						     valueField : 'LOCTYPERowId',
						     displayField : 'LOCTYPEDesc',
						     hiddenName : 'CTCMUNTNationalCode',
						     pageSize :combopage 
						},{
							xtype:'checkbox',
                            labelSeparator : "",
							fieldLabel : '是否激活',
							id : 'CTCMUNTActiveFlagF',
							name : 'CTCMUNTActiveFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTActiveFlagF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCMUNTActiveFlagF')),
							inputValue : true ? 'Y' : 'N',
							checked : true
						} ]
			});
   
   /*********************************重置form的数据清空**************************************/
      var ClearForm = function()
      {
         Ext.getCmp("form-save").getForm().reset();   
      }
 
 /*********************************关闭弹出窗口时的函数方法*********************************/
        var closepages= function (){
            win.hide();
            ClearForm();
         }  
  
 /*******************************定义‘基本信息’框*******************************************/
 var tabs=new Ext.TabPanel({
      id:'basic',
      activeTab: 0,
      frame:true,
      items:[WinForm,AliasGrid]
 });
  Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	/***************************************** 增加修改时弹出窗口******************************** */
	var win = new Ext.Window({
		  width : 410,
		  height: 280,
		  layout : 'fit',
		  closeAction : 'hide',
		  plain : true,
		  modal : true,
		  frame : true,
		  autoScroll : true,
		  collapsible : true,
		  hideCollapseTool : true,
		  titleCollapse : true,
		  bodyStyle : 'padding:3px',
		  buttonAlign : 'center',
          items : tabs,
		  buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				var tempCode = Ext.getCmp("CTCMUNTCodeF").getValue();
				var tempDesc = Ext.getCmp("CTCMUNTDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    		 
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true,  
						url : SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
                                win.hide();
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
												Ext.Msg.alert('提示', '添加数据失败!');
											}
										})
									} else {
										Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
											if (btn == 'yes') {
												WinForm.form.submit({
													clientValidation : true, // 进行客户端验证
													url : SAVE_ACTION_URL,
													method : 'POST',
													success : function(form, action) {
					                                    AliasGrid.saveAlias();
														if (action.result.success == 'true') {
															var myrowid = 'rowid='+action.result.id;
					                                        win.hide();
								                            Ext.Msg.show({
								                                           title : '<font color=blue>提示</font>',
								                                           msg : '<font color=green> 修改成功!</font>',
								                                           animEl: 'form-save',
								                                           icon : Ext.Msg.INFO,
								                                           buttons : Ext.Msg.OK,
								                                           fn : function(btn) {
								                                             Ext.BDP.FunLib.ReturnDataForUpdate('grid',QUERY_ACTION_URL,myrowid);
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
														Ext.Msg.alert('提示', '修改数据失败!');
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
					                ClearForm(); 
								}
							}],
							listeners : {
								"show" : function() {
									Ext.getCmp("form-save").getForm().findField("CTCMUNTCode").focus(true,800);
								},
								"hide" : function(){
					                 Ext.BDP.FunLib.Component.FromHideClearFlag();
					                 closepages();
					               },
								"close" : function() {}
							}
						});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
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
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					var _record = grid.getSelectionModel().getSelected();
					if (!_record) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						tabs.setActiveTab(0);
						win.show('');
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('CTCMUNTRowId'),
			                success : function(form,action) {
			                	  AliasGrid.DataRefer = _record.get('CTCMUNTRowId');
					              AliasGrid.loadGrid();
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			        }

				}
			});
	/** grid数据存储 */
	var fields= [{
					name : 'CTCMUNTRowId',
					mapping : 'CTCMUNTRowId',
					type : 'int'
				}, {
					name : 'CTCMUNTCode',
					mapping : 'CTCMUNTCode',
					type : 'string'
				}, {
					name : 'CTCMUNTDesc',
					mapping : 'CTCMUNTDesc',
					type : 'string'
				},{
					name:'CTCMUNTNationalCode',
					mapping:'CTCMUNTNationalCode',
					type:'string'
				},{
					name:'CTCMUNTActiveFlag',
					mapping:'CTCMUNTActiveFlag',
					type:'string'
				},{
                    name:'CTCMUNTDR',
                    mapping:'CTCMUNTDR',
                    type:'string'
                }]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
			});
  	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/** grid加载数据 */
	  ds.load({
		params : {
					  start : 0,
					  limit : limit
				} 
			});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
            pageSize: limit,
            store: ds,
            displayInfo: true,
            displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
            emptyMsg : "没有记录",
            plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
            listeners : {
				"change":function (t,p)
				{ 
		           limit=this.pageSize;
		       }
           }
     });
	/** *****************************************增删改工具条 ***************************************/
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
		});
	/** ************************************搜索按钮 ***********************************************/
	 var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue(),
							streetdr : Ext.getCmp("TextCTCMUNTNationalCode").getValue()
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit :limit
						}
					});
				}
			});
	/** *********************************重置按钮************************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextCTCMUNTNationalCode").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
							params : {
								    	 start : 0,
							    		 limit :limit
							    	}
							});
				 }
			});
	/** ********************************搜索工具条 ***********************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						}, '-',
						'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},'-',
						'所属乡镇/街道',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							triggerAction : 'all',
							listWidth:250,
							shadow:false,
							fieldLabel : '<font color=red></font>所属乡镇/街道',
							id :'TextCTCMUNTNationalCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTCMUNTNationalCode'),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : STREET_QUERY_ACTION }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'LOCTYPECode',mapping:'LOCTYPECode'},
										{name:'LOCTYPEDesc',mapping:'LOCTYPEDesc'} ])
								}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'LOCTYPEDesc',
							valueField : 'LOCTYPECode'
						}, '-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	/** ***************************************创建grid **********************************************/
	var GridCM= [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'CTCMUNTRowId',
							sortable : true,
							dataIndex : 'CTCMUNTRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,  
							dataIndex : 'CTCMUNTCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'CTCMUNTDesc'
						},{
							header:'所属乡镇/街道',
							sortable:true,
							dataIndex:'CTCMUNTNationalCode'
						},{
							header:'激活',
							sortable:true,
							dataIndex:'CTCMUNTActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{
                            header:'CTCMUNTDR',
                            dataIndex:'CTCMUNTDR',
                            hidden:true,
                            sortable:true
                        } ];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				title : '社区/村',
				viewConfig : {
					forceFit : true
				},
				columnLines : true,  
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), 
				bbar : paging,
				tbar : tb,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
   		Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
   		btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		 	 var _record=grid.getSelectionModel().getSelected();
	         var selectrow=_record.get('CTCMUNTRowId');
		 }
		else
		{
		  	 var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
	/** *********************************************grid双击事件*********************************** */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
		       } else {
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					tabs.setActiveTab(0);
					win.show();
		            Ext.getCmp("form-save").getForm().load({
		                   url : OPEN_ACTION_URL + '&id=' + _record.get('CTCMUNTRowId'),
		                   success : function(form,action) {
                            
                        },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
                     
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('CTCMUNTRowId');
               AliasGrid.loadGrid();
		     }
	});
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/******************************快捷键操作 ************************************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	 });
   });
