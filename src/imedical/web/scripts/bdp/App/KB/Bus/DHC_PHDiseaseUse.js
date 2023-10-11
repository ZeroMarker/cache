/// 名称: 给药途径
/// 描述: 包含用药方法的保存功能
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2014-12-3
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
Ext.onReady(function(){
var QUERY_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtInstruc&pClassQuery=GetList";
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseUse&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDiseaseUse";
var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseUse&pClassQuery=GetList";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseUse&pClassMethod=DeleteData";
var SAVE_MODE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseUse&pClassMethod=SaveMode&pEntityName=web.Entity.KB.DHCPHDiseaseUse";
//var SAVE_MODE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDiseaseUse&pClassMethod=SaveMode";
var BindingAge = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmb1";
var BindingAgeUom= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassQuery=GetDataForCmbYMD";
var AGE_ACTION_URL= "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHPatAgeList&pClassMethod=getMaxMin";
var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
//var pagesize_main = 100;
//全局变量
var GenDr=Ext.BDP.FunLib.getParam("GlPGenDr");
var Pointer=Ext.BDP.FunLib.getParam("GlPPointer");
var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
/**********************************west***********************************/
	/** grid数据存储 */
	var dsWest = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [{
							name : 'PHEINRowId',
							mapping : 'PHEINRowId',
							type : 'string'
						}, {
							name : 'PHEINCode',
							mapping : 'PHEINCode',
							type : 'string'
						}, {
							name : 'PHEINDesc',
							mapping : 'PHEINDesc',
							type : 'string'
						}
				])
	});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
		disabled : false,
		store : dsWest
	});
	/*dsWest.on('beforeload',function(thiz,options){ 
		Ext.apply(   
		  this.baseParams,   
		  {   
		    'TypeDr':'',
			'GenDr':GenDr,
			'PointerType':PointerType,
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
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","PreMet");
	var tb = new Ext.Toolbar({
		id : 'tb',
		items : ['级别', {
					xtype : 'combo',
					name : 'PHINSTMode',
					hiddenName : 'PHINSTMode',
					id:'Mode',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('Mode'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Mode')),
					editable:false,
					allowBlank : false,
					width : 80,
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
				},'-',
				'禁忌', {
					xtype : 'checkbox',
					name : 'PDIExcludeFlag',
					id:'ExcludeFlag',
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('ExcludeFlag'),
					style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ExcludeFlag')),
					//checked:true,
					inputValue : true ? 'Y' : 'N'
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
							var useStr = "";
							Ext.each(rs,function(){
								if(useStr!="") useStr = useStr+"*";
								var PDIUseDR=this.get('PHEINRowId');//用法id
								var Mode=Ext.getCmp("Mode").getValue(); //管制级别
								var Type="PREMET";//知识库目录
								var OrderNum=0;//顺序
								var Gen=GenDr; //通用名  传
								//var Pointer=Pointer;//指针  传
								//var PointerType=PointerType;//指针类型
								var Lib="DRUG";//知识库标识
								var ActiveFlag="Y";//是否可用
								var SysFlag="Y";//是否系统标识
								var ExcludeFlag = Ext.getCmp("ExcludeFlag").getValue();
								var Age = Ext.getCmp("Age").getValue();
								var MinVal = Ext.getCmp("PDAMinVal").getValue();
								var MaxVal = Ext.getCmp("PDAMaxVal").getValue();
								var UomDr = Ext.getCmp("PDAUomDrF").getValue();
								var AlertMsg= Ext.getCmp("AlertMsg").getValue();
								
								if (MinVal != "" && MaxVal != "") {
				        			if (parseInt(MinVal)>parseInt(MaxVal)) {
				        				Ext.Msg.show({
						        					title : '提示',
													msg : '年龄最小值不能大于年龄最大值!',
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
										flagRet = 1;
				          			 	return;
				      				}
				   			 	};
				   			 	for (var i = 0; i < dsCenter.getCount(); i++) {
									var record = dsCenter.getAt(i);
									var UseDR = record.get('PDIUseDR');
									var AgeDr = record.get('PDAAgeDr');
									if(PDIUseDR==UseDR){
										if(Age==AgeDr){
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
									}
								};
				   			 	useStr = useStr+PDIUseDR+"^"+Mode+"^"+Type+"^"+OrderNum+"^"+Gen+"^"+Pointer+"^"+PointerType+"^"+Lib+"^"+ActiveFlag+"^"+SysFlag+"^"+ExcludeFlag+"^"+Age+"^"+MinVal+"^"+MaxVal+"^"+UomDr+"^"+AlertMsg;
							})
							if (flagRet == 0){
								Ext.Ajax.request({
									url : SAVE_ACTION_URL , 		
									method : 'POST',	
									params : {
											'useStr' : useStr
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
														'PointerType':PointerType,
														'PointerDr':Pointer,
														start : 0,
														limit : pagesize_main
													}
												});
												gridWest.getStore().load({
													params : {
														/*'TypeDr':'',
														'GenDr':GenDr,
														'PointerType':PointerType,
														'PointerDr':Pointer,*/
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
					}
				}]
	});
	var tbt = new Ext.Toolbar({
		id : 'tbt',
		items : [
			'年龄',{
					xtype:'bdpcombo',
					name : 'PDAAge',
					id : 'Age',
					hiddenName : 'PDAAge',
					width:80,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('Age'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('Age')),
					triggerAction : 'all',// query
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					queryParam : "desc",
					mode : 'remote',
					pageSize : Ext.BDP.FunLib.PageSize.Combo,
					minChars : 0,
					listWidth : 230,
					valueField : 'PDARowID',
					displayField : 'PDAAgeDesc',
					store : new Ext.data.JsonStore({
						autoLoad : true,
						url : BindingAge,
						root : 'data',
						totalProperty : 'total',
						idProperty : 'PDARowID',
						fields : ['PDARowID', 'PDAAgeDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'PDARowID',
							direction : 'ASC'
						}
					}),
					listeners : {
						'select' : function(){
							var PDARowId=Ext.getCmp("Age").getValue()
							if(PDARowId!=""){
								Ext.Ajax.request({											
								url:AGE_ACTION_URL,
								method:'GET', 
								params:{
									'id':PDARowId
									},
								callback:function(options,success,response){
										    if(success){	
										    var jsonData=Ext.util.JSON.decode(response.responseText);
				    				 		var PDAAgeMin=jsonData.PDAAgeMin;
				    				 		Ext.getCmp("PDAMinVal").setValue(PDAAgeMin);
				    				 		var PDAAgeMax=jsonData.PDAAgeMax;
				    				 		Ext.getCmp("PDAMaxVal").setValue(PDAAgeMax);
				    				 		var PDAUomDr=jsonData.PDAUomDr;
	    				 					Ext.getCmp("PDAUomDrF").setValue(PDAUomDr);
				  						 }
									}
								})	
							}		
						}
					}
				},'-',
				'年龄限制',{
					xtype:'textfield',
					name : 'PDAMinVal',
					id : 'PDAMinVal',
					width:35,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMinVal'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMinVal')),
					minValue : 0,
					minText : '不能小于0',
					nanText : '只能是数字'
				},'<html>-</html>',{
					xtype:'textfield',
					name : 'PDAMaxVal',
					id : 'PDAMaxVal',
					width:40,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAMaxVal'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAMaxVal')),
					minValue : 0,
					minText : '不能小于0',
					nanText : '只能是数字'
				},'&nbsp;',{
					xtype : 'combo',
					name : 'PDAUomDr',
					id : 'PDAUomDrF',
					hiddenName : 'PDAUomDr',
					width:70,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDAUomDrF'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDAUomDrF')),
					triggerAction : 'all',// query
					forceSelection : true,
					selectOnFocus : false,
					typeAhead : true,
					queryParam : "desc",
					mode : 'remote',
					valueField : 'PHEURowId',
					displayField : 'PHEUDesc',
					store : new Ext.data.JsonStore({
						autoLoad : true,
						url : BindingAgeUom,
						root : 'data',
						totalProperty : 'total',
						idProperty : 'PHEURowId',
						fields : ['PHEURowId', 'PHEUDesc'],
						remoteSort : true,
						sortInfo : {
							field : 'PHEURowId',
							direction : 'ASC'
						}
					})
			}]
	});
	var tbb = new Ext.Toolbar({
		id : 'tbb',
		items : [
			'提示消息',{
					xtype:'textfield',
					name : 'PDIAlertMsg',
					id : 'AlertMsg',
					width:240,
					readOnly : Ext.BDP.FunLib.Component.DisableFlag('AlertMsg'),
					style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('AlertMsg'))
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
		closable : true,
		store : dsWest,
		split:true,
		trackMouseOver : true,
		columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
				{
					header : 'PHEINRowId',
					sortable : true,
					dataIndex : 'PHEINRowId',
					hidden : true
				}, {
					header : '代码',
					sortable : true,
					dataIndex : 'PHEINCode'
				}, {
					header : '描述',
					sortable : true,
					dataIndex : 'PHEINDesc'
				}],
		stripeRows : true,
		title:'用法列表',
		width:360,
		viewConfig : {
			forceFit : true
		},
		columnLines : true, //在列分隔处显示分隔符
		//sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
		sm : new Ext.grid.CheckboxSelectionModel,
		bbar : pagingWest,
		tbar:tb,
		stateId : 'gridWest',
		listeners:{
			'render':function(){
				tbt.render(this.tbar);
				tbb.render(this.tbar);
			}
		}
	});
	/**未选列表双击行，添加到已选列表*/
	 /*gridWest.on("rowdblclick", function(grid, rowIndex, e){
	 	var PDIUseDR=gridWest.getSelectionModel().getSelected().get('PHEINRowId');//用法id
		var Mode=Ext.getCmp("Mode").getValue(); //管制级别
		var Type="PREMET";//知识库目录
		var OrderNum=0;//顺序
		var Gen=GenDr; //通用名  传
		//var Pointer=Pointer;//指针  传
		var PointerType=PointerType;//指针类型
		var Lib="DRUG";//知识库标识
		var ActiveFlag="Y";//是否可用
		var SysFlag="Y";//是否系统标识
		var ExcludeFlag = Ext.getCmp("ExcludeFlag").getValue();
		var Age = Ext.getCmp("Age").getValue();
		var MinVal = Ext.getCmp("PDAMinVal").getValue();
		var MaxVal = Ext.getCmp("PDAMaxVal").getValue();
		var UomDr = Ext.getCmp("PDAUomDrF").getValue();
		var useStr = PDIUseDR+"^"+Mode+"^"+Type+"^"+OrderNum+"^"+Gen+"^"+Pointer+"^"+PointerType+"^"+Lib+"^"+ActiveFlag+"^"+SysFlag+"^"+ExcludeFlag+"^"+Age+"^"+MinVal+"^"+MaxVal+"^"+UomDr;
		if (MinVal != "" && MaxVal != "") {
        			if (parseInt(MinVal)>parseInt(MaxVal)) {
        				Ext.Msg.show({
			        					title : '提示',
										msg : '年龄最小值不能大于年龄最大值!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
          			 		return;
      					}
   			 	}
		Ext.Ajax.request({
			url : SAVE_ACTION_URL , 		
			method : 'POST',	
			params : {
					'useStr' : useStr
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
								'PointerType':PointerType,
								'PointerDr':Pointer,
								start : 0,
								limit : pagesize_main
							}
						});
						gridWest.getStore().load({
							params : {
								'TypeDr':'',
								'GenDr':GenDr,
								'PointerType':PointerType,
								'PointerDr':Pointer,
								start : 0,
								limit : pagesize_main
							}
						});
//						Ext.getCmp("Mode").reset();
//						Ext.getCmp("ExcludeFlag").reset();
//						Ext.getCmp("Age").reset();
//						Ext.getCmp("PDAMinVal").reset();
//						Ext.getCmp("PDAMaxVal").reset();
//						Ext.getCmp("PDAUomDrF").reset();
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
	 })*/
