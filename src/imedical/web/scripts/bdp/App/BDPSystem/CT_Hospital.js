/**@author基础数据平台公共产品组 蔡昊哲**/
/**@argument：医院维护**/
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
var communityid=Ext.getUrlParam('communityid');
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTHospital";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassMethod=DeleteData";
	var OPEN_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassMethod=OpenData";
	var DefaultHospital = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	/************************************键盘事件，按键弹出添加窗口***********************************/

   	

  
  		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_Hospital"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
		/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTHospital";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    /*****************排序*******************/
    //////////////////////////////日志查看 ////////////////////////////////////////
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
       RowID=rows[0].get('HOSPRowId');
       Desc=rows[0].get('HOSPDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

  //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_Hospital"
	});
	
	/**-----------------------实现医院维护中的删除功能-------------------------**/
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						AliasGrid.DataRefer = rows[0].get('HOSPRowId');
						AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id':rows[0].get('HOSPRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}
										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br />错误信息:' + jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '删除失败!' + errorMsg,
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

/************************************增加修改的Form************************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				title : '基本信息',		
				labelAlign : 'right',
				width : 250,
				split : true,
				frame : true,
				defaults : {
					width : 230,
					bosrder : false   
				},
				reader: new Ext.data.JsonReader({root:'list'},
	            [{name: 'HOSPCode',mapping:'HOSPCode'},
	             {name: 'HOSPDesc',mapping:'HOSPDesc'},
	             {name: 'HOSPShortDesc1',mapping:'HOSPShortDesc1'},
	             {name: 'HOSPShortDesc2',mapping:'HOSPShortDesc2'},
	             {name: 'HOSPDateFrom',mapping:'HOSPDateFrom'},
	             {name: 'HOSPDateTo',mapping:'HOSPDateTo'},
	             {name: 'HOSPMandatoryRefHospital',mapping:'HOSPMandatoryRefHospital'},
				 {name: 'HOSPDefaultHospitalDR',mapping:'HOSPDefaultHospitalDR'},	//20200429 lkf
	             {name: 'HOSPRowId',mapping:'HOSPRowId'}
	            ]),
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'HOSPRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'HOSPRowId'
						}, {
							xtype : 'textfield',
							fieldLabel : '<font color=red>*</font>代码',
							allowBlank:false,
						 	blankText: '代码不能为空',
							name : 'HOSPCode',
							id:'HOSPCode',	
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPCode')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPCode'),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPCode'),
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                          if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                          return true;
	                          }
	                            var className =  "web.DHCBL.CT.CTHospital";   
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){  
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('HOSPRowId');  
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
							xtype : 'textfield',
							fieldLabel : '<font color=red>*</font>描述',
							allowBlank:false,
							blankText: '描述不能为空',
							name : 'HOSPDesc',
							id:'HOSPDesc',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc'),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDesc'),
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){  
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.CTHospital"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ 
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('HOSPRowId');  
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
						},{	//20200429 lkf
							xtype:'bdpcombo',
							loadByIdParam : 'rowid',
							fieldLabel : '医院组默认医院',
							name:'HOSPDefaultHospitalDR',
							id:'HOSPDefaultHospitalDRF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDefaultHospitalDRF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDefaultHospitalDRF')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDefaultHospitalDRF'),
							hiddenName : 'HOSPDefaultHospitalDR',
							forceSelection: true,
							queryParam:"desc",
							listWidth:300,
							//triggerAction : 'all',
							selectOnFocus:false,
							mode:'remote',
							pageSize: Ext.BDP.FunLib.PageSize.Combo,
							displayField : 'HOSPDesc',
							valueField : 'HOSPRowId',
							listWidth : 270,//下拉框宽度
							store : new Ext.data.JsonStore({
								//autoLoad : true,
								url : DefaultHospital,
								baseParams:{communityid:communityid},
								root : 'data',
								totalProperty : 'total',
								idProperty : 'HOSPRowId',
								fields : ['HOSPRowId', 'HOSPDesc'],
								remoteSort : true,
								sortInfo : {
									field : 'HOSPRowId',
									direction : 'ASC'
								}
							})
						}, {
							xtype : 'textfield',
							fieldLabel : '简称1',
							name : 'HOSPShortDesc1',
							id:'HOSPShortDesc1',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPShortDesc1')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPShortDesc1')
						}, {
							xtype : 'textfield',
							fieldLabel : '简称2',
							name : 'HOSPShortDesc2',
							id:'HOSPShortDesc2',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPShortDesc2')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPShortDesc2')
						},{
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name :'HOSPDateFrom',
							id:'HOSPDateFromF',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF'),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateFromF'),
							format : BDPDateFormat,
							allowBlank:false,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							blankText: '开始日期不能为空'
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'HOSPDateTo',
							id:'HOSPDateToF',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF'),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPDateToF'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
							//editable:false
						},{ 							 
							fieldLabel : '转诊医院',
							name :'HOSPMandatoryRefHospital',
							id:'HOSPMandatoryRefHospitalF',
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF'),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPMandatoryRefHospitalF'),
							xtype:'checkbox',
							autoHeight:'true',
							inputValue : true?'Y':'N'
					    }]
			});

			
	var tabs = new Ext.TabPanel({
		 activeTab : 0,
		 frame : true,
		 border : false,
		 height : 200,
		 items : [WinForm, AliasGrid]
	 });
	 
/************************************增加修改时弹出窗口***********************************/
	var win = new Ext.Window({
		title : '',
		width : 450,
		height : 400,
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
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function AddData() {
			var tempCode = Ext.getCmp("form-save").getForm().findField("HOSPCode").getValue();
			var tempDesc = Ext.getCmp("form-save").getForm().findField("HOSPDesc").getValue();
			var startDate = Ext.getCmp("form-save").getForm().findField("HOSPDateFrom").getValue();
			var endDate = Ext.getCmp("form-save").getForm().findField("HOSPDateTo").getValue();
			if (tempCode=="") {
				Ext.Msg.show({ title : '提示', msg : '代码不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (tempDesc=="") {
				Ext.Msg.show({ title : '提示', msg : '描述不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (startDate=="") {
				Ext.Msg.show({ title : '提示', msg : '开始日期不能为空！', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      			return;
			}
			if (startDate != "" && endDate != "") {
    			if (startDate > endDate) {
    				Ext.Msg.show({
    					title : '提示',
						msg : '开始日期不能大于结束日期！',
						minWidth : 200,
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
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,
						method : 'POST',
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
												var startIndex = grid.getBottomToolbar().cursor;
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
								//保存别名
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
							Ext.Msg.alert('提示', '添加失败！');
						}
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								success : function(form, action) {
									//保存别名
									AliasGrid.saveAlias();
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+ action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid);
												
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
									Ext.Msg.alert('提示', '修改失败');
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
				Ext.getCmp("form-save").getForm().findField("HOSPCode").focus(true,50);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
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
					//激活基本信息面板
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
					if (grid.selModel.hasSelection()) {
						
						loadFormData(grid);
						
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				}
			});
/************************************数据存储***********************************/
			
	var fields=[{     
						            name : 'HOSPRowId',
									mapping :'HOSPRowId',
									type : 'string'
								}, {
									name : 'HOSPCode',
									mapping : 'HOSPCode',
									type : 'string'
								}, {
									name : 'HOSPDesc',
									mapping :'HOSPDesc',
									type:'string'
								}, {
									name : 'HOSPShortDesc1',
									mapping :'HOSPShortDesc1',
									type:'string'
								}, {
									name : 'HOSPShortDesc2',
									mapping :'HOSPShortDesc2',
									type:'string'
								},{
									name:'HOSPDateFrom',
									mapping:'HOSPDateFrom',
									type : 'string'
								}, {
									name :'HOSPDateTo',
									mapping :'HOSPDateTo',
									type : 'string'
								},{
									name:'HOSPMandatoryRefHospital',
									mapping:'HOSPMandatoryRefHospital',
									inputValue : true?'Y':'N'
								
								
								},{
									name :'HOSPDefaultHospitalDR',
									mapping :'HOSPDefaultHospitalDR',
									type : 'string'
								}
						];
	
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
									
						}, fields),
				remoteSort : true
			});
	
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	/************************************数据加载************************************/
	ds.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		     communityid:communityid
		  }   
		)
	});
	ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			}); // 加载数据
