﻿  /**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 健康监护区域
 * @Created on 2015-3-4
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
/// 调用 别名维护 的后台类方法
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    var comboPage=Ext.BDP.FunLib.PageSize.Combo;
    var HCAHCRDR_ACTIONURL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareRegion&pClassQuery=GetDataForCmb1";
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHealthCareArea";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHealthCareArea&pClassMethod=OpenData";	

    //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "CT_HealthCareArea"
  });
  /********排序*******/
   Ext.BDP.FunLib.SortTableName = "User.CTHealthCareArea";
   var btnSort = Ext.BDP.FunLib.SortBtn;
    
   Ext.BDP.FunLib.TableName="CT_HealthCareArea";
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
       RowID=rows[0].get('HCARowId');
       Desc=rows[0].get('HCADesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
 /************************************删除功能************************************/
	var btnDel = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			handler :DelData= function () {
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
                        AliasGrid.DataRefer=records[0].get('HCARowId');
                        AliasGrid.delallAlias();
						var gsm = grid.getSelectionModel(); 
						var rows = gsm.getSelections(); 
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('HCARowId') 
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

   	 
/************************************增加修改的Form************************************/
    var JsonReaderE=new Ext.data.JsonReader({root:'list'},
   [{ 
	     name : 'HCARowId',
	     mapping : 'HCARowId' 
     }, {
	     name : 'HCACode',
	     mapping :'HCACode' 
        }, {
	     name : 'HCADesc',
	     mapping :'HCADesc' 
      },{
      	name:'HCAHCRDR',
      	mapping:'HCAHCRDR'
      },{
	     name:'HCADateFrom',
	     mapping:'HCADateFrom' 
    }, {
	     name :'HCADateTo',
	     mapping :'HCADateTo' 
    } ,{
       	 name:'HCAHCRDR',
       	 mapping:'HCAHCRDR'
       }// 列的映射
   ]);
    //RowId
    var RowIdText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : 'HCARowId',
         hideLabel : 'True',
         hidden : true,
         name : 'HCARowId'
    });
   //  Code 
    var CodeText=new Ext.BDP.FunLib.Component.TextField({
         fieldLabel : '<font color=red>*</font>代码',
	     allowBlank:false,
	     regexText:"代码不能为空",
	     name :'HCACode',
	     id:'HCACodeF',
	     readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCACodeF'),
	     style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCACodeF')),
	     enableKeyEvents : true,
	     validationEvent : 'blur',  
         validator : function(thisText){
        if(thisText==""){  //当文本框里的内容为空的时候不用此验证
             return true;
         }
        var className =  "web.DHCBL.CT.CTHealthCareArea";   
        var classMethod = "FormValidate"; //数据重复验证后台函数名                             
        var id="";
        if(win.title=='修改'){  
          var _record = grid.getSelectionModel().getSelected();
          var id = _record.get('HCARowId');  
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
   // Desc
   var DescText=new Ext.BDP.FunLib.Component.TextField({
       fieldLabel : '<font color=red>*</font>描述',
       allowBlank:false,
       regexText:"描述不能为空",
       name : 'HCADesc',
       id:'HCADescF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCADescF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCADescF')),
       minLength :1 ,                 
       minLengthText : "描述最少1个字符",                  
       maxLength : 20 ,                 
       maxLengthText :"描述至多20个字符",                
       enableKeyEvents : true,
       validationEvent : 'blur',
       validator : function(thisText){
        if(thisText==""){  
           return true;
         }
       var className =  "web.DHCBL.CT.CTHealthCareArea"; //后台类名称
       var classMethod = "FormValidate"; //数据重复验证后台函数名
       var id="";
       if(win.title=='修改'){ 
       var _record = grid.getSelectionModel().getSelected();
       var id = _record.get('HCARowId');  
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
   /// DateFrom
   var DateFromText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '<font color=red>*</font>开始日期',
       name :'HCADateFrom',
       id:'HCADateFromF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCADateFromF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCADateFromF')),
       format : BDPDateFormat,
       allowBlank:false,
       regexText:"开始日期不能为空",
       editable:true,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        
        }}
   });
  /// DateTo 
   var DateToText=new Ext.BDP.FunLib.Component.DateField({
       fieldLabel : '结束日期',
       name : 'HCADateTo',
       id:'HCADateToF',
       readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCADateToF'),
       style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCADateToF')),
       format : BDPDateFormat,
       enableKeyEvents : true,
       listeners : {   
        'keyup' : function(field, e)
        { 
         Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
        }}
   });
  
	var WinForm = new Ext.form.FormPanel({
		   id : 'form-save',
           title:'基本信息',
		   labelAlign : 'right',
		   width : 350,
           labelWidth:120,
		   split : true,
		   frame : true,
		   defaults : {
				anchor: '85%',
				border : false  
			},
		   reader:JsonReaderE,
		   items : [RowIdText,CodeText,DescText,{
							xtype : "bdpcombo",
							fieldLabel : '健康监护地区',
                            loadByIdParam:'rowid',
                            hiddenName : 'HCAHCRDR',
                            id:'HCAHCRDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HCAHCRDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HCAHCRDRF')),
							store : new Ext.data.Store({
										autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
										proxy : new Ext.data.HttpProxy({ url : HCAHCRDR_ACTIONURL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'HCRRowId',mapping:'HCRRowId'},
										{name:'HCRDesc',mapping:'HCRDesc'} ])
								}),
							mode : 'local',
                            pageSize: comboPage ,
                            listWidth : 250,
                            queryParam : 'desc',
							forceSelection : true,
							displayField : 'HCRDesc',
							valueField : 'HCRRowId'
						}, DateFromText,DateToText]
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
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		width : 400,
		height : 320,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("HCACode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("HCADesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("HCADateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("HCADateTo").getValue();
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
									Ext.getCmp("form-save").getForm().findField("HCACode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("HCADesc").focus(true,true);
								}
							 });
      					return;
					}
			if (startDate=="") {
				Ext.Msg.show({ 
								title : '<font color=blue>提示</font>', 
								msg : '开始日期不能为空!', 
								minWidth : 200,
								animEl: 'form-save',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK ,
								fn:function()
								{
									Ext.getCmp("form-save").getForm().findField("HCADateFrom").focus(true,true);
								}
							 });
      				return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
			    					title : '<font color=blue>提示</font>',
									msg : '<font color=red>开始日期不能大于结束日期!</font>',
									minWidth : 200,
									animEl: 'form-save',
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
      			 			return;
  					}
			 	}
           if(WinForm.getForm().isValid()==false){
	           Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
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
				Ext.getCmp("form-save").getForm().findField("HCACode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
/************************************增加按钮***********************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				tooltip : '添加',
				iconCls : 'icon-add',
				handler : AddData=function () {
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
/************************************修改按钮***********************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
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
	
	/************************************数据存储***********************************/
   	var fields= [{
					name : 'HCARowId',
					mapping : 'HCARowId',
					type : 'int'
				}, {
					name : 'HCACode',    
					mapping : 'HCACode',
					type : 'string'
				}, {
					name : 'HCADesc',
					mapping : 'HCADesc',
					type : 'string'
				}, {
					name : 'HCADateFrom',
					mapping : 'HCADateFrom',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				}, {
					name : 'HCADateTo',
					mapping : 'HCADateTo',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				},{
					name:'HCAHCRDR',
					mapping:'HCAHCRDR',
					type:'string'
				} ]
						
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
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
	/*********************************数据分页************************************/
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
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog] 
	});
