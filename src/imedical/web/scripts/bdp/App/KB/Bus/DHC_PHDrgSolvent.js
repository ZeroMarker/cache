/// 名称:知识库业务表 - 浓度
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期: 2016-10-11
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgSolvent&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgSolvent&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgSolvent&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHDrgSolvent";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgSolvent&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHDrgSolvent";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHDrgSolvent&pClassMethod=DeleteData";
	var DRG_QUERY_ACTION_URL= "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHProName&pClassQuery=GetDataForCmb1";
	var BindingUom = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHExtUom&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
	var PointerType = Ext.BDP.FunLib.getParam("GlPPointerType"); 
	var mode = tkMakeServerCall("web.DHCBL.KB.DHCPHInstLabel","GetManageMode","Solvent");
	
	//最小值
	var PDINTDosageMin= new Ext.BDP.FunLib.Component.TextField({ 
		fieldLabel : '浓度范围',
		name : 'PDINTDosageMin',
		id : 'PDINTDosageMinF',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageMinF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageMinF'))
	});
	//最大值
	var PDINTDosageMax= new Ext.BDP.FunLib.Component.TextField({ 
		name : 'PDINTDosageMax',
		id : 'PDINTDosageMaxF',
		disabled:true,
		readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageMaxF'),
		style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageMaxF'))
	});

					
	var formSearch = new Ext.form.FormPanel({
				title:'浓度表单',
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
				labelWidth : 100,
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PDINTRowId',mapping:'PDINTRowId',type:'string'},
                                        {name: 'PDINTInstDr',mapping:'PDINTInstDr',type:'string'},
                                        {name: 'PHINSTMode',mapping:'PHINSTMode',type:'string'},
                                        {name: 'PDINTMustUomDr',mapping:'PDINTMustUomDr',type:'string'},
                                        {name: 'PDINTRelation',mapping:'PDINTRelation',type:'string'},
                                        {name: 'PDINTDosage',mapping:'PDINTDosage',type:'string'},
                                        {name: 'PDINTDrgDr',mapping:'PDINTDrgDr',type:'string'},
                                        {name: 'PHINSTText',mapping:'PHINSTText',type:'string'},
                                        {name: 'PDINTDosageMin',mapping:'PDINTDosageMin',type:'string'},
                                        {name: 'PDINTDosageMax',mapping:'PDINTDosageMax',type:'string'},
                                        
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
							fieldLabel : '关联溶媒药品',
							hiddenName : 'PDINTDrgDr',
							id:'PDINTDrgDrF',
							xtype : 'bdpcombo',
							pageSize : Ext.BDP.FunLib.PageSize.Combo,
							loadByIdParam : 'rowid',
							width:300,
							emptyText:'请选择',
							//allowBlank:false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTDrgDrF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTDrgDrF')),
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
									if(Ext.getCmp("PDINTDrgDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("本品可溶于"+Ext.getCmp("PDINTRelationF").getRawValue()+Ext.getCmp("PDINTDosageF").getValue()+Ext.getCmp("PDINTMustUomDrF").getRawValue()+Ext.getCmp("PDINTDrgDrF").getRawValue());
									}
								
								}
                            }
						},{
							xtype : 'combo',
							fieldLabel : '逻辑',
							name : 'PDINTRelation',
							hiddenName : 'PDINTRelation',
							id:'PDINTRelationF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTRelationF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTRelationF')),
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
									      ['<>','不等于'],
									      ['><','区间']
								     ]
							}),
							listeners : {
								'blur' : function(){
									if(Ext.getCmp("PDINTDrgDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("本品可溶于"+Ext.getCmp("PDINTRelationF").getRawValue()+Ext.getCmp("PDINTDosageF").getValue()+Ext.getCmp("PDINTMustUomDrF").getRawValue()+Ext.getCmp("PDINTDrgDrF").getRawValue());
									}
								
								},
								'select' : function(){
									if(Ext.getCmp("PDINTRelationF").getValue()=="><"){
										Ext.getCmp('PDINTDosageMaxF').enable();
										Ext.getCmp('PDINTDosageMinF').enable();
										Ext.getCmp('PDINTDosageF').disable();									
									}else{
										Ext.getCmp('PDINTDosageMaxF').disable();
										Ext.getCmp('PDINTDosageMinF').disable();
										Ext.getCmp('PDINTDosageF').enable();
									}
								
								}
							}	
						},{
							fieldLabel:'单支溶媒量',
							xtype : 'textfield',
							name : 'PDINTDosage',
							id:'PDINTDosageF',
							width:300,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTDosageF')),
   							enableKeyEvents : true,
                         	validationEvent : 'blur',
                            listeners : {
								'blur' : function(){
									if(Ext.getCmp("PDINTDrgDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("本品可溶于"+Ext.getCmp("PDINTRelationF").getRawValue()+Ext.getCmp("PDINTDosageF").getValue()+Ext.getCmp("PDINTMustUomDrF").getRawValue()+Ext.getCmp("PDINTDrgDrF").getRawValue());
									}
								
								}
                            }
   							
						},{
							layout : 'column',
							border : false,
							items:[{
									width:230,
									layout : 'form',
									labelWidth : 80,
									labelPad : 1,// 默认5
									border : false,
									style:'margin-left:21px', 
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [PDINTDosageMin]
								},{
									width:5,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%'
									},
									items : [{fieldLabel:'-',labelSeparator:''}]
								},{
									width:150,
									layout : 'form',
									labelWidth : 5,
									labelPad : 1,// 默认5
									border : false,
									defaults : {
										anchor : '96%',
										xtype : 'textfield',
										msgTarget : 'under'
									},
									items : [PDINTDosageMax]
								}]	
						},{
							fieldLabel:'单位',
							xtype:'combo',
							name : 'PDINTMustUomDr',
							id : 'PDINTMustUomDrF',
							hiddenName : 'PDINTMustUomDr',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PDINTMustUomDrF'),
							style : Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PDINTMustUomDrF')),
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
									if(Ext.getCmp("PDINTDrgDrF").getValue()!=""){
										//Ext.getCmp("PHINSTTextF").setValue("本品可溶于"+Ext.getCmp("PDINTRelationF").getRawValue()+Ext.getCmp("PDINTDosageF").getValue()+Ext.getCmp("PDINTMustUomDrF").getRawValue()+Ext.getCmp("PDINTDrgDrF").getRawValue());
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
				      					Ext.getCmp('PDINTDosageMaxF').disable();
										Ext.getCmp('PDINTDosageMinF').disable();
										Ext.getCmp('PDINTDosageF').enable();										
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
									'PDINTInstDr': checkRowId
								},
								success : function(form, action) {
									if (action.result.success == 'true') {
										Ext.getCmp("form-save").getForm().reset();
										Ext.getCmp('PDINTDosageMaxF').disable();
										Ext.getCmp('PDINTDosageMinF').disable();
										Ext.getCmp('PDINTDosageF').enable();
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
													Ext.getCmp('PDINTDosageMaxF').disable();
													Ext.getCmp('PDINTDosageMinF').disable();
													Ext.getCmp('PDINTDosageF').enable();
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
      					Ext.getCmp('PDINTDosageMaxF').disable();
						Ext.getCmp('PDINTDosageMinF').disable();
						Ext.getCmp('PDINTDosageF').enable();
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
				title : '浓度',
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
		                	/**设置检验项目是否可用**/
							if(action.result.data.PDINTRelation=="><"){
								Ext.getCmp('PDINTDosageMaxF').enable();
								Ext.getCmp('PDINTDosageMinF').enable();
								Ext.getCmp('PDINTDosageF').disable();									
							}else{
								Ext.getCmp('PDINTDosageMaxF').disable();
								Ext.getCmp('PDINTDosageMinF').disable();
								Ext.getCmp('PDINTDosageF').enable();
							}
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