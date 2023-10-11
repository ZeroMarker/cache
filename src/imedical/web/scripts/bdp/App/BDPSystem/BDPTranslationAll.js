/// 名称: 基础数据翻译汇总
/// 描述: 包含增删改查
/// 编写者: 基础数据平台组-李欣
/// 编写日期: 2017-09-14
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPTranslation";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=OpenDataNew";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPTranslation&pClassMethod=DeleteData";
	var BindingForm="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSLanguage&pClassQuery=GetList";
	var BindingGen="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var BindingToxicity="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHToxicity&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	/*************************************排序*********************************/
   // Ext.BDP.FunLib.SortTableName = "User.BDPTranslation";
    //var btnSort = Ext.BDP.FunLib.SortBtn;
	Ext.BDP.FunLib.SortTableName = "User.BDPTranslation";
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
       RowID=rows[0].get('RowId');
       Desc=rows[0].get('FieldDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
  
  ////×××××××××××××××××××××导出功能开始×××××××××××××××××*****************************//
	///导出数据功能
	///导出Excel文件2017-9-14  谷雪萍
	function ExcelExport()
	{
		Ext.MessageBox.confirm('提示', '确定要导出查询出的翻译数据吗?', function(btn) {
		if (btn == 'yes') {
			try{
		    	xlApp = new ActiveXObject("Excel.Application");
				xlBook = xlApp.Workbooks.Add();///默认三个sheet
			}catch(e){
				var emsg="请在IE下操作，并在[internet选项]-[安全]-[受信任的站点]-[站点]中添加开始界面到可信任的站点，然后在[自定义级别]中对[没有标记为安全的ActiveX控件进行初始化和脚本运行]这一项设置为启用!"
					Ext.Msg.show({
						title : '提示',
						msg : emsg ,
						minWidth : 200,
						icon : Ext.Msg.INFO,
						buttons : Ext.Msg.OK
					}) 
			     return;
			}
		
			Ext.MessageBox.wait('正在导出查询出的翻译数据，请勿刷新或关闭页面，请稍候...','提示');
			///菜单
			xlBook.worksheets(1).select(); 
			var xlsheet = xlBook.ActiveSheet; 
			
			//var tablename =Ext.getCmp("textTableName").getValue();
			//var fieldname =Ext.getCmp("textFieldName").getValue();
			var language = Ext.getCmp("textLanguage").getValue();
			var fielddesc = Ext.getCmp("textFieldDesc").getValue();
			
			var menucount=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","GetTransCount",language,fielddesc);
			
			xlsheet.name="其他数据翻译";  //sheet的表名
			//1b	
	    	xlsheet.cells(1,1)="表名";
			xlsheet.cells(1,2)="字段";
			xlsheet.cells(1,3)="语言"+language; //dr-> 功能大表 User.BDPExecutables
			xlsheet.cells(1,4)="翻译前内容"+fielddesc;
			xlsheet.cells(1,5)="翻译后内容";
		
			//1b
			xlsheet.cells(2,1)="BTTableName";
			xlsheet.cells(2,2)="BTFieldName";
			xlsheet.cells(2,3)="BTLanguages";
			xlsheet.cells(2,4)="BTFieldDesc";
			xlsheet.cells(2,5)="BTTransDesc";
	
			
			for (var i=1;i<=menucount;i++){
				var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","GetTransDataInfo",i);
				var Details=DataDetailStr.split("&%");	
				for (var j=1;j<=5;j++){
					xlsheet.cells(2+i,j)=Details[j-1];
				}	
			}
		
			Ext.MessageBox.hide();
		
			xlApp.Visible=true;	
	
			Ext.Msg.show({
				title : '提示',
				msg : '导出完成!',
				icon : Ext.Msg.INFO,
				buttons : Ext.Msg.OK,
				fn : function(btn) {
					xlBook.Close(savechanges=true);
					xlApp.Quit();
					CollectGarbage();
					xlApp=null;
					xlsheet=null;
				}
			});
	
	
		}
	}, this);
		
	}

	    //搜索工具条
	var btnExport=new Ext.Button({
        iconCls:'icon-export',
        text:'导出',
        disabled : Ext.BDP.FunLib.Component.DisableFlag('btnExport'),
        handler:function(){
			ExcelExport();
        }
    });

////×××××××××××××××××××××导出功能结束××××××××××××××××××*****************************//
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
					//	Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						//删除所有别名
						//AliasGrid.DataRefer = rows[0].get('RowId');
						//AliasGrid.delallAlias();
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('RowId')
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
															var startIndex = grid.getBottomToolbar().cursor;
															var totalnum=grid.getStore().getTotalCount();
															if(totalnum==1){   //修改添加后只有一条，返回第一页
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
															{
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
															}
															grid.getStore().load({
																params : {
																			start : startIndex,
																			limit : pagesize_main
																		}
																	});
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
	/** 创建Form表单 */
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 90,
				title : '基本信息',
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                        [{name: 'ID',mapping:'ID',type:'string'},
                         //{name: 'BTTableName',mapping:'BTTableName',type:'string'},
                         //{name: 'BTFieldName',mapping:'BTFieldName',type:'string'},
                         {name: 'BTLanguages',mapping:'BTLanguages',type:'string'},
                         {name: 'BTFieldDesc',mapping:'BTFieldDesc',type:'string'},
                         {name: 'BTTransDesc',mapping:'BTTransDesc',type:'string'}
                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'BTRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ID',
							id:'BTRowIdF'
						}, /*{
							fieldLabel : '<font color=red>*</font>表名',
							name : 'BTTableName',
							id:'BTTableNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BTTableNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BTTableNameF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                          
	                            var className =  "web.DHCBL.BDP.FunLib";  //后台类名称
	                            var classMethod = "IsValidClassName"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('RowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            if(thisText!="User.OTHER"){
	                            	var flag = tkMakeServerCall(className,classMethod,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
		                            if(flag == "0"){  //当后台返回数据位"1"时转换为相应的bool值
		                             	return false;
		                             }else{
		                             	return true;
		                             }
	                            }else{
	                            	return true;
	                            }
	                            
                            },
                            invalidText : '表名输入错误',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>字段',
							name : 'BTFieldName',
							id:'BTFieldNameF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BTFieldNameF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BTFieldNameF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.FindTableStructure"; //后台类名称
	                            var classMethod = "PropertyExistOrNot"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('RowId'); //此条数据的rowid
	                            }
	                            var table = Ext.getCmp("BTTableNameF").getValue();
	                            var flag = "";
	                            if(table=='User.OTHER'&&thisText=='OTHER'){
	                            	return true;
	                            }else{
	                            	var flag = tkMakeServerCall(className,classMethod,table,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
		                            if(flag == "0"){  //当后台返回数据位"1"时转换为相应的bool值
		                             	return false;
		                             }else{
		                             	return true;
		                             }
	                            }
                            },
                            invalidText : '表名未填写或者此字段不存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						},*/ {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'CTLANCode',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>语言',
							id:'BTLanguagesF',
							hiddenName : 'BTLanguages',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BTLanguagesF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BTLanguagesF')),
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : BindingForm }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLANCode',mapping:'CTLANCode'},
										{name:'CTLANDesc',mapping:'CTLANDesc'} ])
								}),
							mode  : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							displayField : 'CTLANDesc',
							valueField : 'CTLANCode'
						}, {
							fieldLabel : '<font color=red>*</font>翻译前内容',
							name : 'BTFieldDesc',
							id:'BTFieldDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BTFieldDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BTFieldDescF')),
							allowBlank : false,
							/*validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPTranslation";  //后台类名称
	                            var classMethod = "Translated"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('BTRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var table = Ext.getCmp("BTTableNameF").getValue()
	                            var field = Ext.getCmp("BTFieldNameF").getValue()
	                            var lan = Ext.getCmp("BTLanguageF").getValue()
	                            var flag = tkMakeServerCall(className,classMethod,table,field,lan,thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该记录已翻译，不允许再次添加',*/
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>翻译后内容',
							name : 'BTTransDesc',
							id:'BTTransDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('BTTransDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('BTTransDescF')),
							allowBlank : false,
							/*validationEvent : 'blur',  
                           alidator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return false;
	                            }
	                           /* var className =  "web.DHCBL.KB.DHCPHProName";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('BTRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '此项不能为空',*/
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}]
			});
	var tabs = new Ext.TabPanel({
			 activeTab : 0,
			 frame : true,
			 border : false,
			 height : 200,
			 items : [WinForm]
		 });	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		width : 480,
		height : 380,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
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
				//var tempTableName = Ext.getCmp("BTTableNameF").getValue();
				//var tempFieldName = Ext.getCmp("BTFieldNameF").getValue();
				var tempLanguage = Ext.getCmp("BTLanguagesF").getValue();
				var tempFieldDesc = Ext.getCmp("BTFieldDescF").getValue();
				var tempTransDesc = Ext.getCmp("BTTransDescF").getValue();
				/*if (tempTableName=="") {
    				Ext.Msg.show({ title : '提示', msg : '表名不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempFieldName=="") {
    				Ext.Msg.show({ title : '提示', msg : '字段不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}*/
    			if (tempLanguage=="") {
    				Ext.Msg.show({ title : '提示', msg : '语言不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempFieldDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '翻译前内容不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (tempTransDesc=="") {
    				Ext.Msg.show({ title : '提示', msg : '翻译后内容不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}    			
    			if(WinForm.form.isValid()==false){return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params:{
							'BTTableName' :"User.OTHER",///desc只读，修改时禁用的话参数传不到，要单独传。
							'BTFieldName' : "OTHER"
						},
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
												grid.getStore().load({
													params : {
																start : 0,
																limit : 1,
																rowid : myrowid
															}
														});
											}
								});
								//添加时 同时保存别名
								//AliasGrid.DataRefer = myrowid;
								//AliasGrid.saveAlias();
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
					})
				} else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							//修改时 先保存别名
							//AliasGrid.saveAlias();	
							//如果对照了则不允许修改代码和描述
							//var PHNid=grid.getSelectionModel().getSelections()[0].get('PHNRowId')
							// disableFlag=CanUpdate(PHNid)
							/*Ext.getCmp("BTRowIdF").setDisabled(true);
				        	Ext.getCmp("BTTableNameF").setDisabled(true);
				        	Ext.getCmp("BTFieldNameF").setDisabled(true);/
				        	/*var id=grid.getSelectionModel().getSelections()[0].get('RowId');
				        	var fieldname =  grid.getSelectionModel().getSelections()[0].get('FieldName')
			        		var language  =  grid.getSelectionModel().getSelections()[0].get('Language')
				        	var fielddesc =  grid.getSelectionModel().getSelections()[0].get('FieldDesc')
				        	var transdesc =  grid.getSelectionModel().getSelections()[0].get('TransDesc');*/
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								params : {
									/*'id':*/
									'BTTableName' :"User.OTHER",///desc只读，修改时禁用的话参数传不到，要单独传。
									'BTFieldName' : "OTHER"
									/*'fielddesc' : fielddesc,
									'transdesc' : transdesc*/
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + action.result.id;
										//alert(myrowid)
										Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
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
			}
		}],
		listeners : {
			"show" : function() {
			},
			"hide" : Ext.BDP.FunLib.Component.FromHideClearFlag,
			"close" : function() {}
		}
	});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show('new1');
					WinForm.getForm().reset();
			       // Ext.getCmp("PHNCodeF").setDisabled(false);
		           //Ext.getCmp("PHNDescF").setDisabled(false);				
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            //AliasGrid.DataRefer = "";
		            //AliasGrid.clearGrid();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
  		 		disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					if (!grid.selModel.hasSelection()) {
			            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			        	var _record = grid.getSelectionModel().getSelected();
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('RowId'),
			                success : function(form,action) {
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            //var _record = grid.getSelectionModel().getSelected();
			            //AliasGrid.DataRefer = _record.get('PHNRowId');
				        //AliasGrid.loadGrid();
			        }
				}
			});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RowId',
									mapping : 'RowId',
									type : 'string'
								}, /*{
									name : 'TableName',
									mapping : 'TableName',
									type : 'string'
								},{
									name : 'FieldName',
									mapping : 'FieldName',
									type : 'string'
								},*/ {
									name : 'Language',
									mapping : 'Language',
									type : 'string'
								}, {
									name : 'FieldDesc',
									mapping : 'FieldDesc',
									type : 'string'
								}, {
									name : 'TransDesc',
									mapping : 'TransDesc',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						disabled : false,
						store : ds
					});
	/** grid加载数据 */
	ds.load({
		params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
			});
	/** grid分页工具条 */
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录",
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
				listeners : {
					"change":function (t,p) {
						pagesize_main=this.pageSize;
					}
				}
			});
			/*var testbt = new Ext.Button({
				text:'11',
				handler:function(){
					alert(Ext.getCmp("textLanguage").getValue())
				}
			})*/
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'->',btnlog,'-',btnhislog]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					//alert(Ext.getCmp("textLanguage").getRawValue())
					grid.getStore().baseParams={			
							//tablename : Ext.getCmp("textTableName").getValue(),
							//fieldname : Ext.getCmp("textFieldName").getValue(),
							language  : Ext.getCmp("textLanguage").getRawValue(),
							fielddesc : Ext.getCmp("textFieldDesc").getValue()
					};		
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					//Ext.getCmp("textTableName").reset();
					//Ext.getCmp("textFieldName").reset();
					Ext.getCmp("textLanguage").reset();
					Ext.getCmp("textFieldDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
						params : {
									/*rowid: "",
									tablename: "",
									fieldname: "",
									language:"",
									fielddesc:"",
									transdesc:"",*/
									start : 0,
									limit : pagesize_main
								}
						});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [/*'表名', {
							xtype : 'textfield',
							id : 'textTableName',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textTableName')
						}, '-',
						'表字段', {
							xtype : 'textfield',
							id : 'textFieldName',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textFieldName')
						}, '-',*/
						'语言', {
							xtype : 'combo',
							id : 'textLanguage',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textLanguage'),
							triggerAction : 'all',// query
							queryParam : "desc",
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							allQuery : '',
							minChars : 1,
							listWidth : 250,
							valueField : 'CTLANCode',
							displayField : 'CTLANDesc',
							store : new Ext.data.JsonStore({
								url : BindingForm,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'CTLANCode',
								fields : ['CTLANCode','CTLANDesc']
							})	
						}, '-','翻译前内容', {
							xtype : 'textfield',
							id : 'textFieldDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('textFieldDesc')
						}, '-' ,btnSearch, '-', btnRefresh,'->',btnExport
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'RowId',
							sortable : true,
							dataIndex : 'RowId',
							hidden : true
						},/* {
							header : '表名',
							sortable : true,
							dataIndex : 'TableName'
						}, {
							header : '字段',
							sortable : true,
							dataIndex : 'FieldName'
						}, */{
							header : '语言',
							sortable : true,
							dataIndex : 'Language'
						}, {
							header : '翻译前内容',
							sortable : true,
							dataIndex : 'FieldDesc'
						}, {
							header : '翻译后内容',
							sortable : true,
							dataIndex : 'TransDesc'
						}],
				stripeRows : true,
				title : '其他数据翻译管理',
				//stateful : true,
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
		
	/** grid双击事件 */
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
		       	 	//var disableFlag=CanUpdate(_record.get('PHNRowId'))
		       	 	/*Ext.getCmp("BTTableNameF").setDisabled(true);
		       	 	Ext.getCmp("BTLanguageF").setDisabled(true);
		        	Ext.getCmp("BTFieldNameF").setDisabled(true);
		        	Ext.getCmp("BTFieldDescF").setDisabled(true);*/
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('RowId'),
		                success : function(form,action) {
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            //var _record = grid.getSelectionModel().getSelected();
		            //AliasGrid.DataRefer = _record.get('PHNRowId');
			        //AliasGrid.loadGrid();
		        }
			});
	/** 布局 */
	var viewport = new Ext.Viewport({
		        id:'vp',
				layout : 'border',
				items : [grid]
			});
			
    /** 如果未开启翻译授权，则禁用此页面。 */
	var BDPTransAut =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPTranslation");
	if (BDPTransAut != "Y")
	{
		Ext.getCmp('vp').disable();
		Ext.getCmp('grid').disable();
		alert('未开启翻译功能，请在平台配置下开启，或者联系管理员。')
	}
	/** 调用keymap */
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
});