/************************************数据分页************************************/
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
				          "change":function (t,p)
				         { 
				             pagesize=this.pageSize;
				         }
		        }
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
/************************************增删改工具条************************************/
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]
		})
 
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
						limit : pagesize,
						communityid:communityid
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
					
					Ext.BDP.FunLib.SelectRowId =""; //翻译
					
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize,
									communityid:communityid
								}
							});
				}

			});
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						// '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							emptyText : '描述/别名',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}
					  ,'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', btnSearch, '-', btnRefresh, '->'
				// btnHelp
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	 /************************************创建表格************************************/
	var GridCM =[sm, {
							header :'HOSPRowId',
							width : 60,
							sortable : true,
						    hidden:true,
							dataIndex : 'HOSPRowId'
					  }, {
							header : '代码',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPCode'
						}, {
							header : '描述',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPDesc'
						},{
							header : '医院组默认医院',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPDefaultHospitalDR'
						},{
							header : '简称1',
							width : 100,
							sortable : true,
							dataIndex : 'HOSPShortDesc1'
						},{
							header : '简称2',
							width : 100,
							sortable : true,
							dataIndex : 'HOSPShortDesc2'
						},{
							header : '开始日期',
							width : 120,
							sortable : true,
							dataIndex :'HOSPDateFrom'
						}, {
							header : '结束日期',
							width : 120,
							sortable : true,
							dataIndex : 'HOSPDateTo'
						},{
							header : '转诊医院',
							width : 80,
							sortable : true,
							dataIndex : 'HOSPMandatoryRefHospital',
							renderer :Ext.BDP.FunLib.Component.ReturnFlagIcon 
						
						}];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				disabled:Ext.BDP.FunLib.Component.DisableFlag('grid'),
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				columns : GridCM,
				stripeRows : true,
				loadMask : {
					//msg : '数据加载中,请稍候...'
				},
				title : '医院维护',
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
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
/************************************双击事件************************************/
	  		var loadFormData = function(grid){
		        var _record = grid.getSelectionModel().getSelected();  //records[0]//获取当前行的记录
		        if (!_record) {
		            Ext.Msg.alert('修改操作', '请选择要修改的一项!');
		        } else {
		        		win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
						//加载别名面板
		        		AliasGrid.DataRefer = _record.get('HOSPRowId');
		        		AliasGrid.loadGrid();
		        		WinForm.form.load( {
		                url : OPEN_ACTION_URL + '&id='+ _record.get('HOSPRowId'),  //id 对应OPEN里的入参
		                success : function(form,action) {
			        	},
		                failure : function(form,action) {
		                }
		            });
		        }
	    };
	    grid.on("rowdblclick", function(grid, rowIndex, e) {
			   	loadFormData(grid)
	    });	
	    
	    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('HOSPRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
});
