/// 名称: 诊断与症状关联表维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-5-19
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'side';
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHSymptom&pClassQuery=GetDataForCmb1";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDisLinkSym";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassQuery=GetList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassMethod=DeleteData";
var DELETE_IDS_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDisLinkSym&pClassMethod=DeleteDataStr";
var pagesize_main = Ext.BDP.FunLib.PageSize.Pop;
//全局变量
var selectrow=Ext.BDP.FunLib.getParam("selectrow");
 //清空选中的表头全选框checkbox  
 function clearCheckGridHead(grid){  
  	var hd_checker = grid.getEl().select('div.x-grid3-hd-checker');    
     var hd = hd_checker.first();   
     hd.removeClass('x-grid3-hd-checker-on'); 
 } 

 		/************************关联通用名*************************************/
	var btnGen = new Ext.Toolbar.Button({
			text : '建议用药或检查',
			tooltip : '建议用药或检查',
			iconCls : 'icon-DP',
			id : 'btnGen',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnGen'),
	      	handler: ConGen=function () {			        
				var records =  gridCenter.selModel.getSelections();
				var recordsLen= records.length;
				if(recordsLen == 0){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});	
					 return
				 };
				if(recordsLen > 1){
						Ext.Msg.show({
										title:'提示',
										minWidth:200,
										msg:'请选择其中一行进行维护!',
										icon:Ext.Msg.WARNING,
										buttons:Ext.Msg.OK
									});
				  }
				 else{
				        var gsm = gridCenter.getSelectionModel();// 获取选择列
					    var rows = gsm.getSelections();// 根据选择列获取到所有的行
					    var itemdesc=rows[0].get('LSYSymDr');
					    var itemRowId=rows[0].get('LSYRowId')
	                	var link="dhc.bdp.ext.default.csp?extfilename=App/KB/Dic/DHC_PHDisLinkSymI&selectrow="+itemRowId; 
						var windowSyn = new Ext.Window({
										iconCls : 'icon-DP',
										width : 700,
										height : 400,
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
										html : '',
										listeners : {
											"show" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
											    	keymap_main.disable();
											    }
											},
											"hide" : function(){
											},
											"close" : function(){
												if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器,否则可能会报错
											    {
													keymap_main.enable();
											    }
											}
										}
									});
						windowSyn.html='<iframe id="ifrmalias" src=" '+link+' " width="100%" height="100%"></iframe>';
						windowSyn.setTitle(itemdesc);
						windowSyn.show();
				}
	      }	
    });
    
/**********************************west***********************************/
/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'SYMRowId',
							mapping : 'SYMRowId',
							type : 'string'
						}, {
							name : 'SYMCode',
							mapping : 'SYMCode',
							type : 'string'
						}, {
							name : 'SYMDesc',
							mapping : 'SYMDesc',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWest
	});

	/** grid加载数据 */
	dsWest.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWest = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWest,
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
		/** 工具条 */
	
		/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					gridWest.getStore().baseParams={			
							desc : Ext.getCmp("TextDesc").getValue()
					};
					gridWest.getStore().load({
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
					Ext.getCmp("TextDesc").reset();
					gridWest.getStore().baseParams={};
					gridWest.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
					clearCheckGridHead(gridWest);  //重置全选按钮
						}
				});
				
		var btnSave = new Ext.Button({			
					xtype : 'button',
					text : '关联',
					icon : Ext.BDP.FunLib.Path.URL_Icon+'folder_go.png',
					id:'btnSave',
	   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSave'),
					handler : function SaveData() {
						var rs=gridWest.getSelectionModel().getSelections();
						if(rs.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请选择需要关联的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else{
							var fieldStr = "";

							Ext.each(rs,function(){
								if(fieldStr!="") fieldStr = fieldStr+",";
								var fieldDR=this.get('SYMRowId');//症状id
								fieldStr = fieldStr+fieldDR;
							})
								Ext.Ajax.request({
									url : SAVE_ACTION_URL , 		
									method : 'POST',	
									params : {
											'LSYSymDr' : fieldStr,
											'LSYIcdDr':selectrow											
									},
									callback : function(options, success, response) {	
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												var myrowid = jsonData.id;

												gridCenter.getStore().load({
															params : {
																	   'parref':selectrow,
																		start : 0,
																		limit : pagesize_main
																	}
															});
												
												gridWest.getStore().load({
													params : {
														start : 0,
														limit : pagesize_main
													},
													callback : function(records, options, success) {
													}
												});
												clearCheckGridHead(gridWest);  //重置全选按钮
											}else{
												var errorMsg ='';
												if(jsonData.errorinfo){
													errorMsg='<br />'+jsonData.errorinfo
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
								});
					
						}
					},
					scope : this
				});
				
				
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : [
				'描述',{
						xtype : 'textfield',
						id : 'TextDesc',
						emptyText : '描述',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc'),
						enableKeyEvents : true,
						listeners : {
				       	'keyup' : function(field, e){
							gridWest.getStore().baseParams={			
									desc : Ext.getCmp("TextDesc").getValue()
							};
							gridWest.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
							}
						}
					},'-', btnSearch,'-',btnRefresh,'->',btnSave
				]
	});
 

	/** 创建grid */
	var gridWest = new Ext.grid.GridPanel({
		id : 'gridWest',
		region : 'west',
		width:380,
		closable : true,
		store : dsWest,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'SYMRowId',
					sortable : true,
					dataIndex : 'SYMRowId',
					hidden : true
				}, {
					header : '症状代码',
					sortable : true,
					dataIndex : 'SYMCode'
					//hidden : true
				}, {
					header : '症状描述',
					sortable : true,
					dataIndex : 'SYMDesc'
				}],
		stripeRows : true,
		title:'症状列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.RowSelectionModel({singleSelect:false}), // 按"Ctrl+鼠标左键"也只能单选
		sm : new Ext.grid.CheckboxSelectionModel,
		bbar : pagingWest,
		tbar:tb,
		stateId : 'gridWest'
	});

