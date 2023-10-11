/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于电子病历--过敏原的维护
 * @Created on 2013-09-03
 * @Updated on  
 * @LastUpdated on 2013-09-03 by sunfengchao
 */	
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"></script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	var limit = Ext.BDP.FunLib.PageSize.Main;
    var comboPage=Ext.BDP.FunLib.PageSize.Combo;
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ORDER_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetList";
	
	  
	
    /// 调用过敏原维护的后台类方法
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACAllergy";///获取 过敏原分类 
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassMethod=DeleteData";
	var ALG_Type_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCAllType&pClassQuery=GetDataForCmb1"; 
	var ALGAllergyDR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergy&pClassQuery=GetDataForCmb1";
    
      //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
      TableN : "PAC_Allergy"
  });
 	 Ext.BDP.FunLib.TableName="PAC_Allergy";
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
    Ext.BDP.FunLib.SortTableName = "User.PACAllergy";
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
	       RowID=rows[0].get('ALGRowId');
	       Desc=rows[0].get('ALGDesc');
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
	    }
	    else
	    {
	       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
	    }
  });
     
	/*****************************删除功能***************************************************/
	var btnDel = new Ext.Toolbar.Button({
		  text : '删除',
	  	  tooltip : '删除',
		  iconCls : 'icon-delete',
		  id : 'del_btn',
		  disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
	  	  handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
                var gsm = grid.getSelectionModel();
                var rows = gsm.getSelections();
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
                        //删除所有别名
                        AliasGrid.DataRefer=rows[0].get('ALGRowId') ;
                        AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ALGRowId')
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

	/***************************** 增加修改的Form*****************************************/
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				URL : SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 85,
                title:'基本信息',
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ALGCode',mapping:'ALGCode'},
                                         {name: 'ALGDesc',mapping:'ALGDesc'},
                                         {name: 'ALGTypeDR',mapping:'ALGTypeDR'},
										 {name:'ALGAllergyDR',mapping:'ALGAllergyDR'},
                                         {name: 'ALGDateFrom',mapping:'ALGDateFrom'},
                                         {name: 'ALGDateTo',mapping:'ALGDateTo'},
                                         {name: 'ALGRowId',mapping:'ALGRowId'}
                                        ]),
				defaults : {
					anchor : '95%',
					border : false
				},
				items : [{
							id:'ALGRowId',
							xtype:'textfield',
							fieldLabel : 'ALGRowId',
							name : 'ALGRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'ALGCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALGCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALGCodeF')),
							name : 'ALGCode',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACAllergy";
	                            var classMethod = "FormValidate";                           
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ALGRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
	                            if(flag == "1"){
	                            	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'ALGDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALGDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALGDescF')),
							name : 'ALGDesc',
							allowBlank:false,
							enableKeyEvents:true, 
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACAllergy";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ALGRowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
							
						}, {
							xtype : "bdpcombo",
							fieldLabel : '过敏原分类',
                            loadByIdParam:'rowid',
                            hiddenName : 'ALGTypeDR',
                            id:'ALGTypeDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALGTypeDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALGTypeDRF')),
							store : new Ext.data.Store({
										autoLoad: true,
                                        pageSize:Ext.BDP.FunLib.PageSize.Combo,
										proxy : new Ext.data.HttpProxy({ url : ALG_Type_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'MRCATRowId',mapping:'MRCATRowId'},
										{name:'MRCATDesc',mapping:'MRCATDesc'} ])
								}),
							mode : 'local',
						    queryParam : 'desc',
							shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							displayField : 'MRCATDesc',
							valueField : 'MRCATRowId'
						}, {
							xtype : "bdpcombo",
							fieldLabel : '关联过敏原',
                            loadByIdParam:'rowid',
							queryParam : 'desc',
                            hiddenName : 'ALGAllergyDR',
                            id:'ALGAllergyDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALGAllergyDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALGAllergyDRF')),
							store : new Ext.data.Store({ 
									pageSize:Ext.BDP.FunLib.PageSize.Combo,
									proxy : new Ext.data.HttpProxy({ url : ALGAllergyDR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
									totalProperty : 'total',
									root : 'data',
									successProperty : 'success'
								}, [{ name:'ALGRowId',mapping:'ALGRowId'},
									{name:'ALGDesc',mapping:'ALGDesc'} ])
							}),
							mode : 'local',
							shadow:false,
                            pageSize: comboPage ,
                            listWidth : 250,
							forceSelection : true,
							selectOnFocus : false, 
							displayField : 'ALGDesc',
							valueField : 'ALGRowId'
						},{
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'ALGDateFrom',
							format : BDPDateFormat,
							id:'date1',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
  					 		readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
  					 		style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
							allowBlank:false
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'ALGDateTo',
							format :BDPDateFormat,
							id:'date2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')) 
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
 
	/**************************************增加修改时弹出窗口*********************************/
	var win = new Ext.Window({
		width : 470,
		height: 360,
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
            var tempCode = Ext.getCmp("form-save").getForm().findField("ALGCodeF").getValue();
            var tempDesc = Ext.getCmp("form-save").getForm().findField("ALGDescF").getValue();
            var startDate = Ext.getCmp("form-save").getForm().findField("date1").getValue();
            var endDate = Ext.getCmp("form-save").getForm().findField("date2").getValue();
            if (tempCode=="") {
			    Ext.Msg.show({ 
						        title : '提示', 
						        msg : '代码不能为空!',
						        minWidth : 200,
						        animEl: 'form-save',
						        icon : Ext.Msg.ERROR,
						        buttons : Ext.Msg.OK ,
						        fn:function()
						        {
						         Ext.getCmp("form-save").getForm().findField("ALRGSEVCode").focus(true,true);
						        }
			              });
			      return;
			   }
			   if (tempDesc=="") {
			       Ext.Msg.show({ 
							        title : '提示',
							        msg : '描述不能为空!', 
							        minWidth : 200, 
							        animEl: 'form-save',
							        icon : Ext.Msg.ERROR, 
							        buttons : Ext.Msg.OK ,
							        fn:function()
							        {
							         Ext.getCmp("form-save").getForm().findField("ALRGSEVDesc").focus(true,true);
							        }
							   });
			       return;
			  }
             if (startDate=="") {
				    Ext.Msg.show({ 
							        title : '提示', 
							        msg : '开始日期不能为空!', 
							        minWidth : 200,
							        animEl: 'form-save', 
							        icon : Ext.Msg.ERROR, 
							        buttons : Ext.Msg.OK ,
							        fn:function()
							        {
							         Ext.getCmp("form-save").getForm().findField("ALRGSEVDateFrom").focus(true,true);
							        }
							    });
				       return;
				   }
				   if (startDate != "" && endDate != "") {
				       if (startDate > endDate) {
				         Ext.Msg.show({
								         title : '提示',
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
						url : SAVE_ACTION_URL,
						clientValidation : true,
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
							Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
						 }
					 });
				 } 
		 else {
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
                  ClearForm(); 
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("ALGCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 closepages();
               },
			"close" : function() {
			}
		}
	});
	
	/***********************************增加按钮**************************************************/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
                    tabs.setActiveTab(0);
		            //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
				},
				scope: this
	  });
	
	/**************************************修改按钮********************************************/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						loadFormData(grid);
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
	var fields=[{
					name : 'ALGRowId',
					mapping : 'ALGRowId',
					type : 'number'
				}, {
					name : 'ALGCode',
					mapping : 'ALGCode',
					type : 'string'
				}, {
					name : 'ALGDesc',
					mapping : 'ALGDesc',
					type : 'string'
				}, {
					name : 'ALGTypeDR',
					mapping : 'ALGTypeDR',
					type : 'string'
				}, {
					name : 'ALGAllergyDR',
					mapping : 'ALGAllergyDR',
					type : 'string'
				},{ 
					name:'ALGNoteText',
					mapping:'ALGNoteText',
					type:'string'
				},{
					name : 'ALGDateFrom',
					mapping : 'ALGDateFrom',
					type : 'date',
                    dateFormat : 'm/d/Y'
				}, {
					name : 'ALGDateTo',
					mapping : 'ALGDateTo',
					type : 'date' ,
                    dateFormat : 'm/d/Y'
				} ]
					
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields) 
	     });
	 
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);	
 	// 加载数据
	ds.load({
				  params : { start : 0, limit : limit } 
	   });
	
	/** **************************grid分页工具条**************************************/
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

	/*************************************增删改工具条******************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
	});
	
	/****************************************搜索工具条*************************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={
						code :  Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue()
				};
		grid.getStore().load({
					params : {
								start : 0,
								limit : limit
							}
				});
		  }
	});
	
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
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
	
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
									xtype:'textfield',
									id : 'TextCode',
									disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
								  },'-',
						'描述/别名', 
								 {
								 	xtype : 'textfield',
								 	id : 'TextDesc',
								 	disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},'-',LookUpConfigureBtn,'-',btnSearch,'-', btnRefresh,'->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});

	// 创建Grid
	var GridCM=[new Ext.grid.CheckboxSelectionModel(),  {
							header : 'ALGRowId',
							width : 70,
							sortable : true,
							dataIndex : 'ALGRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'ALGCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'ALGDesc'
						}, {
							header : '过敏原分类',
							width : 100,
							sortable : true,
							dataIndex : 'ALGTypeDR'
						},{
							header:'关联过敏原',
							width:100,
							sortable:true,
							dataIndex:'ALGAllergyDR'
						},  {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ALGDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ALGDateTo'
						} ];
	var grid = new Ext.grid.GridPanel({
				title : '过敏原',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				closable : true,
				store : ds,
				trackMouseOver : true,
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				columns :GridCM,
				stripeRows : true,
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'	
	});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
   /**********************************右键菜单************************************/
   if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  {
     grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
   	 var rightClick = new Ext.menu.Menu({
      id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
      disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
      items: [
         {
             id: 'rMenu1',
             iconCls :'icon-delete',
             handler: DelData,//点击后触发的事件
             disabled : true, //Ext.BDP.FunLib.Component.DisableFlag('rMenu1'),
             text: '删除数据'
         }, {
             id: 'rMenu2',
             iconCls :'icon-add',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu2'),
             handler: AddData,
             text: '添加数据'
         },{
             id: 'rMenu3',
             iconCls :'icon-update',
             disabled : Ext.BDP.FunLib.Component.DisableFlag('rMenu3'),
             handler:UpdateData ,
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
}

	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		  	var _record=grid.getSelectionModel().getSelected();
	      	var selectrow=_record.get('ALGRowId');
		 }
		else
		{
		  	var selectrow=""
		 }
		Ext.BDP.FunLib.SelectRowId=selectrow
  });
   /********************************载入被选择的数据行的表单数据*******************************************/
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
        } else {
        	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ALGRowId'),
                success : function(form,action) {
                   
                },
                failure : function(form,action) {
                }
            });
             //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('ALGRowId');
               AliasGrid.loadGrid();
        }
    };
    
    grid.on("rowdblclick", function(grid, rowIndex, e) {
        	loadFormData(grid);
    });	
    /********************************* 快捷键操作*******************************************/
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	// 创建viewport
	var viewport = new Ext.Viewport({
		 layout : 'border',
	 	 items : [grid]
	});
});