/************************************搜索工具条************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
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
			
		function Refresh() {
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
/************************************刷新工作条************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : Refresh
			});
/************************************将工具条放到一起***********************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							//enableKeyEvents:true,
							listeners : {
					   		keyup:function(){
					 		grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue()
				};
				grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
						});
					}
				}
			}, '描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							//enableKeyEvents:true,
							listeners : {
					   		keyup:function(){
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
				}
		},'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->' ],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
/************************************create the Grid ************************************/
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), {
							header : 'HCARowId',
							width : 120,
							sortable : true,
							dataIndex :'HCARowId',
							hidden : true
						}, {
							header : '代码',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'HCACode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'HCADesc'
						},{
							header:'健康监护地区',
							width:120,
							sortable:true,
							dataIndex:'HCAHCRDR'
						}, {
							header : '开始日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat), 
							dataIndex :'HCADateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'HCADateTo'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columnLines : true,  
	            tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				stripeRows : true,
				columnLines : true,  
				enableKeyNav:true, 
				title : '健康监护区域',
				stateful : true,
				viewConfig : {
					forceFit: true,
    				emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				enableRowBody: true  
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
   Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
/************************************双击事件************************************/
	  var loadFormData = function(grid){
	        var _record = grid.getSelectionModel().getSelected(); 
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('HCARowId'),   
	                success : function(form,action) {
	        	    },
	                failure : function(form,action) {
	                }
	            });
               //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('HCARowId');
               AliasGrid.loadGrid();
	        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');     
				win.setIconClass('icon-update');
				win.show();
				loadFormData(grid);
	    });	
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  	var _record=grid.getSelectionModel().getSelected();
	        var selectrow=_record.get('HCARowId');
		 }
		else
		{
		  	var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
  Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
  
  
  Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
  
  
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
   });

 