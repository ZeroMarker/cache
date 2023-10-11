﻿/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于婴儿数量维护。
 * @Created on 2012-8-6
 * @Updated on 2013-5-11
 * @LastUpdated on 2013-6-21 by sunfengchao
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
    var limit = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    
   /// 调用 婴儿数量维护 的后台类方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBabyPlurality&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACBabyPlurality&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACBabyPlurality";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBabyPlurality&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBabyPlurality&pClassMethod=OpenData";  //修改时取数据
	
 
	/*************************************排序*********************************/
    Ext.BDP.FunLib.SortTableName = "User.PACBabyPlurality";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
   //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "PAC_BabyPlurality"
  });
  	 Ext.BDP.FunLib.TableName="PAC_BabyPlurality"
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
       RowID=rows[0].get('PLURRowId');
       Desc=rows[0].get('PLURDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
     /// 获取查询配置按钮 
    var LookUpConfigureBtn = Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName);  /// 表名 
    
	/************************************实现删除功能************************************/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn1',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn1'),
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
                        //删除所有别名
                        AliasGrid.DataRefer=records[0].get('PLURRowId') ;
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('PLURRowId') 
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
    /// winform 的json 解析
    var JsonReaderE=new Ext.data.JsonReader({root:'list'},
      [{
         name : 'PLURRowId',
         mapping :'PLURRowId' 
        }, {
         name : 'PLURCode',
         mapping : 'PLURCode'
        }, {
         name : 'PLURDesc',
         mapping :'PLURDesc'
        },{
         name:'PLURBabyCount',
         mapping:'PLURBabyCount'
       }])
       
   // Rowid
  var RowidText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : 'PLURRowId',
       hideLabel : 'True',
       hidden : true,
       name : 'PLURRowId'
  });
  
 /// code 代码   
  var codeText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : '<font color=red>*</font>代码',
       anchor: '85%',
       name : 'PLURCode',
       id:'PLURCodeF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLURCodeF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLURCodeF')),
       stripCharsRe :  ' ',
       allowBlank : false,
       enableKeyEvents : true,
       validationEvent : 'blur',  
                            validator : function(thisText){
                           if(thisText==""){  //当文本框里的内容为空的时候不用此验证
                           return true;
                           }
                             var className =  "web.DHCBL.CT.PACBabyPlurality";   
                             var classMethod = "FormValidate"; //数据重复验证后台函数名                             
                             var id="";
                             if(win.title=='修改'){  
                              var _record = grid.getSelectionModel().getSelected();
                              var id = _record.get('PLURRowId');  
                             }
                             var flag = "";
                             var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
                             if(flag == "1"){   
                               return false;
                              }else{
                               return true;
                              }
                           },
                            invalidText : '该代码已经存在',
         listeners : {
                       'change' : Ext.BDP.FunLib.Component.ReturnValidResult
          }
  });
  
  /// desc 描述
    var descText=new Ext.BDP.FunLib.Component.TextField({
		        fieldLabel : '<font color=red>*</font>描述',
		        allowBlank:false,
                anchor: '85%',
		        regexText:"对不起,描述不能为空",
		        name : 'PLURDesc',
		        id:'PLURDescF',
		        readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLURDescF'),
		        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLURDescF')),
		        enableKeyEvents : true,
		        validationEvent : 'blur',
		        enableKeyEvents : true,
                validator : function(thisText){
                             if(thisText==""){  
                              return true;
                           }
                             var className =  "web.DHCBL.CT.PACBabyPlurality"; //后台类名称
                             var classMethod = "FormValidate"; //数据重复验证后台函数名
                             var id="";
                             if(win.title=='修改'){ 
                              var _record = grid.getSelectionModel().getSelected();
                              var id = _record.get('PLURRowId');  
                             }
                             var flag = "";
                             var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
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
  
      /// babycount 婴儿数
       var babycountText=new Ext.BDP.FunLib.Component.TextField({
                    fieldLabel : '<font color=red>*</font>婴儿数',
				    name :'PLURBabyCount',
				    id:'PLURBabyCountF',
				    xtype:'numberfield',
                    anchor: '85%',
                    minValue:0,
                    maxValue:8,
                    regex : /^(([0-9]+)+)$/,
			        readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLURBabyCountF'),
			        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLURBabyCountF')),
			        allowBlank:false,
			        regexText:"对不起,婴儿数应该为0或者正整数。"
          });
/************************************增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				split : true,
				frame : true,
                title:'基本信息',
				waitMsgTarget : true,
				reader:JsonReaderE,
				defaults : {
					border : false  
				},
				items : [RowidText,codeText,descText,babycountText]
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
/************************************增加修改时弹出窗口************************************/
	var win = new Ext.Window({
		width : 440 ,
        height : 260,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : false,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 65,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("PLURCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("PLURDesc").getValue();
			var tempPLURBabyCount = Ext.getCmp("form-save").getForm().findField("PLURBabyCount").getValue();
          
			if (tempCode=="") {
				Ext.Msg.show({ 
								title : '提示',
								msg : '代码不能为空!', 
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								animEl: 'form-save',
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("PLURCode").focus(true,true);
								},
								buttons : Ext.Msg.OK
							 });
      			return;
			}
		if (tempDesc=="") {
				Ext.Msg.show({ 
								title : '提示', 
								msg : '描述不能为空!', 
								minWidth : 200,
								icon : Ext.Msg.ERROR,
								animEl: 'form-save',
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("PLURDesc").focus(true,true);
								},
								buttons : Ext.Msg.OK 
			 				 });
      			return;
			}
			if (tempPLURBabyCount==""&&tempPLURBabyCount!=0) {
				Ext.Msg.show({ 
								title : '提示', 
								msg : '婴儿数量不能为空!',
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("PLURBabyCount").focus(true,true);
								},
								buttons : Ext.Msg.OK 
							 });
      			return;
			}
		    if (tempPLURBabyCount<0) {
		    Ext.Msg.show({ 
		        title : '提示', 
		        msg : '婴儿数量不能为负数!',
		        minWidth : 200,
		        animEl: 'form-save',
		        icon : Ext.Msg.ERROR,
		        fn:function()
		        {
		         Ext.getCmp("form-save").getForm().findField("PLURBabyCount").focus(true,true);
		        },
		        buttons : Ext.Msg.OK 
		        });
		         return;
		   }
		      if (tempPLURBabyCount>8) {
		      Ext.Msg.show({ 
		          title : '提示', 
		          msg : '婴儿数量超出范围!',
		          minWidth : 200,
		          animEl: 'form-save',
		          icon : Ext.Msg.ERROR,
		          fn:function()
		          {
		           Ext.getCmp("form-save").getForm().findField("PLURBabyCount").focus(true,true);
		          },
		          buttons : Ext.Msg.OK 
		          });
		           return;
		     }
              if(WinForm.getForm().isValid()==false){
			      Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
			      return;
			    } 
			if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
						        win.hide();
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=green>添加成功!</font>',
												icon : Ext.Msg.INFO,
												animEl: 'form-save',
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													var startIndex = grid.getBottomToolbar().cursor;
													grid.getStore().load({
															params :{
																		start : 0,
																		limit : limit,
																		rowid : myrowid
																	}
															});
														}
												});
                                            //保存别名
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
							Ext.Msg.alert('<font color=blue>提示</font>', '<font color=red>添加失败!</font>');
						}
					})
				} else {
					Ext.MessageBox.confirm('<font color=blue>提示</font>', '<font color=red>确定要修改该条数据吗?</font>', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '<font color=blue>提示</font>',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
                                    AliasGrid.saveAlias();
									if (action.result.success == 'true') {
							             win.hide();
							             var myrowid = 'rowid='+ action.result.id;
					                    Ext.Msg.show({
							                          title : '<font color=blue>提示</font>',
							                          msg : '<font color=green> 修改成功!</font>',
							                          animEl: 'form-save',
							                          icon : Ext.Msg.INFO,
							                          buttons : Ext.Msg.OK,
					                                  fn : function(btn) {
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
														msg : '<font color=red >修改失败!</font>' ,
														minWidth : 200,
														animEl: 'form-save',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
											}
								},
								failure : function(form, action) {
									Ext.Msg.alert('<font color=blue>提示</font>', '<font color=red>修改失败!</font>');
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
				Ext.getCmp("form-save").getForm().findField("PLURCode").focus(true,250);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
/************************************增加按钮************************************/
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
/************************************修改按钮************************************/
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
							win.show('');
							loadFormData(grid);
						 }
	      		 }
	    });
    
/**********************************数据存储************************************/
	var fields= [{     
		            name : 'PLURRowId',
					mapping :'PLURRowId',
					type : 'int'
				}, {
					name : 'PLURCode',  
					mapping : 'PLURCode',
					type : 'string'
				}, {
					name : 'PLURDesc',
					mapping :'PLURDesc',
					type:'string'
				},{
					name:'PLURBabyCount',
					mapping:'PLURBabyCount'
				}]
						
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}), 
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						  },fields) 
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		
	/***********************************数据加载************************************/
	ds.load({
				params : {
					start : 0,
					limit : limit
				},
				callback : function(records, options, success) {
				} 
			}); // 加载数据
 
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
				
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	/**********************************增删改工具条***********************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]    
		})
	/************************************搜索工具条***********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnsearch'),
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						count: Ext.getCmp("TextCount").getValue()
				};
				grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							 }
						});
				  }
			});
	/************************************刷新工作条***********************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextCount").reset();
					grid.getStore().baseParams={};
						grid.getStore().load({
							params : {
									start : 0,
									limit : limit
								 }
						 });
						 
				   }
		      });
	/********************************* 将工具条放到一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
	                 },'描述/别名', {
							fieldLabel : '<font color=red></font>描述',
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				    },'婴儿数',{
							fieldLabel : '<font color=red></font>婴儿数',
							xtype : 'textfield',
							id : 'TextCount',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCount'),
							width : 140
	                 },'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					          render : function() {
						          tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
							}
						}
					});
	/************************************创建数据表格************************************/
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'PLURRowId',
							width : 160,
							sortable : true,
						    hidden:true,
							dataIndex : 'PLURRowId'
					  }, {
							header : '代码',
							width : 160,
							sortable : true,
							id:'PLURCode',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'PLURCode'
						}, {
							header : '描述',
							width : 160,
							sortable : true,
							dataIndex : 'PLURDesc'
						},{
							header : '婴儿数',
							width : 160,
							sortable : true,
							dataIndex : 'PLURBabyCount'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				trackMouseOver : true,
				columns:GridCM,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true, 
				title : '婴儿数量',
				stateful : true,
				viewConfig : {
					forceFit : true,
					emptyText:"<span style='color:red;<font size=25>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true  
				},
				bbar :paging,
				tbar : tb,
				stateId : 'grid'
			});
		Ext.BDP.AddColumnFun(grid,"PAC_BabyPlurality",GridCM);
	/*****************************右键菜单**************************************************/
            grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
			var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [
        	{
	            id: 'rMenu1',
	            iconCls :'icon-delete',
	            handler: DelData,//点击后触发的事件
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu1'),
	            text: '删除数据'
	        }, {
	            id: 'rMenu2',
	            iconCls :'icon-add',
	            handler: AddData,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu2'),
	            text: '添加数据'
	        },{
	            id: 'rMenu3',
	            iconCls :'icon-update',
	            handler:UpdateData ,
	            disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu3'),
	            text: '修改数据'
	        },{
	        	id:'rMenu4',
	        	iconCls :'icon-refresh',
	        	disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu4'),
	        	handler:function(){
	            Ext.getCmp("grid").store.reload();
	            },
	        	text:'刷新'
	        }  
	    ]
	}); 
 /****************************************右键菜单的关键代码，右键可以选中一行***************************************************/
 	function rightClickFn(grid,rowindex,e){
    	 e.preventDefault();
    	 var currRecord = false; 
   		 var currRowindex = false; 
   		 var currGrid = false; 
         if (rowindex < 0) { 
         return; 
   } 
     grid.getSelectionModel().selectRow(rowindex); 
     currRowIndex = rowindex; 
     currRecord = grid.getStore().getAt(rowindex); 
     currGrid = grid; 
     rightClick.showAt(e.getXY()); 
  }
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  var _record=grid.getSelectionModel().getSelected();
	      var selectrow=_record.get('PLURRowId');
		 }
		else
		{
		  var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
/************************************双击事件************************************/
	 var loadFormData = function(grid){
	    var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
        if (!_record)
      {
         Ext.Msg.alert('修改操作', '<font color=red>请选择要修改的一项!</font>');
      }
        else
     {
         WinForm.form.load( {
           url :OPEN_ACTION_URL+ '&id='+ _record.get('PLURRowId'),  //id 对应OPEN里的入参
           success : function(form,action) {
                
              },
                 failure : function(form,action) {
                        Ext.Msg.alert("提示","数据加载失败！")
                 }
             });
              //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('PLURRowId');
               AliasGrid.loadGrid();
         }
     };            
	    
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
	        	loadFormData(grid);
	    });	 
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);   
	/************************************键盘事件************************************/
   	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
});
