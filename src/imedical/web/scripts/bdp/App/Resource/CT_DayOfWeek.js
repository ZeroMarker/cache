/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于星期维护 
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTDayOfWeek&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTDayOfWeek&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTDayOfWeek";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDayOfWeek&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTDayOfWeek&pClassMethod=OpenData";

    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      	 TableN : "CT_DayOfWeek"
  	 }); 
    Ext.BDP.FunLib.TableName="CT_DayOfWeek";
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
    Ext.BDP.FunLib.SortTableName = "User.CTDayOfWeek";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
    //////////////////////////////日志查看 ///////////////////////////////////////////////////////////
   var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
   var btnhislog=Ext.BDP.FunLib.GetHisLogBtn(Ext.BDP.FunLib.SortTableName);
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
       RowID=rows[0].get('DOWRowId');
       Desc=rows[0].get('DOWName');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
 /*************************** 删除功能*************************************************/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
					 	Ext.Msg.show({
										title:'提示',
										minWidth:280,
										msg:'请选择需要删除的行!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 } 
				 else{
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
					if (btn == 'yes') {
                        
                        AliasGrid.DataRefer=records[0].get('DOWRowId') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel(); 
						var rows = gsm.getSelections(); 
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('DOWRowId') 
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=red>删除成功!</font>',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											animEl: 'form-save',
											fn : function(btn) {
													 Ext.BDP.FunLib.DelForTruePage(grid,limit);
                                                   }
                                               });
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:' + jsonData.info
										}
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>数据删除失败!</font>' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														animEl: 'form-save',
														buttons : Ext.Msg.OK
													});
											}
								} else {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>异步通讯失败,请检查网络连接!</font>',
													icon : Ext.Msg.ERROR,
													animEl: 'form-save',
													buttons : Ext.Msg.OK
												});
										}
								}
							}, this);
						}
				}, this);
			} 
		}
	});

    var jsonReaderE=new Ext.data.JsonReader({root:'list'},
                        [{name: 'DOWRowId',mapping:'DOWRowId',type:'int'},
                         {name: 'DOWDay',mapping:'DOWDay',type:'string'},
                         {name: 'DOWName',mapping:'DOWName',type:'string'},
                         {name: 'DOWSequence',mapping:'DOWSequence',type:'string'} ,
                         {name: 'DOWChecked',mapping:'DOWChecked',inputValue : true?'Y':'N',type:'string'},
                         {name:'DOWWeekend',mapping:'DOWWeekend',inputValue : true?'Y':'N',type:'string'}
                ]);
    var RowidText=new Ext.BDP.FunLib.Component.TextField({
          fieldLabel : 'DOWRowId',
          hideLabel : 'True',
          hidden : true,
          name:'DOWRowId'
    });
    
	///、 星期的天数
    var DOWDayText=new Ext.BDP.FunLib.Component.NumberField({
           fieldLabel : '<font color=red>*</font>星期的天数',
	       allowBlank:false,
	       regexText:"星期的天数不能为空",
	       name :'DOWDay',
	       minValue:1,
	       maxValue:7,
	       id:'DOWDayF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DOWDayF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DOWDayF')),
	       enableKeyEvents : true,
	       validationEvent : 'blur',  
           validator : function(thisText){
              if(thisText==""){   
                 return true;
               }
              var className =  "web.DHCBL.CT.CTDayOfWeek";   
              var classMethod = "FormValidateForCode";                           
              var id="";
              if(win.title=='修改'){  
                 var _record = grid.getSelectionModel().getSelected();
                 var id = _record.get('DOWRowId');  
               }
             var flag = "";
             var flag = tkMakeServerCall(className,classMethod,id,thisText); 
             if(flag == "1"){   
                return false;
              }else{
                return true;
              }
           },
         invalidText : '数据已经存在',
         listeners : {
             'change' : Ext.BDP.FunLib.Component.ReturnValidResult
          } 
          
     });
    /// 描述  
    var DOWNameText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : '<font color=red>*</font>描述',
       allowBlank:false,
       regexText:"描述不能为空",
       name : 'DOWName',
       id:'DOWNameF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DOWNameF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DOWNameF'))  ,
       enableKeyEvents : true,
       validationEvent : 'blur',
       validator : function(thisText){
       if(thisText==""){  
            return true;
        }
       var className =  "web.DHCBL.CT.CTDayOfWeek";  
       var classMethod = "FormValidate"; 
       var id="";
       if(win.title=='修改'){ 
        var _record = grid.getSelectionModel().getSelected();
        var id = _record.get('DOWRowId');  
       }
        var flag = "";
        var flag = tkMakeServerCall(className,classMethod,id,thisText); 
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
      });
    /// 第几天 
    var DOWSequenceText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : '第几天',
       name :'DOWSequence',
       id:'DOWSequenceF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DOWSequenceF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DOWSequenceF')) 
    });
    /// DOWChecked
    var DOWCheckedText=new Ext.BDP.FunLib.Component.Checkbox({
           fieldLabel:'默认在RB',
	       name:'DOWChecked',
	       id:'DOWCheckedF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DOWCheckedF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DOWCheckedF')),
	       autoHeight:'true',
	       hideLabels:true,
	       inputValue : true?'Y':'N'
    });
    /// 是否是周末 
    var DOWWeekendText=new Ext.BDP.FunLib.Component.Checkbox({
	       fieldLabel:'是否是周末',
	       name:'DOWWeekend',
	       id:'DOWWeekendF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('DOWWeekendF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('DOWWeekendF')),
	       hideLabels:true,
	       autoHeight:'true',
	       inputValue : true?'Y':'N'
    });
	/****************************增加修改的Form*********************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				split : true,
				frame : true,
                title:'基本信息',
				defaults : {
				anchor: '85%',
				border : false  
				},
				reader:jsonReaderE,
				items : [RowidText,DOWDayText,DOWNameText,DOWSequenceText,DOWCheckedText,DOWWeekendText]
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
	/************************** 增加修改时弹出窗口*********************************************/
	var win = new Ext.Window({
		width : 430,
		height : 320,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("DOWDayF").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("DOWNameF").getValue();
			 
			if (tempCode=="") {
				Ext.Msg.show({
								title : '<font color=blue>提示</font>', 
								msg : '星期的天数不能为空!', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("DOWDayF").focus(true,true);
								}
							 });
      			return;
			}
			else
			{
				if((tempCode<1)||(tempCode>7)){
						Ext.Msg.show({
								title : '<font color=blue>提示</font>', 
								msg : '星期的天数不能小于1或者大于7!', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("DOWDayF").focus(true,true);
								}
							 });
      				return;
				}
			}
			if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>',
								msg : '描述不能为空!', 
								minWidth : 200, 
								animEl: 'form-save',
								icon : Ext.Msg.ERROR, 
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("DOWNameF").focus(true,true);
								}
						   });
      			return;
			}
		   if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true,  
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
						 if (action.result.success == 'true') {
							   var myrowid = action.result.id;
                                win.hide();
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=green>添加成功!</font>',
												animEl: 'form-save',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
														var startIndex = grid.getBottomToolbar().cursor;
														grid.getStore().load({
																	params : {
																				start : 0,
																				limit : limit,
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
																		title : '<font color=blue>提示</font>',
																		msg : '<font color=red>添加失败!</font>' ,
																		minWidth : 200,
																		animEl: 'form-save',
																		icon : Ext.Msg.ERROR,
																		buttons : Ext.Msg.OK
																	});
								             	}
						  	},
						  failure : function(form, action) {
							Ext.Msg.show({
											title : '<font color=blue>提示</font>',
											msg : '<font color=red>添加失败!</font>' ,
											minWidth : 200,
											animEl: 'form-save',
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
								}
					 	})
				   } else {
					Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								url : SAVE_ACTION_URL_New,
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
					                                    var startIndex = grid.getBottomToolbar().cursor;
				                                        Ext.BDP.FunLib.ReturnDataForUpdate('grid',ACTION_URL,myrowid);
				                                     }
				                              }); 
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:' + action.result.errorinfo
										}
										Ext.Msg.show({
														title : '<font color=blue>提示</font>',
														msg : '<font color=red>修改失败!</font>' ,
														minWidth : 200,
														animEl: 'form-save',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
												}
										},
								failure : function(form, action) {
									Ext.Msg.show({
													title : '<font color=blue>提示</font>',
													msg : '<font color=red>修改失败!</font>' ,
													minWidth : 200,
													animEl: 'form-save',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
											}
									})
								}
							}, this);
					}
				}
		},{
			text : '关闭',
            iconCls : 'icon-close',
			handler : function() {
			  win.hide();   
              ClearForm();
			}
		}],
		listeners : {
			"show" : function() {
			Ext.getCmp("form-save").getForm().findField("DOWChecked").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	/********************************增加按钮**********************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
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
	/********************************修改按钮**********************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					var records =  grid.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
										title:'提示',
										minWidth:280,
										msg:'请选择需要修改的行!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 } 
				 else{
				   		win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						loadFormData(grid);
					 }
      		 }
    });
	 
    var fields=[{
					name : 'DOWRowId',
					mapping : 'DOWRowId',
					type : 'int'
				}, {
					name : 'DOWDay',
					mapping :'DOWDay',
					type:'string'
				}, {
					name : 'DOWName',  
					mapping : 'DOWName',
					type : 'string'
				}, {
					name :'DOWSequence',
					mapping :'DOWSequence',
					type:'string'
				} , {
					name : 'DOWChecked',  
					mapping : 'DOWChecked',
					type : 'string'
				},{
					name:'DOWWeekend',
					mapping:'DOWWeekend',
					type:'string' 
				} 
		];
	/***************************数据保存格式为json格式**********************************/
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields) 
		});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
