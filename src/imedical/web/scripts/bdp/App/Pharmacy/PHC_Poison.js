 
	/// 名称:药学-5 管制药品分类维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹 
	/// 编写日期:2012-8-30
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PHC_Poison"
	});
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCPoison&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCPoison&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCPoison&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCPoison";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCPoison&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.PHCPoison";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PHC_Poison"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	//-----------------（别忘了后面的grid单击事件）翻译结束--------//
	/////////////////////////////日志查看 ////////////////////////////////////////
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
	if (btnhislogflag ==1)
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
			RowID=rows[0].get('PHCPORowId');
			Desc=rows[0].get('PHCPODesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
	Ext.QuickTips.init();												  //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	/**---------在删除按钮下实现删除功能--------------*/
	var btnDel = new Ext.Toolbar.Button({                                 //-------创建一个删除按钮 
		text : '删除',													  //-------按钮的内容
		tooltip : '删除',												  //-------工具提示或说明
		iconCls : 'icon-delete',										  //-------给一个空间用来显示图标
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {											  //指定事件处理的函数,点击删除按钮后执行后面的函数
			if (grid.selModel.hasSelection()) {                           //-------如果选中某一行则继续执行删除操作
				
				/**Ext.MessageBox.confirm------------------------------------------用来弹出一个提示框() 
				  *调用格式： confirm(String title,String msg,[function fn],[Object scope]) 
				  */
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   //-------点击确定按钮后继续执行删除操作
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示'); //-------wait框
						var gsm = grid.getSelectionModel();				  // ------获取选择列
						var rows = gsm.getSelections();					  //-------根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('PHCPORowId');
						AliasGrid.delallAlias();
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('PHCPORowId')          //-------通过RowId来删除数据
							},
							
							/**callback : Function （可选项）(Optional) 
                                       *该方法被调用时附上返回的http response对象
                                       *该函数中传入了如下参数：
                                       *options : Object  //-----------------------请求所调用的参数
                                       *success : Boolean //-----------------------请求成功则为true
                                       *response : Object //-----------------------包含了返回数据的xhr(XML Http Request)对象
                                       **/
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              //-------请求成功									
									var jsonData = Ext.util.JSON.decode(response.responseText);//------获取返回的信息
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,          //-------显示图标样式(信息图标)
											buttons : Ext.Msg.OK,         //-------只显示一个确定按钮
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);	
	
											}
										});
									} else {						     //--------如果返回的是错误的请求
										var errorMsg = '';
										if (jsonData.info) {			//---------获取传递来的错误信息
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,//--------显示图标样式(错误图标)
													buttons : Ext.Msg.OK//---------只有一个确定按钮
												});
									}
								} else {							    //---------删除失败提示错误信息
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
												icon : Ext.Msg.ERROR,    //--------显示图标样式(错误图标)
												buttons : Ext.Msg.OK     //--------只有一个确定按钮
											});
								}
							}
						}, this);
					}
				}, this);
			} else {												   
				Ext.Msg.show({										     //--------没有选择行记录的时候
							title : '提示',
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	/**---------创建一个供增加和修改使用的form-----------*/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',	                                     //--------FORM标签的id									
				//collapsible : true,
				//title : '数据信息',
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL_New,
				title:'基本信息',
				autoScroll:true,
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
                                        [{name: 'PHCPORowId',mapping:'PHCPORowId',type:'string'},
                                         {name: 'PHCPOCode',mapping:'PHCPOCode',type:'string'},
                                         {name: 'PHCPODesc',mapping:'PHCPODesc',type:'string'},
                                         {name: 'PHCPOOTCFlag',mapping:'PHCPOOTCFlag',type:'string'},
                                         {name: 'PHCPOSaleRpt',mapping:'PHCPOSaleRpt',type:'string'},
                                         {name: 'PHCPOMHRpt',mapping:'PHCPOMHRpt',type:'string'}
                                        ]),
				defaultType : 'textfield',								 //--------统一设定items类型为textfield
				items : [{
							id:'PHCPORowId',
							fieldLabel : 'PHCPORowId',
							hideLabel : 'True',
							hidden : true,                               //--------RowId属性隐藏
							name : 'PHCPORowId'
						}, {
							id:'PHCPOCodeF',
							maxLength:15,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCPOCodeF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCPOCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCPOCodeF')),
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHCPOCode',
							allowBlank: false,
							enableKeyEvents:true,                       //--------启用事件
            				validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCPoison";
	                            var classMethod = "FormValidate";                     
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCPORowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
					},{
							id:'PHCPODescF',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCPODescF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCPODescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCPODescF')),
							fieldLabel : '<font color=red>*</font>描述',
							name : 'PHCPODesc',
							allowBlank: false,
							enableKeyEvents:true,
							validationEvent : 'blur',  
						    validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCPoison";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCPORowId');
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}
						    
						},{
           				    /*xtype: 'fieldset',
                            title: '',
                            autoHeight:true,
                            defaultType: 'radio',
                            //hideLabels: true,
                            fieldLabel:"<span style='color:red;'></span>激活标识",
                            id:'CTCFActiveFlagF',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('CTCFActiveFlagF'),
                            layout:'column',
                            items: [
                                      {boxLabel: '激活', name: 'CTCFActiveFlag', inputValue: 'Y'},
                                      {boxLabel: '不激活', name: 'CTCFActiveFlag', inputValue: 'N'}
                                   ]*/
							fieldLabel: '超出计数',
							xtype : 'checkbox',
							name : 'PHCPOOTCFlag',
							id:'PHCPOOTCFlagF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCPOOTCFlagF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCPOOTCFlagF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCPOOTCFlagF')),
							inputValue : true?'Y':'N'
                        },{
							fieldLabel: '销售记录',
							xtype : 'checkbox',
							name : 'PHCPOSaleRpt',
							id:'PHCPOSaleRptF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCPOSaleRptF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCPOSaleRptF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCPOSaleRptF')),
							inputValue : true?'Y':'N'
                        },{
							fieldLabel: '部门报告',
							xtype : 'checkbox',
							name : 'PHCPOMHRpt',
							id:'PHCPOMHRptF',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCPOMHRptF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCPOMHRptF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCPOMHRptF')),
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
	/**---------增加、修改操作弹出的窗口-----------*/
	var win = new Ext.Window({
		title : '',
		width : 280,
		height : 350,
		layout : 'fit',													//----------布局会充满整个窗口，组件自动根据窗口调整大小
		plain : true,                                                   //----------true则主体背景透明
		modal : true,//在页面上放置一层遮罩,确保用户只能跟window交互
		frame : true,													//----------win具有全部阴影，若为false则只有边框有阴影
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',										   //-----------关闭窗口后执行隐藏命令
		items : tabs,											   //-----------将增加和修改的表单加入到win窗口中
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
  			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			//formBind:true,
			handler : function() {									   //-----------保存按钮下调用的函数
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					 return;
				}
				/**-------添加部分操作----------*/	 
				if (win.title == "添加") {                                         //？？？可以换个判断方式
					WinForm.form.submit({
						clientValidation : true,                       //-----------进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,						//----------发出请求的路径（保存数据）
						method : 'POST',
						
						/**下面有两种不同类型的success对象其表示的意义有所不同
						 * ①是submit的一个配置选项 表示服务器成功响应。不管你响应给客户端的内容是什么，
						 * ---------------------------------------只要响应成功就会执行这个success，跟你返回的内容无关
						 * ②是根据返回json中success属性判断的，如果success为true，则success否则 failure
						 */
						success : function(form, action) {              
							if (action.result.success == 'true') {    //如果json中success属性返回的为true
								win.hide();
								var myrowid = action.result.id;		  
								// var myrowid = jsonData.id;
								Ext.Msg.show({						  //------------做一个文本提示框
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,	  //------------图标显示（信息图标样式）
											buttons : Ext.Msg.OK,     //------------只有一个确定按钮的样式
											fn : function(btn) {      //------------回调函数参数为button的Id
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数
												grid.getStore().load({ //-----------重新载入数据         
															params : { //-----------参数
																start : 0,
																limit : pagesize,
																rowid : myrowid   //新添加的数据rowid
															}
														});
											}
										});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} 
							else {									//--------------如果jason中success属性返回的不是true
								var errorMsg = '';
								if (action.result.errorinfo) {      //--------------保存返回的错误信息
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提示',
											msg : '添加失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
							}

						},
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {
								
							Ext.Msg.alert('提示', '添加失败！');
								}
					})
				} 
				/**---------修改部分操作(操作过程与增加类似，重复代码不再注释)-------*/
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({                   //---------------确定修改后，将表单的数据提交
								clientValidation : true,            //---------------进行客户端验证
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								params : {
									'PHCPOCode' : grid.getSelectionModel().getSelections()[0].get('PHCPOCode')   ///code只读，修改时禁用的话参数传不到，要单独传。
								},
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												
											}
										});
									} else {
										var errorMsg = '';
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}

								},
								failure : function(form, action) {
								
									Ext.Msg.alert('提示', '修改失败！');
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
				Ext.getCmp("form-save").getForm().findField("PHCPOCode").focus(true,300);
				//grid.setDisabled(true);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag;
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});

	
	/**---------增加按钮-----------*/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler :AddData=function () {                              //------------在函数中调用添加窗口
					
					
					var flagcode=Ext.BDP.FunLib.Component.DisableFlag('PHCPOCodeF');
					Ext.getCmp("PHCPOCodeF").setDisabled(flagcode);
					
					
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();					    //------------添加首先要将表单重置清空一下
					
					//激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
		            
				},
				scope : this										//------------作用域
			});
	/**---------修改按钮-----------*/
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {						        //-----------显示修改的窗口和form	
					if (grid.selModel.hasSelection()) {
					
						loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('PHCPORowId');
				        AliasGrid.loadGrid();
					}
					else {
							Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						}
				}
			});
	var fields=	[{												//---------列的映射
									name : 'PHCPORowId',
									mapping : 'PHCPORowId',
									type : 'string'
								}, {
									name : 'PHCPOCode',
									mapping : 'PHCPOCode',
									type : 'string'
								}, {
									name : 'PHCPODesc',
									mapping : 'PHCPODesc',
									type : 'string'
								},{
									name:'PHCPOOTCFlag',
									mapping:'PHCPOOTCFlag',
									type:'string'
								},{
									name:'PHCPOSaleRpt',
									mapping:'PHCPOSaleRpt',
									type:'string'
								},{
									name:'PHCPOMHRpt',
									mapping:'PHCPOMHRpt',
									type:'string'
								}
						]	
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
	var ds = new Ext.data.Store({											
				proxy : new Ext.data.HttpProxy({                            //---------通过HttpProxy的方式读取原始数据
							url : ACTION_URL								//---------调用的动作
						}),
				reader : new Ext.data.JsonReader({						    //---------将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields )
				//remoteSort : true										  //----------排序
			});
	 Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
		/**-------------------加载数据-----------------*/
	ds.load({
				params : {												  //----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          //----------加载完成后执行的回调函数
					/**参数records表示获得的数据
					 * 	  options表示执行load时传递的参数 	 
					 *    success表示是否加载成功
					 */
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+
					 //records.length);
				}
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},											     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	/**---------增删改工具条-----------*/
	var tbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',btnSort,'-',btnTrans,'->',btnlog,'-',btnhislog
		]
		})
		
		
	/**---------搜索按钮-----------*/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  //-----------执行回调函数
				grid.getStore().baseParams={							//-----------模糊查询		
						code :  Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue()
									
				};
				grid.getStore().load({									//-----------加载查询出来的数据
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}

			});
			
	/**---------刷新按钮-----------*/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.BDP.FunLib.SelectRowId ="";
					Ext.getCmp("TextCode").reset();						//-----------将输入框清空
					Ext.getCmp("TextDesc").reset();                     //-----------将输入框清空
					grid.getStore().baseParams={};
					grid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

			});
			
	/**---------将工具条放在一起-----------*/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
   							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						 '-',
						'描述', {
							xtype : 'textfield',
							emptyText : '描述/别名',id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						},
						'-', Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',btnSearch, '-', btnRefresh, '->'
				],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	var GridCM= [sm, {									//----------------定义列
							header : 'PHCPO_RowId',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPORowId',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPOCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPODesc'
						}, {
							header : '超出计数',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPOOTCFlag',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '销售记录',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPOSaleRpt',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '部门报告',
							width : 100,
							sortable : true,
							dataIndex : 'PHCPOMHRpt',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon
						}]
	/**---------创建grid-----------*/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				closable : true,
				store : ds,											//----------------表格的数据集
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns :GridCM,
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				title : '管制药品分类',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHCPOForeignDesc',
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid'
			});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	

	/**---------双击事件-----------*/
	grid.on("rowdblclick", function(grid) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
			loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('PHCPORowId');
	        AliasGrid.loadGrid();
		}
    });
    		//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('PHCPORowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	// 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
        	Ext.Msg.alert('修改操作', '请选择要修改的一项');
        } else {
        	
        	Ext.getCmp("PHCPOCodeF").setDisabled(true)  ///代码不可修改
			        	
			        	
        	win.setTitle('修改');
        	win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&PHCPORowId='+ _record.get('PHCPORowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑', '载入成功');
                },
                failure : function(form,action) {
                	alert(action);
                    //Ext.example.msg('编辑', '载入失败');
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
        }
    };
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	/**---------创建viewport-----------*/
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	
    
    
});
