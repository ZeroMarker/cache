/// 名称: 码表数据日志管理
/// 编写者: 基础数据平台组  sunfengchao  
/// 编写日期: 2016-6-22
document.write('<style> .x-grid3-cell-inner {white-space:normal; !important;} </style>'); //内容长的时候换行
Ext.onReady(function() {
	Ext.QuickTips.init();
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var QUERY_METHOD_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSysErrorLog&pClassMethod=GetList";
	/*************************************grid数据存储 *****************************************/
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : QUERY_METHOD_URL 
						}),  		
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'BDPERRowId',
									mapping : 'BDPERRowId',
									type : 'string'
								}, {
									name : 'BDPERDate',
									mapping : 'BDPERDate',
									type : 'date' 
								}, {
									name : 'BDPERTime',
									mapping : 'BDPERTime',
									type : 'string'
								}, {
									name : 'BDPERApp',
									mapping : 'BDPERApp',
									type : 'string'
								}, {
									name : 'BDPERModule',
									mapping : 'BDPERModule',
									type : 'string'
								}, {
									name : 'BDPERErrInfo',
									mapping : 'BDPERErrInfo',
									type : 'string'
								}, {
									name : 'BDPERKeyValue',
									mapping : 'BDPERKeyValue',
									type : 'string'
								}, {
									name : 'BDPERIPAddress',
									mapping : 'BDPERIPAddress',
									type : 'string'
								}, {
									name : 'BDPERSSUSRDR',
									mapping : 'BDPERSSUSRDR',
									type : 'string'
								}, {
									name : 'BDPBrowserInfo',
									mapping : 'BDPBrowserInfo',
									type : 'string'
								} ,{
									name:'BDPERClassInfo',
									mapping:'BDPERClassInfo',
									type:'string'
								}
						])
			});
 
	/***************************************grid加载数据 ********************************/
	ds.load({
		params : {	
                    datefrom:'',
                    dateto:'',
					start : 0,
					limit : pagesize_main
				} 
		});
	/****************************************grid分页工具条******************************/
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
/** ****************************************搜索按钮 ********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler :search=function() {
					grid.getStore().baseParams={
							datefrom  : Ext.getCmp("datefrom").getValue()===""?"":Ext.getCmp("datefrom").getValue().format(BDPDateFormat),
							dateto  : Ext.getCmp("dateto").getValue()===""?"":Ext.getCmp("dateto").getValue().format(BDPDateFormat)
					};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	
	/** ************************************重置按钮 ********************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : refresh=function() { 
					Ext.getCmp("datefrom").reset();
					Ext.getCmp("dateto").reset();
				 	str="";
					grid.getStore().baseParams={};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main
								}
							});
					}
			});
	
	/// 查看数据详情 
	var datadetailbtn=new Ext.Button({
			id:'LookUpDataDetail',
			disabled:Ext.BDP.FunLib.Component.DisableFlag('LookUpDataDetail'),
			text:'查看数据详情' ,
			iconCls : 'icon-DP',
			handler:function()
			{
				var gsm = grid.getSelectionModel(); 
				var rows = gsm.getSelections(); 
				if(rows.length>0)
				{
						
						var height=Math.min(Ext.getBody().getViewSize().height-350,790);	
						var Log_Win = new Ext.Window
						({
									title:'',
									width :1100,
									height :height,
									layout : 'fit',
								 	plain : true, 
								 	modal : true,
								 	frame : true,
									// autoScroll : true,
								 	constrain : true,
									closeAction : 'hide'  
							});
							var url="dhc.bdp.bdp.errorlog.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('BDPERRowId'); 
							if ('undefined'!==typeof websys_getMWToken)
							{
								url += "&MWToken="+websys_getMWToken() //增加token
							}  	 
							var url=encodeURI(url)
						 	Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
						 	Log_Win.show();
				}
				else{
					Ext.Msg.show({
							title:'提示',
							minWidth:280,
							msg:'请选择需要查看的数据行!',
							icon:Ext.Msg.WARNING,
							buttons:Ext.Msg.OK
						});	
					}
				}
			});
	
			
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [ 
						 '开始日期', {
							width : 100,
							xtype : 'datefield',
							id : 'datefrom',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('datefrom'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
						},
						'结束日期', {
							width : 100,
							xtype : 'datefield',
							id : 'dateto',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('dateto'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
						} ,   '-',btnSearch, '-', btnRefresh,'-',datadetailbtn 
				] 
			});
	
	 
	/** ***********************************创建grid ****************************************/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				trackMouseOver : true,
				trackMouseOver : true,
				columnLines : true,
				store : ds,
				stripeRows : true,
				stateful : true,
				viewConfig : {
					forceFit: true,  
					scrollOffset: 0 , 
					emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
    				autoFill:true,
    				enableRowBody: true  
				},
				sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
				columns : [new Ext.grid.CheckboxSelectionModel(),  
						 {
							header : 'BDPERRowId',
							sortable : true,
							dataIndex : 'BDPERRowId',
							width : 20,
							hidden : true
						},{
							header : '日志生成日期',
							sortable : true,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'BDPERDate',
							width:65
						},{
							header : '日志生成时间',
							sortable : true,
							dataIndex : 'BDPERTime',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 60
						}, {
							header : '错误发生模块',
							sortable : true,
							dataIndex : 'BDPERApp',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width :60
						},{
							header:'发生错误的类',
							sortable:true,
							dataIndex:'BDPERClassInfo',
							width:60,
							rendeerer:Ext.BDP.FunLib.Component.GridTipShow
						},{
							header : '产生错误的代码块',
							sortable : true,
							width:70,
							dataIndex : 'BDPERModule'
						}, {
							header : '错误描述 ',
							sortable : true,
							dataIndex : 'BDPERErrInfo',
							width:55
						}, {
							header : '产生错误的数据',
							sortable : true,
							dataIndex : 'BDPERKeyValue',
							width : 40 
						} , {
							header : '操作人IP',
							sortable : true,
							dataIndex : 'BDPERIPAddress',
							width : 60
						},  {
							header : '操作人',
							sortable : true,
							width:35,
							dataIndex : 'BDPERSSUSRDR'
						} , {
							header : '浏览器信息',
							sortable : true,
							dataIndex : 'BDPBrowserInfo',
							width:65
						}],
				title : '错误日志管理',
				monitorResize: true,
				doLayout: function() {
					this.setSize(Ext.get(this.getEl().dom.parentNode).getSize(true));
					Ext.grid.GridPanel.prototype.doLayout.call(this);
			   },
			    tools:Ext.BDP.FunLib.Component.HelpMsg,
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
 grid.on("rowdblclick", function(grid, rowIndex, e){
 		var gsm = grid.getSelectionModel(); 
		var rows = gsm.getSelections(); 
		if(rows.length>0)
		{ 
				var Log_Win = new Ext.Window
				({
							title:'',
							width :990,
							height :400,
							layout : 'fit',
						 	plain : true, 
						 	modal : true,
						 	frame : true,
							// autoScroll : true,
						 	constrain : true,
							closeAction : 'hide'  
					});
					var url="dhc.bdp.bdp.errorlog.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('BDPERRowId');  
					if ('undefined'!==typeof websys_getMWToken)
					{
						url += "&MWToken="+websys_getMWToken() //增加token
					}  	 
					var url=encodeURI(url)
				 	Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
				 	Log_Win.show();
		}
		else{
			Ext.Msg.show({
					title:'提示',
					minWidth:280,
					msg:'请选择需要查看的数据行!',
					icon:Ext.Msg.WARNING,
					buttons:Ext.Msg.OK
				});	
			}
 });	
Ext.BDP.FunLib.Component.KeyMap(); 
Ext.BDP.FunLib.ShowUserHabit(grid,"User.BDPDataChangeLog");
/***********************************定义viewport容器*******************************/
var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid]
	});
});