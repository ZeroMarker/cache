/// 名称: 医嘱与结果 3.医嘱子分类维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2012-9-6
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/AliasEditorGridPanel.js"> </script>');
///新疆中医院需求of1  医嘱子分类与处方类型关联
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'qtip';
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var pagesize_pop = Ext.BDP.FunLib.PageSize.Pop;
	var ORDCAT_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECOrderCategory&pClassQuery=GetDataForCmb1";
	var EXEC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECExecCateg&pClassQuery=GetDataForCmb1";
	var DocCTDefine_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDefineDataForCmb";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItemCat";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassMethod=DeleteData";
	
	var CTLOC_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmb1";
	var CTLOC_Group_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTLoc&pClassQuery=GetDataForCmbGroup";  //返回本组的科室
	var HOSP_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTHospital&pClassQuery=GetDataForCmb1";
	var Priority_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.OECPriority&pClassQuery=GetDataForCmb1";
	var CHILD_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItemCatRecLoc';
	var CHILD_OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassMethod=DeleteData';
	
	//初始化“别名”维护面板
	var AliasGrid = new Ext.BDP.grid.AliasEditorGridPanel({
		TableN : "ARC_ItemCat"
	});
	/********排序*******/
    Ext.BDP.FunLib.SortTableName = "User.ARCItemCat";
    var btnSort = Ext.BDP.FunLib.SortBtn;
    //-----------------翻译开始--------//	
	Ext.BDP.FunLib.TableName="ARC_ItemCat"
	var btnTrans = Ext.BDP.FunLib.TranslationBtn;  //翻译按钮;
	var TransFalg =tkMakeServerCall("web.DHCBL.BDP.BDPTranslation","IfTransLation",Ext.BDP.FunLib.TableName);
	if(TransFalg=="false"){
		btnTrans.hidden=false;
	}else{
		btnTrans.hidden=true;
	}
	/////////////////////////////日志查看 ////////////////////////////////////////
	var logmenu=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLogForOther","GetLinkTable",Ext.BDP.FunLib.SortTableName);
    var btnlog=Ext.BDP.FunLib.GetLogBtn(logmenu) 
	//var btnlog=Ext.BDP.FunLib.GetLogBtn(Ext.BDP.FunLib.SortTableName);
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
			RowID=rows[0].get('ARCICRowId');
			Desc=rows[0].get('ARCICDesc');
			var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","SaveLogParams",RowID,Desc);        
		}
	else
	{
		var result = tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","KillDatalogGlobal");
		}
	});

	/////////////////////////////接收科室日志查看 ////////////////////////////////////////
	var btnlog_loc=Ext.BDP.FunLib.GetLogBtn("User.ARCItemCatRecLoc");
	var btnhislog_loc=Ext.BDP.FunLib.GetHisLogBtn("User.ARCItemCatRecLoc")  
   
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
			RowID=rows[0].get('RLRowId');
			Desc=rows[0].get('RLOrdLocDesc')+"^"+rows[0].get('RLRecLocDesc');			
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
		 Ext.getCmp("TextCode").reset();
         Ext.getCmp("TextDesc").reset();
         Ext.getCmp("OrderType").reset();
         Ext.getCmp("ordcatText").reset();
		 grid.getStore().baseParams = {
			code : Ext.getCmp("TextCode").getValue(),
			desc : Ext.getCmp("TextDesc").getValue(),
			hospid:hospComp.getValue()
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : pagesize_main
					}
				});
		
	});
	//多院区医院-数据关联医院按钮
    var HospWinButton = GenHospWinButton(Ext.BDP.FunLib.TableName);
    //数据关联医院按钮绑定点击事件
    HospWinButton.on("click" , function(){
           if (grid.selModel.hasSelection()) { //选中一条数据数据时，弹出 数据与医院关联窗口
				var rowid=grid.getSelectionModel().getSelections()[0].get("ARCICRowId");
				GenHospWin(Ext.BDP.FunLib.TableName,rowid,function(){}).show();
			}
			else
			{
				alert('请选择需要授权的记录!')
			}        
    });
	/** 删除按钮 */
	var btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'del_btn',
   		disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
		handler :DelData= function () {
			if (grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						//删除所有别名
						AliasGrid.DataRefer = rows[0].get('ARCICRowId');
						AliasGrid.delallAlias();
						
						Ext.Ajax.request({
							url : DELETE_ACTION_URL,
							method : 'POST',
							params : {
								'id' : rows[0].get('ARCICRowId')
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
												Ext.BDP.FunLib.DelForTruePage(grid,pagesize_main);
												
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

	/************复制部分**************/                                                
	
	var CopyRecLoc_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassMethod=CopyCatsubRecLoc";
	var ItemCat_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
	
	//复制窗口
	var CopyWinForm = new Ext.FormPanel({
				id : 'Copy-form-save',
				autoScroll:true,
				//baseCls : 'x-plain',//form透明,不显示框框
				labelAlign : 'right',
				labelWidth : 150,
				split : true,
				frame : true,	
				waitMsgTarget : true,
       			reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ToItemCat',mapping:'ToItemCat'}
                                       ]),
				defaults : {
					anchor : '85%',
					bosrder : false
				},
				//defaultType : 'textfield',
				items : [{
							fieldLabel : '<font color=red>*</font>复制给医嘱子分类',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							name : 'ToItemCatF',
							id :'ToItemCat',
							hiddenName : 'ToItemCatF',
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ToItemCat'),
							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ToItemCat')),
							mode : 'remote',
							store :  new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : ItemCat_QUERY_ACTION_URL }),
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
					
					}]
	});

	//复制结果
	var copy_ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({url:''}),// 调用的动作
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'data',
                            successProperty : 'success'
                        }, [{
                            name: 'Data',
                            mapping:'Data',
                            type:'string'
                        }, {
                            name: 'Tips',
                            mapping:'Tips',
                            type:'string'
                        }   
                    ]) 
            });
	var copy_cm = new Ext.grid.ColumnModel([
                new Ext.grid.RowNumberer({width:30}),
                //new Ext.grid.CheckboxSelectionModel(),
                {header:'原始数据',dataIndex:'Data',width:100,sortable:true},
                {header:'提示',dataIndex:'Tips',width:100,sortable:true}
           ]);

  

	// 复制结果列表			
    var CopyResultGrid = new Ext.grid.GridPanel({
                id : 'CopyResultGrid',
                region : 'center',
                width : 900,
                height : 500,
                //title:"复制结果列表",
                closable : true,
                store : copy_ds,
                trackMouseOver : true,
                forceFit: true,
                columnLines : true, //在列分隔处显示分隔符
                // tools:Ext.BDP.FunLib.Component.HelpMsg,
                stripeRows : true ,
                stateful : true,
                viewConfig : {
                    forceFit : true,
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'"
                },
                sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
                cm:copy_cm
                
            });
	
	/** 复制结果窗口 */	
	var win_CopyResult = new Ext.Window({
		title : '复制结果',
		width : 900,
		height: 400,
		layout : 'fit',
		closeAction : 'hide',
		plain : true, 
		modal : true,
		frame : true,
		iconCls:"icon-copy",
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : CopyResultGrid, 
		buttons : [{
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_CopyResult.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				
			},
			"close" : function() {
			}
		}
	});
	//声明对应grid的Record对象
	var ItemRecord =  Ext.data.Record.create([		
			{name:'Data'},
			{name:'Tips'}
		]
	);

	/** 复制窗口 */	
	var win_Copy = new Ext.Window({
		title : '复制所有接收科室',
		width : 400,
		height: 200,
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
		items : CopyWinForm, 
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'Copy_save_btn',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('Copy_save_btn'),
			handler : function() {
						
						if(CopyWinForm.getForm().isValid()==false)
						{
							 Ext.Msg.alert('提示','<font color = "red">请选择要将接收科室复制给哪一项！');
							 return;
						}
						
						
						var gsm = grid.getSelectionModel();//获取选择列
			            var rows = gsm.getSelections();//根据选择列获取到所有的行
					
			            var FromItemCat=rows[0].get('ARCICRowId');
						var FromItemCatDesc=rows[0].get('ARCICDesc');
						var ToItemCatDesc=Ext.getCmp("ToItemCat").getRawValue();
						
						if (Ext.getCmp("ToItemCat").getValue()==FromItemCat)
						{
							Ext.Msg.show({
									title : '提示',
									msg : '不能复制给自己！',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
								return;
						}
					Ext.MessageBox.confirm('提示', '确定要将<'+FromItemCatDesc+'>的所有接收科室复制到<'+ToItemCatDesc+'>吗?', function(btn) {
						if (btn == 'yes') {	
								Ext.Ajax.request({
								url : CopyRecLoc_ACTION_URL,
								method : 'POST',
								params : {
									'FromCatsubDr' : FromItemCat,
									'ToCatsubDr':Ext.getCmp("ToItemCat").getValue()   ///复制给
								},
								callback : function(options, success, response) {
									Ext.MessageBox.hide();
									if (success) {
										win_Copy.hide()
										var pageSize = 200;
										CopyResultGrid.store.removeAll(); 
										var result=response.responseText.split("^");
										for(var i=1;i<result.length;i++){	
											var data=eval('('+result[i]+')');
											if (data.success == 'true') {
												
												var record = new ItemRecord({ 
													Data: data.ARCICDesc+"#"+data.RLOrdLocDesc+"#"+data.RLRecLocDesc,
													Tips: '复制成功！'
												}); 
											}
											else {
												
												var record = new ItemRecord({ 
													Data: data.ARCICDesc+"#"+data.RLOrdLocDesc+"#"+data.RLRecLocDesc,
													Tips: data.errorinfo
												});
											}

											CopyResultGrid.store.insert(CopyResultGrid.store.getCount(), record); //插入新行作为grid最后一行	
										}
										win_CopyResult.show()										
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
													
				}
			
		}, {
			text : '关闭',
			iconCls : 'icon-close',
			handler : function() {
				win_Copy.hide();
			}
		}],
		listeners : {
			"show" : function() {
				
			},
			"hide" : function() {
				Ext.getCmp("Copy-form-save").getForm().reset()
			},
			"close" : function() {
			}
		}
	});

	//复制按钮
	var btn_Copy = new Ext.Button({
    	id:'btn_Copy',
    	disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_Copy'),
        iconCls:'icon-copy',
        text:'复制所有接收科室给其它医嘱子分类',
        handler:function(){
        	var gsm = grid.getSelectionModel();//获取选择列
            var rows = gsm.getSelections();//根据选择列获取到所有的行
            if (rows.length!=1){
            	Ext.Msg.show({
					title:'提示',
					msg:'请选择一条医嘱子分类!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});
            }else{
            	
				win_Copy.setIconClass('icon-copy');
            	win_Copy.show();
            }
        }
    })




	/** 接收科室删除按钮  */
	var child_btnDel = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn'),
		handler :DelData2= function () {
			if (child_grid.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						
						for(let i=0;i<rows.length;i++){
							(function (i) {
								Ext.Ajax.request({
									url : CHILD_DELETE_ACTION_URL,
									method : 'POST',
									async: false,
									params : {
										'id' : rows[i].get('RLRowId')
									},
									callback : function(options, success, response) {
										if (success) {
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												if (i==rows.length-1)
												{
													Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.DelForTruePage(child_grid,pagesize_pop);	
														}
													});
												}
													

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
							})(i)
								
						}
						
						
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
				autoScroll : true, //滚动条
				frame : true,
				//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ARCICRowId',mapping:'ARCICRowId',type:'string'},
                                         {name: 'ARCICCode',mapping:'ARCICCode',type:'string'},
                                         {name: 'ARCICDesc',mapping:'ARCICDesc',type:'string'},
                                         {name: 'ARCICOrderType',mapping:'ARCICOrderType',type:'string'},
                                         {name: 'ARCICOrdCatDR',mapping:'ARCICOrdCatDR',type:'string'},
                                         {name: 'ARCICExecCategDR',mapping:'ARCICExecCategDR',type:'string'},
                                        // {name: 'ARCICDocCTDefineDR',mapping:'ARCICDocCTDefineDR',type:'string'},
                                         // {name: 'ARCICCalcQtyFlag',mapping:'ARCICCalcQtyFlag',type:'string'},
                                         {name: 'ARCICRestrictedOrder',mapping:'ARCICRestrictedOrder',type:'string'}
                                         
                                         
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ARCICRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ARCICRowId'
						}, {
							fieldLabel : '<font color=red>*</font>代码',
							name : 'ARCICCode',
							id:'ARCICCodeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICCodeF')),
							allowBlank : false,
							validationEvent : 'blur',  
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.ARCItemCat";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ARCICRowId'); //此条数据的rowid
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
							name : 'ARCICDesc',
							id:'ARCICDescF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICDescF')),
							allowBlank : false,
							validationEvent : 'blur',
                            validator : function(thisText){
                            	//Ext.Msg.alert(thisText);
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.CT.ARCItemCat"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ARCICRowId'); //此条数据的rowid
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
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>医嘱类型',
							name : 'ARCICOrderType',
							id:'ARCICOrderTypeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICOrderTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICOrderTypeF')),
							hiddenName : 'ARCICOrderType',
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											['R', 'Drug'],
											['D', 'Diet'],
											['I', 'IV'],
											['C', 'Consultation'],
											['N', 'Normal'],
											['T', 'Dental'],
											['L', 'LabTrak'],
											['X', 'RehabMedicine'],
											['P', 'Price'],
											['B', 'BloodBank'],
											['S', 'Diet Supplement'],
											['H', 'Hardware'],
											['E', 'Diet Enteral Feed'],
											['A', 'Day Book'],
											['F', 'DFT'],
											['DTF', 'Diet Thickened Fluid'],
											['BM', 'Bulk Meal'],
											['M', 'Material'],
											['PROS', 'Prosthetics']
											
											
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, {
							xtype : 'bdpcombo',
							fieldLabel : '<font color=red>*</font>医嘱大类',
							name : 'ARCICOrdCatDR',
							id:'ARCICOrdCatDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICOrdCatDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICOrdCatDRF')),
							hiddenName : 'ARCICOrdCatDR',
							allowBlank : false,
							store : new Ext.data.Store({   
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : ORDCAT_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ORCATRowId', 'ORCATDesc' ])
							}),
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'ORCATRowId',
							displayField : 'ORCATDesc',
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
							fieldLabel : '医嘱执行分类',
							name : 'ARCICExecCategDR',
							id:'ARCICExecCategDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICExecCategDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICExecCategDRF')),
							hiddenName : 'ARCICExecCategDR',
							store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : EXEC_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'EXECRowId', 'EXECDesc' ])
										}),
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'EXECRowId',
							displayField : 'EXECDesc'
						/*	
						 * 测试组铁羽 2016/5/31-建议把【计算数量】维护项去掉，非药品医嘱子类若勾选后会导致医生录入医嘱时医嘱数量为0
						 * }, {
							xtype : 'checkbox',
							boxLabel : '计算数量',
							name : 'ARCICCalcQtyFlag',
							id:'ARCICCalcQtyFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICCalcQtyFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICCalcQtyFlagF')),
							inputValue : 'Y'*/
						}, {
							xtype : 'checkbox',
							fieldLabel : '限制类',   //boxLabel:''  标签在右边
							name : 'ARCICRestrictedOrder',
							id:'ARCICRestrictedOrderF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICRestrictedOrderF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICRestrictedOrderF')),
							inputValue : 'Y'
						/*}, {
							xtype : 'bdpcombo',
							fieldLabel : '处方类型',
							name : 'ARCICDocCTDefineDR',
							id:'ARCICDocCTDefineDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCICDocCTDefineDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCICDocCTDefineDRF')),
							hiddenName : 'ARCICDocCTDefineDR',
							store : new Ext.data.Store({
											autoLoad : true,
											proxy : new Ext.data.HttpProxy({ url : DocCTDefine_QUERY_ACTION_URL }),
											reader : new Ext.data.JsonReader({
														totalProperty : 'total',
														root : 'data',
														successProperty : 'success'
													}, [ 'RowId', 'DHCDocCTDefineDesc' ])
										}),
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							queryParam : 'desc',
							//triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'RowId',
							displayField : 'DHCDocCTDefineDesc'	*/
						}]
			});
	
	/** 接收科室增加\修改的Form */
	var child_WinForm = new Ext.form.FormPanel({
				id : 'child-form-save',
				labelAlign : 'right',
				labelWidth : 90,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'RLRowId',mapping:'RLRowId',type:'string'},
                                         {name: 'RLRecLocDR',mapping:'RLRecLocDR',type:'string'},
                                         {name: 'RLOrdLocDR',mapping:'RLOrdLocDR',type:'string'},
                                         {name: 'RLFunction',mapping:'RLFunction',type:'string'},
                                         {name: 'RLDefaultFlag',mapping:'RLDefaultFlag',type:'string'},
                                         {name: 'RLTimeFrom',mapping:'RLTimeFrom',type:'string'},
                                         {name: 'RLTimeTo',mapping:'RLTimeTo',type:'string'},
                                         {name: 'RLCTHospitalDR',mapping:'RLCTHospitalDR',type:'string'},
                                         {name: 'RLDateFrom',mapping:'RLDateFrom',type:'string'},
                                         {name: 'RLDateTo',mapping:'RLDateTo',type:'string'},
                                         {name: 'RLOrderPriorityDR',mapping:'RLOrderPriorityDR',type:'string'},
                                         {name: 'RLClinicType',mapping:'RLClinicType',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'RLParRef',
							hideLabel : 'True',
							hidden : true,
							readOnly : true,
							name : 'RLParRef'
						},{
							fieldLabel : 'RLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'RLRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:300,

							fieldLabel : '病人科室',
							name : 'RLOrdLocDR',
							id:'RLOrdLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLOrdLocDRF')),
							hiddenName : 'RLOrdLocDR',
							mode : 'remote',
							store : new Ext.data.Store({
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
												tablename:Ext.BDP.FunLib.TableName,
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
							listWidth:300,
							
							fieldLabel : '<font color=red>*</font>接收科室',
							name : 'RLRecLocDR',
							hiddenName : 'RLRecLocDR',
							id:'RLRecLocDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLRecLocDRF')),
							mode : 'remote',
							store : new Ext.data.Store({
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
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>功能',
							name : 'RLFunction',
							id:'RLFunctionF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLFunctionF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLFunctionF')),
							hiddenName : 'RLFunction',
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['Execute', 'Execute'],
													['Processing', 'Processing']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, {
							xtype : 'checkbox',
							fieldLabel : '默认',
							name : 'RLDefaultFlag',
							id:'RLDefaultFlagF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDefaultFlagF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDefaultFlagF')),
							inputValue : 'Y'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '医院',
							name : 'RLCTHospitalDR',
							id:'RLCTHospitalDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLCTHospitalDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLCTHospitalDRF')),
							hiddenName : 'RLCTHospitalDR',
							store : new Ext.data.Store({
											autoLoad : true,
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
							xtype : 'datefield',
							fieldLabel : '<font color=red>*</font>开始日期',
							name : 'RLDateFrom',
							id:'RLDateFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDateFromF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDateFromF')),
							format : BDPDateFormat,
							allowBlank : false,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'RLDateTo',
							id:'RLDateToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLDateToF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLDateToF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						}, {
							xtype : 'timefield',
							fieldLabel : '开始时间',
							name : 'RLTimeFrom',
							id:'RLTimeFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLTimeFromF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLTimeFromF')),
							format : 'H:i:s',
							increment: 15
						}, {
							xtype : 'timefield',
							fieldLabel : '结束时间',
							name : 'RLTimeTo',
							id:'RLTimeToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLTimeToF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLTimeToF')),
							format : 'H:i:s',
							increment: 15
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							loadByIdParam : 'rowid',
							
							fieldLabel : '医嘱优先级',
							name : 'RLOrderPriorityDR',
							id:'RLOrderPriorityDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLOrderPriorityDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLOrderPriorityDRF')),
							hiddenName : 'RLOrderPriorityDR',
							
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
						},  {
							xtype : 'combo',
							listWidth : 250,
							fieldLabel : '就诊类型',
							name : 'RLClinicType',
							id:'RLClinicTypeF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RLClinicTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RLClinicTypeF')),
							hiddenName : 'RLClinicType',
							allowBlank : true,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['O', '门诊'],
													['E', '急诊'],
													['I', '住院'],
													['H', '体检'],
													['N', '新生儿']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}

						]
			});
	
	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm, AliasGrid]
			 });
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
		title : '',
		width : 330,
		height : 400,
		layout : 'fit',
		plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : tabs,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'save_btn',
   			disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
			handler : function() {
				
   			 	if(WinForm.form.isValid()==false){
   			 		Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
					return;}
				if (win.title == "添加") {
					WinForm.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : SAVE_ACTION_URL,
						method : 'POST',
						params : {									 
							'LinkHospId' :hospComp.getValue()         
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
								
								//保存别名
								AliasGrid.DataRefer = myrowid;
								AliasGrid.saveAlias();
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
							WinForm.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : SAVE_ACTION_URL,
								method : 'POST',
								success : function(form, action) {
									//保存别名
									AliasGrid.saveAlias();
									
									// alert(action);
									if (action.result.success == 'true') {
										win.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
												/*grid.getStore().load({
															params : {
																start : 0,
																limit : 1,
																rowid : myrowid
															}
														});*/
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
				win.hide();
			}
		}],
		listeners : {
			"show" : function() {
				Ext.getCmp("form-save").getForm().findField("ARCICCode").focus(true,500);
			},
			"hide" : function() {
				Ext.BDP.FunLib.Component.FromHideClearFlag();
				WinForm.getForm().reset();
			},
			"close" : function() {}
		}
	});	
	/** 接收科室增加\修改窗口 */
	var child_win = new Ext.Window({
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
		items : child_WinForm,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn'),
			handler : function() {
				var RLDateFrom = Ext.getCmp("child-form-save").getForm().findField("RLDateFrom").getValue();				
    			var RLDateTo = Ext.getCmp("child-form-save").getForm().findField("RLDateTo").getValue();
				var RLTimeFrom = Ext.getCmp("child-form-save").getForm().findField("RLTimeFrom").getValue();				
    			var RLTimeTo = Ext.getCmp("child-form-save").getForm().findField("RLTimeTo").getValue();
					
    			if (RLDateFrom != "" && RLDateTo != "") {
    				RLDateFrom = RLDateFrom.format("Ymd");
					RLDateTo = RLDateTo.format("Ymd");
        			if (RLDateFrom > RLDateTo) {
        				Ext.Msg.show({
        					title : '提示',
							msg : '开始日期不能大于结束日期!',
							minWidth : 200,
							icon : Ext.Msg.ERROR,
							buttons : Ext.Msg.OK
						});
          			 	return;
      				}
   			 	}
   			 	
   			 	if (((RLTimeFrom=="")&&(RLTimeTo != ""))||((RLTimeFrom!="")&&(RLTimeTo== ""))) 
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
   			 	
   			 	if ((RLTimeFrom!="")&&(RLTimeTo != "")) {
   			 		
   			 		if (RLTimeFrom>=RLTimeTo) {
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
   			 	if(child_WinForm.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br />请检查您的数据格式是否有误！');
   			 		return;
   			 	
   			 	}

				var ClinicType = Ext.getCmp("child-form-save").getForm().findField("RLClinicTypeF").getValue();

   			 	var WarningMsg="";
   			 	var RLDefaultFlagF = Ext.getCmp("RLDefaultFlagF").getValue();  ///true false
   			 	if(RLDefaultFlagF==true)
   			 	{
   			 		var parref = grid.getSelectionModel().getSelected().get('ARCICRowId');	 
   			 		var rlrowid = Ext.getCmp("child-form-save").getForm().findField("RLRowId").getValue();
   			 		var ordlocdr = Ext.getCmp("child-form-save").getForm().findField("RLOrdLocDR").getValue();
					var rldateform=Ext.getCmp("RLDateFromF").getValue();
					var rldateto=Ext.getCmp("RLDateToF").getValue();
					if ((rldateform!="")&&(rldateform!=null)){
						rldateform=rldateform.format('Y-m-d')
					}
					if ((rldateto!="")&&(rldateto!=null)){
						rldateto=rldateto.format('Y-m-d')
					}

   			 		var str=Ext.getCmp("RLOrderPriorityDRF").getValue()+"^"+Ext.getCmp("RLTimeFromF").getValue()+"^"+Ext.getCmp("RLTimeToF").getValue()+"^"+rldateform+"^"+rldateto+"^"+Ext.getCmp("RLCTHospitalDRF").getValue()+"^"+ClinicType+"^1"
   			 		var flag=tkMakeServerCall("web.DHCBL.CT.ARCItemCatRecLoc","GetDefRecLoc",parref,rlrowid,ordlocdr,str);
   			 		if (flag==1)
   			 		{
   			 			WarningMsg='已经存在默认接收科室，此次保存会把其他的默认记录改成不默认,'
   			 		}
   			 	
   			 	}
   			 Ext.MessageBox.confirm('提示', WarningMsg+'确定要保存该条数据吗?', function(btn) {
						if (btn == 'yes') {
   			 	
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
												child_grid.getStore().load({
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
												//Ext.BDP.FunLib.ReturnDataForUpdate("child_grid", CHILD_QUERY_ACTION_URL, myrowid)

												child_grid.getStore().load({
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
				child_win.hide();
			}
		}],
		listeners : {
			'show' : function() {
				///Ext.getCmp("child-form-save").getForm().findField("RLOrdLocDR").focus(true,800);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});

	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				id:'add_btn',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					WinForm.getForm().reset();
					win.show();
					
					
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //清空别名面板grid
		            AliasGrid.DataRefer = "";
		            AliasGrid.clearGrid();
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
						Ext.getCmp("form-save").getForm().reset();
						win.show('');
						
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ARCICRowId'),
			                waitMsg : '正在载入数据...',
			                success : function(form,action) {
			                    //Ext.Msg.alert(action);
			                	//Ext.Msg.alert('编辑', '载入成功');
			                },
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			            //激活基本信息面板
			            tabs.setActiveTab(0);
				        //加载别名面板
			            AliasGrid.DataRefer = _record.get('ARCICRowId');
				        AliasGrid.loadGrid();
			        }
				}
			});
	/** 接收科室store */
	var child_ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RLRowId',
									mapping : 'RLRowId',
									type : 'string'
								}, {
									name : 'RLRecLocDesc',
									mapping : 'RLRecLocDesc',
									type : 'string'
								}, {
									name : 'RLOrdLocDesc',
									mapping : 'RLOrdLocDesc',
									type : 'string'
								}, {
									name : 'RLFunction',
									mapping : 'RLFunction',
									type : 'string'
								}, {
									name : 'RLDefaultFlag',
									mapping : 'RLDefaultFlag',
									type : 'string'
								}, {
									name : 'RLTimeFrom',
									mapping : 'RLTimeFrom',
									type : 'string'
								}, {
									name : 'RLTimeTo',
									mapping : 'RLTimeTo',
									type : 'string'
								}, {
									name : 'RLCTHospitalDesc',
									mapping : 'RLCTHospitalDesc',
									type : 'string'
								}, {
									name : 'RLDateFrom',
									mapping : 'RLDateFrom',
									type : 'string'
								}, {
									name : 'RLDateTo',
									mapping : 'RLDateTo',
									type : 'string'
								}, {
									name : 'RLOrderPriorityDesc',
									mapping : 'RLOrderPriorityDesc',
									type : 'string'
								}, {
									name : 'RLClinicType',
									mapping : 'RLClinicType',
									type : 'string'
								}// 列的映射
						])
			});
	/** 加载前设置参数 */
	child_ds.on('beforeload',function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.apply(child_ds.lastOptions.params, {
				    	ParRef : rows[0].get('ARCICRowId')
				    });
			},this);
	/** 接收科室维护工具条 */
	var child_tbbutton = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn'),
								handler : AddData2=function() {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var RLParRef = rows[0].get('ARCICRowId')
									child_win.setTitle('添加');
									child_win.setIconClass('icon-add');
									child_win.show('new1');
									child_WinForm.getForm().reset();
									child_WinForm.getForm().findField('RLParRef').setValue(RLParRef);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn'),
									handler : UpdateData2=function() {
										var _record = child_grid.getSelectionModel().getSelected();
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
											Ext.getCmp("child-form-save").getForm().load({
								                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('RLRowId'),
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
								}), '-', child_btnDel,'-',btn_Copy,'->',btnlog_loc,'-',btnhislog_loc
					]
		});
		
	///可以多选
	var childsm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : false,
				checkOnly : false,
				width : 20
	});
	
	/** 接收科室child_grid */
	var child_grid = new Ext.grid.GridPanel({
				id : 'child_grid',
				region : 'center',
				closable : true,
				store : child_ds,
				trackMouseOver : true,
				sm : childsm, // 按"Ctrl+鼠标左键"也只能单选
				columns : [childsm, //单选列
						{
							header : 'RLRowId',
							sortable : true,
							dataIndex : 'RLRowId',
							width : 90,
							hidden : true
						}, {
							header : '病人科室',
							sortable : true,
							dataIndex : 'RLOrdLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 200
						}, {
							header : '接收科室',
							sortable : true,
							dataIndex : 'RLRecLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 200
						}, {
							header : '功能',
							sortable : true,
							width : 90,
							dataIndex : 'RLFunction'
						}, {
							header : '默认',
							sortable : true,
							width : 70,
							dataIndex : 'RLDefaultFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
						}, {
							header : '医院',
							sortable : true,
							width : 100,
							dataIndex : 'RLCTHospitalDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '开始日期',
							sortable : true,
							width : 100,
							dataIndex : 'RLDateFrom'
						}, {
							header : '结束日期',
							sortable : true,
							width : 100,
							dataIndex : 'RLDateTo'
						}, {
							header : '开始时间',
							sortable : true,
							width : 100,
							dataIndex : 'RLTimeFrom'
						}, {
							header : '结束时间',
							sortable : true,
							width : 100,
							dataIndex : 'RLTimeTo'
						}, {
							header : '医嘱优先级',
							sortable : true,
							width : 90,
							dataIndex : 'RLOrderPriorityDesc'
						}, {
							header : '就诊类型',
							sortable : true,
							width : 120,
							dataIndex : 'RLClinicType'
						}],
				title : '医嘱子分类 接收科室',
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
						  items : [ '病人科室',{
						  				xtype : 'bdpcombo',
						  				id : 'TextCode2',
						  				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
						  				mode : 'local',
						  				pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 300,
										store : new Ext.data.Store({
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
															tablename:Ext.BDP.FunLib.TableName,
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
										id : 'TextDesc2',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
										mode : 'local',
										pageSize : Ext.BDP.FunLib.PageSize.Combo,
										listWidth : 300,
										store : new Ext.data.Store({
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
													id:'sub_btnResearch',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch'),
													handler : function() {
																child_grid.getStore().baseParams={
																	RecLoc : Ext.getCmp('TextDesc2').getValue(),
																	OrdLoc : Ext.getCmp('TextCode2').getValue()
															 	};
																child_grid.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh'),
														handler : function() {
															Ext.getCmp('TextCode2').reset();
															Ext.getCmp('TextDesc2').reset();
															child_grid.getStore().baseParams={};
															child_grid.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton.render(child_grid.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid,"User.ARCItemCatRecLoc");
	/** child_grid双击事件 */
	child_grid.on('rowdblclick', function(child_grid) {
				var _record = child_grid.getSelectionModel().getSelected();
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
					Ext.getCmp("child-form-save").getForm().load({
		                url : CHILD_OPEN_ACTION_URL + '&id=' + _record.get('RLRowId'),
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
	/** 接收科室窗口 */	
	
	var child_list_win = new Ext.Window({
					//title : '医嘱子分类 接收科室',
					iconCls : 'icon-DP',
					width : Ext.getBody().getWidth()*0.96,
					height : Ext.getBody().getHeight()-180,//Ext.getBody().getHeight()*.9,
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
					items : [child_grid],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_pop = Ext.BDP.FunLib.Component.KeyMap(AddData2,UpdateData2,DelData2);
						   							
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
				tooltip : '医嘱子分类接收科室',
				iconCls : 'icon-DP',
				id:'btnLoc',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnLoc'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						Ext.getCmp('TextCode2').reset();
						Ext.getCmp('TextDesc2').reset();
						child_ds.removeAll();
						child_ds.baseParams={};
						child_ds.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win.setTitle(rows[0].get('ARCICDesc'));
						child_list_win.show();
					} else {
						Ext.Msg.show({
									title : '提示',
									msg : '请选择一条医嘱子分类!',
									icon : Ext.Msg.WARNING,
									buttons : Ext.Msg.OK
								});
					}
				}
			});
	
	/************复制部分**************/

	///新疆中医院需求of1  医嘱子分类与处方类型关联
	
	/*		
	
	///医嘱子分类与处方类型关联
	var Define_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassQuery=GetDefineDataForCmb";
	var CHILD_QUERY_ACTION_URL_define = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_define = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItemCatLinkDocCTDefine';
	var CHILD_OPEN_ACTION_URL_define = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL_define = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatLinkDocCTDefine&pClassMethod=DeleteData';
	var ItemCat_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCat&pClassQuery=GetDataForCmb1";
			
	///医嘱子分类与处方类型关联删除按钮  
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
								'id' : rows[0].get('ARCLDCDRowId')
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
												Ext.BDP.FunLib.DelForTruePage(child_grid_define,pagesize_pop);	
												
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
		
	/// 医嘱子分类与处方类型关联增加\修改的Form 
	var child_WinForm_define = new Ext.form.FormPanel({
				id : 'child-form-save_define',
				labelAlign : 'right',
				labelWidth : 90,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ARCLDCDRowId',mapping:'ARCLDCDRowId',type:'string'},
                                         {name: 'ARCLDCDItemCatDR',mapping:'ARCLDCDItemCatDR',type:'string'},
                                         {name: 'ARCLDCDDocCTDefineDR',mapping:'ARCLDCDDocCTDefineDR',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [
						{
							fieldLabel : 'ARCLDCDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'ARCLDCDRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '医嘱子分类',
							name : 'ARCLDCDItemCatDR',
							hiddenName : 'ARCLDCDItemCatDR',
							id:'ARCLDCDItemCatDRF',
   							readOnly : true,
   							style:Ext.BDP.FunLib.ReadonlyStyle(true),
							mode : 'remote',
							store : new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : ItemCat_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ARCICRowId', 'ARCICDesc' ])
							}),
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'ARCICRowId',
							displayField : 'ARCICDesc',
							allowBlank : false
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:250,
							fieldLabel : '<font color=red>*</font>处方类型',
							name : 'ARCLDCDDocCTDefineDR',
							id:'ARCLDCDDocCTDefineDRF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ARCLDCDDocCTDefineDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ARCLDCDDocCTDefineDRF')),
							hiddenName : 'ARCLDCDDocCTDefineDR',
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
		////医嘱子分类与处方类型关联增加\修改窗口 
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
				Ext.getCmp("child-form-save_define").getForm().findField("ARCLDCDDocCTDefineDR").focus(true,500);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
	
	///医嘱子分类与处方类型关联store 
	var child_ds_define = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL_define }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ARCLDCDRowId',
									mapping : 'ARCLDCDRowId',
									type : 'string'
								}, {
									name : 'ARCLDCDItemCatDR',
									mapping : 'ARCLDCDItemCatDR',
									type : 'string'
								}, {
									name : 'ARCLDCDDocCTDefineDR',
									mapping : 'ARCLDCDDocCTDefineDR',
									type : 'string'
								
								}// 列的映射
						])
			});
	///  医嘱子分类与处方类型关联维护工具条 
	var child_tbbutton_define = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn_define',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_define'),
								handler : AddData_define=function() {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var RowId = rows[0].get('ARCICRowId')
									child_win_define.setTitle('添加');
									child_win_define.setIconClass('icon-add');
									child_win_define.show('');
									child_WinForm_define.getForm().reset();
									child_WinForm_define.getForm().findField('ARCLDCDItemCatDR').setValue(RowId);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn_define',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_define'),
									handler :UpdateData_define=function() {
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
											Ext.getCmp("child-form-save_define").getForm().load({
								                url : CHILD_OPEN_ACTION_URL_define + '&id=' + _record.get('ARCLDCDRowId'),
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
	//医嘱子分类与处方类型关联child_grid_define 
	var child_grid_define = new Ext.grid.GridPanel({
				id : 'child_grid_define',
				region : 'center',
				closable : true,
				store : child_ds_define,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'ARCLDCDRowId',
							sortable : true,
							dataIndex : 'ARCLDCDRowId',
							hidden : true
						}, {
							header : '医嘱子分类',
							sortable : true,
							dataIndex : 'ARCLDCDItemCatDR',
							width : 160,
							hidden : true
						}, {
							header : '处方类型',
							sortable : true,
							dataIndex : 'ARCLDCDDocCTDefineDR',
							width : 160
						
						}],
				title : '医嘱子分类与处方类型关联',
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
																	itemcatdr : grid.getSelectionModel().getSelections()[0].get('ARCICRowId')
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
																itemcatdr : grid.getSelectionModel().getSelections()[0].get('ARCICRowId')
															 	
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
	Ext.BDP.FunLib.ShowUserHabit(child_grid_define,"User.ARCItemCatLinkDocCTDefine");
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
					 Ext.getCmp("child-form-save_define").getForm().load({
		                url : CHILD_OPEN_ACTION_URL_define + '&id=' + _record.get('ARCLDCDRowId'),
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
	/// 医嘱子分类与处方类型关联窗口 	
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
	//医嘱子分类与处方类型关联
	var btnDefine = new Ext.Toolbar.Button({
				text : '关联处方类型',
				tooltip : '关联处方类型',
				iconCls : 'icon-DP',
				id:'btnDefine',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDefine'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						child_ds_define.baseParams={
							itemcatdr : grid.getSelectionModel().getSelections()[0].get('ARCICRowId')
						};
						child_ds_define.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win_define.setTitle(rows[0].get('ARCICDesc')+'---与处方类型关联');
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
	
	////医嘱子分类与处方类型关联 完
	*/	
	/*		
			
	//ofy7 吉大三院需求
	///开医嘱限制
	var CHILD_QUERY_ACTION_URL_res = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRestrictLoc&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_res = '../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRestrictLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItemCatRestrictLoc';
	var CHILD_OPEN_ACTION_URL_res = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRestrictLoc&pClassMethod=OpenData";
	var CHILD_DELETE_ACTION_URL_res = '../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRestrictLoc&pClassMethod=DeleteData';
			
	//开医嘱限制删除按钮 
	var child_btnDel_res = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '请选择一行后删除(Shift+D)',
		iconCls : 'icon-delete',
		id:'sub_del_btn_res',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_del_btn_res'),
		handler : DelData_res=function() {
			if (child_grid_res.selModel.hasSelection()) {
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
						var gsm = child_grid_res.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						Ext.Ajax.request({
							url : CHILD_DELETE_ACTION_URL_res,
							method : 'POST',
							params : {
								'id' : rows[0].get('RESLRowId')
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
												Ext.BDP.FunLib.DelForTruePage(child_grid_res,pagesize_pop);
												
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
	
	
	
	
	//开医嘱限制增加\修改的Form 
	var child_WinForm_res = new Ext.form.FormPanel({
				id : 'child-form-save_res',
				labelAlign : 'right',
				labelWidth : 90,
				autoScroll:true,//滚动条
				frame : true,//baseCls : 'x-plain',
        		reader: new Ext.data.JsonReader({root:'list'},
                                       
                                          [{name: 'RESLRowId',mapping:'RESLRowId',type:'string'},
                                         {name: 'RESLLocDR',mapping:'RESLLocDR',type:'string'},
                                         {name: 'RESLFunction',mapping:'RESLFunction',type:'string'},
                                         {name: 'RESLFlag',mapping:'RESLFlag',type:'string'},
                                         {name: 'RESLDateFrom',mapping:'RESLDateFrom',type:'string'},
                                         {name: 'RESLDateTo',mapping:'RESLDateTo',type:'string'}
                                   ]),
				defaults : {
					anchor : '90%',
					border : false
				},
				defaultType : 'textfield',
				items : [
						{
							fieldLabel : 'RESLParRef',
							hideLabel : 'True',
							hidden : true,
							readOnly : true,
							name : 'RESLParRef'
						},{
							fieldLabel : 'RESLRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'RESLRowId'
						}, {
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							listWidth:300,
							fieldLabel : '<font color=red>*</font>科室',
							name : 'RESLLocDR',
							id:'RESLLocDRF',
							allowBlank : false,
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLLocDRF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLLocDRF')),
							hiddenName : 'RESLLocDR',
							mode : 'remote',
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
							//triggerAction : 'all',  设置页码要注释此行
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'CTLOCRowID',
							displayField : 'CTLOCDesc'
						
						}, {
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>开医嘱权限',
							name : 'RESLFunction',
							id:'RESLFunctionF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLFunctionF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLFunctionF')),
							hiddenName : 'RESLFunction',
							allowBlank : false,
							mode : 'local',
							store : new Ext.data.SimpleStore({
										fields : ['value', 'text'],
										data : [
													['R', '限制'],
													['A', '允许']
												]
									}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						
						}, {
							xtype : 'datefield',
							fieldLabel : '开始日期',
							name : 'RESLDateFrom',
							id:'RESLDateFromF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLDateFromF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLDateFromF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						
						}, {
							xtype : 'datefield',
							fieldLabel : '结束日期',
							name : 'RESLDateTo',
							id:'RESLDateToF',
   							readOnly : Ext.BDP.FunLib.Component.DisableFlag('RESLDateToF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('RESLDateToF')),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : { 'keyup' : function(field, e){ Ext.BDP.FunLib.Component.GetCurrentDate(field,e); }}
						
					
						}]
			});

			//开医嘱限制增加\修改窗口 
	var child_win_res = new Ext.Window({
		title : '',
		width : 350,
		height:300,
		layout : 'fit',
		//plain : true,// true则主体背景透明
		modal : true,
		frame : true,
		//collapsible : true,
		//constrain : true,
		hideCollapseTool : true,
		//titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		closeAction : 'hide',
		items : child_WinForm_res,
		buttons : [{
			text : '保存',
			iconCls : 'icon-save',
			id:'sub_savebtn_res',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('sub_savebtn_res'),
			handler : function() {
				
   			 	if(child_WinForm_res.form.isValid()==false){
   			 	 	Ext.Msg.alert('提示','<font color = "red">数据验证失败，<br/>请检查您的数据格式是否有误！');
					return;
   			 	}
				if (child_win_res.title == '添加') {
					child_WinForm_res.form.submit({
						clientValidation : true, // 进行客户端验证
						waitMsg : '正在提交数据请稍后...',
						waitTitle : '提示',
						url : CHILD_SAVE_ACTION_URL_res,
						method : 'POST',
						success : function(form, action) {
							if (action.result.success == 'true') {
								child_win_res.hide();
								var myrowid = action.result.id;
								// var myrowid = jsonData.id;
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												child_grid_res.getStore().load({
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
							child_WinForm_res.form.submit({
								clientValidation : true, // 进行客户端验证
								waitMsg : '正在提交数据请稍后...',
								waitTitle : '提示',
								url : CHILD_SAVE_ACTION_URL_res,
								method : 'POST',
								success : function(form, action) {
									// alert(action);
									if (action.result.success == 'true') {
										child_win_res.hide();
										var myrowid = "rowid=" + action.result.id;
										// var myrowid = jsonData.id;
										Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											icon : Ext.Msg.INFO,
											buttons : Ext.Msg.OK,
											fn : function(btn) {
												Ext.BDP.FunLib.ReturnDataForUpdate("child_grid_res", CHILD_QUERY_ACTION_URL_res, myrowid)
												
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
				child_win_res.hide();
			}
		}],
		listeners : {
			'show' : function() {
				//Ext.getCmp("child-form-save_res").getForm().findField("RESLLocDR").focus(true,800);
			},
			'hide' : function() {
			},
			'close' : function() {
			}
		}
	});
	
	//开医嘱限制store 
	var child_ds_res = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : CHILD_QUERY_ACTION_URL_res }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'RESLRowId',
									mapping : 'RESLRowId',
									type : 'string'
								}, {
									name : 'RESLLocDesc',
									mapping : 'RESLLocDesc',
									type : 'string'
								
								}, {
									name : 'RESLFunction',
									mapping : 'RESLFunction',
									type : 'string'
								}, {
									name : 'RESLFlag',
									mapping : 'RESLFlag',
									type : 'string'
								
								}, {
									name : 'RESLDateFrom',
									mapping : 'RESLDateFrom',
									type : 'string'
								}, {
									name : 'RESLDateTo',
									mapping : 'RESLDateTo',
									type : 'string'
								
								}// 列的映射
						])
			});
	
	//开医嘱限制维护工具条 
	var child_tbbutton_res = new Ext.Toolbar({
		enableOverflow : true,
		items : [new Ext.Button({text:'添加',
								tooltip : '添加一条数据(Shift+A)',
								iconCls : 'icon-add',
								id:'sub_addbtn_res',
  						 		disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_addbtn_res'),
								handler : AddData_res=function() {
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									var ARCICRowId = rows[0].get('ARCICRowId')
									child_win_res.setTitle('添加');
									child_win_res.setIconClass('icon-add');
									child_win_res.show('');
									child_WinForm_res.getForm().reset();
									child_WinForm_res.getForm().findField('RESLParRef').setValue(ARCICRowId);
								},
								scope : this
							}), '-',
					new Ext.Button({text : '修改',
									tooltip : '请选择一行后修改(Shift+U)',
									iconCls : 'icon-update',
									id:'sub_updatebtn_res',
   									disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_updatebtn_res'),
									handler : UpdateData_res=function() {
											if (!child_grid_res.selModel.hasSelection()) {
									            Ext.Msg.show({
														title : '提示',
														msg : '请选择需要修改的行!',
														icon : Ext.Msg.WARNING,
														buttons : Ext.Msg.OK
													});
									        } else {
									        var _record = child_grid_res.getSelectionModel().getSelected();
								            child_win_res.setTitle('修改');
											child_win_res.setIconClass('icon-update');
											child_win_res.show('');
											 Ext.getCmp("child-form-save_res").getForm().load({
								                url : CHILD_OPEN_ACTION_URL_res + '&id=' + _record.get('RESLRowId'),
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
								}), '-', child_btnDel_res]
		});
	//开医嘱限制child_grid_res 
	var child_grid_res = new Ext.grid.GridPanel({
				id : 'child_grid_res',
				region : 'center',
				closable : true,
				store : child_ds_res,
				trackMouseOver : true,
				columns : [new Ext.grid.CheckboxSelectionModel(), //单选列
						{
							header : 'RESLRowId',
							sortable : true,
							dataIndex : 'RESLRowId',
							hidden : true
						}, {
							header : '科室',
							sortable : true,
							dataIndex : 'RESLLocDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow,
							width : 160
						
						}, {
							header : '开医嘱权限',
							sortable : true,
							dataIndex : 'RESLFunction',
							renderer : function(v){
								if(v=='R'){return '限制';}
								if(v=='A'){return '允许';}
								
							
							}
						
						}, {
							header : '开始日期',
							sortable : true,
							dataIndex : 'RESLDateFrom'
						
						}, {
							header : '结束日期',
							sortable : true,
							dataIndex : 'RESLDateTo'
						
						}],
				title : '开医嘱限制',
				stripeRows : true,
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : new Ext.PagingToolbar({
						pageSize : pagesize_pop,
						store : child_ds_res,
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
						  items : ['科室',{
						  				xtype : 'bdpcombo',
						  				id : 'TextLOCDR',
						  				disabled : Ext.BDP.FunLib.Component.DisableFlag('TextLOCDR'),
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
										valueField : 'CTLOCRowID',
										displayField : 'CTLOCDesc'
						  			}, '-',
									'开医嘱权限', {
										fieldLabel : '开医嘱权限',
										xtype : 'combo',
										id : 'TextFunc',
										disabled : Ext.BDP.FunLib.Component.DisableFlag('TextFunc'),
										width : 140,
										mode : 'local',
										triggerAction : 'all',// query
										forceSelection : true,
										selectOnFocus : false,
										minChars : 1,
										listWidth : 250,
										valueField : 'value',
										displayField : 'name',
										store : new Ext.data.JsonStore({
											fields : ['name', 'value'],
											data : [{
												name : '限制',
												value : 'R'
											}, {
												name : '允许',
												value : 'A'
											
											}]
										})},'-',
									new Ext.Button({iconCls : 'icon-search',
													text : '搜索',
													id:'sub_btnResearch_res',
   													disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnResearch_res'),
													handler : function() {
																child_grid_res.getStore().baseParams={
																	ParRef : grid.getSelectionModel().getSelections()[0].get('ARCICRowId'),
																	locdr:Ext.getCmp("TextLOCDR").getValue(),
																	func:Ext.getCmp("TextFunc").getValue()
															 	};
																child_grid_res.getStore().load({params : {start : 0, limit : pagesize_pop}});
															}
													}), '-',
									new Ext.Button({ iconCls : 'icon-refresh',
														text : '重置',
														id:'sub_btnRefresh_res',
   														disabled : Ext.BDP.FunLib.Component.DisableFlag('sub_btnRefresh_res'),
														handler : function() {
															child_grid_res.getStore().baseParams={
																ParRef : grid.getSelectionModel().getSelections()[0].get('ARCICRowId')
																
															};
															Ext.getCmp("TextLOCDR").reset();
															Ext.getCmp("TextFunc").reset();
															child_grid_res.getStore().load({ params : { start : 0, limit : pagesize_pop } });
														}
													})
									],
							listeners : {
									render : function() {
										child_tbbutton_res.render(child_grid_res.tbar) // tbar.render(panel.bbar)这个效果在底部
									}
							}
						})
			});	
	Ext.BDP.FunLib.ShowUserHabit(child_grid_res,"User.ARCItemCatRestrictLoc");
	//child_grid_res双击事件 
	child_grid_res.on('rowdblclick', function(child_grid_res) {
				if (!child_grid_res.selModel.hasSelection()) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		        	var _record = child_grid_res.getSelectionModel().getSelected();
		            child_win_res.setTitle('修改');
					child_win_res.setIconClass('icon-update');
					child_win_res.show('');
					Ext.getCmp("child-form-save_res").getForm().load({
		                url : CHILD_OPEN_ACTION_URL_res + '&id=' + _record.get('RESLRowId'),
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
	//开医嘱限制窗口 		
	var child_list_win_res = new Ext.Window({
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
					//titleCollapse : true,
					//bodyStyle : 'padding:3px',
					constrain : true,
					closeAction : 'hide',
					items : [child_grid_res],
					listeners : {
						"show" : function(){
							keymap_main.disable();
						    keymap_res = Ext.BDP.FunLib.Component.KeyMap(AddData_res,UpdateData_res,DelData_res);
													
						},
						"hide" : function(){
							keymap_res.disable();
							keymap_main.enable();
						},
						"close" : function(){
						}
					}
				});
	////开医嘱限制 
	var btnResLoc = new Ext.Toolbar.Button({
				text : '开医嘱限制',
				tooltip : '开医嘱限制',
				iconCls : 'icon-DP',
				id:'btnResLoc',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnResLoc'),
				handler : function() {
					if (grid.selModel.hasSelection()) {
						child_ds_res.baseParams={
							ParRef : grid.getSelectionModel().getSelections()[0].get('ARCICRowId')
						};
						child_ds_res.load({
								params : {
										start : 0,
										limit : pagesize_pop
									}
							});
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						child_list_win_res.setTitle(rows[0].get('ARCICDesc')+'---开医嘱限制');
						child_list_win_res.show();
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
	
	////开医嘱限制 完
		*/
	 var fields=[{
									name : 'ARCICRowId',
									mapping : 'ARCICRowId',
									type : 'int'
								}, {
									name : 'ARCICCode',
									mapping : 'ARCICCode',
									type : 'string'
								}, {
									name : 'ARCICDesc',
									mapping : 'ARCICDesc',
									type : 'string'
								}, {
									name : 'ARCICOrderType',
									mapping : 'ARCICOrderType',
									type : 'string'
								}, {
									name : 'ARCICOrdCatDR',
									mapping : 'ARCICOrdCatDR',
									type : 'string'
								}, {
									name : 'ARCICExecCategDR',
									mapping : 'ARCICExecCategDR',
									type : 'string'
								}, {
									name : 'ARCICCalcQtyFlag',
									mapping : 'ARCICCalcQtyFlag',
									type : 'string'
								}, {
									name : 'ARCICRestrictedOrder',
									mapping : 'ARCICRestrictedOrder',
									type : 'string'
								/*}, {
									name : 'ARCICDocCTDefineDR',
									mapping : 'ARCICDocCTDefineDR',
									type : 'string'*/
								}
						]
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, fields)
			});
			
	Ext.BDP.AddReaderFieldFun(ds,fields,Ext.BDP.FunLib.TableName);

	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
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
			
				
			
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [btnAddwin, '-', btnEditwin, '-', btnDel,'-',btnLoc  ,'-',HospWinButton   //多院区医院
			// ,'-',btnDefine   ///新疆中医院
			//,'-',btnResLoc
			
		,'-',btnSort,'-',btnTrans  
		,'->',btnlog,'-',btnhislog
		]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue(),
							OrderType : Ext.getCmp("OrderType").getValue(),
							OrderCat : Ext.getCmp("ordcatText").getValue(),
							hospid:hospComp.getValue()
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
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					//翻译
					Ext.BDP.FunLib.SelectRowId="";
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					Ext.getCmp("OrderType").reset();
					Ext.getCmp("ordcatText").reset();
					grid.getStore().baseParams={hospid:hospComp.getValue()};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							id : 'TextCode'
						}, '-',
						'描述', {
							xtype : 'textfield',
							emptyText : '描述/别名',id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-',
						'医嘱类型', {
							xtype : 'combo',
							id : 'OrderType',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('OrderType'),
							mode : 'local',
							store : new Ext.data.SimpleStore({
								fields : ['value', 'text'],
								data : [
											/*['R', 'Drug'],
											['N', 'Normal'],
											['L', 'LabTrak'],
											['P', 'Price'] */
								
											['R', 'Drug'],
											['D', 'Diet'],
											['I', 'IV'],
											['C', 'Consultation'],
											['N', 'Normal'],
											['T', 'Dental'],
											['L', 'LabTrak'],
											['X', 'RehabMedicine'],
											['P', 'Price'],
											['B', 'BloodBank'],
											['S', 'Diet Supplement'],
											['H', 'Hardware'],
											['E', 'Diet Enteral Feed'],
											['A', 'Day Book'],
											['F', 'DFT'],
											['DTF', 'Diet Thickened Fluid'],
											['BM', 'Bulk Meal'],
											['M', 'Material'],
											['PROS', 'Prosthetics']
										]
							}),
							triggerAction : 'all',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							//minChars : 1,
							valueField : 'value',
							displayField : 'text'
						}, '-',
						'医嘱大类', {
							xtype : 'bdpcombo',
							id : 'ordcatText',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('ordcatText'),
							store :new Ext.data.Store({
								autoLoad : true,
								proxy : new Ext.data.HttpProxy({ url : ORDCAT_QUERY_ACTION_URL }),
								reader : new Ext.data.JsonReader({
											totalProperty : 'total',
											root : 'data',
											successProperty : 'success'
										}, [ 'ORCATRowId', 'ORCATDesc' ])
							}),
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							listWidth : 250,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							valueField : 'ORCATRowId',
							displayField : 'ORCATDesc',
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
						}, '-',Ext.BDP.FunLib.GetLookUpBtnFun(Ext.BDP.FunLib.TableName),'-',  btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar) // tbar.render(panel.bbar)这个效果在底部
					}
				}
			});
	
	var GridCM=[new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ARCICRowId',
							sortable : true,
							dataIndex : 'ARCICRowId',
							hidden : true,
							width:80
						}, {
							header : '代码',
							sortable : true,
							dataIndex : 'ARCICCode',
							width:160
						}, {
							header : '描述',
							sortable : true,
							dataIndex : 'ARCICDesc',
							width:160
						}, {
							header : '医嘱类型',
							sortable : true,
							width:160,
							dataIndex : 'ARCICOrderType',
							renderer : function(v){
								if(v=='R'){return 'Drug';}
								if(v=='D'){return 'Diet';}
								if(v=='I'){return 'IV';}
								if(v=='C'){return 'Consultation';}
								if(v=='N'){return 'Normal';}
								if(v=='T'){return 'Dental';}
								if(v=='L'){return 'LabTrak';}
								if(v=='X'){return 'RehabMedicine';}
								if(v=='P'){return 'Price';}
								if(v=='B'){return 'BloodBank';}
								if(v=='S'){return 'Diet Supplement';}
								if(v=='H'){return 'Hardware';}
								if(v=='E'){return 'Diet Enteral Feed';}
								if(v=='A'){return 'Day Book';}
								if(v=='F'){return 'DFT';}
								if(v=='DTF'){return 'Diet Thickened Fluid';}
								if(v=='BM'){return 'Bulk Meal';}
								if(v=='M'){return 'Material';}
								if(v=='PROS'){return 'Prosthetics';}
							
							}
						}, {
							header : '医嘱大类',
							sortable : true,
							dataIndex : 'ARCICOrdCatDR',
							width:160
						}, {
							header : '医嘱执行分类',
							sortable : true,
							dataIndex : 'ARCICExecCategDR',
							width:160
						}, {
							header : '计算数量',
							sortable : true,
							dataIndex : 'ARCICCalcQtyFlag',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							hidden : true,
							width:160
						/*}, {
							header : '处方类型',
							sortable : true,
							dataIndex : 'ARCICDocCTDefineDR'*/
						}, {
							header : '限制类',
							sortable : true,
							dataIndex : 'ARCICRestrictedOrder',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
							width:160
						}]
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns : GridCM,
				stripeRows : true,
				title : '医嘱子分类',
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
			
	Ext.BDP.AddTabpanelFun(tabs,Ext.BDP.FunLib.TableName);
	Ext.BDP.AddColumnFun(grid,Ext.BDP.FunLib.TableName,GridCM);	
	
	Ext.BDP.FunLib.ShowUserHabit(grid,Ext.BDP.FunLib.SortTableName);		
	 //单击事件（翻译按钮要用到）
	btnTrans.on("click",function(){
		if (grid.selModel.hasSelection()) {		
	        var _record = grid.getSelectionModel().getSelected();
	        var selectrow = _record.get('ARCICRowId');	           
		 } else {
		 	var selectrow="";
		 }
		 Ext.BDP.FunLib.SelectRowId = selectrow
	});	
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {
				
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
					Ext.getCmp("form-save").getForm().reset();
					win.show('');
					
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ARCICRowId'),
		                waitMsg : '正在载入数据...',
		                success : function(form,action) {
		                    //Ext.Msg.alert(action);
		                	//Ext.Msg.alert('编辑', '载入成功');
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		            
		            //激活基本信息面板
		            tabs.setActiveTab(0);
			        //加载别名面板
		            AliasGrid.DataRefer = _record.get('ARCICRowId');
			        AliasGrid.loadGrid();
		        }
			});
	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [GenHospPanel(hospComp),grid]  //多院区医院
			});
	
	
    var keymap_pop = "",keymap_define="",keymap_res=""
    var keymap_main=Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);
    
    //多院区医院
    ///医嘱大类下拉框, 新增修改弹窗 
	/*Ext.getCmp('ARCICOrdCatDRF').store.on("beforeload", function() {
        this.baseParams = {hospid:hospComp.getValue() };
    });*/
    ///医嘱大类下拉框, 工具条查询
	/*Ext.getCmp('ordcatText').store.on("beforeload", function() {
        this.baseParams = {hospid:hospComp.getValue() };
    });
    ///医嘱子分类下拉框, 复制接收科室给其他医嘱子分类
	Ext.getCmp('ToItemCat').store.on("beforeload", function() {
        this.baseParams = {hospid:hospComp.getValue() };
    });
    */
    
   /* ///病人科室 下拉框 ,  新增修改弹窗 
    Ext.getCmp('RLOrdLocDRF').store.on("beforeload", function() {
		this.baseParams = {hospid:hospComp.getValue() };
    });
    ///接收科室 下拉框 , 新增修改弹窗 
    Ext.getCmp('RLRecLocDRF').store.on("beforeload", function() {
		this.baseParams = {hospid:hospComp.getValue() };
    });
    ///病人科室下拉框 工具条查询
    Ext.getCmp('TextCode2').store.on("beforeload", function() {
		this.baseParams = {hospid:hospComp.getValue() };
    });
    ///接收科室下拉框 工具条查询
	Ext.getCmp('TextDesc2').store.on("beforeload", function() {
		this.baseParams = {hospid:hospComp.getValue() };
    });
    */
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
						limit : pagesize_main
					},
					callback : function(records, options, success) {
						// alert(options);
						// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
					}
				});
	
	}
    
    
    
});
