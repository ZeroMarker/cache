/// 名称:知识库业务表 - 配伍禁忌
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期:2014-12-5
/********************** treecombo控件 ****************************/
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/TreeCombox.js"> </script>');
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDrugContrain";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHDrugContrain";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassMethod=DeleteData";
	var Gen_Dr_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtGeneric&pClassQuery=GetDataForCmb1";
	var DRG_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb1";
	var TREE_COMBO_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibCat&pClassMethod=GetTreeProComboJson";
	var TEXT_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrugContrain&pClassMethod=GetText";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Taboo");
	
	//按商品名维护的时候才显示
	var drugHidden=""
	var drugHidden=""   //商品名显示与否
	if(PointerType=="ProName"){
		drugHidden=false
		genHidden=true
	}else{
		drugHidden=true
		genHidden=false
	}
	
	var comboTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: "ParentID",
		dataUrl: TREE_COMBO_URL
	});
	comboTreeLoader.on("beforeload", function(treeLoader, node) {  
		comboTreeLoader.baseParams.lib = "DRUG";
    }, this);
	/*var comboTreePanel = new Ext.tree.TreePanel({
			id: 'treeComboPanel',
			root: new Ext.tree.AsyncTreeNode({
					id:"CatTreeRoot",
					text:"分类",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
				}),
			loader: comboTreeLoader,
			//boxMaxHeight:30,
			autoScroll: true,
			containerScroll: true,
			rootVisible:false
		});
	var treeCombox = new Ext.tet.TreeComboField({
			name:'PDINTCatDr',
			id:'PDINTCatDrF',
			readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTCatDrF'),
			style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTCatDrF')),
			fieldLabel:"分类",
			hiddenName : 'PDINTCatDr',
			//anchor:"70%",
			width:200,
			editable : true,			
			enableKeyEvents: true,
			tree:comboTreePanel,
			validationEvent : 'blur',
          	listeners : {       		
   				'blur' : function(){
   						var cat=Ext.getCmp("PDINTCatDrF").getValue()
   						if(cat!=""){
   							Ext.getCmp("PDINTGenDrF").setValue("");
   							Ext.Ajax.request({											
										url:TEXT_ACTION_URL,
										method:'GET', 
										params:{
											'cat':cat
											},
										callback:function(options,success,response){
												    if(success){	
												    var jsonData=Ext.util.JSON.decode(response.responseText);
						    				 		var PDINTCatDesc=jsonData.PDINTCatDesc;
						    				 		//Ext.getCmp("PHINSTTextF").setValue("本品与"+PDINTCatDesc+"配伍禁忌:");
						  						 }
											}
								})	
   						}
		  								
					}
			}
		});*/
    var treeCombox = new Ext.ux.TreeCombo({  
		 id : 'PDINTCatDrF',
		 name:'PDINTCatDr', 
         width:300,
         fieldLabel:"分类",
         disabled : Ext.BDP.FunLib.Component.DisableFlag('PDINTCatDrF'),
         hiddenName : 'PDINTCatDr',  
         root : new Ext.tree.AsyncTreeNode({  
         			id:"CatTreeRoot",
					text:"分类",
					draggable:false,  //可拖拽的
					expanded:true  //根节点自动展开
                 }),  
         loader: comboTreeLoader,
         autoScroll: true,
		 containerScroll: true,
		 rootVisible:false,
		 enableKeyEvents: true,
		 validationEvent : 'blur',
         listeners : {       		
   				'select' : function(){
   						var cat=Ext.getCmp("PDINTCatDrF").getRawValue()
   						if(cat!=""){
   							Ext.getCmp("PDINTGenDrF").setValue("");
   							Ext.getCmp("PDINTDrugDrF").setValue("");
   							//Ext.getCmp("PHINSTTextF").setValue("本品与"+cat+"合用时:");
   						}
		  								
					}
			}
     });  
								
	var formSearch = new Ext.form.FormPanel({
				title:'配伍禁忌表单',
				id : 'form-save',
				frame:true,
				autoScroll:true,///滚动条
				border:false,
				region: 'center',
				width:500,
				plain : true,//true则主体背景透明
				bodyStyle:'overflow-y:auto;overflow-x:hidden;',
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 140,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PDINTRowId',mapping:'PDINTRowId',type:'string'},
                                        {name: 'PDINTInstDr',mapping:'PDINTInstDr',type:'string'},
                                        {name: 'PDINTType',mapping:'PDINTType',type:'string'},
                                        {name: 'PDINTFlag',mapping:'PDINTFlag',type:'string'},
                                        {name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                                        {name: 'PDINTGenDr',mapping:'PDINTGenDr',type:'string'},
                                        {name: 'PDINTCatDr',mapping:'PDINTCatDr',type:'string'},
                                        {name: 'PDINTDrugDr',mapping:'PDINTDrugDr',type:'string'},
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
							fieldLabel : 'PDINTRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDINTRowId'
						},{
							fieldLabel : 'PDINTInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PDINTInstDr'
						},{
							fieldLabel : 'PDINTType',
							hideLabel : 'True',
							hidden : true,
							name : 'PDINTType'
						},{
							xtype : 'combo',
							fieldLabel : '级别',
							name : 'PHINSTMode',
							hiddenName : 'PHINSTMode',
							id:'PHINSTModeF',
							value:mode,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTModeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTModeF')),
							width:300,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							editable: false	,
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['W','警示'],
									      ['C','管控'],
									      ['S','统计']
								     ]
							})
						},{
							fieldLabel: '医嘱标识',
				    		xtype:'radiogroup',
				    		defaultType:'radio',
							name :'PDINTFlag',
							id:'PDINTFlag',
							autoHeight:true,
							width:300,
							//layout:'column', //激活、未激活呈分列式排布,checked:true
							items:[{boxLabel:'组内',name:'PDINTFlag',inputValue:'1'},
								   {boxLabel:'组间',name:'PDINTFlag',inputValue:'2'},
								   {boxLabel:'全部',name:'PDINTFlag',inputValue:'3',checked:true}]
						},{
							fieldLabel : '通用名',
							hiddenName : 'PDINTGenDr',
							id:'PDINTGenDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							hidden:genHidden,
							hideLabel:genHidden,
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTGenDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTGenDrF')),
   							store : new Ext.data.Store({
										autoLoad: true,
										baseParams:{code:'DRUG'},
										proxy : new Ext.data.HttpProxy({ url : Gen_Dr_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHEGRowId',mapping:'PHEGRowId'},
										{name:'PHEGDesc',mapping:'PHEGDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PHEGDesc',
							valueField : 'PHEGRowId',
							
							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'select' : function(){
									if(Ext.getCmp("PDINTGenDrF").getValue()!=""){
										Ext.getCmp("PDINTCatDrF").setValue("");
										Ext.getCmp("PDINTDrugDrF").setValue("");
										//Ext.getCmp("PHINSTTextF").setValue("本品与"+Ext.getCmp("PDINTGenDrF").getRawValue()+"合用时:");
									}
								
								}
                            }
						},{
							fieldLabel : '商品名',
							hiddenName : 'PDINTDrugDr',
							id:'PDINTDrugDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							hidden:drugHidden,
							hideLabel:drugHidden,
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTDrugDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTDrugDrF')),
   							store : new Ext.data.Store({
										autoLoad: true,
										proxy : new Ext.data.HttpProxy({ url : DRG_QUERY_ACTION_URL}),
										reader : new Ext.data.JsonReader({
										totalProperty : 'total',
										root : 'data',
										successProperty : 'success'
									}, [{ name:'PHNRowId',mapping:'PHNRowId'},
										{name:'PHNDesc',mapping:'PHNDesc'} ])
								}),
							mode : 'local',
							shadow:false,
							queryParam : 'desc',
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							displayField : 'PHNDesc',
							valueField : 'PHNRowId',
							
							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'select' : function(){
									if(Ext.getCmp("PDINTDrugDrF").getValue()!=""){
										Ext.getCmp("PDINTCatDrF").setValue("");
										Ext.getCmp("PDINTGenDrF").setValue("");
										//Ext.getCmp("PHINSTTextF").setValue("本品与"+Ext.getCmp("PDINTDrugDrF").getRawValue()+"合用时:");
									}
								
								}
                            }
						},treeCombox,
						{
							fieldLabel : '描述',
							//allowBlank : false,
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHINSTTextF')),
   							width:300,
   							height : 120
						}
					],
				buttons: [{
					text: '添加',
					width: 100,
					id:'btn_SavePanel',
					iconCls : 'icon-add',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_SavePanel'),
		      		handler: function (){
		      			if(Ext.getCmp("PHINSTTextF").getValue()==""){
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
					//tooltip : '请选择一行后修改(Shift+D)',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){
		      			
		      		if (grid.selModel.hasSelection()) {
		      			if(Ext.getCmp("PHINSTTextF").getValue()==""){
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
									'PDINTRowId': checkRowId
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
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
					//tooltip : '请选择一行后删除(Shift+D)',
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
											'id' : rows[0].get('PDINTRowId')
										},
										callback : function(options, success, response) {
											if (success) {
												var jsonData = Ext.util.JSON.decode(response.responseText);
												if (jsonData.success == 'true') {
													Ext.getCmp("form-save").getForm().reset();
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
									name : 'PDINTRowId',
									mapping : 'PDINTRowId',
									type : 'string'
								}, {
									name : 'PHINSTMode',
									mapping : 'PHINSTMode',
									type : 'string'
								}, {
									name : 'PDINTGenDr',
									mapping : 'PDINTGenDr',
									type : 'string'
								},{
									name : 'PDINTCatDr',
									mapping : 'PDINTCatDr',
									type : 'string'
								}, {
									name : 'PHINSTText',
									mapping : 'PHINSTText',
									type : 'string'
								}// 列的映射
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
				split:true,
        		stripeRows: true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '配伍禁忌',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PDINTRowId',
							sortable : true,
							dataIndex : 'PDINTRowId',
							hidden : true
						}, {
							header : '级别',
							sortable : true,
							dataIndex : 'PHINSTMode',
							hidden : true
						}, {
							header : '通用名',
							sortable : true,
							dataIndex : 'PDINTGenDr',
							hidden : true
						},{
							header : '分类',
							sortable : true,
							dataIndex : 'PDINTCatDr',
							hidden : true
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
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
				checkRowId= _record.get('PDINTRowId')
				if (!_record) {
					//Ext.getCmp("btn_DeletePanel").setDisabled(true);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(true);
		
		        } else {
		        	//Ext.getCmp("btn_DeletePanel").setDisabled(false);
		        	//Ext.getCmp("btn_UpdatePanel").setDisabled(false);
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PDINTRowId'),
		                success : function(form,action) {
		                	var PDINTCatDesc=_record.get('PDINTCatDr');
                			Ext.get("PDINTCatDrF").dom.value = PDINTCatDesc;
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