/// 名称: 医嘱优先级
/// 描述: 包含医嘱优先级的保存功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-12-3
Ext.onReady(function(){
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtPriority&pClassQuery=GetList";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseasePriority&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseasePriority";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseasePriority&pClassQuery=GetList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseasePriority&pClassMethod=DeleteData";
var SAVE_MODE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseasePriority&pClassMethod=SaveMode&pEntityName=web.Entity.KB.DHCPHDiseasePriority";
var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
//全局变量
var GenDr=Ext.BDP.FunLib.getParam("GlPGenDr");
var Pointer=Ext.BDP.FunLib.getParam("GlPPointer");
/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHEPRowId',
							mapping : 'PHEPRowId',
							type : 'string'
						}, {
							name : 'PHEPCode',
							mapping : 'PHEPCode',
							type : 'string'
						}, {
							name : 'PHEPDesc',
							mapping : 'PHEPDesc',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWest
	});
/*	dsWest.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		    'TypeDr':'',
			'GenDr':GenDr,
			'PointerType':'Form',
			'PointerDr':Pointer
		  }   
		)
	});*/
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
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Priority","");
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : ['级别:', {
					xtype : 'combo',
					name : 'PHINSTMode',
					hiddenName : 'PHINSTMode',
					id:'Mode',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('Mode'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Mode')),
					editable:false,
					allowBlank : false,
					width : 100,
					labelWidth:30,
					mode : 'local',
					triggerAction : 'all',// query
					value:mode,
					valueField : 'value',
					displayField : 'name',
					store:new Ext.data.SimpleStore({
						fields:['value','name'],
						data:[
							      ['W','警示'],
							      ['C','管控'],
							      ['S','统计']
						     ]
					})
				},'-',{
					xtype : 'button',
					text : '保存',
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
							var flagRet = 0;
							var priorityStr = "";
							Ext.each(rs,function(){
								if(priorityStr!="") priorityStr = priorityStr+"*";
								var PDPPriorityDR=this.get('PHEPRowId');//频率id
								var Mode=Ext.getCmp("Mode").getValue(); //管制级别
								var Type="PRIORITY";//知识库目录
								var OrderNum=0;//顺序
								var Gen=GenDr;//通用名  传
								//var Pointer=Pointer; //指针  传
								var PointerType="Form";//指针类型
								var Lib="DRUG";//知识库标识
								var ActiveFlag="Y";//是否可用
								var SysFlag="Y";//是否系统标识
								
				   			 	for (var i = 0; i < dsCenter.getCount(); i++) {
									var record = dsCenter.getAt(i);
									var PriorityDR = record.get('PDPPriorityDR');
									if(PDPPriorityDR==PriorityDR){
											Ext.Msg.show({
												title:'提示',
												msg:'该记录已存在!',
												minWidth:200,
												icon:Ext.Msg.ERROR,
												buttons:Ext.Msg.OK
											});
											flagRet = 1;
											return;
									}
								};
								priorityStr = priorityStr+PDPPriorityDR+"^"+Mode+"^"+Type+"^"+OrderNum+"^"+Gen+"^"+Pointer+"^"+PointerType+"^"+Lib+"^"+ActiveFlag+"^"+SysFlag;
							})
							if (flagRet == 0){
								Ext.Ajax.request({
									url : SAVE_ACTION_URL , 		
									method : 'POST',	
									params : {
											'priorityStr' : priorityStr
									},
									callback : function(options, success, response) {	
										if(success){
											var jsonData = Ext.util.JSON.decode(response.responseText);
											if (jsonData.success == 'true') {
												var myrowid = jsonData.id;
												gridCenter.getStore().load({
													params : {
														'TypeDr':'',
														'GenDr':GenDr,
														'PointerType':'Form',
														'PointerDr':Pointer,
														start : 0,
														limit : pagesize_main
													}
												});
												gridWest.getStore().load({
													params : {
														'TypeDr':'',
														'GenDr':GenDr,
														'PointerType':'Form',
														'PointerDr':Pointer,
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
						}
					},
					scope : this
				}]
	});
    Ext.override(Ext.grid.CheckboxSelectionModel, {   
	    handleMouseDown : function(g, rowIndex, e){     
	      if(e.button !== 0 || this.isLocked()){     
	        return;     
	      }     
	      var view = this.grid.getView();     
	      if(e.shiftKey && !this.singleSelect && this.last !== false){     
	        var last = this.last;     
	        this.selectRange(last, rowIndex, e.ctrlKey);     
	        this.last = last; // reset the last     
	        view.focusRow(rowIndex);     
	      }else{     
	        var isSelected = this.isSelected(rowIndex);     
	        if(isSelected){     
	          this.deselectRow(rowIndex);     
	        }else if(!isSelected || this.getCount() > 1){     
	          this.selectRow(rowIndex, true);     
	          view.focusRow(rowIndex);     
	        }     
	      }     
	    }   
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
					header : 'PHEPRowId',
					sortable : true,
					dataIndex : 'PHEPRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'PHEPCode'
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'PHEPDesc'
				}],
		stripeRows : true,
		title:'医嘱优先级列表',
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
	/**未选列表双击行，添加到已选列表*/
/*	 gridWest.on("rowdblclick", function(grid, rowIndex, e){
		var PDPPriorityDR=gridWest.getSelectionModel().getSelected().get('PHEPRowId');//频率id
		var Mode=Ext.getCmp("Mode").getValue(); //管制级别
		var Type="FREQ";//知识库目录
		var OrderNum=0;//顺序
		var Gen=GenDr;//通用名  传
		//var Pointer=Pointer; //指针  传
		var PointerType="Form";//指针类型
		var Lib="DRUG";//知识库标识
		var ActiveFlag="Y";//是否可用
		var SysFlag="Y";//是否系统标识
		var priorityStr = PDPPriorityDR+"^"+Mode+"^"+Type+"^"+OrderNum+"^"+Gen+"^"+Pointer+"^"+PointerType+"^"+Lib+"^"+ActiveFlag+"^"+SysFlag;
		
		Ext.Ajax.request({
			url : SAVE_ACTION_URL , 		
			method : 'POST',	
			params : {
					'priorityStr' : priorityStr
			},
			callback : function(options, success, response) {	
				if(success){
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
						var myrowid = jsonData.id;
						gridCenter.getStore().load({
							params : {
								'TypeDr':'',
								'GenDr':GenDr,
								'PointerType':'Form',
								'PointerDr':Pointer,
								start : 0,
								limit : pagesize_main
							}
						});
						gridWest.getStore().load({
							params : {
								'TypeDr':'',
								'GenDr':GenDr,
								'PointerType':'Form',
								'PointerDr':Pointer,
								start : 0,
								limit : pagesize_main
							}
						});
//						Ext.getCmp("Mode").reset();
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
	 });*/
/**********************************Center *************************************/
	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [  {
							name : 'PHEPCode',
							mapping : 'PHEPCode',
							type : 'string'
						},{
							name : 'PHEPDesc',
							mapping : 'PHEPDesc',
							type : 'string'
						},{
							name : 'PHINSTMode',
							mapping : 'PHINSTMode',
							type : 'string'
						},{
							name : 'PDPRowId',
							mapping : 'PDPRowId',
							type : 'string'
						},{
							name : 'PDPInstDr',
							mapping : 'PDPInstDr',
							type : 'string'
						},{
							name : 'PDPPriorityDR',
							mapping : 'PDPPriorityDR',
							type : 'string'
						}
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
		    'TypeDr':'',
			'GenDr':GenDr,
			'PointerType':'Form',
			'PointerDr':Pointer
		  }   
		)
	});
	/** grid 加载数据 */
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
					header : '代码',
					sortable : true,
					dataIndex : 'PHEPCode'
				},{
					header : '描述',
					sortable : true,
					dataIndex : 'PHEPDesc'
				},{
					header : '级别',
					sortable : true,
					dataIndex : 'PHINSTMode',
					renderer:function(value){
						if(value=="W"){return "警示"}
						if(value=="C"){return "管控"}
						if(value=="S"){return "统计"}
					},
					editor:new Ext.form.ComboBox({
						name : 'PHINSTMode',
						hiddenName : 'PHINSTMode',
						editable:false,
						allowBlank : false,
						width : 230,
						labelWidth:30,
						mode : 'local',
						triggerAction : 'all',// query
						value:mode,
						valueField : 'value',
						displayField : 'name',
						store:new Ext.data.SimpleStore({
							fields:['value','name'],
							data:[
								      ['W','警示'],
								      ['C','管控'],
								      ['S','统计']
							     ]
						})
					})
				}, {
					header : 'PDPRowId',
					sortable : true,
					dataIndex : 'PDPRowId',
					hidden:true
				}, {
					header : 'PDPInstDr',
					sortable : true,
					dataIndex : 'PDPInstDr',
					hidden:true
				}, {
					header : 'PDPPriorityDR',
					sortable : true,
					dataIndex : 'PDPPriorityDR',
					hidden:true
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
       			var mode=record.get('PHINSTMode');
               Ext.Ajax.request({
                   url: SAVE_MODE_URL,
                   method: "POST",
                   params: {
                       mode: mode,
                       id: record.get('PDPInstDr')
                   },
                   callback : function(options, success, response) {	
				   		if(success){
				   			var jsonData = Ext.util.JSON.decode(response.responseText);
				   				if (jsonData.success == 'true') {
			                       	gridCenter.getStore().reload(); 
			                 		gridCenter.getSelectionModel().selectRow(0,false);// 
			                       	gridCenter.getView().focusCell(0,0); //选中的获取焦点 
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
                  /* success: function(r) {
                   		//保存成功后grid加载之前加载可编辑下拉框 防止下拉框搜索添加时，保存后显示为id而不是描述
                   		storeAge.load();
                   		storeAgeUom.load();
                       	gridCenter.getStore().reload(); 
                 		gridCenter.getSelectionModel().selectRow(0,false);// 
                       	gridCenter.getView().focusCell(0,0); //选中的获取焦点 
                   },
                   failure: function() {
                        MessageBox("提示", "操作失败！", Ext.MessageBox.ERROR);
                      	gridCenter.getStore().reload();
                   }*/
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
				'id' : gridCenter.getSelectionModel().getSelected().get('PDPRowId')//频率id
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
							var id = gridCenter.getSelectionModel().getSelections()[0].get('PDPRowId');
						}
						gridCenter.getStore().load({
							params : {
								'TypeDr':'',
								'GenDr':GenDr,
								'PointerType':'Form',
								'PointerDr':Pointer,
								id : id,
								start : startIndex,
								limit : pagesize_main
							}
						});
						gridWest.getStore().load({
							params : {
								/*'TypeDr':'',
								'GenDr':GenDr,
								'PointerType':'Form',
								'PointerDr':Pointer,*/
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
