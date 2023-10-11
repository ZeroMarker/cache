/// 名称: 病症与诊断关联表维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-5-19
Ext.onReady(function(){
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCExtIcdFeild&pClassQuery=GetDataForCmb1";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseItmList";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassQuery=GetList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseItmList&pClassMethod=DeleteData";

var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
//全局变量
var selectrow=Ext.BDP.FunLib.getParam("selectrow");

/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						}, {
							name : 'ICDCode',
							mapping : 'ICDCode',
							type : 'string'
						}, {
							name : 'ICDDesc',
							mapping : 'ICDDesc',
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
					Ext.getCmp("textType").reset();
					gridWest.getStore().baseParams={};
					gridWest.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}
				});
				
		var btnSave = new Ext.Button({			
					xtype : 'button',
					text : '保存',
					iconCls : 'icon-save',
					//icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
					id:'btnSave',
	   				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSave'),
					handler : function SaveData() {
						var rs=gridWest.getSelectionModel().getSelections();
						if(rs.length==0){
							Ext.Msg.show({
								title : '提示',
								msg : '请选择需要保存的行!',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
						}else{
							var fieldStr = "";
							var PHDISLIType=Ext.getCmp("textType").getValue();
							var PHDISLISysFlag=Ext.getCmp("textFlag").getValue();
							if(PHDISLISysFlag==true){
						       		PHDISLISysFlag="Y"
						    }else{
						       	PHDISLISysFlag="N"
						    }

							Ext.each(rs,function(){
								if(fieldStr!="") fieldStr = fieldStr+",";
								var fieldDR=this.get('ICDRowId');//诊断id
								fieldStr = fieldStr+fieldDR;
							})
								Ext.Ajax.request({
									url : SAVE_ACTION_URL , 		
									method : 'POST',	
									params : {
											'PHDISLIICDDr' : fieldStr,
											'PHDISLIDisDr':selectrow,
											'PHDISLIType':PHDISLIType,
											'PHDISLISysFlag':PHDISLISysFlag
											
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
					},'-', btnSearch,'-',btnRefresh
				]
	});

		var tbt = new Ext.Toolbar({
		id : 'tbt',
		items : [
			'诊断类型',{
					xtype:'textfield',
					id:'textType',
					width:'100',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textType')
				},'-',
				'系统标识',{
					fieldLabel:'系统标识',
					xtype : 'checkbox',
					id:'textFlag',
					inputValue : true ? 'Y' : 'N',
					checked:true,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textFlag')
			},'->',
			btnSave
			]
	});
 

	/** 创建grid */
	var gridWest = new Ext.grid.GridPanel({
		id : 'gridWest',
		region : 'west',
		width:360,
		closable : true,
		store : dsWest,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'ICDRowId',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden : true
				}, {
					header : '诊断代码',
					sortable : true,
					dataIndex : 'ICDCode'
					//hidden : true
				}, {
					header : '诊断描述',
					sortable : true,
					dataIndex : 'ICDDesc'
				}],
		stripeRows : true,
		title:'诊断列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.RowSelectionModel({singleSelect:false}), // 按"Ctrl+鼠标左键"也只能单选
		sm : new Ext.grid.CheckboxSelectionModel,
		bbar : pagingWest,
		tbar:tb,
		stateId : 'gridWest',
		listeners:{
			'render':function(){
				tbt.render(this.tbar);
			}
		}
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
							name : 'PHDISLIRowId',
							mapping : 'PHDISLIRowId',
							type : 'string'
						},{
							name : 'PHDISLIDisDr',
							mapping : 'PHDISLIDisDr',
							type : 'string'
						},{
							name : 'ICDRowId',
							mapping : 'ICDRowId',
							type : 'string'
						},{
							name : 'PHDISLIICDDr',
							mapping : 'PHDISLIICDDr',
							type : 'string'
						},{
							name : 'PHDISLIType',
							mapping : 'PHDISLIType',
							type : 'string'
						}, {
							name : 'PHDISLISysFlag',
							mapping : 'PHDISLISysFlag',
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
					dataIndex : 'PHDISLIRowId',
					hidden : true
				},{
					header : '病症',
					sortable : true,
					dataIndex : 'PHDISLIDisDr'
				},{
					header : '诊断rowid',
					sortable : true,
					dataIndex : 'ICDRowId',
					hidden:true
				},{
					header : '诊断',
					sortable : true,
					dataIndex : 'PHDISLIICDDr'
				},{
					header : '诊断类型',
					sortable : true,
					dataIndex : 'PHDISLIType',
					editor:new Ext.form.TextField()
					//hidden : true
				},{
					header : '系统标识',
					sortable : true,
					dataIndex : 'PHDISLISysFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
					editor:new Ext.form.ComboBox({
						name : 'PHDISLISysFlag',
						hiddenName : 'PHDISLISysFlag',
						editable:false,
						allowBlank : false,
						width : 230,
						labelWidth:30,
						mode : 'local',
						triggerAction : 'all',// query
						valueField : 'value',
						displayField : 'name',
						store:new Ext.data.SimpleStore({
							fields:['value','name'],
							data:[
								      ['Y','Yes'],
								      ['N','No']
							     ]
						})
					})
				}],
		stripeRows : true,
		title : '已选列表',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingCenter,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter',
		listeners:{
			'afteredit':function(e){
				var record = e.record; //得到当前行所有数据
  				var PHDISLIRowId=record.get('PHDISLIRowId');
				var PHDISLIType=record.get('PHDISLIType');
				var PHDISLISysFlag=record.get('PHDISLISysFlag');
				var PHDISLIICDDr=record.get('ICDRowId');
				var PHDISLIDisDr=selectrow;
				Ext.Ajax.request({
					url : SAVE_ACTION_URL , 		
					method : 'POST',	
					params : {
							'PHDISLIRowId' : PHDISLIRowId,
							'PHDISLIType':PHDISLIType,
							'PHDISLISysFlag':PHDISLISysFlag,
							'PHDISLIICDDr':PHDISLIICDDr,
							'PHDISLIDisDr':PHDISLIDisDr							
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
		}

	});
	
	
	/**已选列表双击进行已选列表中删除操作*/
	 gridCenter.on("rowdblclick", function(grid, rowIndex, e){
		Ext.Ajax.request({
			url : DELETE_ACTION_URL,
			method : 'POST',
			params : {
				'id' : gridCenter.getSelectionModel().getSelected().get('PHDISLIRowId')//频率id
			},
			callback : function(options, success, response) {
				if (success) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
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
						if(gridCenter.getSelectionModel().getCount()!='0'){
							var id = gridCenter.getSelectionModel().getSelections()[0].get('PHDISLIRowId');
						}
						gridCenter.getStore().load({
							params : {
								'parref':selectrow,
								id: id,
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
	 });
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
