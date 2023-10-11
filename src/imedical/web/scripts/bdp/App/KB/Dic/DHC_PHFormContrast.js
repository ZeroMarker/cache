﻿/// 名称: 剂型对照
/// 描述: 包含剂型表与his剂型表对照功能，与已对照剂型删除功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-11-4
Ext.onReady(function(){
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtForm&pClassQuery=GetList";
var QUERY_HIS_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.Arcim&pClassQuery=GetDataForCmbForm1";
var QUERY_CONTRAST_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHFormContrast&pClassQuery=GetList";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHFormContrast&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHFormContrast";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHFormContrast&pClassMethod=DeleteData";
var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

	/** ****************************清空已对照数据 *************************/
	function clearSubWin() {
			gridWestS.getStore().removeAll()
			document.getElementById('ext-comp-1030').innerHTML="没有记录",
			document.getElementById('ext-comp-1026').innerHTML="页,共 1 页",
			document.getElementById('ext-comp-1025').value="1"
	}
/**********************************剂型表***********************************/
	/** grid数据存储 */
	var dsWestN = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHEFRowId',
							mapping : 'PHEFRowId',
							type : 'string'
						}, {
							name : 'PHEFCode',
							mapping : 'PHEFCode',
							type : 'string'
						}, {
							name : 'PHEFDesc',
							mapping : 'PHEFDesc',
							type : 'string'
						}, {
							name : 'PHEFActiveFlag',
							mapping : 'PHEFActiveFlag',
							type : 'string'
						}, {
							name : 'PHEFSysFlag',
							mapping : 'PHEFSysFlag',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestN
	});
	/** grid加载数据 */
	dsWestN.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWestN = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWestN,
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
	/**搜索按钮 */
	var btnWestNSearch = new Ext.Button({
		id : 'btnWestNSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridWestN.getStore().baseParams={			
					desc : Ext.getCmp("textDesc").getValue()
			};
			gridWestN.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
				});
		}
	});
	/**重置按钮 */
	var btnWestNRefresh = new Ext.Button({
		id : 'btnWestNRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnWestNRefresh'),
		handler : function() {
			Ext.getCmp("textDesc").reset();
			gridWestN.getStore().baseParams={};
			gridWestN.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
						}
				});
			clearSubWin()
		}
	});
	/**搜索工具条 */
	var tbWestN = new Ext.Toolbar({
		id : 'tbWestN',
		items : [
				'描述', {
					xtype : 'textfield',
					id : 'textDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
				}, '-', btnWestNSearch, '-', btnWestNRefresh, '->'
		]
	});
	/** 创建grid */
	var gridWestN = new Ext.grid.GridPanel({
		id : 'gridWestN',
		region : 'north',
		height:300,
		closable : true,
		store : dsWestN,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'PHEFRowId',
					sortable : true,
					dataIndex : 'PHEFRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'PHEFCode'
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'PHEFDesc'
				}, {
					header : '启用',
					sortable : true,
					dataIndex : 'PHEFActiveFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
				}, {
					header : '系统标识',
					sortable : true,
					dataIndex : 'PHEFSysFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon
				}],
		stripeRows : true,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestN,
		tbar : tbWestN,
		stateId : 'gridWestN'
	});
	/*********************************已对照表***************************************/
	/** 已对照grid数据存储 */
	var dsWestS = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CONTRAST_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHFCTFormCode',
							mapping : 'PHFCTFormCode',
							type : 'string'
						}, {
							name : 'PHFCTFormDesc',
							mapping : 'PHFCTFormDesc',
							type : 'string'
						}, {
							name : 'PHFCTHisFormCode',
							mapping : 'PHFCTHisFormCode',
							type : 'string'
						}, {
							name : 'PHFCTHisFormDesc',
							mapping : 'PHFCTHisFormDesc',
							type : 'string'
						},{
							name : 'PHFCTRowId',
							mapping : 'PHFCTRowId',
							type : 'string'
						}
				])
	});
	/** 已对照grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestS
	}); 
	/**加载分页参数**/
	dsWestS.on('beforeload',function(){ 
		if(dsWestS.getCount()!='0'){
			if(gridWestN.getSelectionModel().getCount()!='0'){
				Ext.apply(this.baseParams,{id:gridWestN.getSelectionModel().getSelections()[0].get('PHEFRowId')})
			}
		}
		
	});  
  
	/** 已对照grid加载数据 */
	dsWestS.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** 已对照grid分页工具条 */
	var pagingWestS = new Ext.PagingToolbar({
		pageSize : pagesize_main,
		store : dsWestS,
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
	/** 创建已对照grid */
	var gridWestS = new Ext.grid.GridPanel({
		id : 'gridWestS',
		region : 'center',
		closable : true,
		store : dsWestS,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : '代码',
					sortable : true,
					dataIndex : 'PHFCTFormCode'
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'PHFCTFormDesc'
				}, {
					header : 'his代码',
					sortable : true,
					dataIndex : 'PHFCTHisFormCode'
				}, {
					header : 'his描述',
					sortable : true,
					dataIndex : 'PHFCTHisFormDesc'
				}, {
					header : '操作',
					dataIndex : 'PHFCTRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : '已对照剂型',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestS,
		stateId : 'gridWestS'
	});
	/**根据对照查询已对照*/
	 gridWestN.on("rowclick", function(grid, rowIndex, e){
	 	var id = gridWestN.getSelectionModel().getSelections()[0].get('PHEFRowId');
	 	gridWestS.getStore().load({
			params : {
				id : id,
				start : 0,
				limit : pagesize_main
			}
		});
	 });
	/**删除**/
	gridWestS.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		
	 		Ext.MessageBox.confirm('提示','确定撤销此条对照吗?', function(button) {
	 		if(button=="yes"){
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行	
				var id= rows[0].get('PHFCTRowId');
				Ext.Ajax.request({
					url : DELETE_ACTION_URL,
					method : 'POST',
					params : {
						'id' : id
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '对照撤销成功!',
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
										if(gridWestN.getSelectionModel().getCount()!='0'){
											var id = gridWestN.getSelectionModel().getSelections()[0].get('PHEFRowId');
										}	
										grid.getStore().load({
											params : {
													id : id,
													start : startIndex,
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
	 		}
	});
/************************************West***********************************************/
var gridWest = new Ext.Panel({
		id : 'gridWest',
		title:'剂型对照',
		region : 'west',
		width:550,
		split:true,
		collapsible:true,
		layout:'border',
		items:[gridWestN,gridWestS]
})
/**********************************Center his剂型表*************************************/
	/** grid his数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_HIS_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [ {
							name : 'PHCFCode',
							mapping : 'PHCFCode',
							type : 'string'
						}, {
							name : 'PHCFDesc',
							mapping : 'PHCFDesc',
							type : 'string'
						},{
							name : 'PHCFRowId',
							mapping : 'PHCFRowId',
							type : 'string'
						}
				])
	});
	/** grid his数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsCenter
	});
	/** grid his加载数据 */
	dsCenter.load({
		params : {
			start : 0,
			limit : pagesize_main
		},
		callback : function(records, options, success) {
		}
	});
	/** grid his分页工具条 */
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
	/**his搜索按钮 */
	var btnCenterSearch = new Ext.Button({
		id : 'btnCenterSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterSearch'),
		iconCls : 'icon-search',
		text : '搜索',
		handler : function() {
			gridCenter.getStore().baseParams={			
					desc : Ext.getCmp("textHisDesc").getValue()
			};
			gridCenter.getStore().load({
				params : {
							start : 0,
							limit : pagesize_main
						}
				});
		}
	});
	/**his重置按钮 */
	var btnCenterRefresh = new Ext.Button({
		id : 'btnCenterRefresh',
		iconCls : 'icon-refresh',
		text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterRefresh'),
		handler : function() {
			Ext.getCmp("textHisDesc").reset();
			gridCenter.getStore().baseParams={};
			gridCenter.getStore().load({
				params : {
					start : 0,
					limit : pagesize_main
						}
				});
		}
	});
	/**his搜索工具条 */
	var tbCenter = new Ext.Toolbar({
		id : 'tbCenter',
		items : [
				'描述', {
					xtype : 'textfield',
					id : 'textHisDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textHisDesc')
				}, '-', btnCenterSearch, '-', btnCenterRefresh, '->'
		]
	});
	/** 创建hisgrid */
	var gridCenter = new Ext.grid.GridPanel({
		id : 'gridCenter',
		region : 'center',
		closable : true,
		store : dsCenter,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : '代码',
					sortable : true,
					dataIndex : 'PHCFCode'
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'PHCFDesc'
				}, {
					header : '操作',
					dataIndex : 'PHCFRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >对照</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="conBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : 'his剂型',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingCenter,
		tbar : tbCenter,
		//tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter'
	});
	/**对照**/
	 gridCenter.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.conBtn');
	 	if(btn){
		 	if(gridWestN.getSelectionModel().getCount()!=0){
		 		var rowid = gridWestN.getSelectionModel().getSelections()[0].get('PHEFRowId');
		 		var hisrowid = gridCenter.getSelectionModel().getSelections()[0].get('PHCFRowId');
		    	var ids=rowid+"^"+hisrowid;
		    
				Ext.Ajax.request({
				url : SAVE_ACTION_URL , 		
				method : 'POST',	
				params : {
						'ids' : ids
				},
				callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								gridWestS.getStore().load({
									params : {
										id : rowid,
										start : 0,
										limit : pagesize_main
										
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
			}else{
		 		Ext.Msg.show({
					title : '提示',
					msg : '请先选择一条剂型对照!',
					icon : Ext.Msg.INFO,
					buttons : Ext.Msg.OK
	    		})
		 	}	
		 }	
	 });

	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
