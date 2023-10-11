		//自定义一个cKData的vtype的表单验证，用来验证结束日期是否大约开始日期
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;//有日期为空的情况要排除在外
    		return v2 > v1;//通过判断返回一个boolean值类型
		},
		cKDateText:'开始日期不能大于结束日期'//当判断错误时显示的错误提示信息
	});
			
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	
Ext.onReady(function() {
	
	/// 名称: 《科室》 - 房间类型 维护
	/// 描述: 房间类型维护, 包含增删改查功能
	/// 编写者：基础平台组 - 蔡昊哲
	/// 编写日期: 2012-9-10

	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACRoomType&pClassQuery=GetList";//ds里调用数据
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACRoomType&pClassMethod=OpenData";//修改时取数据
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACRoomType&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACRoomType";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACRoomType&pClassMethod=DeleteData";
	
	var ARC_ItmMast_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetDataForCmb2&subcatdesc=bed";
	
	var pagesize=Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();//悬浮提示,tooltip：'***'
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PAC_RoomType"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_RoomType"
	});
	
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.PACRoomType";
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
       RowID=rows[0].get('ROOMTRowId');
       Desc=rows[0].get('ROOMTDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });
	
	//多院区医院下拉框
	var hospComp=GenHospComp(Ext.BDP.FunLib.TableName);	
	//医院下拉框选择一条医院记录后执行此函数
	hospComp.on('select',function (){
		 grid.enable();
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=grid.getSelectionModel().getSelections()[0].get("ROOMTRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
	
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
  		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {//点击确定按钮后执行删除操作
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();//获取选择列
						var rows = gsm.getSelections();//根据选择列获取到所有的行
						
						AliasGrid.DataRefer = rows[0].get('ROOMTRowId');
						AliasGrid.delallAlias();
						//开始处理请求  Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ROOMTRowId')//通过RowId来删除数据
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);//获取返回的信息
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){//回调函数
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}
									});
								}
								else {//对应if (jsonData.success == 'true'){ }
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info//获取返回的错误信息
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败!' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {//对应 if (success) {}   
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
			} else {//对应if (grid.selModel.hasSelection()) {}
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	

	// 增加修改的form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				URL : SAVE_ACTION_URL,
				labelAlign : 'right',//标签对齐方式
				width : 250,
				split : true,
				frame : true,
				title : '基本信息',
				defaults : {
					width : 140,
					bosrder : false
				},
				waitMsgTarget : true,//这个属性决定了load和submit中对数据的处理,list必须是一个集合类型,json格式应该是[]包含的一个数组
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ROOMTCode',mapping:'ROOMTCode'},
                                         {name: 'ROOMTDesc',mapping:'ROOMTDesc'},
                                         {name: 'ROOMTARCIMDR',mapping:'ROOMTARCIMDR'},
                                         {name: 'ROOMTDateFrom',mapping:'ROOMTDateFrom'},
                                         {name: 'ROOMTDateTo',mapping:'ROOMTDateTo'},
                                         {name: 'ROOMTRowId',mapping:'ROOMTRowId'}
                                        ]),
				items : [{
							xtype:'textfield',
							fieldLabel : 'ROOMTRowId',
							name : 'ROOMTRowId',
							hideLabel : 'True',
							hidden : true//RowId隐藏
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'ROOMTCode',
							name : 'ROOMTCode',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMTCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMTCode')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMTCode'),
							allowBlank:false,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACRoomType";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ROOMTRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"",hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
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
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'ROOMTDesc',
							name : 'ROOMTDesc',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMTDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMTDesc')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMTDesc'),
							allowBlank:false,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACRoomType"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ROOMTRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText,hospComp.getValue());//用tkMakeServerCall函数实现与后台同步调用交互
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
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
							xtype:'bdpcombo',
							loadByIdParam : 'rowid',
							emptyText:'请选择',
							name:'ROOMTARCIMDR',
							//id:'ROOMTARCIMDR',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ROOMTARCIMDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ROOMTARCIMDR')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ROOMTARCIMDR'),
							fieldLabel : '医嘱项目',
							hiddenName : 'ROOMTARCIMDR',
							forceSelection: true,
							queryParam:"desc",
							//triggerAction : 'all',
							selectOnFocus:false,
							//typeAhead:true,
							mode:'remote',
							pageSize:Ext.BDP.FunLib.PageSize.Combo,
							//minChars: 0,
							listWidth:300,
							displayField : 'ARCIMDesc',
							valueField : 'ARCIMRowId',
							store : new Ext.data.Store({
								autoLoad: true,
								proxy : new Ext.data.HttpProxy({ url : ARC_ItmMast_DR_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
									totalProperty : 'total',
									root : 'data',
									successProperty : 'success'
								}, ['ARCIMRowId','ARCIMDesc'])
							}),
							listeners:{
								'beforequery': function(e){
									this.store.baseParams = {
										hospid:hospComp.getValue()
									};
									this.store.load({params : {
											start : 0,
											limit : Ext.BDP.FunLib.PageSize.Combo
									}})
								}
							}
							//editable: false,
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'ROOMTDateFrom',
							format : BDPDateFormat,
							id:'date1',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							vtype:'cKDate',
							allowBlank:false
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'ROOMTDateTo',
							format : BDPDateFormat,
							id:'date2',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							vtype:'cKDate'
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
		width : 350,
		height : 350,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
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
			id:'save_btn',
			iconCls : 'icon-save',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {//保存按钮下调用的函数	
				if(WinForm.getForm().isValid()==false){
					   Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					   return;
				  }
				//**-------添加----------*//	
				if (win.title == "添加") {//WinForm.form.isValid()
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍后',
						method : 'POST',
						params : {									 
							'LinkHospId' :hospComp.getValue()         
						},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;//获取当前页开始的记录数						
												grid.getStore().load({//保存数据成功后,通过RowId返回到这一条数据
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
							} else {//对应if (action.result.success == 'true') {	}
								var errorMsg = '';
								if (action.result.errorinfo) {//获取返回的错误信息
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
						//服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				//**---------修改-------**//
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							WinForm.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍后',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									//保存别名
												AliasGrid.saveAlias();
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
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",QUERY_ACTION_URL,myrowid);
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
				Ext.getCmp("form-save").getForm().findField("ROOMTCode").focus(true,50);
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
				handler : AddData=function() {
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
				scope: this
	});
	// 修改按钮
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'update_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function() {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						var record = grid.getSelectionModel().getSelected();//获取当前行的记录
						
						loadFormData(grid);
						//Ext.getCmp("form-save").getForm().loadRecord(record);//通过form的id调用form，并加载当前行的数据到form
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = record.get('ROOMTRowId');
				        AliasGrid.loadGrid();
					} else {//对应if (grid.selModel.hasSelection()) {}
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}			 
				}
	});
	
			
  /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
	var fields=[{
								name : 'ROOMTRowId',
								mapping : 'ROOMTRowId',
								type : 'string'
							}, {
								name : 'ROOMTCode',
								mapping : 'ROOMTCode',
								type : 'string'
							}, {
								name : 'ROOMTDesc',
								mapping : 'ROOMTDesc',
								type : 'string'
					
							}, {
								name : 'ROOMTARCIMDR',
								mapping : 'ROOMTARCIMDR',
								type : 'string'
							},{
								name : 'ROOMTDateFrom',
								mapping : 'ROOMTDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'ROOMTDateTo',
								mapping : 'ROOMTDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}// 列的映射
						];
	
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({//将原始数据转换
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
	});
	
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	
	//分页工具条
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
	});

	var sm = new Ext.grid.CheckboxSelectionModel({//CheckBox选择列
				singleSelect : true,//只能选一行
				checkOnly : false,//
				width : 20
	});


	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-' ,HospWinButton,'-',btnTrans,'-',btnSort,'->',btnlog,'-',btnhislog]
	});
		
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				handler : function() {
				grid.getStore().baseParams={//模糊查询		
						code : Ext.getCmp("TextCode").getValue(),
						desc : Ext.getCmp("TextDesc").getValue(),
						hospid:hospComp.getValue()
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
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					
					Ext.BDP.FunLib.SelectRowId =""; //翻译
					
					grid.getStore().baseParams={
						hospid:hospComp.getValue()
					};
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
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},
						 '-',
						'描述', {xtype : 'textfield',id : 'TextDesc',emptyText : '描述/别名',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},
						'-',
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),
						'-',
						btnSearch,
						'-', 
						btnRefresh,
						'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
			});

	// 创建 Grid
	var GridCM = [sm, {
				header : 'ROOMT_RowId',
				width : 70,
				sortable : true,
				dataIndex : 'ROOMTRowId',
				hidden : true
			}, {
				header : '代码',
				width : 80,
				sortable : true,
				dataIndex : 'ROOMTCode'
			}, {
				header : '描述',
				width : 100,
				sortable : true,
				dataIndex : 'ROOMTDesc'
			}, {
				header : '医嘱项目',
				width : 100,
				sortable : true,
				dataIndex : 'ROOMTARCIMDR'
			}, {
				header : '开始日期',
				width : 80,
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
				dataIndex : 'ROOMTDateFrom'
			}, {
				header : '结束日期',
				width : 80,
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
				dataIndex : 'ROOMTDateTo'
			}];
	var grid = new Ext.grid.GridPanel({
				title : '房间类型维护',
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
				// config options for stateful behavior
				stateful : true,
				viewConfig : {//视图配置
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
        var _record = grid.getSelectionModel().getSelected();//获取当前行的记录
        if (!_record) {
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ROOMTRowId'),
                success : function(form,action) {
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败!');
                }
            });
        }
    };

    //双击事件
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
        	//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('ROOMTRowId');
	        AliasGrid.loadGrid();
    });	
	
    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ROOMTRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	
    	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
	//创建viewport
	//var gridname=Ext.getCmp(Request);
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid]//显示的内容grid
				});
			
	///多院区医院
	var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		grid.disable();
	}
	else
	{
		/** grid加载数据 */
		ds.load({
				params : {
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {
				}
			});
	}			

});