/// 名称:知识库业务表 - 成分含量(g)
/// 编写者:基础平台组 - 高姗姗
/// 编写日期: 2016-11-23
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');

Ext.onReady(function() {
	Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'qtip';   
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHEleCon&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHEleCon&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHEleCon&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHEleCon";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHEleCon&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHEleCon";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHEleCon&pClassMethod=DeleteData";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtIngr&pClassMethod=GetTreeComboJson";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	                  
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	
	/*var text = new Array();
	function getStr(text){
		if(text.length<0) return "";
		var str="";
		for (var i = 0 ; i < text.length; i++){
			if(text[i]==undefined){
				text[i]="";
			}
			str=str+text[i];
		}
		return str;
	}*/
	var comboTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: "ParentID",
		dataUrl: TREE_COMBO_URL
	});
	var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'PHECPHExtIngrF',
         fieldLabel:"单支成分含量",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('PHECPHExtIngrF'),
         name:'PHECPHExtIngr',
         hiddenName : 'PHECPHExtIngr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"成分",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: comboTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false/*,
		 listeners : {
			'select' : function(){
				text[0]="单支成分含量:"+Ext.getCmp("PHECPHExtIngrF").getRawValue();
				var relation = tkMakeServerCall("web.DHCBL.KB.DHCPHExtIngr","GetRelation",Ext.getCmp("PHECPHExtIngrF").getValue(),"");
				if (relation.split("^")[0]!=""){
					Ext.getCmp("PHECRelationF").setValue(relation.split("^")[0])
					text[3]="浓度"+Ext.getCmp("PHECRelationF").getRawValue();
				}else{
					Ext.getCmp("PHECRelationF").setValue("");
					text[3]="";
				}
				if (relation.split("^")[1]!=""){
					Ext.getCmp("PHECTotalQtyF").setValue(relation.split("^")[1])
					text[4]=Ext.getCmp("PHECTotalQtyF").getValue();
				}else{
					Ext.getCmp("PHECTotalQtyF").setValue("")
					text[4]="";
				}
				Ext.getCmp("PHINSTTextF").setValue(getStr(text));
			}
		}	*/
     });  				
	var formSearch = new Ext.form.FormPanel({
				title:'成分含量(g)表单',
				id : 'form-save',
				frame:true,
				autoScroll:true,///滚动条
				border:false,
				region: 'center',
				width:500,
				//iconCls:'icon-find',
				plain : true,//true则主体背景透明
				//collapsible:true,
				split: true,
				bodyStyle:'overflow-y:auto;overflow-x:hidden;',
				//baseCls:'x-plain',
				buttonAlign:'center',
				labelAlign : 'right',
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PHECRowId',mapping:'PHECRowId',type:'string'},
                                        {name: 'PHECInstDr',mapping:'PHECInstDr',type:'string'},
                                        {name: 'PHECPHExtIngr',mapping:'PHECPHExtIngr',type:'string'},
                                        {name: 'PHECIngrQty',mapping:'PHECIngrQty',type:'string'},
                                        {name: 'PHECUomDr',mapping:'PHECUomDr',type:'string'},
                                        {name: 'PHECRelation',mapping:'PHECRelation',type:'string'},
                                        {name: 'PHECTotalQty',mapping:'PHECTotalQty',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        
                                        {name: 'PHINSTTypeDr',mapping:'PHINSTTypeDr',type:'string'},
                                        {name: 'PHINSTOrderNum',mapping:'PHINSTOrderNum',type:'string'},
                                        {name: 'PHINSTGenDr',mapping:'PHINSTGenDr',type:'string'},
                                        {name: 'PHINSTPointerDr',mapping:'PHINSTPointerDr',type:'string'},
                                        {name: 'PHINSTLibDr',mapping:'PHINSTLibDr',type:'string'},
                                        {name: 'PHINSTPointerType',mapping:'PHINSTPointerType',type:'string'},
                                        {name: 'PHINSTActiveFlag',mapping:'PHINSTActiveFlag',type:'string'},
                                        {name: 'PHINSTSysFlag',mapping:'PHINSTSysFlag',type:'string'}

                                 ]),
		
				items:[{
					layout : 'column',
					border : false,
					items : [{
								width : 250,
								layout : 'form',
								labelWidth : 100,
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [treeCombox]
							},{
								width : 60,
								labelWidth :1,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype : 'textfield',
									name : 'PHECIngrQty',
									id:'PHECIngrQtyF',
									regex: /^\d+(\.\d+)?$/, 
									regexText:"请输入浮点数！", 
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECIngrQtyF'),
		   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECIngrQtyF'))/*,
									listeners : {
										'blur' : function(){
											text[1]=Ext.getCmp("PHECIngrQtyF").getValue();
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}*/	
								}]
							},{
								width : 95,
								labelWidth :1,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype:'combo',
									name : 'PHECUomDr',
									id : 'PHECUomDrF',
									hiddenName : 'PHECUomDr',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECUomDrF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECUomDrF')),
									triggerAction : 'all',// query
									forceSelection : true,
									selectOnFocus : false,
									typeAhead : true,
									queryParam : "desc",
									mode : 'remote',
									pageSize : Ext.BDP.FunLib.PageSize.Combo,
									minChars : 0,
									listWidth : 200,
									valueField : 'PHEURowId',
									displayField : 'PHEUDesc',
									store : new Ext.data.JsonStore({
										autoLoad : true,
										url : BindingUom,
										root : 'data',
										totalProperty : 'total',
										idProperty : 'PHEURowId',
										fields : ['PHEURowId', 'PHEUDesc'],
										remoteSort : true,
										sortInfo : {
											field : 'PHEURowId',
											direction : 'ASC'
										}
									})/*,
									listeners : {
										'blur' : function(){
											text[2]=Ext.getCmp("PHECUomDrF").getRawValue()+";";
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}	*/
								}]
							}/*,{
								width : 170,
								labelWidth : 90,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype : 'combo',
									fieldLabel : '/整组液体量(ml)',
									name : 'PHECRelation',
									hiddenName : 'PHECRelation',
									id:'PHECRelationF',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECRelationF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECRelationF')),
									editable:false,
									width : 100,
									labelWidth:30,
									mode : 'local',
									triggerAction : 'all',// query
									valueField : 'value',
									displayField : 'name',
									store:new Ext.data.SimpleStore({
										fields:['value','name'],
										data:[
											      ['>','大于'],
											      ['<','小于'],
											      ['=','等于'],
											      ['!>','不大于'],
											      ['!<','不小于'],
											      ['<>','不等于']
										     ]
									}),
									listeners : {
										'blur' : function(){
											text[3]="浓度"+Ext.getCmp("PHECRelationF").getRawValue();
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}	
								}]
							},{
								width : 50,
								labelWidth : 1,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype : 'textfield',
									name : 'PHECTotalQty',
									id:'PHECTotalQtyF',
									regex: /^\d+(\.\d+)?$/, 
									regexText:"请输入浮点数！", 
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECTotalQtyF'),
		   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECTotalQtyF')),
									listeners : {
										'blur' : function(){
											text[4]=Ext.getCmp("PHECTotalQtyF").getValue();
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}	
								}]
							}*/]
						},{
							layout : 'column',
							border : false,
							items : [{
								width : 250,
								labelWidth : 100,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype : 'combo',
									fieldLabel : '/整组液体量(ml)',
									name : 'PHECRelation',
									hiddenName : 'PHECRelation',
									id:'PHECRelationF',
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECRelationF'),
									style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECRelationF')),
									editable:false,
									//width : 100,
									//labelWidth:30,
									mode : 'local',
									triggerAction : 'all',// query
									valueField : 'value',
									displayField : 'name',
									store:new Ext.data.SimpleStore({
										fields:['value','name'],
										data:[
											      ['>','大于'],
											      ['<','小于'],
											      ['=','等于'],
											      ['!>','不大于'],
											      ['!<','不小于'],
											      ['<>','不等于']
										     ]
									}),
									listeners : {
										'blur' : function(){
											text[3]="浓度"+Ext.getCmp("PHECRelationF").getRawValue();
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}	
								}]
							},{
								width : 160,
								labelWidth : 1,
								layout : 'form',
								labelPad : 1,// 默认5
								border : false,
								defaults : {
									anchor : '96%'
								},
								items : [{
									xtype : 'textfield',
									name : 'PHECTotalQty',
									id:'PHECTotalQtyF',
									regex: /^\d+(\.\d+)?$/, 
									regexText:"请输入浮点数！", 
									readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHECTotalQtyF'),
		   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHECTotalQtyF')),
									listeners : {
										'blur' : function(){
											text[4]=Ext.getCmp("PHECTotalQtyF").getValue();
											Ext.getCmp("PHINSTTextF").setValue(getStr(text));
										}
									}	
								}]
							}]
						},{
							fieldLabel:'描述',
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:300,
   							height : 120
						},{
							fieldLabel : 'PHECRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHECRowId'
						},{
							fieldLabel : 'PHECInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PHECInstDr'
						}
					],
				buttons: [{
					text: '添加',
					width: 100,
					id:'btn_SavePanel',
					iconCls : 'icon-add',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_SavePanel'),
		      		handler: function (){
		      			if((Ext.getCmp("PHECPHExtIngrF").getValue()=="")||(Ext.getCmp("PHINSTTextF").getValue()=="")){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
		      			}
						formSearch.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
	                                 //主索引表必填项
										//'PHINSTTypeDr' :"9",
										'PHINSTOrderNum' :"1",
										'PHINSTGenDr' :GenDr,
										'PHINSTPointerDr' :PointerDr,
										//'PHINSTLibDr' :"25",
										'PHINSTPointerType':PointerType,
										'PHINSTActiveFlag' :"Y",
										'PHINSTSysFlag' :"Y"
									
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										//text.length=0;
										Ext.Msg.show({
													title : '提示',
													msg : '添加成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
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
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '添加失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '添加失败！');
								}
							})
		      			
		      			
		      			
		      	} 
				},{
					text: '修改',
					width: 100,
					id:'btn_UpdatePanel',
					iconCls : 'icon-update',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){	      			
		      		if (grid.selModel.hasSelection()) {
		      			if((Ext.getCmp("PHECPHExtIngrF").getValue()=="")||(Ext.getCmp("PHINSTTextF").getValue()=="")){
		      				Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
		      			}
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PHECInstDr': checkRowId
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										//text.length=0;
										var myrowid = "rowid=" + action.result.id;
										Ext.Msg.show({
													title : '提示',
													msg : '修改成功！',
													icon : Ext.Msg.INFO,
										
													buttons : Ext.Msg.OK,
														fn : function(btn) {
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
										if (action.result.errorinfo) {
											errorMsg = '<br/>错误信息:'+ action.result.errorinfo
										}
										Ext.Msg.show({
													title : '提示',
													msg : '修改失败！' + errorMsg,
													minWidth : 200,
													icon : Ext.Msg.ERROR,
													buttons : Ext.Msg.OK
												});
									}
								},
								failure : function(form, action) {
									Ext.Msg.alert('提示', '修改失败！');
								}
							})
		      		}else {
							Ext.Msg.show({
										title : '提示',
										msg : '请选择需要修改的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
		      		} 
		      		
				},{
					text: '删除',
					width: 100,
					id:'btn_DeletePanel',
					iconCls : 'icon-delete',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_DeletePanel'),
					//disabled : true,
		      		handler : function DelData() {
						if (grid.selModel.hasSelection()) {
							Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
								if (btn == 'yes') {
									Ext.MessageBox.wait('数据删除中,请稍候...', '提示');
									var gsm = grid.getSelectionModel();// 获取选择列
									var rows = gsm.getSelections();// 根据选择列获取到所有的行
									
									Ext.Ajax.request({
										url : DELETE_ACTION_URL,
										method : 'POST',
										params : {
											'id' : rows[0].get('PHINSTRowId')
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													Ext.getCmp("form-save").getForm().reset();
													//text.length=0;
													Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
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
															grid.getStore().load({
																		params : {
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
						} else {
							Ext.Msg.show({
										title : '提示',
										msg : '请选择需要删除的行!',
										icon : Ext.Msg.WARNING,
										buttons : Ext.Msg.OK
									});
						}
					}  		
				},
				{
					text: '重置',
					width: 100,
					id:'btn_RefreshPanel',
					iconCls : 'icon-refresh',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_RefreshPanel'),
		      		handler: function (){
		      			Ext.getCmp("form-save").getForm().reset();	
		      			//text.length=0;
		      			grid.getStore().baseParams={
		      				TypeDr : "",
							GenDr: GenDr,
							PointerType:PointerType,
							PointerDr:PointerDr
		      			};
						grid.getStore().load({
								params : {
											start : 0,
											limit : pagesize_main
										}
								});
						}	
						
				}]
	});
	
    
   /** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'PHINSTRowId',
									mapping : 'PHINSTRowId',
									type : 'string'
								}, {
									name : 'PHINSTText',
									mapping : 'PHINSTText',
									type : 'string'
								}, {
									name : 'PHECPHExtIngr',
									mapping : 'PHECPHExtIngr',
									type : 'string'
								}, {
									name : 'PHEINGDesc',
									mapping : 'PHEINGDesc',
									type : 'string'
								}
						])
			});
	/** grid数据加载遮罩 */
	var loadMarsk = new Ext.LoadMask(document.body,{
						msg : '数据加载中,请稍后...',
						disabled : false,
						store : ds
					});
	ds.baseParams={			
					TypeDr : "",
					GenDr: GenDr, 
					PointerType:PointerType,
					PointerDr:PointerDr 
				};
	/** grid加载数据 */
	ds.load({
				params : {
					start : 0,
					limit : pagesize_main
				},
				callback : function(records, options, success) {
				}
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

	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'west',
				closable : true,
				store : ds,
				trackMouseOver : true,
        		stripeRows: true,
        		split:true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '成分含量(g)',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHINSTRowId',
							sortable : true,
							dataIndex : 'PHINSTRowId',
							hidden : true
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
						},{
							header : '成分Dr',
							sortable : true,
							dataIndex : 'PHECPHExtIngr',
							hidden : true
						},{
							header : '成分',
							sortable : true,
							dataIndex : 'PHEINGDesc',
							hidden : true
						}],
				width:200,
        		viewConfig: {
					forceFit: true //自动延展每列的长度//若为ture,column里面设置的无效,autoExpandColumn不起作用
		   		 },
		   		columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				//tbar : tb,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	/** grid单击事件 */
	grid.on("rowclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				checkRowId= _record.get('PHINSTRowId')
				if (!_record) {
					//Ext.getCmp("btn_DeletePanel").setDisabled(true);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(true);
		
		        } else {
		        	//Ext.getCmp("btn_DeletePanel").setDisabled(false);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(false);
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {
		                	var PHEINGDesc=_record.get('PHEINGDesc');
                			Ext.get("PHECPHExtIngrF").dom.value = PHEINGDesc;
		                	/*if (Ext.getCmp("PHECPHExtIngrF").getValue()!=""){
		                		text[0]="单支成分含量:"+Ext.getCmp("PHECPHExtIngrF").getRawValue();
		                	}
		                	if (Ext.getCmp("PHECIngrQtyF").getValue()!=""){
		                		text[1]=Ext.getCmp("PHECIngrQtyF").getValue();
		                	}
							if (Ext.getCmp("PHECUomDrF").getValue()!=""){
								text[2]=Ext.getCmp("PHECUomDrF").getRawValue()+";";
							}
							if (Ext.getCmp("PHECRelationF").getValue()!=""){
								text[3]="浓度"+Ext.getCmp("PHECRelationF").getRawValue();
							}
							if (Ext.getCmp("PHECTotalQtyF").getValue()!=""){
								text[4]=Ext.getCmp("PHECTotalQtyF").getValue();
							}*/
		                },
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
		        }
			});
	 //用Viewport可自适应高度跟宽度
    var viewport = new Ext.Viewport({
        enableTabScroll: true,
        layout: 'border',
        items: [formSearch,grid]
    });
	
	});