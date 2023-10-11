 
 	/// 名称:药学-8 药品用法维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹 
	/// 编写日期:2016-8-26
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {	
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PHC_Instruc"
	});
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCInstruc";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_main=Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop=Ext.BDP.FunLib.PageSize.Pop;	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.PHCInstruc";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PHC_Instruc"
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
			RowID=rows[0].get('PHCINRowId');
			Desc=rows[0].get('PHCINDesc1');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});

	/////////////////////////////接收科室日志查看 ////////////////////////////////////////
	var btnlog_loc=Ext.BDP.FunLib.GetLogBtn("User.DHCPHCInstrRecLoc");
	var btnhislog_loc=Ext.BDP.FunLib.GetHisLogBtn("User.DHCPHCInstrRecLoc")  
   
	///日志查看按钮是否显示
	var btnlogflag_loc=Ext.BDP.FunLib.ShowBtnOrNotFun();
	if (btnlogflag_loc==1)
	{
		btnlog_loc.hidden=false;
	}
    else
    {
       btnlog_loc.hidden=true;
    }
	/// 数据生命周期按钮 是否显示
	var btnhislogflag_loc= Ext.BDP.FunLib.ShowLifeBtnOrNotFun();
	if (btnhislogflag_loc ==1)
	{
		btnhislog_loc.hidden=false;
	}
    else
    {
		btnhislog_loc.hidden=true;
	}  
	btnhislog_loc.on('click', function(btn,e){    
		var RowID="",Desc="",ParentDesc="";
		if (child_grid_loc.selModel.hasSelection()) {
			var rows = child_grid_loc.getSelectionModel().getSelections(); 
			RowID=rows[0].get('RowID');
			Desc=rows[0].get('InstrOrdSubCatDesc')+"^"+rows[0].get('InstrOrdDepDesc')+"^"+rows[0].get('InstrRecLocDesc');			
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
						AliasGrid.DataRefer = rows[0].get('PHCINRowId');
						AliasGrid.delallAlias();
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('PHCINRowId')          //-------通过RowId来删除数据
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
				title:'基本信息',
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
                                        [{name: 'PHCINRowId',mapping:'PHCINRowId',type:'string'},
                                         {name: 'PHCINCode',mapping:'PHCINCode',type:'string'},
                                         {name: 'PHCINActiveFlag',mapping:'PHCINActiveFlag',type:'string'},
                                         {name: 'PHCINClinicTypeO',mapping:'PHCINClinicTypeO',type:'string'},
                                         {name: 'PHCINClinicTypeE',mapping:'PHCINClinicTypeE',type:'string'},
                                         {name: 'PHCINClinicTypeI',mapping:'PHCINClinicTypeI',type:'string'},
                                         {name: 'PHCINClinicTypeH',mapping:'PHCINClinicTypeH',type:'string'},
                                         {name: 'PHCINClinicTypeN',mapping:'PHCINClinicTypeN',type:'string'},
                                         {name: 'PHCINDesc1',mapping:'PHCINDesc1',type:'string'},
                                         {name: 'PHCINDesc2',mapping:'PHCINDesc2',type:'string'}
                                        ]),
				defaultType : 'textfield',								 //--------统一设定items类型为textfield
				items : [{
							id:'PHCINRowId',
							fieldLabel : 'PHCINRowId',
							hideLabel : 'True',
							hidden : true,                               //--------RowId属性隐藏
							name : 'PHCINRowId'
						}, {
							id:'PHCINCodeF',
							maxLength:15,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCINCodeF'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCINCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCINCodeF')),
							fieldLabel : '<font color=red>*</font>代码',
							name : 'PHCINCode',
							allowBlank: false,
            				enableKeyEvents:true, 
 							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCInstruc";
	                            var classMethod = "FormValidate";                     
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCINRowId');
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
					}, {
							id:'PHCINDesc1F',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc1F'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc1F'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc1F')),
							fieldLabel : '<font color=red>*</font>中文描述',
							name : 'PHCINDesc1',
							allowBlank: false,
							enableKeyEvents:true, 
						    validationEvent : 'blur',  
						    validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCInstruc";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCINRowId');
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
							id:'PHCINDesc2F',
							maxLength:220,
							allowBlank: false,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc2F'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc2F'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCINDesc2F')),
							fieldLabel : '<font color=red>*</font>英文描述',
							name : 'PHCINDesc2'
						}, {
							fieldLabel: '是否激活',
							xtype : 'checkbox',
							name : 'PHCINActiveFlag',
							id:'PHCINActiveFlag',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCINActiveFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCINActiveFlag')),
							inputValue : 'Y',
							checked:true
						}, {
							xtype:'fieldset',
				            title: '就诊类型' , 
				            style: 'margin-left:17px;',
		           			bodyStyle: 'margin-left:-28px;',
				            items: [{
				            		xtype : 'checkboxgroup',   ////// 控制哪些类型可开这个用法，值为空则都可以开    O,E,I,H,N   (门诊,急诊,住院,体检,新生儿)
								    id:'PHCINClinicTypeF',
								    readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCINClinicTypeF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCINClinicTypeF')),
								    columns: 1,
								    items: [
								        {boxLabel: '门诊', name: 'PHCINClinicTypeO',id: 'PHCINClinicTypeO', inputValue : 'O',checked:true},
								        {boxLabel: '急诊', name: 'PHCINClinicTypeE',id: 'PHCINClinicTypeE', inputValue : 'E',checked:true},
								        {boxLabel: '住院', name: 'PHCINClinicTypeI',id: 'PHCINClinicTypeI', inputValue : 'I',checked:true},
								        {boxLabel: '体检', name: 'PHCINClinicTypeH',id: 'PHCINClinicTypeH', inputValue : 'H',checked:true},
								        {boxLabel: '新生儿', name: 'PHCINClinicTypeN',id: 'PHCINClinicTypeN', inputValue : 'N',checked:true}
								    ]
				            }]
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
		width : 350,
		minWidth:290,
		height : 440,
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
												var startIndex = grid 
													   .getBottomToolbar().cursor;//获取当前页开始的记录数
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
								/*switch (action.failureType) {
								    case Ext.form.Action.CLIENT_INVALID:
									       Ext.Msg.alert('Failure', '客户端的表单验证出现错误！');
									break;
									case Ext.form.Action.CONNECT_FAILURE:
									       Ext.Msg.alert('Failure', '远程服务器发送请求遇到通信错误！');
									break;
									case Ext.form.Action.SERVER_INVALID:
										Ext.Msg.alert('Failure', '服务器端数据验证失败！');
								 }*/
								 
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
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}

								},
								failure : function(form, action) {
								/*switch (action.failureType) {
								    case Ext.form.Action.CLIENT_INVALID:
									       Ext.Msg.alert('Failure', '客户端的表单验证出现错误');
									break;
									case Ext.form.Action.CONNECT_FAILURE:
									       Ext.Msg.alert('Failure', '远程服务器发送请求遇到通信错误');
									break;
									case Ext.form.Action.SERVER_INVALID:
										Ext.Msg.alert('Failure', '服务器端数据验证失败');
								 }*/
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
				Ext.getCmp("form-save").getForm().findField("PHCINCode").focus(true,300);
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

	
	///用法与用量关联
	
	var Dosage_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCDosage&pClassQuery=GetDataForCmb1";
	var Instruc_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstruc&pClassQuery=GetDataForCmb1";
	var CHILD_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDosage&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDosage&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCInstrucLinkDosage';
	var CHILD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDosage&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDosage&pClassMethod=DeleteData';
			
		//用法与用量关联删除按钮  
	var child_btnDel_dos = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn'),
		handler : DelData_dos=function() {
			if (child_grid_dos.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid_dos.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ILDRowId')
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
												var startIndex = child_grid_dos.getBottomToolbar().cursor;
												var totalnum=child_grid_dos.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
												{
													var pagenum=child_grid_dos.getStore().getCount();
													if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
												}
												child_grid_dos.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize_pop
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
		
	///用法用量关联增加\修改的Form 
	var child_WinForm = new Ext.form.FormPanel({
				id : 'child-form-save',
				labelAlign : 'right',
				labelWidth : 70,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ILDRowId',mapping:'ILDRowId',type:'string'},
                                         {name: 'ILDInstrucDR',mapping:'ILDInstrucDR',type:'string'},
                                         {name: 'ILDDosageDR',mapping:'ILDDosageDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [
						{
							fieldLabel : 'ILDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ILDRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '用法',
							name : 'ILDInstrucDR',
							hiddenName : 'ILDInstrucDR',
							id:'ILDInstrucDRF',
   							readOnly : true,
   							style:Ext.BDP.FunLib.ReadonlyStyle(true),
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Instruc_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'PHCINRowId', 'PHCINDesc1' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'PHCINRowId',
							displayField : 'PHCINDesc1',
							allowBlank : false
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>用量',
							name : 'ILDDosageDR',
							id:'ILDDosageDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ILDDosageDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ILDDosageDRF')),
							hiddenName : 'ILDDosageDR',
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Dosage_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'PHCDORowId', 'PHCDODesc1' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'PHCDORowId',
							displayField : 'PHCDODesc1',
							allowBlank : false
					
						}]
			});
		/// 用量增加\修改窗口 
	var child_win = new Ext.Window({
		title : '',
		width : 350,
		height:240,
		layout : 'fit',
		//plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		//constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
			handler : function() {
				
   			 	if(child_WinForm.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					return;
   			 	}
				if (child_win.title == '添加') {
					child_WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : CHILD_SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								child_win.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												child_grid_dos.getStore().load({
															params : {
																start : 0,
																limit : pagesize_pop
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
							child_WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										child_win.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_dos", CHILD_QUERY_ACTION_URL, myrowid)
												
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
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win.hide();
			}
		}],
		listeners : {
			'show' : function() {
				Ext.getCmp("child-form-save").getForm().findField("ILDDosageDR").focus(true,800);
				
			},
			'hide' : function() {
				
			},
			'close' : function() {
			}
		}
	});
	
	/// 用法用量关联store 
	var child_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ILDRowId',
									mapping : 'ILDRowId',
									type : 'string'
								}, {
									name : 'ILDInstrucDR',
									mapping : 'ILDInstrucDR',
									type : 'string'
								}, {
									name : 'ILDDosageDR',
									mapping : 'ILDDosageDR',
									type : 'string'
								
								}// 列的映射
						])
			});
	///用法用量关联维护工具条 
	var child_tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn'),
								handler : AddData_dos=function () {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var PHCINRowId = rows[0].get('PHCINRowId')
									child_win.setTitle('添加');
									child_win.setIconClass('icon-add');
									child_win.show('new1');
									child_WinForm.getForm().reset();
									child_WinForm.getForm().findField('ILDInstrucDR').setValue(PHCINRowId);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn'),
									handler :  UpdateData_dos=function() {
										var _record = child_grid_dos.getSelectionModel().getSelected();
										if (!_record) {
								            Ext.Msg.show({
												title : '提示',
												msg : '请选择需要修改的行!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
								        } else {
								            child_win.setTitle('修改');
											child_win.setIconClass('icon-update');
											child_win.show('');
											Ext.getCmp("child-form-save").getForm().reset();
								            Ext.getCmp("child-form-save").getForm().load({
								                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('ILDRowId'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                    //Ext.Msg.alert(action);
								                	//Ext.Msg.alert('编辑', '载入成功');
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel_dos]
		});
	////用法与用量关联child_grid 
	var child_grid_dos = new Ext.grid.GridPanel({
				id : 'child_grid_dos',
				region : 'center',
				closable : true,
				store : child_ds,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'ILDRowId',
							sortable : true,
							dataIndex : 'ILDRowId',
							hidden : true
						}, {
							header : '用法',
							sortable : true,
							dataIndex : 'ILDInstrucDR',
							width : 160,
							hidden : true
						}, {
							header : '用量',
							sortable : true,
							dataIndex : 'ILDDosageDR',
							width : 160
						
						}],
				title : '用法与用量关联',
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : [ '用量', {
										xtype : 'textfield',
										id : 'TextDesc_dosage',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc_dosage')
									}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch'),
													handler : function() {
																child_grid_dos.getStore().baseParams={
																	dosagedesc:Ext.getCmp("TextDesc_dosage").getValue(),
																	instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	};
																child_grid_dos.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh'),
														handler : function() {
															Ext.getCmp("TextDesc_dosage").reset();
															child_grid_dos.getStore().baseParams={
																instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	
															};
															
															child_grid_dos.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton.render(child_grid_dos.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid_dos,"User.PHCInstrucLinkDosage");
	///child_grid双击事件 
	child_grid_dos.on('rowdblclick', function(child_grid_dos) {
				var _record = child_grid_dos.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            child_win.setTitle('修改');
					child_win.setIconClass('icon-update');
					child_win.show('');
					Ext.getCmp("child-form-save").getForm().reset();
		            Ext.getCmp("child-form-save").getForm().load({
		                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('ILDRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			})
	/// 用法与用量关联窗口 
	var child_list_win = new Ext.Window({
					iconCls : 'icon-DP',
					width : 760,  //Ext.getBody().getWidth()*0.8,
					height : 500,//Ext.getBody().getHeight()*.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [child_grid_dos],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_dos = Ext.BDP.FunLib.Component.KeyMap(AddData_dos,UpdateData_dos,DelData_dos);
						    
							
													
						},
						"hide" : function(){
							keymap_dos.disable();
						    keymap_main.enable();
						    
						},
						"close" : function(){
						}
					}
				});
	///用法与用量关联 
	var btnDosage = new Ext.Toolbar.Button({
				text : '关联用量',
				tooltip : '关联用量',
				iconCls : 'icon-DP',
				id:'btnDosage',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDosage'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						child_ds.baseParams={
							instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
						};
						child_ds.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win.setTitle(rows[0].get('PHCINDesc1')+'---与用量关联');
						child_list_win.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条药品用法!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	
	////用法与用量关联 完
	
	
	
	///用法与频次关联
	var Freq_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCFreq&pClassQuery=GetDataForCmb1";
	var CHILD_QUERY_ACTION_URL_freq = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkFreq&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_freq = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkFreq&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCInstrucLinkFreq';
	var CHILD_OPEN_ACTION_URL_freq = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkFreq&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL_freq = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkFreq&pClassMethod=DeleteData';
			
	///用法与频次关联删除按钮  
	var child_btnDel_freq = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn_freq',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn_freq'),
		handler : DelData_freq=function () {
			if (child_grid_freq.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid_freq.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL_freq,
							method : 'POST',
							params : {
								'id' : rows[0].get('ILFRowId')
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
												var startIndex = child_grid_freq.getBottomToolbar().cursor;
												var totalnum=child_grid_freq.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
												{
													var pagenum=child_grid_freq.getStore().getCount();
													if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
												}
												child_grid_freq.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize_pop
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
		
	/// 用法与频次关联增加\修改的Form 
	var child_WinForm_freq = new Ext.form.FormPanel({
				id : 'child-form-save_freq',
				labelAlign : 'right',
				labelWidth : 70,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ILFRowId',mapping:'ILFRowId',type:'string'},
                                         {name: 'ILFInstrucDR',mapping:'ILFInstrucDR',type:'string'},
                                         {name: 'ILFFreqDR',mapping:'ILFFreqDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [
						{
							fieldLabel : 'ILFRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ILFRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '用法',
							name : 'ILFInstrucDR',
							hiddenName : 'ILFInstrucDR',
							id:'ILFInstrucDRF',
   							readOnly : true,
   							style:Ext.BDP.FunLib.ReadonlyStyle(true),
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Instruc_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'PHCINRowId', 'PHCINDesc1' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'PHCINRowId',
							displayField : 'PHCINDesc1',
							allowBlank : false
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>频次',
							name : 'ILFFreqDR',
							id:'ILFFreqDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ILFFreqDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ILFFreqDRF')),
							hiddenName : 'ILFFreqDR',
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Freq_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'PHCFRRowId', 'PHCFRDesc1' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'PHCFRRowId',
							displayField : 'PHCFRDesc1',
							allowBlank : false
					
						}]
			});
		////用法与频次关联增加\修改窗口 
	var child_win_freq = new Ext.Window({
		title : '',
		width : 350,
		height:240,
		layout : 'fit',
		//plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		//constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm_freq,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn_freq',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn_freq'),
			handler : function() {
				
   			 	if(child_WinForm_freq.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					return;
   			 	}
				if (child_win_freq.title == '添加') {
					child_WinForm_freq.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : CHILD_SAVE_ACTION_URL_freq,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								child_win_freq.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												child_grid_freq.getStore().load({
															params : {
																start : 0,
																limit : pagesize_pop
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
							child_WinForm_freq.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL_freq,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										child_win_freq.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_freq", CHILD_QUERY_ACTION_URL_freq, myrowid)
												
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
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win_freq.hide();
			}
		}],
		listeners : {
			'show' : function() {
				Ext.getCmp("child-form-save_freq").getForm().findField("ILFFreqDR").focus(true,800);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
	
	///用法与频次关联store 
	var child_ds_freq = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL_freq }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ILFRowId',
									mapping : 'ILFRowId',
									type : 'string'
								}, {
									name : 'ILFInstrucDR',
									mapping : 'ILFInstrucDR',
									type : 'string'
								}, {
									name : 'ILFFreqDR',
									mapping : 'ILFFreqDR',
									type : 'string'
								
								}// 列的映射
						])
			});
	///  用法与频次关联维护工具条 
	var child_tbbutton_freq = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn_freq',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_freq'),
								handler : AddData_freq=function () {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var PHCINRowId = rows[0].get('PHCINRowId')
									child_win_freq.setTitle('添加');
									child_win_freq.setIconClass('icon-add');
									child_win_freq.show('');
									child_WinForm_freq.getForm().reset();
									child_WinForm_freq.getForm().findField('ILFInstrucDR').setValue(PHCINRowId);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn_freq',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_freq'),
									handler : UpdateData_freq=function () {
											if (!child_grid_freq.selModel.hasSelection()) {
									            Ext.Msg.show({
														title : '提示',
														msg : '请选择需要修改的行!',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
									        } else {
									        var _record = child_grid_freq.getSelectionModel().getSelected();
								            child_win_freq.setTitle('修改');
											child_win_freq.setIconClass('icon-update');
											child_win_freq.show('');
											Ext.getCmp("child-form-save_freq").getForm().reset();
								            Ext.getCmp("child-form-save_freq").getForm().load({
								                url : CHILD_OPEN_ACTION_URL_freq + '&id=' + _record.get('ILFRowId'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                    //Ext.Msg.alert(action);
								                	//Ext.Msg.alert('编辑', '载入成功');
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel_freq]
		});
	//用法与频次关联child_grid_freq 
	var child_grid_freq = new Ext.grid.GridPanel({
				id : 'child_grid_freq',
				region : 'center',
				closable : true,
				store : child_ds_freq,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'ILFRowId',
							sortable : true,
							dataIndex : 'ILFRowId',
							hidden : true
						}, {
							header : '用法',
							sortable : true,
							dataIndex : 'ILFInstrucDR',
							width : 160,
							hidden : true
						}, {
							header : '频次',
							sortable : true,
							dataIndex : 'ILFFreqDR',
							width : 160
						
						}],
				title : '用法与频次关联',
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds_freq,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : [ '频次', {
										xtype : 'textfield',
										id : 'TextDesc_freq',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc_freq')
									}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch_freq',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch_freq'),
													handler : function() {
																child_grid_freq.getStore().baseParams={
																	freqdesc:Ext.getCmp("TextDesc_freq").getValue(),
																	instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	};
																child_grid_freq.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh_freq',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh_freq'),
														handler : function() {
															Ext.getCmp("TextDesc_freq").reset();
															child_grid_freq.getStore().baseParams={
																instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	
															};
															
															child_grid_freq.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton_freq.render(child_grid_freq.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid_freq,"User.PHCInstrucLinkFreq");
	///child_grid_freq双击事件 
	child_grid_freq.on('rowdblclick', function(child_grid_freq) {
				if (!child_grid_freq.selModel.hasSelection()) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		        	var _record = child_grid_freq.getSelectionModel().getSelected();
		            child_win_freq.setTitle('修改');
					child_win_freq.setIconClass('icon-update');
					child_win_freq.show('');
					Ext.getCmp("child-form-save_freq").getForm().reset();
		            Ext.getCmp("child-form-save_freq").getForm().load({
		                url : CHILD_OPEN_ACTION_URL_freq + '&id=' + _record.get('ILFRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	/// 用法与频次关联窗口 	
	var child_list_win_freq = new Ext.Window({
					iconCls : 'icon-DP',
					width : 760, //Ext.getBody().getWidth()*0.8,
					height : 500,//Ext.getBody().getHeight()*.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [child_grid_freq],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_freq = Ext.BDP.FunLib.Component.KeyMap(AddData_freq,UpdateData_freq,DelData_freq);
						    	
						    						
						},
						"hide" : function(){
							keymap_freq.disable();
						    keymap_main.enable();
						    
						},
						"close" : function(){
						}
					}
				});
	//用法与频次关联
	var btnFreq = new Ext.Toolbar.Button({
				text : '关联频次',
				tooltip : '关联频次',
				iconCls : 'icon-DP',
				id:'btnFreq',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnFreq'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						child_ds_freq.baseParams={
							instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
						};
						child_ds_freq.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win_freq.setTitle(rows[0].get('PHCINDesc1')+'---与频次关联');
						child_list_win_freq.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条药品用法!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	
	//用法与频次关联 完
	
	/*********************************接收科室开始*********************************************/
	var ARCITEM_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";	
	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
	
	var HOSP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var Priority_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
	var RECTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCPHCInstrRecLoc&pClassQuery=GetList";
	var RECTLOC_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCPHCInstrRecLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCPHCInstrRecLoc';
	var RECTLOC_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPHCInstrRecLoc&pClassMethod=OpenData";
	var RECTLOC_DELETE_ACTION_URL = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCPHCInstrRecLoc&pClassMethod=DeleteData';
	
	//多院区医院下拉框
	var hospComp=GenHospComp("ARC_ItemCat");	
	//医院下拉框选择一条医院记录后执行此函数	
	hospComp.on('select',function (){
		
	 	if (grid.selModel.hasSelection()) { 
	 		child_grid_loc.enable();
	 		var gsm = grid.getSelectionModel();// 获取选择列
			var rows = gsm.getSelections();// 根据选择列获取到所有的行
			Ext.getCmp('RecLocText').setValue('')
			Ext.getCmp('OrdLocText').setValue('')
			Ext.getCmp('ItemCateText').setValue('')
			
			child_grid_loc.getStore().baseParams={
				hospid:  hospComp.getValue(),
				ParRef : rows[0].get('PHCINRowId')
		 	};
		 	
			child_grid_loc.getStore().load({
						params : {
							start : 0,
							limit : pagesize_pop
							
						}
					});
	 	}
		
	});
	/** 接收科室删除按钮  */
	var child_btnDel_loc = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除',
		iconCls : 'icon-delete',
		id:'sub_del_btn_loc',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn_loc'),
		handler :DelData_Loc= function () {
			if (child_grid_loc.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid_loc.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						for(var i=0;i<rows.length;i++){
							Ext.Ajax.request({
								url : RECTLOC_DELETE_ACTION_URL,
								method : 'POST',
								params : {
									'id' : rows[i].get('RowID')
								},
								callback : function(options, success, response) {
									if (success) {
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (jsonData.success == 'true') {
											
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
											return;
										}
									} else {
										Ext.Msg.show({
													title : '提示',
													msg : '异步通讯失败,请检查网络连接!',
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										return;
									}
								}
							}, this);
						}
						
						Ext.Msg.show({
								title : '提示',
								msg : '数据删除成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.BDP.FunLib.DelForTruePage(child_grid_loc,pagesize_pop);	
								}
							});
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

	/** 接收科室增加\修改的Form */
	var child_WinForm_loc = new Ext.form.FormPanel({
				id : 'child-form-save_loc',
				labelAlign : 'right',
				labelWidth : 90,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'RowID',mapping:'RowID',type:'string'},
                                         {name: 'InstrRecLocParRef',mapping:'InstrRecLocParRef',type:'string'},
                                         {name: 'InstrOrdSubCat',mapping:'InstrOrdSubCat',type:'string'},
                                         {name: 'InstrOrdDep',mapping:'InstrOrdDep',type:'string'},
                                         {name: 'InstrRecLoc',mapping:'InstrRecLoc',type:'string'},
                                         {name: 'InstrDefault',mapping:'InstrDefault',type:'string'},
                                         {name: 'InstrTimeFrom',mapping:'InstrTimeFrom',type:'string'},
                                         {name: 'InstrTimeTo',mapping:'InstrTimeTo',type:'string'},
                                         {name: 'InstrTimeRange',mapping:'InstrTimeRange',type:'string'},
                                         {name: 'InstrHospitalDR',mapping:'InstrHospitalDR',type:'string'},
                                         {name: 'InstrOrdPrior',mapping:'InstrOrdPrior',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'InstrRecLocParRef',
							hideLabel : 'True',
							hidden : true,
							readOnly : true,
							name : 'InstrRecLocParRef'
						},{
							fieldLabel : 'RowID',
							hideLabel : 'True',
							hidden : true,
							name : 'RowID'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,

							fieldLabel : '医嘱子类',
							name : 'InstrOrdSubCat',
							id:'InstrOrdSubCatF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrOrdSubCatF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrOrdSubCatF')),
							hiddenName : 'InstrOrdSubCat',
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : ARCITEM_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ARCICRowId', 'ARCICDesc' ])
							}),
							queryParam : 'desc',
							//triggerAction : 'all',  设置页码要注释此行
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'ARCICRowId',
							displayField : 'ARCICDesc',
					        listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
				  				
								 	}
							}
							
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '病人科室',
							name : 'InstrOrdDep',
							id:'InstrOrdDepF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrOrdDepF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrOrdDepF')),
							hiddenName : 'InstrOrdDep',
							mode : 'remote',
							store : new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							//triggerAction : 'all',  设置页码要注释此行
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							listeners:{
								   'beforequery': function(e){
										this.store.baseParams = {
												desc:e.query,
												tablename:'ARC_ItemCat',  //先按照医嘱子分类的私有属性来
												hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
									
								 	}
							}
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>接收科室',
							name : 'InstrRecLoc',
							hiddenName : 'InstrRecLoc',
							id:'InstrRecLocF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrRecLocF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrRecLocF')),
							mode : 'remote',
							store : new Ext.data.Store({
								///autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'CTLOCRowID', 'CTLOCDesc' ])
							}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc',
							allowBlank : false
						}, {
							xtype : 'checkbox',
							fieldLabel : '默认',
							name : 'InstrDefault',
							id:'InstrDefaultF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrDefaultF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrDefaultF')),
							inputValue : '1'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '医院',
							name : 'InstrHospitalDR',
							id:'InstrHospitalDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrHospitalDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrHospitalDRF')),
							hiddenName : 'InstrHospitalDR',
							store : new Ext.data.Store({
											//autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : HOSP_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'HOSPRowId', 'HOSPDesc' ])
										}),
							queryParam : 'desc',
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'HOSPRowId',
							displayField : 'HOSPDesc'
						}, {
							xtype : 'timefield',
							fieldLabel : '开始时间',
							name : 'InstrTimeFrom',
							id:'InstrTimeFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrTimeFromF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrTimeFromF')),
							format : 'H:i:s',
							increment: 15
						}, {
							xtype : 'timefield',
							fieldLabel : '结束时间',
							name : 'InstrTimeTo',
							id:'InstrTimeToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrTimeToF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrTimeToF')),
							format : 'H:i:s',
							increment: 15
						},{
							fieldLabel : 'InstrTimeRange',
							hideLabel : 'True',
							hidden : true,
							name : 'InstrTimeRange'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							
							fieldLabel : '医嘱类型',
							name : 'InstrOrdPrior',
							id:'InstrOrdPriorF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('InstrOrdPriorF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('InstrOrdPriorF')),
							hiddenName : 'InstrOrdPrior',
							
							store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : Priority_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'OECPRRowId', 'OECPRDesc' ])
										}),
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'OECPRRowId',
							displayField : 'OECPRDesc'
						}]
			});
 	/** 接收科室增加\修改窗口 */
	var child_win_loc = new Ext.Window({
		title : '',
		width : 400,
		height:470,
		layout : 'fit',
		//plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		//constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm_loc,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn_loc',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn_loc'),
			handler : function() {					
				var InstrRecLoc = Ext.getCmp("child-form-save_loc").getForm().findField("InstrRecLocF").getValue();				
				if (InstrRecLoc=="")
				{
					Ext.Msg.show({
        					title : '提示',
							msg : '接收科室不可为空!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
				}

				var InstrTimeFrom = Ext.getCmp("child-form-save_loc").getForm().findField("InstrTimeFrom").getValue();				
    			var InstrTimeTo = Ext.getCmp("child-form-save_loc").getForm().findField("InstrTimeTo").getValue();
				child_WinForm_loc.getForm().findField('InstrTimeRange').setValue(InstrTimeFrom+"~"+InstrTimeTo);
				//Ext.getCmp("child-form-save").getForm().findField("InstrTimeRange").setValue(InstrTimeFrom+"~"+InstrTimeTo);	
   			 	if (((InstrTimeFrom=="")&&(InstrTimeTo != ""))||((InstrTimeFrom!="")&&(InstrTimeTo== ""))) 
   			 	{
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始时间和结束时间需同时填写!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      			
   			 	}
   			 	
   			 	if ((InstrTimeFrom!="")&&(InstrTimeTo != "")) {
   			 		
   			 		if (InstrTimeFrom>=InstrTimeTo) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '结束时间必须大于开始时间!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
   			 	}
   			 	if(child_WinForm_loc.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
   			 		return;
   			 	
   			 	}
   			 	
   			 	var WarningMsg="";
   			 	var InstrDefaultF = Ext.getCmp("InstrDefaultF").getValue();  ///true false
   			 	if(InstrDefaultF==true)
   			 	{
   			 		var parref = grid.getSelectionModel().getSelected().get('PHCINRowId');	 
   			 		var rowid = Ext.getCmp("child-form-save_loc").getForm().findField("RowID").getValue();
   			 		var arcitemcat = Ext.getCmp("child-form-save_loc").getForm().findField("InstrOrdSubCat").getValue();
   			 		var ordlocdr = Ext.getCmp("child-form-save_loc").getForm().findField("InstrOrdDep").getValue();
   			 		var timerange=Ext.getCmp("InstrTimeFromF").getValue()+"~"+Ext.getCmp("InstrTimeToF").getValue()
   			 		var str=Ext.getCmp("InstrOrdPriorF").getValue()+"^"+timerange+"^"+Ext.getCmp("InstrHospitalDRF").getValue()
   			 		var flag=tkMakeServerCall("web.DHCBL.CT.DHCPHCInstrRecLoc","GetDefRecLoc",parref,rowid,ordlocdr,arcitemcat,str);
   			 		if (flag==1)
   			 		{
   			 			WarningMsg='已经存在默认接收科室，此次保存会把其他的默认记录改成不默认,'
   			 		}
   			 	
   			 	}
   			 Ext.MessageBox.confirm('提示', WarningMsg+'确定要保存该条数据吗?', function(btn) {
						if (btn == 'yes') {
   			 	
				if (child_win_loc.title == '添加') {
					child_WinForm_loc.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : RECTLOC_SAVE_ACTION_URL,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								child_win_loc.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												child_grid_loc.getStore().load({
															params : {
																start : 0,
																limit : 1,
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
					
							child_WinForm_loc.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : RECTLOC_SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										child_win_loc.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_loc", RECTLOC_QUERY_ACTION_URL, myrowid)
												
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
						
					// WinForm.getForm().reset();
				}
				
				
				}
					}, this);
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win_loc.hide();
			}
		}],
		listeners : {
			'show' : function() {
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
 	/** 接收科室store */
	var child_ds_loc = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : RECTLOC_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RowID',
									mapping : 'RowID',
									type : 'string'
								}, {
									name : 'InstrOrdSubCatDesc',
									mapping : 'InstrOrdSubCatDesc',
									type : 'string'
								}, {
									name : 'InstrOrdDepDesc',
									mapping : 'InstrOrdDepDesc',
									type : 'string'
								}, {
									name : 'InstrRecLocDesc',
									mapping : 'InstrRecLocDesc',
									type : 'string'
								}, {
									name : 'InstrDefault',
									mapping : 'InstrDefault',
									type : 'string'
								}, {
									name : 'InstrTimeFrom',
									mapping : 'InstrTimeFrom',
									type : 'string'
								}, {
									name : 'InstrTimeTo',
									mapping : 'InstrTimeTo',
									type : 'string'
								}, {
									name : 'InstrHospitalDesc',
									mapping : 'InstrHospitalDesc',
									type : 'string'
								}, {
									name : 'InstrOrdPriorDesc',
									mapping : 'InstrOrdPriorDesc',
									type : 'string'
								}// 列的映射
						])
			});
	/** 加载前设置参数 */
	child_ds_loc.on('beforeload',function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(child_ds_loc.lastOptions.params, {
				    	ParRef : rows[0].get('PHCINRowId')
				    });
			},this);
	/** 接收科室维护工具条 */
	var child_tbbutton_loc = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据',
								iconCls : 'icon-add',
								id:'sub_addbtn_loc',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_loc'),
								handler : AddData_Loc=function() {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var ParRef = rows[0].get('PHCINRowId')
									child_win_loc.setTitle('添加');
									child_win_loc.setIconClass('icon-add');
									child_win_loc.show('new1');
									child_WinForm_loc.getForm().reset();
									child_WinForm_loc.getForm().findField('InstrRecLocParRef').setValue(ParRef);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改',
									iconCls : 'icon-update',
									id:'sub_updatebtn_loc',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_loc'),
									handler : UpdateData_Loc=function() {
										var _record = child_grid_loc.getSelectionModel().getSelected();
										if (!_record) {
								            Ext.Msg.show({
												title : '提示',
												msg : '请选择需要修改的行!',
												icon : Ext.Msg.WARNING,
												buttons : Ext.Msg.OK
											});
								        } else {
								            child_win_loc.setTitle('修改');
											child_win_loc.setIconClass('icon-update');
											child_win_loc.show('');
											Ext.getCmp("child-form-save_loc").getForm().load({
								                url : RECTLOC_OPEN_ACTION_URL + '&id=' + _record.get('RowID'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                	var data=action.result.data
								                	var InstrTimeRange=data.InstrTimeRange
								                	var time=InstrTimeRange.split("~")
								                	child_WinForm_loc.getForm().findField('InstrTimeFromF').setValue(time[0]);
								                	child_WinForm_loc.getForm().findField('InstrTimeToF').setValue(time[1]);
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel_loc,'->',btnlog_loc,'-',btnhislog_loc]
		});
		
	///可以多选
	var childsm_loc = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false,
				checkOnly : false,
				width : 20
	});
	
	/** 接收科室child_grid_loc */
	var child_grid_loc = new Ext.grid.GridPanel({
				id : 'child_grid_loc',
				region : 'center',
				closable : true,
				store : child_ds_loc,
				trackMouseOver : true,
				sm : childsm_loc, // 按"Ctrl+鼠标左键"也只能单选
				columns : [childsm_loc, //单选列
						{
							header : 'RowID',
							sortable : true,
							dataIndex : 'RowID',
							width : 90,
							hidden : true
						}, {
							header : '医嘱子类',
							sortable : true,
							dataIndex : 'InstrOrdSubCatDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 100
						},{
							header : '病人科室',
							sortable : true,
							dataIndex : 'InstrOrdDepDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 200
						}, {
							header : '接收科室',
							sortable : true,
							dataIndex : 'InstrRecLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 200
						}, {
							header : '默认',
							sortable : true,
							width : 70,
							dataIndex : 'InstrDefault',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '医院',
							sortable : true,
							width : 200,
							dataIndex : 'InstrHospitalDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						},  {
							header : '开始时间',
							sortable : true,
							width : 100,
							dataIndex : 'InstrTimeFrom'
						}, {
							header : '结束时间',
							sortable : true,
							width : 100,
							dataIndex : 'InstrTimeTo'
						}, {
							header : '医嘱类型',
							sortable : true,
							width : 90,
							dataIndex : 'InstrOrdPriorDesc'
						}],
				title : '用法 接收科室',
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds_loc,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : [ '医嘱子类',{
						  				xtype : 'bdpcombo',
						  				id : 'ItemCateText',
						  				disabled : Ext.BDP.FunLib.Component.DisableFlag('ItemCateText'),
						  				mode : 'remote',
						  				pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store :  new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : ARCITEM_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'ARCICRowId', 'ARCICDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'ARCICRowId',
										displayField : 'ARCICDesc',
								        listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
															desc:e.query,
															hospid:hospComp.getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
							  				
											 	}
										}
						  			}, '-','病人科室',{
						  				xtype : 'bdpcombo',
						  				id : 'OrdLocText',
						  				disabled : Ext.BDP.FunLib.Component.DisableFlag('OrdLocText'),
						  				mode : 'local',
						  				pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc',
										listeners:{
											   'beforequery': function(e){
													this.store.baseParams = {
															desc:e.query,
															tablename:'ARC_ItemCat',  //先按照医嘱子分类的私有属性来
															hospid:hospComp.getValue()
													};
													this.store.load({params : {
																start : 0,
																limit : Ext.BDP.FunLib.PageSize.Combo
													}})
												
											 	}
										}
						  			}, '-',
									'接收科室',{
										xtype : 'bdpcombo',
										id : 'RecLocText',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('RecLocText'),
										mode : 'local',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 250,
										store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : CTLOC_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'CTLOCRowID', 'CTLOCDesc' ])
										}),
										queryParam : 'desc',
										//triggerAction : 'all',
										forceSelection : true,
										selectOnFocus : false,
										//typeAhead : true,
										//minChars : 1,
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc'
										}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch_loc',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch_loc'),
													handler : function() {
																var gsm = grid.getSelectionModel();// 获取选择列
																var rows = gsm.getSelections();// 根据选择列获取到所有的行
																child_grid_loc.getStore().baseParams={
																	RecLoc : Ext.getCmp('RecLocText').getValue(),
																	OrdLoc : Ext.getCmp('OrdLocText').getValue(),
																	ItemCate:  Ext.getCmp('ItemCateText').getValue(),
																	hospid:  hospComp.getValue(),
																	ParRef : rows[0].get('PHCINRowId')
															 	};
																child_grid_loc.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh_loc',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh_loc'),
														handler : function() {
															Ext.getCmp('OrdLocText').reset();
															Ext.getCmp('RecLocText').reset();
															Ext.getCmp('ItemCateText').reset();
															var gsm = grid.getSelectionModel();// 获取选择列
															var rows = gsm.getSelections();// 根据选择列获取到所有的行
															child_ds_loc.removeAll();
															child_grid_loc.getStore().baseParams={
																hospid:  hospComp.getValue(),
																ParRef : rows[0].get('PHCINRowId')
														 	};
														 	
															child_grid_loc.getStore().load({
																		params : {
																			start : 0,
																			limit : pagesize_pop
																			
																		}
																	});
															
															
															child_list_win_loc.setTitle(rows[0].get('PHCINDesc1'));
															child_list_win_loc.show();
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton_loc.render(child_grid_loc.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid_loc,"User.DHCPHCInstrRecLoc");
	/** child_grid_loc双击事件 */
	child_grid_loc.on('rowdblclick', function(child_grid_loc) {
				var _record = child_grid_loc.getSelectionModel().getSelected();
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            child_win_loc.setTitle('修改');
					child_win_loc.setIconClass('icon-update');
					child_win_loc.show('');
					Ext.getCmp("child-form-save_loc").getForm().load({
		                url : RECTLOC_OPEN_ACTION_URL + '&id=' + _record.get('RowID'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                	var data=action.result.data
		                	var InstrTimeRange=data.InstrTimeRange
		                	var time=InstrTimeRange.split("~")
		                	child_WinForm_loc.getForm().findField('InstrTimeFromF').setValue(time[0]);
		                	child_WinForm_loc.getForm().findField('InstrTimeToF').setValue(time[1]);

		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	/** 接收科室窗口 */	
	
	var child_list_win_loc = new Ext.Window({
					iconCls : 'icon-DP',
					width : Ext.getBody().getWidth()*0.96,
					height : Ext.getBody().getHeight()*.9,
					layout : 'border',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [GenHospPanel(hospComp),child_grid_loc],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData_Loc,UpdateData_Loc,DelData_Loc);
						   							
						},
						"hide" : function(){
							keymap_pop.disable();
							keymap_main.enable();
						    
						},
						"close" : function(){
						}
					}
				});
	
	/** 接收科室按钮 */
	var btnLoc = new Ext.Toolbar.Button({
				text : '接收科室',
				tooltip : '用法接收科室',
				iconCls : 'icon-DP',
				id:'btnLoc',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLoc'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_ds_loc.removeAll();
						Ext.getCmp('RecLocText').setValue('')
						Ext.getCmp('OrdLocText').setValue('')
						Ext.getCmp('ItemCateText').setValue('')
						
						child_grid_loc.getStore().baseParams={
							hospid:  hospComp.getValue(),
							ParRef : rows[0].get('PHCINRowId')
					 	};
					 	
						child_grid_loc.getStore().load({
									params : {
										start : 0,
										limit : pagesize_pop
										
									}
								});
						
						
						child_list_win_loc.setTitle(rows[0].get('PHCINDesc1'));
						child_list_win_loc.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一种用法!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});




	/*********************************接收科室结束*********************************************/

	/*
	///用法与处方类型关联   新疆中医院
	var Define_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassQuery=GetDefineDataForCmb";
	var CHILD_QUERY_ACTION_URL_define = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDocCTDefine&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_define = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDocCTDefine&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCInstrucLinkDocCTDefine';
	var CHILD_OPEN_ACTION_URL_define = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDocCTDefine&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL_define = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCInstrucLinkDocCTDefine&pClassMethod=DeleteData';
			
	///用法与处方类型关联删除按钮  
	var child_btnDel_define = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn_define',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn_define'),
		handler : DelData_define=function () {
			if (child_grid_define.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid_define.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL_define,
							method : 'POST',
							params : {
								'id' : rows[0].get('ILDCDRowId')
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
												var startIndex = child_grid_define.getBottomToolbar().cursor;
												var totalnum=child_grid_define.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
												{
													var pagenum=child_grid_define.getStore().getCount();
													if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候,不是最后一页则还停留在这一页
												}
												child_grid_define.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize_pop
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
		
	/// 用法与处方类型关联增加\修改的Form 
	var child_WinForm_define = new Ext.form.FormPanel({
				id : 'child-form-save_define',
				labelAlign : 'right',
				labelWidth : 70,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ILDCDRowId',mapping:'ILDCDRowId',type:'string'},
                                         {name: 'ILDCDInstrucDR',mapping:'ILDCDInstrucDR',type:'string'},
                                         {name: 'ILDCDDocCTDefineDR',mapping:'ILDCDDocCTDefineDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [
						{
							fieldLabel : 'ILDCDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ILDCDRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '用法',
							name : 'ILDCDInstrucDR',
							hiddenName : 'ILDCDInstrucDR',
							id:'ILDCDInstrucDRF',
   							readOnly : true,
   							style:Ext.BDP.FunLib.ReadonlyStyle(true),
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Instruc_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'PHCINRowId', 'PHCINDesc1' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'PHCINRowId',
							displayField : 'PHCINDesc1',
							allowBlank : false
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>处方类型',
							name : 'ILDCDDocCTDefineDR',
							id:'ILDCDDocCTDefineDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ILDCDDocCTDefineDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ILDCDDocCTDefineDRF')),
							hiddenName : 'ILDCDDocCTDefineDR',
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : Define_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'RowId', 'DHCDocCTDefineDesc' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'RowId',
							displayField : 'DHCDocCTDefineDesc'
					
						}]
			});
		////用法与处方类型关联增加\修改窗口 
	var child_win_define = new Ext.Window({
		title : '',
		width : 350,
		height:240,
		layout : 'fit',
		//plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		//constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm_define,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn_define',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn_define'),
			handler : function() {
				
   			 	if(child_WinForm_define.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					return;
   			 	}
				if (child_win_define.title == '添加') {
					child_WinForm_define.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : CHILD_SAVE_ACTION_URL_define,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								child_win_define.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												child_grid_define.getStore().load({
															params : {
																start : 0,
																limit : pagesize_pop
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
							child_WinForm_define.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL_define,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										child_win_define.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_define", CHILD_QUERY_ACTION_URL_define, myrowid)
												
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
					// WinForm.getForm().reset();
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				child_win_define.hide();
			}
		}],
		listeners : {
			'show' : function() {
				Ext.getCmp("child-form-save_define").getForm().findField("ILDCDDocCTDefineDR").focus(true,500);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
	
	///用法与处方类型关联store 
	var child_ds_define = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL_define }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ILDCDRowId',
									mapping : 'ILDCDRowId',
									type : 'string'
								}, {
									name : 'ILDCDInstrucDR',
									mapping : 'ILDCDInstrucDR',
									type : 'string'
								}, {
									name : 'ILDCDDocCTDefineDR',
									mapping : 'ILDCDDocCTDefineDR',
									type : 'string'
								
								}// 列的映射
						])
			});
	///  用法与处方类型关联维护工具条 
	var child_tbbutton_define = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn_define',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_define'),
								handler : AddData_define=function () {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var PHCINRowId = rows[0].get('PHCINRowId')
									child_win_define.setTitle('添加');
									child_win_define.setIconClass('icon-add');
									child_win_define.show('');
									child_WinForm_define.getForm().reset();
									child_WinForm_define.getForm().findField('ILDCDInstrucDR').setValue(PHCINRowId);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn_define',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_define'),
									handler : UpdateData_define=function () {
											if (!child_grid_define.selModel.hasSelection()) {
									            Ext.Msg.show({
														title : '提示',
														msg : '请选择需要修改的行!',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
									        } else {
									        var _record = child_grid_define.getSelectionModel().getSelected();
								            child_win_define.setTitle('修改');
											child_win_define.setIconClass('icon-update');
											child_win_define.show('');
											Ext.getCmp("child-form-save_define").getForm().reset();
								            Ext.getCmp("child-form-save_define").getForm().load({
								                url : CHILD_OPEN_ACTION_URL_define + '&id=' + _record.get('ILDCDRowId'),
								                waitMsg : '正在载入数据...',
								                success : function(form,action) {
								                    //Ext.Msg.alert(action);
								                	//Ext.Msg.alert('编辑', '载入成功');
								                },
								                failure : function(form,action) {
								                	Ext.Msg.alert('编辑', '载入失败');
								                }
								            });
								        }
									},
									scope : this
								}), '-', child_btnDel_define]
		});
	//用法与处方类型关联child_grid_define 
	var child_grid_define = new Ext.grid.GridPanel({
				id : 'child_grid_define',
				region : 'center',
				closable : true,
				store : child_ds_define,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'ILDCDRowId',
							sortable : true,
							dataIndex : 'ILDCDRowId',
							hidden : true
						}, {
							header : '用法',
							sortable : true,
							dataIndex : 'ILDCDInstrucDR',
							width : 160,
							hidden : true
						}, {
							header : '处方类型',
							sortable : true,
							dataIndex : 'ILDCDDocCTDefineDR',
							width : 160
						
						}],
				title : '用法与处方类型关联',
				//iconCls : 'icon-DP',
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stripeRows : true,
				//stateful : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds_define,
						displayInfo : true,
						displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
						emptyMsg : '没有记录',
						plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
						listeners : {
							"change":function (t,p) {
								pagesize_pop=this.pageSize;
							}
						}
					}),
				tbar : new Ext.Toolbar({
						  items : [ '处方类型', {
										xtype : 'textfield',
										id : 'TextDesc_define',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc_define')
									}, '-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch_define',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch_define'),
													handler : function() {
																child_grid_define.getStore().baseParams={
																	definedesc:Ext.getCmp("TextDesc_define").getValue(),
																	instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	};
																child_grid_define.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh_define',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh_define'),
														handler : function() {
															Ext.getCmp("TextDesc_define").reset();
															child_grid_define.getStore().baseParams={
																instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
															 	
															};
															
															child_grid_define.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton_define.render(child_grid_define.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid_define,"User.PHCInstrucLinkDocCTDefine");
	///child_grid_define双击事件 
	child_grid_define.on('rowdblclick', function(child_grid_define) {
				if (!child_grid_define.selModel.hasSelection()) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		        	var _record = child_grid_define.getSelectionModel().getSelected();
		            child_win_define.setTitle('修改');
					child_win_define.setIconClass('icon-update');
					child_win_define.show('');
					Ext.getCmp("child-form-save_define").getForm().reset();
		            Ext.getCmp("child-form-save_define").getForm().load({
		                url : CHILD_OPEN_ACTION_URL_define + '&id=' + _record.get('ILDCDRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	/// 用法与处方类型关联窗口 	
	var child_list_win_define = new Ext.Window({
					iconCls : 'icon-DP',
					width : 760, //Ext.getBody().getWidth()*0.8,
					height : 500,//Ext.getBody().getHeight()*.9,
					layout : 'fit',
					plain : true,// true则主体背景透明
					modal : true,
					//frame : true,
					autoScroll : true,
					collapsible : true,
					hideCollapseTool : true,
					titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [child_grid_define],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_define = Ext.BDP.FunLib.Component.KeyMap(AddData_define,UpdateData_define,DelData_define);
													
						},
						"hide" : function(){
							keymap_define.disable();
							keymap_main.enable();
						    
						},
						"close" : function(){
						}
					}
				});
	//用法与处方类型关联
	var btnDefine = new Ext.Toolbar.Button({
				text : '关联处方类型',
				tooltip : '关联处方类型',
				iconCls : 'icon-DP',
				id:'btnDefine',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDefine'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						child_ds_define.baseParams={
							instrucdr : grid.getSelectionModel().getSelections()[0].get('PHCINRowId')
						};
						child_ds_define.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win_define.setTitle(rows[0].get('PHCINDesc1')+'---与处方类型关联');
						child_list_win_define.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条药品用法!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	
	////用法与处方类型关联 完
			
			
		*/	
			
			
			
	/**---------增加按钮-----------*/
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler :AddData= function () {                              //------------在函数中调用添加窗口
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
				handler : UpdateData=function () {
					
					if (grid.selModel.hasSelection()) {
						loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('PHCINRowId');
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
	var fields=[{												//---------列的映射
									name : 'PHCINRowId',
									mapping : 'PHCINRowId',
									type : 'string'
								}, {
									name : 'PHCINCode',
									mapping : 'PHCINCode',
									type : 'string'
								}, {
									name : 'PHCINDesc1',
									mapping : 'PHCINDesc1',
									type : 'string'
								},
								{
									name:'PHCINDesc2',
									mapping:'PHCINDesc2',
									type:'string'
								}, {
									name : 'PHCINActiveFlag',
									mapping : 'PHCINActiveFlag',
									type : 'string'
								}, {
									name : 'PHCINClinicType',
									mapping : 'PHCINClinicType',
									type : 'string'
									
									
									
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
						}, fields)
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
		,'-', btnDosage,'-',btnFreq   ///,'-',btnDefine   ///新疆中医院
		,'-',btnLoc           //接收科室
		,'-',btnSort,'-', btnTrans,'->',btnlog,'-',btnhislog
		]
		})
		
		
	/**---------搜索按钮-----------*/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {                                  //-----------执行回调函数
				grid.getStore().baseParams={							//-----------模糊查询		
						code : Ext.getCmp("TextCode").getValue()
								,
						desc1 :  Ext.getCmp("TextDesc1").getValue()
									,
						desc2:  Ext.getCmp("TextDesc2").getValue()
									
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
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					Ext.BDP.FunLib.SelectRowId ="";
					Ext.getCmp("TextCode").reset();						//-----------将输入框清空
					Ext.getCmp("TextDesc1").reset();                     //-----------将输入框清空
					Ext.getCmp("TextDesc2").reset();
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
						'中文描述', {
							xtype : 'textfield',
							emptyText : '描述/别名',id : 'TextDesc1',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc1')
						},
						'-',
						'英文描述', {
							xtype : 'textfield',
							id : 'TextDesc2',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')
						},'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
			
	var GridCM=[sm, {									//----------------定义列
							header : 'PHCINRowId',
							width : 100,
							sortable : true,
							dataIndex : 'PHCINRowId',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'PHCINCode'
						}, {
							header : '中文描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCINDesc1'
						}, {
							header : '英文描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCINDesc2'
						}, {
							header : '是否激活',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCINActiveFlag'
						}, {
							header : '就诊类型',
							width : 120,
							sortable : true,
							dataIndex : 'PHCINClinicType'
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
				columns : GridCM,
				stripeRows : true,                                //------------------显示斑马线
				loadMask : {                                      //------------------用于在加载数据时做出类似于遮罩的效果
					msg : '数据加载中,请稍候...'
				},
				title : '药品用法',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHCINDesc2',
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb,                                        //-----------------顶部状态栏
				stateId : 'grid'
			});
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	

	/**---------双击事件-----------*/
	 grid.on("rowdblclick", function(grid) {
        loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('PHCINRowId');
	        AliasGrid.loadGrid();
			
        //alert(form1.reader);
    });
			//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('PHCINRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
    // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
               Ext.Msg.alert('提示', '请选择要修改的行');
        } else {
        	win.setTitle('修改');
        	win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&PHCINRowId='+ _record.get('PHCINRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	
                	Ext.getCmp('PHCINClinicTypeO').setValue((action.result.data.PHCINClinicTypeO)=='O'?true:false);
                	Ext.getCmp('PHCINClinicTypeE').setValue((action.result.data.PHCINClinicTypeE)=='E'?true:false);
                	Ext.getCmp('PHCINClinicTypeI').setValue((action.result.data.PHCINClinicTypeI)=='I'?true:false);
                	Ext.getCmp('PHCINClinicTypeH').setValue((action.result.data.PHCINClinicTypeH)=='H'?true:false);
                	Ext.getCmp('PHCINClinicTypeN').setValue((action.result.data.PHCINClinicTypeN)=='N'?true:false);
					
                },
                failure : function(form,action) {
                    //Ext.example.msg('编辑', '载入失败');
                	Ext.Msg.alert('编辑', '载入失败');
                }
            });
        }
    };
    
    var keymap_freq ="",keymap_dos ="",keymap_define=""
    var keymap_main =Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	
	
	/**---------创建viewport-----------*/
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
	
 
    
});