/**********************************Center *************************************/
	 //年龄store
	var storeAge = new Ext.data.JsonStore({
		autoLoad : true,
		url : BindingAge,
		root : 'data',
		totalProperty : 'total',
		idProperty : 'PDARowID',
		fields : ['PDARowID', 'PDAAgeDesc'],
		remoteSort : true,
		sortInfo : {
			field : 'PDARowID',
			direction : 'ASC'
		}
	})
	//年龄单位store
	var storeAgeUom = new Ext.data.JsonStore({
		autoLoad : true,
		url : BindingAgeUom,
		root : 'data',
		totalProperty : 'total',
		idProperty : 'PHEURowId',
		fields : ['PHEURowId', 'PHEUDesc'],
		remoteSort : true,
		sortInfo : {
			field : 'PHEURowId',
			direction : 'ASC'
		}
	});
	/** grid 数据存储 */
	var dsCenter = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
		reader : new Ext.data.JsonReader({
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, [   {
							name : 'PHEINCode',
							mapping : 'PHEINCode',
							type : 'string'
						},{
							name : 'PHEINDesc',
							mapping : 'PHEINDesc',
							type : 'string'
						},{
							name : 'PHINSTMode',
							mapping : 'PHINSTMode',
							type : 'string'
						},{
							name : 'PDAAgeDesc',
							mapping : 'PDAAgeDesc',
							type : 'string'
						},{
							name : 'PDAMinVal',
							mapping : 'PDAMinVal',
							type : 'string'
						},{
							name : 'PDAMaxVal',
							mapping : 'PDAMaxVal',
							type : 'string'
						},{
							name : 'PDAUomDr',
							mapping : 'PDAUomDr',
							type : 'string'
						},{
							name : 'PDAAgeDr',
							mapping : 'PDAAgeDr',
							type : 'string'
						},{
							name : 'PDIExcludeFlag',
							mapping : 'PDIExcludeFlag',
							type : 'string'
						},{
							name : 'PDIAlertMsg',
							mapping : 'PDIAlertMsg',
							type : 'string'
						},{
							name : 'PDIRowId',
							mapping : 'PDIRowId',
							type : 'string'
						},{
							name : 'PDIInstDr',
							mapping : 'PDIInstDr',
							type : 'string'
						},{
							name : 'PDIUseDR',
							mapping : 'PDIUseDR',
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
			'PointerType':PointerType,
			'PointerDr':Pointer
		  }   
		)
	});
	/** grid 加载数据 */
	//grid加载之前加载可编辑下拉框
	storeAge.load();
	storeAgeUom.load();
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
					dataIndex : 'PHEINCode'
				},{
					header : '描述',
					sortable : true,
					dataIndex : 'PHEINDesc'
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
				},{
					header : '年龄',
					sortable : true,
					dataIndex : 'PDAAgeDr',
					//renderer使其显示dispaly值而不是value值
  					renderer : function(value, cellmeta, record) {
	  					//获取当前id="UomDr"的comboBox选择的值
	     				var index = storeAge.find(Ext.getCmp('AgeDr').valueField, value);
	    				var record = storeAge.getAt(index);
	    				var displayText = "";
	     				// 如果下拉列表没有被选择,那么record也就不存在,这时候,返回传进来的value
	     				// 而这个value就是grid的deal_with_name列的value,所以直接返回
	    				if (record == null) {
	    					//返回默认值
	    					displayText = value;
						} 
						else {
							displayText = record.data.PDAAgeDesc;//获取record中的数据集中的displayField字段的值
	     				}
	     				return displayText;
	     			},
					editor:new Ext.form.ComboBox({
						id : 'AgeDr',
						name : 'PDAAge',
						hiddenName : 'PDAAge',
						triggerAction : 'all',// query
						forceSelection : true,
						selectOnFocus : false,
						typeAhead : true,
						queryParam : "desc",
						mode : 'remote',
						pageSize : Ext.BDP.FunLib.PageSize.Combo,
						minChars : 0,
						listWidth : 230,
						valueField : 'PDARowID',
						displayField : 'PDAAgeDesc',
						store : storeAge
					})
				},{
					header : '年龄最小值',
					sortable : true,
					dataIndex : 'PDAMinVal',
					editor:new Ext.form.NumberField()
				},{
					header : '年龄最大值',
					sortable : true,
					dataIndex : 'PDAMaxVal',
					editor:new Ext.form.NumberField()
				},{
					header : '年龄单位',
					sortable : true,
					dataIndex : 'PDAUomDr',
					//renderer使其显示dispaly值而不是value值
  					renderer : function(value, cellmeta, record) {
	  					//获取当前id="UomDr"的comboBox选择的值
	     				var index = storeAgeUom.find(Ext.getCmp('UomDr').valueField, value);
	    				var record = storeAgeUom.getAt(index);
	    				var displayText = "";
	     				// 如果下拉列表没有被选择,那么record也就不存在,这时候,返回传进来的value
	     				// 而这个value就是grid的deal_with_name列的value,所以直接返回
	    				if (record == null) {
	    					//返回默认值
	    					displayText = value;
						} 
						else {
							displayText = record.data.PHEUDesc;//获取record中的数据集中的displayField字段的值
	     				}
	     				return displayText;
	     			},
					editor:new Ext.form.ComboBox({
	            		id :'UomDr',
	            		hiddenName: 'PDAUomDr',
	           			store:storeAgeUom  ,
	           			mode : 'local',
	           			shadow:false,
	  					forceSelection : true,
	  					triggerAction: 'all',  
	  					//lazyRender: true, //值为true时阻止ComboBox渲染直到该对象被请求
	  					displayField : 'PHEUDesc', 
	  					valueField : 'PHEURowId'
					})
				},{
					header : '年龄单位描述',
					sortable : true,
					dataIndex : 'PHEUDesc',
					hidden:true
				},{
					header : '年龄描述',
					sortable : true,
					dataIndex : 'PDAAgeDesc',
					hidden:true
				},{
					header : '禁忌',
					sortable : true,
					dataIndex : 'PDIExcludeFlag',
					renderer : Ext.BDP.FunLib.Component.ReturnFlagIcon,
					editor:new Ext.form.ComboBox({
						name : 'PDIExcludeFlag',
						hiddenName : 'PDIExcludeFlag',
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
								      ['Y','Yes'],
								      ['N','No']
							     ]
						})
					})
				},{
					header : '提示消息',
					sortable : true,
					dataIndex : 'PDIAlertMsg',
					editor:new Ext.form.TextField()
				},{
					header : 'PDIRowId',
					sortable : true,
					dataIndex : 'PDIRowId',
					hidden:true
				},{
					header : 'PDIInstDr',
					sortable : true,
					dataIndex : 'PDIInstDr',
					hidden:true
				},{
					header : 'PDIUseDR',
					sortable : true,
					dataIndex : 'PDIUseDR',
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
       			//var mode = e.value; //得到修改列修改后值
				var mode=record.get('PHINSTMode');
				var minVal=record.get('PDAMinVal');
				var maxVal=record.get('PDAMaxVal');
				var ageDr=record.get('PDAAgeDr');
				var uomDr=record.get('PDAUomDr');
				var flag=record.get('PDIExcludeFlag');
				var msg=record.get('PDIAlertMsg');
								
				if (minVal != "" && maxVal != "") {
        			if (parseInt(minVal)>parseInt(maxVal)) {
        				Ext.Msg.show({
			        					title : '提示',
										msg : '年龄最小值不能大于年龄最大值!',
										minWidth : 200,
										icon : Ext.Msg.ERROR,
										buttons : Ext.Msg.OK
									});
          			 		return;
      					}
   			 	}
                Ext.Ajax.request({
                   url: SAVE_MODE_URL,
                   method: "POST",
                   params: {
                       mode: mode,
                       ageDr:ageDr,
                       minVal:minVal,
                       maxVal:maxVal,
                       uomDr:uomDr,
                       flag:flag,
                       msg:msg,
                       id: record.get('PDIInstDr')
                   },
                   callback : function(options, success, response) {	
				   		if(success){
				   			var jsonData = Ext.util.JSON.decode(response.responseText);
				   				if (jsonData.success == 'true') {
				   					//保存成功后grid加载之前加载可编辑下拉框 防止下拉框搜索添加时，保存后显示为id而不是描述
			                   		storeAge.load();
			                   		storeAgeUom.load();
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
                   /*success: function(r) {
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
				'id' : gridCenter.getSelectionModel().getSelections()[0].get('PDIRowId')
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
							var id = gridCenter.getSelectionModel().getSelections()[0].get('PDIRowId');
						}
						
						gridCenter.getStore().load({
							params : {
									'TypeDr':'',
									'GenDr':GenDr,
									'PointerType':PointerType,
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
								'PointerType':PointerType,
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
	 })
	/** 布局 */
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [gridWest,gridCenter]
	});	

})
