/**
 * @Title: 基础数据平台-基础数据
 * @Author: 孙凤超 DHC-BDP
 * @Description: 用于过敏改变原因维护
 * @Created on 2013-6-26
 * @LastUpdated on    by sunfengchao
 */
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');  
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    var limit = Ext.BDP.FunLib.PageSize.Main;
    
    /// 调用过敏改变原因维护的后台类方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergyReasonForChang&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACAllergyReasonForChang&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACAllergyReasonForChang";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAllergyReasonForChang&pClassMethod=DeleteData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACAllergyReasonForChang&pClassMethod=OpenData";	

     //初始化“别名”维护面板
     var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
         TableN : "PAC_AllergyReasonForChang"
     });
   	 Ext.BDP.FunLib.TableName="PAC_AllergyReasonForChang";
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
    Ext.BDP.FunLib.SortTableName = "User.PACAllergyReasonForChang";
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
       RowID=rows[0].get('ALRFCRowId');
       Desc=rows[0].get('ALRFCDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
 /************************************ 删除功能************************************/
	var btnDel = new Ext.Toolbar.Button({
			text : '删除',
			iconCls : 'icon-delete',
			id:'del_btn',
	   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
			handler : DelData=function() {
			  if (grid.selModel.hasSelection()) {
                  var gsm = grid.getSelectionModel();// 获取选择列
                  var rows = gsm.getSelections();// 根据选择列获取到所有的行
				  Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
                         //删除所有别名
                        AliasGrid.DataRefer=rows[0].get('ALRFCRowId') ;
                        AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ALRFCRowId')
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
/************************************增加修改的Form********************************/
  			 
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
                title:'基本信息',
				width : 200,
				split : true,
				frame : true,
				defaults : {
					anchor: '85%',
					 border: false  
				},
				reader:new Ext.data.JsonReader({root:'list'},
                         [ 
                        	 {
									name : 'ALRFCRowId',
									mapping : 'ALRFCRowId',
									type : 'int'
								}, {
									name : 'ALRFCCode',
									mapping : 'ALRFCCode',
									type : 'string'
								}, {
									name : 'ALRFCDesc',
									mapping :'ALRFCDesc',
									type:'string'
								},{
									name:'ALRFCDateFrom',
									mapping:'ALRFCDateFrom',
									type:'string'
								}, {
									name :'ALRFCDateTo',
									mapping :'ALRFCDateTo',
									type:'string'
								}// 列的映射
                         ]),
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ALRFCRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ALRFCRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'ALRFCCode',
							id:'ALRFCCodeF',
							stripCharsRe :  ' ',
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRFCCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRFCCodeF')),
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                          if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                          return true;
	                          }
	                            var className =  "web.DHCBL.CT.PACAllergyReasonForChang";   
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){  
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ALRFCRowId');  
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
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							name : 'ALRFCDesc',
							id:'ALRFCDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRFCDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRFCDescF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){  
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACAllergyReasonForChang"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ 
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ALRFCRowId');  
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
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							allowBlank:false,
							regexText:"开始日期不能为空",
							name :'ALRFCDateFrom',
							id:'ALRFCDateFromF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRFCDateFromF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRFCDateFromF')),
							format : BDPDateFormat,
							editable:true,
							enableKeyEvents : true,
							listeners : {   
								'keyup' : function(field, e)
								{	
									Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
								
								}}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'ALRFCDateTo',
							id:'ALRFCDateToF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ALRFCDateToF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ALRFCDateToF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   
								'keyup' : function(field, e)
								{	
									Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
								
								}}
						}]
			});
   
