/// 名称: 排序
/// 编写者： 基础数据平台组 高姗姗
/// 编写日期: 2015-8-7
var tableName=Ext.BDP.FunLib.getParam('tableName');
Ext.onReady(function(){
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData";
	var BindingType = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	
	//多院区医院下拉框
	var sqltablename=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetCodeByTableName",tableName);
	var SorthospComp=GenHospComp(sqltablename);	
	//医院界面 排序单独处理，不显示医院下拉框 2021-11-11
	SorthospComp.hidden=((tkMakeServerCall("web.DHCBL.BDP.BDPConfig","GetConfigValue","BDPHospAut")!="Y")||(tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetDataType",sqltablename)=="G")||(sqltablename=="CT_Hospital"))?true:false,   //表定义为公有时不显示此按钮
	//医院下拉框选择一条医院记录后执行此函数
	SorthospComp.on('select',function (){
		 Ext.getCmp("Type").setValue('');
     Ext.getCmp("SortDesc").setValue('');
		 grid.getStore().baseParams = {
			hospid:SorthospComp.getValue(),
		    tableName:tableName,
		    type:Ext.getCmp("Type").getValue(),
        desc:Ext.getCmp("SortDesc").getValue(),
		    dir : dir
		};
		grid.getStore().load({
					params : {
						start : 0,
						limit : Ext.BDP.FunLib.PageSize.Main
					}
				});
		
	});
	
	var rowIndex;
	
	var dir = "";
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'SortId',
									mapping : 'SortId',
									type : 'string'
								},{
									name : 'RowId',
									mapping : 'RowId',
									type : 'string'
								}, {
									name : 'Desc',
									mapping : 'Desc',
									type : 'string'
								}, {
									name : 'SortType',
									mapping : 'SortType',
									type : 'string'
								}, {
									name : 'SortNum',
									mapping : 'SortNum',
									type : 'string'
								}
						]),
					pruneModifiedRecords: true
				//remoteSort:true,
				//sortInfo: {field: 'SortNum', direction: 'ASC'}
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
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
	var flagPage = 0;
	paging.on('beforechange',function(tb,e){ //添加翻页监听
		if(ds.getModifiedRecords().length!=0){
			var cfmF = window.confirm('本页数据已变动,是否保存?');
    		if(cfmF){ //是
    			saveData();
    			flagPage = 1;
    		}
		}
	});
	/**保存按钮*/
	var btnSave = new Ext.Button({
			id : 'btnSave',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSave'),
			icon : Ext.BDP.FunLib.Path.URL_Icon+'save.gif',
			text : '保存',
			handler : saveData
		});
	function saveData(){
			var SortType = Ext.getCmp("Type").getValue(); //SortType
			if (SortType=="") {
		    	Ext.Msg.show({ title : '提示', msg : '排序类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		        return;
		    }
			var sortstr="";
			
			var records = ds.getModifiedRecords()
			if (records.length==0) {
		    	Ext.Msg.show({ title : '提示', msg : '顺序号不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
		        return;
		    }
			for(var i = 0; i < records.length; i++){
				/*if(sortstr!=""){
					if(records[i].get('SortNum')==""){
						sortstr = sortstr+"";
					}else{
						sortstr = sortstr+"*";
					}
				}
				if(records[i].get('SortNum')!=""){
					sortstr = sortstr+tableName+'^'+records[i].get('RowId')+'^'+SortType+'^'+records[i].get('SortNum')+'^'+records[i].get('SortId');
				}*/
				if (sortstr==""){
					sortstr = tableName+'^'+records[i].get('RowId')+'^'+SortType+'^'+records[i].get('SortNum')+'^'+records[i].get('SortId');
				}else{
					sortstr = sortstr+"*"+tableName+'^'+records[i].get('RowId')+'^'+SortType+'^'+records[i].get('SortNum')+'^'+records[i].get('SortId');
				}
			}
			Ext.Ajax.request({
				url:SAVE_ACTION_URL,
				method:'POST',
				params:{
					'sortstr':sortstr
				},
				callback : function(options, success, response) {	
					if(success){
						var jsonData = Ext.util.JSON.decode(response.responseText);
						if (jsonData.success == 'true') {
							var myrowid = jsonData.id;
							Ext.Msg.show({
							title : '提示',
							msg : '保存成功!',
							icon : Ext.Msg.INFO,
							buttons : Ext.Msg.OK,
							fn : function(btn) {
								if(flagPage==0){
									grid.getStore().baseParams = {
										hospid:SorthospComp.getValue(),
									    tableName:tableName,
									    type:Ext.getCmp("Type").getValue(),
                      desc:Ext.getCmp("SortDesc").getValue(),
									    dir :dir
									};
									grid.getStore().load({
												params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Main
												}
											});
					
								}
								
								/*
								dsType.load({
							    	params:{
							    		tableName:tableName
							    	}
							    });*/
							    flagPage=0;
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
	
	
	 
	//上移 下移 移到首行
	OrderFunLib=function(type)
	{
		if (!(grid.selModel.hasSelection())) {	
			Ext.Msg.show({ title : '提示', msg : '请先选择一条有顺序的记录!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
      		return;    
	 	}
	 	//var rowIndex=grid.store.indexOf(rec)
	 	//var rowIndex = grid.getBottomToolbar().cursor;
	 	//var totalnum=grid.getStore().getTotalCount(); //总条数
		var rows = grid.getSelectionModel().getSelections();
       	var SortNum = rows[0].get('SortNum');
       	if (SortNum=="")
       	{
       		Ext.Msg.show({ title : '提示', msg : '只能对有顺序的数据进行排序，请重新选择!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
       		return;
       	}
       	if (type=='up')
		{
			//上移
			var record = grid.getSelectionModel().getSelected();
			if (record) {
			    var index = grid.store.indexOf(record);
			    if (index > 0) 
			 	{
			  			grid.store.removeAt(index);
						grid.store.insert(index - 1, record);
						grid.getView().refresh();
			        	grid.getSelectionModel().selectRow(index - 1);
			        	//交换顺序号
						var SortNumNew=grid.store.getAt(index).get('SortNum');
						grid.getStore().getAt(index - 1).set("SortNum",SortNumNew) 
						grid.getStore().getAt(index).set("SortNum",SortNum)	
			    }
			 }
					
		}
		else if (type=='down')
		{
			//下移
			var record = grid.getSelectionModel().getSelected();
	        if (record) {
	             var index = grid.store.indexOf(record);
	             if (index < grid.store.getCount() - 1) {
	                 grid.store.removeAt(index);
	                 grid.store.insert(index + 1, record);
	                 grid.getView().refresh();
	                 grid.getSelectionModel().selectRow(index + 1);
	                //交换顺序号
					var SortNumNew=grid.store.getAt(index).get('SortNum');
					grid.getStore().getAt(index + 1).set("SortNum",SortNumNew) 
					grid.getStore().getAt(index).set("SortNum",SortNum)
	             }
	         }
	        
			
		}
	}
	
	/** 上移按钮 */
	var btnMoveUp = new Ext.Button({
			id : 'btnMoveUp',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMoveUp'),
			icon : Ext.BDP.FunLib.Path.URL_Img+'up.gif',
			text : '上移',
			handler : function() {
				OrderFunLib("up");
					
				}
		});
	/** 下移按钮 */
	var btnMoveDown = new Ext.Button({
			id : 'btnMoveDown',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnMoveDown'),
			icon : Ext.BDP.FunLib.Path.URL_Img+'down.gif',
			text : '下移',
			handler : function() {
				OrderFunLib("down");
				
			}
		});
		
	/******************上移、下移、移到首行结束******************************************/
		
		
	/** 升序按钮 */
	var btnUp = new Ext.Button({
			id : 'btnUp',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnUp'),
			icon : Ext.BDP.FunLib.Path.URL_Img+'up.gif',
			text : '升序',
			handler : function() {
				dir = "ASC";
				grid.getStore().baseParams = {
					hospid:SorthospComp.getValue(),
				    tableName:tableName,
				    type:Ext.getCmp("Type").getValue(),
            desc:Ext.getCmp("SortDesc").getValue(),
				    dir :dir
				};
				grid.getStore().load({
							params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Main
							}
						});
					
					
				}
		});
	/** 降序按钮 */
	var btnDown = new Ext.Button({
			id : 'btnDown',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnDown'),
			icon : Ext.BDP.FunLib.Path.URL_Img+'down.gif',
			text : '降序',
			handler : function() {
				dir = "DESC";
				grid.getStore().baseParams = {
					hospid:SorthospComp.getValue(),
				    tableName:tableName,
				    type:Ext.getCmp("Type").getValue(),
            desc:Ext.getCmp("SortDesc").getValue(),
				    dir :dir
				};
				grid.getStore().load({
							params : {
								start : 0,
								limit : Ext.BDP.FunLib.PageSize.Main
							}
						});
				
			}
		});
  // 搜索按钮
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : search=function() {
					
					grid.getStore().baseParams = {
						hospid:SorthospComp.getValue(),
					    tableName:tableName,
					    type:Ext.getCmp("Type").getValue(),
					    desc:Ext.getCmp("SortDesc").getValue()
					};
					grid.getStore().load({
								params : {
									start : 0,
									limit : Ext.BDP.FunLib.PageSize.Main
								}
							});
				}
			})
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
			id : 'btnRefresh',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
			iconCls : 'icon-refresh',
			text : '重置',
			handler : function() {
					Ext.getCmp("Type").setValue('');
          Ext.getCmp("SortDesc").setValue('');
					grid.getStore().baseParams = {
						hospid:SorthospComp.getValue(),
					    tableName:tableName,
					    type:Ext.getCmp("Type").getValue(),
					    desc:Ext.getCmp("SortDesc").getValue()
					};
					grid.getStore().load({
								params : {
									start : 0,
									limit : Ext.BDP.FunLib.PageSize.Main
								}
							});
					
					
				}
			});
/*	var dsType = new Ext.data.JsonStore({
			url : BindingType,
			root : 'data',
			totalProperty : 'total',
			idProperty : 'SortType',
			fields : ['SortType', 'SortType'],
			remoteSort : true,
			sortInfo : {
				field : 'SortType',
				direction : 'ASC'
			}
		});
	dsType.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {  
		  	hospid:SorthospComp.getValue(),
		    tableName:tableName
		  }   
		)
	});
    dsType.load();*/
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : [
						SorthospComp,'排序类型', {
							xtype : 'combo',
							id : 'Type',
							width:80,
							disabled : Ext.BDP.FunLib.Component.DisableFlag('all'),
							triggerAction : 'all', 
							selectOnFocus : true,
							editable:true,
						//	typeAhead : true,
							mode : 'remote',
							//pageSize : Ext.BDP.FunLib.PageSize.Combo,
					 		allQuery : '',
							minChars : 0,
							listWidth : 250,
							valueField : 'SortType',
							displayField : 'SortType',
							store : dsType=new Ext.data.JsonStore({
								url : BindingType,
								root : 'data',
								totalProperty : 'total',
								idProperty : 'SortType',
								fields : ['SortType', 'SortType'],
								remoteSort : true,
								sortInfo : {
									field : 'SortType',
									direction : 'ASC'
								}
							}),
							listeners : {
								'beforequery': function(e){
									this.store.baseParams = {
											desc:e.query,
											tableName:tableName,
											hospid:SorthospComp.getValue()
									};
									this.store.load({params : {
												start : 0,
												limit : Ext.BDP.FunLib.PageSize.Combo
									}})
								
							 	},
								'select':function(){
								 	grid.getStore().baseParams = {
										hospid:SorthospComp.getValue(),
									    tableName:tableName,
									    type:Ext.getCmp("Type").getValue(),
                      desc:Ext.getCmp("SortDesc").getValue(),
									    dir :dir
									};
									grid.getStore().load({
												params : {
													start : 0,
													limit : Ext.BDP.FunLib.PageSize.Main
												}
											});
								}
							}
						},'描述', {xtype : 'textfield',id : 'SortDesc',width:80,
                              listeners : {
                								specialkey: function(field, e){	
                									///回车查询。
                									if (e.getKey() == e.ENTER) {
                							        	search()
                							        }
                						        }
                              }
            
            
            },'-', btnSearch,'-',btnRefresh,'-',btnSave,'-',btnUp,'-',btnDown,'-',btnMoveUp,'-',btnMoveDown
				]
			});
	/** 创建grid */
	var grid = new Ext.grid.EditorGridPanel({
			id : 'grid',
			region : 'center',
			closable : true,
			store : ds,
			trackMouseOver : true,
			columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
					{
						header : 'SortId',
						sortable : true,
						dataIndex : 'SortId',
						hidden : true
					},{
						header : '对应表RowId',
						sortable : true,
						dataIndex : 'RowId',
						hidden : true
					}, {
						header : '描述',
						sortable : true,
						dataIndex : 'Desc'
					}, {
						header : '排序类型',
						sortable : true,
						dataIndex : 'SortType',
						hidden:true
					}, {
						header : '顺序号',
						sortable : true,
						dataIndex : 'SortNum',
						editor:new Ext.form.TextField()
					}],
			stripeRows : true,
			viewConfig : {
				forceFit : true
			},
			
			columnLines : true, //在列分隔处显示分隔符
			sm : new Ext.grid.RowSelectionModel({
				singleSelect:true
			}), 
			bbar : paging,
			tbar : tb,
			stateId : 'grid'
		});
	/** 布局 */
	var viewport = new Ext.Viewport({
			layout : 'border',
			items : [grid]
		});
})