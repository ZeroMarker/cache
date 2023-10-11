 	
	/// 名称:2 安全组维护,2.1安全组医嘱授权，2.1.1医嘱子类明细,2.2安全组库存授权（科室）,2.3复制授权
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2013-5-4
	var SSGRPRowId="1"; ///批量授权，设置初始安全组为demo
	
	///页面帮助 2014-10-23 by chenying
	var htmlurl = "../scripts/bdp/AppHelp/System/SSGroup.htm";
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');

	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPTabCloseMenu.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/ChinesePY.js"> </script>');
Ext.onReady(function() {
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "SS_Group"
	});
	
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.SSGroup";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	Ext.BDP.FunLib.TableName="SS_Group";
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
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
			RowID=rows[0].get('SSGRPRowId');
			Desc=rows[0].get('SSGRPDesc');
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
		 Ext.getCmp('tbActiveFlag').setValue("Y")
		 //grid.enable();
		 grid.getStore().baseParams={
				hospid:hospComp.getValue(),		
				activeflag:'Y',
				desc : Ext.getCmp("TextDesc").getValue()
				
		};
		grid.getStore().load({
			params : {
				start : 0,
				limit : pagesize
			}
		});
		
	});
	//Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';

	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetList";
	//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=SaveEntityAll&pEntityName=web.Entity.CT.SSGroup";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=DeleteData";
	var SSGroup_DR_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	
	//医嘱授权 SSGroupOrderCategory
	var SSORD_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassQuery=GetList";
	var SSORD_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSGroupOrderCategory";
	var SSORD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassMethod=OpenData";
	var SSORD_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassMethod=DeleteData";
	var Ord_Cat_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassQuery=GetDataForCmb1";
	//var Ord_Sub_Category_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassQuery=GetARCICDR";
	var Ord_Sub_Category_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
	
	//医嘱子类明细  SSGroupOrderCategoryItems
	var ITM_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassQuery=GetList";
	var ITM_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSGroupOrderCategoryItems";
	var ITM_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=OpenData";
	var ITM_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=DeleteData";
	//var ARCIM_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassQuery=GetDataForCmb1";
	var ARCIM_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmMast&pClassMethod=GetDataForCmb2";
	//一键Include/Exclude
	var IncludeExclude_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=IEAll";
	//修改医嘱子类时，查询有没有子类明细
	var ITM_ACTION_URL1 = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=QueryForItems";
	//确认修改医嘱，子类删除子类明细
	var ITM_DELETE_ACTION_URL1 = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategoryItems&pClassMethod=ChangeOrdSub";
	
	//库存授权 SSGroupStockLocations
	var ST_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassQuery=GetList";
	var ST_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSGroupStockLocations";
	var ST_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassMethod=OpenData";
	var ST_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassMethod=DeleteData";
	var CT_LOC_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1"; //RowID
	var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
	//var CT_Hospital_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	
	 //=====================医嘱状态========================
	var OSTAT_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderStatus&pClassQuery=GetList";
	var OSTAT_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderStatus&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSGroupOrderStatus";
	var OSTAT_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderStatus&pClassMethod=OpenData";
	var OSTAT_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderStatus&pClassMethod=DeleteData";
	var OSTAT_OrdStat_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderStatus&pClassQuery=GetDataForCmb1";
    
	 //=====================医院========================
	var HOSP_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupHospitals&pClassQuery=GetList";
	var HOSP_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroupHospitals&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.SSGroupHospitals";
	var HOSP_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupHospitals&pClassMethod=OpenData";
	var HOSP_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupHospitals&pClassMethod=DeleteData";
	
	///医院，不调用医院组
	var HOSP_Hospital_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
    //调用获取医院组的接口 2020-05-20
	var Hosp_Comp_QUERY_ACTION_URL="../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPMappingHOSP&pClassQuery=GetHospDataForCombo"+"&tablename="+"SS_Group";
	//复制授权维护 
	var Copy_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetList";//查询安全组
	var Copy_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=CopyEntity";
	
	
	//安全组配置
	var Set_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=GetSSGroupSet";
	var Set_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=SaveEntityAll&pEntityName=web.Entity.CT.SSGroup";
	
	var WLS_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForWLS";
	var WLSL_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForWLSL";
	var POREF_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForPOREF";
	var LLDR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLocationList&pClassQuery=GetDataForCmb1";
	
	
	
	Ext.QuickTips.init();												  //--------启用悬浮提示

	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	//----初始化Ext状态管理器，在Cookie中记录用户的操作状态
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	//---------在删除按钮下实现删除功能--------------
	/*
	var btnDel = new Ext.Toolbar.Button({                                 //-------创建一个删除按钮 
		text : '删除',													  //-------按钮的内容
		id:'delete-btn',
		tooltip : '删除',												  //-------工具提示或说明
		iconCls : 'icon-delete',										  //-------给一个空间用来显示图标
		disabled:Ext.BDP.FunLib.Component.DisableFlag('delete-btn'),
		handler : function() {											  //指定事件处理的函数,点击删除按钮后执行后面的函数
			if (grid.selModel.hasSelection()) {                           //-------如果选中某一行则继续执行删除操作
				//Ext.MessageBox.confirm------------------------------------------用来弹出一个提示框() 
				//调用格式： confirm(String title,String msg,[function fn],[Object scope]) 
				var targetRecord=ds.getAt(0);//获得该行记录的引用 //新增数据都在第一行， 故设定为getAt(0)
				//alert(targetRecord.data['SSGRPRowId']);
				if(targetRecord.data['SSGRPRowId']==undefined)//若新增数据未保存则直接删除
				{
					ds.remove(targetRecord);
				}
				else{
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   //-------点击确定按钮后继续执行删除操作
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示'); //-------wait框
						var gsm = grid.getSelectionModel();				  // ------获取选择列
						var rows = gsm.getSelections();					  //-------根据选择列获取到所有的行
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : SSGRP_DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('SSGRPRowId')           //-------通过RowId来删除数据
							},
							//callback : Function （可选项）(Optional) 
                             //          该方法被调用时附上返回的http response对象
                            ///           该函数中传入了如下参数：
                              //         options : Object  //-----------------------请求所调用的参数
                              //         success : Boolean //-----------------------请求成功则为true
                              ///         response : Object //-----------------------包含了返回数据的xhr(XML Http Request)对象
                              //         
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);//------获取返回的信息
									if (jsonData.success == 'true') {
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
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
													msg : '数据删除失败!' + errorMsg,
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
				
			}
			} else {												   
				Ext.Msg.show({										     //--------没有选择行记录的时候
							title : '提示',
							msg : '请选择需要删除的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	
	var editor = new Ext.ux.grid.RowEditor({                           //---------打一个可以编辑的表格补丁
		saveText : '更新',                       
		cancelText : '取消',
		commitChangesText : '提交',
		errorText : '错误'
	});
	
	var btnAddwin = new Ext.Toolbar.Button({
		text : '添加',
		tooltip : '添加',
		iconCls : 'icon-add',
		id:'add_btn',
		disabled:Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
		handler : function(thiz) { 									// ------------点击触发的事件
			var a = new SSGRPStore({										    // ------------创建一条新数据
				SSGRPDesc : ''
			});
			editor.stopEditing();
			ds.insert(0, a); 											// -------------将此数据插入到最上面
			grid.getSelectionModel().selectRow(0);
			editor.startEditing(0);
		},
		scope : this													// -------------作用域
	});
	
	var SSGRPStore = Ext.data.Record.create([				        // -------------列的映射
						        {   name : 'SSGRPRowId',
									mapping : 'SSGRPRowId',
									type : 'string'
								}, {
									name : 'SSGRPDesc',
									mapping : 'SSGRPDesc',
									type : 'string'
								}, {
									name : 'SSGRPCode',
									mapping : 'SSGRPCode',
									type : 'string'
								}]);
    //------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------
	var ds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ // ---------通过HttpProxy的方式读取原始数据
			url : SSGRP_ACTION_URL
				// ---------调用的动作
		}),
		reader : new Ext.data.JsonReader({ // ---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		}, SSGRPStore),
		listeners : { // ---------对数据集进行监听
			'update' : function(thiz, record, operation) { // ---------当数据有更新的时候触发的事件
				var startIndex = grid.getBottomToolbar().cursor;// 获取当前页开始的记录数
				//Ext.MessageBox.confirm('提示', '确定要提交更新的数据吗?', function(btn) {
				//			if (btn == 'yes') { // -------点击确定按钮后继续执行更新操作
								var user = thiz.getAt(thiz.indexOf(record)).data; // ---------得到此条数据
								if (typeof(user.SSGRPRowId) == 'undefined') {
									user.SSGRPRowId = "";
								}
								if (operation == Ext.data.Record.EDIT) { // ---------如果此数据有改动触发的事件
									thiz.commitChanges(); // ----------提交数据
									Ext.Ajax.request({ // -----------Ajax进行数据提交
										url : SSGRP_SAVE_ACTION_URL,
										method : 'POST',
										params : 'SSGRPRowId='+ user.SSGRPRowId // ------------参数列表
												+ '&SSGRPDesc='+ user.SSGRPDesc,
										
										callback : function(options, success, response) {
											//Ext.MessageBox.hide();
											if (success) {//请求成功	
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true')
												{   
													thiz.commitChanges();
													Ext.Msg.show({
														title : '提示',
														msg : '保存成功！',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn){
															var startIndex = grid.getBottomToolbar().cursor;
															grid.getStore().load({ // -----------重新载入数据
																	params : { // -----------参数
																		start : 0,
																		limit : pagesize,
																		RowId : jsonData.id
																		
																	}
																});
														}	
													});
													grid.getView().refresh();
												}
												else {
													//alert(jsonData.errorinfo);
													thiz.rejectChanges();//请求失败,回滚本地记录
													var errorMsg = '';
													if (jsonData.errorinfo) {
														errorMsg = '<br/>错误信息:'+ jsonData.errorinfo
													}
													Ext.Msg.show({
																title : '提示',
																msg : '保存失败！' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK,
																fn : function(btn){
																var startIndex = grid.getBottomToolbar().cursor;
																	grid.getStore().load({ // -----------重新载入数据
																			params : { // -----------参数
																				start : startIndex,
																				limit : pagesize
																			}
																		});
																}
													});
													grid.getView().refresh();
												}
											} 
											else {
												Ext.Msg.show({
															title : '提示',
															msg : '异步通讯失败,请检查网络连接！',
															icon : Ext.Msg.ERROR,
															buttons : Ext.Msg.OK
														});
											}
										}
									});

								}
			}
		}
	});
	// -------------------加载数据----------------- 
	ds.load({
				params : {												  // ----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          // ----------加载完成后执行的回调函数
				
					 //参数records表示获得的数据 options表示执行load时传递的参数 success表示是否加载成功
					 //Ext.Msg.alert('info', '加载完毕, success = '+records.length);
				}
			});
			
	//---------分页工具条-----------
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,											     //-----------刚ds发生load事件时会触发paging
				displayInfo : false,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	//--------增删改工具条-----------
	var tbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnAddwin, '-', btnDel,'-']			                 //------------通过'-'连接每个按钮也可以用'separator'代替
		});	
	//---------搜索按钮-----------
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				//text : '搜索',
				handler : function() {                                  //-----------执行回调函数
				grid.getStore().baseParams={							//-----------模糊查询	
					
						desc :  Ext.getCmp("TextDesc").getValue()
						
				};
				grid.getStore().load({									//-----------加载查询出来的数据
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}
			});		
	//--------刷新按钮-----------
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				//text : '重置',
				handler : function() {
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
	//---------将工具条放在一起-----------
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [btnSearch,'-', {
							xtype : 'textfield',
							id : 'TextDesc',
							width:70
						},'-', btnRefresh, '->'],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	//---------创建grid-----------
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'west',
				width:220,
				minSize: 220,
				maxSize: 300,
				store : ds,											//----------------表格的数据集
				plugins: [editor],  
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'SSGRP_RowId',
							sortable : true,
							dataIndex : 'SSGRPRowId',
							hidden : true                          //-----------------隐藏掉rowid
						},{
							header : '安全组代码',
							sortable : true,
							dataIndex : 'SSGRPCode',
							editor:{xtype: 'textfield'}
						},{
							header : '安全组描述',
							sortable : true,
							dataIndex : 'SSGRPDesc',
							editor:{xtype: 'textfield'}
						}],
				stripeRows : true,                                //------------------显示斑马线
				title : '安全组',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								
				},
				bbar : paging,                                    //-----------------底部状态栏
				tbar : tb, 
				stateId : 'grid'
			});
	*/
			
	// 删除功能
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler : DelData=function() {   
			if (grid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();
						var rows = gsm.getSelections();
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('SSGRPRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL, 
							method : 'POST',
							params : {
								'id' : rows[0].get('SSGRPRowId')
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
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
												
												SSGRPBaseInfoWinform.getForm().reset();
												
												///2017-10-13  安全组，选择记录-删除/重置后右侧安全组配置和菜单配置依然显示被选中信息的信息
												//var htmlS1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+"websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID=''&ID=''"+"'></iframe>";
												//Ext.getCmp("tabset").update(htmlS1);
												//var htmlM1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+"epr.groupsettings.editmenusecurity.csp?GroupDR=''&ID=''&SSGRPDesc=''"+"'></iframe>";
												//Ext.getCmp("tabmenu").update(htmlM1);
												
												
												var url1= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlS1","");
												url1+="&MWToken="+websys_getMWToken()
												if ('undefined'!==typeof websys_getMWToken)
										        {
													url1 += "&MWToken="+websys_getMWToken() //20230209 增加token
												}
												var htmlS1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>";
												Ext.getCmp("tabset").update(htmlS1);
												
												var url2= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlM1","");
												if ('undefined'!==typeof websys_getMWToken)
										        {
													url2 += "&MWToken="+websys_getMWToken() //20230209 增加token
												}
												var htmlM1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url2+"&SingleHospId="+hospComp.getValue()+"'></iframe>";
												Ext.getCmp("tabmenu").update(htmlM1);
				
												SSORDgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize  
																}	
														});	
												OSTATgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize  
																}	
														});	
												HOSPgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize  
																}	
														});	
												STgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize  
																}	
														});
												copygrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize  
																}	
														});
	
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});
	

		
	//新增的form
	var SSGRPAddWinform = new Ext.FormPanel({
				id : 'SSGRPAdd-form-save',
				//baseCls : 'x-plain',//form透明,不显示框框
				URL : Set_SAVE_ACTION_URL,
				title:'基本信息',
				labelAlign : 'right',
				labelWidth :300,
				split : true,
				autoScroll:true,  ///滚动条
				frame : true,
				//buttonAlign : 'center',
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'SSGRPRowId',mapping:'SSGRPRowId'},
                                        {name: 'SSGRPDesc',mapping:'SSGRPDesc'},
                                        {name: 'SSGRPCode',mapping:'SSGRPCode'},
                                        {name: 'SSGRPActiveFlag',mapping:'SSGRPActiveFlag'},
                                        {name: 'SSGRPGroupDr',mapping:'SSGRPGroupDr'},
                                        {name: 'SSGRPStartDate',mapping:'SSGRPStartDate'},
                                        {name: 'SSGRPEndDate',mapping:'SSGRPEndDate'},
                                        {name: 'SSGRPSeqNo',mapping:'SSGRPSeqNo'},
                                        {name: 'SSGRPPYCode',mapping:'SSGRPPYCode'},
                                        {name: 'SSGRPWBCode',mapping:'SSGRPWBCode'},
                                        {name: 'SSGRPMark',mapping:'SSGRPMark'},
                                          //bed
                                        {name: 'SSGRPWardViewLocListDR',mapping:'SSGRPWardViewLocListDR'},
                                        {name: 'SSGRPWardPlaceLocListDR',mapping:'SSGRPWardPlaceLocListDR'},
                                        {name: 'SSGRPAllowDeleteBedTransactions',mapping:'SSGRPAllowDeleteBedTransactions'},
                                        {name: 'SSGRPRestrictWardsToDepartment',mapping:'SSGRPRestrictWardsToDepartment'},
                                        
                                        //booking
                                         {name: 'SSGRPAllowBookOutsideRange',mapping:'SSGRPAllowBookOutsideRange'},
                                        {name: 'SSGRPAllowedtoBookOR',mapping:'SSGRPAllowedtoBookOR'},
                                        {name: 'SSGRPAllowMultipleServAdhoc',mapping:'SSGRPAllowMultipleServAdhoc'},
                                        {name: 'SSGRPAllowOverBookRB',mapping:'SSGRPAllowOverBookRB'},
                                        {name: 'SSGRPAllowOverBookOnSlotZero',mapping:'SSGRPAllowOverBookOnSlotZero'},
                                        {name: 'SSGRPAllowUndoAppt',mapping:'SSGRPAllowUndoAppt'},
                                        {name: 'SSGRPAllowOverPayorRestrict',mapping:'SSGRPAllowOverPayorRestrict'},
                                        {name: 'SSGRPChkFutureAppts',mapping:'SSGRPChkFutureAppts'},
                                         {name: 'SSGRPNotBookOutSess',mapping:'SSGRPNotBookOutSess'},
                                          {name: 'SSGRPNotExcLoadLevelOverrides',mapping:'SSGRPNotExcLoadLevelOverrides'},
                                           {name: 'SSGRPNAllAddPastAppt',mapping:'SSGRPNAllAddPastAppt'},
                                            {name: 'SSGRPDFLocListDR',mapping:'SSGRPDFLocListDR'},
                                           
                                            //billing
                                            {name: 'SSGRPAllowDiscPaidOrder',mapping:'SSGRPAllowDiscPaidOrder'},
                                        {name: 'SSGRPRoundingAutomatic',mapping:'SSGRPRoundingAutomatic'},
                                        {name: 'SSGRPRoundingOnPayment',mapping:'SSGRPRoundingOnPayment'},
                                        
                                        //clinical
                                        {name: 'SSGRPAllowOSFEdit24hrs',mapping:'SSGRPAllowOSFEdit24hrs'},
                                        {name: 'SSGRPOrdersPrevEpisode',mapping:'SSGRPOrdersPrevEpisode'},
                                        {name: 'SSGRPClinicalLocListDr',mapping:'SSGRPClinicalLocListDr'},
                                        {name: 'SSGRPDisplayDiagnProcDRG',mapping:'SSGRPDisplayDiagnProcDRG'},
                                        {name: 'SSGRPShowAllPatientsInNWB',mapping:'SSGRPShowAllPatientsInNWB'},
                                         
                                         	//discharge
                                         		{name: 'SSGRPAutoMedDischarge',mapping:'SSGRPAutoMedDischarge'},
                                        {name: 'SSGRPDischargeLocList',mapping:'SSGRPDischargeLocList'},
                                        //general
                                         {name: 'SSGRPAllowSendMsgAll',mapping:'SSGRPAllowSendMsgAll'},
                                        {name: 'SSGRPEnableSystemCT',mapping:'SSGRPEnableSystemCT'},
                                        {name: 'SSGRPRestrictLocForGrHospitals',mapping:'SSGRPRestrictLocForGrHospitals'},
                                        {name: 'SSGRPSecurityLevel',mapping:'SSGRPSecurityLevel'},
                                        {name: 'SSGRPPasswordDaysToExpire',mapping:'SSGRPPasswordDaysToExpire'},
                                        {name: 'SSGRPInactivityTimeOut',mapping:'SSGRPInactivityTimeOut'},
                                            
                                        
                                        ////operating
                                         {name: 'SSGRPAllowChangeDepOT',mapping:'SSGRPAllowChangeDepOT'},
                                        {name: 'SSGRPNAllORBookNA',mapping:'SSGRPNAllORBookNA'},
                                        {name: 'SSGRPNAllORBookNoSess',mapping:'SSGRPNAllORBookNoSess'},
                                        {name: 'SSGRPNAllORBookPast',mapping:'SSGRPNAllORBookPast'},
                                        {name: 'SSGRPWarnORBookingMoveRes',mapping:'SSGRPWarnORBookingMoveRes'},
                                        {name: 'SSGRPDontBookOutsideOTSchedule',mapping:'SSGRPDontBookOutsideOTSchedule'},
                                        
                                        //orders
                                         {name: 'SSGRPAllowToChangeOEStatus',mapping:'SSGRPAllowToChangeOEStatus'},
                                        {name: 'SSGRPAllowDiscOrdPackedPres',mapping:'SSGRPAllowDiscOrdPackedPres'},
                                        {name: 'SSGRPAllowedSeeSEnsitRes',mapping:'SSGRPAllowedSeeSEnsitRes'},
                                        {name: 'SSGRPCheckApproved',mapping:'SSGRPCheckApproved'},
                                        {name: 'SSGRPDefaultDoseEquiv',mapping:'SSGRPDefaultDoseEquiv'},
                                        {name: 'SSGRPDisableAddAll',mapping:'SSGRPDisableAddAll'},
                                        {name: 'SSGRPDiscontinueExecOrders',mapping:'SSGRPDiscontinueExecOrders'},
                                        {name: 'SSGRPIgnoreOrderRestrictions',mapping:'SSGRPIgnoreOrderRestrictions'},
                                        {name: 'SSGRPJobOE',mapping:'SSGRPJobOE'},
                                        {name: 'SSGRPMinimizeOEUpdate',mapping:'SSGRPMinimizeOEUpdate'},
                                        {name: 'SSGRPRetainOrderCategory',mapping:'SSGRPRetainOrderCategory'},
                                        {name: 'SSGRPPrice',mapping:'SSGRPPrice'},
                                        {name: 'SSGRPSuppressPin',mapping:'SSGRPSuppressPin'},
                                        
                                        
                                        ///paper
                                        {name: 'SSGRPAllowIssueArchiveMR',mapping:'SSGRPAllowIssueArchiveMR'},
                                        {name: 'SSGRPRestrictMRTypeCurrHosp',mapping:'SSGRPRestrictMRTypeCurrHosp'},
                                        {name: 'SSGRPAllowActivateVolume',mapping:'SSGRPAllowActivateVolume'},
                                        {name: 'SSGRPAllowNewMRTypesPat',mapping:'SSGRPAllowNewMRTypesPat'},
                                        
                                        
                                        //patient
                                            {name: 'SSGRPWaitListStatusDR',mapping:'SSGRPWaitListStatusDR'},
                                        {name: 'SSGRPEmergencyLocListDR',mapping:'SSGRPEmergencyLocListDR'},
                                        {name: 'SSGRPHealthPromLocListDR',mapping:'SSGRPHealthPromLocListDR'},
                                        {name: 'SSGRPInPatLocListDR',mapping:'SSGRPInPatLocListDR'},
                                        //临时科室列表?
                                         {name: 'SSGRPTempPatLocList',mapping:'SSGRPTempPatLocList'},
                                         {name: 'SSGRPOutPatLocListDR',mapping:'SSGRPOutPatLocListDR'},
                                         {name: 'SSGRPOnlyOutpatUnitsForMyHospit',mapping:'SSGRPOnlyOutpatUnitsForMyHospit'},
                                         {name: 'SSGRPInPatTransferListDR',mapping:'SSGRPInPatTransferListDR'},
                                         {name: 'SSGRPRadLocList',mapping:'SSGRPRadLocList'},
                                         {name: 'SSGRPWaitListLocListDR',mapping:'SSGRPWaitListLocListDR'},
                                        {name: 'SSGRPWLStatusListDR',mapping:'SSGRPWLStatusListDR'},
                                       {name: 'SSGRPWardAttendLocListDR',mapping:'SSGRPWardAttendLocListDR'},
                                       {name: 'SSGRPOnlyInpatUnitsForMyHospita',mapping:'SSGRPOnlyInpatUnitsForMyHospita'},
                                       
                                       
                                       ///patient2
                                        {name: 'SSGRPAllowDeleteEpisode',mapping:'SSGRPAllowDeleteEpisode'},
                                        {name: 'SSGRPAllowedAddOrdersReview',mapping:'SSGRPAllowedAddOrdersReview'},
                                       // {name: 'SSGRPAllowBookPastGuarDateWL',mapping:'SSGRPAllowBookPastGuarDateWL'},
                                        {name: 'SSGRPAllowToChangeFamilyDoctor',mapping:'SSGRPAllowToChangeFamilyDoctor'},
                                        {name: 'SSGRPAllowDeleteDiagOtherUs',mapping:'SSGRPAllowDeleteDiagOtherUs'},
                                        {name: 'SSGRPAllowEditEpLogLoc',mapping:'SSGRPAllowEditEpLogLoc'},
                                        {name: 'SSGRPAllowEditWLStatusTreated',mapping:'SSGRPAllowEditWLStatusTreated'},
                                        {name: 'SSGRPAllowViewVIPPatients',mapping:'SSGRPAllowViewVIPPatients'},
                                        {name: 'SSGRPShowPatientSearch',mapping:'SSGRPShowPatientSearch'},
                                        {name: 'SSGRPDisplayDiagnosis',mapping:'SSGRPDisplayDiagnosis'},
                                        {name: 'SSGRPCheckOrdersCovered',mapping:'SSGRPCheckOrdersCovered'},
                                        {name: 'SSGRPShowOnlyIPUnitsForWL',mapping:'SSGRPShowOnlyIPUnitsForWL'},
                                        {name: 'SSGRPRestrictSearchEMR',mapping:'SSGRPRestrictSearchEMR'},
                                        {name: 'SSGRPShowAllLocations',mapping:'SSGRPShowAllLocations'},
                                        {name: 'SSGRPShowPreadmafterAppoint',mapping:'SSGRPShowPreadmafterAppoint'},
                                        {name: 'SSGRPMoveToDefaultBed',mapping:'SSGRPMoveToDefaultBed'},
                                        {name: 'SSGRPWLAuditLetterDays',mapping:'SSGRPWLAuditLetterDays'},
                                        {name: 'SSGRPChangeDataAfterDischarge',mapping:'SSGRPChangeDataAfterDischarge'},
                                        
                                        
                                        //stock
                                        
                                	 {name: 'SSGRPAllowEditPriceGR',mapping:'SSGRPAllowEditPriceGR'},
                                        {name: 'SSGRPAllowToChangeAgrPrice',mapping:'SSGRPAllowToChangeAgrPrice'},
                                        //{name: 'SSGRPAllowToAddItemToVendPortfolio',mapping:'SSGRPAllowToAddItemToVendPortfolio'},
                                        {name: 'SSGRPAllowAddStockItem',mapping:'SSGRPAllowAddStockItem'},
                                      // {name: 'SSGRPAllowToAddItemToLocPortfolio',mapping:'SSGRPAllowToAddItemToLocPortfolio'},
                                       {name: 'SSGRPOnePOforEveryVendor',mapping:'SSGRPOnePOforEveryVendor'},
                                       {name: 'SSGRPConsReasonMandatory',mapping:'SSGRPConsReasonMandatory'},
                                       {name: 'SSGRPUserPOReferenceNotMandator',mapping:'SSGRPUserPOReferenceNotMandator'},
                                       {name: 'SSGRPDefaultPOReferenceDR',mapping:'SSGRPDefaultPOReferenceDR'},
                                       {name: 'SSGRPMaxPOAmount',mapping:'SSGRPMaxPOAmount'}
                                        
                                        
                                        
                                        
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'SSGRPRowId1',
							xtype:'textfield',
							fieldLabel : 'SSGRPRowId',
							name : 'SSGRPRowId',
							hideLabel : 'True',
							hidden : true			
						},{
							xtype:'fieldset',
							title:'基本信息',
							items:[{
							id:'SSGRPCode1',
							width:200,
							xtype:'textfield',
							fieldLabel: "<span style='color:red;'>*</span>代码",
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPCode1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPCode1')),
							name : 'SSGRPCode'
						},{
							id:'SSGRPDesc1',
							width:200,
							xtype:'textfield',
							fieldLabel: "<span style='color:red;'>*</span>描述",
							allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPDesc1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPDesc1')),
							name : 'SSGRPDesc',
							listeners :{
								'blur' : function(){
						    		//失焦自动填写拼音码和五笔码
					        		var Desc=Ext.getCmp("SSGRPDesc1").getValue()
					        		if (Desc!="")
					        		{
					        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
								        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
								        Ext.getCmp("SSGRPPYCode1").setValue(PYCode)  
								        Ext.getCmp("SSGRPWBCode1").setValue(WBCode)
					        		}
						    	}
							}
						},{
							xtype : 'bdpcombo',
							width:200,
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '上级安全组',
							hiddenName : 'SSGRPGroupDr',	
							id : 'SSGRPGroupDr1',
							store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : SSGroup_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
									totalProperty : 'total',
									root : 'data',
									successProperty : 'success'
								}, [{ name:'SSGRPRowId',mapping:'SSGRPRowId'},
									{name:'SSGRPDesc',mapping:'SSGRPDesc'} ])
							}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'SSGRPDesc',
							valueField : 'SSGRPRowId'
						},{
							fieldLabel:'有效',
							xtype : 'checkbox',
							name : 'SSGRPActiveFlag',
							id:'SSGRPActiveFlag1',
							inputValue : 'Y',
							checked:true
						} ,{
							xtype : 'datefield',
							fieldLabel : "<span style='color:red;'>*</span>开始日期",
							name :'SSGRPStartDate',
							id:'SSGRPStartDate1',
							allowBlank:false,
							width:200,
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPStartDate1')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPStartDate1'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'SSGRPEndDate',
							id:'SSGRPEndDate1',
							width:200,
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPEndDate1')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPEndDate1'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						},{
							id:'SSGRPSeqNo1',
							width:200,
							xtype:'numberfield',
							fieldLabel: "顺序号",
							minValue : 0,
							allowNegative : false,//不允许输入负数
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPSeqNo1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPSeqNo1')),
							name : 'SSGRPSeqNo'
						},{
							id:'SSGRPPYCode1',
							width:200,
							xtype:'textfield',
							fieldLabel: "拼音码",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPPYCode1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPPYCode1')),
							name : 'SSGRPPYCode'
						},{
							id:'SSGRPWBCode1',
							width:200,
							xtype:'textfield',
							fieldLabel: "五笔码",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPWBCode1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPWBCode1')),
							name : 'SSGRPWBCode'
						},{
							id:'SSGRPMark1',
							width:200,
							xtype:'textfield',
							fieldLabel: "备注",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPMark1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPMark1')),
							name : 'SSGRPMark'
							
						}]},{
							xtype:'fieldset',
							title:'Bed Management',     //1
							items:[{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病房列表允许浏览',
				hiddenName : 'SSGRPWardViewLocListDR',	
				id : 'SSGRPWardViewLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病房列表允许安置病人',
				hiddenName : 'SSGRPWardPlaceLocListDR',
				id : 'SSGRPWardPlaceLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			},{
				fieldLabel:'允许删除床位合约',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteBedTransactions',
				id:'SSGRPAllowDeleteBedTransactions1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'限制病区到病房',
				xtype : 'checkbox',
				name : 'SSGRPRestrictWardsToDepartment',
				id:'SSGRPRestrictWardsToDepartment1',
				inputValue : 'Y',
				checked:false
			}]
						},{
							xtype:'fieldset',
							title:'Booking',   //2
							items:[{
				fieldLabel:'允许在排班时间外进行预约',
				xtype : 'checkbox',
				name : 'SSGRPAllowBookOutsideRange',
				id:'SSGRPAllowBookOutsideRange1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许预约手术时间/顺序',
				xtype : 'checkbox',
				name : 'SSGRPAllowedtoBookOR',
				id:'SSGRPAllowedtoBookOR1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许临时预约多项服务',
				xtype : 'checkbox',
				name : 'SSGRPAllowMultipleServAdhoc',
				id:'SSGRPAllowMultipleServAdhoc1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'无论会话最大数值多少允许超额预约',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowOverBookRB',
				id:'SSGRPAllowOverBookRB1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'当槽覆盖为0时允许超额预约',
				xtype : 'checkbox',
				name : 'SSGRPAllowOverBookOnSlotZero',
				id:'SSGRPAllowOverBookOnSlotZero1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许撤销将一个科室的order拖放到时间表',///?
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowUndoAppt',
				id:'SSGRPAllowUndoAppt1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许忽略支付者限制',
				xtype : 'checkbox',
				name : 'SSGRPAllowOverPayorRestrict',
				id:'SSGRPAllowOverPayorRestrict1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'检查将来的约定',
				xtype : 'checkbox',
				name : 'SSGRPChkFutureAppts',
				id:'SSGRPChkFutureAppts1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许会话时间之外的预约',
				xtype : 'checkbox',
				name : 'SSGRPNotBookOutSess',
				id:'SSGRPNotBookOutSess1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'槽覆盖不允许超过负载水平',
				xtype : 'checkbox',
				name : 'SSGRPNotExcLoadLevelOverrides',
				id:'SSGRPNotExcLoadLevelOverrides1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许添加以往的约定',
				xtype : 'checkbox',
				name : 'SSGRPNAllAddPastAppt',
				id:'SSGRPNAllAddPastAppt1',
				inputValue : 'Y',
				checked:false
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '部门职能科室列表',
				hiddenName : 'SSGRPDFLocListDR',	
				id : 'SSGRPDFLocListDR1',	
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}]	
						},{
							xtype:'fieldset',
							title:'Billing and Cashiers', //3
							items:[{
				fieldLabel:'允许收到账单/打印账单后停止订单',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowDiscPaidOrder',
				id:'SSGRPAllowDiscPaidOrder1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'自动四舍五入',
				xtype : 'checkbox',
				name : 'SSGRPRoundingAutomatic',
				id:'SSGRPRoundingAutomatic1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'付款自动四舍五入',
				xtype : 'checkbox',
				name : 'SSGRPRoundingOnPayment',
				id:'SSGRPRoundingOnPayment1',
				inputValue : 'Y',
				checked:false
			
			}]	
						},{
							xtype:'fieldset',
							title:'Clinical and EMR',   //4
							items:[{
				fieldLabel:'允许在24h内编辑主观和客观结果',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowOSFEdit24hrs',
				id:'SSGRPAllowOSFEdit24hrs1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'临床工作台启用充分患者搜索',
				xtype : 'checkbox',
				name : 'SSGRPOrdersPrevEpisode',
				id:'SSGRPOrdersPrevEpisode1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'在分配的病区显示所有病人',
				xtype : 'checkbox',
				name : 'SSGRPShowAllPatientsInNWB',
				id:'SSGRPShowAllPatientsInNWB1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只显示电子病历中DRG排序的诊断和程序',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPDisplayDiagnProcDRG',
				id:'SSGRPDisplayDiagnProcDRG1',
				inputValue : 'Y',
				checked:false
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '临床科室列表',
				hiddenName : 'SSGRPClinicalLocListDr',
				id : 'SSGRPClinicalLocListDr1',		
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'Discharge',   //5
							items:[{
				fieldLabel:'自动化医疗卸货',
				xtype : 'checkbox',
				name : 'SSGRPAutoMedDischarge',
				id:'SSGRPAutoMedDischarge1',
				inputValue : 'Y',
				checked:false
			
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '卸货科室列表',
				hiddenName : 'SSGRPDischargeLocList',	
				id : 'SSGRPDischargeLocList1',	
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'General System Information',   //6
							items:[{
				fieldLabel:'允许向所有用户发送信息',
				xtype : 'checkbox',
				name : 'SSGRPAllowSendMsgAll',
				id:'SSGRPAllowSendMsgAll1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许添加删除系统代码表',
				xtype : 'checkbox',
				name : 'SSGRPEnableSystemCT',
				id:'SSGRPEnableSystemCT1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'对组医院限制科室访问',
				xtype : 'checkbox',
				name : 'SSGRPRestrictLocForGrHospitals',
				id:'SSGRPRestrictLocForGrHospitals1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel : '安全等级',
				xtype:'numberfield',
				width:200,
				id:'SSGRPSecurityLevel1',
				name : 'SSGRPSecurityLevel'
			},{
				fieldLabel : '在此分钟内不活动则超时',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPInactivityTimeOut1',
				name : 'SSGRPInactivityTimeOut'
			},{
				fieldLabel : '在此天数后密码到期',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPPasswordDaysToExpire1',
				name : 'SSGRPPasswordDaysToExpire'
			}
							
							]},{
							xtype:'fieldset',
							title:'Operating Theatre Workbenth',   //7
							items:[{
				fieldLabel:'允许改变部门',
				xtype : 'checkbox',
				name : 'SSGRPAllowChangeDepOT',
				id:'SSGRPAllowChangeDepOT1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在标记不可用的区域放置预约',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPNAllORBookNA',
				id:'SSGRPNAllORBookNA1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在非会话区域放置预约',
				xtype : 'checkbox',
				name : 'SSGRPNAllORBookNoSess',
				id:'SSGRPNAllORBookNoSess1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在过去时间放置预约',
				xtype : 'checkbox',
				name : 'SSGRPNAllORBookPast',
				id:'SSGRPNAllORBookPast1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在时间表外预约',
				xtype : 'checkbox',
				name : 'SSGRPDontBookOutsideOTSchedule',
				id:'SSGRPDontBookOutsideOTSchedule1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'当用户将预约转移到其他资源时发出警告',
				xtype : 'checkbox',
				name : 'SSGRPWarnORBookingMoveRes',
				id:'SSGRPWarnORBookingMoveRes1',
				inputValue : 'Y',
				checked:false
			}
							
							]},{
							xtype:'fieldset',
							title:'Order and Results',   //8
							items:[{
				fieldLabel:'执行后允许改变医嘱状态',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeOEStatus',
				id:'SSGRPAllowToChangeOEStatus1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'批量处方允许停止医嘱',
				xtype : 'checkbox',
				name : 'SSGRPAllowDiscOrdPackedPres',
				id:'SSGRPAllowDiscOrdPackedPres1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'可以浏览敏感结果',
				xtype : 'checkbox',
				name : 'SSGRPAllowedSeeSEnsitRes',
				id:'SSGRPAllowedSeeSEnsitRes1',
				inputValue : 'Y',
				checked:false	
			},{
				fieldLabel:'检查被认可',
				xtype : 'checkbox',
				name : 'SSGRPCheckApproved',
				id:'SSGRPCheckApproved1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'默认相等的剂量',
				xtype : 'checkbox',
				name : 'SSGRPDefaultDoseEquiv',
				id:'SSGRPDefaultDoseEquiv1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口"重复所有"按钮不可用',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPDisableAddAll',
				id:'SSGRPDisableAddAll1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'停止被执行的医嘱',
				xtype : 'checkbox',
				name : 'SSGRPDiscontinueExecOrders',
				id:'SSGRPDiscontinueExecOrders1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口不需要PIN值',
				xtype : 'checkbox',
				name : 'SSGRPSuppressPin',
				id:'SSGRPSuppressPin1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'忽略医嘱限制',
				xtype : 'checkbox',
				name : 'SSGRPIgnoreOrderRestrictions',
				id:'SSGRPIgnoreOrderRestrictions1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'aOET11',
				xtype : 'checkbox',
				name : 'SSGRPJobOE',
				id:'SSGRPJobOE1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'更新时最小化医嘱入口',
				xtype : 'checkbox',
				name : 'SSGRPMinimizeOEUpdate',
				id:'SSGRPMinimizeOEUpdate1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口保留医嘱分类',
				xtype : 'checkbox',
				name : 'SSGRPRetainOrderCategory',
				id:'SSGRPRetainOrderCategory1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'显示医嘱价格',
				xtype : 'checkbox',
				name : 'SSGRPPrice',
				id:'SSGRPPrice1',
				inputValue : 'Y',
				checked:false
			
			}
							
							]},{
							xtype:'fieldset',
							title:'Paper Record Tracking',   //9
							items:[{
				fieldLabel:'允许问题/结果存入医疗记录',
				xtype : 'checkbox',
				name : 'SSGRPAllowIssueArchiveMR',
				id:'SSGRPAllowIssueArchiveMR1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'对当前医院类型限制磁共振类型',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPRestrictMRTypeCurrHosp',
				id:'SSGRPRestrictMRTypeCurrHosp1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许激活和失活量',
				xtype : 'checkbox',
				name : 'SSGRPAllowActivateVolume',
				id:'SSGRPAllowActivateVolume1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许为病人创建新的磁共振类型',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowNewMRTypesPat',
				id:'SSGRPAllowNewMRTypesPat1',
				inputValue : 'Y',
				checked:false
			}
							
							]},{
							xtype:'fieldset',
							title:'Patient Management',   //10
							items:[{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认等候列表状态',
				hiddenName : 'SSGRPWaitListStatusDR',
				id : 'SSGRPWaitListStatusDR1',
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : WLS_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSRowId',mapping:'WLSRowId'},
							{name:'WLSDesc',mapping:'WLSDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				displayField : 'WLSDesc',
				valueField : 'WLSRowId'
			}, {
			
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '急诊科室列表',
				hiddenName : 'SSGRPEmergencyLocListDR',
				id : 'SSGRPEmergencyLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '健康促进科室列表',
				hiddenName : 'SSGRPHealthPromLocListDR',
				id : 'SSGRPHealthPromLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '住院科室列表',
				hiddenName : 'SSGRPInPatLocListDR',
				id : 'SSGRPInPatLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				fieldLabel: 'OnlyInpatUnitsForMyHospital',
				xtype : 'checkbox',
				name : 'SSGRPOnlyInpatUnitsForMyHospita',
				id:'SSGRPOnlyInpatUnitsForMyHospita1',
				inputValue : 'Y',
				checked:false
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '临时科室列表',
				hiddenName : 'SSGRPTempPatLocList',
				id : 'SSGRPTempPatLocList1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '门诊科室列表',
				hiddenName : 'SSGRPOutPatLocListDR',
				id : 'SSGRPOutPatLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				fieldLabel:'OnlyOutpatUnitsForMyHospital',
				//fieldLabel: 'OnlyOutpatUnitsForMyHospit',
				xtype : 'checkbox',
				name : 'SSGRPOnlyOutpatUnitsForMyHospit',
				id:'SSGRPOnlyOutpatUnitsForMyHospit1',
				inputValue : 'Y',//=inputValue : 'Y'
				checked:false
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '住院病人移交科室列表',
				hiddenName : 'SSGRPInPatTransferListDR',
				id : 'SSGRPInPatTransferListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '放射科室列表',
				hiddenName : 'SSGRPRadLocList',
				id : 'SSGRPRadLocList1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '等候列表科室列表',
				hiddenName : 'SSGRPWaitListLocListDR',
				id : 'SSGRPWaitListLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '等候列表状态列表',
				hiddenName : 'SSGRPWLStatusListDR',
				id : 'SSGRPWLStatusListDR1',
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : WLSL_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSLRowId',mapping:'WLSLRowId'},
							{name:'WLSLDesc',mapping:'WLSLDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'WLSLDesc',
				valueField : 'WLSLRowId'		
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病区出席者科室列表',
				hiddenName : 'SSGRPWardAttendLocListDR',
				id : 'SSGRPWardAttendLocListDR1',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'Patient Management2',   //11
							items:[{
				fieldLabel:'允许删除患病期/过程',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteEpisode',
				id:'SSGRPAllowDeleteEpisode1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'检查标志后允许增加医嘱',
				xtype : 'checkbox',
				name : 'SSGRPAllowedAddOrdersReview',
				id:'SSGRPAllowedAddOrdersReview1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许改变家庭医生',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeFamilyDoctor',
				id:'SSGRPAllowToChangeFamilyDoctor1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人出院后允许修改数据',
				xtype : 'checkbox',
				name : 'SSGRPChangeDataAfterDischarge',
				id:'SSGRPChangeDataAfterDischarge1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许删除其他用户创建的诊断',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteDiagOtherUs',
				id:'SSGRPAllowDeleteDiagOtherUs1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只允许在登陆科室编辑患病期',
				xtype : 'checkbox',
				name : 'SSGRPAllowEditEpLogLoc',
				id:'SSGRPAllowEditEpLogLoc1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'AllowEditWLStatusTreated',
				xtype : 'checkbox',
				name : 'SSGRPAllowEditWLStatusTreated',
				id:'SSGRPAllowEditWLStatusTreated1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许浏览VIP患者',
				xtype : 'checkbox',
				name : 'SSGRPAllowViewVIPPatients',
				id:'SSGRPAllowViewVIPPatients1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'在挂号时自动限制病人搜索结果',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPShowPatientSearch',
				id:'SSGRPShowPatientSearch1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人查询时显示诊断结果',
				xtype : 'checkbox',
				name : 'SSGRPDisplayDiagnosis',
				id:'SSGRPDisplayDiagnosis1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'新付款人不需要支付已经存在的医嘱',
				width:300,
				xtype : 'checkbox',
				name : 'SSGRPCheckOrdersCovered',
				id:'SSGRPCheckOrdersCovered1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只显示住院病人单元',
				xtype : 'checkbox',
				name : 'SSGRPShowOnlyIPUnitsForWL',
				id:'SSGRPShowOnlyIPUnitsForWL1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'限制患者搜索结果byLL',
				xtype : 'checkbox',
				name : 'SSGRPRestrictSearchEMR',
				id:'SSGRPRestrictSearchEMR1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人挂号时显示所有科室',
				xtype : 'checkbox',
				name : 'SSGRPShowAllLocations',
				id:'SSGRPShowAllLocations1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'预约后显示患病期信息',
				xtype : 'checkbox',
				name : 'SSGRPShowPreadmafterAppoint',
				id:'SSGRPShowPreadmafterAppoint1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'选择"转移到默认床位类型"',
				xtype : 'checkbox',
				name : 'SSGRPMoveToDefaultBed',
				id:'SSGRPMoveToDefaultBed1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel : 'WL Audit Letter Days',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPWLAuditLetterDays1',
				name : 'SSGRPWLAuditLetterDays'
			}
							
							]},{
							xtype:'fieldset',
							title:'Stock',   //12
							items:[{
				fieldLabel:'库存结果允许编辑价格和接收方式',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowEditPriceGR',
				id:'SSGRPAllowEditPriceGR1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'订单允许编辑单元价格',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeAgrPrice',
				id:'SSGRPAllowToChangeAgrPrice1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许无限制的库存物品请求',
				xtype : 'checkbox',
				name : 'SSGRPAllowAddStockItem',
				id:'SSGRPAllowAddStockItem1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'为每一个供应商创建一个订单',
				xtype : 'checkbox',
				name : 'SSGRPOnePOforEveryVendor',
				id:'SSGRPOnePOforEveryVendor1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'设置消耗原因为受限制的',
				xtype : 'checkbox',
				name : 'SSGRPConsReasonMandatory',
				id:'SSGRPConsReasonMandatory1',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'用户订单指向不受限制',
				xtype : 'checkbox',
				name : 'SSGRPUserPOReferenceNotMandator',
				id:'SSGRPUserPOReferenceNotMandator1',
				inputValue : 'Y',
				checked:false
			},{
						
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '订单默认指向',
				hiddenName : 'SSGRPDefaultPOReferenceDR',
				id : 'SSGRPDefaultPOReferenceDR1',
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : POREF_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'POREFRowId',mapping:'POREFRowId'},
							{name:'POREFDesc',mapping:'POREFDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'POREFDesc',
				valueField : 'POREFRowId'
			},{
				fieldLabel : '订单最大值',
				xtype:'numberfield',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				id:'SSGRPMaxPOAmount1',
				name : 'SSGRPMaxPOAmount'
			}
							
							]}
							
							/*,{
							xtype:'fieldset',
							title:'Bed Management',
							layout:'column',
							items:[{
										columnWidth:.5,
										layout:'form',
										items:[{
													id:'CTZIPRowId',
													xtype:'textfield',
													fieldLabel : 'CTZIPRowId',
													name : 'CTZIPRowId'
												},{
													fieldLabel : '<font color=red>*</font>代码',
													xtype:'textfield',
													id:'CTZIPCode'
													
												}, {
													fieldLabel : '<font color=red>*</font>描述',
													xtype:'textfield',
													id:'CTZIPDesc'
												
												
												}]
								},{
										columnWidth:.5,
										layout:'form',
										baseCls : 'x-plain',//form透明,不显示框框
										///style:'margin-left:20px',
										items:[{
													xtype : "textfield",
													
													fieldLabel : '<font color=red></font>健康监护区域'
													
											}]
									}]	
						}*/
				
				
				
				
				
				]
	});
	
	//详细信息的form  修改
	var SSGRPBaseInfoWinform = new Ext.FormPanel({
				id : 'SSGRPBaseInfo-form-save',
				//baseCls : 'x-plain',//form透明,不显示框框
				URL : Set_SAVE_ACTION_URL,
				labelAlign : 'right',
				labelWidth : 300,
				split : true,
				autoScroll:true,  ///滚动条
				frame : true,
				buttonAlign : 'center',
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [
                                        {name: 'SSGRPRowId',mapping:'SSGRPRowId'},
                                        {name: 'SSGRPDesc',mapping:'SSGRPDesc'},
                                        {name: 'SSGRPCode',mapping:'SSGRPCode'},
                                        {name: 'SSGRPActiveFlag',mapping:'SSGRPActiveFlag'},
                                        {name: 'SSGRPGroupDr',mapping:'SSGRPGroupDr'},
                                        {name: 'SSGRPStartDate',mapping:'SSGRPStartDate'},
                                        {name: 'SSGRPEndDate',mapping:'SSGRPEndDate'},
                                        {name: 'SSGRPSeqNo',mapping:'SSGRPSeqNo'},
                                        {name: 'SSGRPPYCode',mapping:'SSGRPPYCode'},
                                        {name: 'SSGRPWBCode',mapping:'SSGRPWBCode'},
                                        {name: 'SSGRPMark',mapping:'SSGRPMark'},
                                          //bed
                                        {name: 'SSGRPWardViewLocListDR',mapping:'SSGRPWardViewLocListDR'},
                                        {name: 'SSGRPWardPlaceLocListDR',mapping:'SSGRPWardPlaceLocListDR'},
                                        {name: 'SSGRPAllowDeleteBedTransactions',mapping:'SSGRPAllowDeleteBedTransactions'},
                                        {name: 'SSGRPRestrictWardsToDepartment',mapping:'SSGRPRestrictWardsToDepartment'},
                                        
                                        //booking
                                         {name: 'SSGRPAllowBookOutsideRange',mapping:'SSGRPAllowBookOutsideRange'},
                                        {name: 'SSGRPAllowedtoBookOR',mapping:'SSGRPAllowedtoBookOR'},
                                        {name: 'SSGRPAllowMultipleServAdhoc',mapping:'SSGRPAllowMultipleServAdhoc'},
                                        {name: 'SSGRPAllowOverBookRB',mapping:'SSGRPAllowOverBookRB'},
                                        {name: 'SSGRPAllowOverBookOnSlotZero',mapping:'SSGRPAllowOverBookOnSlotZero'},
                                        {name: 'SSGRPAllowUndoAppt',mapping:'SSGRPAllowUndoAppt'},
                                        {name: 'SSGRPAllowOverPayorRestrict',mapping:'SSGRPAllowOverPayorRestrict'},
                                        {name: 'SSGRPChkFutureAppts',mapping:'SSGRPChkFutureAppts'},
                                         {name: 'SSGRPNotBookOutSess',mapping:'SSGRPNotBookOutSess'},
                                          {name: 'SSGRPNotExcLoadLevelOverrides',mapping:'SSGRPNotExcLoadLevelOverrides'},
                                           {name: 'SSGRPNAllAddPastAppt',mapping:'SSGRPNAllAddPastAppt'},
                                            {name: 'SSGRPDFLocListDR',mapping:'SSGRPDFLocListDR'},
                                           
                                            //billing
                                            {name: 'SSGRPAllowDiscPaidOrder',mapping:'SSGRPAllowDiscPaidOrder'},
                                        {name: 'SSGRPRoundingAutomatic',mapping:'SSGRPRoundingAutomatic'},
                                        {name: 'SSGRPRoundingOnPayment',mapping:'SSGRPRoundingOnPayment'},
                                        
                                        //clinical
                                        {name: 'SSGRPAllowOSFEdit24hrs',mapping:'SSGRPAllowOSFEdit24hrs'},
                                        {name: 'SSGRPOrdersPrevEpisode',mapping:'SSGRPOrdersPrevEpisode'},
                                        {name: 'SSGRPClinicalLocListDr',mapping:'SSGRPClinicalLocListDr'},
                                        {name: 'SSGRPDisplayDiagnProcDRG',mapping:'SSGRPDisplayDiagnProcDRG'},
                                        {name: 'SSGRPShowAllPatientsInNWB',mapping:'SSGRPShowAllPatientsInNWB'},
                                         
                                         	//discharge
                                         		{name: 'SSGRPAutoMedDischarge',mapping:'SSGRPAutoMedDischarge'},
                                        {name: 'SSGRPDischargeLocList',mapping:'SSGRPDischargeLocList'},
                                        //general
                                         {name: 'SSGRPAllowSendMsgAll',mapping:'SSGRPAllowSendMsgAll'},
                                        {name: 'SSGRPEnableSystemCT',mapping:'SSGRPEnableSystemCT'},
                                        {name: 'SSGRPRestrictLocForGrHospitals',mapping:'SSGRPRestrictLocForGrHospitals'},
                                        {name: 'SSGRPSecurityLevel',mapping:'SSGRPSecurityLevel'},
                                        {name: 'SSGRPPasswordDaysToExpire',mapping:'SSGRPPasswordDaysToExpire'},
                                        {name: 'SSGRPInactivityTimeOut',mapping:'SSGRPInactivityTimeOut'},
                                            
                                        
                                        ////operating
                                         {name: 'SSGRPAllowChangeDepOT',mapping:'SSGRPAllowChangeDepOT'},
                                        {name: 'SSGRPNAllORBookNA',mapping:'SSGRPNAllORBookNA'},
                                        {name: 'SSGRPNAllORBookNoSess',mapping:'SSGRPNAllORBookNoSess'},
                                        {name: 'SSGRPNAllORBookPast',mapping:'SSGRPNAllORBookPast'},
                                        {name: 'SSGRPWarnORBookingMoveRes',mapping:'SSGRPWarnORBookingMoveRes'},
                                        {name: 'SSGRPDontBookOutsideOTSchedule',mapping:'SSGRPDontBookOutsideOTSchedule'},
                                        
                                        //orders
                                         {name: 'SSGRPAllowToChangeOEStatus',mapping:'SSGRPAllowToChangeOEStatus'},
                                        {name: 'SSGRPAllowDiscOrdPackedPres',mapping:'SSGRPAllowDiscOrdPackedPres'},
                                        {name: 'SSGRPAllowedSeeSEnsitRes',mapping:'SSGRPAllowedSeeSEnsitRes'},
                                        {name: 'SSGRPCheckApproved',mapping:'SSGRPCheckApproved'},
                                        {name: 'SSGRPDefaultDoseEquiv',mapping:'SSGRPDefaultDoseEquiv'},
                                        {name: 'SSGRPDisableAddAll',mapping:'SSGRPDisableAddAll'},
                                        {name: 'SSGRPDiscontinueExecOrders',mapping:'SSGRPDiscontinueExecOrders'},
                                        {name: 'SSGRPIgnoreOrderRestrictions',mapping:'SSGRPIgnoreOrderRestrictions'},
                                        {name: 'SSGRPJobOE',mapping:'SSGRPJobOE'},
                                        {name: 'SSGRPMinimizeOEUpdate',mapping:'SSGRPMinimizeOEUpdate'},
                                        {name: 'SSGRPRetainOrderCategory',mapping:'SSGRPRetainOrderCategory'},
                                        {name: 'SSGRPPrice',mapping:'SSGRPPrice'},
                                        {name: 'SSGRPSuppressPin',mapping:'SSGRPSuppressPin'},
                                        
                                        
                                        ///paper
                                        {name: 'SSGRPAllowIssueArchiveMR',mapping:'SSGRPAllowIssueArchiveMR'},
                                        {name: 'SSGRPRestrictMRTypeCurrHosp',mapping:'SSGRPRestrictMRTypeCurrHosp'},
                                        {name: 'SSGRPAllowActivateVolume',mapping:'SSGRPAllowActivateVolume'},
                                        {name: 'SSGRPAllowNewMRTypesPat',mapping:'SSGRPAllowNewMRTypesPat'},
                                        
                                        
                                        //patient
                                            {name: 'SSGRPWaitListStatusDR',mapping:'SSGRPWaitListStatusDR'},
                                        {name: 'SSGRPEmergencyLocListDR',mapping:'SSGRPEmergencyLocListDR'},
                                        {name: 'SSGRPHealthPromLocListDR',mapping:'SSGRPHealthPromLocListDR'},
                                        {name: 'SSGRPInPatLocListDR',mapping:'SSGRPInPatLocListDR'},
                                        //临时科室列表?
                                         {name: 'SSGRPTempPatLocList',mapping:'SSGRPTempPatLocList'},
                                         {name: 'SSGRPOutPatLocListDR',mapping:'SSGRPOutPatLocListDR'},
                                         {name: 'SSGRPOnlyOutpatUnitsForMyHospit',mapping:'SSGRPOnlyOutpatUnitsForMyHospit'},
                                         {name: 'SSGRPInPatTransferListDR',mapping:'SSGRPInPatTransferListDR'},
                                         {name: 'SSGRPRadLocList',mapping:'SSGRPRadLocList'},
                                         {name: 'SSGRPWaitListLocListDR',mapping:'SSGRPWaitListLocListDR'},
                                        {name: 'SSGRPWLStatusListDR',mapping:'SSGRPWLStatusListDR'},
                                       {name: 'SSGRPWardAttendLocListDR',mapping:'SSGRPWardAttendLocListDR'},
                                       {name: 'SSGRPOnlyInpatUnitsForMyHospita',mapping:'SSGRPOnlyInpatUnitsForMyHospita'},
                                       
                                       
                                       ///patient2
                                        {name: 'SSGRPAllowDeleteEpisode',mapping:'SSGRPAllowDeleteEpisode'},
                                        {name: 'SSGRPAllowedAddOrdersReview',mapping:'SSGRPAllowedAddOrdersReview'},
                                       // {name: 'SSGRPAllowBookPastGuarDateWL',mapping:'SSGRPAllowBookPastGuarDateWL'},
                                        {name: 'SSGRPAllowToChangeFamilyDoctor',mapping:'SSGRPAllowToChangeFamilyDoctor'},
                                        {name: 'SSGRPAllowDeleteDiagOtherUs',mapping:'SSGRPAllowDeleteDiagOtherUs'},
                                        {name: 'SSGRPAllowEditEpLogLoc',mapping:'SSGRPAllowEditEpLogLoc'},
                                        {name: 'SSGRPAllowEditWLStatusTreated',mapping:'SSGRPAllowEditWLStatusTreated'},
                                        {name: 'SSGRPAllowViewVIPPatients',mapping:'SSGRPAllowViewVIPPatients'},
                                        {name: 'SSGRPShowPatientSearch',mapping:'SSGRPShowPatientSearch'},
                                        {name: 'SSGRPDisplayDiagnosis',mapping:'SSGRPDisplayDiagnosis'},
                                        {name: 'SSGRPCheckOrdersCovered',mapping:'SSGRPCheckOrdersCovered'},
                                        {name: 'SSGRPShowOnlyIPUnitsForWL',mapping:'SSGRPShowOnlyIPUnitsForWL'},
                                        {name: 'SSGRPRestrictSearchEMR',mapping:'SSGRPRestrictSearchEMR'},
                                        {name: 'SSGRPShowAllLocations',mapping:'SSGRPShowAllLocations'},
                                        {name: 'SSGRPShowPreadmafterAppoint',mapping:'SSGRPShowPreadmafterAppoint'},
                                        {name: 'SSGRPMoveToDefaultBed',mapping:'SSGRPMoveToDefaultBed'},
                                        {name: 'SSGRPWLAuditLetterDays',mapping:'SSGRPWLAuditLetterDays'},
                                        {name: 'SSGRPChangeDataAfterDischarge',mapping:'SSGRPChangeDataAfterDischarge'},
                                        
                                        
                                        //stock
                                        
                                	 {name: 'SSGRPAllowEditPriceGR',mapping:'SSGRPAllowEditPriceGR'},
                                        {name: 'SSGRPAllowToChangeAgrPrice',mapping:'SSGRPAllowToChangeAgrPrice'},
                                        //{name: 'SSGRPAllowToAddItemToVendPortfolio',mapping:'SSGRPAllowToAddItemToVendPortfolio'},
                                        {name: 'SSGRPAllowAddStockItem',mapping:'SSGRPAllowAddStockItem'},
                                      // {name: 'SSGRPAllowToAddItemToLocPortfolio',mapping:'SSGRPAllowToAddItemToLocPortfolio'},
                                       {name: 'SSGRPOnePOforEveryVendor',mapping:'SSGRPOnePOforEveryVendor'},
                                       {name: 'SSGRPConsReasonMandatory',mapping:'SSGRPConsReasonMandatory'},
                                       {name: 'SSGRPUserPOReferenceNotMandator',mapping:'SSGRPUserPOReferenceNotMandator'},
                                       {name: 'SSGRPDefaultPOReferenceDR',mapping:'SSGRPDefaultPOReferenceDR'},
                                       {name: 'SSGRPMaxPOAmount',mapping:'SSGRPMaxPOAmount'}
                                        
                                        
                                        
                                        
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'SSGRPRowId',
							xtype:'textfield',
							fieldLabel : 'SSGRPRowId',
							name : 'SSGRPRowId',
							hideLabel : 'True',
							hidden : true			
						},{
							xtype:'fieldset',
							title:'基本信息',     //1
							items:[{
							id:'SSGRPCode',
							width:200,
							xtype:'textfield',
							fieldLabel : "<span style='color:red;'>*</span>代码",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPCode')),				
							name : 'SSGRPCode'
						},{
							id:'SSGRPDesc',
							width:200,
							xtype:'textfield',
							fieldLabel : "<span style='color:red;'>*</span>描述",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPDesc')),
							name : 'SSGRPDesc',
							listeners :{
								'blur' : function(){
						    		//失焦自动填写拼音码和五笔码
					        		var Desc=Ext.getCmp("SSGRPDesc").getValue()
					        		if (Desc!="")
					        		{
					        			var PYCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetPYCODE",Desc) 
								        var WBCode=tkMakeServerCall("web.DHCBL.BDP.FunLib","GetSWBCODE",Desc,1) 
								        Ext.getCmp("SSGRPPYCode").setValue(PYCode)  
								        Ext.getCmp("SSGRPWBCode").setValue(WBCode)
					        		}
						    	}
							}
						},{
							xtype : 'bdpcombo',
							width:200,
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '上级安全组',
							hiddenName : 'SSGRPGroupDr',	
							id : 'SSGRPGroupDr2',
							store : new Ext.data.Store({
									//autoLoad: true,
									proxy : new Ext.data.HttpProxy({ url : SSGroup_DR_QUERY_ACTION_URL }),
									reader : new Ext.data.JsonReader({
									totalProperty : 'total',
									root : 'data',
									successProperty : 'success'
								}, [{ name:'SSGRPRowId',mapping:'SSGRPRowId'},
									{name:'SSGRPDesc',mapping:'SSGRPDesc'} ])
							}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'SSGRPDesc',
							valueField : 'SSGRPRowId'
						},{
							fieldLabel:'有效',
							xtype : 'checkbox',
							name : 'SSGRPActiveFlag',
							id:'SSGRPActiveFlag',
							inputValue : 'Y',
							checked:false
						} ,{
							xtype : 'datefield',
							fieldLabel : "<span style='color:red;'>*</span>开始日期",
							name :'SSGRPStartDate',
							id:'SSGRPStartDate',
							allowBlank:false,
							width:200,
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPStartDate')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPStartDate'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'SSGRPEndDate',
							id:'SSGRPEndDate',
							width:200,
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPEndDate')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPEndDate'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }}
						},{
							id:'SSGRPSeqNo',
							width:200,
							xtype:'numberfield',
							fieldLabel: "排序号",
							minValue : 0,
							allowNegative : false,//不允许输入负数
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPSeqNo'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPSeqNo')),
							name : 'SSGRPSeqNo'
						},{
							id:'SSGRPPYCode',
							width:200,
							xtype:'textfield',
							fieldLabel: "拼音码",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPPYCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPPYCode')),
							name : 'SSGRPPYCode'
						},{
							id:'SSGRPWBCode',
							width:200,
							xtype:'textfield',
							fieldLabel: "五笔码",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPWBCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPWBCode')),
							name : 'SSGRPWBCode'
						},{
							id:'SSGRPMark',
							width:200,
							xtype:'textfield',
							fieldLabel: "备注",
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSGRPMark'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSGRPMark')),
							name : 'SSGRPMark'
							
						}]},{
							xtype:'fieldset',
							title:'Bed Management',     //1
							items:[{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病房列表允许浏览',
				hiddenName : 'SSGRPWardViewLocListDR',		
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病房列表允许安置病人',
				hiddenName : 'SSGRPWardPlaceLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			},{
				fieldLabel:'允许删除床位合约',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteBedTransactions',
				id:'SSGRPAllowDeleteBedTransactions',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'限制病区到病房',
				xtype : 'checkbox',
				name : 'SSGRPRestrictWardsToDepartment',
				id:'SSGRPRestrictWardsToDepartment',
				inputValue : 'Y',
				checked:false
			}]
						},{
							xtype:'fieldset',
							title:'Booking',   //2
							items:[{
				fieldLabel:'允许在排班时间外进行预约',
				xtype : 'checkbox',
				name : 'SSGRPAllowBookOutsideRange',
				id:'SSGRPAllowBookOutsideRange',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许预约手术时间/顺序',
				xtype : 'checkbox',
				name : 'SSGRPAllowedtoBookOR',
				id:'SSGRPAllowedtoBookOR',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许临时预约多项服务',
				xtype : 'checkbox',
				name : 'SSGRPAllowMultipleServAdhoc',
				id:'SSGRPAllowMultipleServAdhoc',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'无论会话最大数值多少允许超额预约',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowOverBookRB',
				id:'SSGRPAllowOverBookRB',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'当槽覆盖为0时允许超额预约',
				xtype : 'checkbox',
				name : 'SSGRPAllowOverBookOnSlotZero',
				id:'SSGRPAllowOverBookOnSlotZero',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许撤销将一个科室的order拖放到时间表',///?
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowUndoAppt',
				id:'SSGRPAllowUndoAppt',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许忽略支付者限制',
				xtype : 'checkbox',
				name : 'SSGRPAllowOverPayorRestrict',
				id:'SSGRPAllowOverPayorRestrict',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'检查将来的约定',
				xtype : 'checkbox',
				name : 'SSGRPChkFutureAppts',
				id:'SSGRPChkFutureAppts',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许会话时间之外的预约',
				xtype : 'checkbox',
				name : 'SSGRPNotBookOutSess',
				id:'SSGRPNotBookOutSess',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'槽覆盖不允许超过负载水平',
				xtype : 'checkbox',
				name : 'SSGRPNotExcLoadLevelOverrides',
				id:'SSGRPNotExcLoadLevelOverrides',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许添加以往的约定',
				xtype : 'checkbox',
				name : 'SSGRPNAllAddPastAppt',
				id:'SSGRPNAllAddPastAppt',
				inputValue : 'Y',
				checked:false
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '部门职能科室列表',
				hiddenName : 'SSGRPDFLocListDR',		
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}]	
						},{
							xtype:'fieldset',
							title:'Billing and Cashiers', //3
							items:[{
				fieldLabel:'允许收到账单/打印账单后停止订单',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowDiscPaidOrder',
				id:'SSGRPAllowDiscPaidOrder',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'自动四舍五入',
				xtype : 'checkbox',
				name : 'SSGRPRoundingAutomatic',
				id:'SSGRPRoundingAutomatic',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'付款自动四舍五入',
				xtype : 'checkbox',
				name : 'SSGRPRoundingOnPayment',
				id:'SSGRPRoundingOnPayment',
				inputValue : 'Y',
				checked:false
			
			}]	
						},{
							xtype:'fieldset',
							title:'Clinical and EMR',   //4
							items:[{
				fieldLabel:'允许在24h内编辑主观和客观结果',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowOSFEdit24hrs',
				id:'SSGRPAllowOSFEdit24hrs',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'临床工作台启用充分患者搜索',
				xtype : 'checkbox',
				name : 'SSGRPOrdersPrevEpisode',
				id:'SSGRPOrdersPrevEpisode',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'在分配的病区显示所有病人',
				xtype : 'checkbox',
				name : 'SSGRPShowAllPatientsInNWB',
				id:'SSGRPShowAllPatientsInNWB',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只显示电子病历中DRG排序的诊断和程序',
				width:300,
				xtype : 'checkbox',
				name : 'SSGRPDisplayDiagnProcDRG',
				id:'SSGRPDisplayDiagnProcDRG',
				inputValue : 'Y',
				checked:false
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '临床科室列表',
				hiddenName : 'SSGRPClinicalLocListDr',		
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'Discharge',   //5
							items:[{
				fieldLabel:'自动化医疗卸货',
				xtype : 'checkbox',
				name : 'SSGRPAutoMedDischarge',
				id:'SSGRPAutoMedDischarge',
				inputValue : 'Y',
				checked:false
			
			},{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '卸货科室列表',
				hiddenName : 'SSGRPDischargeLocList',		
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'General System Information',   //6
							items:[{
				fieldLabel:'允许向所有用户发送信息',
				xtype : 'checkbox',
				name : 'SSGRPAllowSendMsgAll',
				id:'SSGRPAllowSendMsgAll',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许添加删除系统代码表',
				xtype : 'checkbox',
				name : 'SSGRPEnableSystemCT',
				id:'SSGRPEnableSystemCT',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'对组医院限制科室访问',
				xtype : 'checkbox',
				name : 'SSGRPRestrictLocForGrHospitals',
				id:'SSGRPRestrictLocForGrHospitals',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel : '安全等级',
				xtype:'numberfield',
				width:200,
				id:'SSGRPSecurityLevel',
				name : 'SSGRPSecurityLevel'
			},{
				fieldLabel : '在此分钟内不活动则超时',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPInactivityTimeOut',
				name : 'SSGRPInactivityTimeOut'
			},{
				fieldLabel : '在此天数后密码到期',
				width:200,
				xtype:'numberfield',
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPPasswordDaysToExpire',
				name : 'SSGRPPasswordDaysToExpire'
			}
							
							]},{
							xtype:'fieldset',
							title:'Operating Theatre Workbenth',   //7
							items:[{
				fieldLabel:'允许改变部门',
				xtype : 'checkbox',
				name : 'SSGRPAllowChangeDepOT',
				id:'SSGRPAllowChangeDepOT',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在标记不可用的区域放置预约',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPNAllORBookNA',
				id:'SSGRPNAllORBookNA',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在非会话区域放置预约',
				xtype : 'checkbox',
				name : 'SSGRPNAllORBookNoSess',
				id:'SSGRPNAllORBookNoSess',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在过去时间放置预约',
				xtype : 'checkbox',
				name : 'SSGRPNAllORBookPast',
				id:'SSGRPNAllORBookPast',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'不允许在时间表外预约',
				xtype : 'checkbox',
				name : 'SSGRPDontBookOutsideOTSchedule',
				id:'SSGRPDontBookOutsideOTSchedule',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'当用户将预约转移到其他资源时发出警告',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPWarnORBookingMoveRes',
				id:'SSGRPWarnORBookingMoveRes',
				inputValue : 'Y',
				checked:false
			}
							
							]},{
							xtype:'fieldset',
							title:'Order and Results',   //8
							items:[{
				fieldLabel:'执行后允许改变医嘱状态',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeOEStatus',
				id:'SSGRPAllowToChangeOEStatus',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'批量处方允许停止医嘱',
				xtype : 'checkbox',
				name : 'SSGRPAllowDiscOrdPackedPres',
				id:'SSGRPAllowDiscOrdPackedPres',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'可以浏览敏感结果',
				xtype : 'checkbox',
				name : 'SSGRPAllowedSeeSEnsitRes',
				id:'SSGRPAllowedSeeSEnsitRes',
				inputValue : 'Y',
				checked:false	
			},{
				fieldLabel:'检查被认可',
				xtype : 'checkbox',
				name : 'SSGRPCheckApproved',
				id:'SSGRPCheckApproved',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'默认相等的剂量',
				xtype : 'checkbox',
				name : 'SSGRPDefaultDoseEquiv',
				id:'SSGRPDefaultDoseEquiv',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口"重复所有"按钮不可用',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPDisableAddAll',
				id:'SSGRPDisableAddAll',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'停止被执行的医嘱',
				xtype : 'checkbox',
				name : 'SSGRPDiscontinueExecOrders',
				id:'SSGRPDiscontinueExecOrders',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口不需要PIN值',
				xtype : 'checkbox',
				name : 'SSGRPSuppressPin',
				id:'SSGRPSuppressPin',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'忽略医嘱限制',
				xtype : 'checkbox',
				name : 'SSGRPIgnoreOrderRestrictions',
				id:'SSGRPIgnoreOrderRestrictions',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'aOET11',
				xtype : 'checkbox',
				name : 'SSGRPJobOE',
				id:'SSGRPJobOE',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'更新时最小化医嘱入口',
				xtype : 'checkbox',
				name : 'SSGRPMinimizeOEUpdate',
				id:'SSGRPMinimizeOEUpdate',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'医嘱入口保留医嘱分类',
				xtype : 'checkbox',
				name : 'SSGRPRetainOrderCategory',
				id:'SSGRPRetainOrderCategory',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'显示医嘱价格',
				xtype : 'checkbox',
				name : 'SSGRPPrice',
				id:'SSGRPPrice',
				inputValue : 'Y',
				checked:false
			
			}
							
							]},{
							xtype:'fieldset',
							title:'Paper Record Tracking',   //9
							items:[{
				fieldLabel:'允许问题/结果存入医疗记录',
				xtype : 'checkbox',
				name : 'SSGRPAllowIssueArchiveMR',
				id:'SSGRPAllowIssueArchiveMR',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'对当前医院类型限制磁共振类型',
				width:300,
				xtype : 'checkbox',
				name : 'SSGRPRestrictMRTypeCurrHosp',
				id:'SSGRPRestrictMRTypeCurrHosp',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许激活和失活量',
				xtype : 'checkbox',
				name : 'SSGRPAllowActivateVolume',
				id:'SSGRPAllowActivateVolume',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许为病人创建新的磁共振类型',
				xtype : 'checkbox',
				name : 'SSGRPAllowNewMRTypesPat',
				id:'SSGRPAllowNewMRTypesPat',
				inputValue : 'Y',
				checked:false
			}
							
							]},{
							xtype:'fieldset',
							title:'Patient Management',   //10
							items:[{
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '默认等候列表状态',
				hiddenName : 'SSGRPWaitListStatusDR',	
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : WLS_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSRowId',mapping:'WLSRowId'},
							{name:'WLSDesc',mapping:'WLSDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				displayField : 'WLSDesc',
				valueField : 'WLSRowId'
			}, {
			
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '急诊科室列表',
				hiddenName : 'SSGRPEmergencyLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '健康促进科室列表',
				hiddenName : 'SSGRPHealthPromLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '住院科室列表',
				hiddenName : 'SSGRPInPatLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				fieldLabel: 'OnlyInpatUnitsForMyHospital',
				xtype : 'checkbox',
				name : 'SSGRPOnlyInpatUnitsForMyHospita',
				id:'SSGRPOnlyInpatUnitsForMyHospita',
				inputValue : 'Y',
				checked:false
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '临时科室列表',
				hiddenName : 'SSGRPTempPatLocList',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '门诊科室列表',
				hiddenName : 'SSGRPOutPatLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				fieldLabel:'OnlyOutpatUnitsForMyHospital',
				//fieldLabel: 'OnlyOutpatUnitsForMyHospit',
				xtype : 'checkbox',
				name : 'SSGRPOnlyOutpatUnitsForMyHospit',
				id:'SSGRPOnlyOutpatUnitsForMyHospit',
				inputValue : 'Y',//=inputValue : 'Y'
				checked:false
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '住院病人移交科室列表',
				hiddenName : 'SSGRPInPatTransferListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '放射科室列表',
				hiddenName : 'SSGRPRadLocList',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '等候列表科室列表',
				hiddenName : 'SSGRPWaitListLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '等候列表状态列表',
				hiddenName : 'SSGRPWLStatusListDR',
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : WLSL_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'WLSLRowId',mapping:'WLSLRowId'},
							{name:'WLSLDesc',mapping:'WLSLDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'WLSLDesc',
				valueField : 'WLSLRowId'		
			}, {
				
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '病区出席者科室列表',
				hiddenName : 'SSGRPWardAttendLocListDR',
				store : new Ext.data.Store({
						//autoLoad: true,
						proxy : new Ext.data.HttpProxy({ url : LLDR_QUERY_ACTION_URL }),
						reader : new Ext.data.JsonReader({
						totalProperty : 'total',
						root : 'data',
						successProperty : 'success'
					}, [{ name:'LLRowId',mapping:'LLRowId'},
						{name:'LLDesc',mapping:'LLDesc'} ])
				}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'LLDesc',
				valueField : 'LLRowId'
			}
							
							]},{
							xtype:'fieldset',
							title:'Patient Management2',   //11
							items:[{
				fieldLabel:'允许删除患病期/过程',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteEpisode',
				id:'SSGRPAllowDeleteEpisode',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'检查标志后允许增加医嘱',
				xtype : 'checkbox',
				name : 'SSGRPAllowedAddOrdersReview',
				id:'SSGRPAllowedAddOrdersReview',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许改变家庭医生',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeFamilyDoctor',
				id:'SSGRPAllowToChangeFamilyDoctor',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人出院后允许修改数据',
				xtype : 'checkbox',
				name : 'SSGRPChangeDataAfterDischarge',
				id:'SSGRPChangeDataAfterDischarge',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许删除其他用户创建的诊断',
				xtype : 'checkbox',
				name : 'SSGRPAllowDeleteDiagOtherUs',
				id:'SSGRPAllowDeleteDiagOtherUs',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只允许在登陆科室编辑患病期',
				xtype : 'checkbox',
				name : 'SSGRPAllowEditEpLogLoc',
				id:'SSGRPAllowEditEpLogLoc',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'AllowEditWLStatusTreated',
				xtype : 'checkbox',
				name : 'SSGRPAllowEditWLStatusTreated',
				id:'SSGRPAllowEditWLStatusTreated',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许浏览VIP患者',
				xtype : 'checkbox',
				name : 'SSGRPAllowViewVIPPatients',
				id:'SSGRPAllowViewVIPPatients',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'在挂号时自动限制病人搜索结果',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPShowPatientSearch',
				id:'SSGRPShowPatientSearch',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人查询时显示诊断结果',
				xtype : 'checkbox',
				name : 'SSGRPDisplayDiagnosis',
				id:'SSGRPDisplayDiagnosis',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'新付款人不需要支付已经存在的医嘱',
				width:300,
				xtype : 'checkbox',
				name : 'SSGRPCheckOrdersCovered',
				id:'SSGRPCheckOrdersCovered',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'只显示住院病人单元',
				xtype : 'checkbox',
				name : 'SSGRPShowOnlyIPUnitsForWL',
				id:'SSGRPShowOnlyIPUnitsForWL',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'限制患者搜索结果byLL',
				xtype : 'checkbox',
				name : 'SSGRPRestrictSearchEMR',
				id:'SSGRPRestrictSearchEMR',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'病人挂号时显示所有科室',
				xtype : 'checkbox',
				name : 'SSGRPShowAllLocations',
				id:'SSGRPShowAllLocations',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'预约后显示患病期信息',
				xtype : 'checkbox',
				name : 'SSGRPShowPreadmafterAppoint',
				id:'SSGRPShowPreadmafterAppoint',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'选择"转移到默认床位类型"',
				xtype : 'checkbox',
				name : 'SSGRPMoveToDefaultBed',
				id:'SSGRPMoveToDefaultBed',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel : 'WL Audit Letter Days',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				allowDecimals : false,//不允许输入小数
				id:'SSGRPWLAuditLetterDays',
				name : 'SSGRPWLAuditLetterDays'
			}
							
							]},{
							xtype:'fieldset',
							title:'Stock',   //12
							items:[{
				fieldLabel:'库存结果允许编辑价格和接收方式',
				xtype : 'checkbox',
				width:300,
				name : 'SSGRPAllowEditPriceGR',
				id:'SSGRPAllowEditPriceGR',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'订单允许编辑单元价格',
				xtype : 'checkbox',
				name : 'SSGRPAllowToChangeAgrPrice',
				id:'SSGRPAllowToChangeAgrPrice',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'允许无限制的库存物品请求',
				xtype : 'checkbox',
				name : 'SSGRPAllowAddStockItem',
				id:'SSGRPAllowAddStockItem',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'为每一个供应商创建一个订单',
				xtype : 'checkbox',
				name : 'SSGRPOnePOforEveryVendor',
				id:'SSGRPOnePOforEveryVendor',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'设置消耗原因为受限制的',
				xtype : 'checkbox',
				name : 'SSGRPConsReasonMandatory',
				id:'SSGRPConsReasonMandatory',
				inputValue : 'Y',
				checked:false
			},{
				fieldLabel:'用户订单指向不受限制',
				xtype : 'checkbox',
				name : 'SSGRPUserPOReferenceNotMandator',
				id:'SSGRPUserPOReferenceNotMandator',
				inputValue : 'Y',
				checked:false
			},{
						
				xtype : 'bdpcombo',
				width:200,
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				loadByIdParam : 'rowid',
				listWidth:250,
				//emptyText:'请选择',
				fieldLabel : '订单默认指向',
				hiddenName : 'SSGRPDefaultPOReferenceDR',
				store : new Ext.data.Store({
							//autoLoad: true,
							proxy : new Ext.data.HttpProxy({ url : POREF_DR_QUERY_ACTION_URL }),
							reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{ name:'POREFRowId',mapping:'POREFRowId'},
							{name:'POREFDesc',mapping:'POREFDesc'} ])
					}),
				mode : 'local',
				shadow:false,
				queryParam : 'desc',
				forceSelection : true,
				selectOnFocus : false,
				//triggerAction : 'all',
				//hideTrigger: false,
				displayField : 'POREFDesc',
				valueField : 'POREFRowId'
			},{
				fieldLabel : '订单最大值',
				xtype:'numberfield',
				xtype:'numberfield',
				width:200,
				allowNegative : false,//不允许输入负数
				id:'SSGRPMaxPOAmount',
				name : 'SSGRPMaxPOAmount'
			}
							
							]}
							
							/*,{
							xtype:'fieldset',
							title:'Bed Management',
							layout:'column',
							items:[{
										columnWidth:.5,
										layout:'form',
										items:[{
													id:'CTZIPRowId',
													xtype:'textfield',
													fieldLabel : 'CTZIPRowId',
													name : 'CTZIPRowId'
												},{
													fieldLabel : '<font color=red>*</font>代码',
													xtype:'textfield',
													id:'CTZIPCode'
													
												}, {
													fieldLabel : '<font color=red>*</font>描述',
													xtype:'textfield',
													id:'CTZIPDesc'
												
												
												}]
								},{
										columnWidth:.5,
										layout:'form',
										baseCls : 'x-plain',//form透明,不显示框框
										///style:'margin-left:20px',
										items:[{
													xtype : "textfield",
													
													fieldLabel : '<font color=red></font>健康监护区域'
													
											}]
									}]	
						}*/
				
				
				
				
				
				],
				buttons: [{
			text: '保存',
			iconCls : 'icon-save',
			width: 100,
			id:'SSGRPBaseInfosave_btn',
			disabled:Ext.BDP.FunLib.Component.DisableFlag('SSGRPBaseInfosave_btn'),
      		handler: function (){
      			
      			if (grid.selModel.hasSelection()) {
      			
      			if(SSGRPBaseInfoWinform.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				
				var startDate = Ext.getCmp("SSGRPBaseInfo-form-save").getForm().findField("SSGRPStartDate").getValue();
				var endDate = Ext.getCmp("SSGRPBaseInfo-form-save").getForm().findField("SSGRPEndDate").getValue();
				if ((startDate != "") && (endDate != "")) {
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
			 	
      			var rows = grid.getSelectionModel().getSelections();
				var ssrowid= rows[0].get('SSGRPRowId');
				var ssdesc= rows[0].get('SSGRPDesc');
				SSGRPBaseInfoWinform.form.submit({
						url : Set_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST', 
						success : function(form, action) {
							if (action.result.success == 'true') {
								
								
										var myrowid = "rowid="+action.result.id;
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
											msg : '设置失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
							}
						},
						failure : function(form, action) {
							Ext.Msg.alert('提示', '设置失败！');
						}
					})
      			} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请先选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
      			
      			
      	} 
		}]
	});
	var tabsWin = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 450,
				 items : [SSGRPAddWinform, AliasGrid]
			 });		
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '', 
		width : 770,
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
		items : tabsWin,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				if(SSGRPAddWinform.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				var startDate = Ext.getCmp("SSGRPAdd-form-save").getForm().findField("SSGRPStartDate").getValue();
				var endDate = Ext.getCmp("SSGRPAdd-form-save").getForm().findField("SSGRPEndDate").getValue();
				if ((startDate != "") && (endDate != "")) {
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
				
				//-------添加----------	
				if (win.title == "添加") {
					SSGRPAddWinform.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									   ///多院区医院
									'LinkHospId' :hospComp.getValue()           
								},
						success : function(form, action) {
							if (action.result.success == 'true') {
								win.hide();
								var myrowid = action.result.id;
								 //var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
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
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
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
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							SSGRPAddWinform.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = grid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("grid",ACTION_URL,myrowid)
												
												var _record = grid.getSelectionModel().getSelected();
        										if (!_record) {
        			
       											} else {	 
           		 									SSGRPBaseInfoWinform.form.load( {
                										url : Set_OPEN_ACTION_URL + '&id='+ _record.get('SSGRPRowId'),
            		 									success : function(form,action) {
                	
            		 									},
            		 									failure : function(form,action) {
            		 										Ext.Msg.alert('编辑','载入失败！');
            		 									}
            		 								});
            		 								}
												
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
									Ext.Msg.alert('提示', '修改失败！');
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
				//Ext.getCmp("form-save").getForm().findField("SSGRPDesc").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				SSGRPAddWinform.getForm().reset();
				
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
					SSGRPAddWinform.getForm().reset();
					
					//激活基本信息面板
		            tabsWin.setActiveTab(0);
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
						loadFormData(grid);
						
						//激活基本信息面板
			            tabsWin.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            AliasGrid.DataRefer = _record.get('SSGRPRowId');
				        AliasGrid.loadGrid();
				        
						//var record = grid.getSelectionModel().getSelected();
						//Ext.getCmp("form-save").getForm().loadRecord(record);
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
								name : 'SSGRPRowId',
								mapping : 'SSGRPRowId',
								type : 'number'
							
							}, {
								name : 'SSGRPDesc',
								mapping : 'SSGRPDesc',
								type : 'string'
							}, {
								name : 'SSGRPCode',
								mapping : 'SSGRPCode',
								type : 'string'
							}
						]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
	});
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		
 	
	
			
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : ds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条', 
				emptyMsg : "没有记录"
	});

	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

				
	
	/////-参数配置------------------
	var MENUTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=GetTreeJson";
	/** 参数配置面板 */
	var menuTreeLoader1 = new Ext.tree.TreeLoader({
			nodeParameter: "ParentID",
			dataUrl: MENUTREE_ACTION_URL
		});
	var menuPanel1 = new Ext.tree.TreePanel({
				title: '参数配置',
				region: 'west',
				width:220,
				id: 'menuConfigTreePanel2',
				expanded:true,
				split:true,
				collapsible:true, //自动收缩按钮 
				border:true,
				root: new Ext.tree.AsyncTreeNode({
						id:"menuTreeRoot",
						text:"配置项",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: menuTreeLoader1,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false,
	            listeners:{
	            	"click":function(node,event) {
	            		centertab.removeAll();
								addtab(node);
							}
	            }
	       
		});
	/** 初始化Home TabPanel */
	var centertab =  new Ext.TabPanel({
                id:'main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
               	plugins:new Ext.BDP.TabCloseMenu(),
                items:[{
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }]
		});
	/** 新增TabPanel的函数 */
    var addtab = function(node){
	    	if (!node.isLeaf()) return;
	    	//if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
	    	var tabs=Ext.getCmp('main-tabs');
	    	var tabId = "tab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){
	    		///alert(grid.getSelectionModel().getSelected().get('SSGRPRowId'));
	    		obj.setTitle(node.text);
	    		var url = node.attributes.myhref;
	    		if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //20230209 增加token
				}
	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"&gid="+grid.getSelectionModel().getSelected().get('SSGRPRowId')+"'></iframe>";
	    		obj.update(html);
	    	}else{
	    		var url = node.attributes.myhref;
	    		if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //20230209 增加token
				}
	    		///alert(grid.getSelectionModel().getSelected().get('SSGRPRowId'));
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	iconCls:node.attributes.iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"&gid="+grid.getSelectionModel().getSelected().get('SSGRPRowId')+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };
 
	var BasePanel = new Ext.Window({
		//region:"center",
		height:450,
		width:800,
		title:'参数配置',
		layout : 'border',
		id:'BasePanel',
		closeAction : 'hide',
		items:[menuPanel1,centertab],
		/*buttons:[{
				text:'保存',
				iconCls : 'icon-save',
				id:'btn-save-set',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btn-save-set'),
				handler:function(){
					//var winAction = Ext.getCmp('div-winaction').getValue();
					//if (winAction=='添加新医嘱项')   AddOrder();
					
					//if (winAction=='修改医嘱项') editFun();
					
					//if (winAction=='医嘱复制') SaveAsAddFun();	
				}
			},{
				text : '关闭',
				iconCls : 'icon-close',
				handler:function(){
					BasePanel.hide();
				}
			}],*/
		listeners : {
			"show" : function() {
			},
			"hide" : function() {
				centertab.removeAll();
				obj1=centertab.add({
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                });
                obj1.show();
				
			},
			"close" : function() {
			}
		}
	});
	
	
 
	
	// 参数配置按钮
	var btnSet = new Ext.Toolbar.Button({
				text : '参数配置',
				tooltip : '参数配置',
				//iconCls : 'icon-update',
				id:'Set_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('Set_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						
						//var gsm = grid.getSelectionModel();//获取选择列
        				//var rows = gsm.getSelections();//根据选择列获取到所有的行
        				//var SSGRPRowId=rows[0].get('SSGRPRowId');
           				//var SSGRPDesc=rows[0].get('SSGRPDesc');  
						var _record = grid.getSelectionModel().getSelected();
						var id=_record.get('SSGRPRowId');
						var desc=_record.get('SSGRPDesc');
						BasePanel.setTitle('参数配置-'+desc);
						BasePanel.show();
	   					//Ext.getCmp("hidden_SSGRPRowId").reset();
	       				///Ext.getCmp("hidden_SSGRPRowId").setValue(id);
	       				
						//var record = grid.getSelectionModel().getSelected();
						//Ext.getCmp("form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请先选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}

				}
	});
	/*
 // 载入被选择的数据行的表单数据
    var loadSetData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            SetWinform.form.load( {
                url : Set_OPEN_ACTION_URL + '&id='+ _record.get('SSGRPRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
          ///  Ext.getCmp("form-save").getForm().findField('SSGRPAllowSendMsgAll').setValue((_record.get('SSGRPAllowSendMsgAll'))=='Y'?true:false);
            
            
        }
    };	
    */

	
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',btnSort,'-',btnTrans
		// ,btnSet
		]
	});
	// 增删改工具条
	var tbbutton2 = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnlog,'-',btnhislog,'-',helphtmlbtn
		]
	});
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				//text : '搜索',
				handler : function() {
					var title = Ext.getCmp('tabs').getActiveTab().title;
					switchcase(title, '')
					grid.getStore().baseParams={
							hospid:hospComp.getValue(),	
							activeflag:Ext.getCmp('tbActiveFlag').getValue(),
							desc : Ext.getCmp("TextDesc").getValue()
							
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
				//text : '重置',
				handler : function() {
					
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					var title = Ext.getCmp('tabs').getActiveTab().title;
					switchcase(title, '')
					 Ext.getCmp('tbActiveFlag').setValue("Y");
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={
						activeflag:Ext.getCmp('tbActiveFlag').getValue(),
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
				items : [
				
				{xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),width:80	},'-','有效',{
							xtype : 'combo',
							listWidth:70,
							width:70,
							shadow:false,
							fieldLabel : '有效',
							id :'tbActiveFlag',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbActiveFlag'),
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
									name : '是',
									value : 'Y'
								}, {
									name : '否',
									value : 'N'
								}]
							}),
							mode : 'local',
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							triggerAction : 'all',
							valueField : 'value',
							displayField : 'name',
							listeners:{
								   'select': function(field,e){
								          grid.getStore().baseParams={
												hospid:hospComp.getValue(),		
												activeflag:Ext.getCmp('tbActiveFlag').getValue(),
												desc : Ext.getCmp("TextDesc").getValue()
												
										};
										grid.getStore().load({
											params : {
												start : 0,
												limit : pagesize
											}
										});
				                 	}
							}
							
						},Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-', btnSearch,'-',
						{xtype: 'textfield',id: 'SSGRPROWID_HIDDEN',hidden : true},
				{xtype: 'textfield',id: 'SSGRPDESC_HIDDEN',hidden : true},
						btnRefresh
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
						tbbutton2.render(grid.tbar)
					}
				}
	});
	var GridCM=[sm, {
							header : 'SSGRPRowId',
							width : 70,
							sortable : true,
							dataIndex : 'SSGRPRowId',
							hidden : true
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'SSGRPCode'
						
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'SSGRPDesc'
						}]
	
	
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '安全组',
				id : 'grid',
				region : 'west',
				split:true,
				collapsible:true, //自动收缩按钮 
				border:true,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				width:360,
				minSize: 300,
				maxSize: 480,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :GridCM,
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});
	Ext.BDP.AddTabpanelFun(tabsWin,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
	

	 // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            SSGRPAddWinform.form.load( {
                url : Set_OPEN_ACTION_URL + '&id='+ _record.get('SSGRPRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };			
			
	grid.on("rowdblclick", function(grid, rowIndex, e) {
		if (Ext.BDP.FunLib.Component.DisableArray["update_btn"]!=="N"){  
		   	var row = grid.getStore().getAt(rowIndex).data;
			win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);			
			//激活基本信息面板
            tabsWin.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('SSGRPRowId');
	        AliasGrid.loadGrid();
		}	
    });	
    
	
    	
   
	//===============================================安全组页面（完）===============================================
    
    /////------安全组整合-其他配置
	/*var setTREE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassMethod=GetOtherSetTreeJson";
	var setmenuTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter: "ParentID",
			dataUrl: setTREE_ACTION_URL,
			baseParams:{GroupRowId:""}  
			
		});
	var setmenuPanel = new Ext.tree.TreePanel({
				title: '配置项',
				region: 'west',
				width:200,
				id: 'setmenuConfigTreePanel',
				expanded:true,
				split:true,
				collapsible:true, //自动收缩按钮 
				border:true,
				root: new Ext.tree.AsyncTreeNode({
						id:"setmenuTreeRoot",
						text:"配置项",
						draggable:false,  //可拖拽的
						expanded:true  //根节点自动展开
					}),
				loader: setmenuTreeLoader,
				autoScroll: true,
				containerScroll: true,
				rootVisible:false,
	            listeners:{
	            	"click":function(node,event) {
        				setcentertab.removeAll();
						addtab2(node);
					}
	            }
	       
		});
	// 初始化Home TabPanel 
	var setcentertab =  new Ext.TabPanel({
                id:'set-main-tabs',
                activeTab:0,
                region:'center',
                enableTabScroll:true,
                resizeTabs: true,
                tabWidth:130,
				minTabWidth:120,
                //margins:'0 5 5 0',
                resizeTabs:true,
                //tabWidth:150
               	plugins:new Ext.BDP.TabCloseMenu(),
                items:[{
                	title:"Home",
					//html:"Welcome"
					html : "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.csp'></iframe>"
                }]
		});
	//新增TabPanel的函数
    var addtab2 = function(node){
	    	if (!node.isLeaf()) return;
	    	//if(ObjectReference == "") {Ext.Msg.alert("提示","请先选择授权类别!"); return;}
	    	var tabs=Ext.getCmp('set-main-tabs');
	    	var tabId = "settab_"+node.id;
	    	var obj = Ext.getCmp(tabId);
	    	if (obj){
	    		///alert(grid.getSelectionModel().getSelected().get('SSGRPRowId'));
	    		obj.setTitle(node.text);
	    		var url = node.attributes.myhref;
	    		var html = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>";
	    		obj.update(html);
	    	}else{
	    		var url = node.attributes.myhref;
	    		///alert(grid.getSelectionModel().getSelected().get('SSGRPRowId'));
	    	    obj=tabs.add({
	    	    	id:tabId,
	            	title:node.text,
	            	tabTip:node.text,
	            	iconCls:node.attributes.iconCls,
	            	html:"<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
	            	closable:true
	      		 });
	    	}
	    	obj.show();	//显示tab页
	    };
    */
	//-------------定义Grid的行单击事件--------------------
	grid.on("rowclick", function(grid, rowIndex, e) { // ----------------单击父表中一行显示对应的子表
				//SSGRPBaseInfoWinform.getForm().reset();
				var _record = grid.getSelectionModel().getSelected();
				var ssgrprowid = _record.get('SSGRPRowId');
				var ssgrpdesc = _record.get('SSGRPRowId');
				Ext.getCmp("SSGRPROWID_HIDDEN").reset();
           		Ext.getCmp("SSGRPROWID_HIDDEN").setValue(ssgrprowid);
           		
           		Ext.getCmp("SSGRPDESC_HIDDEN").setValue(ssgrpdesc);
           		
           		
				var title = Ext.getCmp('tabs').getActiveTab().title;
				switchcase(title, ssgrprowid);
				
				
				/*setmenuPanel.on('beforeload', function(){    
        		    setmenuTreeLoader.dataUrl = setTREE_ACTION_URL ;   
         		   	setmenuTreeLoader.baseParams = {GroupRowId:ssgrprowid};   
   				});
   				setmenuPanel.root.reload();*/
			});
	
	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('SSGRPRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});			
			
	function switchcase(title, ssgrprowid) {
		switch (title) {	
			case '详细信息' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				SSGRPBaseInfoWinform.form.load( {
                url : Set_OPEN_ACTION_URL +'&id='+ssgrprowid,
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	///alert("sssssss");
                },
                failure : function(form,action) {
                	Ext.Msg.alert('提示','载入失败！');
                }
            });
				break;
			case '安全组设置' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				var url1= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlS1",ssgrprowid);
				if ('undefined'!==typeof websys_getMWToken)
		        {
					url1 += "&MWToken="+websys_getMWToken() //20230209 增加token
				}
				var htmlS1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>";
				Ext.getCmp("tabset").update(htmlS1);
				//alert("htmlS1")
				break;
			case '菜单配置' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				var url2= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlM1",ssgrprowid);
				if ('undefined'!==typeof websys_getMWToken)
		        {
					url2 += "&MWToken="+websys_getMWToken() //20230209 增加token
				}
				var htmlM1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url2+"&SingleHospId="+hospComp.getValue()+"'></iframe>";
				Ext.getCmp("tabmenu").update(htmlM1);
				//alert("htmlM1")
				break;
			case '医嘱授权' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				SSORDgrid.getStore().baseParams={
					'hospid': hospComp.getValue(),
					ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
				};
				SSORDgrid.getStore().load({                              //-----------加载数据
						params : {
							start : 0,
							limit : pagesize
						}
					});	
				/* 
				//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
				SSORDds.setBaseParam('ssgrprowid', ssgrprowid);
				SSORDds.setBaseParam('hospid', hospComp.getValue());
				SSORDds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});*/
				break;
			case '库存授权' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				STgrid.getStore().baseParams={
					'hospid': hospComp.getValue(),
					ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
				};
				STgrid.getStore().load({                              //-----------加载数据
						params : {
							start : 0,
							limit : pagesize
						}
					});	
				/*STds.setBaseParam('ssgrprowid', ssgrprowid);
				STds.setBaseParam('hospid', hospComp.getValue());
				STds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});*/
				break;
			case '医嘱状态' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				OSTATgrid.getStore().baseParams={
					ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
				};
				OSTATgrid.getStore().load({                              //-----------加载数据
						params : {
							start : 0,
							limit : pagesize
						}
					});	
				/*OSTATds.setBaseParam('ssgrprowid', ssgrprowid);
				OSTATds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});*/
				break;
			case '医院' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
				//HOSPds.setBaseParam('ssgrprowid', ssgrprowid);
				HOSPgrid.getStore().baseParams={
					ssgrprowid : ssgrprowid
				};
				HOSPds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});
				break;
			case '复制授权' :
				if(ssgrprowid==""){
					tabs.disable();
					break;
				}
				else
				{
					tabs.enable();
				}
			
				 //PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
				copyds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize //每页的数据条数 
					}
				});
				break;
			/*case '安全组其他配置' :
				
				if (grid.selModel.hasSelection()) {
					var _record = grid.getSelectionModel().getSelected();
					var ssgrprowid = _record.get('SSGRPRowId');
					setmenuPanel.on('beforeload', function(){    
        		   		setmenuTreeLoader.dataUrl = setTREE_ACTION_URL ;   
         		   		setmenuTreeLoader.baseParams = {GroupRowId:ssgrprowid};   
   					});
   					setmenuPanel.root.reload();
   					///2019-07-22 重新刷新其他配置下的菜单
					setcentertab.removeAll();
				
					break;
				}
				else
				{
					alert("请先选择安全组！")
				
				}*/
		}
	}
			
			
	//==========================安全组医嘱授权=====================
	var SSORDbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'SSORD_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORD_del_btn'),
		handler : function() {   
			if (grid.selModel.hasSelection()) {
			if (SSORDgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = SSORDgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : SSORD_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('SSORDRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												
												Ext.BDP.FunLib.DelForTruePage(SSORDgrid,pagesize);
												
												
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择安全组！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
			
		
		}
		
	});
	
	// 增加修改的form
	var SSORDWinForm = new Ext.FormPanel({
		id : 'SSORD-form-save',
		// title : '数据信息',
		// collapsible : true,
		// region: 'west',
		// bodyStyle : 'padding:5px 5px 0 0',
		URL : SSORD_SAVE_ACTION_URL,
		autoScroll : true,
		baseCls : 'x-plain',// form透明,不显示框框
		labelAlign : 'right',
		labelWidth : 110,
		split : true,
		frame : true,
		waitMsgTarget : true,
		reader : new Ext.data.JsonReader({
					root : 'list'
				}, [{
							name : 'SSORDParRef',
							mapping : 'SSORDParRef'
						}, {
							name : 'SSORDRowId',
							mapping : 'SSORDRowId'
						}, {
							name : 'SSORDOrdCatDR',
							mapping : 'SSORDOrdCatDR'
						},// 医嘱大类
						{
							name : 'SSORDOrdSubCategory',
							mapping : 'SSORDOrdSubCategory'
						/*},// 医嘱子类
						{
							name : 'SSORDOrderOnDischarge',
							mapping : 'SSORDOrderOnDischarge'
						}, // 出院未结算
						{
							name : 'SSORDOrderInvisbleItem',
							mapping : 'SSORDOrderInvisbleItem'
						},// 不可见医嘱项
						{
							name : 'SSORDOrderSets',
							mapping : 'SSORDOrderSets'
						},// 医嘱套
						{
							name : 'SSORDRequireAuthorisation',
							mapping : 'SSORDRequireAuthorisation'
						},// 修改医嘱项
						{
							name : 'SSORDOrderOnFinanceDisch',
							mapping : 'SSORDOrderOnFinanceDisch'
						},// 出院结算医嘱
						{
							name : 'SSORDBookingOnly', // 仅限预约
							mapping : 'SSORDBookingOnly'*/
						}
				]),
		defaults : {
			anchor : '85%',
			bosrder : false
		},
		// defaultType : 'textfield',
		items : [{
					id : 'SSORDParRef',
					xtype : 'textfield',
					fieldLabel : 'SSORDParRef',
					name : 'SSORDParRef',
					hideLabel : 'True',
					hidden : true
				}, {
					id : 'SSORDRowId',
					xtype : 'textfield',
					fieldLabel : 'SSORDRowId',
					name : 'SSORDRowId',
					hideLabel : 'True',
					hidden : true
				}, {
				
				
					xtype:'bdpcombo',
					mode:'remote',
					listWidth : 250,
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					loadByIdParam : 'rowid',
					fieldLabel : '<font color=red>*</font>医嘱大类',
					hiddenName : 'SSORDOrdCatDR',
					id : 'comboSSORDOrdCatDR',
					allowBlank : false,
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdCatDR'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdCatDR'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdCatDR')),

					store:new Ext.data.JsonStore({
							url:Ord_Cat_DR_QUERY_ACTION_URL,
							root: 'data',
							totalProperty: 'total',
							successProperty : 'success',
							fields:['ORCATRowId','ORCATDesc']
						}),
					//shadow : false,
					queryParam : 'desc',
					forceSelection : true,
					selectOnFocus : false,
					//triggerAction : 'all',
					//hideTrigger: false,
					displayField : 'ORCATDesc',
					valueField : 'ORCATRowId',
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
	          				
							 },
         					'select': function(field,e){
         							Ext.getCmp("comboSSORDOrdSubCategory").setValue("");
                 			}
                		}
				
				}, {
				
					xtype:'bdpcombo',
					mode:'remote',
					listWidth : 250,
					pageSize:Ext.BDP.FunLib.PageSize.Combo,
					loadByIdParam : 'rowid',
					fieldLabel : '<font color=red></font>医嘱子类',
					hiddenName : 'SSORDOrdSubCategory',
					id : 'comboSSORDOrdSubCategory',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdSubCategory'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdSubCategory'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrdSubCategory')),
					
				
					store:new Ext.data.JsonStore({
							url:Ord_Sub_Category_QUERY_ACTION_URL,
							root: 'data',
							totalProperty: 'total',
							successProperty : 'success',
							fields:['ARCICRowId','ARCICDesc']
						}),
					//mode : 'local',
					//shadow : false,
					queryParam : 'desc',
					forceSelection : true,
					selectOnFocus : false,
					//triggerAction : 'all',
					//hideTrigger: false,
					displayField : 'ARCICDesc',
					valueField : 'ARCICRowId',
					listeners : {
						'beforequery': function(e){
	  								this.store.baseParams = {
	  									desc:e.query,
	  									hospid:hospComp.getValue(),
										ordcat:Ext.getCmp("comboSSORDOrdCatDR").getValue()
									};
									this.store.load({params : {
												start : 0,
												limit : Ext.BDP.FunLib.PageSize.Combo
									}})
	          				
							 },
						'change' : function(combo, record, index) {
							if(SSORDwin.title=="修改"){   //if (SSORDgrid.selModel.hasSelection())
							var Oldsub = SSORDgrid.getSelectionModel().getSelected().get('OrdSubCategory');
							//alert(SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId'));
							if (Oldsub) {
								Ext.Ajax.request({
									url : ITM_ACTION_URL1,
									method : 'POST',
									params : {
										'ssordrowid' : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')
									},
									callback : function(options, success,response) {
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (success) {// 请求成功
											// 没有子类明细时，不提示；有子类明细时，提示是否确认修改医嘱子类
											if (jsonData.success == 'true') { // 有子类明细
												Ext.MessageBox.confirm('提示','存在子类明细，是否要删除对应的子类明细继续修改?',function(btn) {
													if (btn == 'yes') {
														Ext.Ajax.request({
															url : ITM_DELETE_ACTION_URL1,
															method : 'POST',
															params : {
																'ssordrowid' : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')
															},
															callback : function(options,success,response) {
																if (success) {// 请求成功

																	if (jsonData.success == 'true') { // 有子类明细
																		Ext.Msg.show({
																			title : '提示',
																			msg : '子类明细删除成功！',
																			icon : Ext.Msg.INFO,
																			buttons : Ext.Msg.OK
																		});
																	}
																} else {
																	Ext.Msg.show({
																		title : '提示',
																		msg : '异步通讯失败,请检查网络连接！',
																		icon : Ext.Msg.ERROR,
																		buttons : Ext.Msg.OK
																	});
																}

															}
														})
													} else {
															var Sub = SSORDgrid.getSelectionModel().getSelected().get('OrdSubCategory');
															Ext.getCmp('comboSSORDOrdSubCategory').setValue(Sub);
													}
												});
											}
										} else {
											Ext.Msg.show({
														title : '提示',
														msg : '异步通讯失败,请检查网络连接！',
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}
									}
								}, this);
							}
						}
						}
							
					}/*,
					renderer : function(value, cellmeta, record) {
					//获取当前id="AgentDR"的comboBox选择的值
     				var index = subcatds.find(Ext.getCmp('comboSSORDOrdSubCategory').valueField, value);
    				var record = subcatds.getAt(index);
    				//alert(value);
    				var displayText = "";
     				//如果下拉列表没有被选择,那么record也就不存在,这时候,返回传进来的value
     				//而这个value就是grid的deal_with_name列的value,所以直接返回
    				if (record == null) {
    					//返回默认值
    					displayText = value;
					} 
					else {
						displayText = record.data.ARCICDesc;//获取record中的数据集中的displayField字段的值
					}
     				return displayText;
     				}*/
					
				///2015-2-2修改
				}, {
					fieldLabel : '<font color=red></font>出院未结算',
					xtype : 'checkbox',
					name : 'SSORDOrderOnDischarge',
					id : 'SSORDOrderOnDischarge',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnDischarge'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnDischarge'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnDischarge')),
					inputValue : true ? 'Y' : 'N'
				}, {
					fieldLabel : '<font color=red></font>不可见医嘱项',
					xtype : 'checkbox',
					name : 'SSORDOrderInvisbleItem',
					id : 'SSORDOrderInvisbleItem',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderInvisbleItem'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderInvisbleItem')),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderInvisbleItem'),
					inputValue : true ? 'Y' : 'N'
				}, {
					fieldLabel : '<font color=red></font>医嘱套',
					xtype : 'checkbox',
					name : 'SSORDOrderSets',
					id : 'SSORDOrderSets',
					checked : true,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderSets'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderSets')),
				    //disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderSets'),
					inputValue : true ? 'Y' : 'N'
				}, {
					fieldLabel : '<font color=red></font>修改医嘱项',
					xtype : 'checkbox',
					name : 'SSORDRequireAuthorisation',
					id : 'SSORDRequireAuthorisation',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDRequireAuthorisation'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDRequireAuthorisation')),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDRequireAuthorisation'),
					inputValue : true ? 'Y' : 'N'
				}, {
					fieldLabel : '<font color=red></font>出院结算医嘱',
					xtype : 'checkbox',
					name : 'SSORDOrderOnFinanceDisch',
					id : 'SSORDOrderOnFinanceDisch',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnFinanceDisch'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnFinanceDisch')),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDOrderOnFinanceDisch'),
					inputValue : true ? 'Y' : 'N'
				}, {
					fieldLabel : '<font color=red></font>仅限预约',
					xtype : 'checkbox',
					name : 'SSORDBookingOnly',
					id : 'SSORDBookingOnly',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('SSORDBookingOnly'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('SSORDBookingOnly')),
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDBookingOnly'),
					inputValue : true ? 'Y' : 'N'

				}]
	});
			
	// 增加修改时弹出窗口
	var SSORDwin = new Ext.Window({
		title : '',
		width : 330,
		height: 450,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		//collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : SSORDWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'SSORD_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORD_save_btn'),
			handler : function() {
				//-------添加----------
				if (SSORDwin.title == "添加") {
					
					SSORDWinForm.form.submit({
						url : SSORD_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'SSORDParRef' : grid.getSelectionModel().getSelected().get('SSGRPRowId')           //-------通过RowId来删除数据
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								SSORDwin.hide();
								var myrowid = action.result.id;
								
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = SSORDgrid.getBottomToolbar().cursor;
												SSORDgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
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
				} 
				//---------修改-------
				else {
					//判断当子类明细存在时，修改医嘱子类则删除对应的子类明细
					
					
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							SSORDWinForm.form.submit({
								url : SSORD_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										SSORDwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = SSORDgrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("SSORDgrid",SSORD_ACTION_URL,myrowid)
												/*SSORDgrid.getStore().load({
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
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
						}
					}, this);
					
					//WinForm.getForm().reset();
					
					
					
					
				}
			}
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				SSORDwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("SSORD-form-save").getForm().findField("SSORDOrdCatDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				SSORDWinForm.getForm().reset();
				
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var SSORDbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'SSORD_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORD_add_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						
						SSORDwin.setTitle('添加');
						SSORDwin.setIconClass('icon-add');
						SSORDwin.show();
						SSORDWinForm.getForm().reset();
						
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				},
				scope: this
	});
	// 修改按钮
	var SSORDbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'SSORD_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORD_update_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
					if (SSORDgrid.selModel.hasSelection()) {
						
						SSORDwin.setTitle('修改');
						SSORDwin.setIconClass('icon-update');
						SSORDwin.show();
						loadSSORDFormData(SSORDgrid);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	var SSORDds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : SSORD_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'SSORDRowId',
								mapping : 'SSORDRowId',
								type : 'string'
							}, {
								name : 'SSORDParRef',
								mapping : 'SSORDParRef',
								type : 'string'
							}, {
								name : 'SSORDOrdCatDR',
								mapping : 'SSORDOrdCatDR',
								type : 'string'
							}, {
								name : 'SSORDOrdSubCategory',
								mapping : 'SSORDOrdSubCategory',
								type : 'string'
							}, {
								name : 'OrdCatDR', //医嘱大类id
								mapping : 'OrdCatDR',
								type : 'string'
							}, {
								name : 'OrdSubCategory',//医嘱子类id
								mapping : 'OrdSubCategory',
								type : 'string'
							}, {
								name : 'SSORDOrderOnDischarge',
								mapping : 'SSORDOrderOnDischarge'
							}, {
								name : 'SSORDOrderInvisbleItem',
								mapping : 'SSORDOrderInvisbleItem'
							}, {
								name : 'SSORDOrderSets',
								mapping : 'SSORDOrderSets'
							}, {
								name : 'SSORDBookingOnly',
								mapping : 'SSORDBookingOnly'
							}, {
								name : 'SSORDOrderOnFinanceDisch',
								mapping : 'SSORDOrderOnFinanceDisch'
							}, {
								name : 'SSORDRequireAuthorisation',
								mapping : 'SSORDRequireAuthorisation'
								//inputValue : true?'Y':'N' //checkbox
							
							}
						])
	});
			
	
	// 分页工具条
	var SSORDpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : SSORDds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var SSORDsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});
			
	var ITMbtn = new Ext.Button({
				id : 'ITM_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('ITM_btn'),
				iconCls : 'icon-AdmType',
				text : '医嘱子类明细',
				handler : function() {
					if (grid.selModel.hasSelection()) {
					if (SSORDgrid.selModel.hasSelection()) {
						if (SSORDgrid.getSelectionModel().getSelected().get('OrdSubCategory')) {

							ITMds.setBaseParam('ssordrowid', SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId'));
							ITMds.load({ // ----------------根据父表rowid加载父表的store
								params : {
									start : 0,
									limit : pagesize
									// 每页的数据条数
								}
							});
							///医嘱项下拉框 ,  （医嘱子类明细）
						    Ext.getCmp('ITMARCIMDR').store.on("beforeload", function() {
								this.baseParams = {
									hospid:hospComp.getValue(),
									subcat:SSORDgrid.getSelectionModel().getSelected().get('OrdSubCategory')
								};
						    });
							//arcimds.proxy= new Ext.data.HttpProxy({url: ARCIM_DR_QUERY_ACTION_URL+'&subcat='+SSORDgrid.getSelectionModel().getSelected().get('OrdSubCategory')});  
							//arcimds.load();
							
							ITMWindow.show();
							var SSORDOrdCatDR=SSORDgrid.getSelectionModel().getSelected().get('SSORDOrdCatDR')
    						var SSORDOrdSubCategory=SSORDgrid.getSelectionModel().getSelected().get('SSORDOrdSubCategory')
							ITMPanel.setTitle(SSORDOrdCatDR+"--"+SSORDOrdSubCategory);
							
							Ext.getCmp("ITMARCIMDR").clearValue();
							Ext.getCmp("ITMIncludeExclude").setValue('I'); 
							Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
							
							if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
								
								Ext.getCmp("ITM_Add_btn").enable();
							}
							else{
								Ext.getCmp("ITM_Add_btn").disable();
							}
    						Ext.getCmp("ITM_Update_btn").disable();
    						
    						
    						Ext.getCmp("ITM_del_btn").disable();
    						
    						
    						
						} else {
							Ext.Msg.show({
										title : '提示',
										msg : '医嘱子类为空，无明细！',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请先选择一条医嘱子类不为空的医嘱授权数据！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请先选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});	
			
	/// 名称: 批量医嘱授权，陈莹， 2014-3-3		
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupOrderCategory&pClassMethod=GetTreeJson";
	
	/** 树面板 */
	var menuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentID",
				dataUrl: TREE_QUERY_ACTION_URL+ '&GroupID='+Ext.getCmp("SSGRPROWID_HIDDEN").getValue()+ '&hospid='+hospComp.getValue()
			});
	
	var menuPanel = new Ext.tree.TreePanel({
			region: 'center',
			//xtype:'treepanel',
			id: 'menuConfigTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"menuTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: menuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,///
			tbar:[{
						xtype:'panel',
						baseCls:'x-plain',
						height:30,
						items:[{
							xtype : 'radiogroup',
							columns: [60, 60, 60],
				            items : [{
			            		id : 'radio1',
			            		boxLabel : "全部",
			            		name : 'FilterCK',
			            		inputValue : '0',
			            		checked : true,
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL+ '&GroupID='+Ext.getCmp("SSGRPROWID_HIDDEN").getValue()+ '&hospid='+hospComp.getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio2',
			            		boxLabel : "已选",
			            		name : 'FilterCK',
			            		inputValue : '1',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL + '&FilterCK=checked' + '&GroupID='+Ext.getCmp("SSGRPROWID_HIDDEN").getValue()+ '&hospid='+hospComp.getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}, {
			            		id : 'radio3',
			            		boxLabel : "未选",
			            		name : 'FilterCK',
			            		inputValue : '2',
			            		listeners : {
					            	'check' : function(com, checked){
					            		if(checked){
					            			menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL + '&FilterCK=unchecked' + '&GroupID='+Ext.getCmp("SSGRPROWID_HIDDEN").getValue()+ '&hospid='+hospComp.getValue();
					            			menuPanel.root.reload();
					            		}
					            	},
					            	scope : this
					            }
			            	}]
			            }]
					}]
	});
	var Tree1Window = new Ext.Window({
    title: '批量授权',
    closable: true,      
    width: 350,
    height: 500,
    border: false,
    layout: 'border',
    modal : true,
	closeAction : 'hide',
    items: [menuPanel],
    buttons: [{
        text: '关闭',
        iconCls : 'icon-close',
        handler: function () {
        	
 			Tree1Window.hide();
 			if(grid.selModel.hasSelection()){
				SSORDgrid.getStore().baseParams={							//-----------模糊查询	
					'hospid': hospComp.getValue(),
					ordcat :  Ext.getCmp("TextOrdCatDR").getValue(),			
					ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
				
				};
				SSORDgrid.getStore().load({
					params : {
						start : 0,
						limit : pagesize
					}
				});
			}
        }
    }],
    listeners : {
		"show" : function(){
						
		},
		"hide" : function(){
			Ext.getCmp("radio1").setValue(0);
 			
		},
		"close" : function(){
		}
	}
  	});	
  	
  	menuPanel.on("checkchange",function (node, checked){
			if (checked==true){//添加
				//alert(menuPanel.getChecked())//获取到所有打对勾的checkbox
				
				//选中描述或者图片才行，得到  Node 1^1^204, checkbox不行,得到null
				//var selectednode = menuPanel.getSelectionModel().getSelectedNode();
				//var ObjectReference=selectednode.id; //1^1^204
				
				//node.attributes.checked
				
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var SSGRPRowId=arryTmpRowId[0];
				var ORCATRowId = arryTmpRowId[1];
				var ARCICRowId = arryTmpRowId[2];
				var SaveTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupOrderCategory","SaveTreePanel",SSGRPRowId,ORCATRowId,ARCICRowId);
			
			}
			else{//删除
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var SSGRPRowId=arryTmpRowId[0];
				var ORCATRowId = arryTmpRowId[1];
				var ARCICRowId = arryTmpRowId[2];
				var DeleteTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupOrderCategory","DeleteTreePanel",SSGRPRowId,ORCATRowId,ARCICRowId);
			
			
			}
			
			
		},this,{stopEvent:true});
		
	
	var SSORD_batchAut_btn = new Ext.Button({
				id : 'SSORD_batchAut_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORD_batchAut_btn'),
				iconCls : 'icon-AdmType',
				text : '批量授权',
				handler :function(){
					if(!grid.selModel.hasSelection()){
						Ext.Msg.show({
								title : '提示',
								msg : '请先选中安全组!',
								icon : Ext.Msg.ERROR,
								buttons : Ext.Msg.OK
								});
						return ;
					}
					else{
						//alert(Ext.getCmp("SSGRPROWID_HIDDEN").getValue());
						menuTreeLoader.dataUrl = TREE_QUERY_ACTION_URL + '&GroupID='+Ext.getCmp("SSGRPROWID_HIDDEN").getValue()+ '&hospid='+hospComp.getValue();
					    menuPanel.root.reload();
						//ssordroot.reload();  //重新加载dataURL和根节点
						Tree1Window.show();
					}
				}
			});	
				
	// 增删改工具条
	var SSORDtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [SSORDbtnAddwin, '-', SSORDbtnEditwin, '-', SSORDbtnDel,'-',ITMbtn,'-'
		,SSORD_batchAut_btn,'-'
		]
	});
	
	
		
	// 搜索工具条
	var SSORDbtnSearch = new Ext.Button({
				id : 'SSORDbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDbtnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if(grid.selModel.hasSelection()){
						SSORDgrid.getStore().baseParams={							//-----------模糊查询	
							'hospid': hospComp.getValue(),
							ordcat :  Ext.getCmp("TextOrdCatDR").getValue(),			
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						
						};
						SSORDgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize
							}
						});
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	// 刷新工作条
	var SSORDbtnRefresh = new Ext.Button({
				id : 'SSORDbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('SSORDbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					if(grid.selModel.hasSelection()){
		
						Ext.getCmp("TextOrdCatDR").reset();
						SSORDgrid.getStore().baseParams={
							'hospid': hospComp.getValue(),
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						};
						//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
						//SSORDds.setBaseParam('ssgrprowid', grid.getSelectionModel().getSelected().get('SSGRPRowId')); 
						SSORDgrid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
									//ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
								}
							});	
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
		
	// 将工具条放到一起
	var SSORDtb = new Ext.Toolbar({
				id : 'SSORDtb',
				items : ['医嘱大类',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>医嘱大类',
							id : 'TextOrdCatDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextOrdCatDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Ord_Cat_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'ORCATRowId',mapping:'ORCATRowId'},
										{name:'ORCATDesc',mapping:'ORCATDesc'} ])
								}),
							mode : 'remote',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'ORCATDesc',
							valueField : 'ORCATRowId',
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
						}, '-',
						SSORDbtnSearch,'-', 
						SSORDbtnRefresh,'-'
					],
				listeners : {
					render : function() {
						SSORDtbbutton.render(SSORDgrid.tbar)
					}
				}
	});

	// 创建Grid
	var SSORDgrid = new Ext.grid.GridPanel({
				id : 'SSORDgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : SSORDds,
				trackMouseOver : true,
				columns :[SSORDsm, {
							header : 'SSORDParRef',
							width : 70,
							sortable : true,
							dataIndex : 'SSORDParRef',
							hidden:true
							
						}, {
							header : 'SSORDRowId',
							width : 80,
							sortable : true,
							dataIndex : 'SSORDRowId',
							hidden:true
						}, {
							header : '医嘱大类',
							width : 100,
							sortable : true,
							dataIndex : 'SSORDOrdCatDR'
						}, {
							header : '医嘱子类',
							width : 100,
							sortable : true,
							dataIndex : 'SSORDOrdSubCategory'
						}, {
							header : '医嘱大类id',
							width : 100,
							sortable : true,
							dataIndex : 'OrdCatDR',
							hidden:true
						}, {
							header : '医嘱子类id',
							width : 100,
							sortable : true,
							dataIndex : 'OrdSubCategory',
							hidden:true
					
						}, {
							header : '出院未结算',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDOrderOnDischarge'
						}, {
							header : '不可见医嘱项',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDOrderInvisbleItem'
						}, {
							header : '医嘱套',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDOrderSets'
						}, {
							header : '修改医嘱项',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDRequireAuthorisation'
						}, {
							header : '出院结算医嘱',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDOrderOnFinanceDisch'
						}, {
							header : '仅限预约',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'SSORDBookingOnly'
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : SSORDpaging,
				tbar : SSORDtb,
				stateId : 'SSORDgrid'
	});
	Ext.BDP.FunLib.ShowUserHabit(SSORDgrid,"User.SSGroupOrderCategory");

   // 载入被选择的数据行的表单数据
    var loadSSORDFormData = function(grid) {
        var _record = SSORDgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
        					
            SSORDWinForm.form.load( {
                url : SSORD_OPEN_ACTION_URL + '&id='+ _record.get('SSORDRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDOrderOnDischarge').setValue((_record.get('SSORDOrderOnDischarge'))=='Y'?true:false);
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDOrderInvisbleItem').setValue((_record.get('SSORDOrderInvisbleItem'))=='Y'?true:false);
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDOrderSets').setValue((_record.get('SSORDOrderSets'))=='Y'?true:false);
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDBookingOnly').setValue((_record.get('SSORDBookingOnly'))=='Y'?true:false);
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDOrderOnFinanceDisch').setValue((_record.get('SSORDOrderOnFinanceDisch'))=='Y'?true:false);
           Ext.getCmp("SSORD-form-save").getForm().findField('SSORDRequireAuthorisation').setValue((_record.get('SSORDRequireAuthorisation'))=='Y'?true:false);
        }
    };

    //双击事件
    SSORDgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			SSORDwin.setTitle('修改');
			SSORDwin.setIconClass('icon-update');
			SSORDwin.show();
        	loadSSORDFormData(SSORDgrid);
    });	
		
	//=====================安全组医嘱授权（完）==============
    
    //=====================医嘱子类明细=====================
    ITMDelete=function() {   
			if (ITMgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = ITMgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : ITM_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ITMRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.getCmp("ITMARCIMDR").clearValue();

												Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
												if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
												Ext.getCmp("ITM_Add_btn").enable();
												}
												else{ 
													xt.getCmp("ITM_Add_btn").disable(); 
												}
												Ext.getCmp("ITM_Update_btn").disable();
												Ext.getCmp("ITM_del_btn").disable();
												
												var startIndex = ITMgrid.getBottomToolbar().cursor;
												var totalnum=ITMgrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize_pop==0)//最后一页只有一条
												{
														
														var pagenum=ITMgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize_pop;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												ITMgrid.getStore().baseParams = {
															arcimdr : "",
															ssordrowid : SSORDgrid
																	.getSelectionModel()
																	.getSelected()
																	.get('SSORDRowId')
														};
												ITMgrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize_pop  
																}	
														});		
												
											}
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
			
		
		}


	
	ITMAdd = function() {
		if (Ext.getCmp("ITMARCIMDR").getValue() == "") { // 10040||1
			Ext.Msg.show({
						title : '提示',
						msg : '医嘱项不可为空！',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
		} else {
			var totalITMnum = ITMgrid.getStore().getTotalCount();
			var TempIE = "";
			if (totalITMnum > 0) {
				var TempIE = ITMds.getAt(0).get('ITMIncludeExclude');
			}
			var CurrentIE = Ext.getCmp("ITMIncludeExclude").getValue().inputValue;
			if ((CurrentIE == TempIE) || (totalITMnum == 0)) {
				var SSORDRECORD = SSORDgrid.getSelectionModel().getSelections();

				Ext.Ajax.request({
					url : ITM_SAVE_ACTION_URL,
					method : 'POST',
					params : {
						'ITMParRef' : SSORDRECORD[0].get('SSORDRowId'),
						'ITMARCIMDR' : Ext.getCmp("ITMARCIMDR").getValue(),
						'ITMIncludeExclude' : Ext.getCmp("ITMIncludeExclude").getValue().inputValue,
						'ITMUnverifOrder' : Ext.getCmp("ITMUnverifOrder").getValue().inputValue
					},
					callback : function(options, success, response) {
						// Ext.MessageBox.hide();
						if (success) {
							var jsonData = Ext.util.JSON
									.decode(response.responseText);

							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												ITMgrid.getStore().baseParams = {
													arcimdr : "",
													ssordrowid : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')
												};
												ITMgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize_pop
															}
														});
												Ext.getCmp("ITMARCIMDR").clearValue();

												Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
												if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
	
													Ext.getCmp("ITM_Add_btn").enable();
												}
												else { 
													Ext.getCmp("ITM_Add_btn").disable();
												}
												Ext.getCmp("ITM_Update_btn").disable();
												Ext.getCmp("ITM_del_btn").disable();
											}
										});

							} else {
								var errorMsg = '';
								if (jsonData.errorinfo) {
									errorMsg = '<br/>错误信息:'+ jsonData.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : errorMsg,
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
			} else {
				var TempIE1 = "";
				if (TempIE == "I") {
					var TempIE1 = "Include";
				} else if (TempIE == "E") {
					var TempIE1 = "Exclude";
				}
				Ext.Msg.show({
							title : '提示',
							msg : 'Include/Exclude要与之前的数据统一为' + TempIE1,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});

			}

		}
	}
	ITMUpdate = function() {
		var SSORDRECORD = SSORDgrid.getSelectionModel().getSelections();
		// SSORDRECORD.get('SSORDRowId'); //SSORDRECORD[0].get('SSORDRowId')
		var ITMRECORD = ITMgrid.getSelectionModel().getSelections();
		if (Ext.getCmp("ITMARCIMDR").getValue() == "") {
			Ext.Msg.show({
						title : '提示',
						msg : '医嘱项不可为空！',
						minWidth : 200,
						icon : Ext.Msg.ERROR,
						buttons : Ext.Msg.OK
					});
		} else {
			var totalITMnum = ITMgrid.getStore().getTotalCount();
			var TempIE = "";
			if (totalITMnum > 1) {
				var TempIE = ITMds.getAt(0).get('ITMIncludeExclude');
			}
			var CurrentIE = Ext.getCmp("ITMIncludeExclude").getValue().inputValue;
			if ((CurrentIE == TempIE) || (totalITMnum == 1)) {

				Ext.Ajax.request({
					url : ITM_SAVE_ACTION_URL,
					method : 'POST',
					params : {
						'ITMRowId' : ITMRECORD[0].get('ITMRowId'),
						'ITMParRef' : ITMRECORD[0].get('ITMParRef'),
						'ITMARCIMDR' : Ext.getCmp("ITMARCIMDR").getValue(),
						'ITMIncludeExclude' : Ext.getCmp("ITMIncludeExclude").getValue().inputValue,
						'ITMUnverifOrder' : Ext.getCmp("ITMUnverifOrder").getValue().inputValue
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON
									.decode(response.responseText);

							if (jsonData.success == 'true') {
								Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												ITMgrid.getStore().baseParams = {
													arcimdr : "",
													ssordrowid : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')
												};
												ITMgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize_pop
															}
														});
												Ext.getCmp("ITMARCIMDR").clearValue();

												Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
												if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){

													Ext.getCmp("ITM_Add_btn").enable();
												}
												else{
													Ext.getCmp("ITM_Add_btn").disable();
												}
												Ext.getCmp("ITM_Update_btn").disable();
												Ext.getCmp("ITM_del_btn").disable();
											}
										});

							} else {
								var errorMsg = '';
								if (jsonData.errorinfo) {
									errorMsg = '<br/>错误信息:'+ jsonData.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : errorMsg,
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
			} else {
				var TempIE1 = "";
				if (TempIE == "I") {
					var TempIE1 = "Include";
				} else if (TempIE == "E") {
					var TempIE1 = "Exclude";
				}
				Ext.Msg.show({
							title : '提示',
							msg : 'Include/Exclude要与之前的数据统一为' + TempIE1,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});

			}

		}

	}
	
	var ITMds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ITM_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'ITMRowId',
								mapping : 'ITMRowId',
								type : 'string'
							}, {
								name : 'ITMParRef',
								mapping : 'ITMParRef',
								type : 'string'
							}, {
								name : 'ITMARCIMDR',
								mapping : 'ITMARCIMDR',
								type : 'string'
							}, {
								name : 'ARCIMDR',
								mapping : 'ARCIMDR',
								type : 'string'
							
							}, {
								name : 'ITMIncludeExclude',
								mapping : 'ITMIncludeExclude',
								type : 'string'
							}, {
								name : 'ITMUnverifOrder',
								mapping : 'ITMUnverifOrder',
								type : 'string'
							
							}
						])
	});
		
	
	// 分页工具条
	var ITMpaging = new Ext.PagingToolbar({
				pageSize : pagesize_pop,
				store : ITMds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize_pop=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var ITMsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	ITMSearch=function() {
						ITMgrid.getStore().baseParams={
							arcimdr : Ext.getCmp("ITMARCIMDR").getValue(),
							ssordrowid : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')			
						};
						ITMgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize_pop
							}
						});
					
				}
	ITMRefresh=function() {
					//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
	
					Ext.getCmp("ITMARCIMDR").clearValue();
					Ext.getCmp("ITMIncludeExclude").setValue('I'); 
					Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
					if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
						Ext.getCmp("ITM_Add_btn").enable();
					}
					else{
						Ext.getCmp("ITM_Add_btn").disable();
					}
    				Ext.getCmp("ITM_Update_btn").disable();
    				Ext.getCmp("ITM_del_btn").disable();
					ITMgrid.getStore().baseParams={
							arcimdr : "",
							ssordrowid : SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId')			
						};
					ITMgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize_pop
							}
						});

					}
	/*
	// 增删改工具条
	var ITMtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [ITMbtnAddwin, '-', ITMbtnEditwin, '-', ITMbtnDel,'-',ITMbtnSearch,'-',ITMbtnRefresh,'->']
	});
			
	// 将工具条放到一起
	var ITMtb = new Ext.Toolbar({
				id : 'ITMtb',
				items : ['Parref',ITMParRef,'rowid：',ITMRowId,'医嘱项：',ITMARCIMDR,'-',
						'Include/Exclude',ITMIncludeExclude,'-',
						'需要授权',ITMUnverifOrder,'-',
						'->'
					],
				listeners : {
					render : function() {
						ITMtbbutton.render(ITMgrid.tbar)
					}
				}
	});
*/
	// 创建Grid
	var ITMgrid = new Ext.grid.GridPanel({
				id : 'ITMgrid',
				region : 'center',
				closable : true,
				height:500,
				store : ITMds,
				trackMouseOver : true,
				columns :[ITMsm, {
							header : 'ITMParRef',
							width : 70,
							sortable : true,
							dataIndex : 'ITMParRef',
							hidden:true
						}, {
							header : 'ITMRowId',
							width : 80,
							sortable : true,
							dataIndex : 'ITMRowId',
							hidden:true
						}, {
							header : '医嘱项',
							width : 190,
							sortable : true,
							dataIndex : 'ITMARCIMDR'
						}, {
							header : '医嘱项id值',
							width : 85,
							sortable : true,
							dataIndex : 'ARCIMDR',
							hidden:true
						}, {
							header : 'Include/Exclude',
							width : 70,
							sortable : true,
							dataIndex : 'ITMIncludeExclude',
							renderer : function(v){
								if(v=='I'){return 'Include';}
								if(v=='E'){return 'Exclude';}
							}
						}, {
							header : '需要授权',
							width : 70,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'ITMUnverifOrder'
						
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : ITMpaging,
				//tbar : ITMtb,
				stateId : 'ITMgrid'
	});
	Ext.BDP.FunLib.ShowUserHabit(ITMgrid,"User.SSGroupOrderCategoryItems");


    //dan击事件
    ITMgrid.on("rowclick", function(grid, rowIndex, e) {
        var _record = ITMgrid.getSelectionModel().getSelected();
        //alert(_record.get('ITMIncludeExclude'));
    	Ext.getCmp("ITMARCIMDR").setValue(_record.get('ARCIMDR'));
    	Ext.getCmp("ITMIncludeExclude").setValue(_record.get('ITMIncludeExclude')); //debugger;
    	Ext.getCmp("ITMUnverifOrder").setValue(_record.get('ITMUnverifOrder'));
    	Ext.getCmp("ITM_Add_btn").disable();
    	if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Update_btn')){
    		Ext.getCmp("ITM_Update_btn").enable();
    	}
    	else{ Ext.getCmp("ITM_Update_btn").disable();}
    	
    	if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_del_btn')){
    		Ext.getCmp("ITM_del_btn").enable();
    	}
    	else{
    		Ext.getCmp("ITM_del_btn").disable();
    	}
    });	
    radioITMIncludeExclude = new Ext.BDP.FunLib.Component.RadioGroup({
				id : 'ITMIncludeExclude',
				fieldLabel : 'Include/Exclude',
				columns : 'auto',
				items : [{
							boxLabel : 'Include',
							name : 'ITMIncludeExclude',
							inputValue : 'I',
							checked : true
						}, {
							boxLabel : 'Exclude',
							name : 'ITMIncludeExclude',
							inputValue : 'E'
						}]

			});
	radioITMUnverifOrder = new Ext.BDP.FunLib.Component.RadioGroup({
				id : 'ITMUnverifOrder',
				fieldLabel : '需要授权',
				columns : 'auto',
				items : [{
							boxLabel : 'Yes',
							name : 'ITMUnverifOrder',
							inputValue : 'Y'
						}, {
							boxLabel : 'No',
							name : 'ITMUnverifOrder',
							inputValue : 'N',
							checked : true
						}]/*,
						listeners : {
         		 "change":function (e)
         		{ 
             		if(e=="I") alert("iii");
             		else alert("ss");
         		}
          		}*/

			});
			
    var ITMPanel = new Ext.FormPanel({
				id : 'itm-form-save',
				title : ' ',
				labelAlign : 'right',
				split : true,
				frame : true,
				labelWidth : 160,
				defaults : {
					width : 200,
					bosrder : false
				},
				defaultType : 'textfield',
				items : [/*{
							fieldLabel : 'ITMRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ITMRowId'
						}, {
							fieldLabel : 'ITMParRef',
							xtype : 'textfield',
							id : 'ITMParRef',
							hideLabel : 'True',
							hidden : true
						}, */
							{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:350,
							emptyText : '请选择',
							fieldLabel : '<font color=red>*</font>医嘱项',
							id : 'ITMARCIMDR',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ITMARCIMDR'),
							store :  new Ext.data.Store({
								//autoLoad : true,
								proxy : new Ext.data.HttpProxy({
											url : ARCIM_DR_QUERY_ACTION_URL
										}),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{
													name : 'ARCIMRowId',
													mapping : 'ARCIMRowId'
												}, {
													name : 'ARCIMDesc',
													mapping : 'ARCIMDesc'
												}])
							}),
							mode : 'remote',
							shadow : false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							// hideTrigger: false,
							displayField : 'ARCIMDesc',
							valueField : 'ARCIMRowId'
						},
						radioITMIncludeExclude, 
						radioITMUnverifOrder
				],
				buttonAlign : 'left',// 按钮对其方式
				buttons : [{
							text : '添加',
							id:'ITM_Add_btn',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn'),
							width : 60,
							iconCls :'icon-Add',
							handler : function() {
								ITMAdd()
							}
						}, {
							text : '修改',
							id:'ITM_Update_btn',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ITM_Update_btn'),
							iconCls :'icon-Update',
							width : 60,
							handler : function() {
								ITMUpdate()
							} // handler
						}, {
							text : '删除',
							width : 60,
							id:'ITM_del_btn',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ITM_del_btn'),
							iconCls :'icon-Delete',
							handler : function() {
								ITMDelete()
							} // handler
						}, {
							text : '重置',
							id:'ITM_refresh_btn',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ITM_refresh_btn'),
							iconCls : 'icon-refresh',
							width : 60,
							handler : function() {
								ITMRefresh()
							}

						}
						
					]

			});
    
    
   var ITMtab= new Ext.TabPanel({
   					height:180,
   					region:'north',
                    border: false, // already wrapped so don't add another
									// border
                    activeTab: 0, // second tab initially active
                   // tabPosition: 'bottom',
                    items: [ITMPanel]
                })
	var ITMWindow = new Ext.Window({
		title : '医嘱子类明细',
		height: 500,
		width:700,
		iconCls :'icon-AdmType',
		layout : 'border',
		plain : true,
		modal : true,
		frame : true,
		autoScroll : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : [ITMgrid,ITMtab]	
	});
	
	var ITMmenu =({
			id : 'ITMmenu',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('ITMmenu'),
			text:'医嘱子类明细',
	        iconCls :'icon-AdmType',
			handler:ITMShow=function(){
				ITMds.setBaseParam('ssordrowid', SSORDgrid.getSelectionModel().getSelected().get('SSORDRowId'));
				ITMds.load({ // ----------------根据父表rowid加载父表的store
					params : {
						start : 0,
						limit : pagesize_pop //每页的数据条数 
					}
				});			
				
				ITMWindow.show();
				
				var SSORDOrdCatDR=SSORDgrid.getSelectionModel().getSelected().get('SSORDOrdCatDR')
    			var SSORDOrdSubCategory=SSORDgrid.getSelectionModel().getSelected().get('SSORDOrdSubCategory')
				ITMPanel.setTitle(SSORDOrdCatDR+"--"+SSORDOrdSubCategory);

				Ext.getCmp("ITMARCIMDR").clearValue();
				Ext.getCmp("ITMIncludeExclude").setValue('I'); 
				Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
				if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
					Ext.getCmp("ITM_Add_btn").enable();
				}
				else{
					Ext.getCmp("ITM_Add_btn").disable();
				}
    			Ext.getCmp("ITM_Update_btn").disable();
    			Ext.getCmp("ITM_del_btn").disable();
    			
			}
	});	
	

    //=====================医嘱子类明细（完）=====================
    
    //=====================右键菜单=====================
    if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  	{
  		SSORDgrid.addListener('rowcontextmenu', function(grid,rowindex,e){
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
     		
     		if(currRecord.json.SSORDOrdSubCategory=="")//医嘱子类为空时，右键菜单灰化
    		{
    			Ext.getCmp('ITMmenu').disable();
    		}
    		else{
    			if(!Ext.BDP.FunLib.Component.DisableFlag('ITMmenu')){
    			Ext.getCmp('ITMmenu').enable();
    			}
    			else{
    				Ext.getCmp('ITMmenu').disable();
    			}
    			///医嘱项下拉框 ,  （医嘱子类明细）
			    Ext.getCmp('ITMARCIMDR').store.on("beforeload", function() {
					this.baseParams = {
						hospid:hospComp.getValue(),
						subcat:currRecord.json.OrdSubCategory
					};
			    });
    		
    		}

     		currGrid = grid; 
     		rightClick.showAt(e.getXY()); 
     		
     		
  		});//右键菜单代码关键部分
  		var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: ITMmenu
		}); 
		
  		
	}
	
	 //=====================一键Include/Exclude右键菜单=====================
	 var IncludeALL =({
			id : 'IncludeALL',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('IncludeALL'),
			text:'IncludeALL',
			handler:function(){
				Ext.Ajax.request({
				url : IncludeExclude_ACTION_URL, // -------发出请求的路径
				method : 'POST', // -------需要传递参数 用POST
				params : { // -------请求带的参数
					'ssordrowid' : ITMgrid.getSelectionModel().getSelected().get('ITMParRef'),
					'IE' : "I"
					// -------通过RowId来删除数据
				},
				callback : function(options, success, response) {

					if (success) {
						var jsonData = Ext.util.JSON
								.decode(response.responseText);// ------获取返回的信息
						if (jsonData.success == 'true') {
							Ext.Msg.show({
								title : '提示',
								msg : '操作成功！',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.getCmp("ITMARCIMDR").clearValue();

									Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
									if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){

									Ext.getCmp("ITM_Add_btn").enable();
									}
									else{
										Ext.getCmp("ITM_Add_btn").disable();
									}
									Ext.getCmp("ITM_Update_btn").disable();
									Ext.getCmp("ITM_del_btn").disable();
									ITMgrid.getStore().baseParams = {
										arcimdr : "",
										ssordrowid : SSORDgrid
												.getSelectionModel()
												.getSelected()
												.get('SSORDRowId')
									};
									ITMgrid.getStore().load({
												params : {
													start : 0,
													limit : pagesize_pop
												}
											});
								}
							});
						} else { // --------如果返回的是错误的请求
							Ext.Msg.show({
								title : '提示',
								msg : '操作失败!',
								minWidth : 200,
								icon : Ext.Msg.ERROR,// --------显示图标样式(错误图标)
								buttons : Ext.Msg.OK
									// ---------只有一个确定按钮
								});
						}
					} else { // ---------删除失败提示错误信息
						Ext.Msg.show({
							title : '提示',
							msg : '异步通讯失败,请检查网络连接！',
							icon : Ext.Msg.ERROR, // --------显示图标样式(错误图标)
							buttons : Ext.Msg.OK
								// --------只有一个确定按钮
							});
					}
				}
			}, this);
			}
	});	
	 var ExcludeALL = ({
		id : 'ExcludeALL',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('ExcludeALL'),
		text : 'ExcludeALL',
		handler : function() {
			Ext.Ajax.request({
				url : IncludeExclude_ACTION_URL, // -------发出请求的路径
				method : 'POST', // -------需要传递参数 用POST
				params : { // -------请求带的参数
					'ssordrowid' : ITMgrid.getSelectionModel().getSelected()
							.get('ITMParRef'),
					'IE' : "E"
					// -------通过RowId来删除数据
				},
				callback : function(options, success, response) {

					if (success) {
						var jsonData = Ext.util.JSON
								.decode(response.responseText);// ------获取返回的信息
						if (jsonData.success == 'true') {
							Ext.Msg.show({
								title : '提示',
								msg : '操作成功！',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.getCmp("ITMARCIMDR").clearValue();

									Ext.getCmp("ITMUnverifOrder").setValue('N'); // 否则在下一次打开时，会显示上一次的搜索项
									if(!Ext.BDP.FunLib.Component.DisableFlag('ITM_Add_btn')){
									Ext.getCmp("ITM_Add_btn").enable();
									}
									else{
										Ext.getCmp("ITM_Add_btn").disable();
									}
									Ext.getCmp("ITM_Update_btn").disable();
									Ext.getCmp("ITM_del_btn").disable();
									ITMgrid.getStore().baseParams = {
										arcimdr : "",
										ssordrowid : SSORDgrid
												.getSelectionModel()
												.getSelected()
												.get('SSORDRowId')
									};
									ITMgrid.getStore().load({
												params : {
													start : 0,
													limit : pagesize_pop
												}
											});
								}
							});
						} else { // --------如果返回的是错误的请求
							Ext.Msg.show({
								title : '提示',
								msg : '操作失败!',
								minWidth : 200,
								icon : Ext.Msg.ERROR,// --------显示图标样式(错误图标)
								buttons : Ext.Msg.OK
									// ---------只有一个确定按钮
								});
						}
					} else { // ---------删除失败提示错误信息
						Ext.Msg.show({
							title : '提示',
							msg : '异步通讯失败,请检查网络连接！',
							icon : Ext.Msg.ERROR, // --------显示图标样式(错误图标)
							buttons : Ext.Msg.OK
								// --------只有一个确定按钮
							});
					}
				}
			}, this);
		}
	});	
  
    if(window.ActiveXObject)// 判断浏览器是否属于IE,屏蔽其它浏览器
  	{
  		ITMgrid.addListener('rowcontextmenu', rightClickFn1);// 右键菜单代码关键部分
  		var rightClick1 = new Ext.menu.Menu({
    		id:'rightClickCont', // 在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [IncludeALL,ExcludeALL]
		}); 
		
  		rightClickFn1=function (grid,rowindex,e){
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
     		
     		if(currRecord.json.ITMIncludeExclude=="E")
    		{
    			if(!Ext.BDP.FunLib.Component.DisableFlag('IncludeALL')){
    				Ext.getCmp('IncludeALL').enable();
    			}
    			else{
    				Ext.getCmp('IncludeALL').disable();
    			}
    			Ext.getCmp('ExcludeALL').disable();
    		}
    		else{
    			if(!Ext.BDP.FunLib.Component.DisableFlag('ExcludeALL')){
    				Ext.getCmp('ExcludeALL').enable();
    			}
    			else{
    				Ext.getCmp('ExcludeALL').disable();
    			}
    			
    			Ext.getCmp('IncludeALL').disable();
    		}

     		currGrid = grid; 
     		rightClick1.showAt(e.getXY()); 
     		
     		
  		}
	}
	   
	//=====================右键菜单(完)=====================
    
	
	
    
    //=====================安全组库存授权========================
    var STbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'ST_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('ST_del_btn'),
		handler : function() {   
			if (grid.selModel.hasSelection()) {
			if (STgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = STgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : ST_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('STRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												
												Ext.BDP.FunLib.DelForTruePage(STgrid,pagesize);
												
												
											}
											
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择安全组！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
			
		
		}
		
	});
	
	// 增加修改的form
	var STWinForm = new Ext.FormPanel({
				id : 'ST-form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : ST_SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 70,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'STParRef',mapping:'STParRef'},
                                         {name: 'STRowId',mapping:'STRowId'},
                                         {name: 'STCTLOCDR',mapping:'STCTLOCDR'},
                                          {name: 'STActiveFlag',mapping:'STActiveFlag'}
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'STParRef',
							xtype:'textfield',
							fieldLabel : 'STParRef',
							name : 'STParRef',
							hideLabel : 'True',
							hidden : true
						}, {
							id:'STRowId',
							xtype:'textfield',
							fieldLabel : 'STRowId',
							name : 'STRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:250,
							listWidth:250,
							fieldLabel : '<font color=red>*</font>科室',
							//name:'STCTLOCDR',
							hiddenName : 'STCTLOCDR',
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('STCTLOCDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('STCTLOCDR')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('STCTLOCDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
										{name:'CTLOCDesc',mapping:'CTLOCDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'CTLOCDesc',
							valueField : 'CTLOCRowID',
							listeners:{
								'beforequery': function(e){
		  								this.store.baseParams = {
		  									desc:e.query,
		  									tablename:'SS_Group',
		  									hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
		          				
								 }
	                		}
						},{
							xtype:'checkbox',
							fieldLabel:'激活',
							id:'STActiveFlag',
				    		readOnly : Ext.BDP.FunLib.Component.DisableFlag('STActiveFlag'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('STActiveFlag')),
							checked:true,
							inputValue:'Y'
						}]	
	});
			
	// 增加修改时弹出窗口
	var STwin = new Ext.Window({
		title : '',
		width:350,
		height: 200,
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
		items : STWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'ST_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('ST_save_btn'),
			handler : function() {
				//-------添加----------
				if (STwin.title == "添加") {
					
					STWinForm.form.submit({
						url : ST_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'STParRef' : grid.getSelectionModel().getSelected().get('SSGRPRowId')           //-------通过RowId来删除数据
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								STwin.hide();
								var myrowid = action.result.id;
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = STgrid.getBottomToolbar().cursor;
												STgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
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
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							STWinForm.form.submit({
								url : ST_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										STwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = STgrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("STgrid",ST_ACTION_URL,myrowid)
												/*STgrid.getStore().load({
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
				STwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("ST-form-save").getForm().findField("STCTLOCDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				STWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var STbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'ST_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('ST_add_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						STwin.setTitle('添加');
						STwin.setIconClass('icon-add');
						STwin.show();
						STWinForm.getForm().reset();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				},
				scope: this
	});
	// 修改按钮
	var STbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'ST_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('ST_update_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
					if (STgrid.selModel.hasSelection()) {
						STwin.setTitle('修改');
						STwin.setIconClass('icon-update');
						STwin.show();
						loadSTFormData(STgrid);
						//var record = STgrid.getSelectionModel().getSelected();
						//Ext.getCmp("ST-form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	/****************************批量授权按钮 树形 李可凡 2020年4月13日***************************/

	var STOCKTREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.SSGroupStockLocations&pClassMethod=GetTreeJsonForGRP";
	/** 菜单面板 */
	var StockmenuTreeLoader = new Ext.tree.TreeLoader({
				nodeParameter: "ParentGRPID"
			});
	
	var StockmenuPanel = new Ext.tree.TreePanel({
			region: 'center',
			id: 'StockTreePanel',
			expanded:true,
			root: ssordroot=new Ext.tree.AsyncTreeNode({
					id:"StockTreeRoot",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
					
				}),
			loader: StockmenuTreeLoader,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false,
			tbar:[{xtype: 'textfield',id: 'Hidden_GroupID',hidden : true},
					'检索',
					new Ext.form.TextField({
						id:'FindTreeText',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('FindTreeText'),
						width:150,
						emptyText:'请输入查找内容',
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', {
						text:'清空',
						id:'Textrefresh',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('Textrefresh'),
						iconCls:'icon-refresh',
						handler:function(){clearFind();} //清除树过滤
					}] 
	});
	
	  	StockmenuPanel.on("checkchange",function (node, checked){
			if (checked==true){//添加
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var STCTLOCDR=arryTmpRowId[0];
				var STParRef = arryTmpRowId[1];
				var SaveTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupStockLocations","SaveTreePanel",STCTLOCDR,STParRef);
			}
			else{//删除
				var ID=node.id;
				var arryTmpRowId = ID.split("^");
				var STCTLOCDR=arryTmpRowId[0];
				var STParRef = arryTmpRowId[1];
				var DeleteTreePanelResult = tkMakeServerCall("web.DHCBL.CT.SSGroupStockLocations","DeleteTreePanel",STCTLOCDR,STParRef);
			}
		},this,{stopEvent:true});
		
	var winCTLocGroupStock = new Ext.Window({
			title:'',
			width:700,
            height:500,
			layout:'fit',
			plain:true,//true则主体背景透明
			modal:true,
			frame:true,
			collapsible:true,
			hideCollapseTool:true,
			titleCollapse: true,
			bodyStyle:'padding:3px',
			buttonAlign:'center',
			closeAction:'hide',
            labelWidth:55,
			items: StockmenuPanel,
			listeners:{
				"show":function(){
					Ext.getCmp('FindTreeText').reset();
					hiddenPkgs = [];
				},
				"hide":function(){
					Ext.getCmp("TextCTLOCDR").reset();
					STgrid.getStore().baseParams={
						'hospid': hospComp.getValue(),
						ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
					};
					STgrid.getStore().load({  
						params : {
							start : 0,
							limit : pagesize
						}
					});	
				},
				"close":function(){
				}
			}
		});

	/*******************************检索功能********************************/	
	var timeOutId = null;

	var treeFilter = new Ext.tree.TreeFilter(StockmenuPanel, {
		clearBlank : true,
		autoClear : true
	});

	// 保存上次隐藏的空节点
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// 清除timeOutId
		StockmenuPanel.expandAll();// 展开树节点
		//alert(node)
		// 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
		timeOutId = setTimeout(function() {
			// 获取输入框的值
			var text = node.getValue();
			// 根据输入制作一个正则表达式，'i'代表不区分大小写
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// 先要显示上次隐藏掉的节点
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			})
			hiddenPkgs = [];
			if (text != "") {
				StockmenuPanel.root.cascade(function(n) {
					if(n.id!='StockTreeRoot'){
						//增加判断大写首拼/小写首拼 是否符合筛选条件 2021-01-07
						if((!re.test(n.text))&&(!re.test(Pinyin.GetJP(n.text)))&&(!re.test(Pinyin.GetJPU(n.text))))
						{
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// 清除树过滤
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		StockmenuPanel.root.cascade(function(n) {
					if(n.id!='StockTreeRoot'){
						n.ui.show();
					}
			});
	}
	
	
	var btnCTLocGroupStock = new Ext.Toolbar.Button({
	    text: '批量授权',
	    id:'btnCTLocGroupStock',
	    disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCTLocGroupStock'),
        iconCls: 'icon-DP',
		tooltip: '批量授权',
        handler: CTLocGroupStockWinEdit =function() {   
    	var _record = grid.getSelectionModel().getSelected();
        if(_record){
			var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行 Hidden_GroupStock_CTLocID
            var SSGRPRowIdForStock=rows[0].get('SSGRPRowId');
            Ext.getCmp("Hidden_GroupID").reset();
           	Ext.getCmp("Hidden_GroupID").setValue(SSGRPRowIdForStock);
           	StockmenuTreeLoader.dataUrl = STOCKTREE_QUERY_ACTION_URL+ '&groupid='+Ext.getCmp("Hidden_GroupID").getValue()+ '&hospid='+hospComp.getValue();
			StockmenuPanel.root.reload();
			winCTLocGroupStock.setTitle('批量授权');
			winCTLocGroupStock.setIconClass('icon-DP');
			winCTLocGroupStock.show('');
        }
	        else
			{
				Ext.Msg.show({
						title:'提示',
						msg:'请选择安全组!',
						icon:Ext.Msg.WARNING,
						buttons:Ext.Msg.OK
					});
			}		
        }
	});
	
	/****************************批量授权按钮 树形 完***************************/
	
	var STds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ST_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'STRowId',
								mapping : 'STRowId',
								type : 'string'
							}, {
								name : 'STParRef',
								mapping : 'STParRef',
								type : 'string'
							}, {
								name : 'STCTLOCDR',
								mapping : 'STCTLOCDR',
								type : 'string'
							}, {
								name : 'STActiveFlag',
								mapping : 'STActiveFlag',
								type : 'string'
							
							}
						])
	});
	
			
 	// 加载数据
	STds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var STpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : STds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var STsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var STtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [STbtnAddwin, '-', STbtnEditwin, '-', STbtnDel,'-',btnCTLocGroupStock]
	});
		
	// 搜索工具条
	var STbtnSearch = new Ext.Button({
				id : 'STbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('STbtnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if(grid.selModel.hasSelection()){
						STgrid.getStore().baseParams={							//-----------模糊查询	
							'hospid': hospComp.getValue(),
							ctloc :  Ext.getCmp("TextCTLOCDR").getValue(),			
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						
						};
						STgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize
							}
						});
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	// 刷新工作条
	var STbtnRefresh = new Ext.Button({
				id : 'STbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('STbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					if(grid.selModel.hasSelection()){
		
						Ext.getCmp("TextCTLOCDR").reset();
						STgrid.getStore().baseParams={
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						};
						//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
						//STds.setBaseParam('ssgrprowid', grid.getSelectionModel().getSelected().get('SSGRPRowId')); 
						STgrid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
									//ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
								}
							});	
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
		
	// 将工具条放到一起
	var STtb = new Ext.Toolbar({
				id : 'STtb',
				items : ['科室',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:250,
							listWidth:250,
							fieldLabel : '<font color=red>*</font>科室',
							id : 'TextCTLOCDR', //要用id而不是hiddenname
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTLOCDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : CTLOC_Group_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'CTLOCRowID',mapping:'CTLOCRowID'},
										{name:'CTLOCDesc',mapping:'CTLOCDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'CTLOCDesc',
							valueField : 'CTLOCRowID',
							listeners:{
								'beforequery': function(e){
		  								this.store.baseParams = {
		  									desc:e.query,
		  									tablename:'SS_Group',
		  									hospid:hospComp.getValue()
										};
										this.store.load({params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Combo
										}})
		          				
								 }
	                		}
						}, '-',
						STbtnSearch,'-', 
						STbtnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						STtbbutton.render(STgrid.tbar)
					}
				}
	});

	// 创建Grid
	var STgrid = new Ext.grid.GridPanel({
				id : 'STgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : STds,
				trackMouseOver : true,
				columns :[STsm, {
							header : 'STParRef',
							width : 80,
							sortable : true,
							dataIndex : 'STParRef',
							hidden:true
							
						}, {
							header : 'STRowId',
							width : 80,
							sortable : true,
							dataIndex : 'STRowId',
							hidden:true
						}, {
							header : '科室',
							width : 100,
							sortable : true,
							dataIndex : 'STCTLOCDR'
						}, {
							header : '激活',
							width : 80,
							sortable : true,
							dataIndex : 'STActiveFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						
						
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : STpaging,
				tbar : STtb,
				stateId : 'STgrid'
	});

	Ext.BDP.FunLib.ShowUserHabit(STgrid,"User.SSGroupStockLocations");
   // 载入被选择的数据行的表单数据
    var loadSTFormData = function(grid) {
        var _record = STgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            STWinForm.form.load( {
                url : ST_OPEN_ACTION_URL + '&id='+ _record.get('STRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };

    //双击事件
    STgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			STwin.setTitle('修改');
			STwin.setIconClass('icon-update');
			STwin.show();
        	loadSTFormData(STgrid);
    });	
	
    
    
    
    //=====================安全组库存授权（完）=====================
    
    
    ///安全组医院
   
    var HOSPbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'HOSP_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSP_del_btn'),
		handler : function() {   
			if (grid.selModel.hasSelection()) {
			if (HOSPgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = HOSPgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : HOSP_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('HOSPRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												
												Ext.BDP.FunLib.DelForTruePage(HOSPgrid,pagesize);
												
													
	
											}
											
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择安全组！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
			
		
		}
		
	});
	
	// 增加修改的form
	var HOSPWinForm = new Ext.FormPanel({
				id : 'HOSP-form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : HOSP_SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 70,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'HOSPParRef',mapping:'HOSPParRef'},
                                         {name: 'HOSPRowId',mapping:'HOSPRowId'},
                                         {name: 'HOSPHospitalDR',mapping:'HOSPHospitalDR'}
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'HOSPParRef',
							xtype:'textfield',
							fieldLabel : 'HOSPParRef',
							name : 'HOSPParRef',
							hideLabel : 'True',
							hidden : true
						}, {
							id:'HOSPRowId',
							xtype:'textfield',
							fieldLabel : 'HOSPRowId',
							name : 'HOSPRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>医院',
							//name:'HOSPHospitalDR',
							hiddenName : 'HOSPHospitalDR',
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('HOSPHospitalDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('HOSPHospitalDR')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPHospitalDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Hosp_Comp_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'HOSPRowId',mapping:'HOSPRowId'},
										{name:'HOSPDesc',mapping:'HOSPDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'HOSPDesc',
							valueField : 'HOSPRowId'
						}]	
	});
			
	// 增加修改时弹出窗口
	var HOSPwin = new Ext.Window({
		title : '',
		width:320,
		height: 200,
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
		items : HOSPWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'HOSP_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSP_save_btn'),
			handler : function() {
				//-------添加----------
				if (HOSPwin.title == "添加") {
					
					HOSPWinForm.form.submit({
						url : HOSP_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'HOSPParRef' : grid.getSelectionModel().getSelected().get('SSGRPRowId')           //-------通过RowId来删除数据
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								HOSPwin.hide();
								var myrowid = action.result.id;
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = HOSPgrid.getBottomToolbar().cursor;
												HOSPgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
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
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							HOSPWinForm.form.submit({
								url : HOSP_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										HOSPwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = HOSPgrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("HOSPgrid",HOSP_ACTION_URL,myrowid)
												/*HOSPgrid.getStore().load({
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
				HOSPwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("HOSP-form-save").getForm().findField("HOSPHospitalDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				HOSPWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var HOSPbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'HOSP_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSP_add_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						HOSPwin.setTitle('添加');
						HOSPwin.setIconClass('icon-add');
						HOSPwin.show();
						HOSPWinForm.getForm().reset();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				},
				scope: this
	});
	// 修改按钮
	var HOSPbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'HOSP_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSP_update_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
					if (HOSPgrid.selModel.hasSelection()) {
						HOSPwin.setTitle('修改');
						HOSPwin.setIconClass('icon-update');
						HOSPwin.show();
						loadHOSPFormData(HOSPgrid);
						//var record = HOSPgrid.getSelectionModel().getSelected();
						//Ext.getCmp("HOSP-form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	var HOSPds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : HOSP_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'HOSPRowId',
								mapping : 'HOSPRowId',
								type : 'string'
							}, {
								name : 'HOSPParRef',
								mapping : 'HOSPParRef',
								type : 'string'
							}, {
								name : 'HOSPHospitalDR',
								mapping : 'HOSPHospitalDR',
								type : 'string'
							
							}
						])
	});
	
			
 	// 加载数据
	HOSPds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var HOSPpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : HOSPds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var HOSPsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var HOSPtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [HOSPbtnAddwin, '-', HOSPbtnEditwin, '-', HOSPbtnDel,'-']
	});
		
	// 搜索工具条
	var HOSPbtnSearch = new Ext.Button({
				id : 'HOSPbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPbtnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if(grid.selModel.hasSelection()){
						HOSPgrid.getStore().baseParams={							//-----------模糊查询				
							cthospital :  Ext.getCmp("TextCTHospitalDR").getValue(),			
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						
						};
						HOSPgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize
							}
						});
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	// 刷新工作条
	var HOSPbtnRefresh = new Ext.Button({
				id : 'HOSPbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('HOSPbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					if(grid.selModel.hasSelection()){
		
						Ext.getCmp("TextCTHospitalDR").reset();
						HOSPgrid.getStore().baseParams={
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						};
						//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
						//HOSPds.setBaseParam('ssgrprowid', grid.getSelectionModel().getSelected().get('SSGRPRowId')); 
						HOSPgrid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
									//ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
								}
							});	
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
		
	// 将工具条放到一起
	var HOSPtb = new Ext.Toolbar({
				id : 'HOSPtb',
				items : ['医院',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>医院',
							id : 'TextCTHospitalDR', //要用id而不是hiddenname
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCTHospitalDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Hosp_Comp_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'HOSPRowId',mapping:'HOSPRowId'},
										{name:'HOSPDesc',mapping:'HOSPDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'HOSPDesc',
							valueField : 'HOSPRowId'
						}, '-',
						HOSPbtnSearch,'-', 
						HOSPbtnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						HOSPtbbutton.render(HOSPgrid.tbar)
					}
				}
	});

	// 创建Grid
	var HOSPgrid = new Ext.grid.GridPanel({
				id : 'HOSPgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : HOSPds,
				trackMouseOver : true,
				columns :[HOSPsm, {
							header : 'HOSPParRef',
							width : 80,
							sortable : true,
							dataIndex : 'HOSPParRef',
							hidden:true
							
						}, {
							header : 'HOSPRowId',
							width : 80,
							sortable : true,
							dataIndex : 'HOSPRowId',
							hidden:true
						}, {
							header : '医院',
							width : 100,
							sortable : true,
							dataIndex : 'HOSPHospitalDR'
						
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : HOSPpaging,
				tbar : HOSPtb,
				stateId : 'HOSPgrid'
	});
Ext.BDP.FunLib.ShowUserHabit(HOSPgrid,"User.SSGroupHospitals");

   // 载入被选择的数据行的表单数据
    var loadHOSPFormData = function(grid) {
        var _record = HOSPgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            HOSPWinForm.form.load( {
                url : HOSP_OPEN_ACTION_URL + '&id='+ _record.get('HOSPRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };

    //双击事件
    HOSPgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			HOSPwin.setTitle('修改');
			HOSPwin.setIconClass('icon-update');
			HOSPwin.show();
        	loadHOSPFormData(HOSPgrid);
    });	
	
    
    
    
    //=====================医院（完）=====================
    
    
   
    var OSTATbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'OSTAT_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTAT_del_btn'),
		handler : function() {   
			if (grid.selModel.hasSelection()) {
			if (OSTATgrid.selModel.hasSelection()) {
				//Ext.MessageBox.confirm(String title,String msg,[function fn],[Object scope])
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						//Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = OSTATgrid.getSelectionModel();
						var rows = gsm.getSelections();
						//Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : OSTAT_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('OSTATRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(OSTATgrid,pagesize);
												
												
											}
											
									});
								}
								else {
										var errorMsg = '';
										if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
										Ext.Msg.show({
													title : '提示',
													msg : '数据删除失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								} 
								else {
									Ext.Msg.show({
												title : '提示',
												msg : '异步通讯失败,请检查网络连接！',
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
							msg : '请选择需要删除的行！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择安全组！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
			
		
		}
		
	});
	
	// 增加修改的form
	var OSTATWinForm = new Ext.FormPanel({
				id : 'OSTAT-form-save',
				//title : '数据信息',
				//collapsible : true,
				//region: 'west',
				//bodyStyle : 'padding:5px 5px 0 0',
				URL : OSTAT_SAVE_ACTION_URL,
				baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 70,
				split : true,
				frame : true,
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'OSTATParRef',mapping:'OSTATParRef'},
                                         {name: 'OSTATRowId',mapping:'OSTATRowId'},
                                         {name: 'OSTATOrdStatDR',mapping:'OSTATOrdStatDR'}
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'OSTATParRef',
							xtype:'textfield',
							fieldLabel : 'OSTATParRef',
							name : 'OSTATParRef',
							hideLabel : 'True',
							hidden : true
						}, {
							id:'OSTATRowId',
							xtype:'textfield',
							fieldLabel : 'OSTATRowId',
							name : 'OSTATRowId',
							hideLabel : 'True',
							hidden : true
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>医嘱状态',
							//name:'OSTATOrdStatDR',
							hiddenName : 'OSTATOrdStatDR',
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('OSTATOrdStatDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('OSTATOrdStatDR')),
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTATOrdStatDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : OSTAT_OrdStat_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'OSTATRowId',mapping:'OSTATRowId'},
										{name:'OSTATDesc',mapping:'OSTATDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'OSTATDesc',
							valueField : 'OSTATRowId'
						}]	
	});
			
	// 增加修改时弹出窗口
	var OSTATwin = new Ext.Window({
		title : '',
		width:320,
		height: 200,
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
		items : OSTATWinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'OSTAT_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTAT_save_btn'),
			handler : function() {
				//-------添加----------
				if (OSTATwin.title == "添加") {
					
					OSTATWinForm.form.submit({
						url : OSTAT_SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						params : {									  //-------请求带的参数
								'OSTATParRef' : grid.getSelectionModel().getSelected().get('SSGRPRowId')           //-------通过RowId来删除数据
							},
						success : function(form, action) {
							if (action.result.success == 'true') {
								OSTATwin.hide();
								var myrowid = action.result.id;
								//var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = OSTATgrid.getBottomToolbar().cursor;
												OSTATgrid.getStore().load({
															params : {
																start : 0,
																limit : pagesize,
																rowid : myrowid
															}
														});
											}
										});
							} else {
								var errorMsg = '';
								if (action.result.errorinfo) {
									errorMsg = '<br/>错误信息:'+ action.result.errorinfo
								}
								Ext.Msg.show({
											title : '提示',
											msg : '添加失败！' + errorMsg,
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
				} 
				//---------修改-------
				else {
					Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
						if (btn == 'yes') {
							OSTATWinForm.form.submit({
								url : OSTAT_SAVE_ACTION_URL,
								clientValidation : true,
								waitMsg : '正在提交数据请稍候...',
								waitTitle : '提示',
								method : 'POST',
								success : function(form, action) {
									if (action.result.success == 'true') {
										OSTATwin.hide();
										var myrowid = "rowid="+action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												var startIndex = OSTATgrid.getBottomToolbar().cursor;
												Ext.BDP.FunLib.ReturnDataForUpdate("OSTATgrid",OSTAT_ACTION_URL,myrowid)
												/*OSTATgrid.getStore().load({
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
				OSTATwin.hide();
			}
		}],
		listeners : {
			"show" : function() {
				//Ext.getCmp("OSTAT-form-save").getForm().findField("OSTATOrdStatDR").focus(true,700);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				OSTATWinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	
	// 增加按钮
	var OSTATbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'OSTAT_add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTAT_add_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						OSTATwin.setTitle('添加');
						OSTATwin.setIconClass('icon-add');
						OSTATwin.show();
						OSTATWinForm.getForm().reset();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					
				},
				scope: this
	});
	// 修改按钮
	var OSTATbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id:'OSTAT_update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTAT_update_btn'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
					if (OSTATgrid.selModel.hasSelection()) {
						OSTATwin.setTitle('修改');
						OSTATwin.setIconClass('icon-update');
						OSTATwin.show();
						loadOSTATFormData(OSTATgrid);
						//var record = OSTATgrid.getSelectionModel().getSelected();
						//Ext.getCmp("OSTAT-form-save").getForm().loadRecord(record);
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要修改的行！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	var OSTATds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : OSTAT_ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'OSTATRowId',
								mapping : 'OSTATRowId',
								type : 'string'
							}, {
								name : 'OSTATParRef',
								mapping : 'OSTATParRef',
								type : 'string'
							}, {
								name : 'OSTATOrdStatDR',
								mapping : 'OSTATOrdStatDR',
								type : 'string'
							
							}
						])
	});
	
			
 	// 加载数据
	OSTATds.load({
				params : { start : 0, limit : pagesize },
				callback : function(records, options, success) {
				}
	});			
			
	
	// 分页工具条
	var OSTATpaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : OSTATds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
	});

	var OSTATsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	// 增删改工具条
	var OSTATtbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [OSTATbtnAddwin, '-', OSTATbtnEditwin, '-', OSTATbtnDel,'-']
	});
		
	// 搜索工具条
	var OSTATbtnSearch = new Ext.Button({
				id : 'OSTATbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTATbtnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					if(grid.selModel.hasSelection()){
						OSTATgrid.getStore().baseParams={							//-----------模糊查询				
							ordstatdr :  Ext.getCmp("TextOSTATOrdStatDR").getValue(),			
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						
						};
						OSTATgrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize
							}
						});
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
	
	// 刷新工作条
	var OSTATbtnRefresh = new Ext.Button({
				id : 'OSTATbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('OSTATbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					if(grid.selModel.hasSelection()){
		
						Ext.getCmp("TextOSTATOrdStatDR").reset();
						OSTATgrid.getStore().baseParams={
							ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
						};
						//PagingToolbar默认只能加载两个参数,加载load里分页会有问题,第一页显示正常,后面第二页却为空白
						//OSTATds.setBaseParam('ssgrprowid', grid.getSelectionModel().getSelected().get('SSGRPRowId')); 
						OSTATgrid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
									//ssgrprowid : grid.getSelectionModel().getSelected().get('SSGRPRowId')
								}
							});	
					}else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择安全组！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
	});
		
	// 将工具条放到一起
	var OSTATtb = new Ext.Toolbar({
				id : 'OSTATtb',
				items : ['医嘱状态',{
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>医嘱状态',
							id : 'TextOSTATOrdStatDR', //要用id而不是hiddenname
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextOSTATOrdStatDR'),
							store : new Ext.data.Store({
										//autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : OSTAT_OrdStat_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'OSTATRowId',mapping:'OSTATRowId'},
										{name:'OSTATDesc',mapping:'OSTATDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'OSTATDesc',
							valueField : 'OSTATRowId'
						}, '-',
						OSTATbtnSearch,'-', 
						OSTATbtnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						OSTATtbbutton.render(OSTATgrid.tbar)
					}
				}
	});

	// 创建Grid
	var OSTATgrid = new Ext.grid.GridPanel({
				id : 'OSTATgrid',
				region : 'center',
				width : 900,
				height : 500,
				closable : true,
				store : OSTATds,
				trackMouseOver : true,
				columns :[OSTATsm, {
							header : 'OSTATParRef',
							width : 80,
							sortable : true,
							dataIndex : 'OSTATParRef',
							hidden:true
							
						}, {
							header : 'OSTATRowId',
							width : 80,
							sortable : true,
							dataIndex : 'OSTATRowId',
							hidden:true
						}, {
							header : '医嘱状态',
							width : 100,
							sortable : true,
							dataIndex : 'OSTATOrdStatDR'
						
						}],
				stripeRows : true,
				loadMask : {
					msg : '数据加载中,请稍候...'
				},
				// config options for stateful behavior
				stateful : true,
				viewConfig : {
					forceFit : true
				},
				bbar : OSTATpaging,
				tbar : OSTATtb,
				stateId : 'OSTATgrid'
	});
Ext.BDP.FunLib.ShowUserHabit(OSTATgrid,"User.SSGroupOrderStatus");

   // 载入被选择的数据行的表单数据
    var loadOSTATFormData = function(grid) {
        var _record = OSTATgrid.getSelectionModel().getSelected();
        if (!_record) {
            //Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            OSTATWinForm.form.load( {
                url : OSTAT_OPEN_ACTION_URL + '&id='+ _record.get('OSTATRowId'),
                //waitMsg : '正在载入数据...',
                success : function(form,action) {
                	//Ext.Msg.alert('编辑','载入成功！');
                },
                failure : function(form,action) {
                	Ext.Msg.alert('编辑','载入失败！');
                }
            });
        }
    };

    //双击事件
    OSTATgrid.on("rowdblclick", function(grid, rowIndex, e) {
		   	//var row = grid.getStore().getAt(rowIndex).data;
			OSTATwin.setTitle('修改');
			OSTATwin.setIconClass('icon-update');
			OSTATwin.show();
        	loadOSTATFormData(OSTATgrid);
    });	
	
    
    
    
    //=====================医嘱状态（完）=====================
    
    
    
    //=====================复制授权==============================

	var btnCopy = new Ext.Toolbar.Button({
		text : '复制权限',
		tooltip : '复制权限',
		iconCls : 'icon-copy',
		id:'copy_btn',
		disabled:Ext.BDP.FunLib.Component.DisableFlag('copy_btn'),
		handler : function(thiz) {
			if(grid.selModel.hasSelection()){
				if(copygrid.selModel.hasSelection()){
					var SSGroupDesc = grid.getSelectionModel().getSelections()[0].get('SSGRPDesc');
					var SSGroupDesc2 = copygrid.getSelectionModel().getSelections()[0].get('SSGRPDesc');
					if(SSGroupDesc==SSGroupDesc2){
						Ext.Msg.show({
										title : '提示',
										msg : '不能复制自己的权限！',
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
										});
					
					}
					else{
					Ext.MessageBox.confirm('提示', '	确定要把"'+SSGroupDesc2+'"的权限复制给"'+SSGroupDesc+'"吗？"'+SSGroupDesc+'"的原有权限将被覆盖！！', function(btn) {
					if (btn == 'yes') {   
						var SSGroupId1 = grid.getSelectionModel().getSelections()[0].get('SSGRPRowId');
						var SSGroupId2 = copygrid.getSelectionModel().getSelections()[0].get('SSGRPRowId');
						Ext.lib.Ajax.request(
				    	'POST',
				   	 	Copy_SAVE_ACTION_URL,
				   	 	{
				    	success:function(response){
				    		var jsonData=Ext.util.JSON.decode(response.responseText); //获取返回的信息
				    		if(jsonData.success=='true'){
				    			Ext.Msg.show({
										title : '提示',
										msg : '权限复制成功！',
										icon : Ext.Msg.INFO,
										buttons : Ext.Msg.OK,
										fn : function(btn) {
												STds.load();
												SSORDds.load();
											}
										});
				    		}
				    		else{
				    			
				    			var errorMsg = '';
								if (jsonData.info) {
											errorMsg = '<br/>错误信息:'+ jsonData.info
										}
								Ext.Msg.show({
											title : '提示',
											msg : '授权复制失败！' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
				    		}
				    		//Ext.Msg.alert('信息',response.responseText,function(){});	
				    	},
				    	failure:function(){
				    		Ext.Msg.alert("提示","与后台联系的时候出现了问题！");
				    	}
				   	 },
				   	 'SSGroupId1='+SSGroupId1+'&SSGroupId2='+SSGroupId2
					)		
				}
			});
			
			
				}
					
			}
				else{
					Ext.Msg.alert('提示', '请先选择被复制权限的安全组！');
				}
			}
			else{
				Ext.Msg.alert('提示', '请先选择要操作的安全组！');
			}
		},
		scope : this													// -------------作用域
	});
	
	var copyStore = Ext.data.Record.create([				        // -------------列的映射
						        {   name : 'SSGRPRowId',
									mapping : 'SSGRPRowId',
									type : 'string'
								}, {
									name : 'SSGRPCode',
									mapping : 'SSGRPCode',
									type : 'string'
								}, {
									name : 'SSGRPDesc',
									mapping : 'SSGRPDesc',
									type : 'string'
								}]);

    //------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------
	var copyds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ // ---------通过HttpProxy的方式读取原始数据
			url : Copy_ACTION_URL  // ---------调用的动作
		}),
		reader : new Ext.data.JsonReader({ // ---------将原始数据转换
			totalProperty : 'total',
			root : 'data',
			successProperty : 'success'
		}, copyStore)
	});
	copyds.load({
				params : {												  // ----------ds加载时发送的附加参数
					start : 0,
					limit : pagesize
				},
				callback : function(records, options, success) {          // ----------加载完成后执行的回调函数
				
					 //alert(options);
					 //Ext.Msg.alert('info', '加载完毕, success = '+records.length);
				}
			});
			
	
	var copypaging = new Ext.PagingToolbar({
				pageSize : pagesize,
				store : copyds,	
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize=this.pageSize;
         		}
          		},										     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				//displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})

	var copytbbutton = new Ext.Toolbar({
		//enableOverflow : true,										
		items : [btnCopy, '-']			                 //------------通过'-'连接每个按钮也可以用'separator'代替
		});	

	var copybtnSearch = new Ext.Button({
				id : 'copybtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('copybtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  //-----------执行回调函数
				copygrid.getStore().baseParams={							//-----------模糊查询	
					
						desc :  Ext.getCmp("TGroupDesc").getValue()
						
				};
				copygrid.getStore().load({									//-----------加载查询出来的数据
					params : {
						start : 0,
						limit : pagesize
					}
				});
				}
			});		

	var copybtnRefresh = new Ext.Button({
				id : 'copybtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('copybtnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TGroupDesc").reset();                     //-----------将输入框清空
					copygrid.getStore().baseParams={};
					copygrid.getStore().load({                              //-----------加载数据
								params : {
									start : 0,
									limit : pagesize
								}
							});
				}

			});		

	var copytb = new Ext.Toolbar({
				id : 'copytb',
				items : ['安全组描述', {
							xtype : 'textfield',
							id : 'TGroupDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TGroupDesc'),
							width:85
						},'-',copybtnSearch,'-', copybtnRefresh,'-',btnCopy ,'->']
			});
	var copygrid = new Ext.grid.GridPanel({
				id : 'copygrid',
				region : 'center',
				width:'20%',
				store : copyds,										//----------------表格的数据集
				layout:'fit',
				trackMouseOver : true,                              //----------------鼠标移动到某一行将显示高亮
				columns : [sm, {									//----------------定义列
							header : 'SSGRP_RowId',
							sortable : true,
							dataIndex : 'SSGRPRowId',
							hidden : true                          //-----------------隐藏掉rowid
						},{
							header : '安全组代码',
							sortable : true,
							dataIndex : 'SSGRPCode'
						},{
							header : '安全组描述',
							sortable : true,
							dataIndex : 'SSGRPDesc'
						}],
				stripeRows : true,                                //------------------显示斑马线

				//title : '权限复制授权维护',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								
				},
				bbar : copypaging,                                    //-----------------底部状态栏
				tbar : copytb, 
				stateId : 'copygrid'
			});

    Ext.BDP.FunLib.ShowUserHabit(copygrid,"User.SSGroup1");
    //====================复制授权（完）============================
	var url1= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlS1","");
	if ('undefined'!==typeof websys_getMWToken)
    {
		url1 += "&MWToken="+websys_getMWToken() //20230209 增加token
	}
	var htmlS1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url1+"'></iframe>";
	var url2= tkMakeServerCall("web.DHCBL.CT.SSGroup","GetHtmlM1","");
	if ('undefined'!==typeof websys_getMWToken)
    {
		url2 += "&MWToken="+websys_getMWToken() //20230209 增加token
	}
	var htmlM1 = "<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url2+"&SingleHospId="+hospComp.getValue()+"'></iframe>";
				
	//var htmlS1 ="<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='websys.default.csp?WEBSYS.TCOMPONENT=epr.GroupSettings.Edit&GroupID=''&ID='' '></iframe>"
	//var htmlM1 ="<iframe frameborder='0' scrolling='auto' height='100%' width='100%' src='epr.groupsettings.editmenusecurity.csp?GroupDR=''&ID=''&SSGRPDesc='' '></iframe>"
	
	 var tabs = new Ext.TabPanel({
		id : 'tabs',
		width:'80%',
		activeTab : 0,
        region:'center',
        enableTabScroll:true,
        resizeTabs: true,
        tabWidth:120,
		minTabWidth:60,
        //margins:'0 5 5 0',
		items : [{

					layout:'fit',
					title : '详细信息',
					items : [SSGRPBaseInfoWinform]
				} ,{
					title : '安全组设置',
					closable:false,
					id:'tabset',
         			xtype:'panel',
        			html:htmlS1
            		
            	} ,{
					
					title : '菜单配置',
					closable:false,
					id:'tabmenu',
             		xtype:'panel',
            		html:htmlM1
            		
				} ,{
					layout:'fit',
					title : '医嘱授权',
					items : [SSORDgrid]
				} ,{
					layout:'fit',
					title : '库存授权',
					items : [STgrid]
				
				},{
					layout:'fit',
					title : '医嘱状态',
					items : [OSTATgrid]
				},{
					layout:'fit',
					title : '医院',
					items : [HOSPgrid]
				},{
					layout:'fit',
					title : '复制授权',
					items : [copygrid]
				/*},{
					//layout:'fit',
					title : '安全组其他配置',
					layout : 'border',
					items:[setmenuPanel,setcentertab]
				
				*/	
					
				}],
		listeners : {
					tabchange : function(tp, p) {
						if (grid.selModel.hasSelection()) { // -------如果选中某一行则继续执行
							var gsm = grid.getSelectionModel(); // ------获取选择列
							var rows = gsm.getSelections();
							var ssgrprowid = rows[0].get('SSGRPRowId');
							
							switchcase(p.title, ssgrprowid);
							/*
							var rowid1;
							if (SSORDgrid.getStore().getTotalCount() != 0) {
								rowid1 = SSORDgrid.getStore().getAt(0).get('SSORDParRef');
							}
							if (ssgrprowid != rowid1||SSORDgrid.getStore().getTotalCount() == 0) {
								switchcase(p.title, ssgrprowid);
							}
							
						*/
   							
							
        		   			/*setmenuTreeLoader.dataUrl = setTREE_ACTION_URL ;   
         		  			setmenuTreeLoader.baseParams = {GroupRowId:ssgrprowid};   
   							
   							setmenuPanel.root.reload();*/
   				
						}
						else
						{
							switchcase(p.title, '');
						}
					}
				}
			});
	var GroupId=Ext.BDP.FunLib.getParam('GroupId');  //PORATAL组传参 2020-04-15
	/*setmenuPanel.on('beforeload', function(){    
   		setmenuTreeLoader.dataUrl = setTREE_ACTION_URL ;   
   		setmenuTreeLoader.baseParams = {GroupRowId:""};   
   	});
   	setmenuPanel.root.reload();		*/
	Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);		
	var viewport = new Ext.Viewport({
				layout : 'border',
				defaults:{split:true},
				items : [{
					frame:true,
					xtype: 'panel',
			        region: 'north',
			        layout:'form',
			        labelAlign : 'right',
					labelWidth : 30,
					items:[hospComp],
			        height: 35,
			        border: false
			    },grid,tabs],
				listeners: {
		            'afterlayout': function(n) {
		               // alert("viewafterlayout")
		            }
		        }

	});
	Ext.getCmp('tbActiveFlag').setValue("Y")
	///多院区医院
	var flag= tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")
	if (flag=="Y"){
		
	}
	else
	{
		// 加载数据  Portal组传参，获取传过来的安全组id，并选中，详细信息里加载安全组的数据 2020-04-15
    	if (GroupId>0)
    	{
    		grid.getStore().load({
					params : { start : 0, limit : pagesize,rowid: GroupId},
					callback : function(records, options, success) {
						grid.getSelectionModel().selectRow(0)
						var title = Ext.getCmp('tabs').getActiveTab().title;
						switchcase(title, GroupId)
						
					}
				});
    	}
    	else
    	{
    		grid.getStore().baseParams={
					activeflag:'Y',
					desc : Ext.getCmp("TextDesc").getValue()
			};
    		grid.getStore().load({
					params : { start : 0, limit : pagesize},
					callback : function(records, options, success) {
						
						
					}
				});
    		
    	}
		
	
	}
	
	
});