/// 名称:知识库业务表 - 检验结果辅助诊断
/// 编写者:基础数据平台 - 高姗姗
/// 编写日期:2017-3-23
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHLibResultDiag";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCPHLibResultDiag";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHLibResultDiag&pClassMethod=DeleteData";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'qtip';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
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
	var formSearch = new Ext.form.FormPanel({
				title:'检验结果辅助诊断',
				id : 'form-save',
				frame:true,
				autoScroll:true,///滚动条
				border:false,
				region: 'center',
				width:500,
				plain : true,//true则主体背景透明
				//collapsible:true,
				split: true,
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 140,
				defaultType : 'textfield',
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PLRDRowId',mapping:'PLRDRowId',type:'string'},
                                        {name: 'PLRDInstDr',mapping:'PLRDInstDr',type:'string'},  
                                        {name: 'PLRDNormal',mapping:'PLRDNormal',type:'string'},  
                                        {name: 'PLRDHigh',mapping:'PLRDHigh',type:'string'},  
                                        {name: 'PLRDLow',mapping:'PLRDLow',type:'string'},  
                                        {name: 'PLRDNegative',mapping:'PLRDNegative',type:'string'},  
                                        {name: 'PLRDPositive',mapping:'PLRDPositive',type:'string'},  
                                        {name: 'PLRDOther',mapping:'PLRDOther',type:'string'},  
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
							fieldLabel : 'PLRDRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PLRDRowId'
						},{
							fieldLabel : 'PLRDInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PLRDInstDr'
						},{
							fieldLabel:'正常范围值',
							xtype : 'textarea',
							name : 'PLRDNormal',
							id:'PLRDNormalF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDNormalF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDNormalF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if (Ext.getCmp("PLRDNormalF").getValue()!=""){
										text[0]="正常范围值:"+Ext.getCmp("PLRDNormalF").getValue()+";";
									}else{
										text[0]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}*/				
						},{
							fieldLabel:'结果值升高',
							xtype : 'textarea',
							name : 'PLRDHigh',
							id:'PLRDHighF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDHighF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDHighF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if (Ext.getCmp("PLRDHighF").getValue()!=""){
										text[1]="结果值升高:"+Ext.getCmp("PLRDHighF").getValue()+";";
									}else{
										text[1]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}	*/							
						},{
							fieldLabel:'结果值降低',
							xtype : 'textarea',
							name : 'PLRDLow',
							id:'PLRDLowF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDLowF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDLowF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if (Ext.getCmp("PLRDLowF").getValue()!=""){
										text[2]="结果值降低:"+Ext.getCmp("PLRDLowF").getValue()+";";
									}else{
										text[2]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}	*/							
						},{
							fieldLabel:'结果值阴性',
							xtype : 'textarea',
							name : 'PLRDNegative',
							id:'PLRDNegativeF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDNegativeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDNegativeF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if (Ext.getCmp("PLRDNegativeF").getValue()!=""){
										text[3]="结果值阴性:"+Ext.getCmp("PLRDNegativeF").getValue()+";";
									}else{
										text[3]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}	*/							
						},{
							fieldLabel:'结果值阳性',
							xtype : 'textarea',
							name : 'PLRDPositive',
							id:'PLRDPositiveF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDPositiveF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDPositiveF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if (Ext.getCmp("PLRDPositiveF").getValue()!=""){
										text[4]="结果值阳性:"+Ext.getCmp("PLRDPositiveF").getValue()+";";
									}else{
										text[4]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}	*/							
						},{
							fieldLabel:'结果值其他',
							xtype : 'textarea',
							name : 'PLRDOther',
							id:'PLRDOtherF',
							validationEvent : 'blur',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('PLRDOtherF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('PLRDOtherF')),
   							width:300,
   							height : 60/*,
							listeners : {
								'blur' : function(){
									if(Ext.getCmp("PLRDOtherF").getValue()!=""){
										text[5]="结果值其他:"+Ext.getCmp("PLRDOtherF").getValue()+";";
									}else{
										text[5]="";
									}
									Ext.getCmp("PHINSTTextF").setValue(getStr(text));
								}
							}	*/							
						},{
							fieldLabel:'描述',
							xtype : 'textarea',
							name : 'PHINSTText',
							id:'PHINSTTextF',
							validationEvent : 'blur',
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
		      			var hasText=Ext.getCmp('PHINSTTextF').getValue();
						if (hasText=="") {
			    			Ext.Msg.show({ title : '提示', msg : '记录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
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
										'PHINSTPointerType':"Form",
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
					tooltip : '请选择一行后修改(Shift+D)',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('btn_UpdatePanel'),
					//disabled:true,
		      		handler: function (){
		      			
		      		if (grid.selModel.hasSelection()) {
		      			var hasText=Ext.getCmp('PHINSTTextF').getValue();
						if (hasText=="") {
			    			Ext.Msg.show({ title : '提示', msg : '记录不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
			    		}
		      			formSearch.form.submit({
								url : UPDATE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
									'PLRDInstDr': checkRowId
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
					tooltip : '请选择一行后删除(Shift+D)',
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
							PointerType:"Form",
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
								},{
									name : 'PLRDRowId',
									mapping : 'PLRDRowId',
									type : 'string'
								},{
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
						PointerType:"Form",
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
				split:true,
				closable : true,
				store : ds,
				trackMouseOver : true,
        		stripeRows: true,
        		enableColumnMove: true,     //允许拖放列
	    		enableColumnResize: false,  //禁止改变列的宽度
        		autoScroll: true,
				title : '检验结果辅助诊断',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHINSTRowId',
							sortable : true,
							dataIndex : 'PHINSTRowId',
							hidden : true
						},{
							header : 'PLRDRowId',
							sortable : true,
							dataIndex : 'PLRDRowId',
							hidden : true
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
						}],
				width:250,
        		viewConfig: {
					forceFit: true //自动延展每列的长度//若为ture,column里面设置的无效,autoExpandColumn不起作用
		   		 },
		   		columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				stateId : 'grid'
			});
	/** grid双击事件 */
	grid.on("rowclick", function(grid, rowIndex, e) {
				var _record = grid.getSelectionModel().getSelected();
				checkRowId= _record.get('PHINSTRowId')
				if (!_record) {
		
		        } else {
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('PHINSTRowId'),
		                success : function(form,action) {
		                	/**设置修改时描述的自动生成*/
		                	/*if (Ext.getCmp("PLRDNormalF").getValue()!=""){
		                		text[0]="正常范围值:"+Ext.getCmp("PLRDNormalF").getValue()+";";
		                	}
		                	if (Ext.getCmp("PLRDHighF").getValue()!=""){
								text[1]="结果值升高:"+Ext.getCmp("PLRDHighF").getValue()+";";
		                	}
		                	if (Ext.getCmp("PLRDLowF").getValue()!=""){
								text[2]="结果值降低:"+Ext.getCmp("PLRDLowF").getValue()+";";
		                	}
		                	if (Ext.getCmp("PLRDNegativeF").getValue()!=""){
								text[3]="结果值阴性:"+Ext.getCmp("PLRDNegativeF").getValue()+";";
		                	}
		                	if (Ext.getCmp("PLRDPositiveF")!=""){
								text[4]="结果值阳性:"+Ext.getCmp("PLRDPositiveF").getValue()+";";
		                	}
		                	if (Ext.getCmp("PLRDOtherF").getValue()!=""){
								text[5]="结果值其他:"+Ext.getCmp("PLRDOtherF").getValue()+";";
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