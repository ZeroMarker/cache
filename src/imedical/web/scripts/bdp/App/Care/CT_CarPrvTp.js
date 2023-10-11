/// 名称: 医护人员类型
/// 编写者： 基础数据平台组 、蔡昊哲
/// 编写日期: 2012-6-1
/// 最后修改日期: 2013-5-14
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.CTCarPrvTp";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassMethod=DeleteData";
	var Verify_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassMethod=VerifyData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.CTCarPrvTp&pClassMethod=OpenData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;

	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

	Ext.QuickTips.init();												   //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip';						   //--------设置消息提示方式为在下方直接显示
    
      if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器，否则可能会报错
    {
    	
    }
    
    	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="CT_CarPrvTp"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
		/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.CTCarPrvTp";
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
       RowID=rows[0].get('CTCPTRowId');
       Desc=rows[0].get('CTCPTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });

    //初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "CT_CarPrvTp"
	});
	
	// 医护人员类型维护
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler :  DelData=function() {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						AliasGrid.DataRefer = rows[0].get('CTCPTRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('CTCPTRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											/*fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												grid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize
															}
														});
											}*/
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}

										});
									} else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
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
	// 增加修改的Form
	
	/**---自定义一个cKData的vtype的表单验证，用来验证结束日期是否大约开始日期*/
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();                       //--------获取第一个日期值
    		var v2 = Ext.getCmp("date2").getValue();                       //--------获取第二个日期值
    		if(v1=="" || v2=="") return true;                              //--------有日期为空的情况要排除在外
    		if( v2 > v1) return false;                                                //--------通过判断返回一个boolean值类型
		},cKDateText:'开始日期不能大于结束日期'                                //--------当判断错误时显示的错误提示信息
		});
		 
		
	
	var WinForm = new Ext.form.FormPanel({
		id : 'form-save',
		//collapsible : true,
		title : '基本信息',
		//region: 'west',
		//bodyStyle : 'padding:5px 5px 0',
		//URL : SAVE_ACTION_URL_New,
		//baseCls : 'x-plain',//form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 75,
		split : true,
		frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
		waitMsgTarget : true,
		defaults : {
			anchor : '85%',
			bosrder : false
		},
		reader: new Ext.data.JsonReader({root:'list'},
            [{name: 'CTCPTCode',mapping:'CTCPTCode'},
             {name: 'CTCPTDesc',mapping:'CTCPTDesc'},
             {name: 'CTCPTInternalType',mapping:'CTCPTInternalType'},
             {name: 'CTCPTDateFrom',mapping:'CTCPTDateFrom'},
             {name: 'CTCPTDateTo',mapping:'CTCPTDateTo'},
             {name: 'CTCPTRotaryFlag',mapping:'CTCPTRotaryFlag'},
             {name: 'CTCPTStudyFlag',mapping:'CTCPTStudyFlag'},
             {name: 'CTCPTRowId',mapping:'CTCPTRowId'}
            ]),
		defaultType : 'textfield',
		items : [{
					fieldLabel : 'CTCPTRowId',
					hideLabel : 'True',
					hidden : true,
					name : 'CTCPTRowId'
				}, {
					fieldLabel : '<font color=red>*</font>代码',
					name : 'CTCPTCode',
					id:'CTCPTCode',	
   					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCPTCode'),
   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCPTCode')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCPTCode'),
					allowBlank: false,
					blankText: '代码不能为空',
					validationEvent : 'blur',
                    validator : function(thisText){
                    	//Ext.Msg.alert(thisText);
                        if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                        	return true;
                        }
                        var className =  "web.DHCBL.CT.CTCarPrvTp"; //后台类名称
                        var classMethod = "FormValidate"; //数据重复验证后台函数名
                        var id="";
                        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
                        	var _record = grid.getSelectionModel().getSelected();
                        	var id = _record.get('CTCPTRowId'); //此条数据的rowid
                        }
                        var flag = "";
                        var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
                        //Ext.Msg.alert(flag);
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
					fieldLabel : '<font color=red>*</font>名称',
					name : 'CTCPTDesc',
					id:'CTCPTDesc',
   					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCPTDesc'),
   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCPTDesc')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCPTDesc'),
					allowBlank: false,
					blankText: '名称不能为空',
					validationEvent : 'blur',
                    validator : function(thisText){
                    	//Ext.Msg.alert(thisText);
                        if(thisText==""){ //当文本框里的内容为空的时候不用此验证
                        	return true;
                        }
                        var className =  "web.DHCBL.CT.CTCarPrvTp"; //后台类名称
                        var classMethod = "FormValidate"; //数据重复验证后台函数名
                        var id="";
                        if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
                        	var _record = grid.getSelectionModel().getSelected();
                        	var id = _record.get('CTCPTRowId'); //此条数据的rowid
                        }
                        var flag = "";
                        var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
                        //Ext.Msg.alert(flag);
                        if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
                         	return false;
                         }else{
                         	return true;
                         }
                    },
                    invalidText : '该名称已经存在',
				    listeners : {
    			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
				    }
				}, {
					fieldLabel : '类型',
					xtype : 'combo',
					hiddenName: 'CTCPTInternalType',
					//name : 'CTCPTInternalType',
					id : 'CTCPTInternalTypeF',
   					//disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCPTInternalType'),
   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCPTInternalTypeF')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCPTInternalType'),
					width : 140,
					mode : 'local',
					triggerAction : 'all',// query
					forceSelection : true,
					selectOnFocus : false,
					listWidth : 250,
					valueField : 'value',
					displayField : 'name',
					store : new Ext.data.JsonStore({
						fields : ['name', 'value'],
						data : [{
									name : '护士',
									value : 'NURSE'
								}, {
									name : '医生',
									value : 'DOCTOR'
								}, {
									name : '技师',
									value : 'Technician'
								}, {
									name : '药师',
									value : 'Pharmacist'
								}, {
									name : '其他',
									value : 'Other'
								}]
					}),
					 listeners : {
    			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
				    }
				}, {
					xtype : 'datefield',
					fieldLabel : '开始日期',
					name : 'CTCPTDateFrom',
					format : BDPDateFormat,
					id:'date1',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
					enableKeyEvents : true,
					listeners : {
		       		'keyup' : function(field, e){
							Ext.BDP.FunLib.Component.GetCurrentDate(field, e  );							
			       	 	}
					}
					//editable:false
        			//vtype:'cKDate'                                    //-------------使用自定义的vtype验证
				}, {
					xtype : 'datefield',
					fieldLabel : '结束日期',
					name : 'CTCPTDateTo',
					format : BDPDateFormat,
					id:'date2',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
					enableKeyEvents : true,
					listeners : {
		       		'keyup' : function(field, e){
							Ext.BDP.FunLib.Component.GetCurrentDate(field, e );							
			       	 	}
					}
					//editable:false
        			//vtype:'cKDate'                                    //-------------使用自定义的vtype验证
				},{
					xtype:'checkbox',
					fieldLabel: '轮转标志',
			        name: 'CTCPTRotaryFlag',
			        id: 'CTCPTRotaryFlag',
			        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCPTRotaryFlag'),
			        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCPTRotaryFlag')),
			        //dataIndex:'CTCPTRotaryFlag',
			        inputValue : true?'Y':'N'
				},{
					xtype:'checkbox',
					fieldLabel: '进修标志',
			        name: 'CTCPTStudyFlag',
			        id: 'CTCPTStudyFlag',
			        readOnly : Ext.BDP.FunLib.Component.DisableFlag('CTCPTStudyFlag'),
			        style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('CTCPTStudyFlag')),
			        //dataIndex:'CTCPTStudyFlag',
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
		 
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width : 380,
		height : 325,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : tabs,
		buttons : [{
			text : '保存',
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				var startDate = Ext.getCmp("date1").getValue();
			   	var endDate = Ext.getCmp("date2").getValue();
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
								// var myrowid = jsonData.id;
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
																limit : pagesize,
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
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
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
						//WinForm.form.isValid();
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
									// alert(action);
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+ action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												//var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});*/
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
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
								switch (action.failureType) {
								    case Ext.form.Action.CLIENT_INVALID:
									       Ext.Msg.alert('Failure', '客户端的表单验证出现错误');
									break;
									case Ext.form.Action.CONNECT_FAILURE:
									       Ext.Msg.alert('Failure', '远程服务器发送请求遇到通信错误');
									break;
									case Ext.form.Action.SERVER_INVALID:
										Ext.Msg.alert('Failure', '服务器端数据验证失败');
								 }
								}
							})
						}
					}, this);
					// WinForm.getForm().reset();
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
				Ext.getCmp("CTCPTCode").focus(true,500);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
			},
			"close" : function() {
			}
		}
	});
	// 增加按钮
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData =function () {
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
	// 修改按钮
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
  				 disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData = function () {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						loadFormData(grid);
						var _record = grid.getSelectionModel().getSelected();// records[0]
						/*Ext.getCmp("form-save").getForm().loadRecord(_record);
						Ext.getCmp("form-save").getForm().findField('CTCPTRotaryFlag').setValue((_record.get('CTCPTRotaryFlag'))=='Y'?true:false);
						Ext.getCmp("form-save").getForm().findField('CTCPTStudyFlag').setValue((_record.get('CTCPTStudyFlag'))=='Y'?true:false);*/
						 //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('CTCPTRowId');
				        AliasGrid.loadGrid();
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
	var fields= [{
									name : 'CTCPTRowId',
									mapping : 'CTCPTRowId',
									type : 'string'
								}, {
									name : 'CTCPTCode',
									mapping : 'CTCPTCode',
									type : 'string'
								}, {
									name : 'CTCPTDesc',
									mapping : 'CTCPTDesc',
									type : 'string'
								}, {
									name : 'CTCPTInternalType',
									mapping : 'CTCPTInternalType',
									type : 'string'
								}, {
									name : 'CTCPTRotaryFlag',
									mapping : 'CTCPTRotaryFlag',
									type : 'string'
								}, {
									name : 'CTCPTStudyFlag',
									mapping : 'CTCPTStudyFlag',
									type : 'string'
								}, {
									name : 'CTCPTDateFrom',
									mapping : 'CTCPTDateFrom',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'CTCPTDateTo',
									mapping : 'CTCPTDateTo',
									type : 'date',
									dateFormat : 'm/d/Y'
								}// 列的映射
						];
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : ACTION_URL
						}),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields),
				remoteSort : true
			});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
			
	ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			}); // 加载数据
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

	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel, '-' ,btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		})
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={			
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						InternalType : Ext.getCmp("TextInternalType").getValue()						
				};
				grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}

			});
	// 刷新工作条
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					
					Ext.BDP.FunLib.SelectRowId =""; //翻译
					
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("TextInternalType").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

			});
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							emptyText:'输入代码..'
						},
						// '-',
						'名称', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
							emptyText : '描述/别名',
							id : 'TextDesc'
						}, '-', '类型', {
							fieldLabel : '类型',
							xtype : 'combo',
							id : 'TextInternalType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextInternalType'),
							emptyText:'选择类型..',
							width : 140,
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							listWidth : 250,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '护士',
									value : 'NURSE'
								}, {
									name : '医生',
									value : 'DOCTOR'
								}, {
									name : '技师',
									value : 'Technician'
								}, {
									name : '药师',
									value : 'Pharmacist'
								}, {
									name : '其他',
									value : 'Other'
								}]
							})
						},'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName), '-', btnSearch, '-', btnRefresh, '->'
				// btnHelp
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	// create the Grid
			
	var GridCM = [sm, {
							header : 'CTCPT_RowId',
							width : 160,
							sortable : true,
							dataIndex : 'CTCPTRowId',
							hidden : true
						}, {
							header : '代码',
							width : 160,
							sortable : true,
							dataIndex : 'CTCPTCode'
						}, {
							header : '名称',
							width : 160,
							sortable : true,
							dataIndex : 'CTCPTDesc'
						}, {
							header : '类型',
							width : 85,
							sortable : true,
							dataIndex : 'CTCPTInternalType',
							renderer:function(value)
			            	{
			            		if (value=="NURSE")
			            		{
			            		   return "护士";
			            		}
			            		if (value=="DOCTOR")
			            		{
			            		   return "医生";
			            		}
			            		if (value=="Technician")
			            		{
			            		   return "技师";
			            		}
			            		if (value=="Pharmacist")
			            		{
			            		   return "药师";
			            		}
			            		if (value=="Other")
			            		{
			            		   return "其他";
			            		}
			            	}
						},{ 
							header: '轮转标志',
							sortable: true, 
							dataIndex: 'CTCPTRotaryFlag',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						},{ 
							header: '进修标志',
							sortable: true, 
							dataIndex: 'CTCPTStudyFlag',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '开始日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCPTDateFrom'
						}, {
							header : '结束日期',
							width : 85,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'CTCPTDateTo'
						}
						];
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				 tools:Ext.BDP.FunLib.Component.HelpMsg,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				title : '医护人员类型',
				// config options for stateful behavior
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
	
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        //alert(_record.get('CTSPCRowId'));
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('CTCPTRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	//alert(id);
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };
    
	//双击事件
	grid.on("rowdblclick", function(grid, rowIndex, e) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
			if (grid.selModel.hasSelection()) {
				var row = grid.getStore().getAt(rowIndex).data;
				win.setTitle('修改');
				win.setIconClass('icon-update');
				win.show('');
				/*var record = grid.getSelectionModel().getSelected();
				Ext.getCmp("form-save").getForm().loadRecord(record);
				Ext.getCmp("form-save").getForm().findField('CTCPTRotaryFlag').setValue((record.get('CTCPTRotaryFlag'))=='Y'?true:false);
				Ext.getCmp("form-save").getForm().findField('CTCPTStudyFlag').setValue((record.get('CTCPTStudyFlag'))=='Y'?true:false);*/
				loadFormData(grid);
				//激活基本信息面板
	            tabs.setActiveTab(0);
		        //加载别名面板
	            var _record = grid.getSelectionModel().getSelected();
	            AliasGrid.DataRefer = _record.get('CTCPTRowId');
		        AliasGrid.loadGrid();
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
			
	 	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('CTCPTRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
 /************************************ 调用keymap*********************************************/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
	// var gridname=Ext.getCmp(Request);
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});

});
