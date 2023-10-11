/// 名称:检验项目编辑器 - 注意事项 AdverseReactions
/// 编写者:基础平台组 - 谷雪萍
/// 编写日期:2015-1-5
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/BDPComboBox.js"> </script>');

Ext.onReady(function() {
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassQuery=GetList";
  	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=OpenData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCCheckMHA";
	var UPDATE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=UpdateData&pEntityName=web.Entity.KB.DHCCheckMHA";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=DeleteData";
	var ORDER_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=SaveOrder";
	var DRAG_ORDER_ACTION_URL="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCCheckMHA&pClassMethod=SaveDragOrder";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.form.Field.prototype.msgTarget = 'under';                         //--------设置消息提示方式为在下边显示
	var checkRowId="";
	var GenDr = Ext.BDP.FunLib.getParam("GlPGenDr"); 
	var PointerDr = Ext.BDP.FunLib.getParam("GlPPointer"); 
					
	var formSearch = new Ext.form.FormPanel({
				title:'注意事项',
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
				buttonAlign:'center',
				labelAlign : 'right',
				labelWidth : 140,
				defaultType : 'textfield',
				reader: new Ext.data.JsonReader({root:'list'},
		                             [
                                        {name: 'PDAIRowId',mapping:'PDAIRowId',type:'string'},
                                        {name: 'PDAIInstDr',mapping:'PDAIInstDr',type:'string'},                                                                          
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
							fieldLabel : 'PDAIRowId',
							hideLabel : 'True',
							hidden : true,
							name : 'PDAIRowId'
						},{
							fieldLabel : 'PDAIInstDr',
							hideLabel : 'True',
							hidden : true,
							name : 'PDAIInstDr'
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
			    			Ext.Msg.show({ title : '提示', msg : '描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          		return;
			    		}
		      			var  ordNum = grid.store.getCount()+1
						formSearch.form.submit({
								url : SAVE_ACTION_URL,
								clientValidation : true,
								waitTitle : '提示',
								waitMsg : '正在提交数据请稍候...',
								method : 'POST', 
								params : {
										'PDAIOrdNum':ordNum,
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
		      			var hasText=Ext.getCmp('PHINSTTextF').getValue();
						if (hasText=="") {
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
									'PDAIInstDr': checkRowId
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
									name : 'PDAIRowId',
									mapping : 'PDAIRowId',
									type : 'string'
								},{
									name : 'PDAICode',
									mapping : 'PDAICode',
									type : 'string'
								},{
									name : 'PDAIText',
									mapping : 'PDAIText',
									type : 'string'
								},{
									name : 'PDAIOrdNum',
									mapping : 'PDAIOrdNum',
									type : 'string'
								},{
									name : 'PHINSTText',
									mapping : 'PHINSTText',
									type : 'string'
								}// 列的映射
						]),
						sortInfo: {field: 'PDAIOrdNum', direction: 'asc'}
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
				title : '注意事项',
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'PHINSTRowId',
							sortable : true,
							dataIndex : 'PHINSTRowId',
							hidden : true
						},{
							header : 'PDAIRowId',
							sortable : true,
							dataIndex : 'PDAIRowId',
							hidden : true
						},{
							header : '代码',
							sortable : true,
							dataIndex : 'PDAICode',
							width:150,
							hidden : true
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PDAIText',
							width:200,
							hidden : true
						},{
							header : '顺序',
							sortable : true,
							dataIndex : 'PDAIOrdNum',
							hidden : true
							//width:250
						},{
							header : '描述',
							sortable : true,
							dataIndex : 'PHINSTText'
						},{
				           	header:"上移/下移",
							dataIndex : 'PINLRowID',
				            width:50,
				            renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
				            			var formatStr1 = '<img src="../scripts/bdp/Framework/imgs/up.gif" onclick="javascript:return false;" class="upBtn" ></img>';   
				         				var resultStr1 = String.format(formatStr1); 
				         				var formatStr2 = '<img src="../scripts/bdp/Framework/imgs/down.gif" onclick="javascript:return false;" class="downBtn" ></img>';   
				         				var resultStr2 = String.format(formatStr2);
				         				if(rowIndex==0){
				         					value ='<div>'+resultStr2+'</div>';
				         				}
				         				else if(rowIndex==grid.store.getCount()-1){
				         					value ='<div>'+resultStr1+'</div>';
				         				}
				         				else{
				         					value='<div>' + resultStr1 +" / " +resultStr2+'</div>';
				         				}
				         				if(grid.store.getCount()==1){
				         					value=""
				         				}	
				         				return value	            	
				            }.createDelegate(this)
				        }],
				width:250,
        		viewConfig: {
					forceFit: true //自动延展每列的长度//若为ture,column里面设置的无效,autoExpandColumn不起作用
		   		 },
		   		columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				stateId : 'grid',
				
				enableDragDrop : true,
    			ddGroup: "GridDD",
				listeners : {
			        'afterrender' : function() {		        		
			            var ddrow = new Ext.dd.DropTarget(grid.container, {  
			                ddGroup : 'GridDD',  
			                copy    : false,  
			                notifyDrop : function(dd, e, data) {		                
			                    var rows = data.selections;  
			                    var index = dd.getDragData(e).rowIndex;
			                    var rowid =rows[0].get('PDAIRowId')
			                   	//alert("index"+index+"^"+"PINLLabelDr"+rows[0].get('PHLIRowId')+"^PINLRowID"+rows[0].get('PINLRowID'))
			                  if(typeof(index) == "undefined") return; 
			                   for(i = 0; i < rows.length; i++) {  
			                        if(!this.copy) {
			                            grid.getStore().remove(rows[i]);
			                            grid.getStore().insert(index, rows[i]);  
			                            grid.view.refresh();			                         
			                            grid.getSelectionModel().selectRow(index);
			                        }
			                    }
			                    var order=""
			                    //遍历列表
							    grid.store.each(function (record) {
							        if(order.length == 0)
							            order = record.data.PDAIRowId;
							        else
							           order += "^"+record.data.PDAIRowId
							    });
							// alert(order)
								Ext.Ajax.request({											
								url:DRAG_ORDER_ACTION_URL,
								method:'post', 
								params:{
									'order':order
									},
								callback:function(options,success,response){
										if(success){
							             grid.getStore().load({
											params : {
														start : 0,
														limit : pagesize_main
													}
											});
										 setTimeout(function(){
										        grid.selModel.selectRows([0,index]);
										 },300); 
							  			}
									}
								})	
							 
			                }
			            });
			        }
				}
			        
			});
	/**已选列表上移或下移操作**/
	grid.on('cellclick', function (grid, rowIndex, columnIndex, e) { 
		var upbtn = e.getTarget('.upBtn');
		var downbtn = e.getTarget('.downBtn');
		if(upbtn){
		 var record = grid.getSelectionModel().getSelected();	
	        if (record) {
	            var index = grid.store.indexOf(record); 
	          // alert("index"+index+"^"+"PINLOrderNum"+record.get('PINLOrderNum')+"^PINLRowID"+record.get('PINLRowID'))
	            if (index > 0) {
	            	var checkId=record.get('PDAIRowId')
	            	var upId=grid.getStore().getAt(index-1).get('PDAIRowId')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':upId
								},
							callback:function(options,success,response){
									if(success){	
						             grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
									 setTimeout(function(){
									        grid.selModel.selectRows([0,index-1]);
									 },300); 
						  			}
								}
					})	
	            	//alert(checkId+upId)
	               
	            }

	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
		if(downbtn){
			 var record = grid.getSelectionModel().getSelected();
	        if (record) {
	            var index = grid.store.indexOf(record);
	            if (index < grid.store.getCount() - 1) {
	            	var checkId=record.get('PDAIRowId')
	            	var downId=grid.getStore().getAt(index+1).get('PDAIRowId')
	            	Ext.Ajax.request({											
							url:ORDER_ACTION_URL,
							method:'post', 
							params:{
								'checkId':checkId,
								'changeId':downId
								},
							callback:function(options,success,response){
									if(success){
										grid.getStore().load({
										params : {
													start : 0,
													limit : pagesize_main
												}
										});
										setTimeout(function(){
									        grid.selModel.selectRows([0,index+1]);
										 },300);
						  			}
								}
					})
					             
	            }
	        } else {
	            Ext.Msg.alert('Warning', 'Please select one item!');
	        }
		}
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