/// 名称: KPI指标条件配置
/// 描述: 包含KPI指标条件维护定义表和明细表的增删改查
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2015-3-5
Ext.onReady(function(){
Ext.QuickTips.init();
Ext.form.Field.prototype.msgTarget = 'side';
	
var QUERY_DEFINE_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.BaseKPIDefine&pClassQuery=GetList";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KPICondConfig&pClassQuery=GetTypeList";
var QUERY_CONFIG_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.KPICondConfig&pClassQuery=GetList";
var SAVE_CONFIG_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KPICondConfig&pClassMethod=SaveData&pEntityName=web.Entity.KB.KPICondConfig";
var DELETE_CONFIG_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.KPICondConfig&pClassMethod=DeleteData";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.KPICondConfig&pClassMethod=Save&pEntityName=web.Entity.KB.KPICondConfig";
var pagesize_westn = Ext.BDP.FunLib.PageSize.Main;
var pagesize_wests = Ext.BDP.FunLib.PageSize.Main;
var pagesize_center = Ext.BDP.FunLib.PageSize.Main;

/*********************************KPI指标条件定义表***********************************/
	/** grid数据存储 */
	var dsWestN = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_DEFINE_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'KPIRowId',
							mapping : 'KPIRowId', 
							type : 'string'
						}, {
							name : 'KPICode',
							mapping : 'KPICode',
							type : 'string'
						}, {
							name : 'KPIName',
							mapping : 'KPIName',
							type : 'string'
						}, {
							name : 'TableName',
							mapping : 'TableName',
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
			limit : pagesize_westn
		},
		callback : function(records, options, success) {
		}
	});
	/** grid分页工具条 */
	var pagingWestN = new Ext.PagingToolbar({
		pageSize : pagesize_westn,
		store : dsWestN,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_westn=this.pageSize;
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
							limit : pagesize_westn
						}
				});
			gridCenter.getStore().load({
				params : {
					tableName : '',
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					code : '',
					start : 0,
					limit : pagesize_wests
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
					limit : pagesize_westn
						}
			});
			gridCenter.getStore().load({
				params : {
					tableName : '',
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					code : '',
					start : 0,
					limit : pagesize_wests
				}
			});
		}
	});
	/**搜索工具条 */
	var tbWestN = new Ext.Toolbar({
		id : 'tbWestN',
		items : [
				'名称:', {
					xtype : 'textfield',
					id : 'textDesc',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('textDesc')
				}, '-', btnWestNSearch, '-', btnWestNRefresh, '->' // '-', btnAddwin, '-', btnEditwin, '-', btnDel,
		]
	});
	/** 创建grid */
	var gridWestN = new Ext.grid.EditorGridPanel({
		id : 'gridWestN',
		region : 'north',
		height:300,
		closable : true,
		store : dsWestN,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'KPIRowId',
					sortable : true,
					dataIndex : 'KPIRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'KPICode'
				}, {
					header : '名称',
					sortable : true,
					dataIndex : 'KPIName'
				}, {
					header : '数据来源',
					sortable : true,
					dataIndex : 'TableName'
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
	/**默认选中*/
	gridWestN.store.on("load",function(){  
		if(gridWestN.getStore().getCount()!=0){
	        gridWestN.getSelectionModel().selectRow(0,true);  
	        var tableName = gridWestN.getSelectionModel().getSelections()[0].get('TableName');
		 	var code = gridWestN.getSelectionModel().getSelections()[0].get('KPICode');
		 	gridCenter.getStore().load({
				params : {
					tableName : tableName,
					start : 0,
					limit : pagesize_center
				}
			});
			gridWestS.getStore().load({
				params : {
					code : code,
					start : 0,
					limit : pagesize_wests
				}
			});
		}
    }); 
	/*********************************KPI指标条件明细表***************************************/
	/** 明细grid数据存储 */
	var dsWestS = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_CONFIG_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'TypeRowID',
							mapping : 'TypeRowID',
							type : 'string'
						},{
							name : 'TypeName',
							mapping : 'TypeName',
							type : 'string'
						},{
							name : 'TableCode',
							mapping : 'TableCode',
							type : 'string'
						},{
							name : 'GroupTypeName',
							mapping : 'GroupTypeName',
							type : 'string'
						}, {
							name : 'ADMType',
							mapping : 'ADMType',
							type : 'string'
						},{
							name : 'Flag',
							mapping : 'Flag',
							type : 'string'
						}, {
							name : 'StartDate',
							mapping : 'StartDate',
							type : 'date',
							dateFormat : 'm/d/Y'
						}, {
							name : 'EndDate',
							mapping : 'EndDate',
							type : 'date',
							dateFormat : 'm/d/Y'
						},{
							name : 'Condition',
							mapping : 'Condition',
							type : 'string'
						},{
							name : 'SavedFlag',
							mapping : 'SavedFlag',
							type : 'string'
						},{
							name : 'KPIRowId',
							mapping : 'KPIRowId',
							type : 'string'
						}
				])
	});
	/** 明细grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWestS
	}); 
	/**加载分页参数**/
	dsWestS.on('beforeload',function(thiz,options){ 
		if(dsWestS.getCount()!='0'){
			if(gridWestN.getSelectionModel().getCount()!=0){
				Ext.apply(   
				  this.baseParams,   
				  {   
				     code:gridWestN.getSelectionModel().getSelections()[0].get('KPICode')
				  }   
				)
			}
		}
		
	});
	/** 明细grid加载数据 */
	dsWestS.load({
		params : {
			code : '',
			start : 0,
			limit : pagesize_wests
		},
		callback : function(records, options, success) {
		}
	});
	/** 明细grid分页工具条 */
	var pagingWestS = new Ext.PagingToolbar({
		pageSize : pagesize_wests,
		store : dsWestS,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_wests=this.pageSize;
			}
		}
	});
	/** 创建明细grid */
	var gridWestS = new Ext.grid.EditorGridPanel({
		id : 'gridWestS',
		region : 'center',
		closable : true,
		store : dsWestS,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列 
				{
					header : 'TypeRowID',
					sortable : true,
					dataIndex : 'TypeRowID',
					editor:new Ext.form.TextField()
				},{
					header : '数据来源名称',
					sortable : true,
					dataIndex : 'TypeName',
					editor:new Ext.form.TextField()
				},{
					header : '表编码',
					sortable : true,
					dataIndex : 'TableCode',
					editor:new Ext.form.TextField()
				},{
					header : '数据组名称',
					sortable : true,
					dataIndex : 'GroupTypeName',
					editor:new Ext.form.TextField()
				}, {
					header : '就诊类型',
					sortable : true,
					dataIndex : 'ADMType',
					renderer:function(value){
						if(value=="A"){return "全院"}
						if(value=="I"){return "住院"}
						if(value=="OE"){return "门急诊"}
						if(value=="O"){return "门诊"}
						if(value=="E"){return "急诊"}
						if(value=="H"){return "体检"}
						if(value=="N"){return "新生儿"}
						if(value=="S"){return "留观"}
					},
					editor:new Ext.form.ComboBox({
						name : 'ADMType',
						hiddenName : 'ADMType',
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
								      ['A','全院'],
								      ['I','住院'],
								      ['OE','门急诊'],
								      ['O','门诊'],
								      ['E','急诊'],
								      ['H','体检'],
								      ['N','新生儿'],
								      ['S','留观']
							     ]
						})
					})
				},{
					header : '有效标志',
					sortable : true,
					dataIndex : 'Flag',
					renderer:function(value){
						if(value=="Y"){return "Yes"}
						if(value=="N"){return "No"}
						if(value=="Un"){return "Unknown"}
					},
					editor:new Ext.form.ComboBox({
						name : 'Flag',
						hiddenName : 'Flag',
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
								      ['N','No'],
								      ['Un','Unknown']
							     ]
						})
					})
				}, {
					header : '开始日期',
					sortable : true,
					dataIndex : 'StartDate',
					renderer : Ext.util.Format.dateRenderer('Y/m/d'),
					editor:new Ext.form.DateField({format:'Y/m/d'})
				}, {
					header : '截止日期',
					sortable : true,
					dataIndex : 'EndDate',
					renderer : Ext.util.Format.dateRenderer('Y/m/d'),
					editor:new Ext.form.DateField({format:'Y/m/d'})
				},{
					header : 'Condition',
					sortable : true,
					dataIndex : 'Condition',
					editor:new Ext.form.TextField()
				},{
					header : '导入标志',
					sortable : true,
					dataIndex : 'SavedFlag',
					renderer:function(value){
						if(value=="Y"){return "Yes"}
						if(value=="N"){return "No"}
						if(value=="Un"){return "Unknown"}
					},
					editor:new Ext.form.ComboBox({
						name : 'SavedFlag',
						hiddenName : 'SavedFlag',
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
								      ['N','No'],
								      ['Un','Unknown']
							     ]
						})
					})
				}, {
					header : '操作',
					dataIndex : 'KPIRowId',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >删除</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="delBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : 'KPI指标条件明细',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingWestS,
		stateId : 'gridWestS',
		listeners:{
			'afteredit':function(e){
				var record = e.record; //得到当前行所有数据
       			//var v = e.value; //得到修改列修改后值
				var TypeRowID = record.get("TypeRowID");
				var TypeName = record.get("TypeName");
				var TableCode = record.get("TableCode");
				var GroupTypeName = record.get("GroupTypeName");
				var ADMType = record.get("ADMType");
				var Flag = record.get("Flag");
				var StartDate = record.get("StartDate");
				var EndDate = record.get("EndDate");
				var Condition = record.get("Condition");
				var SavedFlag = record.get("SavedFlag");
				if (TypeRowID=="") {
    				Ext.Msg.show({ title : '提示', msg : 'TypeRowID不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (TypeName=="") {
    				Ext.Msg.show({ title : '提示', msg : '数据来源名称不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
          			return;
    			}
    			if (StartDate != null && EndDate != null && StartDate != "" && EndDate != "") {
    				StartDate = StartDate.format("Ymd");
					EndDate = EndDate.format("Ymd");
        			if (StartDate > EndDate) {
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
                Ext.Ajax.request({
                   url: SAVE_ACTION_URL,
                   method: "POST",
                   params: {
                       id: record.get("KPIRowId"),
                       TypeRowID:TypeRowID,
                       TypeName:TypeName,
                       TableCode:TableCode,
                       GroupTypeName:GroupTypeName,
                       ADMType:ADMType,
                       Flag:Flag,
                       StartDate:StartDate,
                       EndDate:EndDate,
                       Condition:Condition,
                       SavedFlag:SavedFlag
                   },
                  callback : function(options, success, response) {	
                     if(success){
                       	var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								/*gridWestS.getStore().reload(); 
                 				gridWestS.getSelectionModel().selectRow(0,false);// 
                       			gridWestS.getView().focusCell(0,0); //选中的获取焦点 
*/								gridWestS.getStore().load({
									params : {
										code : gridWestN.getSelectionModel().getSelections()[0].get('KPICode'),
										start : 0,
										limit : pagesize_wests
										
									}
								})
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
		}
	});
	/**删除**/
	gridWestS.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.delBtn');
	 	if(btn){
	 		Ext.MessageBox.confirm('提示','确定删除此条数据吗?', function(button) {
	 		if(button=="yes"){
				var gsm = grid.getSelectionModel();// 获取选择列
				var rows = gsm.getSelections();// 根据选择列获取到所有的行	
				Ext.Ajax.request({
					url : DELETE_CONFIG_URL,
					method : 'POST',
					params : {
						'id' : rows[0].get('KPIRowId')
					},
					callback : function(options, success, response) {
						if (success) {
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								Ext.Msg.show({
									title : '提示',
									msg : '删除成功!',
									icon : Ext.Msg.INFO,
									buttons : Ext.Msg.OK,
									fn : function(btn) {
										var startIndex = gridWestS.getBottomToolbar().cursor;
										var totalnum=gridWestS.getStore().getTotalCount();
										if(totalnum==1){   //修改添加后只有一条，返回第一页
											var startIndex=0
										}
										else if((totalnum-1)%pagesize_wests==0)//最后一页只有一条
										{
											var pagenum=gridWestS.getStore().getCount();
											if (pagenum==1){ startIndex=startIndex-pagesize_wests;}  //最后一页的时候,不是最后一页则还停留在这一页
										}
										if(gridWestN.getSelectionModel().getCount()!='0'){
											var code = gridWestN.getSelectionModel().getSelections()[0].get('KPICode');
										}
										gridWestS.getStore().load({
											params : {
													code : code,
													start : startIndex,
													limit : pagesize_wests
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
		title:'KPI指标条件定义',
		region : 'west',
		width:880,
		split:true,
		collapsible:true,
		layout:'border',
		items:[gridWestN,gridWestS]
})
/**********************************Center KPI指标条件数据来源*************************************/
	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'TypeName',
							mapping : 'TypeName',
							type : 'string'
						},{
							name : 'TypeRowID',
							mapping : 'TypeRowID',
							type : 'string'
						}
				])
	});
	/** grid 数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsCenter
	});
	/**加载分页参数**/
	dsCenter.on('beforeload',function(thiz,options){ 
		if(gridWestN.getSelectionModel().getCount()!=0){
			Ext.apply(   
			  this.baseParams,   
			  {   
			     tableName:gridWestN.getSelectionModel().getSelections()[0].get('TableName')
			  }   
			)	
		}
		
	});
	/** grid 加载数据 */
	dsCenter.load({
		params : {
			start : 0,
			limit : pagesize_center
		},
		callback : function(records, options, success) {
		}
	});
	/** grid 分页工具条 */
	var pagingCenter = new Ext.PagingToolbar({
		pageSize : pagesize_center,
		store : dsCenter,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg : "没有记录",
		plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
		listeners : {
			"change":function (t,p) {
				pagesize_center=this.pageSize;
			}
		}
	});
		/**搜索按钮 */
	var btnCenterSearch = new Ext.Button({
		id : 'btnCenterSearch',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterSearch'),
		iconCls : 'icon-search',
		//text : '搜索',
		handler : function() {
			gridCenter.getStore().baseParams={	
					desc : Ext.getCmp("Desc").getValue()
			};
			gridCenter.getStore().load({
				params : {
							start : 0,
							limit : pagesize_center
						}
				});
		}
	});
	/**重置按钮 */
	var btnCenterRefresh = new Ext.Button({
		id : 'btnCenterRefresh',
		iconCls : 'icon-refresh',
		//text : '重置',
		disabled : Ext.BDP.FunLib.Component.DisableFlag('btnCenterRefresh'),
		handler : function() {
			Ext.getCmp("Desc").reset();
			gridCenter.getStore().baseParams={};
			gridCenter.getStore().load({
				params : {
					start : 0,
					limit : pagesize_center
						}
				});
		}
	});
	/**搜索工具条 */
	var tbCenter = new Ext.Toolbar({
		id : 'tbCenter',
		items : [
				'名称:', {
					xtype : 'textfield',
					id : 'Desc',
					width:130,
					disabled : Ext.BDP.FunLib.Component.DisableFlag('Desc')
				}, '-', btnCenterSearch, '-', btnCenterRefresh, '->'
		]
	});
	/** 创建grid */
	var gridCenter = new Ext.grid.EditorGridPanel({
		id : 'gridCenter',
		region : 'center',
		closable : true,
		store : dsCenter,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : '数据来源名称',
					sortable : true,
					dataIndex : 'TypeName',
					renderer:function(value){
						if(value==""){return "自定义添加->"}
						else{return value}
					}
				}, {
					header : '操作',
					dataIndex : 'TypeRowID',
					align:'center',
					renderer:function (){    
				    	var formatStr = '<a href="#" onclick="javascript:return false;" style="color:blue;" >添加</a>';   
         				var resultStr = String.format(formatStr);  
         				return '<div class="conBtn">' + resultStr + '</div>';  
				    }.createDelegate(this)
				}],
		stripeRows : true,
		title : 'KPI指标条件数据来源',
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		bbar : pagingCenter,
		tbar : tbCenter,
		tools:Ext.BDP.FunLib.Component.HelpMsg,
		stateId : 'gridCenter'
	});
	/**根据TableName查询数据来源；根据父定义表查询子明细表*/
	 gridWestN.on("rowclick", function(grid, rowIndex, e){
	 	var tableName = gridWestN.getSelectionModel().getSelections()[0].get('TableName');
	 	var code = gridWestN.getSelectionModel().getSelections()[0].get('KPICode');
	 	gridCenter.getStore().load({
			params : {
				tableName : tableName,
				start : 0,
				limit : pagesize_center
			}
		});
		gridWestS.getStore().load({
			params : {
				code : code,
				start : 0,
				limit : pagesize_wests
			}
		});
	 });
	/**添加明细**/
	 gridCenter.on('cellclick', function (grid, rowIndex, columnIndex, e) {  
	 	var btn = e.getTarget('.conBtn');
	 	if(btn){
		 	if(gridWestN.getSelectionModel().getCount()!=0){
		 		var KPICode = gridWestN.getSelectionModel().getSelections()[0].get('KPICode');
		 		var KPIDR = gridWestN.getSelectionModel().getSelections()[0].get('KPIRowId');
		 		var KPIName = gridWestN.getSelectionModel().getSelections()[0].get('KPIName');
		 		var TableName = gridWestN.getSelectionModel().getSelections()[0].get('TableName');
		 		var TypeRowID = gridCenter.getSelectionModel().getSelections()[0].get('TypeRowID');
		 		var TypeName = gridCenter.getSelectionModel().getSelections()[0].get('TypeName');
		    	var config = KPICode+"^"+KPIDR+"^"+KPIName+"^"+TableName+"^"+TypeRowID+"^"+TypeName;
			Ext.Ajax.request({
				url : SAVE_CONFIG_URL , 		
				method : 'POST',	
				params : {
						'config' : config
				},
				callback : function(options, success, response) {	
						if(success){
							var jsonData = Ext.util.JSON.decode(response.responseText);
							if (jsonData.success == 'true') {
								gridWestS.getStore().load({
									params : {
										code : gridWestN.getSelectionModel().getSelections()[0].get('KPICode'),
										start : 0,
										limit : pagesize_wests
										
									}
								})
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
					msg : '请先选择一条KPI指标条件定义!',
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