/**********************************Center *************************************/

	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [  {
							name : 'LSYRowId',
							mapping : 'LSYRowId',
							type : 'string'
						},{
							name : 'LSYIcdDr',
							mapping : 'LSYIcdDr',
							type : 'string'
						},{
							name : 'SYMRowId',
							mapping : 'SYMRowId',
							type : 'string'
						},{
							name : 'LSYSymDr',
							mapping : 'LSYSymDr',
							type : 'string'
						}// 列的映射
				])
	});
	/** grid 数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsCenter
	});
	dsCenter.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		    'parref':selectrow
		  }   
		)
	});
	/** grid 加载数据 */
	//grid加载之前加载可编辑下拉框
	dsCenter.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid 分页工具条 */
	var pagingCenter = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsCenter,
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

	
	//批量删除后刷新数据
	var AfterDeleteData=function(){
			var startIndex = gridCenter.getBottomToolbar().cursor;
			var totalnum=gridCenter.getStore().getTotalCount();
			if(totalnum==1){   //修改添加后只有一条，返回第一页
				var startIndex=0
			}
			else if((totalnum-1)%pagesize_main==0)//最后一页只有一条
			{
				var pagenum=gridCenter.getStore().getCount();
				if (pagenum==1){ startIndex=startIndex-pagesize_main;}  //最后一页的时候,不是最后一页则还停留在这一页
			}
			gridCenter.getStore().load({
				params : {
					'parref':selectrow,
					start : startIndex,
					limit : pagesize_main
				}
			});
			gridWest.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
				}
			});
			clearCheckGridHead(gridCenter);  //重置全选按钮
	}
	
	//批量撤销按钮
	var btnSynDelete = new Ext.Button({			
				xtype : 'button',
				text : '批量撤销',
				icon : Ext.BDP.FunLib.Path.URL_Icon+'delete.gif',
				id:'btnSynDelete',
   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSynDelete'),
				handler : function DeleteConICDData() {
					var rs=gridCenter.getSelectionModel().getSelections();
					if(rs.length==0){
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要撤销的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
					}else{
					    var deleteIds=""  //要删除的数据ID串
						Ext.each(rs,function(){
							if (deleteIds!="")
							{
								deleteIds=deleteIds+"^"+this.get('LSYRowId')
							}
							else
							{
								deleteIds=this.get('LSYRowId')
							}
							
						})
						
						var wrongInfo=""   //错误信息
			
						Ext.Ajax.request({
								url : DELETE_IDS_ACTION_URL,
								method : 'POST',
								params : {
									'ids' : deleteIds
								},
								callback : function(options, success, response) {
									if (success) 
									{
										var jsonData = Ext.util.JSON.decode(response.responseText);
										if (jsonData.success == 'false') {									
											if (jsonData.info) {
												wrongInfo='<br/>错误信息:' + jsonData.info
												
											}
										}
										
									    if(wrongInfo!=""){
												Ext.Msg.show({
													title : '提示',
													msg : '批量撤销失败!'+wrongInfo,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK,
													fn : function(btn) {
														AfterDeleteData();
													}
												});
											
										}else{
											Ext.Msg.show({
												title : '提示',
												msg : '批量撤销成功!',
												icon : Ext.Msg.INFO,
												buttons : Ext.Msg.OK,
												fn : function(btn) {
													AfterDeleteData();
												}
										     });
										}

									} 
									else 
									{
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
				},
				scope : this
			});
	var conSyntb = new Ext.Toolbar({
		id : 'conSyntb',
		items : [btnSynDelete,'->',btnGen]
	});
	/** 创建grid */
	var gridCenter = new Ext.grid.EditorGridPanel({
		id : 'gridCenter',
		region : 'center',
		closable : true,
		store : dsCenter,
		trackMouseOver : true,
		clicksToEdit:1,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'rowid',
					sortable : true,
					dataIndex : 'LSYRowId',
					hidden : true
				},{
					header : '诊断',
					sortable : true,
					dataIndex : 'LSYIcdDr'
				},{
					header : '症状rowid',
					sortable : true,
					dataIndex : 'SYMRowId',
					hidden:true
				},{
					header : '症状',
					sortable : true,
					dataIndex : 'LSYSymDr'
				},{
					header : '操作',
					dataIndex : 'LSYRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >撤销</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '已选列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.CheckboxSelectionModel,
		//sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		tbar:conSyntb,
		bbar : pagingCenter,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter'

	});
	
	
	/**已选列表双击进行已选列表中撤销操作*/
	gridCenter.on("cellclick", function (grid, rowIndex, columnIndex, e){
	  var btn = e.getTarget('.delBtn');
	  if(btn){
	  	Ext.MessageBox.confirm('提示','确定撤销该关联数据吗?', function(button) {
	 	 if(button=="yes"){
			Ext.Ajax.request({
				url : DELETE_ACTION_URL,
				method : 'POST',
				params : {
					'id' : gridCenter.getSelectionModel().getSelected().get('LSYRowId')//频率id
				},
				callback : function(options, success, response) {
					if (success) {
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({
								title : '提示',
								msg : '关联撤销成功!',
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
									gridCenter.getStore().load({
										params : {
											'parref':selectrow,
											start : startIndex,
											limit : pagesize_main
										}
									});
									gridWest.getStore().load({
										params : {
											start : 0,
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
		 }
		}, this);
	 	}
	 });
	 
	 
	 
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
