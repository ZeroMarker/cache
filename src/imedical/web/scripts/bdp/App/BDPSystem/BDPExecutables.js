 /**
 * @Title: 'Ext功能大表'维护
 * @Description:'Ext功能大表'，包含增删改查的功能
 * @Created on 2012-12-5 sunfengchao
 * 2014-8-14 modify by sunfengchao
 */
 
 Ext.onReady(function() {
    
	/**--------------调用后台数据用到的类方法的URL-------------------*/
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	var ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExecutables&pClassQuery=GetList";
	var SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExecutables&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPExecutables";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPExecutables&pClassMethod=DeleteData";
	
	var CHILD_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExtExecItem&pClassQuery=GetList";
	var CHILD_SAVE_ACTION_URL_New = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPExtExecItem&pClassMethod=SaveEntity&pEntityName=web.Entity.BDP.BDPExtExecItem";
	var CHILD_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPExtExecItem&pClassMethod=DeleteData";
	
	Ext.QuickTips.init();												   
	Ext.form.Field.prototype.msgTarget = 'qtip';                         
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	Ext.BDP.FunLib.TableName="BDPExecutables"
	/*********************************在删除按钮下实现删除功能**********************************************/
	var btnDel = new Ext.Toolbar.Button({                                   
			text : '删除',													   
			id:'delete-btn',
			tooltip : '删除',												   
			iconCls : 'icon-delete',										   
			disabled:Ext.BDP.FunLib.Component.DisableFlag('delete-btn'),
			handler : function() {											  
			if (grid.selModel.hasSelection()) {                           
				var gsm = grid.getSelectionModel();				  
				var rows = gsm.getSelections();
				if(rows[0].get('ID')==""||typeof(rows[0].get('ID'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
						return;
				}
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                 
						var gsm = grid.getSelectionModel();				  
						var rows = gsm.getSelections();					  
						Ext.Ajax.request({	                              	
								url : DELETE_ACTION_URL,					 
								method : 'POST',                              
								params : {									 
									'id' : rows[0].get('ID')          
								},
								callback : function(options, success, response) {
										
										Ext.MessageBox.hide();
										if (success) {				              								
											var jsonData = Ext.util.JSON.decode(response.responseText); 
											if (jsonData.success == 'true') {
											Ext.Msg.show({
															title : '提示',
															msg : '数据删除成功!',
															icon : Ext.Msg.INFO,           
															buttons : Ext.Msg.OK,         
															fn : function(btn) {
																var startIndex = grid.getBottomToolbar().cursor;
																var totalnum=grid.getStore().getTotalCount();
																if(totalnum==1){   
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0)  
														   {
																var pagenum=grid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}   
															}
															grid.getStore().load({
																  params : {
																				start : startIndex,
																				limit : pagesize_main
																			},
																		callback : function(records, options, success) {					
																			// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
																			clearSubWin();
																		}
																	});
															  }
														});
													} else {		 //--------如果返回的是错误的请求
														var errorMsg = '';
														if (jsonData.info) {			 
															errorMsg = '<br />错误信息:'
																	+ jsonData.info
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
																	msg : '异步通讯失败.....',
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
	
	var editor = new Ext.ux.grid.RowEditor({                            
			saveText : '更新',                                             
			cancelText : '取消',
			commitChangesText : '提交!',
			errorSummary: false,
			listeners:{
				'cancelEdit':function(grid)
				{
					 clearSubWin()
				}
			}
	});
	/// 添加一些监听
   editor.on({
    canceledit : function() {
    				var startIndex = grid.getBottomToolbar().cursor;
    				grid.getStore().load({                               
								params : {
											start : startIndex,
											limit : pagesize_main
										},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
									clearSubWin();
								}
							});
    			}
	});
	/** ****************************清空基本元素维护 *************************/
	function clearSubWin() {
			//BDEFtbbutton.setDisabled(true);
			//BDEFtb.setDisabled(true);
            Ext.getCmp("TextCode2").reset();
            Ext.getCmp("TextDesc2").reset();
            BDEFgrid.setTitle("");
            BDEFds.removeAll();
            BDEFgrid.getStore().baseParams={};
			BDEFds.load({                                    
				params : {
							start : 0,
							limit : pagesize_main,
							ParRef: ""
						}
				});
			
			BDEFgrid.disable()
            //document.getElementById('ext-comp-1033').innerHTML="没有记录",
            //document.getElementById('ext-comp-1029').innerHTML="页,共 1 页",
            //document.getElementById('ext-comp-1028').value="1"
	}
	
	/*********************************增加按钮*********************************/
	var btnAddwin = new Ext.Toolbar.Button({
			id:'btnAddwin',
			disabled : Ext.BDP.FunLib.Component.DisableFlag('btnAddwin'),
			text : '添加',
			tooltip : '添加',
			iconCls : 'icon-add',
			handler : function(thiz) {//点击触发的事件
				editor.stopEditing();
				if(ds.getCount()!=0&&ds.getAt(0).get('Code')==""){
					grid.getSelectionModel().selectRow(0);
					editor.startEditing(0);
				}else{
				var a = new BDET({	  
						Code : '', 										 
						Caption : '',
						Description : '',
						JavaScriptFile : '',
						BDAJavaScriptFile : '',
						ClassName:'',
						PropertyName:''
				});
				ds.insert(0, a); 											 
				grid.getSelectionModel().selectRow(0);
				editor.startEditing(0);
			}
		},
		scope : this												 
	});
		var BDET = Ext.data.Record.create([				        
								{	name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'Code',
									mapping : 'Code',
									type : 'string'
								}, {
									name : 'Caption',
									mapping : 'Caption',
									type : 'string'
								}, {
									name: 'Description',
									mapping:'Description',
									type:'string'
								}, {
                               	 	name: 'JavaScriptFile',
                                	mapping:'JavaScriptFile',
                               		type:'string'
                               	}, {
                               	 	name: 'BDAJavaScriptFile',
                                	mapping:'BDAJavaScriptFile',
                               		type:'string'
                               	},{
                               		name:'ClassName',
                               		mapping:'ClassName',
                               		type:'string'
                               	},{
                               		name:'PropertyName',
                               		mapping:'PropertyName',
                               		type:'string'
                               	}
                       ]);
			
     /**------将数据读取出来并转换(成record实例)，为后面的读取和修改做准备-------*/
     var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({  
					url : ACTION_URL
				}),
				reader : new Ext.data.JsonReader({  
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDET),
				listeners : {
					'cancel':function(){
					 
					},
					'update' : function(thiz, record, operation) {        
						var user = thiz.getAt(thiz.indexOf(record)).data;  
						if (typeof(user.ID) == 'undefined') {     
							user.ID = "";
						}
						if (operation == Ext.data.Record.EDIT) {           
							thiz.commitChanges();                          
							Ext.Ajax.request({                            
								url : SAVE_ACTION_URL_New,
								method : 'POST',
								params : 'ID=' + user.ID     
										+ '&Code=' + user.Code
										+ '&Caption=' + user.Caption
										+ '&Description=' + user.Description
										+ '&JavaScriptFile=' + user.JavaScriptFile
										+ '&BDAJavaScriptFile=' + user.BDAJavaScriptFile
										+ '&ClassName=' + user.ClassName
										+ '&PropertyName=' + user.PropertyName
										,
								success : function(response, opts) {
									var respText = Ext.util.JSON.decode(response.responseText);
									if(respText.success=='true'){
										thiz.commitChanges();
										grid.getStore().load({params : {												   //----------ds加载时发送的附加参数
																RowId : respText.id,
																start : 0,
																limit : pagesize_main
															},
															callback : function(records, options, success) {					
																			// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
																			clearSubWin();
																		}
														});               
										
									}else{
										var errorMsg = '';
										if (respText.errorinfo) {
											errorMsg = '<br/>错误信息:' + respText.errorinfo
										}
										Ext.Msg.show({
														title : '提示',
														msg : '保存失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										var r = grid.getSelectionModel().getSelected();
							            if(r){
							                var index = grid.store.indexOf(r);
							                editor.startEditing(index);
							            }
									}
								},
								failure : function(response, opts) {
									Ext.Msg.alert('错误', '提交数据错误!错误代码： '
													+ response.status);
									thiz.rejectChanges();     
									grid.getStore().load({params : {												  
															start : 0,
															limit : pagesize_main
														}
													});
									grid.getView().refresh();
								}
							});

						}
					}
				}
			});
		/** -------------------加载数据----------------- */
	ds.load({
				params : {												 
					start : 0,
					limit : pagesize_main
				} 
			});
			
		/**---------分页工具条-----------*/	
	var paging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : ds,											      
				displayInfo : true,										  
				emptyMsg : "没有记录"
			})
	var sm = new Ext.grid.CheckboxSelectionModel({
				singleSelect : true,
				checkOnly : false,
				width : 20
			});

	/*******************************增删改工具条*******************************/
	var tbbutton = new Ext.Toolbar({
		items : [btnAddwin, '-', btnDel]			                  
		});
	
	/********************************搜索按钮*********************************/
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {                                  
					grid.getStore().baseParams={
						    code : Ext.getCmp("TextCode").getValue(), 	
							caption : Ext.getCmp("TextCaption").getValue()
					};
					grid.getStore().load({									 
						params : {
							start : 0,
							limit : pagesize_main
						},
						callback : function(records, options, success) {					
							// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
							clearSubWin();
						}
					});
				}
			});		
	/******************************刷新按钮****************************************/
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextCaption").reset();                      
					grid.getStore().baseParams={};
					grid.getStore().load({                               
								params : {
											start : 0,
											limit : pagesize_main
										},
								callback : function(records, options, success) {					
									// Ext.Msg.alert('info', '加载完毕, success = '+records.length);
									clearSubWin();
								}
							});
                         
					}
				});		
 
	/*************************将工具条放在一起************************************/
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							id : 'TextCode',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode')
						},'-','名称', {
							xtype : 'textfield',
							id : 'TextCaption',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCaption')
						},'-', btnSearch, '-',btnRefresh, '->'],
				listeners : {                                        
					render : function() {                             
						tbbutton.render(grid.tbar)                    
					}
				}
			});
			
	/***************************************创建grid******************************************/
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				width : 600,
				split: true,
				height : 500,
				plugins: [editor],                                   
				store : ds,											 
				trackMouseOver : true,                               
				columns : [sm, {									 
							header : 'ID',
							dataIndex : 'ID',
							width : 20,
							hidden : true                           
						}, {
							header : '代码',
							dataIndex : 'Code',
							editor:{
								id:'EditorField_Code',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_Code'),
								xtype:'textfield',
								allowBlank:false
							}
						}, {
							header : '名称',
							dataIndex : 'Caption',
							editor:{
								id:'EditorField_Caption',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_Caption'),
								xtype: 'textfield',
								allowBlank : false
							}
						}, {
							header : '功能描述',
							dataIndex : 'Description',
							editor:{
								id:'EditorField_Description',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_Description'),
								xtype: 'textfield'
							}
						}, {
							header : 'Js路径及文件名',
							dataIndex : 'JavaScriptFile',
							editor:{
								id:'EditorField_JavaScriptFile',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_JavaScriptFile'),
								xtype: 'textfield'
							}
						}, {
							header : '基础数据授权JS路径',
							dataIndex : 'BDAJavaScriptFile',
							editor:{
								id:'EditorField_BDAJavaScriptFile',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDAJavaScriptFile'),
								xtype: 'textfield'
							}
						 },{
							header:'实体类名',
							dataIndex:'ClassName',
							editor:{
							 	id:'EditorField_ClassName',
							 	disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_ClassName'),
							 	xtype:'textfield'
							}
						},{
							header:'显示字段名',
							dataIndex:'PropertyName',
							editor:{
								id:'EditorField_PropertyName',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_PropertyName'),
								xtype:'textfield'
							}
						}],
				stripeRows : true,                                
				title : 'BDP功能大表维护',
				stateful : true,                                   
				viewConfig : {									  
					forceFit : true								   
				},
				bbar : paging,                                    
				tbar : tb,                                        
				stateId : 'grid'
			});
    /*******************************定义Grid的行单击事件**************************/
		grid.on("rowclick", function(grid, rowIndex, e) {        
				if(ds.getAt(0).get('Code')==""){
					ds.removeAt(0);
					if(0==rowIndex) return;
				}
				var _record = grid.getSelectionModel().getSelected();
				Ext.getCmp("TextCode2").reset();
				Ext.getCmp("TextDesc2").reset();
				BDEFgrid.getStore().baseParams={};
				BDEFds.load({                                    
					params : {
								start : 0,
								limit : pagesize_main,
								ParRef : _record.get('ID')
							}
					});
				BDEFgrid.expand();
			});
			
	/*****************************以下为子表部分*******************************************************/
	var BDEFbtnDel = new Ext.Toolbar.Button({                               
			text : '删除',													  
			id:'BDEF-delete-btn',
			tooltip : '删除',												 
			iconCls : 'icon-delete',										 
			disabled:true,
			handler : function() {											 
			if (BDEFgrid.selModel.hasSelection()) {                           
				var gsm = BDEFgrid.getSelectionModel();				 
				var rows = gsm.getSelections();
				if(rows[0].get('BDEFRowId')==""||typeof(rows[0].get('BDEFRowId'))=="undefined"){
					Ext.Msg.show({
									title : '提示',
									msg : '没有要删除的数据!',
									minWidth : 200,
									icon : Ext.Msg.ERROR,
									buttons : Ext.Msg.OK
								});
					return;
				}
				 
				Ext.MessageBox.confirm('提示', '确定要删除所选的数据吗?', function(btn) {
					if (btn == 'yes') {                                   
						Ext.MessageBox.wait('数据删除中,请稍候...', '提示');  
						var gsm = BDEFgrid.getSelectionModel();				  
						var rows = gsm.getSelections();					 
						
						Ext.Ajax.request({	                              	
							url : CHILD_DELETE_ACTION_URL,					  
							method : 'POST',                              
							params : {								 
								'id' : rows[0].get('BDEFRowId')          
							},
							callback : function(options, success, response) {
								Ext.MessageBox.hide();
								if (success) {				              							
									var jsonData = Ext.util.JSON		  
											.decode(response.responseText); 
									if (jsonData.success == 'true') {
										Ext.Msg.show({
														title : '提示',
														msg : '数据删除成功!',
														icon : Ext.Msg.INFO,           
														buttons : Ext.Msg.OK,          
														fn : function(btn) {
															var startIndex = BDEFgrid.getBottomToolbar().cursor;
															var totalnum=BDEFgrid.getStore().getTotalCount();
															if(totalnum==1){    
																var startIndex=0
															}
															else if((totalnum-1)%pagesize_main==0) 
															{
																var pagenum=BDEFgrid.getStore().getCount();
																if (pagenum==1){ startIndex=startIndex-pagesize_main;}  
															}
															BDEFgrid.getStore().load({
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
													errorMsg = '<br />错误信息:'
															+ jsonData.info
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
																msg : '异步通讯失败.....',
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
	
	/************************************增加按钮****************************************/
	var BDEFbtnAddwin = new Ext.Toolbar.Button({
				id:'BDEF-Add-Btn',
				text : '添加',
				tooltip : '添加',
				iconCls : 'icon-add',
				disabled:true,
				handler : function(thiz) { 
					BDEFeditor.stopEditing();
					if(BDEFds.getCount()!=0&&BDEFds.getAt(0).get('BDEFCode')==""){
						BDEFgrid.getSelectionModel().selectRow(0);
						BDEFeditor.startEditing(0);
					}else{
						if (grid.selModel.hasSelection()) {	
							var record1 = grid.getSelectionModel().getSelected();
							var b = new BDEF({  
								BDEFBDETParRef : record1.get('ID'),
								BDEFRowId : '',
								BDEFCode : '',
								BDEFName : '',
								BDEFAllowBlank:'',
								BDEFAutoShow:'',
								BDEFEditable:'',
								BDEFHandler:'',
								BDEFReadOnly:'',
								BDEFRegex:'',
								BDEFRegexText:'',
								BDEFToolTip:'',
							    BDEFToolTipType:'',
								BDEFType:'',
								BDEFValidator:'',
								BDEFValueGet:'',
								BDEFXType:'',
								BDEFValueSet:'',
								BDEFHidden:'',
								BDEFHiddenName:'',
								BDEFIconCls:''
							});
							BDEFds.insert(0, b); 
							BDEFgrid.getSelectionModel().selectRow(0);
							BDEFeditor.startEditing(0);
						}
						else
						{
							Ext.Msg.show({
								title : '提示',
								msg : '请选择父表记录！',
								icon : Ext.Msg.WARNING,
								buttons : Ext.Msg.OK
							});
							
							
						}
					}
				},
				scope : this									 
			});
	var BDEF = Ext.data.Record.create([											 
					{	name : 'BDEFBDETParRef',
						mapping : 'BDEFBDETParRef',
						type : 'string'
					},{	name : 'BDEFRowId',
						mapping : 'BDEFRowId',
						type : 'string'
					}, {
						name : 'BDEFCode',
						mapping : 'BDEFCode',
						type : 'string'
					}, {
						name : 'BDEFName',
						mapping : 'BDEFName',
						type : 'string'
					} ,{
						name : 'BDEFAllowBlank',
						mapping : 'BDEFAllowBlank',
						type : 'string'
					}, {
						name : 'BDEFAutoShow',
						mapping : 'BDEFAutoShow',
						type : 'string'
					}, {
						name : 'BDEFEditable',
						mapping : 'BDEFEditable',
						type : 'string'
					}, {
						name : 'BDEFHandler',
						mapping : 'BDEFHandler',
						type : 'string'
					}, {
						name : 'BDEFHidden',
						mapping : 'BDEFHidden',
						type : 'string'
					}, {
						name : 'BDEFHiddenName',
						mapping : 'BDEFHiddenName',
						type : 'string'
					}, {
						name : 'BDEFIconCls',
						mapping : 'BDEFIconCls',
						type : 'string'
					}, {
						name : 'BDEFReadOnly',
						mapping : 'BDEFReadOnly',
						type : 'string'
					}, {
						name : 'BDEFRegex',
						mapping : 'BDEFRegex',
						type : 'string'
					}, {
						name : 'BDEFRegexText',
						mapping : 'BDEFRegexText',
						type : 'string'
					}, {
						name : 'BDEFToolTip',
						mapping : 'BDEFToolTip',
						type : 'string'
					}, {
						name : 'BDEFToolTipType',
						mapping : 'BDEFToolTipType',
						type : 'string'
					}, {
						name : 'BDEFType',
						mapping : 'BDEFType',
						type : 'string'
					}, {
						name : 'BDEFValidator',
						mapping : 'BDEFValidator',
						type : 'string'
					}, {
						name : 'BDEFValueGet',
						mapping : 'BDEFValueGet',
						type : 'string'
					}, {
						name : 'BDEFXType',
						mapping : 'BDEFXType',
						type : 'string'
					}, {
						name : 'BDEFValueSet',
						mapping : 'BDEFValueSet',
						type : 'string'
					}]);

     /*************************将数据读取出来并转换(成record实例)，为后面的读取和修改做准备********************/
	var BDEFds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({  
					url : CHILD_ACTION_URL
				}),
				reader : new Ext.data.JsonReader({  
					totalProperty : 'total',
					root : 'data',
					successProperty : 'success'
				}, BDEF),
				listeners : {// 对数据集进行监听
					'update' : function(thiz, record, operation) { 
						var user = thiz.getAt(thiz.indexOf(record)).data;  
						if (operation == Ext.data.Record.EDIT) {  
							thiz.commitChanges();  
							Ext.Ajax.request({  
								url : CHILD_SAVE_ACTION_URL_New,
								method : 'POST',
								params : 'BDEFBDETParRef=' + user.BDEFBDETParRef
										+ '&BDEFRowId=' + user.BDEFRowId
										+ '&BDEFCode=' + user.BDEFCode
										+ '&BDEFName=' + user.BDEFName
										+ '&BDEFAllowBlank=' + user.BDEFAllowBlank
										+ '&BDEFAutoShow=' + user.BDEFAutoShow
										+ '&BDEFEditable=' + user.BDEFEditable
										+ '&BDEFHandler=' + user.BDEFHandler
										+ '&BDEFReadOnly=' + user.BDEFReadOnly
										+ '&BDEFRegex=' + user.BDEFRegex
										+ '&BDEFRegexText=' + user.BDEFRegexText
										+ '&BDEFToolTip=' + user.BDEFToolTip
										+ '&BDEFToolTipType=' + user.BDEFToolTipType
										+ '&BDEFType=' + user.BDEFType
										+ '&BDEFValidator=' + user.BDEFValidator
										+ '&BDEFValueGet=' + user.BDEFValueGet
										+ '&BDEFXType=' + user.BDEFXType
										+ '&BDEFValueSet=' + user.BDEFValueSet
										+ '&BDEFHidden=' + user.BDEFHidden
										+ '&BDEFHiddenName=' + user.BDEFHiddenName
										+ '&BDEFIconCls=' + user.BDEFIconCls,
								success : function(response, opts) {
									var Child_respText = Ext.util.JSON.decode(response.responseText);
									if(Child_respText.success=='true'){
										var startIndex = BDEFgrid.getBottomToolbar().cursor;
										BDEFgrid.getStore().load({
												params : {
													//RowId : Child_respText.id,
													start :startIndex,   
													limit : pagesize_main
												}
											});
										BDEFgrid.getView().refresh();
									}else{
										var errorMsg = '';
										if (Child_respText.errorinfo) {
											errorMsg = '<br/>错误信息:' + Child_respText.errorinfo
										}
										Ext.Msg.show({
											title : '提示',
											msg : '保存失败!' + errorMsg,
											minWidth : 200,
											icon : Ext.Msg.ERROR,
											buttons : Ext.Msg.OK
										});
										var r = BDEFgrid.getSelectionModel().getSelected();
							            if(r){
							                var index = BDEFgrid.store.indexOf(r);
							                BDEFeditor.startEditing(index);
							            }
									}
								},
								failure : function(response, opts) {
									Ext.Msg.alert('错误', '提交数据错误!错误代码： '
													+ response.status);
									thiz.rejectChanges(); // 请求失败,回滚本地记录:)
									var startIndex = BDEFgrid.getBottomToolbar().cursor;
									BDEFgrid.getStore().load({
												params : {
															start :startIndex,   
															limit : pagesize_main
														}
											});
									BDEFgrid.getView().refresh();
								}
							});
						}
					},
					'load' : function(thiz, record, operation) {
						//BDEFtbbutton.setDisabled(false);
						//BDEFtb.setDisabled(false);
						BDEFgrid.enable();
						Ext.getCmp('BDEFbtnSearch').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'));
						Ext.getCmp('BDEF-delete-btn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-delete-btn'));
						Ext.getCmp('BDEF-Add-Btn').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEF-Add-Btn'));
						Ext.getCmp('BDEFbtnRefresh').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'));
						Ext.getCmp('TextCode2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextCode2'));
						Ext.getCmp('TextDesc2').setDisabled(Ext.BDP.FunLib.Component.DisableFlag('TextDesc2'));
					}
				}
			});
	 
	/** ***************************加载前设置参数 ********************************/
	BDEFds.on('beforeload',function() {
			if (grid.selModel.hasSelection()) {
				var gsm = grid.getSelectionModel(); 
				var rows = gsm.getSelections(); 
				Ext.apply(BDEFds.lastOptions.params, {
			    		ParRef : rows[0].get('ID')
			   	 });
			}
		},this);		
	/******************************分页工具条**********************************/	
	var BDEFpaging = new Ext.PagingToolbar({
				pageSize : pagesize_main,
				store : BDEFds,											      
				displayInfo : true,		
				displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
				emptyMsg : "没有记录"
			});
	/**-**************************增删改工具条********************************/
	var BDEFtbbutton = new Ext.Toolbar({
		items : [BDEFbtnAddwin, '-', BDEFbtnDel]			   
			// ,'->',{text:'刷新',iconCls:'icon-arrowrefresh'}
		});
		
	var BDEFbtnSearch = new Ext.Button({
				id : 'BDEFbtnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					
					BDEFgrid.getStore().baseParams={			
							code : Ext.getCmp("TextCode2").getValue(),
							desc : Ext.getCmp("TextDesc2").getValue()
					};
					BDEFgrid.getStore().load({
						params : {
									ParRef : rows[0].get('ID'),
									start : 0,
									limit : pagesize_main
								}
						});
					}
			});
	var BDEFbtnRefresh = new Ext.Button({
				id : 'BDEFbtnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('BDEFbtnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					var gsm = grid.getSelectionModel();// 获取选择列
					var rows = gsm.getSelections();// 根据选择列获取到所有的行
					Ext.getCmp("TextCode2").reset();
					Ext.getCmp("TextDesc2").reset();
					BDEFgrid.getStore().baseParams={};
					BDEFgrid.getStore().load({
								params : {
											ParRef : rows[0].get('ID'),
											start : 0,
											limit : pagesize_main
										}
									});
							}
			});
		
	/*****************************将工具条放在一起*********************/
	var BDEFtb = new Ext.Toolbar({
				id : 'BDEFtbtb',
				disabled : true,
				items : ['代码', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode2'),
							id : 'TextCode2'
						}, '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc2',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc2')
						}, '-', BDEFbtnSearch, '-', BDEFbtnRefresh, '->'
				],
				listeners : {                                       
					render : function() {                            
						BDEFtbbutton.render(BDEFgrid.tbar)                   
					}
				}
			});
			
	var BDEFeditor = new Ext.ux.grid.RowEditor({ 
			saveText : '更新',
			cancelText : '取消',
			commitChangesText : '提交!',
			errorSummary: false
	});
	
	BDEFeditor.on({
    canceledit : function() {
        			var startIndex = BDEFgrid.getBottomToolbar().cursor; 
					BDEFgrid.getStore().load({                               
								params : {
											start : startIndex,
											limit : pagesize_main
										}
							})
    				}
		});
	
	
	// 标志位判断数据源
	var flag = [['Y','是'], ['N','否']];
	var flagstore = new Ext.data.SimpleStore({
			fields : ['value','display'],
			data : flag
		});
	
	var XTypeData = [  
	                 ['button','button'], 
	                 ['progress','progress'],
	                 ['colorpalette','colorpalette'],
	                 ['datepicker','datepicker'],
	                 ['checkbox','checkbox'],
	                 ['combo','combo'],
	                 ['datefield','datefield'],
	                 ['timefield','timefield'],
	                 ['field','field'],
	                 ['displayfield','displayfield'],
	                 ['fieldset','fieldset'],
	                 ['hidden','hidden'],
	                 ['htmleditor','htmleditor'],
	                 ['label','label'],
	                 ['numberfield','numberfield'],
	                 ['radio','radio'],
	                 ['textarea','textarea'],
	                 ['textfield','textfield'],
	                 ['trigger','trigger'],
	                 ['checkboxgroup','checkboxgroup'],
	                 ['radiogroup','radiogroup']
	                 ];
	var XTypestore = new Ext.data.SimpleStore({
			fields : ['value','display'],
			data : XTypeData
		});
	                 
	/*****************************创建grid**************************/
	var BDEFgrid = new Ext.grid.GridPanel({
				id : 'BDEFgrid',
				region : 'south',
				width : 500,
				split: true,
				height : 300,
				collapsible: true,
				plugins: [BDEFeditor],
				store : BDEFds,											 
				trackMouseOver : true,                              
				columns : [sm, {									 
							header : 'BDEF_RowId',
							dataIndex : 'BDEFRowId',
							width : 80,
							hidden : true                           
						}, {
							header : '父表rowid',
							dataIndex : 'BDEFBDETParRef',
							hidden : true 
						}, {
							header : '代码',
							dataIndex : 'BDEFCode',
							editor:{
								id:'EditorField_BDEFCode',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFCode'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '名称',
							dataIndex : 'BDEFName',
							editor:{
								id:'EditorField_BDEFName',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFName'),
								xtype: 'textfield',
								allowBlank : false
							}
						},{
							header : '按钮类型',
							dataIndex : 'BDEFType',
							editor:{
								id:'EditorField_BDEFType',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFType'),
								xtype: 'textfield'
							}
						},{
							header : 'XType',
							dataIndex : 'BDEFXType',
							editor : new Ext.form.ComboBox({ 
									id:'EditorField_BDEFXType',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFXType'),
									emptyText : '请选择...',
									typeAhead : true, 
									triggerAction : 'all',
									store : XTypestore, 
									forceSelection : true,
									displayField : 'display', 
									valueField : 'value', 
									mode : 'local',  
									lazyRender : true  
							})
						} ,{
							header : '是否只读',
							dataIndex : 'BDEFReadOnly',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({  
									id:'EditorField_BDEFReadOnly',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFReadOnly'),
									emptyText : '请选择...',
									typeAhead : true, 
									triggerAction : 'all',
									forceSelection : true,
									store : flagstore,   
									displayField : 'display',   
									valueField : 'value',   
									mode : 'local',     
									lazyRender : true     
							})
						},{
							header : '是否为空',
							dataIndex : 'BDEFAllowBlank',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({    
									id:'EditorField_BDEFAllowBlank',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFAllowBlank'),
									emptyText : '请选择...',
									typeAhead : true,    
									triggerAction : 'all',
									store : flagstore,    
									forceSelection : true,
									displayField : 'display',     
									valueField : 'value',      
									mode : 'local',      
									lazyRender : true   
							})
						},{
							header : '是否隐藏',
							dataIndex : 'BDEFHidden',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({   
									id:'EditorField_BDEFHidden',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFHidden'),
									emptyText : '请选择...',
									typeAhead : true,     
									triggerAction : 'all',
									forceSelection : true,
									store : flagstore,          
									displayField : 'display',      
									valueField : 'value',      
									mode : 'local',             
									lazyRender : true       
							})
						},{
							header : '是否可编辑',
							dataIndex : 'BDEFEditable',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({      
									id:'EditorField_BDEFEditable',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFEditable'),
									emptyText : '请选择...',
									typeAhead : true,      
									triggerAction : 'all',
									forceSelection : true,
									store : flagstore,      
									displayField : 'display',    
									valueField : 'value',     
									mode : 'local',      
									lazyRender : true      
							})
						},{
							header : '是否自动显示',
							dataIndex : 'BDEFAutoShow',
							renderer:Ext.BDP.FunLib.Component.ReturnFlagIcon,
							editor : new Ext.form.ComboBox({     
									id:'EditorField_BDEFAutoShow',
									disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFAutoShow'),
									emptyText : '请选择...',
									typeAhead : true,      
									triggerAction : 'all',
									forceSelection : true,
									store : flagstore,      
									displayField : 'display',   
									valueField : 'value',   
									mode : 'local',     
									lazyRender : true   
							})
						},{
							header : '提示信息',
							dataIndex : 'BDEFToolTip',
							editor:{
								id:'EditorField_BDEFToolTip',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFToolTip'),
								xtype: 'textfield'
							}
						},{
							header : '提示信息类型',
							dataIndex : 'BDEFToolTipType',
							editor:{
								id:'EditorField_BDEFToolTipType',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFToolTipType'),
								xtype: 'textfield'
							}
						},{
							header : '图标',
							dataIndex : 'BDEFIconCls',
							editor:{
								id:'EditorField_BDEFIconCls',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFIconCls'),
								xtype: 'textfield'
							}
						},{
							header : '函数',
							dataIndex : 'BDEFHandler',
							editor:{
								id:'EditorField_BDEFHandler',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFHandler'),
								xtype: 'textfield'
							}
						},{
							header : '校验函数',
							dataIndex : 'BDEFValidator',
							editor:{
								id:'EditorField_BDEFValidator',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFValidator'),
								xtype: 'textfield'
							}
						},{
							header : 'HiddenName',
							dataIndex : 'BDEFHiddenName',
							editor:{
								id:'EditorField_BDEFHiddenName',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFHiddenName'),
								xtype: 'textfield'
							}
						},{
							header : '正则表达式',
							dataIndex : 'BDEFRegex',
							editor:{
								id:'EditorField_BDEFRegex',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFRegex'),
								xtype: 'textfield'
							}
						},{
							header : '错误文本',
							dataIndex : 'BDEFRegexText',
							editor:{
								id:'EditorField_BDEFRegexText',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFRegexText'),
								xtype: 'textfield'
							}
						},{
							header : 'SetValue',
							dataIndex : 'BDEFValueSet',
							editor:{
								id:'EditorField_BDEFValueSet',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFValueSet'),
								xtype: 'textfield'
							}
						},{
							header : 'GetValue',
							dataIndex : 'BDEFValueGet',
							editor:{
								id:'EditorField_BDEFValueGet',
								disabled:Ext.BDP.FunLib.Component.DisableFlag('EditorField_BDEFValueGet'),
								xtype: 'textfield'
							}
						}],
				stripeRows : true,                               
				title : '基本元素维护',
				// config options for stateful behavior
				stateful : true,                                  
				bbar : BDEFpaging,                                   
				tbar : BDEFtb,                                         
				stateId : 'BDEFgrid'
			});		
	BDEFgrid.on('rowclick',function(Grid,index,e){
		if(BDEFds.getAt(0).get('BDEFCode')==""){
			BDEFds.removeAt(0);
			if(0==index) return;
		}
	});
	Ext.BDP.FunLib.Component.KeyMap(); 	 		
	/*****************************创建viewport*************************************/
	var viewport = new Ext.Viewport({
		layout : 'border',
		items : [grid,BDEFgrid]
	});
});