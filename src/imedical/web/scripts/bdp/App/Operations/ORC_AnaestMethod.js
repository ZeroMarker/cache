 		
	/// 名称:手术和过程 - 10 麻醉方法维护	
	/// 描述:包含增删改查功能
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2012-9-7
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
	document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	//初始化"别名"维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "ORC_AnaestMethod"
	});
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	//ORC_ANA_Method_Agent_Alloc(10.1)麻醉方法关联的麻醉剂
	var METAG_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCANAMethodAgentAlloc&pClassQuery=GetList";
	//var METAG_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCANAMethodAgentAlloc&pClassMethod=OpenData";
	//var METAG_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCANAMethodAgentAlloc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCANAMethodAgentAlloc";
	var METAG_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCANAMethodAgentAlloc&pClassMethod=DeleteData";
	var METAG_Agent_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestAgent&pClassQuery=GetDataForCmb1";
	
	
	//ORC_AnaestMethod(10)麻醉方法
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestMethod&pClassQuery=GetList";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestMethod&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestMethod&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ORCAnaestMethod";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestMethod&pClassMethod=DeleteData";
	var Type_DR_QUERY_ACTION_URL  = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestType&pClassQuery=GetDataForCmb1"; 
	var ARCOS_DR_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ORCAnaestMethod&pClassQuery=GetARCOSDR";
	
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	var pagesize1=Ext.BDP.FunLib.PageSize.Pop;
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.ORCAnaestMethod";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    
	//-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="ORC_AnaestMethod"
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
			RowID=rows[0].get('ANMETRowId');
			Desc=rows[0].get('ANMETDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});
	Ext.QuickTips.init();
	
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	Ext.form.Field.prototype.msgTarget = 'qtip';
	
	Ext.apply(Ext.form.VTypes, {
		cKDate:function(val, field){
			var v1 = Ext.getCmp("date1").getValue();
    		var v2 = Ext.getCmp ("date2").getValue();
    		if(v1=="" || v2=="") return true;
    		return v2 > v1;
		},
		cKDateText:'结束日期应该大于开始日期'
	});
	//---------------------------------------------关联的麻醉剂--------------------------------------	
	// 删除功能
	var metagbtnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'icon-delete',
		id : 'metag_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('metag_del_btn'),
		handler : function() {
			if (metaggrid.selModel.hasSelection()) {
				// Ext.MessageBox.confirm(String title,String msg,[function
				// fn],[Object scope])
				var gsm = metaggrid.getSelectionModel();
				var rows = gsm.getSelections();
				if(rows[0].get('METAGRowId'))   //判断选中的数据是否已经保存
				{
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						// Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						
						// Ext.Ajax.request({},this);
						Ext.Ajax.request({
							url : METAG_DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('METAGRowId')
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
												/*var startIndex = metaggrid.getBottomToolbar().cursor;
												var totalnum=metaggrid.getStore().getTotalCount();
												if(totalnum==1){   //修改添加后只有一条，返回第一页
													var startIndex=0
												}
												else if((totalnum-1)%pagesize1==0)//最后一页只有一条
												{
														
														var pagenum=metaggrid.getStore().getCount();
														if (pagenum==1){ startIndex=startIndex-pagesize1;}  //最后一页的时候
														//不是最后一页则还停留在这一页
												}
												metaggrid.getStore().load({
															params : {
																start : startIndex,
																limit : pagesize1,
																methoddr : grid.getSelectionModel().getSelected().get('ANMETRowId')
																}	
														});	*/	
											//不重新加载,只移除被删除的行
											var targetRecord = metaggrid.getSelectionModel().getSelected();
											metagds.remove(targetRecord);
											metagds.totalLength=metaggrid.getStore().getTotalCount()-1
    	 									metagpaging.bindStore(metagds)
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
				var targetRecord = metaggrid.getSelectionModel().getSelected();
				metagds.remove(targetRecord);
				metagds.totalLength=metaggrid.getStore().getTotalCount()-1
    	 		metagpaging.bindStore(metagds)
			}
			} else {
				Ext.Msg.show({
							title : '提示',
							msg : '请选择需要删除的关联的麻醉剂！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			}
		}
	});


	// 增加按钮
	var metagbtnAddwin = new Ext.Toolbar.Button({
				text : '添加', ///&nbsp&nbsp
				tooltip : '添加', 
				iconCls : 'icon-add',
				id : 'metagbtnAdd',  
				disabled : Ext.BDP.FunLib.Component.DisableFlag('metagbtnAdd'),
				handler : function() {
					var anmetd=Ext.getCmp("ANMETDesc").getValue();
					var agent=Ext.getCmp("comboMETAGAgentDR").getValue();
					if(anmetd=="")
					{
						Ext.Msg.show({
									title : '提示',
									msg : '麻醉方法描述不可为空！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;
					}
					
					if (agent=="")
					{
						Ext.Msg.show({
									title : '提示',
									msg : '请选择麻醉剂！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;	
					}
					//alert(metagds.getCount())
					///重复校验 ，2015-10-13 chenying
					for (var i = 0; i < metagds.getCount(); i++) {
							var record1 = metagds.getAt(i);
							var METAGAgentDR = record1.get('ANAGNRowId');
							if(agent==METAGAgentDR)
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
							
							
					var _record = new Ext.data.Record({
    	 					'METAGRowId':'',
    	 					'METAGAgentDR':Ext.getCmp('comboMETAGAgentDR').getRawValue(),
    	 					'METAGMethodDR' :Ext.getCmp('ANMETDesc').getRawValue(),
    	 					'ANMETRowId' :'',
    	 					'ANAGNRowId' :Ext.getCmp('comboMETAGAgentDR').getValue()
    	 					
    	 			});
    	 			metaggrid.stopEditing();
    	 			metagds.insert(metagds.getCount(),_record); 	  ///20170622  按照顺序保存 将新加的插入到最后一行 ///metagds.insert(0,_record);    
    	 			Ext.getCmp("comboMETAGAgentDR").reset();
					
					metagds.totalLength=metaggrid.getStore().getTotalCount()+1
    	 			metagpaging.bindStore(metagds)	
						
						/*
						Ext.Ajax.request({
						url : METAG_SAVE_ACTION_URL , 		
						method : 'POST',	
						params : {
								'METAGMethodDR' : grid.getSelectionModel().getSelected().get('ANMETRowId'),
								'METAGAgentDR' :Ext.getCmp("comboMETAGAgentDR").getValue()
						},
						callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								
								Ext.Msg.show({
								title : '提示',
								msg : '添加成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.getCmp("comboMETAGAgentDR").reset();
									metaggrid.getStore().load({
										params : {
											start : 0,
											limit : pagesize1
										}
									});
									
								}
							});
							}else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br />'+jsonData.info
								}
								Ext.Msg.show({
									title:'提示',
									msg:errorMsg,
									minWidth:210,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					}	
					
					})
					
					*/
				

				},
				scope : this
			});

	// 修改按钮
	var metagbtnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '修改',
				iconCls : 'icon-update',
				id : 'metagbtnupdate',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('metagbtnupdate'),
				handler : function() {
					
				if (metaggrid.selModel.hasSelection()) {
					var agent=Ext.getCmp("comboMETAGAgentDR").getValue()
					if (agent=="")
					{
						Ext.Msg.show({
									title : '提示',
									msg : '请选择麻醉剂！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
						return;
					}
					///重复校验 ，2015-10-13 chenying
						for (var i = 0; i < metagds.getCount(); i++) {
								var record1 = metagds.getAt(i);
								var METAGAgentDR = record1.get('ANAGNRowId');
								if(agent==METAGAgentDR)
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
							
					var myrecord = metaggrid.getSelectionModel().getSelected();
    	 			myrecord.set('METAGAgentDR',Ext.getCmp('comboMETAGAgentDR').getRawValue());
    	 			myrecord.set('ANAGNRowId',Ext.getCmp('comboMETAGAgentDR').getValue());
    	 			myrecord.set('METAGMethodDR',Ext.getCmp('ANMETDesc').getValue());
					Ext.getCmp("comboMETAGAgentDR").reset();
						/*
						Ext.Ajax.request({
						url : METAG_SAVE_ACTION_URL , 		
						method : 'POST',	
						params : {
								'METAGMethodDR' : grid.getSelectionModel().getSelected().get('ANMETRowId'),
								'METAGAgentDR' :Ext.getCmp("comboMETAGAgentDR").getValue(),
								'METAGRowId' :metaggrid.getSelectionModel().getSelected().get('METAGRowId')
						},
						callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								
								Ext.Msg.show({
								title : '提示',
								msg : '修改成功!',
								icon : Ext.Msg.INFO,
								buttons : Ext.Msg.OK,
								fn : function(btn) {
									Ext.getCmp("comboMETAGAgentDR").reset();
									metaggrid.getStore().load({
										params : {
											start : 0,
											limit : pagesize1
										}
									});
									
								}
							});
							}else{
								var errorMsg ='';
								if(jsonData.info){
									errorMsg='<br />'+jsonData.info;
								}
								Ext.Msg.show({
									title:'提示',
									msg:errorMsg,
									minWidth:210,
									icon:Ext.Msg.ERROR,
									buttons:Ext.Msg.OK
								});
							}
						}
					}	
					
					})
					*/
					
					
					
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
	var SAVE_METAG_ALL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ORCANAMethodAgentAlloc&pClassMethod=SaveAll";
	
	function savemetag(rowid){
 		var metagstr="";
	    metagds.each(function(record){
			if(metagstr!="") metagstr = metagstr+"*";
			metagstr = metagstr+record.get('METAGRowId')+'^'+record.get('ANAGNRowId');
	    }, this);
		Ext.Ajax.request({
			url:SAVE_METAG_ALL,
			method:'POST',
			params:{
				'rowid':rowid,
				'metagstr':metagstr
			}	
		});  
	}		
	// 刷新工作条
	var metagbtnRefresh = new Ext.Button({
				id : 'metagbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('metagbtnRefresh'),
				tooltip : '重置',
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("comboMETAGAgentDR").reset();
					if(win.title=="修改")
					{
						metaggrid.getStore().baseParams={  //解决metaggrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
									methoddr : grid.getSelectionModel().getSelected().get('ANMETRowId')
						};
						metaggrid.getStore().load({
							params : {
									start : 0,
									limit : pagesize1
							}
						});
					}
					
					else{
						metaggrid.getStore().baseParams={  //解决metaggrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
									methoddr : ""
						};
						metaggrid.getStore().load({
							params : {
									start : 0,
									limit : pagesize1
							}
						});	s
						
						
					}
				}
	});
	var metagds = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : METAG_ACTION_URL
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
								name : 'METAGRowId',
								mapping : 'METAGRowId',
								type : 'string'
							}, {
								name : 'METAGMethodDR',
								mapping : 'METAGMethodDR',
								type : 'string'
							}, {
								name : 'METAGAgentDR',
								mapping : 'METAGAgentDR',
								type : 'string'
							}, {
								name : 'ANMETRowId',
								mapping : 'ANMETRowId',
								type : 'string'
							}, {
								name : 'ANAGNRowId',
								mapping : 'ANAGNRowId',
								type : 'string'
							}])
			
		});
	
	// 加载数据
	metagds.load({
				params : {
					start : 0,
					limit : pagesize1
				},
				callback : function(records, options, success) {
				}
			});

	// 分页工具条
	var metagpaging = new Ext.PagingToolbar({
				pageSize : pagesize1,
				store : metagds,
				plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
         		 "change":function (t,p)
         		{ 
             		pagesize1=this.pageSize;
         		}
          		},
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录, 一共 {2} 条',
				emptyMsg : "没有记录"
			});

	var metagsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	// 增删改工具条
	var metagtbbutton = new Ext.Toolbar({
				enableOverflow : true,
				items : [metagbtnAddwin, '-', metagbtnEditwin, '-',
						metagbtnDel, '-'
						]
			});
	// 将工具条放到一起
	var metagtb = new Ext.Toolbar({
				id : 'metagtb',
				items : ['麻醉剂', {
					xtype : 'bdpcombo',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					loadByIdParam : 'rowid',
					listWidth:250,
					//fieldLabel : '<font color=red>*</font>麻醉剂',
					hiddenName : 'METAGAgentDR1',
					id :'comboMETAGAgentDR',
					//disabled : Ext.BDP.FunLib.Component.DisableFlag('METAGAgentDR'),
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('METAGAgentDR1'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('METAGAgentDR1')),
					store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({
											url : METAG_Agent_DR_QUERY_ACTION_URL
										}),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [{
													name : 'ANAGNRowId',
													mapping : 'ANAGNRowId'
												}, {
													name : 'ANAGNDesc',
													mapping : 'ANAGNDesc'
												}])
							}),
					mode : 'local',
					shadow : false,
					forceSelection : true,
					selectOnFocus : false,
					//triggerAction : 'all',
					// hideTrigger: false,
					displayField : 'ANAGNDesc',
					valueField : 'ANAGNRowId'
				},'-', 
						metagbtnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						metagtbbutton.render(metaggrid.tbar)
					}
				}
	});

	// 创建Grid
	var metaggrid = new Ext.grid.GridPanel({
				title : '关联的麻醉剂',
				id : 'metaggrid',
				region : 'center',
				height : 230,
				store : metagds,
				trackMouseOver : true,
				columns : [metagsm, {
							header : 'METAGRowId',
							width : 70,
							hidden:true,
							sortable : true,
							dataIndex : 'METAGRowId'
						}, {
							header : '麻醉方法',
							width : 80,
							sortable : true,
							//hidden : true,
							dataIndex : 'METAGMethodDR'
						}, {
							header : '麻醉剂',
							width : 80,
							sortable : true,
							dataIndex : 'METAGAgentDR'
						}, {
							header : '麻醉方法ID',
							width : 80,
							sortable : true,
							hidden:true,
							dataIndex : 'ANMETRowId'
						}, {
							header : '麻醉剂ID',
							width : 80,
							sortable : true,
							hidden:true,
							dataIndex : 'ANAGNRowId'
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
				bbar : metagpaging,
				tbar : metagtb,
				stateId : 'metaggrid'
			});
	Ext.BDP.FunLib.ShowUserHabit(metaggrid,"User.ORCANAMethodAgentAlloc");
	
	metaggrid.on("rowclick",function(grid,rowIndex,e){
		var _record1 = metaggrid.getSelectionModel().getSelected();//records[0]
	    Ext.getCmp("comboMETAGAgentDR").reset();
	    Ext.getCmp("comboMETAGAgentDR").setValue(_record1.get('ANAGNRowId'));
	    Ext.getCmp("comboMETAGAgentDR").setRawValue(_record1.get('METAGAgentDR'));
	    
	});	

	// ------------------------------------------关联的麻醉剂（完）--------------------------------------------------------------------------
	// 增加修改的Form
	var WinForm = new Ext.FormPanel({
				id : 'form-save',
				// collapsible : true,
				title:'基本信息',
				// bodyStyle : 'padding:5px 5px 0',
				URL : SAVE_ACTION_URL,
				//baseCls : 'x-plain',// form透明,不显示框框
				region: 'west',
				labelAlign : 'right',
				labelWidth : 90,
				split : true,
				autoScroll : true,///滚动条
				frame : true,
				waitMsgTarget : true,// 这个属性决定了load和submit中对数据的处理,list必须是一个集合类型,json格式应该是[
										// ]包含的一个数组
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ANMETCode',mapping:'ANMETCode'},
                                         {name: 'ANMETDesc',mapping:'ANMETDesc'},
                                         {name: 'ANMETTypeDR',mapping:'ANMETTypeDR'},
                                         {name: 'ANMETARCOSDR',mapping:'ANMETARCOSDR'},
                                         {name: 'ANMETDateFrom',mapping:'ANMETDateFrom'},
                                         {name: 'ANMETDateTo',mapping:'ANMETDateTo'},
                                         {name: 'ANMETRowId',mapping:'ANMETRowId'}
                                        ]),
				defaults : {
					anchor : '95%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							id:'ANMETRowId',
							xtype:'textfield',
							fieldLabel : 'ANMETRowId',
							name : 'ANMETRowId',
							hideLabel : 'True',
							hidden : true
						}, {
								
								
							fieldLabel : '<font color=red>*</font>代码',
							xtype:'textfield',
							id:'ANMETCode',
							maxLength:15,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ANMETCode'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANMETCode'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANMETCode')),
							name : 'ANMETCode',
							allowBlank:false,
							validationEvent : 'blur',  
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){	//当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.ORCAnaestMethod";	//后台类名称
	                            var classMethod = "FormValidate";	//数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){	//如果窗口标题为'修改',则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ANMETRowId');	//此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");	//用tkMakeServerCall函数实现与后台同步调用交互
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}	//数据验证成功后显示对勾
						}, {
							fieldLabel : '<font color=red>*</font>描述',
							xtype:'textfield',
							id:'ANMETDesc',
							maxLength:220,
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ANMETDesc'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANMETDesc'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANMETDesc')),
							name : 'ANMETDesc',
							allowBlank:false,
							validationEvent : 'blur',
							enableKeyEvents:true, 
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){	//当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.ORCAnaestMethod";	//后台类名称
	                            var classMethod = "FormValidate";	//数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){	//如果窗口标题为'修改',则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ANMETRowId');	//此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);	//用tkMakeServerCall函数实现与后台同步调用交互
	                            //Ext.Msg.alert(flag);
	                            if(flag == "1"){	//当后台返回数据位"1"时转换为相应的布尔值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {'change' : Ext.BDP.FunLib.Component.ReturnValidResult}	//数据验证成功后显示对勾
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:300,
							fieldLabel : '<font color=red></font>麻醉方法类型',
							hiddenName : 'ANMETTypeDR',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('ANMETTypeDR'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANMETTypeDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANMETTypeDR')),
							//id :'ANMETTypeDR',
							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : Type_DR_QUERY_ACTION_URL }),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'ANTYPERowId',mapping:'ANTYPERowId'},
										{name:'ANTYPEDesc',mapping:'ANTYPEDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//triggerAction : 'all',
							//hideTrigger: false,
							displayField : 'ANTYPEDesc',
							valueField : 'ANTYPERowId'				
							//typeAhead : true,
							//minChars : 1,
							//editable: false,
							//allowBlank : false
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : "<span style='color:red;'></span>医嘱套",
                            //id :'ANMETARCOSDR',
                            hiddenName: 'ANMETARCOSDR',
                            //disabled : Ext.BDP.FunLib.Component.DisableFlag('ANMETARCOSDR'),
                            readOnly : Ext.BDP.FunLib.Component.DisableFlag('ANMETARCOSDR'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ANMETARCOSDR')),
                            store:  new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : ARCOS_DR_QUERY_ACTION_URL }),
												reader : new Ext.data.JsonReader({
													totalProperty : 'total',
													root : 'data',
													successProperty : 'success'
												}, [{ name:'ARCOSRowId',mapping:'ARCOSRowId'},
												{name:'ARCOSDesc',mapping:'ARCOSDesc'} ]
												)
									}),
                            mode : 'local',
                            shadow:false,
                           queryParam : 'desc',
  					       forceSelection : true,
  					       selectOnFocus : false,
  					       //triggerAction: 'all',  
  				           //hideTrigger : false,
  					       displayField : 'ARCOSDesc', 
  					       valueField : 'ARCOSRowId'
  					       //editable:false,
  					       //allowBlank:false
						}, {
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'ANMETDateFrom',
							format : BDPDateFormat,
							id:'date1',
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date1'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date1')),
							vtype:'cKDate',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							allowBlank:false
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'ANMETDateTo',
							format : BDPDateFormat,
							id:'date2',
							enableKeyEvents : true,
							listeners : {   'keyup' : function(field, e){	 Ext.BDP.FunLib.Component.GetCurrentDate(field,e);  }},
							//disabled : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('date2'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('date2')),
							vtype:'cKDate'
						}
						]	
	});
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, metaggrid,AliasGrid]
			 });
	// 增加修改时弹出窗口
	var win = new Ext.Window({
		title : '',
		width :450,
		height: 470,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,
		modal : true,//在页面上放置一层遮罩,确保用户只能跟window交互
		frame : true,
		//autoScroll : true,
		//collapsible : true,//收缩
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items :tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				if(WinForm.getForm().isValid()==false){
					 Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					 return;
				}
				//-------添加----------	
				if (win.title == "添加") {//WinForm.form.isValid()
					WinForm.form.submit({
						url : SAVE_ACTION_URL,
						clientValidation : true,
						waitTitle : '提示',
						waitMsg : '正在提交数据请稍候...',
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {//如果json中success属性返回的为true
								win.hide();
								var myrowid = action.result.id;
								 //var myrowid = jsonData.id;
								savemetag(action.result.id);
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功！',
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
											}
										});
								//添加时 同时保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
								
							} else {//eo if (action.result.success == 'true') {	}
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
							WinForm.form.submit({
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
										
										savemetag(action.result.id);
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
				Ext.getCmp("form-save").getForm().findField("ANMETCode").focus(true,300);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {
			}
		}
	});
	var fields=[{
								name : 'ANMETRowId',
								mapping : 'ANMETRowId',
								type : 'number'
							}, {
								name : 'ANMETCode',
								mapping : 'ANMETCode',
								type : 'string'
							}, {
								name : 'ANMETDesc',
								mapping : 'ANMETDesc',
								type : 'string'
							},{
								name : 'ANMETTypeDR',
								mapping : 'ANMETTypeDR',
								type : 'string'
							}, {
								name : 'ANMETARCOSDR',
								mapping : 'ANMETARCOSDR',
								type : 'string'
							},{
								name : 'ANMETDateFrom',
								mapping : 'ANMETDateFrom',
								type : 'date',
								dateFormat : 'm/d/Y'
							}, {
								name : 'ANMETDateTo',
								mapping : 'ANMETDateTo',
								type : 'date',
								dateFormat : 'm/d/Y'
							}
						]
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},fields)
				//remoteSort : true
				//sortInfo: {field : "ANMETRowId",direction : "ASC"}
	});
	//ds.sort("ANMETCode","DESC");
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);		
 	//加载数据
	ds.load({
				params : { start : 0, limit : pagesize }, 
				callback : function(records, options, success) {
					//加载完成后执行的回调函数
					//参数records表示获得的数据, options表示执行load时传递的参数,success表示是否加载成功
					// alert(options);
					//Ext.Msg.alert('info', '加载完毕, success = '+ records.length);
				}
	}); 			
	
	//分页工具条
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
						var gsm = grid.getSelectionModel();//获取选择列
						var rows = gsm.getSelections();//根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('ANMETRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ANMETRowId')
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {//请求成功	
									var jsonData = Ext.util.JSON.decode(response.responseText);//获取返回的信息
									if (jsonData.success == 'true')
									{               
										Ext.Msg.show({
											title : '提示',
											msg : '数据删除成功！',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn){
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize);
	
											}
									});
								}
								else {//eo if (jsonData.success == 'true'){ }
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
								else {//eo if(success){}
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

	// 增加按钮
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function() {
					
					Ext.getCmp("comboMETAGAgentDR").reset();
					metaggrid.getStore().baseParams={  //解决metaggrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
							methoddr : ""
					};
					metaggrid.getStore().load({
						params : {
							start : 0,
							limit : pagesize1
						}
					});
					
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
						
						Ext.getCmp("comboMETAGAgentDR").reset();
						metaggrid.getStore().baseParams={  //解决metaggrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
								methoddr : grid.getSelectionModel().getSelected().get('ANMETRowId')
						};
						metaggrid.getStore().load({
							params : {
								start : 0,
								limit : pagesize1
							}
						});
						
						
						win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show();
						loadFormData(grid);
						
						//激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            var _record = grid.getSelectionModel().getSelected();
			            
			           
			            
			            AliasGrid.DataRefer = _record.get('ANMETRowId');
				        AliasGrid.loadGrid();
				        
						//var record = grid.getSelectionModel().getSelected();//获取当前行的记录
						//Ext.getCmp("form-save").getForm().loadRecord(record);//通过form的id调用form,并加载当前行的数据到form
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
		
	// 增删改工具条
	var tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [btnAddwin, '-', btnEditwin, '-', btnDel
		,'-',btnSort,'-',btnTrans ,'->',btnlog,'-',btnhislog
		///metagbtn,'-',
		]
		
		
		
	});
		
		
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={//模糊查询		
						code : Ext.getCmp("TextCode").getValue(),
						
						desc :  Ext.getCmp("TextDesc").getValue()
						
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
					Ext.BDP.FunLib.SelectRowId="";
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
				items : ['代码', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')},'-',
						'描述', {xtype : 'textfield',emptyText : '描述/别名',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-', 
						Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',btnSearch,'-', 
						btnRefresh,'-','->'
					],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar)
					}
				}
	});
