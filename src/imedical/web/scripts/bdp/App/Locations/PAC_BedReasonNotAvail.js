
	Ext.form.Field.prototype.msgTarget = 'qitp'; 
	
	//自定义一个cKData的vtype的表单验证，用来验证结束日期是否大约开始日期
	Ext.apply(Ext.form.VTypes, {										   
		cKDate:function(val, field){
			var v1 = Ext.getCmp("RNAVDateFromF").getValue();
    		var v2 = Ext.getCmp ("RNAVDateToF").getValue();
    		if(v1=="" || v2=="") return true;//有日期为空的情况要排除在外
    		return v2 > v1;//通过判断返回一个boolean值类型
		},
		cKDateText:'开始日期不能大于结束日期'//当判断错误时显示的错误提示信息
		});
			
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	
Ext.onReady(function() {

	/// 名称: 《科室》 - 床位不可用原因 维护	
	/// 描述: 床位不可用原因维护, 包含增删改查功能
	/// 编写者：基础平台组 - chz
	/// 编写日期: 2012-9-7
	//Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PACBedReasonNotAvail&pClassQuery=GetList";//ds里调用数据
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBedReasonNotAvail&pClassMethod=OpenData";//修改时取数据
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PACBedReasonNotAvail&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PACBedReasonNotAvail";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PACBedReasonNotAvail&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	
	Ext.QuickTips.init();
	
		//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PAC_BedReasonNotAvail"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PAC_BedReasonNotAvail"
	});
	
	/*****************排序*******************/
    Ext.BDP.FunLib.SortTableName = "User.PACBedReasonNotAvail";
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
       RowID=rows[0].get('RNAVRowId');
       Desc=rows[0].get('RNAVDesc');
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
    }
    else
    {
       var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
    }
  });


	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function () {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						AliasGrid.DataRefer = rows[0].get('RNAVRowId');
						AliasGrid.delallAlias();
						
						//开始处理请求  Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('RNAVRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide(); 
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText); 
									if (jsonData.success == 'true')
									{
										//var myrowid = action.result.id;                
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功!',
											icon : Ext.Msg.INFO, 
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
											}
									});
								}
								else { //对应if (jsonData.success == 'true'){ }
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
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				URL : SAVE_ACTION_URL,
				labelAlign : 'right',
				title: '基本信息',
				width : 200,
				split : true,
				frame : true,	
				waitMsgTarget : true,//这个属性决定了load和submit中对数据的处理ㄛlist必须是一个集合类型ㄛjson格式应该是[]包含的一个数组
       			 reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'RNAVCode',mapping:'RNAVCode'},
                                         {name: 'RNAVDesc',mapping:'RNAVDesc'},
                                         {name: 'RNAVDateFrom',mapping:'RNAVDateFrom'},
                                         {name: 'RNAVDateTo',mapping:'RNAVDateTo'},
                                         {name: 'RNAVRowId',mapping:'RNAVRowId'}
                                        ]),
				defaults : {
					width : 140,
					bosrder : false
				},
				items : [{
							xtype:'textfield',
							fieldLabel : 'RNAVRowId',
							name : 'RNAVRowId',
							hideLabel : 'True',
							hidden : true//RowId隐藏
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'RNAVCode',
							name : 'RNAVCode',
							id:'RNAVCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RNAVCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RNAVCodeF')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('RNAVCodeF'),
							allowBlank:false,
							blankText: '代码不能为空',
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACBedReasonNotAvail";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('RNAVRowId'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
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
							id:'RNAVDesc',
							name : 'RNAVDesc',
							id:'RNAVDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RNAVDescF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RNAVDescF')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('RNAVDescF'),
							allowBlank:false,
							blankText: '描述不能为空',
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PACBedReasonNotAvail"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为“修改”，则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('RNAVRowId'); //此条数据的rowid
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
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'RNAVDateFrom',
							id:'RNAVDateFromF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RNAVDateFromF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RNAVDateFromF')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('RNAVDateFromF'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							vtype:'cKDate',
							allowBlank:false,
							blankText: '开始日期不能为空'
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'RNAVDateTo',
							id:'RNAVDateToF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RNAVDateToF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RNAVDateToF')),
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('RNAVDateToF'),
							format : BDPDateFormat,
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
		width : 380,
		height : 350,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		//autoScroll : true,
		//collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		labelWidth : 55,
		items : tabs, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
  			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				if(WinForm.getForm().isValid()==false)
				{
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				/**-------添加----------*/	
				if (win.title == "添加") { //WinForm.form.isValid()
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍后',
						method : 'POST',
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
												grid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
														//保存别名
											
											}
								
										});
							AliasGrid.DataRefer = myrowid;
							AliasGrid.saveAlias();
							} else {//对应if (action.result.success == 'true') {	}
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
						//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
						failure : function(form, action) {
							Ext.Msg.alert('提示', '添加失败！');
						}
					})	
				} 
				/**---------修改-------*/
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
				Ext.getCmp("form-save").getForm().findField("RNAVCode").focus(true,50);
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
				handler : AddData=function () {
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
				handler : UpdateData=function () {
					if (grid.selModel.hasSelection()) {
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						var record = grid.getSelectionModel().getSelected(); //获取当前行的记录
						Ext.getCmp("form-save").getForm().loadRecord(record);//通过form的id调用form，并加载当前行的数据到form
						
						var _record = grid.getSelectionModel().getSelected();
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('RNAVRowId');
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
	
			
  /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
	var fields= [{
								name : 'RNAVRowId',
								mapping : 'RNAVRowId',
								type : 'string'
							}, {
								name : 'RNAVCode',
								mapping : 'RNAVCode',
								type : 'string'
							}, {
								name : 'RNAVDesc',
								mapping : 'RNAVDesc',
								type : 'string'
							},{
								name : 'RNAVDateFrom',
								mapping : 'RNAVDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'RNAVDateTo',
								mapping : 'RNAVDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}// 列的映射
						];
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : QUERY_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
			});
 	//加载数据
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);
	
	ds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
					//参数records表示获得的数据, options表示执行load时传递的参数,success表示是否加载成功
				}
			}); 			
			
	
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
			})

	var sm = new Ext.grid.CheckboxSelectionModel({ //CheckBox选择列
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
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={//模糊查询		
						code : '%' + Ext.getCmp("TextCode").getValue()+ '%',
						
						desc : '%' + Ext.getCmp("TextDesc").getValue()+ '%'
						
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
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.BDP.FunLib.SelectRowId =""; //翻译
					
					Ext.getCmp("TextCode").reset(); 
					Ext.getCmp("TextDesc").reset();
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
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},
						 '-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},
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
	var GridCM = [sm, {
							header : 'RNAV_RowId',
							width : 70,
							sortable : true,
							dataIndex : 'RNAVRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'RNAVCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'RNAVDesc'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'RNAVDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'RNAVDateTo'
						}];
	// 创建 Grid
	var grid = new Ext.grid.GridPanel({
				title : '床位不可用原因维护',
				id : 'grid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				tools:Ext.BDP.FunLib.Component.HelpMsg,
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
            //Ext.Msg.alert('修改操作', '请选择要修改的一项');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('RNAVRowId'),//id 对应OPEN里的入参
                success : function(form,action) {
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑', '载入失败!');
                }
            });
        }
    };
    
    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('RNAVRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
    
    grid.on("rowdblclick", function(grid, rowIndex, e) {
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
        	var _record = grid.getSelectionModel().getSelected();
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            AliasGrid.DataRefer = _record.get('RNAVRowId');
	        AliasGrid.loadGrid();
    });	
    
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
				});
});