/************************************增加修改时弹出窗口************************************/
     function ValidateCode(value){
              for (var i = 0; i < value.length; i++){
                  if (value.charAt(i)=='#') {
                   Ext.Msg.alert("提示","您输入的是非法字符，请重新输入。")
                }
              }
           }
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
   var win = new Ext.Window({
		width : 460,
		height :310,
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
		labelWidth : 55,
		items : tabs,
		buttons : [{
			text : '保存',
            iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("ALRFCCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("ALRFCDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("ALRFCDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("ALRFCDateTo").getValue();
            if (tempCode!=""){
             ValidateCode(tempCode)
           }
         
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
									Ext.getCmp("form-save").getForm().findField("ALRFCCode").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("ALRFCDesc").focus(true,true);
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
									Ext.getCmp("form-save").getForm().findField("ALRFCDateFrom").focus(true,true);
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
                                AliasGrid.DataRefer = myrowid;
                                AliasGrid.saveAlias(); 
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:' + action.result.errorinfo
								}
								Ext.Msg.show({
												title : '<font color=blue>提示</font>',
												msg : '<font color=red>添加失败!</font>',
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
														msg : '<font color=red>修改失败!</font>',
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
							 });
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
					Ext.getCmp("form-save").getForm().findField("ALRFCCode").focus(true,300);
			},
			"hide" : function(){
                 Ext.BDP.FunLib.Component.FromHideClearFlag();
                 Ext.getCmp("form-save").getForm().reset();   
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
					//清空别名面板grid
	               	AliasGrid.DataRefer = "";
	               	AliasGrid.clearGrid();
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
                    tabs.setActiveTab(0);
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
	 
	/************************************数据存储************************************/
   	var fields=[{
					name : 'ALRFCRowId',
					mapping : 'ALRFCRowId',
					type : 'int'
				}, {
					name : 'ALRFCCode', 
					mapping : 'ALRFCCode',
					type : 'string'
				}, {
					name : 'ALRFCDesc',
					mapping :'ALRFCDesc',
					type:'string'
				},{
					name:'ALRFCDateFrom',
					mapping:'ALRFCDateFrom',
					type : 'date',
                    dateFormat : 'm/d/Y'
				}, {
					name :'ALRFCDateTo',
					mapping :'ALRFCDateTo',
					type : 'date',
                    dateFormat : 'm/d/Y'
				} ]
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
	/************************************数据加载************************************/
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
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel ,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog] 
		})
	/************************************搜索工具条***********************************/
	var btnSearch = new Ext.Button({
			id : 'btnSearch',
			iconCls : 'icon-search',
			text : '搜索',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
			handler : function() {
			grid.getStore().baseParams={			
					code :  Ext.getCmp("TextCode").getValue() ,
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
				grid.getStore().baseParams={};
				grid.getStore().load({
						params : {
									start : 0,
									limit : limit
								}
 						});
					}
	});
/************************************ 将工具条放到一起***********************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
			 },	'描述/别名', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
				 		} ,'-',LookUpConfigureBtn,'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) 
					}
				}
			});
/************************************create the Grid**********************************/ 
	var GridCM=[new Ext.grid.CheckboxSelectionModel(),{
							header : 'ALRFCRowId',
							width : 60,
							sortable : true,
							dataIndex :'ALRFCRowId',
							hidden : true
						}, {
							header : '代码',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'ALRFCCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							dataIndex : 'ALRFCDesc'
						}, {
							header : '开始日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex :'ALRFCDateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ALRFCDateTo'
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				singleSelect: true ,
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns:GridCM,
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				stripeRows : true,
				columnLines : true, //在列分隔处显示分隔符
				title : '过敏改变原因',
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
		Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	   /**********************************右键菜单************************************/
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
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection())
		{
		 	var _record=grid.getSelectionModel().getSelected();
	        var selectrow=_record.get('ALRFCRowId');
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
	        if (!_record) {
	            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
	        } else {
	        		WinForm.form.load( {
	                url : OPEN_ACTION_URL + '&id='+ _record.get('ALRFCRowId'),  //id 对应OPEN里的入参
	                success : function(form,action) {
                      
                 },
	                failure : function(form,action) {
	                }
	            });
                //激活基本信息面板
               tabs.setActiveTab(0);
               //加载别名面板
               AliasGrid.DataRefer = _record.get('ALRFCRowId');
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
