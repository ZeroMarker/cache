 
    /// 名称:药学-3 频次维护
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹 
	/// 编写日期:2012-8-30
	
	///ofy1 南方医院 2017-12-07  添加PHCFROrderNum (序号（用于决定医生站下医嘱界面频次的显示顺序）)  $P($G(^PHCFR(id,"DHC")),"^",2)
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	////2017-09-08 PRN（必要时）/ST（即刻）/once(一次） 分发时间不一定要与分发次数对应  其他的需要保持一致，否则门诊结算时会报错、住院不会产生执行记录。  		  //SOS（15分钟内执行）/
Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "PHC_Freq"
	});
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var DT_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCDispensingTime&pClassQuery=GetList";
	var DT_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCDispensingTime&pClassMethod=OpenData";
	var DT_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCDispensingTime&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCDispensingTime";
	var DT_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCDispensingTime&pClassMethod=DeleteData";
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.PHCFreq&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCFreq&pClassMethod=OpenData";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.PHCFreq&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.PHCFreq";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCFreq&pClassMethod=DeleteData";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1= Ext.BDP.FunLib.PageSize.Pop;
	Ext.QuickTips.init();												  //--------启用悬浮提示
	Ext.form.Field.prototype.msgTarget = 'qtip'; 
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.PHCFreq";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="PHC_Freq"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	Ext.BDP.FunLib.SelectRowIdD=""
	///翻译按钮(分发时间）  2021-12-02add
	var btnTransD = new Ext.Toolbar.Button({
				text : '翻译',
				tooltip : '翻译',
				iconCls : 'icon-edit',
				handler : function OpenTransWin() {
					if(Ext.BDP.FunLib.SelectRowIdD!=""){
						 var link="dhc.bdp.ext.default.csp?extfilename=App/BDPSystem/BDPTranslation&selectrow="+Ext.BDP.FunLib.SelectRowIdD+"&tableName="+"PHC_DispensingTime";
						 if ('undefined'!==typeof websys_getMWToken){
							link += "&MWToken="+websys_getMWToken()
						}
						 var TransWin = new Ext.Window({
								width:650,
					            height:400,
					            id:'TransWin',
					            title:'',
							   	layout : 'fit',
								plain : true,// true则主体背景透明
								modal : true,
								frame : true,
							    autoScroll : false,
								collapsible : true,
								hideCollapseTool : true,
								titleCollapse : true,
								constrain : true,
								closeAction : 'close',
								html : '<iframe src=" '+link+' " width="100%" height="100%"></iframe>'
							});
						TransWin.setTitle('数据翻译');
						TransWin.setIconClass('icon-edit');
						TransWin.show();				
					}else{
						Ext.Msg.show({
									title : '提示',
									msg : '请选择需要翻译的分发时间数据！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	if(TransFalg=="false"){
		btnTransD.hidden=false;
	}else{
		btnTransD.hidden=true;
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
			RowID=rows[0].get('PHCFRRowId');
			Desc=rows[0].get('PHCFRDesc1');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	
	/**----初始化Ext状态管理器，在Cookie中记录用户的操作状态*/
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());   
	
	
	//---------------------------------------------分发时间--------------------------------------	
	
	// 删除功能
	var dtbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'dt_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('dt_del_btn'),
		handler : function() {
			if (dtgrid.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				var gsm = dtgrid.getSelectionModel();
				var rows = gsm.getSelections();
				if(rows[0].get('PHCDTRowId'))   //判断选中的数据是否已经保存
				{
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : DT_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('PHCDTRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {
									var jsonData = Ext.util.JSON.decode(response.responseText);
									if (jsonData.success == 'true') {
										// var myrowid = action.result.id;
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												var startIndex = dtgrid.getBottomToolbar().cursor;
												var totalnum=dtgrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=dtgrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												dtgrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1,
																parref : grid.getSelectionModel().getSelected().get('PHCFRRowId')  
																}	
														});	
											//不重新加载,只移除被删除的行
											//var targetRecord = dtgrid.getSelectionModel().getSelected();
											//dtds.remove(targetRecord);
	
											}
										});
									} else {
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
				}, this);
			}
			else
			{
				var targetRecord = dtgrid.getSelectionModel().getSelected();
				dtds.remove(targetRecord);
				dtds.totalLength=dtgrid.getStore().getTotalCount()-1
    	 		dtpaging.bindStore(dtds)
			}	
				
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

	// 增加按钮
	var dtbtnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id : 'dt_addbtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('dt_addbtn'),
				handler : function() {
					
					var Code=Ext.getCmp("PHCFRCodeF").getValue();
					if(((Code.toUpperCase()=="PRN")||(Code.toUpperCase()=="ST")||(Code.toUpperCase()=="ONCE")))
					{	
						Ext.Msg.show({						//--------------显示错误信息文本框
								title : '提示',
								msg : "ST/ONCE/PRN不需要维护分发时间！",
								minWidth : 200,
								icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
								buttons : Ext.Msg.OK    //--------------只有一个确定按钮
							});
			   				return;
					 	
						
					 }
					 else
					 {
					 	
					 	
					 	if ((Ext.getCmp("PHCFRIntervalUomF").getValue()=="H")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))  //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间。
						{
							
							Ext.Msg.show({						//--------------显示错误信息文本框
								title : '提示',
								msg : "间隔单位为“小时”时，不需要维护分发时间！",
								minWidth : 200,
								icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
								buttons : Ext.Msg.OK    //--------------只有一个确定按钮
							});
			   				return;
						 	
							
							
						}
						else
						{
							
							if(Ext.getCmp("PHCFRDesc1F").getValue()=="")  ///英文描述
							{	
								Ext.Msg.show({
											title : '提示',
											msg : '频次英文描述不可为空！',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
								return;
							}
							
							var time=Ext.getCmp("tbPHCDTTime").getValue()
							var timedesc=Ext.getCmp("tbPHCDTTimeDesc").getValue()
							if (time=="")
							{
								Ext.Msg.show({
										title : '提示',
										msg : '请选择分发时间！',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
								return;
							}
							
							///重复校验 ，2015-10-13 chenying
							for (var i = 0; i < dtds.getCount(); i++) {
									var record1 = dtds.getAt(i);
									var PHCDTTime = record1.get('PHCDTTime');
									var PHCDTTimeDesc = record1.get('PHCDTTimeDesc');
									if ((time==PHCDTTime)&&(PHCDTTimeDesc==timedesc))
									{
										Ext.Msg.show({
											title:'提示',
											msg:'该记录已存在!',
											minWidth:200,
											icon:Ext.Msg.ERROR,
											buttons:Ext.Msg.OK
										});
										return;
									}
								}
								
						 	//勾选了【不规则分发时间标志】，分发时间描述要求必填
							//勾选了【不规则分发时间标志】 不校验次数和分发时间 chenying  2020-11-13 医生站提需求。
							if (Ext.getCmp("PHCFRIrregularDistributTimeFlagF").getValue()==true)
							{
								if (timedesc=="")
								{
									Ext.Msg.show({
											title : '提示',
											msg : '勾选了【不规则分发时间标志】后，分发时间描述为必填项！',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
									return;
								}
							}	
							else
							{
								//不勾选了【不规则分发时间标志】 ，分发次数要求必填
								var factor=Ext.getCmp("PHCFRFactorF").getValue();  ///分发次数
								if (factor=="")
								{
									Ext.Msg.show({						//--------------显示错误信息文本框
										title : '提示',
										msg : "频次的分发次数必填！",
										minWidth : 200,
										icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
										buttons : Ext.Msg.OK    //--------------只有一个确定按钮
									});
					   				return;
								}
								
								//勾选了【周频次】可以不校验次数和分发次数 chenying  2019-01-15 王伟提需求。 2022-1-05放开限制。
								//if ((Ext.getCmp("PHCFRWeekFlagF").getValue()==false))
								//{
									var storeCount = dtgrid.getStore().getTotalCount();
									if((storeCount)>=factor)
								 	{
								 		Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提示',
											msg : "添加失败！</br>分发时间要与分发次数对应！",
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
						   				return;
								 	}
									
							
							}
						 }
					}
       				var record = new Ext.data.Record({
    	 					'PHCDTRowId':'',
    	 					'PHCDTPHCFRParRef':'',
    	 					'PHCDTTime':Ext.getCmp('tbPHCDTTime').getValue(),
    	 					'PHCDTTimeDesc':Ext.getCmp('tbPHCDTTimeDesc').getValue()
    	 					
    	 					
    	 			});
    	 			var Pstorecount=dtgrid.getStore().getCount()  ///本页数据条数
    	 			dtgrid.stopEditing();
    	 			dtds.insert(Pstorecount,record); 	    //// dtds.insert(0,record);   2017-6-1 项目上反馈保存到数据库的时间的顺序很重要，不能反，所以要顺序插入， 不能将新添加的插入到第一条
    	 			Ext.getCmp("tbPHCDTTime").reset();
    	 			Ext.getCmp("tbPHCDTTimeDesc").reset();
    	 			var num = dtgrid.getStore().getCount()
    	 			
    	 			//dtgrid.getBottomToolbar().bind(dsds)
    	 			dtds.totalLength=dtgrid.getStore().getTotalCount()+1
    	 			dtpaging.bindStore(dtds)
					
    	 			
    	 			
				},
				scope : this
			});

	// 修改按钮
	var dtbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'dt_updatebtn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('dt_updatebtn'),
				handler : function() {
					if (dtgrid.selModel.hasSelection()) {
						var time=Ext.getCmp("tbPHCDTTime").getValue()
						var timedesc=Ext.getCmp("tbPHCDTTimeDesc").getValue()
						if (time=="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : '请选择分发时间！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							return;
						}
						if ((timedesc=="")&&(Ext.getCmp("PHCFRIrregularDistributTimeFlagF").getValue()==true))
						{
							Ext.Msg.show({
									title : '提示',
									msg : '勾选了【不规则分发时间标志】后，分发时间描述为必填项！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
							return;
						}
						
						///重复校验 ，2015-10-13 chenying
						for (var i = 0; i < dtds.getCount(); i++) {
								var record1 = dtds.getAt(i);
								var PHCDTTime = record1.get('PHCDTTime');
								var PHCDTTimeDesc = record1.get('PHCDTTimeDesc');
								if ((time==PHCDTTime)&&(PHCDTTimeDesc==timedesc))
								{
									Ext.Msg.show({
										title:'提示',
										msg:'该记录已存在!',
										minWidth:200,
										icon:Ext.Msg.ERROR,
										buttons:Ext.Msg.OK
									});
									return;
								}
							}
						var myrecord = dtgrid.getSelectionModel().getSelected();
    	 				myrecord.set('PHCDTTime',Ext.getCmp('tbPHCDTTime').getValue());
    	 				myrecord.set('PHCDTTimeDesc',Ext.getCmp('tbPHCDTTimeDesc').getValue());
						Ext.getCmp("tbPHCDTTime").reset();
						Ext.getCmp("PHCDTTimeDesc").reset();
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
	var SAVE_DT_ALL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.PHCDispensingTime&pClassMethod=SaveAll";
	
	function savedt(rowid){
 		var dtstr="";
	    dtds.each(function(record){
			if(dtstr!="") dtstr = dtstr+"*";
			dtstr = dtstr+record.get('PHCDTRowId')+'^'+record.get('PHCDTTime')+'^'+record.get('PHCDTTimeDesc');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_DT_ALL,
			method:'POST',
			params:{
				'rowid':rowid,
				'dtstr':dtstr
			}	
		});  
	}	
	// 刷新工作条
	var dtbtnRefresh = new Ext.Button({
				id : 'dtbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('dtbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.BDP.FunLib.SelectRowIdD ="";
					Ext.getCmp("tbPHCDTTime").reset();
					Ext.getCmp("tbPHCDTTimeDesc").reset();
					if(win.title=="修改")
					{
						dtgrid.getStore().baseParams={
									parref : grid.getSelectionModel().getSelected().get('PHCFRRowId')	
						};
						
					}
					else
					{
						dtgrid.getStore().baseParams={
								parref : ""
					};
					dtgrid.getStore().load({
						params : {
								start : 0,
								limit : pagesize1
						}
					});
					}
					
					
				}
	});
	var dtds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : DT_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'PHCDTRowId',
								mapping : 'PHCDTRowId',
								type : 'string'
							}, {
								name : 'PHCDTPHCFRParRef',
								mapping : 'PHCDTPHCFRParRef',
								type : 'string'	
							}, {
								name : 'PHCDTTime',
								mapping : 'PHCDTTime',
								type : 'string'	
							}, {
								name : 'PHCDTTimeDesc',
								mapping : 'PHCDTTimeDesc',
								type : 'string'	
						
							}])
			// remoteSort : true
		});

	// 加载数据
	dtds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var dtpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : dtds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize1=this.pageSize;
         		}
          		},
				displayInfo : true,
				//displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
			});

	var dtsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});
	
					
			
	// 增删改工具条
	var dttbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [dtbtnAddwin, '-', dtbtnEditwin, '-',dtbtnDel,'-',btnTransD]
			});
	// 将工具条放到一起
	var dttb = new Ext.Toolbar({
				id : 'dttb',
				items : ['分发时间', {
					xtype:'timefield',
					id:'tbPHCDTTime',			
            		format:'H:i:s',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('tbPHCDTTime'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tbPHCDTTime')),
					name : 'PHCDTTime'
				},'-', '分发时间描述', {
					xtype:'textfield',
					id:'tbPHCDTTimeDesc',			
            		readOnly : Ext.BDP.FunLib.Component.DisableFlag('tbPHCDTTimeDesc'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('tbPHCDTTimeDesc')),
					name : 'PHCDTTimeDesc'
				},'-', 
						dtbtnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						dttbbutton.render(dtgrid.tbar)
					}
				}
	});
	
	// 创建Grid
	var dtgrid = new Ext.grid.GridPanel({
				title : '分发时间',
				id : 'dtgrid',
				region : 'center',
				width : 420,
				height : 230,
				store : dtds,
				trackMouseOver : true,
				columns : [dtsm, {
							header : 'PHCDTRowId',
							width : 70,
							sortable : true,
							hidden : true,
							dataIndex : 'PHCDTRowId'
						}, {
							header : 'PHCDTPHCFRParRef',
							width : 80,
							sortable : true,
							hidden : true,
							dataIndex : 'PHCDTPHCFRParRef'
							
						}, {
							header : '分发时间',
							width : 80,
							sortable : true,
							dataIndex : 'PHCDTTime'
						}, {
							header : '分发时间描述',
							width : 80,
							sortable : true,
							dataIndex : 'PHCDTTimeDesc'
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
				bbar : dtpaging,
				tbar : dttb,
				stateId : 'dtgrid'
			});
		Ext.BDP.FunLib.ShowUserHabit(dtgrid,"User.PHCDispensingTime");
		
	dtgrid.on("rowclick",function(grid,rowIndex,e){
		var _record1 = dtgrid.getSelectionModel().getSelected();//records[0]
		
	    Ext.getCmp("tbPHCDTTime").setValue(_record1.get('PHCDTTime'));
	   	Ext.getCmp("tbPHCDTTimeDesc").setValue(_record1.get('PHCDTTimeDesc'));
	    Ext.BDP.FunLib.SelectRowIdD =_record1.get('PHCDTRowId');
	});	
		
	// ------------------------------------------药理学小子分类（完）--------------------------------------------------
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
						AliasGrid.DataRefer = rows[0].get('PHCFRRowId');
						AliasGrid.delallAlias();
						
						//开始处理请求
						Ext.Ajax.request({	                              	
							url : DELETE_ACTION_URL,					  //-------发出请求的路径
							method : 'POST',                              //-------需要传递参数 用POST
							params : {									  //-------请求带的参数
								'id' : rows[0].get('PHCFRRowId')          //-------通过RowId来删除数据
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
				autoScroll:true,  ///滚动条
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 230,
				split : true,
				frame : true, //--------Panel具有全部阴影，若为false则只有边框有阴影			
				waitMsgTarget : true,
				defaults : {
					anchor : '90%',
					bosrder : false
				},
				reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'PHCFRRowId',mapping:'PHCFRRowId',type:'string'},
                                         {name: 'PHCFRCode',mapping:'PHCFRCode',type:'string'},
                                         {name: 'PHCFRDesc1',mapping:'PHCFRDesc1',type:'string'},
                                         {name: 'PHCFRDesc2',mapping:'PHCFRDesc2',type:'string'},
                                         {name: 'PHCFRFactor',mapping:'PHCFRFactor',type:'string'},
                                         {name: 'PHCFRWeekFlag',mapping:'PHCFRWeekFlag',type:'string'},
                                         {name: 'PHCFRWeekFactor',mapping:'PHCFRWeekFactor',type:'string'},
                                         {name: 'PHCFRNoDelayExecute',mapping:'PHCFRNoDelayExecute',type:'string'},
                                         {name: 'PHCFRNoDelayExecute2',mapping:'PHCFRNoDelayExecute2',type:'string'},
                                         {name: 'PHCFRActiveFlag',mapping:'PHCFRActiveFlag',type:'string'},
                                         {name: 'PHCFRClinicTypeO',mapping:'PHCFRClinicTypeO',type:'string'},
                                         {name: 'PHCFRClinicTypeE',mapping:'PHCFRClinicTypeE',type:'string'},
                                         {name: 'PHCFRClinicTypeI',mapping:'PHCFRClinicTypeI',type:'string'},
                                         {name: 'PHCFRClinicTypeH',mapping:'PHCFRClinicTypeH',type:'string'},
                                         {name: 'PHCFRClinicTypeN',mapping:'PHCFRClinicTypeN',type:'string'}
                                         ,{name: 'PHCFRDays',mapping:'PHCFRDays',type:'string'}
                                         ,{name: 'PHCFRIntervalTime',mapping:'PHCFRIntervalTime',type:'string'}
                                         ,{name: 'PHCFRIrregularDistributTimeFlag',mapping:'PHCFRIrregularDistributTimeFlag',type:'string'}
                                         ,{name: 'PHCFRIntervalUom',mapping:'PHCFRIntervalUom',type:'string'},
                                         {name: 'PHCFRWeek1',mapping:'PHCFRWeek1',type:'string'},
                                         {name: 'PHCFRWeek2',mapping:'PHCFRWeek2',type:'string'},
                                         {name: 'PHCFRWeek3',mapping:'PHCFRWeek3',type:'string'},
                                         {name: 'PHCFRWeek4',mapping:'PHCFRWeek4',type:'string'},
                                         {name: 'PHCFRWeek5',mapping:'PHCFRWeek5',type:'string'},
                                         {name: 'PHCFRWeek6',mapping:'PHCFRWeek6',type:'string'},
                                         {name: 'PHCFRWeek7',mapping:'PHCFRWeek7',type:'string'}
                                         
                                         
                                        ]),
				items : {
			xtype:'fieldset',
			border:false,
			autoHeight:true,
			items :[{
				baseCls : 'x-plain',
				layout:'column',
				border:false,
				items:[{
					baseCls : 'x-plain',
					columnWidth:'.55',
					layout: 'form',
					labelPad:1,//默认5
					border:false,
					defaults: {anchor:'90%'},
					items: [{
							fieldLabel : 'PHCFRRowId',
							hideLabel : 'True',
							xtype:'textfield',
							hidden : true,                               //--------RowId属性隐藏
							name : 'PHCFRRowId'
					}, {
							fieldLabel : "<span style='color:red;'>*</span>代码",
							name : 'PHCFRCode',
							id:'PHCFRCodeF',
							maxLength:15,
							xtype:'textfield',
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRCodeF'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRCodeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRCodeF')),
							allowBlank:false,
							enableKeyEvents:true, 
 							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCFreq";
	                            var classMethod = "FormValidate";                     
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCFRRowId');
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
						    listeners : {
						    	'change' : Ext.BDP.FunLib.Component.ReturnValidResult,
						    	'blur':function(f){
						    		
						    		var Code=Ext.getCmp("PHCFRCodeF").getValue();
									if ((Code.toUpperCase()=="ST")||(Code.toUpperCase()=="ONCE"))
									{	
										Ext.getCmp("PHCFRFactorF").setValue(1) //ST/ONCE分发次数要求为1
										Ext.getCmp("PHCFRDaysF").setValue("")  //ST/ONCE间隔长度要求为空
										Ext.getCmp("PHCFRIntervalUomF").setValue("")  //ST/ONCE间隔单位要求为空		
										Ext.getCmp("PHCFRWeekFlagF").setValue(false)  //ST/ONCE不允许勾选周频次
										Ext.getCmp("PHCFRWeekFactorF").setValue("") //ST/ONCE周频次系数要求为空
										Ext.getCmp("PHCFRIrregularDistributTimeFlagF").setValue(false)  //不规则分发时间标志不勾选
										
									 }
									 
									if(Code.toUpperCase()=="PRN")
									{	
										Ext.getCmp("PHCFRFactorF").setValue("") //PRN分发次数要求为空
										Ext.getCmp("PHCFRDaysF").setValue("")  //PRN间隔长度要求为空
										Ext.getCmp("PHCFRIntervalUomF").setValue("") //PRN间隔单位要求为空
										Ext.getCmp("PHCFRWeekFlagF").setValue(false)  //PRN不允许勾选周频次
										Ext.getCmp("PHCFRWeekFactorF").setValue("")  //PRN周频次系数要求为空
										Ext.getCmp("PHCFRIrregularDistributTimeFlagF").setValue(false)  //不规则分发时间标志不勾选
									 }
									
								}
						    	
						    }
					},{
							fieldLabel : "<span style='color:red;'>*</span>英文描述",
							name : 'PHCFRDesc1',
							id:'PHCFRDesc1F',
							maxLength:220,
							xtype:'textfield',
							allowBlank:false,
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc1F'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc1F'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc1F')),
							enableKeyEvents:true, 
						    validationEvent : 'blur',  
						    validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.PHCFreq";
	                            var classMethod = "FormValidate";
	                            var id="";
	                            if(win.title=='修改'){
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('PHCFRRowId');
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
							fieldLabel : "中文描述",
							name : 'PHCFRDesc2',
							id:'PHCFRDesc2F',
							maxLength:220,
							xtype:'textfield',
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc2F')
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc2F'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRDesc2F'))
					},{
							fieldLabel : "分发次数(每天)",  //<span style='color:red;'>*</span>
							name : 'PHCFRFactor',
							//allowBlank:false, //勾选了【不规则分发时间标志】后，分发系数可以不填
							xtype:'numberfield',
							minValue : 0,
							maxValue : 100000,
							allowNegative : false,//不允许输入负数
							allowDecimals : false,//不允许输入小数
							id:'PHCFRFactorF',
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF')
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF')),
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '对于间隔单位为小时的频次，分发次数代表每天的最大分发次数'  
				                    })  
				                }  
				            }  
					}, {
							fieldLabel: '是否激活',
							xtype : 'checkbox',
							name : 'PHCFRActiveFlag',
							id:'PHCFRActiveFlagF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRActiveFlagF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRActiveFlagF')),
							inputValue : 'Y',
							checked:true
					},{
							fieldLabel : "间隔长度",  //原来：间隔天数
							id:'PHCFRDaysF',
							xtype:'numberfield',
							minValue : 0,
							//maxLength:8,
							maxValue : 99999999,
							allowNegative : false,//不允许输入负数
							allowDecimals : false,//不允许输入小数
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDaysF'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRDaysF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRDaysF')),
							name : 'PHCFRDays',
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '间隔长度和间隔单位要成对维护；如果间隔单位为小时，不允许维护分发时间。'  
				                    })  
				                },
				                'blur' : function(){
									if ((Ext.getCmp("PHCFRIntervalUomF").getValue()=="H")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))  //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间。
									{
										var days=Ext.getCmp("PHCFRDaysF").getValue()
										var factor=""
										if (days>0) factor=Math.ceil(24/days)
										Ext.getCmp("PHCFRFactorF").setValue(factor) //间隔单位为“小时”时，分发次数要求为空！"
										Ext.getCmp("PHCFRFactorF").setDisabled(true);
									}
									else
									{
										var flag=Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF');
										Ext.getCmp("PHCFRFactorF").setDisabled(flag);
									}
								}
				            }  
					},{
							fieldLabel : '间隔单位',
							xtype : 'combo',
							hiddenName: 'PHCFRIntervalUom',
							//name : 'PHCFRIntervalUom',
							id : 'PHCFRIntervalUomF',
		   					//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRIntervalUomF'),
		   					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRIntervalUomF')),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRIntervalUomF'),
							mode : 'local',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
								fields : ['name', 'value'],
								data : [{
											name : '天(D)',
											value : 'D'
										}, {
											name : '小时(H)',
											value : 'H'
										}]
							}),
							listeners : {
								'select': function(field,e){
							   		if ((Ext.getCmp("PHCFRIntervalUomF").getValue()=="H")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))  //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间。
									{
										var days=Ext.getCmp("PHCFRDaysF").getValue()
										var factor=""
										if (days>0) factor=Math.ceil(24/days)
										Ext.getCmp("PHCFRFactorF").setValue(factor) //间隔单位为“小时”时，分发次数要求为空！"
										Ext.getCmp("PHCFRFactorF").setDisabled(true);
									}
									else
									{
										var flag=Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF');
										Ext.getCmp("PHCFRFactorF").setDisabled(flag);
									}
		                     	}
							}
					}, {
							fieldLabel: '周频次',   
							xtype : 'checkbox',
							name : 'PHCFRWeekFlag',
							id:'PHCFRWeekFlagF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekFlagF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekFlagF')),
							inputValue : 'Y',
							checked:false,
							listeners : {
								'check' :function() {
										if (Ext.getCmp("PHCFRWeekFlagF").getValue())  //勾选时
										{
											Ext.getCmp("PHCFRWeekFactorF").setDisabled(false)
											Ext.getCmp("PHCFRIrregularDistributTimeFlagF").setValue(false) //【不规则分发时间标志】应与【周频次】、【周频次系数】互斥
										}
										else
										{
											Ext.getCmp("PHCFRWeekFactorF").setDisabled(true)
											Ext.getCmp("PHCFRWeekFactorF").setValue("")
											
											
										}
								}
							}
					},{ 
							fieldLabel : "周频次系数(每周)",  //2019-05-07
							id:'PHCFRWeekFactorF',
							xtype:'numberfield',
							minValue : 0,
							maxValue : 7,
							allowNegative : false,//不允许输入负数
							allowDecimals : false,//不允许输入小数
   							//disabled : Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekFactorF'),
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekFactorF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekFactorF')),
							name : 'PHCFRWeekFactor'
					
					}, {
							fieldLabel: '门诊默认按分发次数全执行',
							xtype : 'checkbox',
							name : 'PHCFRNoDelayExecute',
							id:'PHCFRNoDelayExecuteF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRNoDelayExecuteF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRNoDelayExecuteF')),
							inputValue : 'Y',
							checked:true,
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '若首日执行录入框可填，则默认为全部分发次数；若录入框不可填，则当日直接按照全部分发次数生成执行记录'  
				                    })  
				                }  
				            }  
					}, {
							fieldLabel: '住院默认按分发次数全执行',
							xtype : 'checkbox',
							name : 'PHCFRNoDelayExecute2',
							id:'PHCFRNoDelayExecute2F',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRNoDelayExecute2F'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRNoDelayExecute2F')),
							inputValue : 'Y',
							checked:false,
							listeners : {  
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '若首日执行录入框可填，则默认为全部分发次数；若录入框不可填，则当日直接按照全部分发次数生成执行记录'  
				                    })  
				                }  
				            }  
				    }, {
							fieldLabel: '不规则分发时间标志',   
							xtype : 'checkbox',
							name : 'PHCFRIrregularDistributTimeFlag',
							id:'PHCFRIrregularDistributTimeFlagF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRIrregularDistributTimeFlagF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRIrregularDistributTimeFlagF')),
							inputValue : 'Y',
							checked:false,
							listeners : {
								'check' :function() {
										if (Ext.getCmp("PHCFRIrregularDistributTimeFlagF").getValue()) //勾选时  
										{
											Ext.getCmp("PHCFRWeekFlagF").setValue(false);    //【不规则分发时间标志】应与【周频次】、【周频次系数】互斥
											Ext.getCmp("PHCFRWeekFactorF").setDisabled(true);
											
											//不规则分发时间标志勾选后，间隔长度，间隔单位为空
											Ext.getCmp("PHCFRIntervalUomF").setValue("");
											Ext.getCmp("PHCFRDaysF").setValue("");
											
										}
								},
				                render : function(field) {  
				                    Ext.QuickTips.init();  
				                    Ext.QuickTips.register({  
				                        target : field.el,  
				                        text : '启用该配置后，医嘱的分发时间需由用户自行选择且必填，系统不默认分发时间。若维护分发次数，则限定该频次的分发时间个数。启用后请务必维护分发时间及分发时间描述。【不规则分发时间标志】与【周频次】、【周频次系数】互斥'  
				                    })  
				                }  
				            }  
						
					}]					
				},{
					baseCls : 'x-plain',
				    columnWidth:'.45',
					layout: 'form',
					labelPad:1,
					border:false,
					defaults: {anchor:'80%'},
					items: [{
			        	labelWidth : 8,
			            xtype:'fieldset',
			            title: '就诊类型' ,
			            autoHeight:true,
			            hideLabels: true,
			            style: 'margin-left:40px;',
			            bodyStyle: 'margin-left:50px;',
			            items: [{
				            		xtype : 'checkboxgroup',   ////// 控制哪些类型可开这个频次，值为空则都可以开   O,E,I,H,N  (门诊,急诊,住院,体检,新生儿)
								    id:'PHCFRClinicTypeF',
								    readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRClinicTypeF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRClinicTypeF')),
								    columns: 1,
								    items: [
								        {boxLabel: '门诊', name: 'PHCFRClinicTypeO',id: 'PHCFRClinicTypeO', inputValue : 'O',checked:true},
								        {boxLabel: '急诊', name: 'PHCFRClinicTypeE',id: 'PHCFRClinicTypeE', inputValue : 'E',checked:true},
								        {boxLabel: '住院', name: 'PHCFRClinicTypeI',id: 'PHCFRClinicTypeI', inputValue : 'I',checked:true},
								        {boxLabel: '体检', name: 'PHCFRClinicTypeH',id: 'PHCFRClinicTypeH', inputValue : 'H',checked:true},
								        {boxLabel: '新生儿', name: 'PHCFRClinicTypeN',id: 'PHCFRClinicTypeN', inputValue : 'N',checked:true}
								    ]
				            }]

				    /*},{
							fieldLabel : "间隔时间(小时)",
							id:'PHCFRIntervalTimeF',
							xtype:'textfield',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRIntervalTimeF'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRIntervalTimeF')),
							name : 'PHCFRIntervalTime'*/
						
					},{
			        	labelWidth : 9,
			            xtype:'fieldset',
			            title: '星期' ,
			            autoHeight:true,
			            hideLabels: true,
			            style: 'margin-left:40px;',
			            bodyStyle: 'margin-left:50px;',
			            items: [{
				            		xtype : 'checkboxgroup',   
								    id:'PHCFRWeekF',
								    readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHCFRWeekF')),
								    columns: 1,
								    items: [
								        {boxLabel: '星期一', name: 'PHCFRWeek1',id: 'PHCFRWeek1', inputValue : '1'},
								        {boxLabel: '星期二', name: 'PHCFRWeek2',id: 'PHCFRWeek2', inputValue : '2'},
								        {boxLabel: '星期三', name: 'PHCFRWeek3',id: 'PHCFRWeek3', inputValue : '3'},
								        {boxLabel: '星期四', name: 'PHCFRWeek4',id: 'PHCFRWeek4', inputValue : '4'},
								        {boxLabel: '星期五', name: 'PHCFRWeek5',id: 'PHCFRWeek5', inputValue : '5'},
								        {boxLabel: '星期六', name: 'PHCFRWeek6',id: 'PHCFRWeek6', inputValue : '6'},
								        {boxLabel: '星期日', name: 'PHCFRWeek7',id: 'PHCFRWeek7', inputValue : '7'}
								    ]
				            }]
						
					}]						
				}]
			}]
				}
			});

				
	//var windowHight = document.documentElement.clientHeight;		//可获取到高度
	var windowHight=Math.min(Ext.getBody().getHeight()-30,600)
 	//var windowWidth = document.documentElement.clientWidth;			
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, dtgrid,AliasGrid] 
			 });
			 
	
	/**---------增加、修改操作弹出的窗口-----------*/
	var win = new Ext.Window({
		title : '',
		width:	800,		
		height:	windowHight,
		//width : 620,
		//minWidth:520,
		//height : 600,
		layout : 'fit',													//----------布局会充满整个窗口，组件自动根据窗口调整大小
		plain : true,                                                   //----------true则主体背景透明
		modal : true,//在页面上放置一层遮罩,确保用户只能跟window交互
		frame : true,													//----------win具有全部阴影，若为false则只有边框有阴影
		autoScroll : false,
		//collapsible : true,
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
					
					var factor=Ext.getCmp("PHCFRFactorF").getValue(); 
					var storeCount = dtgrid.getStore().getTotalCount();///获取总条数     //store.getCount()  获取本页条数
					var Code=Ext.getCmp("PHCFRCodeF").getValue();
					if ((Code.toUpperCase()=="ST")||(Code.toUpperCase()=="ONCE"))
					{	
						if (Ext.getCmp("PHCFRFactorF").getValue()!=1)
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'ST/ONCE分发次数要求为1！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRDaysF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'ST/ONCE间隔长度要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRIntervalUomF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'ST/ONCE间隔单位要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRWeekFlagF").getValue()==true)
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'ST/ONCE不允许勾选周频次！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRWeekFactorF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'ST/ONCE周频次系数要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					 }
					var number=0
					var xqCheck = Ext.getCmp("PHCFRWeekF").items;               

					for (var i = 0; i < xqCheck.length; i++)    
		            {    
		                if (xqCheck.get(i).checked)    
		                {    
		                      number+=1                  
		                }    
		            } 
		            if (Ext.getCmp("PHCFRWeekFactorF").getValue()!="")
		            {
		            	if (number!=Ext.getCmp("PHCFRWeekFactorF").getValue())
		            	{
		            		Ext.Msg.show({
									title : '提示',
									msg : '周频次系数和选择的星期不对应！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
		            	}
		            }
		            else
		            {
		            	if (number!=0)
		            	{
		            		Ext.Msg.show({
									title : '提示',
									msg : '周频次系数为空,不可选择星期！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
		            	}
		            }
					 if(Code.toUpperCase()=="PRN")		            
					{	
						if (Ext.getCmp("PHCFRFactorF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'PRN分发次数要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRDaysF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'PRN间隔长度要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRIntervalUomF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'PRN间隔单位要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRWeekFlagF").getValue()==true)
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'PRN不允许勾选周频次！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
						if (Ext.getCmp("PHCFRWeekFactorF").getValue()!="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : 'PRN周频次系数要求为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					 }
					//3.间隔单位和间隔长度要成对维护
					if (Ext.getCmp("PHCFRDaysF").getValue()!="")
					{
						if (Ext.getCmp("PHCFRIntervalUomF").getValue()=="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : '请选择【间隔单位】！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					}
					if (Ext.getCmp("PHCFRIntervalUomF").getValue()!="")
					{
						if (Ext.getCmp("PHCFRDaysF").getValue()=="")
						{
							Ext.Msg.show({
									title : '提示',
									msg : '请选择【间隔长度】！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					}
					if ((Ext.getCmp("PHCFRIntervalUomF").getValue()!="")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))
					{
						if (Ext.getCmp("PHCFRIrregularDistributTimeFlagF").getValue()==true)
						{
							Ext.Msg.show({
									title : '提示',
									msg : '选了间隔长度/间隔时间，不允许【勾选不规则分发时间标志】！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					}
					
					
					if(((Code.toUpperCase()=="PRN")||(Code.toUpperCase()=="ST")||(Code.toUpperCase()=="ONCE")))
					{	
						if (storeCount>0)  //PRN/ONCE/ST不需要维护分发时间
					 	{
					 		Ext.Msg.show({						//--------------显示错误信息文本框
								title : '提示',
								msg : "ST/ONCE/PRN不需要维护分发时间！",
								minWidth : 200,
								icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
								buttons : Ext.Msg.OK    //--------------只有一个确定按钮
							});
			   				return;
					 	}
						
					 }
					 else
					 {
					 	if ((Ext.getCmp("PHCFRIntervalUomF").getValue()=="H")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))  //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间。
						{
							///改成分发次数为 24/间隔小时 并向上取整。
							/*if (factor!="")
							{
								Ext.Msg.show({						//--------------显示错误信息文本框
									title : '提示',
									msg : "间隔单位为“小时”时，分发次数要求为空！",
									minWidth : 200,
									icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
									buttons : Ext.Msg.OK    //--------------只有一个确定按钮
								});
				   				return;
							}*/
							if (storeCount>0)
						 	{
						 		Ext.Msg.show({						//--------------显示错误信息文本框
									title : '提示',
									msg : "间隔单位为“小时”时，不需要维护分发时间！",
									minWidth : 200,
									icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
									buttons : Ext.Msg.OK    //--------------只有一个确定按钮
								});
				   				return;
						 	}
							
							
						}
						else
						{
						 	//勾选了【不规则分发时间标志】，分发时间描述要求必填
							//勾选了【不规则分发时间标志】 不校验次数和分发时间 chenying  2020-11-13 医生站提需求。
							if (Ext.getCmp("PHCFRIrregularDistributTimeFlagF").getValue()==true)
							{
								for (var i = 0; i < dtds.getCount(); i++) {
									var record1 = dtds.getAt(i);
									var PHCDTTimeDesc = record1.get('PHCDTTimeDesc');
									if (PHCDTTimeDesc=="")
									{
										Ext.Msg.show({
											title : '提示',
											msg : '勾选了【不规则分发时间标志】后，分发时间描述为必填项！',
											icon : Ext.Msg.WARNING,
											buttons : Ext.Msg.OK
										});
										return;
									}
								}
								if (factor!=="")
								{
									if (storeCount<factor)  //勾选了“不规则分发时间标志”时，频次的分发次数不能大于分发时间记录数
									 {
									 		Ext.Msg.show({						//--------------显示错误信息文本框
												title : '提示',
												msg : "勾选了【不规则分发时间标志】且频次的分发次数不为空时，分发时间条数要不小于分发次数！",
												minWidth : 200,
												icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
												buttons : Ext.Msg.OK    //--------------只有一个确定按钮
											});
							   				return;
									 }
								}
							}	
							else
							{
								//不勾选了【不规则分发时间标志】 ，分发次数要求必填
								if (factor=="")
								{
									Ext.Msg.show({						//--------------显示错误信息文本框
										title : '提示',
										msg : "频次的分发次数必填！",
										minWidth : 200,
										icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
										buttons : Ext.Msg.OK    //--------------只有一个确定按钮
									});
					   				return;
								}
								
								//勾选了【周频次】可以不校验次数和分发次数 chenying  2019-01-15 王伟提需求。 2022-1-05放开限制。
								//if ((Ext.getCmp("PHCFRWeekFlagF").getValue()==false))
								//{
									if (storeCount!=factor)
								 	{
								 		Ext.Msg.show({						//--------------显示错误信息文本框
											title : '提示',
											msg : "此频次必须维护分发时间，且分发时间要与分发次数对应！",
											minWidth : 200,
											icon : Ext.Msg.ERROR,   //--------------图标（错误提示图标）
											buttons : Ext.Msg.OK    //--------------只有一个确定按钮
										});
						   				return;
								 	}
									
								//}
							}
						}
					 }
							 
							 
							 
					
					
					if(WinForm.getForm().isValid()==false){
						 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
						 return;
					}
				/**-------添加部分操作----------*/	 
				if (win.title == "添加") {                                         //？？？可以换个判断方式
					WinForm.form.submit({
						clientValidation : true,                       //-----------进行客户端验证
						waitMsg : '正在提交数据请稍后',
						waitTitle : '提示',
						url : SAVE_ACTION_URL_New,						//----------发出请求的路径（保存数据）
						params : {
								'PHCFRFactor' : Ext.getCmp("PHCFRFactorF").getValue()   ///只读，修改时禁用的话参数传不到，要单独传。
						},
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
								
								//保存分发时间
								savedt(action.result.id)
								
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
										'PHCFRFactor' : Ext.getCmp("PHCFRFactorF").getValue()   ///只读，修改时禁用的话参数传不到，要单独传。
								},
								success : function(form, action) {
									
									//修改时 先保存别名
									AliasGrid.saveAlias();
									
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid="+action.result.id;
										//保存分发时间
										savedt(action.result.id)
										
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
								/*failure : function(form, action) {
								
									Ext.Msg.alert('提示', '修改失败ww！');
								}*/
								//--------------服务器端响应失败（ps:跟据response的状态码确定，如404,500时为failure）
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
				Ext.getCmp("form-save").getForm().findField("PHCFRCode").focus(true,300);
			},
			"beforehide" : function() {
				
				
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
				handler : AddData=function () {                              //------------在函数中调用添加窗口
					Ext.getCmp("tbPHCDTTime").reset();
					Ext.getCmp("tbPHCDTTimeDesc").reset();
					dtgrid.getStore().baseParams={
						parref : ""	
					};
					dtgrid.getStore().load({
						params : {
							start : 0,
							limit : pagesize1
						}
					});	
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();					    //------------添加首先要将表单重置清空一下
					var flag=Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF');
					Ext.getCmp("PHCFRFactorF").setDisabled(flag);
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
			            AliasGrid.DataRefer = _record.get('PHCFRRowId');
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
									name : 'PHCFRRowId',
									mapping : 'PHCFRRowId',
									type : 'string'
								}, {
									name : 'PHCFRCode',
									mapping : 'PHCFRCode',
									type : 'string'
								}, {
									name : 'PHCFRFactor',
									mapping : 'PHCFRFactor',
									type : 'string'
								},
								{
									name:'PHCFRDesc1',
									mapping:'PHCFRDesc1',
									type:'string'
								},
								{
									name:'PHCFRDesc2',
									mapping:'PHCFRDesc2',
									type:'string'
								},{
									name:'PHCFRDays',
									mapping:'PHCFRDays',
									type:'string'
								},{
									name:'PHCFRWeekFlag',
									mapping:'PHCFRWeekFlag',
									type:'string'
								},{
									name:'PHCFRWeekFactor',
									mapping:'PHCFRWeekFactor',
									type:'string'
								
								}, {
									name : 'PHCFRActiveFlag',
									mapping : 'PHCFRActiveFlag',
									type : 'string'
								}, {
									name : 'PHCFRNoDelayExecute',
									mapping : 'PHCFRNoDelayExecute',
									type : 'string'
								}, {
									name : 'PHCFRNoDelayExecute2',
									mapping : 'PHCFRNoDelayExecute2',
									type : 'string'
								}, {
									name : 'PHCFRClinicType',
									mapping : 'PHCFRClinicType',
									type : 'string'
								}, {
									name : 'PHCFRIntervalTime',
									mapping : 'PHCFRIntervalTime',
									type : 'string'
								},{
									name:'PHCFRIrregularDistributTimeFlag',
									mapping:'PHCFRIrregularDistributTimeFlag',
									type:'string'
								},{
									name:'PHCFRIntervalUom',
									mapping:'PHCFRIntervalUom',
									type:'string'
								}, {
									name : 'PHCFRWeek',
									mapping : 'PHCFRWeek',
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
          		},										     //-----------刚ds发生load事件时会触发paging
				displayInfo : true,										 //-----------是否显示右下方的提示信息false为不显示
				displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',    //-----------提示信息，这里规定了一种显示格式，默认也可以
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	var Helpwin = new Ext.Window({
		title : '页面说明',
		width:850,
		height: 550,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		closeAction : 'hide',
		items : helphtml={
			html:' <iframe scrolling="auto" frameborder="0" width="100%" height="100%" src="'+"../scripts/bdp/AppHelp/Pharmacy/PHCFreq.htm"+'"></iframe>'
		}
	})
	// 刷新工作条
	var helphtmlbtn = new Ext.Button({
				iconCls : 'icon-help',
				text : '页面说明',
				handler : function() {
					Helpwin.show()
				}
	})
			
			
			
			
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
						code : Ext.getCmp("TextCode").getRawValue()
								,
						factor :  Ext.getCmp("TextFactor").getRawValue()
								,
						desc1 :  Ext.getCmp("TextDesc1").getRawValue()
								,
						desc2 :  Ext.getCmp("TextDesc2").getRawValue()
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
					Ext.getCmp("TextFactor").reset();                     //-----------将输入框清空
					Ext.getCmp("TextDesc1").reset();
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
				items : [
						'代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},
						 '-',
						
						'英文描述', {
							xtype : 'textfield',emptyText : '描述/别名',
							id : 'TextDesc1',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc1')
						},'-',
						'中文描述', {
							xtype : 'textfield',
							id : 'TextDesc2',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')
						},'-',
						'分发次数', {
							xtype : 'textfield',
							id : 'TextFactor',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFactor')
						},
						'-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',
						 btnSearch, '-', btnRefresh, '->',helphtmlbtn],
				listeners : {                                        //--------------作一个监听配置(config)
					render : function() {                            //--------------当组件被渲染后将触发此函数
						tbbutton.render(grid.tbar)                   // 渲染tbbutton按钮，tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	var GridCM=[sm, {									//----------------定义列
							header : 'PHCFRRowId',
							width : 100,
							sortable : true,
							dataIndex : 'PHCFRRowId',
							hidden : true                          //-----------------隐藏掉rowid
						}, {
							header : '代码',
							width : 100,
							sortable : true,
							dataIndex : 'PHCFRCode'
						}, {
							header : '英文描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCFRDesc1',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '中文描述',
							width : 100,
							sortable : true,
							dataIndex : 'PHCFRDesc2',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '分发次数',
							width : 50,
							sortable : true,
							dataIndex : 'PHCFRFactor'
						}, {
							header : '是否激活',
							width : 50,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCFRActiveFlag'	
						}, {
							header : '间隔长度',  //原来：间隔天数
							width : 60,
							sortable : true,
							dataIndex : 'PHCFRDays'
						}, {
							header : '间隔单位',
							width : 60,
							sortable : true,
							dataIndex : 'PHCFRIntervalUom'
						}, {
							header : '周频次',
							width : 40,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCFRWeekFlag'
						}, {
							header : '周频次系数',
							width : 60,
							sortable : true,
							dataIndex : 'PHCFRWeekFactor'
						
						}, {
							header : '门诊默认按分发次数全执行',
							width : 150,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCFRNoDelayExecute'
						}, {
							header : '住院默认按分发次数全执行',
							width : 150,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCFRNoDelayExecute2'
							
						}, {
							header : '就诊类型',
							width : 140,
							sortable : true,
							dataIndex : 'PHCFRClinicType',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						/*}, {
							header : '间隔时间(小时)',
							width : 80,
							sortable : true,
							dataIndex : 'PHCFRIntervalTime',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow*/
						}, {
							header : '星期',
							width : 140,
							sortable : true,
							dataIndex : 'PHCFRWeek',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '不规则分发时间标志',
							width : 120,
							sortable : true,
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							dataIndex : 'PHCFRIrregularDistributTimeFlag'
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
				title : '频次',
				// config options for stateful behavior
				stateful : true,                                  //-----------------
				viewConfig : {									  //-----------------视图配置
					forceFit : true								  //-----------------固定大小
				},
				//autoExpandColum:'PHCFRForeignDesc',
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
            AliasGrid.DataRefer = _record.get('PHCFRRowId');
	        AliasGrid.loadGrid();
			
        //alert(form1.reader);
    });
			//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('PHCFRRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
    // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();
        if (!_record) {
            Ext.Msg.alert('提示', '请选择要修改的行！');
        } else {
        	Ext.getCmp("tbPHCDTTime").reset();
        	Ext.getCmp("tbPHCDTTimeDesc").reset();
			dtgrid.getStore().baseParams={
						parref : grid.getSelectionModel().getSelected().get('PHCFRRowId')	
			};
			dtgrid.getStore().load({
				params : {
						start : 0,
						limit : pagesize1
				}
			});	
        	win.setTitle('修改');
        	win.setIconClass('icon-update');
            win.show();
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&PHCFRRowId='+ _record.get('PHCFRRowId'),
                waitMsg : '正在载入数据...',
                success : function(form,action) {
                	Ext.getCmp('PHCFRClinicTypeO').setValue((action.result.data.PHCFRClinicTypeO)=='O'?true:false);
                	Ext.getCmp('PHCFRClinicTypeE').setValue((action.result.data.PHCFRClinicTypeE)=='E'?true:false);
                	Ext.getCmp('PHCFRClinicTypeI').setValue((action.result.data.PHCFRClinicTypeI)=='I'?true:false);
                	Ext.getCmp('PHCFRClinicTypeH').setValue((action.result.data.PHCFRClinicTypeH)=='H'?true:false);
                	Ext.getCmp('PHCFRClinicTypeN').setValue((action.result.data.PHCFRClinicTypeN)=='N'?true:false);              	

                	Ext.getCmp("PHCFRWeek1").setValue(action.result.data.PHCFRWeek1)
                	Ext.getCmp("PHCFRWeek2").setValue(action.result.data.PHCFRWeek2)
                	Ext.getCmp("PHCFRWeek3").setValue(action.result.data.PHCFRWeek3)
                	Ext.getCmp("PHCFRWeek4").setValue(action.result.data.PHCFRWeek4)
                	Ext.getCmp("PHCFRWeek5").setValue(action.result.data.PHCFRWeek5)
                	Ext.getCmp("PHCFRWeek6").setValue(action.result.data.PHCFRWeek6)
                	Ext.getCmp("PHCFRWeek7").setValue(action.result.data.PHCFRWeek7)

                	if ((Ext.getCmp("PHCFRIntervalUomF").getValue()=="H")&&(Ext.getCmp("PHCFRDaysF").getValue()!=""))  //维护了间隔时间和间隔单位 小时时，不允许维护分发次数和分发时间。
					{
						var days=Ext.getCmp("PHCFRDaysF").getValue()
						var factor=""
						if (days>0) factor=Math.ceil(24/days)
						Ext.getCmp("PHCFRFactorF").setValue(factor) //间隔单位为“小时”时，分发次数要求为空！"
						Ext.getCmp("PHCFRFactorF").setDisabled(true);
					}
					else
					{
						var Code=Ext.getCmp("PHCFRCodeF").getValue();
						if((Code.toUpperCase()=="ST")||(Code.toUpperCase()=="ONCE"))
						{	
							Ext.getCmp("PHCFRFactorF").setValue(1)
							Ext.getCmp("PHCFRFactorF").setDisabled(true);
						 }
						 else
						 {
								var flag=Ext.BDP.FunLib.Component.DisableFlag('PHCFRFactorF');
								Ext.getCmp("PHCFRFactorF").setDisabled(flag);
						 }
					}
                },
                failure : function(form,action) {
                    //Ext.example.msg('编辑', '载入失败');
                	Ext.Msg.alert('编辑', '载入失败！');
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
