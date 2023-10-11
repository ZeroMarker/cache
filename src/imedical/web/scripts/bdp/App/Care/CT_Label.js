/**
 * @Title: 基础数据平台-基础数据
 * @Author:  sunfnegchao
 * @Description: 用于 标签维护  
 */
/// 调用 别名维护 的后台类方法
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTLabel";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassMethod=DeleteData";
	var OPEN_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassMethod=OpenData";
	var TABLE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLabel&pClassQuery=GetTypeList";
	
     //初始化“别名”维护面板
   	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_Label"
   });
     Ext.BDP.FunLib.TableName="CT_Label";
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
	 
  /*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTLabel";
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
       RowID=rows[0].get('ID');
       Desc=rows[0].get('LabelName');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
/*********************************删除功能**********************************/
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
					 return false;
				 } 
				 else{
					Ext.MessageBox.confirm('<font color=blue>提示</font>','<font color=red>确定要删除所选的数据吗?</font>', function(btn) {
					if (btn == 'yes') {
                        AliasGrid.DataRefer=records[0].get('ID');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('ID') 
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
												 var startIndex = grid.getBottomToolbar().cursor;
                                                 var totalnum=grid.getStore().getTotalCount();
                                                  if(totalnum==1){   //修改添加后只有一条，返回第一页
								                  var startIndex=0
								               }
								               else if((totalnum-1)%limit==0)//最后一页只有一条
								               {
								                var pagenum=grid.getStore().getCount();
								                if (pagenum==1){ startIndex=startIndex-limit;}  //最后一页的时候,不是最后一页则还停留在这一页
								               }
                                                 grid.getStore().load({
                                                 params : {
                                                            start : startIndex,
                                                            limit : limit
                                                           }
                                                       });
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
     [{    
         name : 'ID',
         mapping :'ID',
         type : 'int'
        }, {
         name : 'LabelCode',
         mapping : 'LabelCode',
         type : 'string'
        }, {
         name : 'LabelName',
         mapping :'LabelName',
         type:'string'
        } ,{
         name:'LabelActiveFlag',
         mapping:'LabelActiveFlag',
         inputValue : true?'Y':'N',
         type:'string'
        },{
         name:'LabelRemark',
         mapping:'LabelRemark', 
         type:'string'
        } ,{
         name:'LabelTableName',
         mapping:'LabelTableName', 
         type:'string'
        } ,{
         name:'LabelCategory',
         mapping:'LabelCategory', 
         type:'string'
        }   
     ]);
     
   /// Rowid
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : 'ID',
        hideLabel : 'True',
        hidden : true,
        name : 'ID'
    });
   /// Code
   var CodeText=new Ext.BDP.FunLib.Component.TextField({
        fieldLabel : '<font color=red>*</font>代码',
        allowBlank:false,
        regexText:"代码不能为空",
        name : 'LabelCode',
        id:'LabelCodeF',
        readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelCodeF'),
        style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelCodeF')) 
   });
  /// Desc
  var DescText=new Ext.BDP.FunLib.Component.TextField({
      fieldLabel : '<font color=red>*</font>名称',
       allowBlank:false,
       regexText:"名称不能为空",
       name : 'LabelName',
       id:'LabelNameF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelNameF') ,
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelNameF')) 
  });
   /// 备注
    var LabelRemarkCheck=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel:'备注',
	       name:'LabelRemark',
	       id:'LabelRemarkF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelRemarkF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelRemarkF')) 
    });
   /// LabelTableName
     var LabelTableName=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel:'<font color=red>*</font>表名',
		   allowBlank:false,
	       name:'LabelTableName',
	       id:'LabelTableNameF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelTableNameF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelTableNameF')) 
    });
	
    /// 激活	
    var LabelActiveFlagCheck=new Ext.BDP.FunLib.Component.Checkbox({
           fieldLabel:'激活',
	       name:'LabelActiveFlag',
	       id:'LabelActiveFlagF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelActiveFlagF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelActiveFlagF')), 
	       inputValue :  'Y' 
    });
   /// 分类
    var LabelCategory=new Ext.BDP.FunLib.Component.TextField({
           fieldLabel:'分类',
	       name:'LabelCategory',
	       id:'LabelCategoryF',
	       readOnly : Ext.BDP.FunLib.Component.DisableFlag('LabelCategoryF'),
	       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('LabelCategoryF')) 
    });
