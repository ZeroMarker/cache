/// 名称: 码表数据日志审计
/// 编写者: 基础数据平台组-陈莹
/// 编写日期: 2014-1-5

document.write('<style> .x-grid3-cell-inner {white-space:normal !important;} </style>'); //内容长的时候换行
Ext.onReady(function() {
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip'; 
  	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var QUERY_ACTION_URL ="../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataAudit&pClassMethod=GetList";
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataAudit&pClassQuery=GetList";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataAudit&pClassMethod=DeleteData";
	var AuditN_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataAudit&pClassMethod=AuditN";
	var AuditA_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataAudit&pClassMethod=AuditA";
	var datestr=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
	var DateArr=[];
	DateArr=datestr.split("^");
	var StartDate=DateArr[0]; 
	var EndDate= DateArr[1]; //7天前的日期 

	Ext.BDP.FunLib.Component.ReturnAuditIcon = function(value)
	{
  	if(value=='A')  //异常
  		{
			return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"error.png' style='border: 0px'";
  		}
  	else if(value=='N') //正常
  		{
			return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"accept.png' style='border: 0px'";
		}
    else 
 	 	{
			return "";
		}
	}
	
	//审计按钮
	var btnAuditN = new Ext.Toolbar.Button({
					id:'AuditN_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('AuditN_btn'),
					text : '审计为正常',
					tooltip : '审计为正常',
					iconCls : 'icon-accept',
					handler :  AuditNF= function (){
						if (grid.selModel.hasSelection()) {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						var str="";
						for(var i=0;i<rows.length;i++){
							if(str==""){
								str += rows[i].get('ID');
							}else{
								str += "^" + rows[i].get('ID');
							}
						}
						Ext.Ajax.request({
										url : AuditN_URL,
										method : 'POST',
										params : {
											'IDstr' : str
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
															var startIndex = grid.getBottomToolbar().cursor;
															grid.getStore().load({
																		params : {
																			start : startIndex,
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
																msg : '数据审计失败!' + errorMsg,
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
						else
						{
							
							Ext.Msg.show({
							title : '提示',
							msg : '请选择需要审计的数据！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
						}
									
					}
	});
	//审计按钮 ，异常
	var btnAuditA = new Ext.Toolbar.Button({
					id:'AuditA_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('AuditA_btn'),
					text : '审计为异常',
					tooltip : '审计为异常',
					iconCls : 'icon-error',
					handler :  AuditAF= function (){
					if (grid.selModel.hasSelection()) {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						var str="";
						for(var i=0;i<rows.length;i++){
							if(str==""){
								str += rows[i].get('ID');
							}else{
								str += "^" + rows[i].get('ID');
							}
						}
						Ext.Ajax.request({
										url : AuditA_URL,
										method : 'POST',
										params : {
											'IDstr' : str
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													
														var startIndex = grid.getBottomToolbar().cursor;
															grid.getStore().load({
																		params : {
																			start : startIndex,
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
																msg : '数据审计失败!' + errorMsg,
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
						else
						{
							
							Ext.Msg.show({
							title : '提示',
							msg : '请选择需要审计的数据！',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
						}
					}
	});
	
	/************************************* 删除按钮 ***********************************/
	var btnDel = new Ext.Toolbar.Button({
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					text : '删除',
					tooltip : '可同时删除多条',
					iconCls : 'icon-delete',
					handler : function DelData() {
						var gsm = grid.getSelectionModel();// 获取选择列
						var rows = gsm.getSelections();// 根据选择列获取到所有的行
						var str="";
						for(var i=0;i<rows.length;i++){
							if(str==""){
								str += rows[i].get('ID');
							}else{
								str += "^" + rows[i].get('ID');
							}
						}
						if (str!=="") {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'str' : str
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
															//var startIndex = grid.getBottomToolbar().cursor;
															grid.getStore().load({
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
	/*************************************grid数据存储 *****************************************/
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'IpAddress',
									mapping : 'IpAddress',
									type : 'string'
								}, {
									name : 'TableName',
									mapping : 'TableName',
									type : 'string'
								}, {
									name : 'ClassName',
									mapping : 'ClassName',
									type : 'string'
								}, {
									name : 'ClassNameDesc',
									mapping : 'ClassNameDesc',
									type : 'string'
								}, {
									name : 'ObjectReference',
									mapping : 'ObjectReference',
									type : 'string'
								}, {
									name : 'ObjectDesc',
									mapping : 'ObjectDesc',
									type : 'string'
								}, {
									name : 'UpdateUserDR',
									mapping : 'UpdateUserDR',
									type : 'string'
								}, {
									name : 'UpdateUserName',
									mapping : 'UpdateUserName',
									type : 'string'
								}, {
									name : 'UpdateDate',
									mapping : 'UpdateDate',
									type : 'date',
									dateFormat : 'm/d/Y'
								}, {
									name : 'UpdateTime',
									mapping : 'UpdateTime',
									type : 'time'
								}, {
									name : 'OperateType',
									mapping : 'OperateType',
									type : 'string'
								}, {
									name : 'NewValue',
									mapping : 'NewValue',
									type : 'string'
								},{
									name:'OldValue',
									mapping:'OldValue',
									type:'string'
								} ,{
									name:'StrJson',
									mapping:'StrJson',
									type:'string'
								} ,{
									name:'BDPDataAuditDataLogDR',
									mapping:'BDPDataAuditDataLogDR',
									type:'string'
								} ,{
									name:'BDPDataAuditRowId',
									mapping:'BDPDataAuditRowId',
									type:'string'
								} ,{
									name:'BDPDataAuditStatus',
									mapping:'BDPDataAuditStatus',
									type:'string'
								} ,{
									name:'BDPDataAuditDate',
									mapping:'BDPDataAuditDate',
									type:'string'
								} ,{
									name:'BDPDataAuditTime',
									mapping:'BDPDataAuditTime',
									type:'string'
								} ,{
									name:'BDPDataAuditUser',
									mapping:'BDPDataAuditUser',
									type:'string'
								} ,{
									name:'BDPDataAuditResult',
									mapping:'BDPDataAuditResult',
									type:'string'
								} ,{
									name:'BDPDataAuditNote',
									mapping:'BDPDataAuditNote',
									type:'string'
									
								}
						])
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
				handler : function() {
					grid.getStore().baseParams={
						
						Status:Ext.getCmp("tbBDPDataAuditStatus").getValue(),
						Result:Ext.getCmp("tbBDPDataAuditResult").getValue(),
						AuditUser:Ext.getCmp("tbBDPDataAuditUser").getValue(),
						AuditDate : Ext.getCmp("tbBDPDataAuditDate").getValue()===""?"":Ext.getCmp("tbBDPDataAuditDate").getValue().format("m/d/Y"),
					
							ClassN : Ext.getCmp("tbClassName").getValue(), //功能描述
							UserName : Ext.getCmp("tbUpdateUserName").getValue(),
							OBJDESC : Ext.getCmp("tbObjectDesc").getValue(),
							DateFrom : Ext.getCmp("tbUpdateDate").getValue()===""?"":Ext.getCmp("tbUpdateDate").getValue().format("m/d/Y"),
							DateTo:Ext.getCmp("tbUpdateDateTo").getValue()===""?"":Ext.getCmp("tbUpdateDateTo").getValue().format("m/d/Y")
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
				handler : function() {
					Ext.getCmp("tbBDPDataAuditStatus").reset();
					Ext.getCmp("tbBDPDataAuditResult").reset();
					Ext.getCmp("tbBDPDataAuditUser").reset();
					Ext.getCmp("tbBDPDataAuditDate").reset();
					
					Ext.getCmp("tbClassName").reset();
					Ext.getCmp("tbObjectDesc").reset();
					
					Ext.getCmp("tbUpdateUserName").reset();
					//Ext.getCmp("tbUpdateDate").reset();
					//Ext.getCmp("tbUpdateDateTo").reset();
					
					Ext.getCmp("tbUpdateDate").setValue(StartDate);
                    Ext.getCmp("tbUpdateDateTo").setValue(EndDate); 
					grid.getStore().baseParams={};
					grid.getStore().load({
						params : {
									start : 0,
									limit : pagesize_main 
								}
							});
					}
			});
	
	/************************************ 工具条 ***************************************/
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : ['审计状态', {
							fieldLabel : '审计状态',
							xtype : 'combo',
							id : 'tbBDPDataAuditStatus',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbBDPDataAuditStatus'),
							width : 100,
							mode : 'local',
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							listWidth : 100,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													name : 'YES',
													value : 'Y'
												}, {
													name : 'NO',
													value : 'N'
												}]
									})
						},'-',
						'审计结果', {
							fieldLabel : '审计结果',
							xtype : 'combo',
							id : 'tbBDPDataAuditResult',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbBDPDataAuditResult'),
							
							width : 100,
							mode : 'local',
							// hiddenName:'hxxx',//不能与id相同
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							typeAhead : true,
							minChars : 1,
							listWidth : 100,
							valueField : 'value',
							displayField : 'name',
							store : new Ext.data.JsonStore({
										fields : ['name', 'value'],
										data : [{
													name : '正常',
													value : 'N'
												}, {
													name : '异常',
													value : 'A'
												}]
									})
						},'-',
						'审计人', {
							width : 100,
							xtype : 'textfield',
							id : 'tbBDPDataAuditUser',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbBDPDataAuditUser')
						}, '-',
						'审计日期', {
							width : 100,
							xtype : 'datefield',
							id : 'tbBDPDataAuditDate',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbBDPDataAuditDate'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
						},btnAuditN,'-',btnAuditA
			
			//'-',btnDel
			]
		});
	
	/** **********************************搜索工具条 **************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['功能描述', {
							width : 100,
							xtype : 'textfield',
							id : 'tbClassName',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbClassName')
						}, '-',
						'被操作数据描述', {
							width : 100,
							xtype : 'textfield',
							id : 'tbObjectDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbObjectDesc')
						}, '-',
						
						'操作用户', {
							width : 100,
							xtype : 'textfield',
							id : 'tbUpdateUserName',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbUpdateUserName')
						}, '-',
						'更新日期从', {
							width : 100,
							xtype : 'datefield',
							id : 'tbUpdateDate',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbUpdateDate'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
						}, '-',
						'到', {
							width : 100,
							xtype : 'datefield',
							id : 'tbUpdateDateTo',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('tbUpdateDateTo'),
							format : BDPDateFormat,
							enableKeyEvents : true,
							listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
						},'-', btnSearch, '-', btnRefresh ///,'->',helphtmlbtn
						//, '->', btnDel
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
						Ext.getCmp("tbUpdateDate").setValue(StartDate);
                        Ext.getCmp("tbUpdateDateTo").setValue(EndDate); 
					}
				}
			});
	
	 
	/** ***********************************创建grid ****************************************/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						 {
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							hidden : true
						},{
							header:'审计状态',
							sortable:true,
							dataIndex:'BDPDataAuditStatus',
							renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
						 	width:60
						},{
							header:'审计结果',
							sortable:true,
							dataIndex:'BDPDataAuditResult',
							
							renderer : Ext.BDP.FunLib.Component.ReturnAuditIcon,
						 	width:60
						} , {
							header : '表名称',
							sortable : true,
							hidden : true,   ///
							dataIndex : 'TableName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 100
						}, {
							header : '类名称',
							sortable : true,
							hidden : true,  ///
							dataIndex : 'ClassName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 100
						},{
							header : '功能描述',
							sortable : true,
							dataIndex : 'ClassNameDesc', 
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width : 80
						},{
							header : '对象ID',
							sortable : true,
							hidden : true,  ///
							dataIndex : 'ObjectReference',
							width : 60
						},{
							header : '被操作数据描述',
							sortable : true,
							width:90,
							dataIndex : 'ObjectDesc'
					
						},  {
							header : '用户',
							sortable : true,
							width:90,
							hidden : true,  ///
							dataIndex : 'UpdateUserDR'
						}, {
							header : '操作用户',
							sortable : true,
							dataIndex : 'UpdateUserName',
							renderer: Ext.BDP.FunLib.Component.GirdTipShow,
							width:90
						},{
							header : '用户IP',
							sortable : true,
							dataIndex : 'IpAddress',
							width : 70
						}, {
							header : '更新日期',
							sortable : true,
							width:60,
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
							dataIndex : 'UpdateDate'
						}, {
							header : '更新时间',
							sortable : true,
							width:60,
							dataIndex : 'UpdateTime'
						}, {
							header : '操作类型',
							sortable : true,
							width:60,
							dataIndex : 'OperateType',
							renderer : function(v){
								if(v=='R'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"plugin.gif''>"+"   读取";}
								if(v=='U'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"update.gif''>"+"   修改";}
								if(v=='D'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"delete.gif''>"+"   删除";}
								if(v=='A'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"add.gif''>"+"   新增";;}
							}
						},{
							header : '修正的数据',
							sortable : true,
							hidden : true,  ///
							dataIndex : 'NewValue',
							width : 10
						},{
							header:'原始数据',
							sortable:true,
							hidden : true,  ///
							dataIndex:'OldValue',
							width:10
						},{
							header:'数据变动明细',
							sortable:true,
							dataIndex:'StrJson',
						 	width:260,
						 	renderer: function(value, meta, record) {    
						         meta.attr = 'style="white-space:normal;word-wrap:break-word; width:92%;"'; 
						         return value;     
						    }  
						},{
							header:'LOGID',
							sortable:true,
							hidden : true,  ///
							dataIndex:'BDPDataAuditDataLogDR',
						 	width:80
						},{
							header:'审计ID',
							sortable:true,
							hidden : true,  ///
							dataIndex:'BDPDataAuditRowId',
						 	width:80
						 
						 },{
							header:'审计日期',
							sortable:true,
							dataIndex:'BDPDataAuditDate',
							renderer : Ext.util.Format.dateRenderer(BDPDateFormat),
						 	width:80
						 },{
							header:'审计时间',
							sortable:true,
							dataIndex:'BDPDataAuditTime',
						 	width:80
						 },{
							header:'审计人',
							sortable:true,
							dataIndex:'BDPDataAuditUser',
						 	width:100
						 
						 },{
							header:'备注',
							sortable:true,
							hidden : true,  ///
							dataIndex:'BDPDataAuditNote',
						 	width:80
						  
						}],
				stripeRows : true,
				title : '基础数据日志审计',
				autoStroll:true,
				columnLines : true, //在列分隔处显示分隔符
				viewConfig : {
					forceFit : true
				},
				sm : new Ext.grid.CheckboxSelectionModel(), //多选
				bbar : paging,
				tbar : tb,
				stateId : 'grid'
			});
	
	/** 监听数据是否有变化,自动判断是否全选并选中或不选中表头的checkbox 20130711lisen */
	//ds.on('datachanged', function autoCheckGridHead(store){
	ds.on('load', function autoCheckGridHead(store){
		var hd_checker = grid.getEl().select('div.x-grid3-hd-checker'); 	
    	var hd = hd_checker.first();		
    	if(hd != null){
	    	if(grid.getSelectionModel().getSelections().length != grid.getStore().getCount()){    //没有全选的话
                //清空表格头的checkBox
                if(hd.hasClass('x-grid3-hd-checker-on')){
	                hd.removeClass('x-grid3-hd-checker-on');     //x-grid3-hd-checker-on
	            }
            }else{
            	if(grid.getStore().getCount() == 0){	//没有记录的话清空;
            		return;
            	}else{
	            	hd.addClass('x-grid3-hd-checker-on');
	                grid.getSelectionModel().selectAll();
            	}
            }
        } 
	});
	
 /*******************************动态生成列表格******************************************/
  	var DetailCM=[]	
    var Detailfd = [];
    var DetailsDs=new Ext.data.JsonStore({
   		fields:Detailfd
  });
 
 var DetailGrid=new Ext.grid.GridPanel({
	   columns:DetailCM,
	   store:DetailsDs,
	   width:1000,
	   height:400,
	   autoScroll:true
  	});
 
	var win = new Ext.Window({
		width : 1000,
		layout : 'fit',
		plain : true,
		modal : true,
		frame : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		items :[DetailGrid],
		viewConfig : {
					forceFit: true, // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化(比如你resize了它)时不会自动调整column的宽度
					scrollOffset: 0 ,//不加这个的话,会在grid的最右边有个空白,留作滚动条的位置
    				autoFill:true,
    				enableRowBody: true  
				},
		listeners : {
				"show" : function() {
								 
				},
				"hide" : function(){
						  DetailCM = []	
   						  Detailfd = [];  
						  win.hide()
					}
				}	 
			});
			
////无法解析json时的弹出窗口
			
var win2 = new Ext.Window({
		title : '修正的数据',
		width : 600,
		layout : 'fit',
		plain : true, 
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		constrain : true,
		hideCollapseTool : true,
		titleCollapse : true,
		buttonAlign : 'center',
		closeAction : 'hide',
		items : [new Ext.form.TextArea({
				id : 'UpdateDataText',
				readOnly : true,
				width : 600,
				height : 300
		})]
	});
 
/*********************日志的原始数据与修正数据进行比对，颜色显示**********************************************/
	 
	grid.on("rowdblclick", function(grid, rowIndex, e){
	try
	{
		var OldValueJson=""
		var redata =""
		var record = grid.getSelectionModel().getSelected();
		var ShowOperate=record.get('OperateType'); 
		var UserClass=record.get("ClassName");
		var ClassNameDesc = record.get('ClassNameDesc');
        var showTitleName=ClassNameDesc 
     	var newdata = record.get('NewValue'); 
     	/// 正常情况下,NewValue 是非空的 
     	if (newdata!=""){
	        var jsondata = eval('(' + newdata + ')');
	        var newjson = "{";
	        var oldjson2="{";
	        var olddata=record.get('OldValue');		
       
       		 /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
       	 	if (olddata!=""){ 
        		//修改 :存在一种情况 操作是修改，但是没有OldValue,只有 NewValue
     	 		 var oldjson= eval('('+olddata+')')
	     		 redata = [oldjson,jsondata]
        	}
		    else{
		    	////olddata 为空
		    	 redata = [jsondata]
		    }
	    
		for(var x in jsondata)
		{
		  	if (newjson!= "{")
	     	{
	     		newjson = newjson + ","
	     	}
	     	if (oldjson2!= "{")
	     	{
	     		oldjson2 = oldjson2 + ","
	     	}
	     	/// 获取属性
	     	var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
	     	var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
	     	
     	    PropertyData=PropertyData.substring(1,(PropertyData.length-1));
		 
	     	var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:125,sortable:true}]};  
	     	var columns = res.columns;
    		var fields = res.fields;
     		for (var i = 0; i < fields.length; i++) {
     	 		Detailfd.push(fields[i].name);
     	 		DetailCM.push(columns[i]);
     		}
     		if(olddata!=""){
     			var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
     		 	PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
     			// 原始数据与现数据进行比较
     			if(PropertyDataY!=PropertyData)
	     		{ ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
	  	   	 		newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"'	
	     			oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"'	
	     		}
	     		else
	     		{
	     			newjson = newjson + x+":"+'"'+PropertyData +'"'	
	     			oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'	
	     		}  		
     		}
     		else{ /// 如果是 新增或者删除时，进行拼串
     			newjson = newjson + x+":"+'"'+PropertyData +'"'	
     		}
  		}
	   		var newjson = newjson + "}";
	 		var newjsondata = eval('(' + newjson + ')');
	 		
	 		var oldjson = oldjson2 + "}";
	 		var oldjson = eval('(' + oldjson + ')');
			win.show();
	 	}
	 	else{
			///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。	
	 		Ext.getCmp('UpdateDataText').setValue(OldValue);
	 	}
	 
		var ss=new Ext.data.JsonStore({ 
			fields:Detailfd  
		}) 	
		DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
		if(olddata!=""){
			ss.loadData([oldjson,newjsondata]);  
			win.setIconClass("icon-update")
			win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
		}
		else{
			if(ShowOperate=="U"){
				ss.loadData([newjsondata])
				win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
				win.setIconClass("icon-update")
			}
			
			if (ShowOperate=="A"){
				ss.loadData([newjsondata])
				win.setTitle(showTitleName+"     "+"添加数据")
				win.setIconClass("icon-add")
			}
		   if (ShowOperate=="D"){
		   		ss.loadData([newjsondata])
				win.setTitle(showTitleName+"      "+"删除数据")
				win.setIconClass("icon-delete")
			} 
		  }
	 }
	 	catch (e) 
		{
			/// 捕获异常后
	   		if((record.get('NewValue')!="")&&(ShowOperate=="U")){
	   			Ext.getCmp('UpdateDataText').setValue(record.get('OldValue')+"->"+record.get('NewValue'));
	   		}
	   		 
		   	if((record.get('OldValue')!="")&&(ShowOperate=="U")){
		   		Ext.getCmp('UpdateDataText').setValue(record.get('OldValue')+"->"+record.get('NewValue')); 
		   	}
		   	if((ShowOperate=="A")||(ShowOperate=="D")){
		   		if(record.get('NewValue')!=""){
		   			Ext.getCmp('UpdateDataText').setValue(record.get('NewValue')); 
		   	}
	   	}
	   	  win2.show()
	 }
});


	
	var auditmenuN =({
			id : 'auditmenuN',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('auditmenuN'),
			text:'审计为正常',
	        iconCls :'icon-accept',
			handler:function(){
				AuditNF();
    			
			}
	});	
	var auditmenuA =({
			id : 'auditmenuA',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('auditmenuA'),
			text:'审计为异常',
	        iconCls :'icon-error',
			handler:function(){
				
    			AuditAF();
			}
	});

    
    //=====================右键菜单=====================
    if(window.ActiveXObject)//判断浏览器是否属于IE,屏蔽其它浏览器
  	{
  		grid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分
  		var rightClick = new Ext.menu.Menu({
    		id:'rightClickCont', //在HTML文件中必须有个rightClickCont的DIV元素
    		disabled : Ext.BDP.FunLib.Component.DisableFlag('rightClickCont'),
    		items: [auditmenuN,auditmenuA]
		}); 
		
  		function rightClickFn(grid,rowindex,e){
    	 	e.preventDefault();
    	 	var currRecord = false; 
   		 	var currRowindex = false; 
   		 	var currGrid = false; 
         	if (rowindex < 0) { 
         		return; 
   			} 
     		grid.getSelectionModel().selectRow(rowindex); 
     		currRowIndex = rowindex; 
     		currRecord = grid.getStore().getAt(rowindex);
     		

     		currGrid = grid; 
     		rightClick.showAt(e.getXY()); 
     		
     		
  		}
	}		
/***********************************定义viewport容器*******************************/
	var viewport = new Ext.Viewport({
		id:'vp',
		layout : 'border',
		items : [grid]
	});
	
	 /** 如果未开启日志审计，则禁用此页面。 */
    	var BDPAudit =tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPDataAudit");
    	if (BDPAudit != "Y")
    	{
    		//Ext.getCmp('vp').disable(); 
    		Ext.getCmp('grid').disable();
    		grid.getStore().removeAll();
			grid.getView().refresh();
    		alert('未开启日志审计功能！如需要开启，请在 "系统配置-平台配置" 下设置。')
    	}
    	else
    	{
    		Ext.getCmp('grid').enable();
    		/***************************************grid加载数据 ********************************/
			ds.load({
				params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {

					}
			});
    	}
    	
});