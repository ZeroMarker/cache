/// 名称: 基础配置组内应用
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-谷雪萍
/// 编写日期: 2014-9-2
 Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.BDP.BDPConfigAdmin&pClassMethod=SaveData&pEntityName=web.Entity.BDP.BDPConfigAdmin";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPConfigAdmin&pClassQuery=GetList";
	//var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfigAdmin&pClassMethod=SaveData";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfigAdmin&pClassMethod=OpenData";
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPConfigAdmin&pClassMethod=DeleteData";
	var BindingGroup = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.SSGroup&pClassQuery=GetDataForCmb1";
	var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
	var showtype//showtype是要显示的配置项类型
	var ConfigData //修改时要显示的配置项的值
	var groupDesc="" //修改时安全组配置项的显示值
	var preciousType //之前的配置项类型
	
	/***********根据配置项类型加载相应的组件************/
	var CreatUI= function(objNameType){
		switch (objNameType) {
		    case 'S':
		    var NewCom =new Ext.BDP.FunLib.Component.TextField({
					fieldLabel: '配置项值',
					name :'ConfigValue',
					id:'ConfigValue',
					xtype:'textfield',
					allowBlank:true			
			});
		    break;
		    case 'N':
		    var NewCom =new Ext.BDP.FunLib.Component.NumberField({
				fieldLabel: '配置项值',
				name :'ConfigValue',
				id:'ConfigValue',
				xtype:'numberfield',
				allowBlank:true
			});
		    break;
		    case 'D':
	    	var NewCom=new Ext.BDP.FunLib.Component.DateField({
				fieldLabel: '配置项值',
				name :'ConfigValue',
				id:'ConfigValue',
				xtype:'datefield',
				allowBlank:true,
				format : BDPDateFormat,
				regexText:"日期不能为空",
				editable:false,
				enableKeyEvents : true,
				listeners : {   
					'keyup' : function(field, e)
						{	
							Ext.BDP.FunLib.Component.GetCurrentDate(field,e);
								
						}}			
				});
	        break;
	  		case 'H': 
			var NewCom=new Ext.form.HtmlEditor({
				fieldLabel: '配置项值',
				name :'ConfigValue',
				id:'ConfigValue',
				xtype:'htmleditor',
				allowBlank:true		
			});  
	        break;
	    	case 'R':
	    	var NewCom=new Ext.BDP.FunLib.Component.RadioGroup({
				fieldLabel: '配置项值',
	    		xtype:'fieldset',
				//xtype:'radio',
	    		defaultType:'radio',
				name :'ConfigValue',
				id:'ConfigValue',
				title:' ',
				autoHeight:true,
				defaultType:'radio',
				layout:'column', //激活、未激活呈分列式排布
				items:[{boxLabel:'Yes',name:'ConfigValue',inputValue:'Y'},
					   {boxLabel:'No',name:'ConfigValue',inputValue:'N',checked:true}]
			});
	        break;
	        case 'C':
		      	var NewCom=new Ext.BDP.FunLib.Component.Checkbox ({
		        xtype : 'checkbox',
				fieldLabel: '配置项值',
				name :'ConfigValue',
				id:'ConfigValue',
				inputValue : true?'Y':'N'
			});	 
	        break;
	        case 'CB':
	        var NewCom = new Ext.BDP.FunLib.Component.BaseComboBox({
				fieldLabel: '配置项值',
			 	name:'ConfigValue',
			 	id:'ConfigValueF',
			 	hiddenName : 'ConfigValue',
			 	mode : 'remote',
			 	/*editable:false,
			    typeAhead: true,
			    triggerAction: 'all',
			    lazyRender:true,
			    mode : 'local',
			    store: new Ext.data.ArrayStore({
			        id: 0,
			        fields: [
			            'myId',
			            'displayText'
			        ],
			        data: [[1, 'item1'], [2, 'item2']]
			    }),
			    valueField: 'myId',
			    displayField: 'displayText'*/
			 	triggerAction : 'all',// query
				forceSelection : true,
				selectOnFocus : false,
				typeAhead : true,
				queryParam : "desc",
				pageSize : Ext.BDP.FunLib.PageSize.Combo,
				minChars : 0,
				listWidth : 250,
				valueField : 'SSGRPRowId',
				displayField : 'SSGRPDesc',
				store : new Ext.data.JsonStore({
					autoLoad : true,
					url : BindingGroup,
					root : 'data',
					totalProperty : 'total',
					idProperty : 'SSGRPRowId',
					fields : ['SSGRPRowId', 'SSGRPDesc'],
					remoteSort : true,
					sortInfo : {
						field : 'SSGRPRowId',
						direction : 'ASC'
					}
				})
			});
		    break;
		}
		
		return NewCom;
	}
	
    
	/** ****删除按钮 **************/
	var btnDel = new Ext.Toolbar.Button({
					text : '删除',
					tooltip : '请选择一行后删除(Shift+D)',
					iconCls : 'icon-delete',
					id:'del_btn',
					disabled : Ext.BDP.FunLib.Component.DisableFlag('del_btn'),
					handler : DelData=function () {
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
											'id' : rows[0].get('ID')
										},
										callback : function(options, success, response) {
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
				});
				
	/**************************创建添加修改的Form表单 ***************************/
	var WinForm = new Ext.form.FormPanel({
				id : 'form-save',
				labelAlign : 'right',
				labelWidth : 110,
				title : '基本信息',
				autoScroll : true, //滚动条
				frame : true,
        		reader: new Ext.data.JsonReader({root:'list'},
                                        [{name: 'ID',mapping:'ID',type:'string'},
                                         {name: 'ConfigCode',mapping:'ConfigCode',type:'string'},
                                         {name: 'ConfigDesc',mapping:'ConfigDesc',type:'string'},
                                         {name: 'ConfigType',mapping:'ConfigType',type:'string'},
                                         {name: 'ConfigExplain',mapping:'ConfigExplain',type:'string'},
                                         {name: 'ConfigActive',mapping:'ConfigActive',type:'string'},
                                         {name: 'ConfigEdit',mapping:'ConfigEdit',type:'string'},
                                         {name: 'ConfigValue',mapping:'ConfigValue',type:'string'},
                                         {name: 'ConfigInitialvalue',mapping:'ConfigInitialvalue',type:'string'}
                                   ]),
				defaults : {
					anchor : '92%',
					border : false
				},
				defaultType : 'textfield',
				items : [{
							fieldLabel : 'ID',
							hideLabel : 'True',
							hidden : true,
							name : 'ID'
						}, {
							fieldLabel : '<font color=red>*</font>配置项代码',
							name : 'ConfigCode',
							id:'ConfigCodeF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ConfigCodeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ConfigCodeF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',  
                            validator : function(thisText){
	                            if(thisText==""){  //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPConfigAdmin";  //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名	                            
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,thisText,"");//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该代码已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						}, {
							fieldLabel : '<font color=red>*</font>配置项描述',
							name : 'ConfigDesc',
							id:'ConfigDescF',
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ConfigDescF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ConfigDescF')),
							allowBlank : false,
							enableKeyEvents : true,
							validationEvent : 'blur',
                            validator : function(thisText){
	                            if(thisText==""){ //当文本框里的内容为空的时候不用此验证
	                            	return true;
	                            }
	                            var className =  "web.DHCBL.BDP.BDPConfigAdmin"; //后台类名称
	                            var classMethod = "FormValidate"; //数据重复验证后台函数名
	                            var id="";
	                            if(win.title=='修改'){ // 如果窗口标题为"修改",则获取rowid
	                            	var _record = grid.getSelectionModel().getSelected();
	                            	var id = _record.get('ID'); //此条数据的rowid
	                            }
	                            var flag = "";
	                            var flag = tkMakeServerCall(className,classMethod,id,"",thisText);//用tkMakeServerCall函数实现与后台同步调用交互
	                            if(flag == "1"){  //当后台返回数据位"1"时转换为相应的bool值
	                             	return false;
	                             }else{
	                             	return true;
	                             }
                            },
                            invalidText : '该描述已经存在',
						    listeners : {
            			        'change' : Ext.BDP.FunLib.Component.ReturnValidResult
						    }
						},  {
							fieldLabel:'配置项说明',
							xtype : 'textfield',
							name : 'ConfigExplain',
							id:'ConfigExplain'				
						},{
							fieldLabel:'是否激活',
							xtype : 'checkbox',
							name : 'ConfigActive',
							id:'ConfigActive',
        					inputValue : true?'Y':'N',
							checked:true						
						},{
							fieldLabel:'是否可修改',
							xtype : 'checkbox',
							name : 'ConfigEdit',
							id:'ConfigEdit',
							inputValue : true?'Y':'N',
							checked:true
						},  {
							fieldLabel:'配置项初始值',
							xtype : 'textfield',
							name : 'ConfigInitialvalue',
							id:'ConfigInitialvalue'				
										
						},{
							xtype : 'combo',
							fieldLabel : '<font color=red>*</font>配置项类型',
							name : 'ConfigType',
							hiddenName:'ConfigType',
							id:'ConfigTypeF',
							editable:false,
							allowBlank : false,
							readOnly : Ext.BDP.FunLib.Component.DisableFlag('ConfigTypeF'),
   							style:Ext.BDP.FunLib.ReadonlyStyle(Ext.BDP.FunLib.Component.DisableFlag('ConfigTypeF')),
							width : 140,
							mode : 'local',
							triggerAction : 'all',// query
							blankText:'请选择',
							valueField : 'value',
							displayField : 'name',
							store:new Ext.data.SimpleStore({
								fields:['value','name'],
								data:[
									      ['S','String'],
									      ['N','Number'],
									      ['D','Date'],
									      //['H','Html'],
									      ['R','Radio'],
									      ['C','CheckBox'],
									      ['CB','Combox']
								     ]
							}),
							listeners:{
								'beforequery':function(){
									preciousType=Ext.getCmp('ConfigTypeF').getValue();
								},
								'select':ChoseValueType			
							}
						
						}]
			});
	
	/****************判断值类型的函数***************************************/

function ChoseValueType(form,action){
    var type=Ext.getCmp('ConfigTypeF').getValue();
    //选择另一类型的时候把之前类型的值清空
    if((type!="")&&(type!=preciousType)&&(ConfigData!="")&&(preciousType!=undefined)&&(preciousType!="")){
    	ConfigData=""
    }
    //移除之前加载的组件
    if (typeof(showtype)!= undefined){
    	WinForm.remove(showtype);
    }
    //按照类型选择要加载的组件并设置窗口大小
    if(type!=""){
    	showtype = CreatUI(type);
    	if(type=="H"){
    		win.setSize(680,400);
    		win.center();
    	}else{
    		win.setSize(350,400);
    		win.center();
    	}
	}
	//checkbox值的设定
	if(ConfigData!=""){
		if((type=="C")&(ConfigData=="Y")){
			ConfigData="true"
		}
		showtype.setValue(ConfigData);
	}

	WinForm.add(showtype);
	WinForm.doLayout();
	
	if ((type=="CB")&(ConfigData!="")){
		showtype.setRawValue(groupDesc);
	}
}

	var tabs = new Ext.TabPanel({
				 activeTab : 0,
				 frame : true,
				 border : false,
				 height : 200,
				 items : [WinForm]
			 });
	
	/** 增加修改时弹出窗口 */
	var win = new Ext.Window({
					title : '',
					width : 350,
					height:400,
					layout : 'fit',
					//autoHeight:true,
					plain : true,//true则主体背景透明
					modal : true,
					frame : true,
					//autoScroll : true,
					collapsible : true,
					constrain : true,
					hideCollapseTool : true,
					titleCollapse : true,
					buttonAlign : 'center',
					closeAction : 'hide',
					items : tabs,
					buttons : [{
						text : '保存',
						id:'save_btn',
						iconCls : 'icon-save',
						disabled : Ext.BDP.FunLib.Component.DisableFlag('save_btn'),
						handler : function () {			
							var hasCode=Ext.getCmp('ConfigCodeF').getValue();
							var hasDesc=Ext.getCmp('ConfigDescF').getValue();
							var hasType=Ext.getCmp('ConfigTypeF').getValue();
							if (hasCode=="") {
			    				Ext.Msg.show({ title : '提示', msg : '配置项代码不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}
			    			if (hasDesc=="") {
			    				Ext.Msg.show({ title : '提示', msg : '配置项描述不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}	
					 		if (hasType=="") {
			    				Ext.Msg.show({ title : '提示', msg : '配置项类型不能为空!', minWidth : 200, icon : Ext.Msg.ERROR, buttons : Ext.Msg.OK });
			          			return;
			    			}	
					 		
							if (win.title == "添加") {
								WinForm.form.submit({
									clientValidation : true, // 进行客户端验证
									waitMsg : '正在提交数据请稍后...',
									waitTitle : '提示',
									url : SAVE_ACTION_URL,
									method : 'POST',
									success : function(form, action) {
										if (action.result.success == 'true') {
											win.hide();
											var myrowid = action.result.id;
											// var myrowid = jsonData.id;
											Ext.Msg.show({
														title : '提示',
														msg : '添加成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																		}
																	});
														}
											});
											
										} else {
											var errorMsg = '';
											if (action.result.errorinfo) {
												errorMsg = '<br/>错误信息:' + action.result.errorinfo
											}
											Ext.Msg.show({
														title : '提示',
														msg : '添加失败!' + errorMsg,
														minWidth : 200,
														icon : Ext.Msg.ERROR,
														buttons : Ext.Msg.OK
													});
										}			
									},
									failure : function(form, action) {
										Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
									}
								})
							} else {
								Ext.MessageBox.confirm('提示', '确定要修改该条数据吗?', function(btn) {
									if (btn == 'yes') {
										WinForm.form.submit({
											clientValidation : true, // 进行客户端验证
											waitMsg : '正在提交数据请稍后...',
											waitTitle : '提示',
											url : SAVE_ACTION_URL,
											method : 'POST',
											success : function(form, action) {									
												if (action.result.success == 'true') {
													win.hide();
													var myrowid = "rowid=" + action.result.id;
													Ext.Msg.show({
														title : '提示',
														msg : '修改成功!',
														icon : Ext.Msg.INFO,
														buttons : Ext.Msg.OK,
														fn : function(btn) {
															Ext.BDP.FunLib.ReturnDataForUpdate("grid", QUERY_ACTION_URL, myrowid)
															/*grid.getStore().load({
																		params : {
																			start : 0,
																			limit : 1,
																			rowid : myrowid
																		}
																	});*/
														}
													});
												} else {
													var errorMsg = '';
													if (action.result.errorinfo) {
														errorMsg = '<br/>错误信息:' + action.result.errorinfo
													}
													Ext.Msg.show({
																title : '提示',
																msg : '修改失败!' + errorMsg,
																minWidth : 200,
																icon : Ext.Msg.ERROR,
																buttons : Ext.Msg.OK
															});
												}			
											},
											failure : function(form, action) {
												Ext.Msg.alert('提示', '异步通讯失败,请检查网络连接!');
											}
										})
									}
								}, this);
								// WinForm.getForm().reset();
							}	

						}
						
					}, {
						text : '取消',
						iconCls : 'icon-close',
						handler : function() {
							win.hide();
							WinForm.getForm().reset();
						}
					}],
					listeners : {
						"show" : function() {
							//Ext.getCmp("form-save").getForm().findField("ConfigCode").focus(true,800);
						},
						"hide" : function() {
							Ext.BDP.FunLib.Component.FromHideClearFlag(); //form隐藏时，清空之前判断重复验证的对勾、
					 		if(ConfigData!=""){
						    	ConfigData=""
					 		}
					 		groupDesc="" 
					 		if(preciousType!=""){
					 			preciousType=""
					 		}
							WinForm.remove(showtype);
							win.setSize(350,400);
						},
						"close" : function() {}
					}
				});
	/** 添加按钮 */
	var btnAddwin = new Ext.Toolbar.Button({
				text : '添加',
				tooltip : '添加一条数据(Shift+A)',
				iconCls : 'icon-add',
				id:'add_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('add_btn'),
				handler : AddData=function () {
					win.setTitle('添加');
					win.setIconClass('icon-add');
					win.show();
					WinForm.getForm().reset();
				},
				scope : this
			});
	/** 修改按钮 */
	var btnEditwin = new Ext.Toolbar.Button({
				text : '修改',
				tooltip : '请选择一行后修改(Shift+U)',
				iconCls : 'icon-update',
				id:'update_btn',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('update_btn'),
				handler : UpdateData=function () {
					if (!grid.selModel.hasSelection()) {
						Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
			        } else {
			       		var _record = grid.getSelectionModel().getSelected();
						ConfigData=_record.get('ConfigValue');
						if (_record.get('ConfigType')=="CB")
						{
							groupDesc=_record.get('ConfigValue');
							ConfigData=tkMakeServerCall("web.DHCBL.BDP.BDPConfigAdmin","GetConfigValue", _record.get('ID'));
						}
			            win.setTitle('修改');
						win.setIconClass('icon-update');
						win.show('');
						Ext.getCmp("form-save").getForm().reset();
			            Ext.getCmp("form-save").getForm().load({
			                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
			                waitMsg : '正在载入数据...',
			                success : ChoseValueType,
			                failure : function(form,action) {
			                	Ext.Msg.alert('编辑', '载入失败');
			                }
			            });
			            
			        }
				}
			});
	/** grid数据存储 */
	var ds = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({ url : QUERY_ACTION_URL }),// 调用的动作
				reader : new Ext.data.JsonReader({
							totalProperty : 'total',
							root : 'data',
							successProperty : 'success'
						}, [{
									name : 'ID',
									mapping : 'ID',
									type : 'string'
								}, {
									name : 'ConfigCode',
									mapping : 'ConfigCode',
									type : 'string'
								}, {
									name : 'ConfigDesc',
									mapping : 'ConfigDesc',
									type : 'string'
								}, {
									name : 'ConfigValue',
									mapping : 'ConfigValue',
									type : 'string'
								},{
									name : 'ConfigType',
									mapping : 'ConfigType',
									type : 'string'
								},{
									name : 'ConfigExplain',
									mapping : 'ConfigExplain',
									type : 'string'
								}, {
									name : 'ConfigActive',
									mapping : 'ConfigActive',
									type : 'string'
								},{
									name : 'ConfigEdit',
									mapping : 'ConfigEdit',
									type : 'string'
								},{
									name : 'ConfigInitialvalue',
									mapping : 'ConfigInitialvalue',
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
	/** 增删改工具条 */
	var tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			id:'tbbutton',
			items : [btnAddwin, '-', btnEditwin, '-', btnDel]
		});
	/** 搜索按钮 */
	var btnSearch = new Ext.Button({
				id : 'btnSearch',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
				iconCls : 'icon-search',
				text : '搜索',
				handler : function() {
					grid.getStore().baseParams={			
							code : Ext.getCmp("TextCode").getValue(),
							desc : Ext.getCmp("TextDesc").getValue()
					};
					grid.getStore().load({
						params : {
							start : 0,
							limit : pagesize_main
						}
					});
				}
			});
	/** 重置按钮 */
	var btnRefresh = new Ext.Button({
				id : 'btnRefresh',
				disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
				iconCls : 'icon-refresh',
				text : '重置',
				handler : function() {
					Ext.getCmp("TextCode").reset();
					Ext.getCmp("TextDesc").reset();
					grid.getStore().baseParams={};
					grid.getStore().load({
								params : {
									start : 0,
									limit : pagesize_main
								}
							});
				}
			});
					
	/** 搜索工具条 */
	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['代码', {
							xtype : 'textfield',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextCode'),
							id : 'TextCode'
						}, '-',
						'描述', {
							xtype : 'textfield',
							id : 'TextDesc',
							disabled : Ext.BDP.FunLib.Component.DisableFlag('TextDesc')
						}, '-', btnSearch, '-', btnRefresh, '->'
				],
				listeners : {
					render : function() {
						tbbutton.render(grid.tbar);
					}
				}
			});
	/** 创建grid */
	var grid = new Ext.grid.GridPanel({
				id : 'grid',
				region : 'center',
				closable : true,
				store : ds,
				trackMouseOver : true,				
				columns : [new Ext.grid.CheckboxSelectionModel(), // 单选列
						{
							header : 'ID',
							sortable : true,
							dataIndex : 'ID',
							width:90,
							hidden : true
						}, {
							header : '配置项代码',
							sortable : true,
							width:140,
							dataIndex : 'ConfigCode',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '配置项描述',
							sortable : true,
							width:140,
							dataIndex : 'ConfigDesc',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						
						}, {
							header : '配置项说明',
							sortable : true,
							width:140,
							dataIndex : 'ConfigExplain',
							renderer : Ext.BDP.FunLib.Component.GirdTipShow
						}, {
							header : '是否激活',
							sortable : true,
							width:90,
							dataIndex : 'ConfigActive',
							renderer:function(value){
								if(value=="Y"){
									value="Yes"
									return "<span style='color:black;<font size=15>;'>"+value+"</span>";
								}
								else{
									value="No"
									return "<span style='color:black;<font size=15>;'>"+value+"</span>";
								}
							}
						}, {
							header : '是否可修改',
							sortable : true,
							width:90,
							dataIndex : 'ConfigEdit',
							renderer:function(value){
								if(value=="Y"){
									value="Yes"
									return "<span style='color:black;<font size=15>;'>"+value+"</span>";
								}
								else{
									value="No"
									return "<span style='color:black;<font size=15>;'>"+value+"</span>";
								}
							}
						}, {
							header : '配置项初始值',
							sortable : true,
							width:90,
							dataIndex : 'ConfigInitialvalue'
							
						
						}, {
							header : '配置项类型',
							sortable : true,
							width:120,
							dataIndex : 'ConfigType',
							renderer:function(value)
            				{
			            		if (value=="S")
			            		{
			            		   return "String"
			            		}
			            		if (value=="N")
			            		{
			            		   return "Number";
			            		}
			            		if (value=="D")
			            		{
			            		   return "Date";
			            		}
			            		if (value=="H")
			            		{            		  
			            		   return "Html";
			            		}
			            		if (value=="R")
			            		{
			            		   return "Radio";
			            		}
			            		if (value=="C")
			            		{
			            		   return "CheckBox";
			            		}
			            		if (value=="CB")
			            		{
			            		   return "Combox";
			            		}
			            	}
						}, {
							header : '配置项值',
							sortable : true,
							width:90,
							dataIndex : 'ConfigValue'
							
						
						}],
				stripeRows : true,
				//stateful : true,// 记录表格状态
				viewConfig : {
					forceFit : true
				},
				columnLines : true, //在列分隔处显示分隔符
				sm : new Ext.grid.RowSelectionModel({singleSelect:true}), // 按"Ctrl+鼠标左键"也只能单选
				bbar : paging,
				tbar : tb,
				//tools:Ext.BDP.FunLib.Component.HelpMsg,
				stateId : 'grid'
			});
	/** grid双击事件 */
	grid.on("rowdblclick", function(grid, rowIndex, e) {	
				var _record = grid.getSelectionModel().getSelected();
			    ConfigData=_record.get('ConfigValue');
	    		if (_record.get('ConfigType')=="CB")
				{
					groupDesc=_record.get('ConfigValue');
					ConfigData=tkMakeServerCall("web.DHCBL.BDP.BDPConfigAdmin","GetConfigValue", _record.get('ID'));
				}
			    //alert(ConfigData)
				if (!_record) {
		            Ext.Msg.show({
							title : '提示',
							msg : '请选择需要修改的行!',
							icon : Ext.Msg.WARNING,
							buttons : Ext.Msg.OK
						});
		        } else {
		            win.setTitle('修改');
					win.setIconClass('icon-update');
					win.show('');
					Ext.getCmp("form-save").getForm().reset();
		            Ext.getCmp("form-save").getForm().load({
		                url : OPEN_ACTION_URL + '&id=' + _record.get('ID'),
		                success : ChoseValueType,
		                failure : function(form,action) {
		                	Ext.Msg.alert('编辑', '载入失败');
		                }
		            });
	
		        }
		
	});

	/** 布局 */
	var viewport = new Ext.Viewport({
				layout : 'border',
				items : [grid]
			});
			
	/** 调用keymap */

    Ext.BDP.FunLib.Component.KeyMap(AddData,UpdateData,DelData);

    
});
 
