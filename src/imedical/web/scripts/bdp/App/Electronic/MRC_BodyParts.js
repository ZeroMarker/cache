/// 名称: 电子病例-身体部位
/// 编写者: 基础数据平台组-孙凤超
/// 编写日期: 2014-12-17
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	
    /// 调用过敏原因的后台类方法
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCBodyParts&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCBodyParts&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCBodyParts";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCBodyParts&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCBodyParts&pClassMethod=DeleteData";
	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var limit = Ext.BDP.FunLib.PageSize.Main;

 
     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "MRC_BodyParts"
  });
	 Ext.BDP.FunLib.TableName="MRC_BodyParts";
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
    Ext.BDP.FunLib.SortTableName = "User.MRCBodyParts";
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
       RowID=rows[0].get('BODPRowId');
       Desc=rows[0].get('BODPDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

	/************************************** 删除按钮 ****************************************************/
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
                        AliasGrid.DataRefer=rows[0].get('BODPRowId') ;
                        AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('BODPRowId')
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
				labelWidth : 90,
                frame:true,
        		reader: new Ext.data.JsonReader({root:'list'},
                         [{name: 'BODPRowId',mapping:'BODPRowId',type:'int'},
                         {name: 'BODPCode',mapping:'BODPCode',type:'string'},
                         {name: 'BODPDesc',mapping:'BODPDesc',type:'string'},
                         {name:'BODPCTLOCDR',mapping:'BODPCTLOCDR',type:'string'},
                         {name:'BODPInfusionFlag',mapping:'BODPInfusionFlag',type:'string'}
                  ]),
				defaults : {
					width : 200,
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'BODPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'BODPRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'BODPCode',
							id:'BODPCodeF',
  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('BODPCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BODPCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.MRCBodyParts";  
	                            var classMethod = "FormValidate";  	                            
	                            var id="";
	                            if(win.title=='修改'){  
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('BODPRowId');  
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,""); 
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
							name : 'BODPDesc',
							id:'BODPDescF',
  						 	readOnly : Ext.BDP.FunLib.Component.DisableFlag('BODPDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BODPDescF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){  
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.MRCBodyParts";  
	                            var classMethod = "FormValidate"; 
	                            var id="";
	                            if(win.title=='修改'){ 
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('BODPRowId');  
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						},{
							xtype : 'bdpcombo',
							fieldLabel : '科室',
							loadByIdParam:'rowid',
							hiddenName:'BODPCTLOCDR',
							dataIndex:'BODPCTLOCDR',
							id:'BODPCTLOCDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BODPCTLOCDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BODPCTLOCDRF')),
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							listWidth:250,
							pageSize:Ext.BDP.FunLib.PageSize.Combo,  
							forceSelection : true,
							selectOnFocus : false, 
							minChars : 0,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc'
						},{
							xtype:'checkbox',
							fieldLabel : '输液部位',
							id : 'BODPInfusionFlag',
							name : 'BODPInfusionFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BODPInfusionFlag'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BODPInfusionFlag')),
							inputValue : 'Y' 
						}]
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
		  height: 300,
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
				var tempCode = Ext.getCmp("BODPCodeF").getValue();
				var tempDesc = Ext.getCmp("BODPDescF").getValue();
				if (tempCode=="") {
    				Ext.Msg.show({ title : '提示', msg : '代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
         if(WinForm.getForm().isValid()==false){
         	Ext.Msg.show({ title : '提示', msg : '数据验证失败,请检查您的数据格式是否有误或者代码,描述重复!', minWidth : 300, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
									Ext.getCmp("form-save").getForm().findField("BODPCode").focus(true,800);
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
						win.show('');
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('BODPRowId'),
			                success : function(form,action) {
			                	  AliasGrid.DataRefer = _record.get('BODPRowId');
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
					name : 'BODPRowId',
					mapping : 'BODPRowId',
					type : 'int'
				}, {
					name : 'BODPCode',
					mapping : 'BODPCode',
					type : 'string'
				}, {
					name : 'BODPDesc',
					mapping : 'BODPDesc',
					type : 'string'
				},{
					name:'BODPCTLOCDR',
					mapping:'BODPCTLOCDR',
					type:'string'
				},{
					name:'BODPInfusionFlag',
					mapping:'BODPInfusionFlag',
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
							desc : Ext.getCmp("TextDesc").getValue()
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : limit
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
					grid.getStore().baseParams={};
					grid.getStore().load({
							params : {
								    	 start : 0,
							    		 limit : limit
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
							header : 'BODPRowId',
							sortable : true,
							dataIndex : 'BODPRowId',
							hidden : true
						}, {
							header : '代码',
							sortable : true,  
							dataIndex : 'BODPCode'
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'BODPDesc'
						},{
							header:'科室',
							sortable:true,
							dataIndex:'BODPCTLOCDR'
						},{
							header:'输液部位',
							sortable:true,
							dataIndex:'BODPInfusionFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}]; 
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				title : '身体部位',
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
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
	         var selectrow=_record.get('BODPRowId');
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
					win.show('');
		            Ext.getCmp("form-save").getForm().load({
		                   url : OPEN_ACTION_URL + '&id=' + _record.get('BODPRowId'),
		                   success : function(form,action) {
                            
                        },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
                     
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('BODPRowId');
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
