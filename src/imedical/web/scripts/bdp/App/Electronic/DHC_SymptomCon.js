/// 名称: 病症分级关联字典维护
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2016-5-19
Ext.onReady(function(){
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomFeild&pClassQuery=GetDataForCmb1";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomCon&pClassMethod=SaveData";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomCon&pClassQuery=GetList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomCon&pClassMethod=DeleteData";
var ORDER_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCSymptomCon&pClassMethod=SaveOrder";

var pagesize_main = Ext.BDP.FunLib.PageSize.Main;

//全局变量
var selectNode=Ext.BDP.FunLib.getParam("selectNode");

/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'SYFRowId',
							mapping : 'SYFRowId',
							type : 'string'
						}, {
							name : 'SYFCode',
							mapping : 'SYFCode',
							type : 'string'
						}, {
							name : 'SYFDesc',
							mapping : 'SYFDesc',
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
				//text : '搜索',
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
				//text : '重置',
				handler : function() {
					Ext.getCmp("TextDesc").reset();
					gridWest.getStore().baseParams={};
					gridWest.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}
				});

	var tb = new Ext.Toolbar({
		id : 'tb',
		items : [
				btnSearch, '-',
				 {
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
					},'-', 
					 
					btnRefresh,'-',
					{
					xtype : 'button',
					text : '保存',
					iconCls : 'icon-save',
					icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
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
							Ext.each(rs,function(){
								if(fieldStr!="") fieldStr = fieldStr+"^";
								var fieldDR=this.get('SYFRowId');//症状id
								fieldStr = fieldStr+fieldDR;
							})
								Ext.Ajax.request({
									url : SAVE_ACTION_URL , 		
									method : 'POST',	
									params : {
											'fieldStr' : fieldStr,
											'levDr':selectNode
									},
									callback : function(options, success, response) {	
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.info == '已经保存') {
												Ext.Msg.show({
													title : '提示',
													msg : '该症状已经存在!',
													icon : Ext.Msg.WARNING,
													buttons : Ext.Msg.OK
												});
											}
											if (jsonData.success == 'true') {
												
												//var DescLeft=gridWest.getSelectionModel().getSelections()[0].get('SYFDesc');
												//var DescRight=gridCenter.getSelectionModel().getSelections()[0].get('SYCFieldDr');
												//alert("left:"+DescLeft+"right:"+DescRight)
												
												
												var myrowid = jsonData.id;
												gridCenter.getStore().load({
													params : {
														'lev':selectNode,
														start : 0,
														limit : pagesize_main
													}
												});
												gridWest.getStore().load({
													params : {
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
								});
					
						}
					},
					scope : this
				}]
	});


	/** 创建grid */
	var gridWest = new Ext.grid.GridPanel({
		id : 'gridWest',
		region : 'west',
		width:320,
		closable : true,
		store : dsWest,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'SYFRowId',
					sortable : true,
					dataIndex : 'SYFRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'SYFCode',
					hidden : true
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'SYFDesc'
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
							name : 'SYCRowId',
							mapping : 'SYCRowId',
							type : 'string'
						},{
							name : 'SYCLevDr',
							mapping : 'SYCLevDr',
							type : 'string'
						},{
							name : 'SYCFieldDr',
							mapping : 'SYCFieldDr',
							type : 'string'
						},{
							name : 'SYCSequence',
							mapping : 'SYCSequence',
							type : 'string'
						}
				]),
				sortInfo: {field: 'SYCSequence', direction: 'asc'}
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
		    'lev':selectNode
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
					dataIndex : 'SYCRowId',
					hidden : true
				},{
					header : '症状分级',
					sortable : true,
					dataIndex : 'SYCLevDr'
				},{
					header : '症状',
					sortable : true,
					dataIndex : 'SYCFieldDr'
				},{
					header : '顺序',
					sortable : true,
					dataIndex : 'SYCSequence',
					hidden : true
				},{
		           	header:"上移/下移",
					dataIndex : 'PINLRowID',
		            width:50,
		            renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
		            			var formatStr1 = '<img src="../scripts/bdp/Framework/imgs/up.gif" onclick="javascript:return false;" class="upBtn" ></img>';   
		         				var resultStr1 = String.format(formatStr1); 
		         				var formatStr2 = '<img src="../scripts/bdp/Framework/imgs/down.gif" onclick="javascript:return false;" class="downBtn" ></img>';   
		         				var resultStr2 = String.format(formatStr2);
		         				if(rowIndex==0){
		         					value ='<div>'+resultStr2+'</div>';
		         				}
		         				else if(rowIndex==gridCenter.store.getCount()-1){
		         					value ='<div>'+resultStr1+'</div>';
		         				}
		         				else{
		         					value='<div>' + resultStr1 +" / " +resultStr2+'</div>';
		         				}
		         				if(gridCenter.store.getCount()==1){
		         					value=""
		         				}	
		         				return value	            	
		            }.createDelegate(this)
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
		stateId : 'gridCenter'

	});
	
	/**已选列表上移或下移操作**/
	gridCenter.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
		var upbtn = e.getTarget('.upBtn');
		var downbtn = e.getTarget('.downBtn');
		if(upbtn){
		 var record = grid.getSelectionModel().getSelected();	
	        if (record) {
	            var index = grid.store.indexOf(record); 

	            if (index > 0) {
	            	var checkId=record.get('SYCRowId')
	            	var upId=grid.getStore().getAt(index-1).get('SYCRowId')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':upId
								},
							callback:function(options,success,response){
									if(success){	
						             grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
									 setTimeout(function(){
									        grid.selModel.selectRows([0,index-1]);
									 },300); 
						  			}
								}
					})	
	               
	            }

	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
		if(downbtn){
			 var record = grid.getSelectionModel().getSelected();
	        if (record) {
	            var index = grid.store.indexOf(record);
	            if (index < grid.store.getCount() - 1) {
	            	var checkId=record.get('SYCRowId')
	            	var downId=grid.getStore().getAt(index+1).get('SYCRowId')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':downId
								},
							callback:function(options,success,response){
									if(success){
										grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
										setTimeout(function(){
									        grid.selModel.selectRows([0,index+1]);
										 },300);
						  			}
								}
					})
					             
	            }
	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
	});
	
	/**已选列表双击进行已选列表中删除操作*/
	 gridCenter.on("rowdblclick", function(grid, rowIndex, e){
		Ext.Ajax.request({
			url : DELETE_ACTION_URL,
			method : 'POST',
			params : {
				'id' : gridCenter.getSelectionModel().getSelected().get('SYCRowId')//频率id
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
							var id = gridCenter.getSelectionModel().getSelections()[0].get('SYCRowId');
						}
						gridCenter.getStore().load({
							params : {
								'lev':selectNode,
								id : id,
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