/************************************加载数据***************************************/
	 ds.load({
		params : {
					start : 0,
					limit : limit
				} 
		}); 
	/************************************数据分页************************************/
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
	/***************************增删改工具条*********************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]  
	});
	/*************************** 搜索工具条**********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={			
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
	/******************************* 刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
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
	/**********************************将工具条放到一起*****************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						  },'-',LookUpConfigureBtn ,'-', btnSearch, '-', btnRefresh,'->'],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
/************************************create the Grid *************************************/
	var x="";
	var sm=	new Ext.grid.RowSelectionModel({singleSelect:true})
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'DOWRowId',
							width : 120,
							sortable : true,
							dataIndex : 'DOWRowId',
							hidden : true
						}, {
							header : '星期的天数',
							width : 80,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'DOWDay',
							renderer:function(day){
							 if(day==1){
								day="Monday";
								 return day;	
							  }
							 if(day==2){
								day="Tuesday";
								 return day;	
							 }
							 if(day==3){
								 day="Wednesday";
								  return day;	
							} 
							 if(day==4){
								 day="Thursday";
								  return day;	
							}
							if(day==5){
								  day="Friday";
								   return day;	
							 }
							 if(day==6){
								 day="Saturday";
								 return day;	
							}   
							 if(day==7){
								day="Sunday";
								return day;	
							  }
							}
						}, {
							header : '描述',
							width : 80,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'DOWName'
						},{
							header:'第几天',
							width:80,
							sortable:true,
							dataIndex:'DOWSequence'
						}, {
							header : '默认在RB',
							width : 120,
							sortable : true,
							dataIndex :'DOWChecked',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						}, {
							header : '是否是周末',
							width : 120,
							sortable : true,
							dataIndex : 'DOWWeekend',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				stripeRows:true,
				autoFill:true,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM,
				sm:sm, 
				stripeRows : true,
				columnLines : true,  
				title : '星期维护',
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true  
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
  Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
  btnTrans.on("click",function(){
	if (grid.selModel.hasSelection())
	{
	  var _record=grid.getSelectionModel().getSelected();
          var selectrow=_record.get('DOWRowId');
	 }
	else
	{
	  var selectrow=""
	 }
	Ext.BDP.FunLib.SelectRowId=selectrow
  });
/************************************双击事件*****************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('DOWRowId'),  
	                success : function(form,action) {
                     
	        	      },
	                 failure : function(form,action) {
	                 	Ext.Msg.alet("提示","加载数据失败！")
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('DOWRowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show();
				loadFormData(grid)
	    });	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	/************************************键盘事件*********************************************/
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
  });