/************************************增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
                title:'基本信息',
				labelAlign : 'right',
                labelWidth:130,
				width : 380,
				split : true,
				frame : true,
				defaults : {
					anchor: '85%',
					bosrder : false   
				},
				reader:jsonReaderE,
				defaultType : 'textfield',
				items : [RowIdText,LabelTableName, CodeText, DescText,LabelCategory,LabelRemarkCheck,LabelActiveFlagCheck]
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
	
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		width : 430,
		height : 360,
		layout : 'fit',
		modal : true,
		frame : true,
		autoScroll : false,
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
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("LabelCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("LabelName").getValue(); 
			var temptable=Ext.getCmp("form-save").getForm().findField("LabelTableName").getValue(); 
			if (tempCode=="") {
					Ext.Msg.show({ 
							title : '<font color=blue>提示</font>',
							msg : '代码不能为空!', 
							minWidth : 200,
							animEl: 'form-save',
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK ,
							fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("LabelCode").focus(true,true);
								}
						});
      			return;
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
									Ext.getCmp("form-save").getForm().findField("LabelName").focus(true,true);
								}
							});
      			return;
			}
			if (temptable=="") {
					Ext.Msg.show({ 
							title : '<font color=blue>提示</font>',
							msg : '表名不能为空!', 
							minWidth : 200,
							animEl: 'form-save',
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK ,
							fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("LabelTableName").focus(true,true);
								}
						});
      			return;
			}
			if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						url : SAVE_ACTION_URL_New,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								var myrowid = action.result.id;
								AliasGrid.DataRefer = myrowid;
                        		AliasGrid.saveAlias();  
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
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>添加失败!</font>'+errorMsg,
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
									if (action.result.success == 'true') {
										 var myrowid = 'rowid='+action.result.id;
										 AliasGrid.saveAlias(); 
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
														msg : '<font color=red>修改失败!</font>'+errorMsg,
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
				Ext.getCmp("form-save").getForm().findField("LabelCode").focus(true,250);
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
/************************************修改按钮**********************************/
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
/************************************数据存储***********************************/
    var fields=[{     
		            name : 'ID',
					mapping :'ID',
					type : 'int'
				}, {
					name : 'LabelCode', 
					mapping : 'LabelCode',
					type : 'string'
				}, {
					name : 'LabelName',
					mapping :'LabelName',
					type:'string'
				} ,{
                    name:'LabelActiveFlag',
					inputValue : true?'Y':'N',
					mapping:'LabelActiveFlag'
				},{
					name:'LabelRemark', 
					mapping:'LabelRemark',
					type:'string'
				},{
					name:'LabelTableName', 
					mapping:'LabelTableName',
					type:'string'
				},{
					name:'LabelCategory', 
					mapping:'LabelCategory',
					type:'string'
				}]  
						
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
	 
	/************************************数据加载************************************/
	 ds.load({
				params : {
					start : 0,
					limit : limit
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
/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
	});
 
/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue() , 
						desc : Ext.getCmp("TextDesc").getValue(),
						table : Ext.getCmp("textType").getValue() 
				};
				
				grid.getStore().load({
						params : {
									start : 0,
									limit : limit
								}
							});
						 }
					});
/************************************刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function refresh() {
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset(); 
					Ext.getCmp("textType").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
											start : 0,
											limit : limit
										}
							});
					}
			});
	
/************************************将工具条放到一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				},'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
			}, '-', '表名', {
							xtype : 'combo',
							id : 'textType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textType'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							mode : 'remote', 
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'TableName',
							displayField : 'TableName',
							store : new Ext.data.JsonStore({
								url : TABLE_QUERY_ACTION_URL,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'TableName',
								fields : ['TableName', 'TableName'],
								remoteSort : true,
								sortInfo : {
									field : 'TableName',
									direction : 'ASC'
								}
							})
						} ,'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	 /************************************创建表格************************************/
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header :'ID',
							width : 60,
							sortable : true,
						    hidden:true,
							dataIndex : 'ID'
					  },{
							header:'表名',
							width:80,
							sortable:true,
							dataIndex:'LabelTableName' 
						}, {
							header : '代码',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'LabelCode'
						}, {
							header : '名称',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'LabelName'
						} ,{
							header : '分类',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'LabelCategory'
						},{
							header:'激活',
							width:80,
							sortable:true,
							dataIndex:'LabelActiveFlag',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						},{
							header:'备注',
							width:80,
							sortable:true,
							dataIndex:'LabelRemark' 
						} ];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				singleSelect: true ,
				monitorResize : true,
				trackMouseOver : true,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM ,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true, //在列分隔处显示分隔符
				title : '标签',
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
				forceFit : true,
				emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    			enableRowBody: true // 
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
		  
/************************************双击事件************************************/
	  	var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('ID'),  //id 对应OPEN里的入参
	                success : function(form,action) {
	                	Ext.getCmp("form-save").getForm().findField('LabelActiveFlag').setValue((_record.get('LabelActiveFlag'))=='Y'?true:false); 
	        	      },
	                failure : function(form,action) {
	                }
	            });
                //激活基本信息面板
                tabs.setActiveTab(0);
                //加载别名面板
                AliasGrid.DataRefer = _record.get('ID');
                AliasGrid.loadGrid(); 
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
				win.setTitle('修改');      ///双击后
				win.setIconClass('icon-update');
				win.show('');
	        	loadFormData(grid);
	    });	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	
	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ID');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	/************************************键盘事件，按键弹出添加窗口***********************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});
