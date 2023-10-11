/// 名称:知识库业务表 - 联合用药
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期: 2016-10-11
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMustDrug&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHMustDrug&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMustDrug&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHMustDrug";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHMustDrug&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHMustDrug";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHMustDrug&pClassMethod=DeleteData";
	var DRG_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb1";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
					
	var formSearch = new Ext.form.FormPanel({
				title:'联合用药表单',
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
				labelWidth : 140,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PHMDRowId',mapping:'PHMDRowId',type:'string'},
                                        {name: 'PHMDInstDr',mapping:'PHMDInstDr',type:'string'},
                                        {name: 'PHMDMustDrugDr',mapping:'PHMDMustDrugDr',type:'string'},
                                        {name: 'PHMDMustUomDr',mapping:'PHMDMustUomDr',type:'string'},
                                        {name: 'PHMDRelation',mapping:'PHMDRelation',type:'string'},
                                        {name: 'PHMDMustQty',mapping:'PHMDMustQty',type:'string'},
                                        {name: 'PHMDAssDrugDr',mapping:'PHMDAssDrugDr',type:'string'},
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
							fieldLabel : 'PHMDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PHMDRowId'
						},{
							fieldLabel : 'PHMDInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PHMDInstDr'
						},{
							fieldLabel : '关联液体',
							hiddenName : 'PHMDAssDrugDr',
							id:'PHMDAssDrugDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMDAssDrugDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMDAssDrugDrF')),
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
								'blur' : function(){
									if(Ext.getCmp("PHMDAssDrugDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品"+Ext.getCmp("PHMDAssDrugDrF").getRawValue()+"输液就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
									else{
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
								
								}
                            }
						},{
							fieldLabel : '必用药品名称',
							hiddenName : 'PHMDMustDrugDr',
							id:'PHMDMustDrugDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMDMustDrugDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMDMustDrugDrF')),
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
								'blur' : function(){
									if(Ext.getCmp("PHMDAssDrugDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品"+Ext.getCmp("PHMDAssDrugDrF").getRawValue()+"输液就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
									else{
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
								
								}
                            }
						},{
							xtype : 'combo',
							fieldLabel : '限定',
							name : 'PHMDRelation',
							hiddenName : 'PHMDRelation',
							id:'PHMDRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMDRelationF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMDRelationF')),
							editable:false,
							width:300,
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
									if(Ext.getCmp("PHMDAssDrugDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品"+Ext.getCmp("PHMDAssDrugDrF").getRawValue()+"输液就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
									else{
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
								
								}
							}	
						},{
							fieldLabel:'必用药品剂量',
							xtype : 'textfield',
							name : 'PHMDMustQty',
							id:'PHMDMustQtyF',
							width:300,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMDMustQtyF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMDMustQtyF')),
   							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHMDAssDrugDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品"+Ext.getCmp("PHMDAssDrugDrF").getRawValue()+"输液就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
									else{
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
								
								}
                            }
   							
						},{
							fieldLabel:'单位',
							xtype:'combo',
							name : 'PHMDMustUomDr',
							id : 'PHMDMustUomDrF',
							hiddenName : 'PHMDMustUomDr',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PHMDMustUomDrF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PHMDMustUomDrF')),
							triggerAction : 'all',// query
							forceSelection : true,
							selectOnFocus : false,
							//typeAhead : true,
							queryParam : "desc",
							mode : 'remote',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							minChars : 0,
							width:300,
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
							}),
							listeners : {
								'blur' : function(){
									if(Ext.getCmp("PHMDAssDrugDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品"+Ext.getCmp("PHMDAssDrugDrF").getRawValue()+"输液就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
									else{
										//Ext.getCmp("PHINSTTextF").setValue("使用该药品就必须使用"+Ext.getCmp("PHMDRelationF").getRawValue()+Ext.getCmp("PHMDMustQtyF").getValue()+Ext.getCmp("PHMDMustUomDrF").getRawValue()+Ext.getCmp("PHMDMustDrugDrF").getRawValue());
									}
								
								}
							}	
						},{
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
									'PHMDInstDr': checkRowId
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
											'id' : rows[0].get('PHINSTRowId')
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
									name : 'PHINSTRowId',
									mapping : 'PHINSTRowId',
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
        		stripeRows: true,
        		split:true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '联合用药',
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