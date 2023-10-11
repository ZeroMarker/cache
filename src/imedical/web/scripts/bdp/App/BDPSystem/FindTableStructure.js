	
	/// 名称:根据表名查询Global 
	/// 编写者:基础数据平台组 - 陈莹
	/// 编写日期:2014-8-11
	
Ext.onReady(function() {
	
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.FindTableStructure&pClassQuery=SelectMaster";
	var ACTION_URL1 = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.FindTableStructure&pClassQuery=SelectProperty";
	var pagesize = Ext.BDP.FunLib.PageSize.Main;
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  
	
	//查询data及index
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'type',
								mapping : 'type',
								type : 'string'
							}, {
								name : 'indexName',
								mapping : 'indexName',
								type : 'string'
							}, {
								name : 'indexMasterData',
								mapping : 'indexMasterData',
								type : 'string'
							}
						])
				//remoteSort : true
				//sortInfo: {field : "CMCBMRowId",direction : "ASC"}
	});
	//ds.sort("CMCBMCode","DESC");
			
 	// 加载数据
	ds.load({
				params : { start : 0},
				callback : function(records, options, success) {
				}
	}); 			
			
	
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	
	// 搜索工具条
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				tooltip : '搜索',
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
				grid.getStore().baseParams={
						packageName : Ext.getCmp("TextCode").getValue(),
						
						className : Ext.getCmp("TextDesc").getValue()
						
				};
				grid.getStore().load({
					params : {
						start : 0
					}
				});
				
			},
			listeners : {
			"click" : function() {
				
				grid1.getStore().baseParams={
						packageName : Ext.getCmp("TextCode").getValue(),
						
						className : Ext.getCmp("TextDesc").getValue()
						
				};
				grid1.getStore().load({
					params : {
						start : 0
						, limit : pagesize 
					}
				});
			}
		}
	});
	
	var loadTwoGrid=function() {
				grid.getStore().baseParams={
						packageName : Ext.getCmp("TextCode").getValue(),
						
						className : Ext.getCmp("TextDesc").getValue()
						
				};
				grid.getStore().load({
					params : {
						start : 0
					}
				});
				
				grid1.getStore().baseParams={
						packageName : Ext.getCmp("TextCode").getValue(),
						
						className : Ext.getCmp("TextDesc").getValue()
						
				};
				grid1.getStore().load({
					params : {
						start : 0
						, limit : pagesize 
					}
				});
			}

	
	
	// 将工具条放到一起
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['Package Name:', {xtype : 'textfield',id : 'TextCode',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
				
				},'-',
						'Table Name:', {xtype : 'textfield',id : 'TextDesc',disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')},'-', 
						btnSearch,'-', '->'
					]
	});
	

	// 创建Grid
	var grid = new Ext.grid.GridPanel({
				title : 'Table Index Structure',
				id : 'grid',
				region : 'center',
				maxheight: 600,
				height : 800,
				closable : true,
				store : ds,
				trackMouseOver : true,
				columns :[sm, {
							header : 'type',
							width : 20,
							sortable : true,
							dataIndex : 'type'
						}, {
							header : 'indexName',
							width : 40,
							sortable : true,
							dataIndex : 'indexName'
						}, {
							header : 'indexMasterData',
							width : 160,
							sortable : true,
							dataIndex : 'indexMasterData'
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
				//bbar : paging,
				tbar : tb,
				stateId : 'grid'
	});
	
	
	///查询data中各属性名称，存放位置，分隔符等信息
	var ds1 = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({url : ACTION_URL1}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						},[{
								name : 'propertyName',
								mapping : 'propertyName',
								type : 'string'
							}, {
								name : 'propertyNode',
								mapping : 'propertyNode',
								type : 'string'
							}, {
								name : 'propertyDeli',
								mapping : 'propertyDeli',
								type : 'string'
							}, {
								name : 'propertyPiece',
								mapping : 'propertyPiece',
								type : 'string'
							}, {
								name : 'propertyType',
								mapping : 'propertyType',
								type : 'string'
							}, {
								name : 'propertyField',
								mapping : 'propertyField',
								type : 'string'
							
							}, {
								name : 'propertyColumn',
								mapping : 'propertyColumn',
								type : 'string'
							}
						])
				//remoteSort : true
				//sortInfo: {field : "CMCBMRowId",direction : "ASC"}
	});
	//ds.sort("CMCBMCode","DESC");
			
 	// 加载数据
	ds1.load({
				params : { start : 0},
				callback : function(records, options, success) {
				}
	}); 			
			
	
	var sm1 = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
	});

	
	
		
	
	// 分页工具条
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize,
				
				store : ds1,
				displayInfo : true,
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录"
	});
	///propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn
	
	// 创建Grid
	var grid1 = new Ext.grid.GridPanel({
				title : 'Index Info',
				id : 'grid1',
				region : 'south',
				height : 400,
				maxheight: 300,
				closable : true,
				store : ds1,
				trackMouseOver : true,
				columns :[sm, {
							header : 'propertyName',
							width : 80,
							sortable : true,
							dataIndex : 'propertyName'
						}, {
							header : 'propertyNode',
							width : 80,
							sortable : true,
							dataIndex : 'propertyNode'
						}, {
							header : 'propertyDeli',
							width : 80,
							sortable : true,
							dataIndex : 'propertyDeli'
						}, {
							header : 'propertyPiece',
							width : 80,
							sortable : true,
							dataIndex : 'propertyPiece'
						}, {
							header : 'propertyType',
							width : 80,
							sortable : true,
							dataIndex : 'propertyType'
						}, {
							header : 'propertyField',
							width : 80,
							sortable : true,
							dataIndex : 'propertyField'
						}, {
							header : 'propertyColumn',
							width : 80,
							sortable : true,
							dataIndex : 'propertyColumn'
						
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
				bbar : paging,
				//tbar : tb1,
				stateId : 'grid1'
	});
	// 增加修改的Form
	var Win= new Ext.FormPanel({
				id : 'Win',
				title:'查询表结构',
				//baseCls : 'x-plain',//form透明,不显示框框
				split : true,
				layout : 'border',
				items : [grid,grid1]
	})
	

    
	Ext.BDP.FunLib.Component.KeyMap = function(loadTwoGrid){
	
       var keymap = new Ext.KeyMap(document, 
			[{
			    key:Ext.EventObject.ENTER, /**按钮转换功能，将enter键转换为tab键。当为button时不进行按键的转换**/
			    shift:true,
			    fn:loadTwoGrid
			
			}]
	   );
       return keymap;
    
	}
	// 创建viewport
	var viewport = new Ext.Viewport({
				layout : 'fit',
				items : [Win]
	});

});