var GridCM= [sm, {
							header : 'ANMETRowId',
							width : 70,
							sortable : true,
							dataIndex : 'ANMETRowId',
							hidden : true
						}, {
							header : '代码',
							width : 80,
							sortable : true,
							dataIndex : 'ANMETCode'
						}, {
							header : '描述',
							width : 100,
							sortable : true,
							dataIndex : 'ANMETDesc'
						}, {
							header : '麻醉方法类型',
							width : 80,
							sortable : true,
							dataIndex : 'ANMETTypeDR'
						}, {
							header : '医嘱套',
							width : 80,
							sortable : true,
							dataIndex : 'ANMETARCOSDR'
						}, {
							header : '开始日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ANMETDateFrom'
						}, {
							header : '结束日期',
							width : 80,
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'ANMETDateTo'
						}]
	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : '麻醉方法',
				id : 'grid',
				region : 'center',
				tools:Ext.BDP.FunLib.Component.HelpMsg,
				width : 900,
				height : 500,
				layout : 'fit',	
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
	
	
	
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);

	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);
    // 载入被选择的数据行的表单数据
    var loadFormData = function(grid) {
        var _record = grid.getSelectionModel().getSelected();//获取当前行的记录
        if (!_record) {
            Ext.Msg.alert('修改','请选择要修改的一项！');
        } else {
            WinForm.form.load( {
                url : OPEN_ACTION_URL + '&id='+ _record.get('ANMETRowId'),//id对应OPEN里的入参
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
		   	var row = grid.getStore().getAt(rowIndex).data;
		   	
		   	Ext.getCmp("comboMETAGAgentDR").reset();
			metaggrid.getStore().baseParams={  //解决metaggrid不能翻页的问题,和翻页、重置后显示空白的问题 13-9-23
					methoddr : grid.getSelectionModel().getSelected().get('ANMETRowId')
			};
			metaggrid.getStore().load({
				params : {
					start : 0,
					limit : pagesize1
				}
			});
		   	win.setTitle('修改');
			win.setIconClass('icon-update');
			win.show();
        	loadFormData(grid);
						
			//激活基本信息面板
            tabs.setActiveTab(0);
	        //加载别名面板
            var _record = grid.getSelectionModel().getSelected();
            AliasGrid.DataRefer = _record.get('ANMETRowId');
	        AliasGrid.loadGrid();
			
    });	
    	//单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ANMETRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});
    
	
    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
    
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
	});

});